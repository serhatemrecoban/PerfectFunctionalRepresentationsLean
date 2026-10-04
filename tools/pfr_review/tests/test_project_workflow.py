"""REPLAYED source-copy integration checks; no models, native tools or Lean runs.

All user/reviewer inputs below are explicitly synthetic fixture records. The
same installed adapter is exercised with TEST_TAG, never production acceptance.
"""
import copy
from dataclasses import asdict
import json
import os
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest
from unittest.mock import patch

sys.path.insert(0, str(Path(__file__).absolute().parents[1]))
import project
from safe_store import FixtureFS, Refusal, digest


class ProjectWorkflowTests(unittest.TestCase):
    chunk = "PFR-C03"
    parent = "source-copy-test-parent"
    reviewer = "/root/source_copy_test_reviewer"
    plan_path = "docs/plans/pfr-c03-source-copy-test.md"
    claim1 = "Fixture step one must preserve the declared source-copy contract."
    claim2 = "Fixture step two must preserve the source-copy contract after step one."

    def setUp(self):
        temporary = tempfile.TemporaryDirectory(prefix="pfr-workflow-test-")
        self.addCleanup(temporary.cleanup)
        self.root = Path(temporary.name)
        env = patch.dict(os.environ, {"CODEX_THREAD_ID": self.parent})
        env.start(); self.addCleanup(env.stop)
        self.n = 0
        self.git("init", "-q")
        self.git("config", "user.name", "Source-copy fixture")
        self.git("config", "user.email", "fixture@example.invalid")
        self.put(".gitignore", ".pfr-review/\ntmp/\n.lake/\n__pycache__/\n")
        self.put("lean-toolchain", "leanprover/lean4:v4.33.1\n")
        self.put("lakefile.toml", 'name = "SOURCE_COPY_TEST_ONLY"\n')
        self.put("lake-manifest.json", json.dumps({"packagesDir": ".lake/packages", "packages": []}))
        self.put("Case.lean", "-- Source-copy fixture; no production theorem or compiler claim.\n")
        self.put(self.plan_path, "# Source-copy fixture plan\n\n**Status:** Approved\n\n"
                 "## PFR-C03-S01\n" + self.claim1 + "\n\n## PFR-C03-S02\n" + self.claim2 + "\n")
        self.git("add", "."); self.git("commit", "-qm", "Source-copy fixture baseline")
        self.head = self.git("rev-parse", "HEAD").decode().strip()

    def put(self, rel, text):
        path = self.root / rel
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(text, encoding="utf-8", newline="")

    def git(self, *args):
        return subprocess.check_output(["git", "-C", str(self.root), *args], stderr=subprocess.STDOUT)

    def user(self, **fields):
        self.n += 1
        return {"role": "user", "reference": f"synthetic-source-copy:user-{self.n}",
                "original_text": "Synthetic fixture instruction, not actual project authorization.", **fields}

    def install_bind(self):
        self.installation = project.setup(self.root, self.user(), test=True)
        creation = {"canonical_reviewer": self.reviewer, "requested": project.PROFILE,
                    "original_result": {"task_name": self.reviewer, "fixture_note": "Synthetic creation; no native call."},
                    "reference": "synthetic-source-copy:creation", "parent_role": "/root"}
        return project.bind(self.root, self.chunk, self.parent, self.reviewer, creation, self.user(), test=True)

    def criterion(self, step=1):
        return {"id": f"C03-S0{step}-C1", "description": f"Source-copy fixture step {step}",
                "source_reference": self.plan_path + f"#pfr-c03-s0{step}",
                "normative_excerpt": self.claim1 if step == 1 else self.claim2,
                "scope": "Case.lean exact source-copy fixture bytes",
                "required_evidence": "Inspect exact fixture bytes; no mathematical certification."}

    def contract(self, kind="STEP"):
        return {"plan_path": self.plan_path, "plan_sha256": digest((self.root / self.plan_path).read_bytes()),
                "kind": kind, "scope": ["Case.lean"], "normative_anchors": [self.claim1, self.claim2],
                "steps": [{"id": f"PFR-C03-S0{i}", "criteria": [self.criterion(i)]} for i in (1, 2)] if kind == "STEP" else [],
                "plan_criteria": [self.criterion()] if kind == "PLAN" else []}

    def session(self, kind="STEP"):
        self.install_bind()
        contract = self.contract(kind)
        self.w = project.open_session(self.root, self.chunk, "execution" if kind == "STEP" else "plan-fixture",
            contract, self.user(scope="APPROVED_IMPLEMENTATION_PLAN" if kind == "STEP" else "PLAN_REVIEW",
                                plan_sha256=contract["plan_sha256"]), test=True)
        return self.w

    def state(self):
        return self.w.inspect()["state"]

    def auth(self, action, target):
        return self.w.authority(action, target, "pfr-auth:" + str(self.n + 1), self.user())

    def next(self, identifier="next-1"):
        return self.w.process_next("pfr-message:" + identifier, "Synthetic next one eligible step with review",
                                   self.auth("NEXT_STEP", self.w.plan_id))

    def ev(self):
        return self.w.parent_evidence("Fixture-only source inspection", "Synthetic PASS; no model or Lean run.",
                                      "REPLAYED source-copy test data, not actual mathematical evidence.")

    def prepared(self, identifier="first", start=True):
        if start:
            self.assertEqual(self.next(identifier)["status"], "ACCEPTED")
        ev = self.ev()
        self.w.initial_validation([ev]); self.w.self_review([], "Synthetic contextual review.")
        self.w.reassess({})
        req = self.w.prepare_review(f"pfr-review:{self.chunk}:execution:{identifier}", [ev])
        return ev, req

    def observation(self, req, raw=None, **extra):
        result = {"input_mode": "REPLAYED", "origin": "SYNTHETIC_EVENT", "parent": self.parent,
                  "reviewer": self.reviewer, "event_ref": f"synthetic-source-copy:event-{self.n}",
                  "original_event": "Synthetic fixture event; not an actual tool response.",
                  "replay_of": "Authored source-copy fixture sample, no historical native claim.",
                  "request_ref": req["reference"]}
        if raw is not None:
            result.update(event_kind="FULL_REPORT", complete=True, text_role="ORIGINAL_NOT_SUMMARY", extracted_text=raw,
                          original_event=json.dumps({"Message Type": "FINAL_ANSWER", "Task name": "/root",
                                                     "Sender": self.reviewer, "Payload": raw}))
        result.update(extra)
        return result

    def report(self, req, status="SATISFIED", finding=False):
        p = req["payload"]
        findings = [{"id": "pfr-finding:source-copy-extra-premise", "label": "Fixture material concern", "material": True,
                     "claim": "Synthetic unresolved source-copy contract concern.", "severity": "HIGH", "confidence": "HIGH"}] if finding else []
        return json.dumps({"report": {"schema": 1, "tag": project.TEST_TAG,
            "request_id": p["request_id"], "attempt": p["attempt"], "source_ref": p["source_ref"], "kind": p["kind"],
            "binding_digest": digest(asdict(self.w.identity)), "scope": "Source-copy fixture only",
            "findings": findings, "criteria": [{"id": c["id"], "status": status, "evidence": ["reviewer:fixture-check"]}
                                                 for c in p["requirements"]],
            "verification": ["reviewer:fixture-check"], "earlier_reconciliation": "Exact fixture prose.\nPreserve whitespace. ",
            "conclusion": "Fixture report data, never approval."},
            "new_evidence": [{"id": "reviewer:fixture-check", "actor": self.reviewer, "method": "Fixture source inspection",
            "source_ref": p["source_ref"], "inspected_source": "Case.lean and exact fixture contract",
            "command": None, "output": "Synthetic fixture observation; no actual model or compiler execution.",
            "outcome": "PASS" if status == "SATISFIED" else "FAIL", "limitations": "Authored REPLAYED test data."}]})

    def deliver(self, req, raw):
        self.w.dispatch_intent(req["reference"])
        receipt = self.w.record_submission(req["reference"], "UNCERTAIN", self.observation(req, original_event='""'))
        original = self.w.fs.read("durable/objects/" + receipt + ".json")
        confirmed = self.w.confirm_delivery(req["reference"], receipt, raw, self.observation(req, raw),
                                            self.auth("CONFIRM_DIAGNOSTIC_DELIVERY", req["reference"]))
        self.assertFalse(confirmed["report_accepted"])
        self.assertEqual(original, self.w.fs.read("durable/objects/" + receipt + ".json"))
        result = self.w.receive_report(raw, self.observation(req, raw), req["payload"]["request_id"], req["payload"]["attempt"])
        self.assertEqual(result["classification"], "VALID")
        return result

    def final_ready(self, ev):
        self.w.finish_corrections()
        for criterion in self.w._criteria(self.state()):
            self.w.assess(criterion["id"], "SATISFIED", [ev], "Synthetic fixture final assessment.")
        self.w.finalize_documents("No fixture documentation changed; inspected owning source-copy files.")
        self.w.prepare_final([ev], impact="NO_SEMANTIC_CHANGE", rationale="Identical scoped fixture source.")

    def test_setup_is_not_execution_and_fixture_store_rejected(self):
        binding = self.install_bind()
        self.assertEqual(self.installation["tag"], project.TEST_TAG)
        self.assertFalse(self.installation["mathematical_execution_authorized"])
        self.assertEqual(binding["input_mode"], "REPLAYED")
        fs = project.ProjectRecordFS(self.root, "chunks/" + self.chunk, test=True)
        with self.assertRaises(Refusal): FixtureFS(fs.root)
        with self.assertRaises(Refusal): project.ProjectRecordFS(self.root, "chunks/" + self.chunk, test=False)
        with self.assertRaises(Refusal): fs.cleanup_scratch()
        self.assertFalse((fs.root / "execution").exists())

    def test_wrong_parent_diagnostic_reviewer_and_unapproved_plan_refused(self):
        project.setup(self.root, self.user(), test=True)
        creation = {"canonical_reviewer": self.reviewer, "requested": project.PROFILE,
                    "original_result": {"task_name": self.reviewer, "fixture_note": "Synthetic creation"},
                    "reference": "synthetic:creation", "parent_role": "/root"}
        with self.assertRaisesRegex(Refusal, "WRONG_ORIGINATING_PARENT"):
            project.bind(self.root, self.chunk, "wrong-parent", self.reviewer, creation, self.user(), test=True)
        with self.assertRaisesRegex(Refusal, "DIAGNOSTIC_REVIEWER_NOT_TRANSFERABLE"):
            project.bind(self.root, self.chunk, self.parent, "/root/pfr_native_toy_20260909", creation, self.user(), test=True)
        project.bind(self.root, self.chunk, self.parent, self.reviewer, creation, self.user(), test=True)
        self.put(self.plan_path, (self.root / self.plan_path).read_text().replace("Approved", "Draft"))
        contract = self.contract()
        with self.assertRaisesRegex(Refusal, "NO_APPROVED_PLAN"):
            project.open_session(self.root, self.chunk, "execution", contract,
                                 self.user(scope="APPROVED_IMPLEMENTATION_PLAN", plan_sha256=contract["plan_sha256"]), test=True)
        self.assertFalse((self.root / ".pfr-review/chunks/PFR-C03/execution").exists())

    def test_unique_per_step_criteria_and_markdown_anchor_required(self):
        contract = self.contract()
        project.verify_contract(self.root, contract, first=True)
        bad = copy.deepcopy(contract); bad["steps"][1]["criteria"][0]["id"] = bad["steps"][0]["criteria"][0]["id"]
        with self.assertRaisesRegex(Refusal, "DUPLICATE_CRITERION"):
            project.verify_contract(self.root, bad, first=True)
        bad = copy.deepcopy(contract); bad["steps"][0]["criteria"][0]["normative_excerpt"] = "Not in actual Markdown."
        with self.assertRaisesRegex(Refusal, "CRITERION_SOURCE_ANCHOR"):
            project.verify_contract(self.root, bad, first=True)

    def test_two_steps_uncertain_delivery_and_original_prose_preserved(self):
        self.session()
        for i in (1, 2):
            if i == 2:
                self.assertEqual(self.next(str(i))["target"], "PFR-C03-S02")
                edit = self.w.begin_edit(["Case.lean"], "Synthetic authorized second-step own patch")
                self.put("Case.lean", "-- Second-step source-copy fixture implementation.\n")
                self.w.finish_edit(edit)
            ev, req = self.prepared(str(i), start=i == 1)
            self.assertEqual([c["id"] for c in req["payload"]["requirements"]], [f"C03-S0{i}-C1"])
            raw = self.report(req); result = self.deliver(req, raw)
            cap = self.w.store.get(result["capture"], "capture")
            self.assertEqual(cap["original_text"], raw)
            self.assertEqual(cap["parsed"]["earlier_reconciliation"], [json.loads(raw)["report"]["earlier_reconciliation"]])
            self.w.reconcile_report(); self.final_ready(ev)
            closure = self.w.project_closure()
            self.assertFalse(closure["production_acceptance"])
            self.assertFalse(closure["next_step_started"])
            if i == 2:
                cert = self.w.store.get(closure["closure"], "closure")
                before = self.w.store.get(cert["B"], "manifest")
                reviewed = self.w.store.get(cert["R"], "manifest")
                self.assertNotEqual(before["source_bytes"]["Case.lean"], reviewed["source_bytes"]["Case.lean"])
            self.assertIsNone(self.state()["active"])
            self.w = project.load_session(self.root, self.chunk, "execution", test=True)
        self.assertEqual(len(self.state()["completed"]), 2)
        self.assertEqual(self.next("third")["status"], "NO_ELIGIBLE_STEP")

    def test_negative_evidence_and_criterion_gap_block_closure(self):
        self.session(); ev, req = self.prepared()
        result = self.deliver(req, self.report(req, "NOT_ESTABLISHED"))
        cap = self.w.store.get(result["capture"], "capture")
        self.assertEqual(self.w.store.get(cap["parsed"]["verification"][0], "evidence")["outcome"], "FAIL")
        self.w.reconcile_report(); self.final_ready(ev)
        with self.assertRaisesRegex(Refusal, "REVIEW_COVERAGE_GAP"):
            self.w.project_closure()
        self.assertFalse(self.state()["completed"])

    def test_material_negative_finding_remains_open(self):
        self.session(); ev, req = self.prepared()
        self.deliver(req, self.report(req, "CONTRADICTED_BY_FINDING", finding=True))
        self.w.reconcile_report(); self.final_ready(ev)
        with self.assertRaisesRegex(Refusal, "MATERIAL_FINDING_OPEN"):
            self.w.project_closure()
        self.assertFalse(self.state()["completed"])

    def test_pending_consumed_skip_does_not_retry_then_fresh_request_can_continue(self):
        self.session(); ev, req = self.prepared()
        self.w.dispatch_intent(req["reference"])
        receipt = self.w.record_submission(req["reference"], "UNCERTAIN", self.observation(req, original_event='""'))
        pending = self.state()["active"]["pending"]
        skipped = self.next("queued")
        self.assertEqual(skipped["status"], "SKIPPED_UNCLOSED")
        self.assertEqual(pending, self.state()["active"]["pending"])
        raw = self.report(req)
        self.w.confirm_delivery(req["reference"], receipt, raw, self.observation(req, raw),
                                 self.auth("CONFIRM_DIAGNOSTIC_DELIVERY", req["reference"]))
        self.w.receive_report(raw, self.observation(req, raw), req["payload"]["request_id"], 1)
        self.w.reconcile_report(); self.final_ready(ev); self.w.project_closure()
        self.assertEqual(self.next("queued"), skipped)
        self.assertIsNone(self.state()["active"])
        self.assertEqual(self.next("new-after-closure")["target"], "PFR-C03-S02")

    def test_baseline_is_working_state_not_head_and_includes_untracked(self):
        self.session()
        self.put("Case.lean", "-- dirty fixture before current-step baseline\n")
        self.put("docs/untracked.md", "Untracked fixture note\n")
        self.assertEqual(self.next()["status"], "ACCEPTED")
        baseline = self.w.store.get(self.state()["active"]["B"], "manifest")
        self.assertEqual(baseline["git"]["head"], self.head)
        self.assertEqual(bytes.fromhex(baseline["source_bytes"]["Case.lean"]), (self.root / "Case.lean").read_bytes())
        self.assertNotEqual(bytes.fromhex(baseline["source_bytes"]["Case.lean"]), self.git("show", "HEAD:Case.lean"))
        self.assertIn("docs/untracked.md", baseline["inventory"])

    def test_missing_explicit_source_consumes_request_and_active_work_skips(self):
        self.install_bind()
        self.put("Extra.lean", "-- Explicit untracked source-copy fixture dependency.\n")
        contract = self.contract(); contract["scope"].append("Extra.lean")
        self.w = project.open_session(self.root, self.chunk, "execution", contract,
            self.user(scope="APPROVED_IMPLEMENTATION_PLAN", plan_sha256=contract["plan_sha256"]), test=True)
        (self.root / "Extra.lean").unlink()
        skipped = self.next("missing-source")
        self.assertEqual(skipped["status"], "SKIPPED_SOURCE_OR_STATE")
        self.assertTrue(skipped["consumed"]); self.assertIsNone(self.state()["active"])
        self.put("Extra.lean", "-- Explicit untracked source-copy fixture dependency.\n")
        self.assertEqual(self.next("missing-source"), skipped)
        self.assertIsNone(self.state()["active"])
        self.assertEqual(self.next("fresh-after-restoration")["target"], "PFR-C03-S01")
        prior = copy.deepcopy(self.state()["active"])
        (self.root / "Extra.lean").unlink()
        self.assertEqual(self.next("active-with-missing-source")["status"], "SKIPPED_UNCLOSED")
        self.assertEqual(self.state()["active"], prior)

    def test_missing_plan_oserror_consumes_request_before_restoration(self):
        self.session()
        original = (self.root / self.plan_path).read_bytes()
        (self.root / self.plan_path).unlink()
        skipped = self.next("missing-plan")
        self.assertEqual(skipped["status"], "SKIPPED_SOURCE_OR_STATE")
        self.assertTrue(skipped["consumed"])
        self.assertIsNone(self.state()["active"])
        (self.root / self.plan_path).write_bytes(original)
        self.assertEqual(self.next("missing-plan"), skipped)
        self.assertIsNone(self.state()["active"])
        self.assertEqual(self.next("new-after-plan-restoration")["target"], "PFR-C03-S01")

    def test_passive_plan_review_never_approves_or_selects_step(self):
        self.session("PLAN")
        req = self.w.plan_review_request(f"pfr-review:{self.chunk}:plan-fixture:first")
        self.w.plan_review_record(req["reference"], "INTENT", "Synthetic passive fixture intent", {})
        self.w.plan_review_record(req["reference"], "SUBMISSION", "Synthetic acknowledged submission",
                                self.observation(req, submission_result="ACKNOWLEDGED"))
        raw = self.report(req)
        result = self.w.plan_review_record(req["reference"], "REPORT", raw, self.observation(req, raw))
        self.assertEqual(result["classification"], "VALID")
        self.assertFalse(result["normal_step_acceptance"])
        self.assertFalse(self.w.plan_review_result()["plan_approved"])
        self.assertFalse(self.w.reconcile_plan_review("Synthetic fixture assessment retained; no implementation approval.")["plan_approved"])
        self.assertIsNone(self.state()["active"]); self.assertFalse(self.state()["completed"])
        with self.assertRaisesRegex(Refusal, "PLAN_REVIEW_NOT_EXECUTION"):
            self.next()

    def test_own_edit_and_restore_barriers_preserve_unrelated_work(self):
        self.session(); self.next()
        restored = self.w.validate_restored_binding_and_source(expected_tip=self.w.inspect()["tip"])
        self.assertFalse(restored["automatic_resume"])
        original = (self.root / "Case.lean").read_bytes()
        with self.assertRaises(Refusal): self.w.own_edit("Case.lean", "not permitted")
        with self.assertRaisesRegex(Refusal, "EDIT_SCOPE"): self.w.begin_edit(["lean-toolchain"], "Fixture forbidden edit")
        ref = self.w.begin_edit(["Case.lean"], "Fixture-owned bounded patch")
        self.assertEqual(original, (self.root / "Case.lean").read_bytes())
        self.put("Case.lean", "-- own fixture patch\n"); self.w.finish_edit(ref)
        self.put("docs/unrelated.md", "Unrelated source-copy user work\n")
        with self.assertRaisesRegex(Refusal, "REVERSAL_NOT_EXACT"): self.w.finish_reversal(ref)
        (self.root / "Case.lean").write_bytes(original); self.w.finish_reversal(ref)
        self.assertEqual((self.root / "docs/unrelated.md").read_text(), "Unrelated source-copy user work\n")
        current = self.w.inspect()
        with self.assertRaisesRegex(Refusal, "STALE_RESTORED_STATE"):
            self.w.validate_restored_binding_and_source(expected_tip="0" * 64)
        with self.assertRaisesRegex(Refusal, "RESTORED_SOURCE_CONFLICT"):
            self.w.validate_restored_binding_and_source(expected_tip=current["tip"])


if __name__ == "__main__":
    unittest.main()
