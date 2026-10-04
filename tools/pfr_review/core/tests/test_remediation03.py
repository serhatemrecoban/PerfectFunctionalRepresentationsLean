"""Model-free R03 invariants. Only names containing fault inject journal state."""
import copy
import json
from test_workflow import FixtureCase
from safe_store import BUNDLE, Refusal
from workflow import Workflow

QUESTION = "Check the still-open source argument"


class Remediation03Tests(FixtureCase):
    def rebuild(self):
        self.w = Workflow(self.fs, self.identity)

    def trace(self, name, value):
        target = BUNDLE / "evidence" / "remediation03-traces"
        target.mkdir(parents=True, exist_ok=True)
        (target / (name + ".json")).write_text(json.dumps(value, indent=2), encoding="utf-8")

    def blocked(self, operation):
        with self.assertRaises(Refusal):
            operation()
        self.assertFalse(self.state()["completed"])

    def escalate(self, producer="finding", correcting=False):
        f = self.finding(True)
        ev, req, raw, env = self.to_final_validation([f])
        if correcting:
            self.w.begin_corrections()
        if producer == "finding":
            self.w.disposition(f["id"], "ESCALATED", "Requires substantive lead judgment")
        elif producer in {"LEAD_DECISION_REQUIRED", "PROGRESS_DECISION_REQUIRED"}:
            self.w.block(producer)
        else:
            self.w.extra_review(QUESTION, [f["id"]], "Exact lead decision", producer, "Unresolved incompatible choices")
        return ev, f, req, raw, env

    def check_producer(self, producer):
        ev, f, _, _, _ = self.escalate(producer)
        obligations = list(self.state()["decision_obligations"])
        self.assertEqual(len(obligations), 1)
        for label in ["SUSPENDED", "REVIEW_FAILED", "DISPATCH_UNCERTAIN", "SOURCE_DIVERGED", "ordinary later stop"]:
            self.w.block(label)
            self.rebuild()
            for mode in ["continue", "retry", "reconcile"]:
                self.blocked(lambda: self.w.recover(self.auth("RECOVER_" + mode.upper(), "TEST-S01"), mode))
        self.w.control("PAUSE", self.auth("PAUSE", "fixture-plan:v1"))
        self.w.control("RELEASE", self.auth("RELEASE", "fixture-plan:v1"))
        self.rebuild()
        for status in ["RESOLVED", "REFUTED_WITH_EVIDENCE", "OPTIONAL_DECLINED", "OPTIONAL_DEFERRED", "SUPERSEDED"]:
            self.blocked(lambda: self.w.disposition(f["id"], status, "Ordinary update is not adjudication", [ev]))
        self.blocked(lambda: self.w.reassess_finding(f["id"], True, "Retain materiality", [ev]))
        self.blocked(lambda: self.w.reassess_finding(f["id"], False, "Downgrade is not discharge", [ev],
                     approval=self.auth("REASSESS_FINDING", f["id"])))
        self.assertEqual(self.state()["decision_obligations"], obligations)
        self.assertEqual(self.start()["status"], "SKIPPED_UNCLOSED")
        self.trace("producer-" + producer, {"obligations": obligations, "completed": self.state()["completed"],
                   "authority_actions": [self.w.store.get(r, "authority")["action"] for r in self.state()["authority_history"]]})

    def test_finding_obligation_survives_all_recovery_and_label_updates(self):
        self.check_producer("finding")

    def test_nonprogress_obligation_uses_shared_gate(self):
        self.check_producer("ESCALATE_NONPROGRESS")

    def test_oscillation_obligation_uses_shared_gate(self):
        self.check_producer("ESCALATE_OSCILLATION")

    def test_incompatible_obligation_uses_shared_gate(self):
        self.check_producer("ESCALATE_INCOMPATIBLE")

    def test_explicit_lead_stop_is_not_a_transient_escape(self):
        self.check_producer("LEAD_DECISION_REQUIRED")

    def test_explicit_progress_stop_is_not_a_transient_escape(self):
        self.check_producer("PROGRESS_DECISION_REQUIRED")

    def test_finding_and_round_obligations_accumulate_without_discharge(self):
        ev, f, _, _, _ = self.escalate()
        self.w.block("SUSPENDED")
        self.w.extra_review(QUESTION, [f["id"]], "Lead decision", "ESCALATE_OSCILLATION", "Second independent reason to stop")
        self.w.disposition(f["id"], "ESCALATED", "Further identified decision scope")
        self.rebuild()
        self.assertEqual(len(self.state()["decision_obligations"]), 3)
        self.assertEqual(len(self.state()["progress_escalations"]), 1)
        self.blocked(lambda: self.w.recover(self.auth("RECOVER_RETRY", "TEST-S01"), "retry"))
        self.blocked(lambda: self.w.disposition(f["id"], "RESOLVED", "No exact substantive authority", [ev]))

    def test_round_then_finding_obligations_accumulate(self):
        _, f, _, _, _ = self.escalate("ESCALATE_INCOMPATIBLE")
        self.w.disposition(f["id"], "ESCALATED", "Finding also requires lead judgment")
        self.assertEqual(len(self.state()["decision_obligations"]), 2)
        self.blocked(lambda: self.w.extra_review(QUESTION, [f["id"]], "Evidence", "PRODUCTIVE", "Cannot replace escalation"))

    def test_obligations_block_source_changes_and_finalization_before_writes(self):
        ev, f, _, _, _ = self.escalate(correcting=True)
        self.w.block("SUSPENDED")
        source = self.fs.read("project/src/Example.lean")
        doc = self.fs.read("project/plan.json")
        self.blocked(lambda: self.w.own_edit("project/src/Example.lean", "def changed := 1\n"))
        self.blocked(self.w.finish_corrections)
        self.blocked(lambda: self.w.finalize_documents("Not authorized while escalated"))
        self.blocked(lambda: self.w.prepare_final([ev], impact="NO_SEMANTIC_CHANGE", rationale="Not adjudication"))
        self.blocked(self.w.close)
        self.assertEqual(self.fs.read("project/src/Example.lean"), source)
        self.assertEqual(self.fs.read("project/plan.json"), doc)

    def test_obligation_blocks_reversal_of_own_applied_edit(self):
        f = self.finding(True)
        self.to_final_validation([f]); self.w.begin_corrections()
        ref = self.w.own_edit("project/src/Example.lean", "def fixtureValue : Nat := 8\n")
        self.w.disposition(f["id"], "ESCALATED", "Decision before further source actions")
        self.w.block("SUSPENDED")
        before = self.fs.read("project/src/Example.lean")
        self.blocked(lambda: self.w.reverse_own_edit(ref))
        self.assertEqual(self.fs.read("project/src/Example.lean"), before)

    def test_new_report_can_be_captured_but_not_accepted_under_explicit_obligation(self):
        ev, req = self.to_pending()
        self.w.block("LEAD_DECISION_REQUIRED"); self.w.block("SUSPENDED")
        raw, env = self.report(req, ev, [self.finding(True)])
        result = self.w.receive(raw, env)
        self.assertEqual(result["classification"], "LATE_VALID_REPORT")
        capture = self.w.store.get(result["capture"], "capture")
        self.assertEqual(capture["original_text"], raw)
        self.assertIn("SUBSTANTIVE_DECISION", capture["deferred_reasons"])
        self.assertIsNone(self.state()["active"]["report"])
        self.assertEqual(self.state()["active"]["findings"], {})
        self.assertEqual(self.w.receive(raw, env)["classification"], "IDENTICAL_DUPLICATE")
        self.blocked(lambda: self.w.recover(self.auth("RECOVER_RECONCILE", "TEST-S01"), "reconcile"))
        self.blocked(self.w.reconcile_report)

    def test_duplicate_and_conflicting_capture_do_not_erase_finding_obligation(self):
        _, _, _, raw, env = self.escalate()
        refs = list(self.state()["decision_obligations"])
        self.assertEqual(self.w.receive(raw, env)["classification"], "IDENTICAL_DUPLICATE")
        self.assertEqual(self.w.receive(raw + " ", env)["classification"], "CONFLICTING_DUPLICATE")
        self.w.block("SUSPENDED"); self.rebuild()
        self.refuse("REPORT_CONFLICT_UNRESOLVED", lambda: self.w.recover(self.auth("RECOVER_RETRY", "TEST-S01"), "retry"))
        self.assertEqual(self.state()["decision_obligations"], refs)

    def test_cancel_release_and_source_restoration_do_not_discharge(self):
        _, _, _, raw, env = self.escalate()
        refs = list(self.state()["decision_obligations"])
        self.w.control("CANCEL", self.auth("CANCEL", "fixture-plan:v1"))
        self.w.control("RELEASE", self.auth("RELEASE", "fixture-plan:v1"))
        prior = self.fs.read("project/src/Example.lean")
        self.fs.write("project/src/Example.lean", "def externalChange := 2\n")
        self.w.block("SOURCE_DIVERGED")
        self.blocked(lambda: self.w.recover(self.auth("RECOVER_RETRY", "TEST-S01"), "retry"))
        self.fs.write("project/src/Example.lean", prior)
        self.w.block("SUSPENDED"); self.rebuild()
        self.blocked(lambda: self.w.recover(self.auth("RECOVER_RECONCILE", "TEST-S01"), "reconcile"))
        self.assertEqual(self.state()["decision_obligations"], refs)
        self.assertEqual(self.state()["active"]["pending"]["status"], "CANCELLED")

    def test_backup_restore_retains_finding_obligation(self):
        self.escalate(); self.w.block("SUSPENDED")
        refs = list(self.state()["decision_obligations"])
        tip = self.w.journal.backup("fixture-backup-r03")
        self.w.journal.restore("fixture-backup-r03", tip, authorized=True)
        self.w = Workflow(self.fs, self.identity, "restored")
        self.w.validate_restored_binding_and_source(expected_tip=tip)
        self.assertEqual(self.state()["decision_obligations"], refs)
        self.refuse("LEAD_DECISION_REQUIRED", lambda: self.w.recover(self.auth("RECOVER_RETRY", "TEST-S01"), "retry"))

    def fault(self, mutation):
        # Deliberate integrity fault, never used to establish successful behavior.
        current = self.w.journal.load()
        def corrupt(s):
            mutation(s)
            return s
        self.w.journal.transact(current["rev"], "EXPLICIT_R03_INTEGRITY_FAULT", corrupt)
        self.rebuild()

    def test_fault_dropped_obligation_registry_refuses_reconstruction(self):
        self.escalate()
        self.fault(lambda s: s.update(decision_obligations=[]))
        self.refuse("DECISION_REGISTRY_MISMATCH", self.w.inspect)
        self.assertEqual(self.start()["status"], "SKIPPED_INVALID_STATE")

    def test_fault_favorable_phase_cannot_bypass_shared_obligation_gate(self):
        ev, _, _, _, _ = self.escalate()
        for phase, operation in [
            ("REVIEW_READY", lambda: self.w.prepare_review("fixture-review-request:fault", [ev])),
            ("REVIEW_READY", self.w.simulate_dispatch),
            ("FINAL_VALIDATION", lambda: self.w.finalize_documents("Fault cannot authorize a write")),
            ("CLOSE_READY", self.w.close),
        ]:
            self.fault(lambda s: s["active"].update(phase=phase, blocker=None))
            self.refuse("LEAD_DECISION_REQUIRED", operation)
        self.fault(lambda s: s.update(active=None))
        result = self.start()
        self.assertEqual(result["status"], "SKIPPED_AUTHORITY")
        self.assertEqual(result["reason"], "LEAD_DECISION_REQUIRED")

    def test_fault_old_schema_refused_without_migration(self):
        self.fault(lambda s: s.update(schema=3))
        self.refuse("STATE_SCHEMA", self.w.inspect)

    def reopened(self, repeats=True):
        f = self.finding(True)
        ev = self.to_self_review([f]); self.w.reassess({f["id"]: "Initial concern checked"})
        self.w.disposition(f["id"], "RESOLVED", "Initial applicable evidence", [ev])
        req = self.w.prepare_review("fixture-review-request:r1", [ev]); self.w.simulate_dispatch()
        handoff = self.state()["active"]["initial_handoff"]
        self.w.receive(*self.report(req, ev, [f] if repeats else [])); self.w.reconcile_report()
        return ev, f, handoff

    def target(self, ev, f, label):
        self.w.extra_review(QUESTION, [f["id"]], "New source argument", "PRODUCTIVE", "Concrete unresolved uncertainty")
        req = self.w.prepare_review("fixture-review-request:" + label, [ev], QUESTION)
        self.w.simulate_dispatch()
        return req

    def intermediate(self, ev, f, label, prose=None):
        req = self.target(ev, f, label)
        raw, env = self.report(req, ev, [], "NOT_ESTABLISHED")
        data = json.loads(raw)
        data["earlier_reconciliation"] = [] if prose is None else prose
        self.w.receive(json.dumps(data), env); self.w.reconcile_report(); self.rebuild()
        self.assertEqual(self.state()["active"]["findings"][f["id"]]["history"][-1]["status"], "OPEN")
        return req

    def test_longer_no_new_findings_chain_then_new_satisfactory_report_and_closure(self):
        ev, f, handoff = self.reopened()
        frozen = self.w.store.get(handoff, "self_handoff")
        anchor = self.state()["active"]["findings"][f["id"]]["reopening_episode"]
        for i in range(2, 5):
            self.intermediate(ev, f, "r" + str(i))
            self.assertEqual(self.state()["active"]["findings"][f["id"]]["reopening_episode"], anchor)
        req = self.target(ev, f, "r5")
        self.w.receive(*self.report(req, ev)); self.w.reconcile_report()
        self.w.finish_corrections(); self.ready(ev)
        self.refuse("MATERIAL_FINDING_OPEN", self.w.close)
        self.w.refresh_final("Supported resolution after new satisfactory review")
        self.w.disposition(f["id"], "RESOLVED", "Applicable final evidence", [ev])
        self.ready(ev); self.w.close()
        cert = self.w.store.get(self.state()["completed"]["TEST-S01"], "closure")
        self.assertEqual(len(cert["reconciliations"]), 5)
        self.assertEqual(self.w.store.get(handoff, "self_handoff"), frozen)
        self.assertIsNone(cert["findings"][f["id"]]["reopening_episode"])
        self.assertEqual(self.start()["target"], "TEST-S02")
        self.trace("long-chain-closure", {"initial_handoff": handoff, "episode": anchor,
                   "reconciliations": cert["reconciliations"], "closure": cert, "next_step": "TEST-S02"})

    def test_arbitrary_earlier_reconciliation_prose_cannot_resolve_open_finding(self):
        ev, f, _ = self.reopened()
        anchor = self.state()["active"]["findings"][f["id"]]["reopening_episode"]
        self.intermediate(ev, f, "r2", [{"finding_id": f["id"], "status": "RESOLVED", "explanation": "Untrusted prose assertion"}])
        self.assertEqual(self.state()["active"]["findings"][f["id"]]["reopening_episode"], anchor)
        self.target(ev, f, "r3")
        self.assertFalse(self.state()["completed"])

    def test_criterion_gap_still_blocks_after_supported_finding_resolution(self):
        ev, f, _ = self.reopened(); self.intermediate(ev, f, "r2")
        self.w.disposition(f["id"], "RESOLVED", "Finding resolved does not supply reviewer criterion coverage", [ev])
        self.w.finish_corrections(); self.ready(ev)
        self.refuse("REVIEW_COVERAGE_GAP", self.w.close)

    def test_own_reopening_after_closed_independent_episode_cannot_reuse_old_anchor(self):
        ev, f, _ = self.reopened(); self.intermediate(ev, f, "r2")
        self.w.disposition(f["id"], "REFUTED_WITH_EVIDENCE", "Closes independent episode", [ev])
        self.w.reassess_finding(f["id"], True, "Implementer opens a later concern", [ev])
        self.assertIsNone(self.state()["active"]["findings"][f["id"]]["reopening_episode"])
        self.refuse("INDEPENDENT_REOPEN_REQUIRED", lambda: self.target(ev, f, "r3"))

    def test_fresh_independent_reappearance_starts_new_episode_after_resolution(self):
        ev, f, _ = self.reopened()
        old = self.state()["active"]["findings"][f["id"]]["reopening_episode"]
        self.w.disposition(f["id"], "RESOLVED", "Closes first episode", [ev])
        req = self.target(ev, f, "r2")
        self.w.receive(*self.report(req, ev, [f])); self.w.reconcile_report()
        new = self.state()["active"]["findings"][f["id"]]["reopening_episode"]
        self.assertNotEqual(old, new)
        self.intermediate(ev, f, "r3"); self.target(ev, f, "r4")
        self.assertEqual(self.state()["active"]["findings"][f["id"]]["reopening_episode"], new)

    def test_same_open_episode_explicit_materiality_assessment_retains_provenance(self):
        ev, f, _ = self.reopened(); self.intermediate(ev, f, "r2")
        anchor = self.state()["active"]["findings"][f["id"]]["reopening_episode"]
        self.w.reassess_finding(f["id"], True, "Current evidence, same still-open claim", [ev])
        self.target(ev, f, "r3")
        self.assertEqual(self.state()["active"]["findings"][f["id"]]["reopening_episode"], anchor)

    def test_pending_materiality_change_blocks_until_explicit_assessment(self):
        ev, f, _ = self.reopened(); req = self.target(ev, f, "r2")
        changed = dict(f, material=False)
        self.w.receive(*self.report(req, ev, [changed])); self.w.reconcile_report()
        self.refuse("FINDING_REASSESSMENT_REQUIRED", lambda: self.target(ev, f, "r3"))

    def test_multi_round_retry_and_deferred_reconciliation_still_continue(self):
        ev, f, _ = self.reopened(); self.intermediate(ev, f, "r2")
        req = self.target(ev, f, "r3")
        causal = self.w.store.get(req["reference"], "review_request")["round_decision"]
        self.w.wait_event("FAILED"); self.w.recover(self.auth("RECOVER_RETRY", "TEST-S01"), "retry")
        req = self.w.prepare_review("fixture-review-request:r3-retry", [ev], QUESTION); self.w.simulate_dispatch()
        self.assertEqual(self.w.store.get(req["reference"], "review_request")["round_decision"], causal)
        self.w.control("PAUSE", self.auth("PAUSE", "fixture-plan:v1"))
        result = self.w.receive(*self.report(req, ev))
        self.assertEqual(result["classification"], "LATE_VALID_REPORT")
        self.w.control("RELEASE", self.auth("RELEASE", "fixture-plan:v1"))
        self.w.recover(self.auth("RECOVER_RECONCILE", "TEST-S01"), "reconcile"); self.w.reconcile_report()
        self.w.disposition(f["id"], "RESOLVED", "Supported evidence after actual new report", [ev])
        self.w.finish_corrections(); self.ready(ev); self.w.close()
        self.assertEqual(self.start()["target"], "TEST-S02")

    def test_multi_round_finding_changed_after_preparation_refuses_dispatch(self):
        ev, f, _ = self.reopened(); self.intermediate(ev, f, "r2")
        self.w.extra_review(QUESTION, [f["id"]], "Evidence", "PRODUCTIVE", "Specific current inquiry")
        self.w.prepare_review("fixture-review-request:r3", [ev], QUESTION)
        self.w.reassess_finding(f["id"], True, "Newer assessment changes frozen context", [ev])
        self.refuse("ADDITIONAL_FINDING_CHANGED", self.w.simulate_dispatch)

    def test_multi_round_source_changed_after_preparation_refuses_dispatch(self):
        ev, f, _ = self.reopened(); self.intermediate(ev, f, "r2")
        self.w.extra_review(QUESTION, [f["id"]], "Evidence", "PRODUCTIVE", "Specific current inquiry")
        self.w.prepare_review("fixture-review-request:r3", [ev], QUESTION)
        self.fs.write("project/src/Example.lean", "def externalChange := 7\n")
        self.refuse("SOURCE_DIVERGED", self.w.simulate_dispatch)

    def test_fault_missing_reopening_episode_refuses_reconstruction(self):
        _, f, _ = self.reopened()
        self.fault(lambda s: s["active"]["findings"][f["id"]].update(reopening_episode=None))
        self.refuse("REOPENING_EPISODE_MISMATCH", self.w.inspect)

    def test_fault_unrelated_reopening_episode_refuses_reconstruction(self):
        ev, f, _ = self.reopened(); req = self.target(ev, f, "r2")
        other = dict(f, id="fixture-finding:other", claim="A genuinely different claim", label="R-F02")
        self.w.receive(*self.report(req, ev, [other])); self.w.reconcile_report()
        other_ref = self.state()["active"]["findings"][other["id"]]["reopening_episode"]
        self.fault(lambda s: s["active"]["findings"][f["id"]].update(reopening_episode=other_ref))
        self.refuse("REOPENING_EPISODE_MISMATCH", self.w.inspect)

    def test_fault_missing_reconciliation_history_refuses_reconstruction(self):
        self.reopened()
        self.fault(lambda s: s["active"].update(reconciliations=[]))
        self.refuse("RECONCILIATION_REGISTRY_MISMATCH", self.w.inspect)

    def test_same_finding_id_with_different_claim_still_refused(self):
        ev, f, _ = self.reopened(); req = self.target(ev, f, "r2")
        other = dict(f, claim="Different mathematical claim under same ID")
        self.w.receive(*self.report(req, ev, [other]))
        self.refuse("FINDING_ID_COLLISION", self.w.reconcile_report)

    def test_missing_initial_self_resolution_is_not_a_targeted_episode(self):
        f = self.finding(True); ev = self.to_self_review([f]); self.w.reassess({f["id"]: "Investigate"})
        self.refuse("MATERIAL_FINDING_OPEN", lambda: self.w.prepare_review("fixture-review-request:first", [ev]))
        self.blocked(lambda: self.target(ev, f, "fake-additional"))
        self.assertIsNone(self.state()["active"]["initial_handoff"])
