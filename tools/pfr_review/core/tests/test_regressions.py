"""Adversarial regressions added after inspection of the first 64-test pass."""
import json

from safe_store import canonical, digest, strict_json
from test_workflow import FixtureCase


class AuditRegressions(FixtureCase):
    def test_duplicate_after_complete_remains_harmless(self):
        ev, _, raw, env = self.to_final_validation()
        self.ready(ev); self.w.close()
        self.assertEqual(self.w.receive(raw, env)["classification"], "IDENTICAL_DUPLICATE")
        self.assertEqual(len(self.state()["completed"]), 1)
        self.assertIsNone(self.state()["active"])

    def test_conflicting_duplicate_after_complete_blocks_dependents(self):
        ev, _, raw, env = self.to_final_validation()
        self.ready(ev); self.w.close()
        self.assertEqual(self.w.receive(raw + " ", env)["classification"], "CONFLICTING_DUPLICATE")
        self.assertEqual(self.start()["status"], "SKIPPED_UNCLOSED")

    def test_unknown_report_evidence_not_accepted(self):
        ev, req = self.to_pending()
        raw, env = self.report(req, ev)
        data = json.loads(raw)
        data["criteria"][0]["evidence"] = ["invented-evidence"]
        self.assertEqual(self.w.receive(json.dumps(data), env)["classification"], "REPORT_EVIDENCE_INVALID")

    def test_request_names_fixed_target_step(self):
        _, req = self.to_pending()
        self.assertEqual(req["payload"].get("target_id"), "TEST-S01")

    def test_pause_forbids_own_rollback(self):
        self.start()
        ref = self.w.own_edit("project/src/Example.lean", "def fixtureValue : Nat := 2\n")
        self.w.control("PAUSE", self.auth("PAUSE", "fixture-plan:v1"))
        before = self.fs.read("project/src/Example.lean")
        self.refuse("AUTHORITY_PAUSED", lambda: self.w.reverse_own_edit(ref))
        self.assertEqual(self.fs.read("project/src/Example.lean"), before)

    def test_report_before_dispatch_cannot_close_review(self):
        ev = self.to_self_review(); self.w.reassess({})
        req = self.w.prepare_review("fixture-review-request:before-dispatch", [ev])
        raw, env = self.report(req, ev)
        self.assertEqual(self.w.receive(raw, env)["classification"], "UNDISPATCHED_REPORT")
        self.assertEqual(self.state()["active"]["phase"], "REVIEW_READY")

    def test_wrong_state_type_is_structured_refusal(self):
        revision = self.w.inspect()["rev"]
        self.w.journal.transact(revision, "fixture-deliberate-malformed-state", lambda _: "done")
        self.refuse("STATE_SCHEMA", self.w.inspect)

    def test_failed_check_cannot_establish_initial_validation(self):
        self.start()
        ev = self.w.add_evidence("fixture failed validation", outcome="FAIL")
        self.refuse("EVIDENCE_NOT_PASSING", lambda: self.w.initial_validation([ev]))

    def test_snapshot_changes_during_capture_refused(self):
        original_read = self.fs.read
        observed = {"changed": False}
        def mutating_read(path):
            raw = original_read(path)
            if path == "project/src/Example.lean" and not observed["changed"]:
                observed["changed"] = True
                self.fs.write(path, "def fixtureValue : Nat := 99\n")
            return raw
        self.fs.read = mutating_read
        self.refuse("UNSTABLE_SOURCE_CAPTURE", lambda: self.w.current(self.state()))

    def test_fresh_review_decision_links_actual_request(self):
        ev, _, _, _ = self.to_final_validation()
        self.w.extra_review("Check new risk", [], "New source observation", "PRODUCTIVE", "Meaningful supplied risk")
        req = self.w.prepare_review("fixture-review-request:new-risk", [ev], "Check new risk")
        stored = self.w.store.get(req["reference"], "review_request")
        self.assertEqual(stored.get("round_decision"), self.state()["active"]["rounds"][-1])

    def test_finding_identity_and_history_survive_next_step(self):
        finding = self.finding()
        ev, _, _, _ = self.to_final_validation([finding])
        self.w.disposition(finding["id"], "OPTIONAL_DECLINED", "Not justified for this step.")
        self.ready(ev); self.w.close()
        ev, req = self.to_pending()
        finding["label"] = "New-report-local-label"
        self.w.receive(*self.report(req, ev, [finding])); self.w.reconcile_report()
        history = self.state()["active"]["findings"][finding["id"]]
        self.assertEqual(history["original"]["label"], "R-F01")
        self.assertEqual(len(history["appearances"]), 2)
        self.assertEqual([h["status"] for h in history["history"]], ["OPEN", "OPTIONAL_DECLINED", "OPEN"])

    def test_editorial_refresh_without_extra_build(self):
        ev, _, _, _ = self.to_final_validation()
        self.ready(ev)
        old_F = self.state()["active"]["F"]
        doc = strict_json(self.fs.read("project/plan.json")); doc["log"].append("late note")
        self.fs.write("project/plan.json", canonical(doc))
        self.refuse("FINAL_SOURCE_CHANGED", self.w.close)
        self.w.refresh_final("Account for later routine metadata; original evidence still applies.")
        self.ready(ev); self.w.close()
        cert = self.w.store.get(self.state()["completed"]["TEST-S01"], "closure")
        self.assertNotEqual(cert["F"], old_F)
        self.assertEqual(cert["validation"], [ev])

    def test_bounded_correction_requires_fresh_evidence_not_extra_review_automatically(self):
        ev, req = self.to_pending()
        self.w.receive(*self.report(req, ev)); self.w.reconcile_report(); self.w.begin_corrections()
        self.w.own_edit("project/src/Example.lean", "def fixtureValue : Nat := 0\n-- fixture proof-maintenance comment\n")
        fresh = self.w.add_evidence("fresh synthetic validation of bounded correction")
        self.w.finish_corrections()
        self.refuse("EVIDENCE_STALE", lambda: self.w.assess("C1", "SATISFIED", [ev], "stale check"))
        self.ready(fresh, impact="BOUNDED_CORRECTION"); self.w.close()
        cert = self.w.store.get(self.state()["completed"]["TEST-S01"], "closure")
        self.assertNotEqual(cert["R"], cert["F"])
        self.assertEqual(len(cert["review_history"]), 1)

    def test_explicit_failed_review_retry_is_new_attempt_not_next_step(self):
        ev, req = self.to_pending(); self.w.wait_event("FAILED")
        self.refuse("EXPLICIT_RETRY_OR_RECONCILIATION_REQUIRED", lambda:
                    self.w.recover(self.auth("RECOVER_CONTINUE", "TEST-S01")))
        self.w.recover(self.auth("RECOVER_RETRY", "TEST-S01"), "retry")
        next_request = self.w.prepare_review("fixture-review-request:retry", [ev])
        self.assertEqual(next_request["payload"]["attempt"], 2)
        self.assertEqual(next_request["payload"]["target_id"], "TEST-S01")
        self.assertEqual(self.start()["status"], "SKIPPED_UNCLOSED")

    def test_wrong_binding_after_restore_refuses(self):
        from dataclasses import replace
        from workflow import Workflow
        tip = self.w.journal.backup("fixture-backup-wrong-binding")
        self.w.journal.restore("fixture-backup-wrong-binding", tip, authorized=True)
        wrong = Workflow(self.fs, replace(self.identity, parent="fixture-parent:wrong-root"), "restored")
        self.refuse("WRONG_BINDING", wrong.inspect)

    def test_symlink_rejected_before_cleanup_when_supported(self):
        self.fs.write("scratch/owned.txt", "owned fixture scratch")
        link = self.fs.root / "scratch" / "linked-project"
        try:
            link.symlink_to(self.fs.path("project"), target_is_directory=True)
        except OSError as exc:
            self.skipTest(f"Local symlink creation unavailable: {exc}")
        self.refuse("INDIRECTION", self.fs.cleanup_scratch)
        self.assertTrue(self.fs.path("project/src/Example.lean").exists())
