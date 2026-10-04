"""REPLAYED source-copy tests for the narrow closed optional finding-ID repair.

Every checkout, authority and reviewer event is synthetic. These tests use only
temporary checkouts and TEST_TAG; they never invoke a reviewer or real session.
"""
import copy
import json
import unittest
from unittest.mock import patch

import test_project_workflow as fixtures


class FindingIdentityTests(fixtures.ProjectWorkflowTests):
    old_id = "pfr-finding:fixture-reused-optional"
    new_id = "pfr-finding:fixture-second-optional"
    reserved_id = "pfr-finding:fixture-reserved"
    old_claim = "Synthetic S01 optional suggestion about the first fixture."
    new_claim = "Synthetic S02 optional suggestion about a different fixture."
    repair_paths = {
        "tools/pfr_review/core/workflow.py",
        "tools/pfr_review/project.py",
        "tools/pfr_review/cli.py",
        "tools/pfr_review/tests/test_finding_identity.py",
        "tools/pfr_review/README.md",
        "docs/review-protocol.md",
        "docs/review-operations.md",
    }

    def finding(self, identifier=None, claim=None, material=False):
        return {"id": identifier or self.old_id, "label": "Synthetic optional suggestion",
                "material": material, "claim": claim or self.new_claim,
                "severity": "LOW", "confidence": "HIGH"}

    def report_with(self, req, findings, status="SATISFIED"):
        report = json.loads(self.report(req, status))
        report["report"]["findings"] = findings
        return json.dumps(report)

    def object_bytes(self, ref):
        return self.w.fs.read("durable/objects/" + ref + ".json")

    def journal_stamp(self):
        return (self.w.fs.read("durable/projection.json"),
                tuple(sorted(path.name for path in (self.w.fs.root / "durable/events").iterdir())))

    def collision(self, *, same_claim=False, incoming_material=False,
                  historical_material=False, historical_status="RESOLVED",
                  reserve=False, current_reserve=False, status="SATISFIED",
                  active_old=False):
        self.session()
        ev1, req1 = self.prepared("identity-first")
        findings1 = [self.finding(claim=self.old_claim, material=historical_material)]
        if reserve:
            findings1.append(self.finding(self.reserved_id, "Synthetic reserved historical claim."))
        raw1 = self.report_with(req1, findings1)
        capture1 = self.deliver(req1, raw1)["capture"]
        self.w.reconcile_report()
        for finding in findings1:
            self.w.disposition(finding["id"], historical_status,
                               "Synthetic disposition of the first-step suggestion.",
                               [ev1] if historical_status == "RESOLVED" else [])
        self.final_ready(ev1)
        closure1 = self.w.project_closure()["closure"]
        history1 = self.state()["finding_registry"][self.old_id]
        if active_old:
            self.assertEqual(self.next("identity-second")["status"], "ACCEPTED")
            ev2 = self.ev()
            self.w.initial_validation([ev2])
            self.w.self_review([self.finding(claim=self.old_claim)], "Synthetic active historical finding.")
            self.w.reassess({self.old_id: "Synthetic current reassessment retains the historical claim."})
            self.w.disposition(self.old_id, "RESOLVED", "Synthetic re-resolution.", [ev2])
            req2 = self.w.prepare_review(f"pfr-review:{self.chunk}:execution:identity-second", [ev2])
        else:
            ev2, req2 = self.prepared("identity-second")
        findings2 = [self.finding(claim=self.old_claim if same_claim else self.new_claim,
                                  material=incoming_material)]
        if current_reserve:
            findings2.append(self.finding(self.reserved_id, "Synthetic reserved current claim."))
        raw2 = self.report_with(req2, findings2, status)
        capture2 = self.deliver(req2, raw2)["capture"]
        preserved = {ref: self.object_bytes(ref) for ref in (capture1, capture2, closure1, history1)}
        return {"ev": ev2, "request": req2, "raw1": raw1, "raw2": raw2,
                "capture1": capture1, "capture": capture2, "closure1": closure1,
                "history1": history1, "preserved": preserved}

    def clarification(self, case, new_id=None):
        text = ("Synthetic complete reviewer addendum: the optional S02 suggestion is distinct "
                "from S01. Assign it " + (new_id or self.new_id) + ".\n"
                "The report's remaining findings, evidence and criteria are unchanged. ")
        req = case["request"]
        return self.observation(req, event_ref="synthetic-source-copy:identity-clarification",
                                event_kind="FINDING_ID_CLARIFICATION", complete=True,
                                text_role="ORIGINAL_NOT_SUMMARY", extracted_text=text,
                                report_ref=case["capture"], source_ref=req["payload"]["source_ref"],
                                attempt=req["payload"]["attempt"],
                                original_event=json.dumps({"Message Type": "FINAL_ANSWER",
                                                           "Task name": "/root", "Sender": self.reviewer,
                                                           "Payload": text}))

    def recover(self, case, **overrides):
        args = {"report_ref": case["capture"], "old_id": self.old_id, "new_id": self.new_id,
                "clarification": self.clarification(case),
                "approval": self.auth("CORRECT_REPORT_FINDING_ID", case["capture"]),
                "rationale": "Synthetic authorized repair of distinct optional claims only."}
        args.update(overrides)
        return self.w.reconcile_report_identity(**args)

    def assert_preserved(self, case):
        for ref, original in case["preserved"].items():
            self.assertEqual(self.object_bytes(ref), original, ref)
        state = json.loads(self.w.fs.read("durable/projection.json"))["state"]
        self.assertEqual(state["finding_registry"][self.old_id], case["history1"])
        self.assertEqual(state["completed"]["PFR-C03-S01"], case["closure1"])

    def assert_refused(self, case, **overrides):
        before = self.journal_stamp()
        with self.assertRaises(fixtures.Refusal):
            self.recover(case, **overrides)
        self.assertEqual(self.journal_stamp(), before)
        self.assert_preserved(case)

    def assert_corrected(self, case):
        active = self.state()["active"]
        self.assertEqual(active["phase"], "FINDINGS_RECONCILIATION")
        self.assertEqual(active["step"], "PFR-C03-S02")
        self.assertEqual(active["report"], case["capture"])
        self.assertEqual(len(self.state()["completed"]), 1)
        self.assertNotIn(self.old_id, active["findings"])
        new = active["findings"][self.new_id]
        self.assertEqual(new["original"], self.finding(self.new_id))
        self.assertFalse(new["material"])
        self.assertEqual(new["history"][-1]["status"], "OPEN")
        reconciliation = self.w.store.get(active["reconciliations"][-1], "review_reconciliation")
        correction = self.w.store.get(reconciliation["identity_correction"],
                                      "report_finding_identity_correction")
        self.assertEqual(correction["correction_kind"], "CLOSED_OPTIONAL_FINDING_ID_COLLISION")
        self.assertEqual(correction["old_id"], self.old_id)
        self.assertEqual(correction["new_id"], self.new_id)
        self.assertEqual(correction["prior_finding"], case["history1"])
        self.assertEqual(correction["closed_steps"], {"PFR-C03-S01": case["closure1"]})
        for key, expected in (("report", case["capture"]), ("request", case["request"]["reference"]),
                              ("source", case["request"]["payload"]["source_ref"])):
            self.assertEqual(reconciliation[key], expected)
            self.assertEqual(correction[key], expected)
        clarification = self.w.store.get(correction["clarification"], "reviewer_finding_identity_clarification")
        self.assertEqual(clarification, self.clarification(case))
        self.assertNotIn(self.old_id, clarification["extracted_text"])
        capture = self.w.store.get(case["capture"], "capture")
        self.assertEqual(capture["original_text"], case["raw2"])
        self.assertEqual(capture["parsed"]["findings"][0]["id"], self.old_id)
        self.assertEqual(correction["original_finding_sha256"], fixtures.digest(capture["parsed"]["findings"][0]))
        self.assert_preserved(case)
        return correction

    def close_corrected(self, case, *, drift=False):
        ev = self.ev() if drift else case["ev"]
        self.w.disposition(self.new_id, "RESOLVED", "Synthetic explicit S02 disposition.", [ev])
        self.w.finish_corrections()
        for criterion in self.w._criteria(self.state()):
            self.w.assess(criterion["id"], "SATISFIED", [ev], "Synthetic final criterion assessment.")
        self.w.finalize_documents("Inspected all owning source-copy documents after fixture repair.")
        self.w.prepare_final([ev], impact="BOUNDED_CORRECTION" if drift else "NO_SEMANTIC_CHANGE",
                             rationale="Only the explicitly authorized synthetic repair files changed.")
        return self.w.project_closure()

    def test_collision_repair_preserves_originals_and_closes_two_steps(self):
        case = self.collision()
        before = self.journal_stamp()
        with self.assertRaisesRegex(fixtures.Refusal, "FINDING_ID_COLLISION"):
            self.w.reconcile_report()
        self.assertEqual(self.journal_stamp(), before)
        self.recover(case)
        correction = self.assert_corrected(case)
        self.assertEqual(correction["source_delta"], {})
        self.w = fixtures.project.load_session(self.root, self.chunk, "execution", test=True)
        self.assert_corrected(case)
        reconciliation = self.w.store.get(self.state()["active"]["reconciliations"][-1], "review_reconciliation")
        correction_ref = reconciliation["identity_correction"]
        original_get = self.w.store.get
        # Read substitution challenges reload validation without rewriting any
        # capture, content-addressed record, or journal (even in this fixture).
        for field, value in (("report", case["capture1"]), ("original_finding_sha256", "wrong-hash"),
                             ("new_id", self.reserved_id), ("source_delta", {"Case.lean": {}})):
            with self.subTest(corrupted_correction_field=field):
                changed = copy.deepcopy(correction)
                changed[field] = value

                def substituted(ref, *args, **kwargs):
                    return changed if ref == correction_ref else original_get(ref, *args, **kwargs)

                before = self.journal_stamp()
                with patch.object(self.w.store, "get", side_effect=substituted):
                    with self.assertRaises(fixtures.Refusal):
                        self.w.inspect()
                self.assertEqual(self.journal_stamp(), before)
        self.assert_preserved(case)
        self.assert_refused(case)  # No second correction or implicit next step.
        closure2 = self.close_corrected(case)
        self.assertFalse(closure2["production_acceptance"])
        self.assertFalse(closure2["next_step_started"])
        self.assertIsNone(self.state()["active"])
        self.assertEqual(len(self.state()["completed"]), 2)
        closed = self.w.store.get(closure2["closure"], "closure")
        self.assertIn(self.new_id, closed["findings"])
        self.assertNotIn(self.old_id, closed["findings"])
        self.assertEqual(closed["findings"][self.new_id]["history"][-1]["status"], "RESOLVED")
        self.assert_preserved(case)
        self.w = fixtures.project.load_session(self.root, self.chunk, "execution", test=True)
        self.assert_preserved(case)
        self.assertEqual(self.next("after-both")["status"], "NO_ELIGIBLE_STEP")

    def test_exact_repair_paths_allowed_but_normal_reconciliation_still_rejects_drift(self):
        case = self.collision()
        for path in sorted(self.repair_paths):
            self.put(path, "# Synthetic repair-only source-copy fixture.\n")
        before = self.journal_stamp()
        with self.assertRaises(fixtures.Refusal):
            self.w.reconcile_report()
        self.assertEqual(self.journal_stamp(), before)
        self.recover(case)
        correction = self.assert_corrected(case)
        self.assertEqual(set(correction["source_delta"]), self.repair_paths)
        for path, entry in correction["source_delta"].items():
            self.assertIsNone(entry["before"])
            self.assertEqual(entry["after"], fixtures.digest((self.root / path).read_bytes()))
        self.close_corrected(case, drift=True)
        self.assert_preserved(case)
        fixtures.project.load_session(self.root, self.chunk, "execution", test=True).inspect()

    def test_wrong_authority_is_atomic(self):
        case = self.collision()
        for field, value in (("action", "CONFIRM_DIAGNOSTIC_DELIVERY"), ("target", case["capture1"]),
                             ("binding", "wrong-binding"), ("actor", self.reviewer),
                             ("contract_hash", "wrong-contract")):
            with self.subTest(field=field):
                approval = self.auth("CORRECT_REPORT_FINDING_ID", case["capture"])
                approval[field] = value
                self.assert_refused(case, approval=approval)
        approval = self.auth("CORRECT_REPORT_FINDING_ID", case["capture"])
        approval["provenance"]["role"] = "assistant"
        self.assert_refused(case, approval=approval)

    def test_wrong_report_request_source_attempt_or_reviewer_is_atomic(self):
        case = self.collision()
        for field, value in (("report_ref", case["capture1"]), ("request_ref", "wrong-request"),
                             ("source_ref", "wrong-source"), ("attempt", 99),
                             ("reviewer", "/root/other-reviewer"), ("parent", "wrong-parent"),
                             ("event_kind", "FULL_REPORT"), ("complete", False),
                             ("text_role", "SUMMARY")):
            with self.subTest(field=field):
                clarification = self.clarification(case)
                clarification[field] = value
                self.assert_refused(case, clarification=clarification)
        self.assert_refused(case, report_ref=case["capture1"])
        self.assert_refused(case, report_ref="missing-report")
        self.assert_refused(case, rationale=" ")

    def test_clarification_native_envelope_and_complete_new_id_are_required(self):
        case = self.collision()
        for field, value in (("Message Type", "MESSAGE"), ("Task name", "/root/other-parent"),
                             ("Sender", "/root/other-reviewer"), ("Payload", "Summary only")):
            with self.subTest(field=field):
                clarification = self.clarification(case)
                event = json.loads(clarification["original_event"])
                event[field] = value
                clarification["original_event"] = json.dumps(event)
                self.assert_refused(case, clarification=clarification)
        for text in ("", "Synthetic clarification without the corrected ID."):
            clarification = self.clarification(case)
            event = json.loads(clarification["original_event"])
            event["Payload"] = text
            clarification.update(extracted_text=text, original_event=json.dumps(event))
            self.assert_refused(case, clarification=clarification)
        for target in ("pfr-finding:", self.new_id[:-3]):
            self.assert_refused(case, new_id=target)
        clarification = self.clarification(case)
        text = clarification["extracted_text"] + " Another candidate is " + self.reserved_id + "."
        event = json.loads(clarification["original_event"])
        event["Payload"] = text
        clarification.update(extracted_text=text, original_event=json.dumps(event))
        self.assert_refused(case, clarification=clarification)

    def test_new_id_cannot_reuse_closed_or_old_finding(self):
        case = self.collision(reserve=True)
        for identifier in (self.old_id, self.reserved_id, "outside-finding-prefix"):
            with self.subTest(identifier=identifier):
                self.assert_refused(case, new_id=identifier,
                                    clarification=self.clarification(case, identifier))

    def test_new_id_cannot_reuse_current_report_finding(self):
        case = self.collision(current_reserve=True)
        self.assert_refused(case, new_id=self.reserved_id,
                            clarification=self.clarification(case, self.reserved_id))

    def test_same_claim_cannot_be_split_into_a_new_identity(self):
        self.assert_refused(self.collision(same_claim=True))

    def test_incoming_material_finding_cannot_use_optional_repair(self):
        self.assert_refused(self.collision(incoming_material=True))

    def test_historical_material_finding_cannot_use_optional_repair(self):
        self.assert_refused(self.collision(historical_material=True))

    def test_declined_historical_optional_is_not_a_resolved_collision(self):
        self.assert_refused(self.collision(historical_status="OPTIONAL_DECLINED"))

    def test_historical_id_already_active_cannot_be_reassigned(self):
        self.assert_refused(self.collision(active_old=True))

    def test_unrelated_source_plan_and_dependency_drift_are_atomic_refusals(self):
        case = self.collision()
        paths = ("Case.lean", "Extra.lean", "docs/unrelated.md", "tools/pfr_review/unapproved.py",
                 self.plan_path, "lean-toolchain", "lakefile.toml", "lake-manifest.json")
        for rel in paths:
            with self.subTest(path=rel):
                path = self.root / rel
                original = path.read_bytes() if path.exists() else None
                try:
                    if rel == "lake-manifest.json":
                        manifest = json.loads(original)
                        manifest["fixture_pin_drift"] = True
                        self.put(rel, json.dumps(manifest))
                    elif rel == "lean-toolchain":
                        self.put(rel, "leanprover/lean4:v4.33.0\n")
                    else:
                        self.put(rel, (original.decode() if original is not None else "") + "\n# Unrelated drift.\n")
                    self.assert_refused(case)
                finally:
                    if original is None:
                        path.unlink()
                    else:
                        path.write_bytes(original)

    def test_paused_and_conflicting_report_barriers_survive_repair(self):
        case = self.collision()
        self.w.control("PAUSE", self.auth("PAUSE", self.w.plan_id))
        self.assert_refused(case)
        self.w.control("RELEASE", self.auth("RELEASE", self.w.plan_id))
        different = json.loads(case["raw2"])
        different["report"]["conclusion"] = "Conflicting synthetic report payload."
        raw = json.dumps(different)
        req = case["request"]
        duplicate = self.w.receive_report(raw, self.observation(req, raw),
                                          req["payload"]["request_id"], req["payload"]["attempt"])
        self.assertEqual(duplicate["classification"], "CONFLICTING_DUPLICATE")
        self.assert_refused(case)

    def test_identity_correction_cannot_turn_a_criterion_gap_into_closure(self):
        case = self.collision(status="NOT_ESTABLISHED")
        self.recover(case)
        self.assert_corrected(case)
        before_completed = copy.deepcopy(self.state()["completed"])
        with self.assertRaisesRegex(fixtures.Refusal, "REVIEW_COVERAGE_GAP"):
            self.close_corrected(case)
        self.assertEqual(self.state()["completed"], before_completed)
        self.assert_preserved(case)


def load_tests(loader, tests, pattern):
    """Run only this module's cases, without rediscovering inherited fixtures."""
    return unittest.TestSuite(FindingIdentityTests(name) for name in sorted(FindingIdentityTests.__dict__)
                              if name.startswith("test_"))


if __name__ == "__main__":
    unittest.main()
