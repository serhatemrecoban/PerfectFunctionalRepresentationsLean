"""Bounded IR-010 controls. Only fault-named tests inject journal/projection state."""
import json
from test_workflow import FixtureCase
from safe_store import BUNDLE, Refusal, canonical, strict_json
from workflow import Workflow


class Remediation04Tests(FixtureCase):
    def rebuild(self):
        self.w = Workflow(self.fs, self.identity)

    def accepted(self, material=False):
        ev, req = self.to_pending()
        raw, env = self.report(req, ev, [self.finding(True)] if material else [],
                               "CONTRADICTED_BY_FINDING" if material else "SATISFIED")
        receipt = self.w.receive(raw, env)
        self.assertEqual(receipt["classification"], "VALID")
        return ev, req, raw, env, receipt["capture"]

    def acceptances(self):
        return [ref for ref in self.state()["records"]
                if self.w.store.get(ref).get("acceptance_kind") == "APPLICABLE_INDEPENDENT_REPORT"]

    def trace(self, name, data):
        root = BUNDLE / "evidence" / "remediation04-traces"
        root.mkdir(parents=True, exist_ok=True)
        (root / (name + ".json")).write_text(json.dumps(data, indent=2), encoding="utf-8")

    def finish(self, ev):
        self.w.finish_corrections(); self.ready(ev); self.w.close()
        self.assertEqual(self.start()["target"], "TEST-S02")

    def test_clean_accepted_report_survives_labels_pause_and_rebuild_then_same_report_continues(self):
        ev, req, raw, env, capture = self.accepted()
        original = self.acceptances()
        for label in ["SUSPENDED", "REVIEW_FAILED", "DISPATCH_UNCERTAIN", "SOURCE_DIVERGED"]:
            self.w.block(label); self.rebuild()
            self.refuse("REPORT_RECONCILIATION_REQUIRED", lambda:
                        self.w.recover(self.auth("RECOVER_RETRY", "TEST-S01"), "retry"))
            self.assertEqual(self.state()["active"]["pending"]["status"], "ACCEPTED")
        self.w.control("PAUSE", self.auth("PAUSE", "fixture-plan:v1"))
        self.refuse("AUTHORITY_PAUSED", lambda: self.w.recover(self.auth("RECOVER_CONTINUE", "TEST-S01")))
        self.w.control("RELEASE", self.auth("RELEASE", "fixture-plan:v1"))
        self.w.block("SUSPENDED"); self.rebuild()
        self.refuse("WORKFLOW_BLOCKED", self.w.reconcile_report)
        self.w.recover(self.auth("RECOVER_CONTINUE", "TEST-S01")); self.rebuild()
        a = self.state()["active"]
        self.assertEqual(a["phase"], "REPORT_CHECK")
        self.assertEqual(a["reports"], [capture]); self.assertEqual(a["reconciliations"], [])
        self.assertEqual(a["requests"], [req["reference"]]); self.assertEqual(self.acceptances(), original)
        self.w.reconcile_report()
        r = self.w.store.get(self.state()["active"]["reconciliations"][0], "review_reconciliation")
        self.assertEqual((r["report"], r["request"], r["source"]), (capture, req["reference"], req["payload"]["source_ref"]))
        self.assertEqual(self.w.store.get(capture, "capture")["original_text"], raw)
        self.finish(ev)
        self.trace("same-report-continuation", {"acceptances": original, "reconciliation": r,
                   "completed": self.state()["completed"], "next": self.state()["active"]["step"]})

    def test_material_resume_open_followup_resolution_and_required_satisfactory_review_close(self):
        ev, req, raw, env, capture = self.accepted(True)
        self.w.block("SUSPENDED"); self.rebuild()
        self.refuse("REPORT_RECONCILIATION_REQUIRED", lambda: self.w.recover(self.auth("RECOVER_RETRY", "TEST-S01"), "retry"))
        self.w.recover(self.auth("RECOVER_CONTINUE", "TEST-S01")); self.w.reconcile_report()
        f = self.finding(True)
        self.w.extra_review("Investigate F", [f["id"]], "New argument", "PRODUCTIVE", "F remains open")
        r2 = self.w.prepare_review("fixture-review-request:r04-r2", [ev], "Investigate F"); self.w.simulate_dispatch()
        self.w.receive(*self.report(r2, ev, [], "NOT_ESTABLISHED")); self.w.reconcile_report(); self.rebuild()
        self.assertEqual(self.state()["active"]["findings"][f["id"]]["history"][-1]["status"], "OPEN")
        self.w.finish_corrections(); self.ready(ev)
        self.refuse("MATERIAL_FINDING_OPEN", self.w.close)
        self.w.refresh_final("Resolve concern with evidence")
        self.w.disposition(f["id"], "RESOLVED", "Applicable fixture evidence", [ev]); self.ready(ev)
        self.refuse("REVIEW_COVERAGE_GAP", self.w.close)
        self.w.refresh_final("Obtain required satisfactory criterion assessment")
        self.w.extra_review("Check corrected argument", [f["id"]], "Satisfactory criterion evidence", "PRODUCTIVE", "Criterion remains not established")
        r3 = self.w.prepare_review("fixture-review-request:r04-r3", [ev], "Check corrected argument"); self.w.simulate_dispatch()
        self.w.receive(*self.report(r3, ev)); self.w.reconcile_report(); self.finish(ev)
        cert = self.w.store.get(self.state()["completed"]["TEST-S01"], "closure")
        self.assertEqual(len(cert["review_history"]), 3); self.assertEqual(len(cert["reconciliations"]), 3)
        self.assertEqual(cert["review_history"][0], capture)
        self.trace("material-eventual-closure", {"first_report": capture, "certificate": cert,
                   "next": self.state()["active"]["step"]})

    def test_pause_release_after_acceptance_needs_no_replacement_or_implicit_reconciliation(self):
        ev, _, _, _, capture = self.accepted()
        self.w.control("PAUSE", self.auth("PAUSE", "fixture-plan:v1"))
        self.refuse("AUTHORITY_PAUSED", self.w.reconcile_report)
        self.w.control("RELEASE", self.auth("RELEASE", "fixture-plan:v1")); self.rebuild()
        self.assertEqual(self.state()["active"]["reports"], [capture])
        self.assertEqual(self.state()["active"]["reconciliations"], [])
        self.w.reconcile_report(); self.finish(ev)

    def test_identical_duplicate_does_not_duplicate_acceptance_or_reset_reconciliation(self):
        ev, _, raw, env, capture = self.accepted()
        acceptance = self.acceptances()
        self.assertEqual(self.w.receive(raw, env)["classification"], "IDENTICAL_DUPLICATE")
        self.assertEqual(self.acceptances(), acceptance); self.assertEqual(self.state()["active"]["reconciliations"], [])
        self.w.reconcile_report(); reconciliations = self.state()["active"]["reconciliations"]
        self.assertEqual(self.w.receive(raw, env)["classification"], "IDENTICAL_DUPLICATE")
        self.rebuild(); self.assertEqual(self.acceptances(), acceptance)
        self.assertEqual(self.state()["active"]["reconciliations"], reconciliations)
        self.w.block("DISPATCH_UNCERTAIN"); self.w.recover(self.auth("RECOVER_CONTINUE", "TEST-S01"))
        self.assertEqual(self.state()["active"]["phase"], "FINDINGS_RECONCILIATION")
        self.finish(ev)
        self.assertEqual(self.w.receive(raw, env)["classification"], "IDENTICAL_DUPLICATE")
        self.assertEqual(self.acceptances(), acceptance)

    def test_deferred_capture_is_not_acceptance_until_authorized_then_same_report_resumes(self):
        ev, req = self.to_pending()
        self.w.control("PAUSE", self.auth("PAUSE", "fixture-plan:v1"))
        raw, env = self.report(req, ev)
        receipt = self.w.receive(raw, env)
        self.assertEqual(receipt["classification"], "LATE_VALID_REPORT"); self.assertEqual(self.acceptances(), [])
        self.w.control("RELEASE", self.auth("RELEASE", "fixture-plan:v1")); self.rebuild()
        self.assertEqual(self.acceptances(), [])
        self.w.recover(self.auth("RECOVER_RECONCILE", "TEST-S01"), "reconcile")
        self.w.block("SUSPENDED"); self.rebuild()
        self.refuse("REPORT_RECONCILIATION_REQUIRED", lambda: self.w.recover(self.auth("RECOVER_RETRY", "TEST-S01"), "retry"))
        self.w.recover(self.auth("RECOVER_CONTINUE", "TEST-S01")); self.w.reconcile_report()
        self.assertEqual(self.state()["active"]["reports"], [receipt["capture"]]); self.finish(ev)

    def test_invalid_and_wrong_source_inputs_do_not_become_acceptance_obligations(self):
        ev, req = self.to_pending()
        self.assertEqual(self.w.receive("malformed", {})["classification"], "BAD_ENVELOPE")
        raw, env = self.report(req, ev)
        wrong = json.loads(raw); wrong["source_ref"] = "not-the-request-source"
        self.assertNotEqual(self.w.receive(json.dumps(wrong), env)["classification"], "VALID")
        self.assertEqual(self.acceptances(), [])
        self.w.wait_event("FAILED"); self.w.recover(self.auth("RECOVER_RETRY", "TEST-S01"), "retry")
        new = self.w.prepare_review("fixture-review-request:unaccepted-retry", [ev]); self.w.simulate_dispatch()
        self.w.receive(*self.report(new, ev)); self.w.reconcile_report(); self.finish(ev)

    def test_conflict_still_blocks_same_report_continuation(self):
        _, _, raw, env, capture = self.accepted()
        self.assertEqual(self.w.receive(raw + " ", env)["classification"], "CONFLICTING_DUPLICATE")
        self.w.block("SUSPENDED"); self.rebuild()
        self.refuse("REPORT_CONFLICT_UNRESOLVED", lambda: self.w.recover(self.auth("RECOVER_CONTINUE", "TEST-S01")))
        self.assertEqual(self.state()["active"]["reports"], [capture]); self.assertFalse(self.state()["completed"])

    def test_cancel_release_does_not_reactivate_accepted_report(self):
        self.accepted()
        self.w.control("CANCEL", self.auth("CANCEL", "fixture-plan:v1"))
        self.w.control("RELEASE", self.auth("RELEASE", "fixture-plan:v1")); self.w.block("SUSPENDED"); self.rebuild()
        for mode in ["continue", "retry", "reconcile"]:
            self.refuse("REQUEST_REACTIVATION_UNSUPPORTED", lambda:
                        self.w.recover(self.auth("RECOVER_" + mode.upper(), "TEST-S01"), mode))
        self.assertEqual(len(self.acceptances()), 1); self.assertFalse(self.state()["completed"])

    def test_source_divergence_refuses_continuation_and_retains_original_until_restored(self):
        ev, _, _, _, capture = self.accepted()
        original = self.fs.read("project/src/Example.lean")
        self.fs.write("project/src/Example.lean", "def externalChange := 1\n")
        self.w.block("SUSPENDED"); self.rebuild()
        self.refuse("SOURCE_DIVERGED", lambda: self.w.recover(self.auth("RECOVER_CONTINUE", "TEST-S01")))
        self.refuse("REPORT_RECONCILIATION_REQUIRED", lambda: self.w.recover(self.auth("RECOVER_RETRY", "TEST-S01"), "retry"))
        self.assertEqual(self.state()["active"]["reports"], [capture])
        self.fs.write("project/src/Example.lean", original)
        self.w.recover(self.auth("RECOVER_CONTINUE", "TEST-S01")); self.w.reconcile_report(); self.finish(ev)

    def fault(self, mutate):
        # Explicit fixture corruption: not a supported workflow progression API.
        current = self.w.journal.load()
        def corrupt(state):
            mutate(state)
            return state
        self.w.journal.transact(current["rev"], "EXPLICIT_R04_INTEGRITY_FAULT", corrupt)
        self.rebuild()

    def test_fault_dropped_report_history_refuses_reconstruction(self):
        self.accepted()
        self.fault(lambda s: s["active"].update(reports=[], report=None))
        self.refuse("ACCEPTANCE_HISTORY_MISMATCH", self.w.inspect)
        self.assertEqual(self.start()["status"], "SKIPPED_INVALID_STATE")

    def test_fault_dropped_acceptance_record_refuses_reconstruction(self):
        self.accepted(); refs = self.acceptances()
        self.fault(lambda s: s.update(records=[r for r in s["records"] if r not in refs]))
        self.refuse("ACCEPTANCE_RECORD_MISSING", self.w.inspect)

    def test_fault_changed_current_pointer_refuses_reconstruction(self):
        self.accepted()
        self.fault(lambda s: s["active"].update(report=None))
        self.refuse("ACCEPTED_REPORT_POINTER", self.w.inspect)

    def test_fault_projection_cannot_claim_reconciliation(self):
        self.accepted()
        projection = strict_json(self.fs.read("durable/projection.json"))
        projection["state"]["active"]["reconciliations"] = ["fabricated-reconciliation"]
        self.fs.write("durable/projection.json", canonical(projection))
        self.refuse("PROJECTION_INCONSISTENT", self.w.inspect)

    def test_fault_favorable_phase_does_not_bypass_all_progress_consumers(self):
        ev, _, _, _, _ = self.accepted()
        for phase, operation in [
            ("REVIEW_READY", lambda: self.w.prepare_review("fixture-review-request:forged-ready", [ev])),
            ("REVIEW_READY", self.w.simulate_dispatch),
            ("FINAL_VALIDATION", lambda: self.w.extra_review("Cannot skip R1", [], "Evidence", "PRODUCTIVE", "Not authority")),
            ("FINAL_VALIDATION", lambda: self.w.finalize_documents("Cannot write before reconciliation")),
            ("FINAL_VALIDATION", lambda: self.w.prepare_final([ev], impact="NO_SEMANTIC_CHANGE", rationale="Not authority")),
            ("CLOSE_READY", self.w.close),
        ]:
            doc = self.fs.read("project/plan.json")
            self.fault(lambda s: s["active"].update(phase=phase, blocker=None))
            self.refuse("REPORT_RECONCILIATION_REQUIRED", operation)
            self.assertEqual(self.fs.read("project/plan.json"), doc)

    def test_fault_missing_active_pointer_does_not_erase_global_obligation(self):
        self.accepted(); self.fault(lambda s: s.update(active=None))
        result = self.start()
        self.assertEqual(result["status"], "SKIPPED_AUTHORITY")
        self.assertEqual(result["reason"], "REPORT_RECONCILIATION_REQUIRED")

    def test_fault_closure_cannot_omit_accepted_reconciliation(self):
        ev, _, _, _, _ = self.accepted()
        self.fault(lambda s: s["active"].update(phase="FINAL_VALIDATION"))
        def forged(state):
            a = state["active"]
            cert = {"tag": state["tag"], "fixture_only": True, "production_acceptance": False,
                    "step": a["step"], "F": a["R"], "review": a["report"],
                    "self_review": a["self_review"], "reassessment": a["reassessment"],
                    "documentation": self.w.store.put("documentation", {"tag": state["tag"]}),
                    "authorization": a["authorization"], "criteria": {}, "validation": [ev],
                    "review_history": a["reports"], "reconciliations": [], "findings": {},
                    "initial_handoff": a["initial_handoff"]}
            state["completed"][a["step"]] = self.w.store.put("closure", cert)
            state["active"] = None
        self.fault(forged)
        self.refuse("REPORT_RECONCILIATION_REQUIRED", self.w.inspect)
        self.assertEqual(self.start()["status"], "SKIPPED_INVALID_STATE")

    def test_fault_schema4_refused_without_migration(self):
        self.fault(lambda s: s.update(schema=4))
        self.refuse("STATE_SCHEMA", self.w.inspect)
