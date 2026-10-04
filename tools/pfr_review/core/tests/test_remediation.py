"""Interaction regressions for IR-001 through IR-006; synthetic public APIs.
Only tests explicitly named fault injection use primitive/mocked corruption.
"""
import copy
import json
from unittest.mock import patch
from test_workflow import FixtureCase
from safe_store import Refusal
from workflow import Workflow

class RemediationInteractions(FixtureCase):
    def reconstruct(self):
        self.w = Workflow(self.fs, self.identity)

    def late(self, mode="SUSPEND"):
        ev, req = self.to_pending(); raw, env = self.report(req, ev)
        if mode == "PAUSE":
            self.w.control("PAUSE", self.auth("PAUSE", "fixture-plan:v1"))
        else:
            self.w.wait_event(mode)
        result = self.w.receive(raw, env)
        self.assertEqual(result["classification"], "LATE_VALID_REPORT")
        return ev, req, raw, env, result

    def assert_no_acceptance(self):
        self.assertIsNone(self.state()["active"]["report"])
        self.assertFalse(self.state()["completed"])
        with self.assertRaises(Refusal): self.w.reconcile_report()
        with self.assertRaises(Refusal): self.w.close()
        self.assertEqual(self.start()["status"], "SKIPPED_UNCLOSED")

    def finish_report(self, ev):
        self.w.reconcile_report(); self.w.finish_corrections(); self.ready(ev); self.w.close()

    def test_IR001_conflict_all_generic_recovery_modes_cannot_close_or_advance(self):
        ev, req, raw, env, _ = self.late()
        other = json.loads(raw); other["findings"] = [self.finding(True)]
        conflict = self.w.receive(json.dumps(other), env)
        self.assertEqual(conflict["classification"], "CONFLICTING_DUPLICATE")
        # Wait/block cannot erase durable conflict even if blocker wording changes.
        self.w.wait_event("SUSPEND"); self.w.block("fixture temporary reason")
        self.reconstruct()
        for mode in ["continue", "retry", "reconcile"]:
            self.refuse("REPORT_CONFLICT_UNRESOLVED", lambda: self.w.recover(self.auth("RECOVER_"+mode.upper(), "TEST-S01"), mode))
        self.assert_no_acceptance()
        captures = [self.w.store.get(x, "capture") for x in self.state()["captures"]]
        self.assertEqual([x["original_text"] for x in captures], [raw, json.dumps(other)])
        self.assertEqual(captures[1]["envelope"], env)

    def test_IR001_cancel_release_pause_wait_and_recovery_cannot_reactivate(self):
        _, _, _, _, _ = self.late()
        self.w.control("CANCEL", self.auth("CANCEL", "fixture-plan:v1"))
        self.w.control("PAUSE", self.auth("PAUSE", "fixture-plan:v1"))
        self.assertTrue(self.state()["cancel"])
        self.w.control("RELEASE", self.auth("RELEASE", "fixture-plan:v1"))
        self.refuse("WAIT_ON_TERMINAL_REQUEST", lambda: self.w.wait_event("SUSPEND"))
        self.reconstruct()
        for mode in ["continue", "retry", "reconcile"]:
            self.refuse("REQUEST_REACTIVATION_UNSUPPORTED", lambda: self.w.recover(self.auth("RECOVER_"+mode.upper(), "TEST-S01"), mode))
        self.assert_no_acceptance()

    def test_IR001_conflict_after_reconciliation_still_blocks_closure(self):
        ev, _, raw, env, _ = self.late()
        self.w.recover(self.auth("RECOVER_RECONCILE", "TEST-S01"), "reconcile")
        self.w.reconcile_report(); self.w.finish_corrections(); self.ready(ev)
        self.w.receive(raw+" ", env)
        with self.assertRaises(Refusal): self.w.close()
        self.assertFalse(self.state()["completed"])
        self.assertEqual(self.start()["status"], "SKIPPED_UNCLOSED")

    def test_IR001_conflict_after_closure_and_reconstruction_blocks_dependents(self):
        ev, _, raw, env = self.to_final_validation(); self.ready(ev); self.w.close()
        prior = dict(self.state()["completed"])
        self.assertEqual(self.w.receive(raw, env)["classification"], "IDENTICAL_DUPLICATE")
        self.assertEqual(self.w.receive(raw+" ", env)["classification"], "CONFLICTING_DUPLICATE")
        self.reconstruct()
        self.assertEqual(self.state()["completed"], prior)
        self.assertEqual(self.start()["status"], "SKIPPED_UNCLOSED")

    def test_IR002_pause_requires_release_and_exact_reconcile_no_redelivery(self):
        ev, _, raw, env, result = self.late("PAUSE")
        self.refuse("AUTHORITY_PAUSED", lambda: self.w.recover(self.auth("RECOVER_RECONCILE", "TEST-S01"), "reconcile"))
        self.assert_no_acceptance()
        self.w.control("RELEASE", self.auth("RELEASE", "fixture-plan:v1"))
        self.assertIsNone(self.state()["active"]["report"])
        self.assertEqual(self.w.receive(raw, env)["classification"], "IDENTICAL_DUPLICATE")
        self.reconstruct()
        self.w.recover(self.auth("RECOVER_RECONCILE", "TEST-S01"), "reconcile")
        self.assertEqual(self.state()["active"]["report"], result["capture"])
        self.assertEqual(self.w.receive(raw, env)["classification"], "IDENTICAL_DUPLICATE")
        self.finish_report(ev)
        self.assertEqual(self.w.receive(raw, env)["classification"], "IDENTICAL_DUPLICATE")
        self.assertEqual(self.start()["target"], "TEST-S02")

    def test_IR002_wrong_recovery_authority_does_not_accept(self):
        self.late("PAUSE")
        self.w.control("RELEASE", self.auth("RELEASE", "fixture-plan:v1"))
        self.refuse("AUTHORITY_SCOPE", lambda: self.w.recover(self.auth("RECOVER_CONTINUE", "TEST-S01"), "reconcile"))
        self.assert_no_acceptance()

    def test_IR002_unrelated_blocker_and_plan_restriction_remain(self):
        self.late("PAUSE")
        self.w.control("RELEASE", self.auth("RELEASE", "fixture-plan:v1"))
        self.w.block("LEAD_DECISION_REQUIRED")
        self.refuse("RECOVERY_BLOCKER_UNSUPPORTED", lambda: self.w.recover(self.auth("RECOVER_RECONCILE", "TEST-S01"), "reconcile"))
        self.w.mark_plan_revision("fixture-proposed-revision")
        self.refuse("AUTHORITY_PAUSED", lambda: self.w.recover(self.auth("RECOVER_RECONCILE", "TEST-S01"), "reconcile"))
        self.assert_no_acceptance()

    def test_IR002_source_divergence_prevents_deferred_acceptance(self):
        self.late("PAUSE")
        self.w.control("RELEASE", self.auth("RELEASE", "fixture-plan:v1"))
        self.fs.write("project/src/Example.lean", "def fixtureValue : Nat := 74\n")
        self.refuse("SOURCE_DIVERGED", lambda: self.w.recover(self.auth("RECOVER_RECONCILE", "TEST-S01"), "reconcile"))
        self.assert_no_acceptance()

    def test_IR002_supported_backup_restore_reconciles_same_valid_capture(self):
        ev, _, _, _, result = self.late()
        tip = self.w.journal.backup("fixture-backup-valid")
        self.w.journal.restore("fixture-backup-valid", tip, authorized=True)
        self.w = Workflow(self.fs, self.identity, "restored")
        self.refuse("OUTSTANDING_DISPATCH_UNRESOLVED", lambda: self.w.validate_restored_binding_and_source(expected_tip=tip))
        self.w.validate_restored_binding_and_source(expected_tip=tip, dispatch_reconciled=True)
        self.w.recover(self.auth("RECOVER_RECONCILE", "TEST-S01"), "reconcile")
        self.assertEqual(self.state()["active"]["report"], result["capture"])
        self.finish_report(ev)

    def test_IR003_nested_malformed_fields_capture_and_cannot_establish_anything(self):
        ev, req = self.to_pending(); raw, env = self.report(req, ev); data = json.loads(raw)
        modifications = [
            ("criteria", [{"id":"C1","status":["SATISFIED"],"evidence":[ev]}]),
            ("criteria", [{"id":[],"status":"SATISFIED","evidence":[ev]}]),
            ("criteria", [{"id":"unknown","status":"SATISFIED","evidence":[ev]}]),
            ("criteria", data["criteria"]*2),
            ("criteria", [42]), ("criteria", None),
            ("verification", [None]), ("verification", {}),
            ("findings", [self.finding(),self.finding()]), ("findings", ["finding"]),
            ("earlier_reconciliation", 1), ("scope", []),
            ("attempt", True), ("binding_digest", {}), ("conclusion", []),
        ]
        for field,value in modifications:
            with self.subTest(field=field,value=value):
                body=copy.deepcopy(data); body[field]=value; malformed=json.dumps(body)
                result=self.w.receive(malformed,env)
                self.assertNotIn(result["classification"], {"VALID","LATE_VALID_REPORT"})
                capture=self.w.store.get(result["capture"],"capture")
                self.assertEqual(capture["original_text"],malformed)
                original=self.w.store.get(capture["original_capture"],"capture")
                self.assertEqual(original["classification"],"UNCLASSIFIED")
                self.assertEqual(original["envelope"],env)
        self.assertFalse(self.state()["active"]["findings"])
        self.assertFalse(self.state()["active"]["assessments"])
        self.assert_no_acceptance()

    def test_IR003_malformed_envelopes_remain_original_and_non_success(self):
        ev,req=self.to_pending(); raw,env=self.report(req,ev)
        for origin in [None, [], "origin", 7, {}, {**env,"attempt":[]}, {**env,"sender":{}}]:
            with self.subTest(origin=origin):
                result=self.w.receive(raw,origin)
                self.assertNotIn(result["classification"],{"VALID","LATE_VALID_REPORT"})
                self.assertEqual(self.w.store.get(result["capture"],"capture")["envelope"],origin)
        self.assert_no_acceptance()

    def test_IR003_fault_injection_internal_classifier_error_preserves_raw_and_barrier(self):
        ev,req=self.to_pending(); raw,env=self.report(req,ev)
        with patch("workflow.classify_report", side_effect=RuntimeError("injected classifier defect")):
            with self.assertRaisesRegex(RuntimeError,"injected classifier"):
                self.w.receive(raw,env)
        record=self.w.store.get(self.state()["captures"][-1],"capture")
        self.assertEqual(record["original_text"],raw)
        self.assertEqual(record["classification"],"UNCLASSIFIED")
        self.reconstruct()
        self.w.wait_event("SUSPEND")
        self.refuse("UNCLASSIFIED_REPORT_CAPTURE",lambda:self.w.recover(self.auth("RECOVER_RETRY","TEST-S01"),"retry"))
        self.assert_no_acceptance()

    def test_IR003_fault_injection_capture_write_failure_never_claims_storage(self):
        ev,req=self.to_pending(); raw,env=self.report(req,ev)
        with patch.object(self.w.store,"put",side_effect=OSError("injected disk failure")):
            with self.assertRaisesRegex(OSError,"injected disk"):
                self.w.receive(raw,env)
        self.assertEqual(self.state()["captures"],[])
        self.assert_no_acceptance()

    def test_IR003_arrival_after_closed_step_preserves_invalid_without_reopening(self):
        self.finish_one(); prior=dict(self.state()["completed"])
        result=self.w.receive('{"criteria":42}',[])
        self.assertEqual(result["classification"],"BAD_ENVELOPE")
        self.assertEqual(self.state()["completed"],prior)
        self.assertIsNone(self.state()["active"])
        self.assertEqual(self.start()["target"],"TEST-S02")

    def test_IR004_failed_retry_ids_reserved_and_old_report_not_accepted(self):
        ev,req=self.to_pending(); raw,env=self.report(req,ev); first=req["payload"]["request_id"]
        self.w.wait_event("FAILED"); self.w.recover(self.auth("RECOVER_RETRY","TEST-S01"),"retry")
        self.reconstruct()
        self.refuse("REQUEST_ID_REUSED",lambda:self.w.prepare_review(first,[ev]))
        new=self.w.prepare_review("fixture-review-request:retry-unique",[ev])
        self.assertEqual(new["payload"]["attempt"],2)
        self.w.simulate_dispatch()
        self.assertEqual(self.w.receive(raw,env)["classification"],"WRONG_REQUEST")
        self.w.receive(*self.report(new,ev)); self.finish_report(ev)
        ev2=self.to_self_review(); self.w.reassess({}); self.reconstruct()
        self.refuse("REQUEST_ID_REUSED",lambda:self.w.prepare_review(first,[ev2]))
        self.refuse("REQUEST_ID_REUSED",lambda:self.w.prepare_review(new["payload"]["request_id"],[ev2]))

    def test_IR004_new_unique_step_request_and_identical_ingress_text_are_valid(self):
        self.finish_one()
        ev,req=self.to_pending()
        self.assertEqual(req["payload"]["target_id"],"TEST-S02")
        raw,env=self.report(req,ev); self.w.receive(raw,env)
        self.assertEqual(self.w.receive(raw,env)["classification"],"IDENTICAL_DUPLICATE")
        self.finish_report(ev)
        self.assertEqual(len(self.state()["request_registry"]),2)

    def test_IR004_fault_injection_missing_historical_reservation_refuses_reconstruction(self):
        self.finish_one()
        current = self.w.journal.load()
        def corrupt(state):
            state["request_registry"].clear()
            return state
        # Deliberate fixture corruption, never the supported transition path.
        self.w.journal.transact(current["rev"], "FAULT_DROP_HISTORICAL_RESERVATION", corrupt)
        self.reconstruct()
        self.refuse("REQUEST_REGISTRY_MISSING", self.w.inspect)
        self.assertEqual(self.start()["status"], "SKIPPED_INVALID_STATE")

    def test_IR005_material_self_resolution_and_optional_decline_allow_dispatch(self):
        material=self.finding(True); optional={**self.finding(),"id":"fixture-finding:optional"}
        ev=self.to_self_review([material,optional])
        self.w.reassess({material["id"]:"Resolve with source evidence",optional["id"]:"Decline with reason"})
        self.refuse("MATERIAL_FINDING_OPEN",lambda:self.w.prepare_review("fixture-review-request:gate",[ev]))
        self.w.disposition(material["id"],"RESOLVED","Verified bounded repair",[ev])
        self.w.disposition(optional["id"],"OPTIONAL_DECLINED","No consumer benefit")
        req=self.w.prepare_review("fixture-review-request:gate",[ev]); self.w.simulate_dispatch()
        self.w.receive(*self.report(req,ev)); self.finish_report(ev)

    def test_IR005_dispatch_rechecks_finding_gate_after_explicit_reassessment(self):
        f=self.finding(); ev=self.to_self_review([f]); self.w.reassess({f["id"]:"defer"})
        self.w.disposition(f["id"],"OPTIONAL_DEFERRED","Revisit with actual need")
        self.w.prepare_review("fixture-review-request:before-reclassification",[ev])
        self.w.reassess_finding(f["id"],True,"New current-step evidence establishes materiality",[ev])
        self.refuse("MATERIAL_FINDING_OPEN",self.w.simulate_dispatch)
        self.assertEqual(self.state()["active"]["pending"]["status"],"READY")

    def test_IR005_stale_disposition_evidence_blocks_handoff(self):
        f=self.finding(True); ev=self.to_self_review([f]); self.w.reassess({f["id"]:"resolve"})
        self.w.disposition(f["id"],"RESOLVED","Inspected",[ev])
        self.w.own_edit("project/src/Example.lean","def fixtureValue : Nat := 11\n")
        fresh=self.w.add_evidence("new validation")
        self.refuse("EVIDENCE_STALE",lambda:self.w.prepare_review("fixture-review-request:stale-disposition",[fresh]))

    def test_IR005_fault_injection_unfinished_edit_blocks_handoff(self):
        self.start()
        original_write=self.fs.write
        def fail_project(path,*args,**kwargs):
            if path=="project/src/Example.lean": raise OSError("fixture interrupted source write")
            return original_write(path,*args,**kwargs)
        with patch.object(self.fs,"write",side_effect=fail_project):
            with self.assertRaises(OSError):self.w.own_edit("project/src/Example.lean","new")
        ev=self.w.add_evidence("source unchanged after failed edit")
        self.w.initial_validation([ev]);self.w.self_review([],"clean");self.w.reassess({})
        self.refuse("UNFINISHED_EDIT",lambda:self.w.prepare_review("fixture-review-request:unfinished",[ev]))

    def test_IR006_explicit_upgrade_reopens_disposition_and_preserves_original(self):
        f=self.finding(); ev,_,_,_=self.to_final_validation([f])
        self.w.disposition(f["id"],"OPTIONAL_DEFERRED","Later if needed")
        original=copy.deepcopy(self.state()["active"]["findings"][f["id"]]["original"])
        self.w.reassess_finding(f["id"],True,"Now needed by current consumer",[ev])
        current=self.state()["active"]["findings"][f["id"]]
        self.assertEqual(current["original"],original)
        self.assertEqual([x["status"] for x in current["history"]],["OPEN","OPTIONAL_DEFERRED","OPEN"])
        self.ready(ev);self.refuse("MATERIAL_FINDING_OPEN",self.w.close)
        self.w.refresh_final("Resolve reclassified concern")
        self.w.disposition(f["id"],"RESOLVED","Fresh supported disposition",[ev])
        self.ready(ev);self.w.close()

    def test_IR006_downgrade_requires_specific_authority_and_evidence(self):
        f=self.finding(True);ev,_,_,_=self.to_final_validation([f])
        self.refuse("AUTHORITY_SCHEMA",lambda:self.w.reassess_finding(f["id"],False,"Preference",[ev]))
        self.refuse("EVIDENCE_REQUIRED",lambda:self.w.reassess_finding(f["id"],False,"Supported decision",[],
                    approval=self.auth("REASSESS_FINDING",f["id"])))
        self.w.reassess_finding(f["id"],False,"Lead confirms optionality from inspected scope",[ev],
                    approval=self.auth("REASSESS_FINDING",f["id"]))
        item=self.state()["active"]["findings"][f["id"]]
        self.assertTrue(item["original"]["material"]);self.assertFalse(item["material"])
        self.w.disposition(f["id"],"OPTIONAL_DECLINED","No longer required in approved scope")
        self.ready(ev);self.w.close()

    def test_IR006_incoming_downgrade_never_automatically_clears_materiality(self):
        f=self.finding(True);ev,_,_,_=self.to_final_validation([f])
        self.w.disposition(f["id"],"RESOLVED","First report concern addressed",[ev])
        self.w.extra_review("Recheck concern",[f["id"]],"New assessment","PRODUCTIVE","Verify from source")
        req=self.w.prepare_review("fixture-review-request:downgrade",[ev],"Recheck concern");self.w.simulate_dispatch()
        f["material"]=False
        self.w.receive(*self.report(req,ev,[f]));self.w.reconcile_report()
        item=self.state()["active"]["findings"][f["id"]]
        self.assertTrue(item["material"]);self.assertTrue(item["pending_assessment"])
        self.refuse("FINDING_REASSESSMENT_REQUIRED",lambda:self.w.disposition(f["id"],"OPTIONAL_DECLINED","No"))
        self.refuse("AUTHORITY_SCHEMA",lambda:self.w.reassess_finding(f["id"],False,"No",[ev]))

    def test_IR006_true_claim_collision_still_refused_original_intact(self):
        f=self.finding();ev,_,_,_=self.to_final_validation([f]);old=copy.deepcopy(self.state()["active"]["findings"][f["id"]])
        self.w.extra_review("Other claim",[f["id"]],"Source","PRODUCTIVE","New question")
        req=self.w.prepare_review("fixture-review-request:collision",[ev],"Other claim");self.w.simulate_dispatch()
        f["claim"]="A genuinely different claim"
        self.w.receive(*self.report(req,ev,[f]))
        self.refuse("FINDING_ID_COLLISION",self.w.reconcile_report)
        self.assertEqual(self.state()["active"]["findings"][f["id"]],old)
        self.assertFalse(self.state()["completed"])

    def test_IR006_historical_reassessment_preserves_certificate_blocks_advance(self):
        f=self.finding();ev,_,_,_=self.to_final_validation([f])
        self.w.disposition(f["id"],"OPTIONAL_DECLINED","Not required then");self.ready(ev);self.w.close()
        prior=dict(self.state()["completed"]);cert=self.w.store.get(prior["TEST-S01"],"closure")
        self.w.reassess_finding(f["id"],True,"Historical acceptance affected by new evidence",[ev],
                               approval=self.auth("REASSESS_FINDING",f["id"]))
        self.reconstruct()
        self.assertEqual(self.state()["completed"],prior)
        self.assertEqual(self.w.store.get(prior["TEST-S01"],"closure"),cert)
        self.assertEqual(self.state()["external_blocker"],"HISTORICAL_FINDING_REASSESSMENT")
        self.assertEqual(self.start()["status"],"SKIPPED_UNCLOSED")

    def test_IR006_current_reassessment_with_declared_earlier_impact_blocks_active_work(self):
        f=self.finding(); ev,_,_,_=self.to_final_validation([f])
        self.w.disposition(f["id"],"OPTIONAL_DECLINED","Not required then"); self.ready(ev); self.w.close()
        prior=dict(self.state()["completed"])
        ev2=self.to_self_review([f]); self.w.reassess({f["id"]:"Investigate current and earlier impact"})
        self.w.reassess_finding(f["id"],True,"Earlier accepted step also affected",[ev2],
                               approval=self.auth("REASSESS_FINDING",f["id"]), affected_closed_steps=["TEST-S01"])
        self.reconstruct()
        self.assertEqual(self.state()["completed"],prior)
        self.refuse("EXTERNAL_BLOCKER", lambda:self.w.prepare_review("fixture-review-request:historical-impact",[ev2]))
        with self.assertRaises(Refusal):self.w.close()

    def test_criterion_gap_strict_guard_retained_and_fresh_review_can_close(self):
        ev,_,_,_=self.to_final_validation(status="NOT_ESTABLISHED")
        old=self.state()["active"]["report"]
        self.ready(ev);self.refuse("REVIEW_COVERAGE_GAP",self.w.close)
        self.w.refresh_final("Obtain actual new criterion assessment")
        self.w.extra_review("Establish missing criterion",[],"Source criterion evidence","PRODUCTIVE","Gap remains")
        req=self.w.prepare_review("fixture-review-request:criterion-gap",[ev],"Establish missing criterion")
        self.w.simulate_dispatch();self.w.receive(*self.report(req,ev));self.finish_report(ev)
        self.assertEqual(self.w.store.get(old,"capture")["parsed"]["criteria"][0]["status"],"NOT_ESTABLISHED")

    def test_criterion_contradiction_not_overridden_by_bounded_string(self):
        ev,_,_,_=self.to_final_validation(status="CONTRADICTED_BY_FINDING")
        self.ready(ev,impact="BOUNDED_CORRECTION")
        self.refuse("REVIEW_COVERAGE_GAP",self.w.close)
