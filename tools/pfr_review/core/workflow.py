"""INACTIVE local structural model. No SDK, subprocess, network, or live adapter.

Evidence and lead decisions are explicitly supplied synthetic fixture records.
The helper verifies structure, provenance links and byte applicability, never
the truth of a mathematical assessment or authenticity of native/user identity.
"""
from __future__ import annotations

import copy
from dataclasses import asdict

from contracts import (Criterion, FactualEvidence, Identity, applicable, classify_report,
                       delta, render_request, report_key, same_source, settings, source_manifest, valid_finding)
from safe_store import Journal, Refusal, Store, TAG, canonical, digest, require, strict_json

PHASES = {"IMPLEMENTING", "INITIAL_VALIDATION", "SELF_REVIEW", "SELF_REASSESSMENT",
          "REVIEW_READY", "REVIEW_PENDING", "REPORT_CHECK", "FINDINGS_RECONCILIATION",
          "CORRECTING", "FINAL_VALIDATION", "CLOSE_READY"}


def fixture_authority(identity, action, target, contract_hash, identifier):
    require(identifier.startswith("fixture-auth:"), "AUTHORITY_ID")
    return {"schema": 1, "tag": TAG, "id": identifier, "actor": "fixture-lead",
            "binding": digest(asdict(identity)), "action": action, "target": target,
            "contract_hash": contract_hash, "provenance": "SYNTHETIC_USER_DECISION"}


class Workflow:
    # Explicit adapter policies. Defaults retain the isolated fixture contract;
    # a project adapter must supply its own validating identity and filesystem.
    tag = TAG
    fixture_only = True
    production_acceptance = False
    ingress_prefix = "fixture-ingress:"
    finding_prefix = "fixture-finding:"
    request_prefix = "fixture-review-request:"
    target_prefixes = ("TEST-S", "TEST-C", "fixture-plan:")
    plan_id = "fixture-plan:v1"
    independent_origin = "INDEPENDENT_SYNTHETIC"
    capture_provenance = "CAPTURED_SYNTHETIC_TEXT_NOT_NATIVE_OUTPUT"
    implementer_actor = "fixture-implementer"
    round_provenance = "SUPPLIED_SYNTHETIC_JUDGMENT_NOT_HEURISTIC"
    impact_provenance = "SUPPLIED_SYNTHETIC_IMPACT_JUDGMENT"

    def _settings(self):
        return settings()

    def _classify(self, state, raw, envelope, expected, seen):
        return classify_report(raw, envelope, expected, seen, tag=self.tag,
                               finding_prefix=self.finding_prefix)

    def _render(self, *args):
        return render_request(*args, tag=self.tag, request_prefix=self.request_prefix,
                              target_prefixes=self.target_prefixes)

    def _authority_origin(self, record):
        require(record["schema"] == 1 and record["tag"] == self.tag
                and record["actor"] == "fixture-lead" and record["id"].startswith("fixture-auth:")
                and record["provenance"] == "SYNTHETIC_USER_DECISION", "AUTHORITY_PROVENANCE")

    def __init__(self, fs, identity, prefix="durable"):
        identity.validate(fs)
        self.fs, self.identity = fs, identity
        self.store = Store(fs, prefix)
        self.journal = Journal(self.store)

    def _remember(self, state, kind, payload):
        ref = self.store.put(kind, payload)
        if ref not in state["records"]:
            state["records"].append(ref)
        return ref

    def _manifest(self, state, label):
        return self._remember(state, "manifest", self.current(state, label))

    def current(self, state=None, label="CURRENT"):
        state = self.inspect()["state"] if state is None else state
        return source_manifest(self.fs, label, state["fixture_baseline"], state["exclusions"])

    def _contract_hash(self, state):
        return self.current(state)["inventory"]["plan.json"]["semantic"]

    def _criteria(self, state):
        return state["plan"]["criteria"]

    def _documentation_current(self, document, current):
        return document["file_hash"] == current["inventory"]["plan.json"]["hash"]

    def _semantic_changes(self, reviewed, current):
        return [p for p in delta(reviewed, current) if p != "plan.json" or
                reviewed["inventory"].get(p, {}).get("semantic") !=
                current["inventory"].get(p, {}).get("semantic")]

    def initialize(self, steps, criteria, approval, historical=None):
        require(steps and len(set(steps)) == len(steps) and
                all(x.startswith("TEST-S") for x in steps), "STEP_SCHEMA")
        for criterion in criteria:
            criterion.validate()
        require(criteria and len({x.id for x in criteria}) == len(criteria), "CRITERION_SCHEMA")
        baseline = {x[len("project/"):]: digest(self.fs.read(x)) for x in self.fs.files("project")}
        contract = strict_json(self.fs.read("project/plan.json"))["contract"]
        state = {"schema": 5, "tag": self.tag, "fixture_only": self.fixture_only, "identity": asdict(self.identity),
                 "settings": self._settings(), "plan": {"id": self.plan_id, "steps": list(steps),
                 "contract_hash": digest(contract), "criteria": [asdict(c) for c in criteria]},
                 "records": [], "fixture_baseline": baseline, "exclusions": {}, "ingress": {},
                 "completed": {}, "active": None, "pause": False, "cancel": False,
                 "plan_restriction": None, "external_blocker": None, "historical": None, "seen_reports": {},
                 "captures": [], "authority_history": [], "finding_registry": {}, "audit": [],
                 "request_registry": {}, "progress_escalations": [], "decision_obligations": []}
        self._authority(state, approval, "APPROVE_PLAN", self.plan_id)
        if historical is not None:
            required = {"kind", "tag", "fixture_only", "historical_chunk", "accepted_revision",
                        "evidence_references", "limitations", "prerequisite_hash"}
            require(set(historical) == required and historical["tag"] == self.tag
                    and historical["fixture_only"] is self.fixture_only
                    and historical["kind"] == "PRE_AUTOMATION_ACCEPTED_BASELINE"
                    and historical["evidence_references"] and historical["limitations"], "HISTORICAL_SCHEMA")
            state["historical"] = self._remember(state, "historical", historical)
        return self.journal.initialize(state)

    def _authority(self, state, record, action, target):
        required = {"schema", "tag", "id", "actor", "binding", "action", "target", "contract_hash", "provenance"}
        require(isinstance(record, dict) and set(record) == required, "AUTHORITY_SCHEMA")
        self._authority_origin(record)
        require(record["binding"] == digest(asdict(self.identity)), "AUTHORITY_BINDING")
        require(record["action"] == action and record["target"] == target
                and record["contract_hash"] == state["plan"]["contract_hash"], "AUTHORITY_SCOPE")
        require(record["id"] not in [self.store.get(x, "authority")["id"] for x in state["authority_history"]],
                "AUTHORITY_ALREADY_CONSUMED")
        ref = self._remember(state, "authority", record)
        state["authority_history"].append(ref)
        return ref

    def _validate(self, state):
        require(isinstance(state, dict) and state.get("schema") == 5 and state.get("tag") == self.tag and
                state.get("fixture_only") is self.fixture_only, "STATE_SCHEMA")
        required = {"schema", "tag", "fixture_only", "identity", "settings", "plan", "records",
                    "fixture_baseline", "exclusions", "ingress", "completed", "active", "pause", "cancel",
                    "plan_restriction", "external_blocker", "historical", "seen_reports", "captures", "authority_history", "finding_registry", "audit", "request_registry", "progress_escalations", "decision_obligations"}
        require(set(state) == required, "STATE_SCHEMA")
        require(state.get("identity") == asdict(self.identity), "WRONG_BINDING")
        require(state.get("authority_history") and isinstance(state.get("records"), list), "MISSING_AUTHORITY")
        retained_requests = {}
        retained_escalations = []
        retained_obligations = []
        reconciliations = {}
        acceptances = {}
        accepted_requests = {}
        episodes = {}
        for ref in state["records"]:
            record = self.store.get(ref)
            if isinstance(record, dict) and record.get("acceptance_kind") == "APPLICABLE_INDEPENDENT_REPORT":
                acceptance = self._acceptance(state, ref)
                require(acceptance["request"] not in accepted_requests, "DUPLICATE_REPORT_ACCEPTANCE")
                accepted_requests[acceptance["request"]] = acceptance["report"]
                acceptances.setdefault(acceptance["step"], []).append(acceptance["report"])
            if isinstance(record, dict) and "progress_decision" in record:
                decision = self.store.get(ref, "round_decision")
                require(decision["progress_decision"] in {"PRODUCTIVE", "ESCALATE_NONPROGRESS", "ESCALATE_OSCILLATION", "ESCALATE_INCOMPATIBLE"}, "PROGRESS_DECISION")
                if decision["progress_decision"] != "PRODUCTIVE":
                    retained_escalations.append(ref)
                    retained_obligations.append(ref)
            if isinstance(record, dict) and "decision_requirement" in record:
                obligation = self.store.get(ref, "decision_obligation")
                require(obligation["decision_requirement"] in {"FINDING_ESCALATION", "EXPLICIT_SUBSTANTIVE_STOP"}
                        and obligation["step"] in state["plan"]["steps"], "DECISION_OBLIGATION_SCHEMA")
                retained_obligations.append(ref)
            if isinstance(record, dict) and record.get("reconciliation_kind") == "ACCEPTED_INDEPENDENT_REPORT":
                reconciliation = self._reconciliation(state, ref)
                reconciliations.setdefault(reconciliation["step"], []).append(ref)
            if isinstance(record, dict) and record.get("episode_kind") == "INDEPENDENT_REOPENING":
                episode = self.store.get(ref, "finding_reopening")
                self._reconciliation(state, episode["reconciliation"])
                episodes[(episode["step"], episode["finding_id"])] = ref
            if isinstance(record, dict) and set(record) == {"payload", "text", "round_decision", "validation"}:
                payload = self.store.get(ref, "review_request")["payload"]
                require(payload["request_id"] not in retained_requests, "REQUEST_ID_REUSED")
                retained_requests[payload["request_id"]] = ref
        require(state["progress_escalations"] == retained_escalations, "ESCALATION_REGISTRY_MISMATCH")
        require(state["decision_obligations"] == retained_obligations, "DECISION_REGISTRY_MISMATCH")
        require(isinstance(state["request_registry"], dict), "REQUEST_REGISTRY_SCHEMA")
        require(set(state["request_registry"]) == set(retained_requests), "REQUEST_REGISTRY_MISSING")
        for request_id, registration in state["request_registry"].items():
            require(isinstance(registration, dict) and set(registration) ==
                    {"ref", "target", "attempt", "status", "dispatched"}
                    and type(registration["dispatched"]) is bool
                    and isinstance(registration["status"], str), "REQUEST_REGISTRY_SCHEMA")
            require(registration["ref"] == retained_requests[request_id], "REQUEST_ASSOCIATION_CHANGED")
            payload = self.store.get(registration["ref"], "review_request")["payload"]
            require(payload["request_id"] == request_id and payload["binding"] == asdict(self.identity)
                    and payload["target_id"] == registration["target"]
                    and payload["attempt"] == registration["attempt"], "REQUEST_ASSOCIATION_CHANGED")
            require(registration["status"] in {"READY", "PENDING", "FAILED", "ACCEPTED", "CANCELLED", "SUPERSEDED"}, "REQUEST_STATUS")
            if registration["status"] == "ACCEPTED":
                require(registration["ref"] in accepted_requests, "ACCEPTANCE_RECORD_MISSING")
        require(all(ref in accepted_requests.values() for ref in state["captures"]
                    if self.store.get(ref, "capture")["classification"] == "VALID"), "ACCEPTANCE_RECORD_MISSING")
        require(set(state["completed"]).issubset(state["plan"]["steps"]), "CROSS_CHUNK_STATE")
        closed = list(state["completed"])
        require(set(closed) == set(state["plan"]["steps"][:len(closed)]), "NONCONTIGUOUS_CLOSURE")
        for step, ref in state["completed"].items():
            cert = self.store.get(ref, "closure")
            require(cert.get("tag") == self.tag and cert.get("fixture_only") is self.fixture_only and
                    cert.get("step") == step and cert.get("production_acceptance") is self.production_acceptance,
                    "CLOSURE_SCHEMA")
            require(all(key in cert for key in ("F", "review", "self_review", "reassessment",
                    "criteria", "validation", "documentation", "authorization")), "CLOSURE_EVIDENCE")
            for key, kind in (("F", "manifest"), ("review", "capture"), ("self_review", "self_review"),
                              ("reassessment", "reassessment"), ("documentation", "documentation"),
                              ("authorization", "ingress_authorization")):
                self.store.get(cert[key], kind)
            self._review_history(state, step, cert["reconciliations"], cert["review_history"],
                                 cert["findings"], cert["initial_handoff"], reconciliations, episodes, acceptances)
            self._report_coverage(cert["review_history"], cert["reconciliations"])
            require(cert["review_history"] and cert["review"] == cert["review_history"][-1], "ACCEPTED_REPORT_POINTER")
        active = state.get("active")
        if active is not None:
            require(active["phase"] in PHASES and active["step"] in state["plan"]["steps"]
                    and active["step"] not in state["completed"], "ACTIVE_STATE")
            for ref in active["requests"]:
                payload = self.store.get(ref, "review_request")["payload"]
                require(state["request_registry"].get(payload["request_id"], {}).get("ref") == ref
                        and payload["target_id"] == active["step"], "REQUEST_REGISTRY_MISSING")
            if active["pending"]:
                entry = self._registration(state, active["pending"]["request"])
                require(entry["status"] == active["pending"]["status"], "REQUEST_STATUS_CONTRADICTION")
            if active["initial_handoff"]:
                handoff = self.store.get(active["initial_handoff"], "self_handoff")
                require(handoff["step"] == active["step"] and handoff["request"] in active["requests"]
                        and handoff["self_review"] == active["self_review"]
                        and handoff["reassessment"] == active["reassessment"], "INITIAL_HANDOFF_ASSOCIATION")
            self._review_history(state, active["step"], active["reconciliations"], active["reports"],
                                 active["findings"], active["initial_handoff"], reconciliations, episodes, acceptances)
            require(active["report"] == (active["reports"][-1] if active["reports"] else None), "ACCEPTED_REPORT_POINTER")
        return state

    def _acceptance(self, state, ref):
        record = self.store.get(ref, "review_acceptance")
        require(set(record) == {"tag", "acceptance_kind", "step", "report", "request", "source"}, "ACCEPTANCE_SCHEMA")
        capture = self.store.get(record["report"], "capture")
        request = self.store.get(record["request"], "review_request")["payload"]
        parsed = capture["parsed"]
        registration = self._registration(state, record["request"])
        require(record["tag"] == self.tag and record["acceptance_kind"] == "APPLICABLE_INDEPENDENT_REPORT"
                and record["report"] in state["captures"]
                and capture["classification"] in {"VALID", "LATE_VALID_REPORT"}
                and capture["request_ref"] == record["request"]
                and request["binding"] == asdict(self.identity)
                and request["target_id"] == record["step"] in state["plan"]["steps"]
                and parsed["request_id"] == request["request_id"]
                and parsed["attempt"] == request["attempt"]
                and parsed["kind"] == request["kind"] == "STEP"
                and parsed["binding_digest"] == digest(asdict(self.identity))
                and parsed["source_ref"] == record["source"] == request["source_ref"]
                and registration["dispatched"]
                and registration["status"] in {"ACCEPTED", "CANCELLED", "SUPERSEDED"}, "ACCEPTANCE_ASSOCIATION")
        return record

    def _report_coverage(self, reports, reconciliations):
        handled = [self.store.get(ref, "review_reconciliation")["report"] for ref in reconciliations]
        require(len(handled) == len(set(handled)), "DUPLICATE_REPORT_RECONCILIATION")
        pending = [ref for ref in reports if ref not in handled]
        require(not pending, "REPORT_RECONCILIATION_REQUIRED", "Accepted reports awaiting reconciliation: " + ", ".join(pending))

    def _reconciliation_barrier(self, state):
        # Derive obligations from committed immutable facts, not mutable current
        # request/phase/history projections. Normal REPORT_CHECK stays valid.
        reports, reconciliations = [], []
        for ref in state["records"]:
            record = self.store.get(ref)
            if isinstance(record, dict):
                if record.get("acceptance_kind") == "APPLICABLE_INDEPENDENT_REPORT":
                    reports.append(record["report"])
                if record.get("reconciliation_kind") == "ACCEPTED_INDEPENDENT_REPORT":
                    reconciliations.append(ref)
        self._report_coverage(reports, reconciliations)

    def _accept_report(self, state, a, capture):
        # Called only after admissibility checks; acceptance and its durable
        # obligation commit together. Deferred/invalid captures alone do not count.
        self._reconciliation_barrier(state)
        require(capture not in a["reports"], "DUPLICATE_REPORT_ACCEPTANCE")
        self._remember(state, "review_acceptance", {"tag": self.tag,
            "acceptance_kind": "APPLICABLE_INDEPENDENT_REPORT", "step": a["step"],
            "report": capture, "request": a["pending"]["request"], "source": a["R"]})
        a["report"] = capture
        a["reports"].append(capture)
        self._request_status(state, "ACCEPTED")
        a["phase"] = "REPORT_CHECK"

    def _reconciliation(self, state, ref):
        require(ref in state["records"], "RECONCILIATION_MISSING")
        record = self.store.get(ref, "review_reconciliation")
        capture = self.store.get(record["report"], "capture")
        request = self.store.get(record["request"], "review_request")["payload"]
        parsed = capture["parsed"]
        require(record["tag"] == self.tag and record["reconciliation_kind"] == "ACCEPTED_INDEPENDENT_REPORT"
                and record["report"] in state["captures"]
                and capture["classification"] in {"VALID", "LATE_VALID_REPORT"}
                and capture["request_ref"] == record["request"]
                and request["binding"] == asdict(self.identity)
                and request["target_id"] == record["step"]
                and parsed["request_id"] == request["request_id"]
                and parsed["attempt"] == request["attempt"]
                and parsed["kind"] == request["kind"] == "STEP"
                and parsed["binding_digest"] == digest(asdict(self.identity))
                and parsed["source_ref"] == record["source"] == request["source_ref"]
                and self._registration(state, record["request"])["dispatched"], "RECONCILIATION_ASSOCIATION")
        self._reconciliation_findings(state, record)
        return record

    def _reconciliation_findings(self, state, record):
        """Original findings unless a source adapter validates an explicit correction."""
        require("identity_correction" not in record, "UNSUPPORTED_IDENTITY_CORRECTION")
        return self.store.get(record["report"], "capture")["parsed"]["findings"]

    def _review_history(self, state, step, refs, reports, findings, handoff, reconciliations, episodes, acceptances):
        require(reports == acceptances.get(step, []), "ACCEPTANCE_HISTORY_MISMATCH")
        require(refs == reconciliations.get(step, []), "RECONCILIATION_REGISTRY_MISMATCH")
        require(all(self.store.get(ref, "review_reconciliation")["report"] in reports for ref in refs),
                "RECONCILIATION_HISTORY_MISMATCH")
        for finding_id, finding in findings.items():
            for index, entry in enumerate(finding["history"]):
                if entry["status"] == "ESCALATED":
                    ref = entry.get("obligation")
                    require(ref in state["decision_obligations"] and ref in state["records"], "FINDING_OBLIGATION_MISSING")
                    obligation = self.store.get(ref, "decision_obligation")
                    require(obligation["decision_requirement"] == "FINDING_ESCALATION"
                            and obligation["step"] == step and obligation["finding_id"] == finding_id
                            and obligation["claim"] == finding["original"]["claim"]
                            and obligation["history_index"] == index
                            and obligation["disposition"] == {k: v for k, v in entry.items() if k != "obligation"},
                            "FINDING_OBLIGATION_ASSOCIATION")
            expected = episodes.get((step, finding_id))
            if expected:
                episode = self.store.get(expected, "finding_reopening")
                require(episode["reconciliation"] in refs and episode["initial_handoff"] == handoff
                        and episode["claim"] == finding["original"]["claim"], "REOPENING_ASSOCIATION")
                r = self._reconciliation(state, episode["reconciliation"])
                appearance_index, history_index = episode["appearance_index"], episode["history_index"]
                require(type(appearance_index) is int and 0 <= appearance_index < len(finding["appearances"])
                        and type(history_index) is int and 0 <= history_index < len(finding["history"]),
                        "REOPENING_ASSOCIATION")
                appearance = finding["appearances"][appearance_index]
                require(appearance["origin"] == self.independent_origin and appearance["step"] == step
                        and appearance["source"] == episode["source"] == r["source"]
                        and appearance["reported"]["id"] == finding_id
                        and appearance["reported"] in self._reconciliation_findings(state, r)
                        and finding["history"][history_index]["status"] == "OPEN", "REOPENING_ASSOCIATION")
                # A no-new-findings report does not change this episode. Closing
                # it and later reopening it ourselves does; old provenance is not
                # authority for that new episode, even with the same stable ID.
                if (appearance_index != len(finding["appearances"]) - 1
                        or any(h["status"] != "OPEN" for h in finding["history"][history_index:])):
                    expected = None
            require(finding["reopening_episode"] == expected, "REOPENING_EPISODE_MISMATCH")

    def _registration(self, state, ref):
        payload = self.store.get(ref, "review_request")["payload"]
        entry = state["request_registry"].get(payload["request_id"])
        require(entry is not None and entry["ref"] == ref, "REQUEST_REGISTRY_MISSING")
        return entry

    def _request_status(self, state, status):
        pending = state["active"]["pending"]
        self._registration(state, pending["request"])["status"] = status
        pending["status"] = status

    def _capture_barrier(self, state):
        # Persistent facts, not the last mutable blocker string. No adjudicator
        # or unclassified-input recovery is implemented by this revision.
        codes = {self.store.get(ref, "capture")["classification"] for ref in state["captures"]}
        require("UNCLASSIFIED" not in codes, "UNCLASSIFIED_REPORT_CAPTURE")
        require("CONFLICTING_DUPLICATE" not in codes, "REPORT_CONFLICT_UNRESOLVED")

    def _decision_barrier(self, state):
        # No substantive lead adjudication is implemented. Transient wording,
        # transport authority and source restoration cannot discharge these facts.
        require(not state["progress_escalations"], "PROGRESS_DECISION_REQUIRED",
                "Unresolved round decisions: " + ", ".join(state["progress_escalations"]))
        if state["decision_obligations"]:
            first = self.store.get(state["decision_obligations"][0], "decision_obligation")
            # Preserve the prior explicit-stop refusal code, but not its former
            # dependence on whichever transient blocker happens to be visible.
            code = ("RECOVERY_BLOCKER_UNSUPPORTED" if first["decision_requirement"] == "EXPLICIT_SUBSTANTIVE_STOP"
                    else "LEAD_DECISION_REQUIRED")
            require(False, code, "Unresolved substantive decisions (no discharge API): "
                    + ", ".join(state["decision_obligations"]))

    def inspect(self):
        result = self.journal.load()
        self._validate(result["state"])
        return result

    def _change(self, operation, fn, expected=None, fault=None):
        current = self.inspect()
        expected = current["rev"] if expected is None else expected
        def change(state):
            self._validate(state)
            fn(state)
            self._validate(state)
            return state
        return self.journal.transact(expected, operation, change, fault)

    def _active(self, state, phases=None, allow_blocked=False, adding_obligation=False):
        active = state["active"]
        require(active is not None, "NO_ACTIVE_STEP")
        require(phases is None or active["phase"] in phases, "FORBIDDEN_PHASE", active["phase"])
        if not allow_blocked:
            require(not state["pause"] and not state["cancel"] and not state["plan_restriction"], "AUTHORITY_PAUSED")
            require(state["external_blocker"] is None, "EXTERNAL_BLOCKER")
            self._capture_barrier(state)
            if not adding_obligation:
                self._decision_barrier(state)
                require(active["blocker"] is None, "WORKFLOW_BLOCKED", str(active["blocker"]))
        return active

    def _prerequisites(self, state):
        self._reconciliation_barrier(state)
        if state["historical"]:
            historical = self.store.get(state["historical"], "historical")
            require(digest(self.fs.read("project/prerequisite.json")) == historical["prerequisite_hash"],
                    "HISTORICAL_CONFLICT")
        require(self._contract_hash(state) == state["plan"]["contract_hash"],
                "CONTRACT_CHANGED")
        if state["completed"]:
            step = state["plan"]["steps"][len(state["completed"]) - 1]
            final = self.store.get(self.store.get(state["completed"][step], "closure")["F"], "manifest")
            require(same_source(final, self.current(state)), "CLOSED_SOURCE_DIVERGED")

    def process_next(self, message_id, text, approval, expected=None):
        require(isinstance(message_id, str) and message_id.startswith(self.ingress_prefix), "AMBIGUOUS_INGRESS_ID")
        require(isinstance(text, str) and text.strip(), "EMPTY_REQUEST")
        # Separate rejection ledger preserves consumption even if workflow state
        # cannot be read. It is not a favorable reconstructed state projection.
        refusal_path = f"{self.store.prefix}/refused-ingress/{digest(message_id)}.json"
        identity = {"id": message_id, "text": text, "binding": digest(asdict(self.identity))}
        if self.fs.path(refusal_path).exists():
            prior = strict_json(self.fs.read(refusal_path))
            require(prior["identity"] == identity, "AMBIGUOUS_REDELIVERY")
            return prior["disposition"]
        try:
            self.inspect()
        except Refusal as exc:
            result = {"status": "SKIPPED_INVALID_STATE", "reason": exc.code, "target": None, "consumed": True}
            self.fs.write(refusal_path, canonical({"tag": self.tag, "identity": identity, "disposition": result}), exclusive=True)
            return result
        output = {}
        def action(state):
            if message_id in state["ingress"]:
                old = state["ingress"][message_id]
                require(old["identity"] == identity, "AMBIGUOUS_REDELIVERY")
                output.update(old["disposition"])
                return
            disposition = {"status": "ACCEPTED", "reason": None, "target": None, "consumed": True}
            if state["active"] is not None:
                disposition.update(status="SKIPPED_UNCLOSED", reason=state["active"]["blocker"] or state["active"]["phase"])
            elif state["external_blocker"]:
                disposition.update(status="SKIPPED_UNCLOSED", reason=state["external_blocker"])
            elif state["pause"] or state["cancel"]:
                disposition.update(status="SKIPPED_PAUSED", reason="EXPLICIT_PAUSE_OR_CANCEL")
            elif state["plan_restriction"]:
                disposition.update(status="SKIPPED_AUTHORITY", reason="MATERIAL_PLAN_REVISION")
            else:
                try:
                    self._capture_barrier(state)
                    self._decision_barrier(state)
                    self._prerequisites(state)
                    self._authority(state, approval, "NEXT_STEP", state["plan"]["id"])
                except Refusal as exc:
                    disposition.update(status="SKIPPED_AUTHORITY", reason=exc.code)
            if disposition["status"] == "ACCEPTED":
                if len(state["completed"]) == len(state["plan"]["steps"]):
                    disposition.update(status="NO_ELIGIBLE_STEP", reason="CHUNK_FINISHED")
                else:
                    target = state["plan"]["steps"][len(state["completed"])]
                    disposition["target"] = target
                    authorization = self._remember(state, "ingress_authorization",
                        {"tag": self.tag, "fixture_only": self.fixture_only, "ingress": identity, "target": target,
                         "authority": state["authority_history"][-1], "plan": copy.deepcopy(state["plan"])})
                    state["active"] = {"step": target, "phase": "IMPLEMENTING", "blocker": None,
                        "authorization": authorization, "B": self._manifest(state, "B"), "R": None, "F": None,
                        "evidence": [], "self_review": None, "reassessment": None, "findings": {},
                        "assessments": {}, "pending": None, "requests": [], "reports": [], "report": None,
                        "documentation": None, "edits": [], "rounds": [], "initial_handoff": None,
                        "reconciliations": []}
            state["ingress"][message_id] = {"identity": identity, "disposition": disposition}
            output.update(disposition)
        self._change("PROCESS_CONDITIONAL_REQUEST", action, expected)
        return output

    def control(self, mode, approval):
        require(mode in ("PAUSE", "CANCEL", "RELEASE"), "CONTROL_MODE")
        def action(state):
            self._authority(state, approval, mode, state["plan"]["id"])
            if mode == "RELEASE":
                state["pause"] = state["cancel"] = False
            else:
                state["pause"] = True
                if mode == "CANCEL":
                    state["cancel"] = True
                if state["active"] and mode == "CANCEL":
                    state["active"]["blocker"] = "CANCELLED"
                    if state["active"]["pending"]:
                        self._request_status(state, "CANCELLED")
        return self._change(mode, action)

    def mark_plan_revision(self, new_contract_hash):
        def action(state):
            state["plan_restriction"] = {"old": state["plan"]["contract_hash"], "proposed": new_contract_hash,
                                         "decision": "LEAD_APPLICABILITY_REQUIRED"}
        return self._change("PLAN_REVISION_RESTRICTION", action)

    def resolve_plan_revision(self, approval, *, retain_original=False):
        require(retain_original, "UNSUPPORTED_MATERIAL_PLAN_REPLACEMENT")
        def action(state):
            self._authority(state, approval, "RETAIN_ORIGINAL_PLAN", state["plan"]["id"])
            require(self._contract_hash(state) == state["plan"]["contract_hash"],
                    "CONTRACT_CHANGED")
            state["plan_restriction"] = None
        return self._change("PLAN_DECISION", action)

    def block(self, reason):
        require(isinstance(reason, str) and reason, "BLOCK_REASON")
        def action(state):
            a = self._active(state, allow_blocked=True)
            if reason in {"LEAD_DECISION_REQUIRED", "PROGRESS_DECISION_REQUIRED"}:
                ref = self._remember(state, "decision_obligation", {"tag": self.tag,
                    "decision_requirement": "EXPLICIT_SUBSTANTIVE_STOP", "step": a["step"],
                    "reason": reason, "sequence": len(state["decision_obligations"]),
                    "source": self._manifest(state, "SUBSTANTIVE_STOP_SOURCE")})
                state["decision_obligations"].append(ref)
            a["blocker"] = reason
        return self._change("BLOCK", action)

    def recover(self, approval, mode="continue"):
        require(mode in ("continue", "retry", "reconcile"), "RECOVERY_MODE")
        def action(state):
            a = self._active(state, allow_blocked=True)
            self._authority(state, approval, "RECOVER_" + mode.upper(), a["step"])
            require(not state["pause"] and not state["cancel"] and not state["plan_restriction"], "AUTHORITY_PAUSED")
            require(state["external_blocker"] is None, "EXTERNAL_BLOCKER")
            self._capture_barrier(state)
            self._decision_barrier(state)
            require(a["blocker"] is not None or (mode == "reconcile" and a["pending"]
                    and a["pending"].get("late_capture")), "NO_RECOVERY_NEEDED")
            if a["pending"]:
                status = a["pending"]["status"]
                require(status not in {"CANCELLED", "SUPERSEDED"}, "REQUEST_REACTIVATION_UNSUPPORTED")
                if mode == "retry":
                    self._reconciliation_barrier(state)
                    require(a["blocker"] in {"REVIEW_FAILED", "SUSPENDED", "SOURCE_DIVERGED", "DISPATCH_UNCERTAIN"}, "RECOVERY_BLOCKER_UNSUPPORTED")
                    self._request_status(state, "SUPERSEDED")
                    a["pending"] = None
                    a["phase"] = "REVIEW_READY"
                elif mode == "reconcile":
                    require(a["pending"].get("late_capture"), "NO_LATE_REPORT")
                    require(a["blocker"] in {None, "SUSPENDED", "DISPATCH_UNCERTAIN"}, "RECOVERY_BLOCKER_UNSUPPORTED")
                    self._admissible_report(state, a, a["pending"]["late_capture"], deferred=True)
                    self._accept_report(state, a, a["pending"]["late_capture"])
                else:
                    require(status in {"PENDING", "ACCEPTED"}, "EXPLICIT_RETRY_OR_RECONCILIATION_REQUIRED")
                    require(a["blocker"] in {"SUSPENDED", "DISPATCH_UNCERTAIN"}, "RECOVERY_BLOCKER_UNSUPPORTED")
                    if status == "ACCEPTED":
                        self._admissible_report(state, a, a["report"], accepted=True)
                        # Resume this exact report/phase; no new acceptance,
                        # reconciliation, disposition or implicit completion.
            else:
                require(mode == "continue" and a["blocker"] not in {"LEAD_DECISION_REQUIRED", "PROGRESS_DECISION_REQUIRED", "CANCELLED"}, "RECOVERY_BLOCKER_UNSUPPORTED")
            a["blocker"] = None  # still unclosed; this does not imply completion
        return self._change("EXPLICIT_RECOVERY", action)

    def add_evidence(self, method, *, outcome="PASS", limitations="Synthetic observation; no model assessed it."):
        result = []
        def action(state):
            a = self._active(state)
            require(a["phase"] not in ("REVIEW_PENDING", "CLOSE_READY"), "EVIDENCE_PHASE")
            require(method and limitations is not None and outcome in ("PASS", "FAIL"), "EVIDENCE_SCHEMA")
            source = self._manifest(state, "EVIDENCE_SOURCE")
            ref = self._remember(state, "evidence", {"schema": 1, "tag": self.tag, "actor": self.implementer_actor,
                "source": source, "method": method, "outcome": outcome, "limitations": limitations})
            a["evidence"].append(ref)
            result.append(ref)
        self._change("VALIDATION_EVIDENCE", action)
        return result[0]

    def _evidence(self, state, refs, current):
        require(isinstance(refs, list) and refs, "EVIDENCE_REQUIRED")
        for ref in refs:
            require(ref in state["records"], "UNKNOWN_EVIDENCE")
            ev = self.store.get(ref, "evidence")
            applicable(ev, self.store.get(ev["source"], "manifest"), current, tag=self.tag)

    def _report_evidence(self, state, parsed, reviewed):
        # Legacy fixture policy remains passing-only. The diagnostic adapter
        # separates observation applicability from criterion success explicitly.
        self._evidence(state, parsed["verification"], reviewed)

    def initial_validation(self, refs):
        def action(state):
            a = self._active(state, {"IMPLEMENTING"})
            self._evidence(state, refs, self.current(state))
            a["phase"] = "INITIAL_VALIDATION"
        return self._change("INITIAL_VALIDATION", action)

    def _findings(self, state, findings, origin, source, reconciliation=None):
        a = state["active"]
        require(isinstance(findings, list) and all(valid_finding(f, prefix=self.finding_prefix) for f in findings), "FINDING_SCHEMA")
        require(len({f["id"] for f in findings}) == len(findings), "DUPLICATE_FINDING_ID")
        for finding in findings:
            require(finding["id"].startswith(self.finding_prefix), "FINDING_ID")
            old = a["findings"].get(finding["id"])
            if old is None and finding["id"] in state["finding_registry"]:
                old = copy.deepcopy(self.store.get(state["finding_registry"][finding["id"]], "finding_history"))
                a["findings"][finding["id"]] = old
            if old:
                require(old["original"]["claim"] == finding["claim"],
                        "FINDING_ID_COLLISION")
                old["appearances"].append({"source": source, "origin": origin, "label": finding["label"],
                                           "reported": copy.deepcopy(finding), "step": a["step"]})
                if old["material"] != finding["material"]:
                    old["pending_assessment"].append({"source": source, "origin": origin,
                                                       "reported": copy.deepcopy(finding)})
                # Repeated material concerns are open again unless freshly adjudicated.
                old["history"].append({"status": "OPEN", "reason": "Repeated concern requires current disposition", "evidence": []})
            else:
                a["findings"][finding["id"]] = {"original": copy.deepcopy(finding), "material": finding["material"],
                    "pending_assessment": [], "assessments": [], "reopening_episode": None,
                    "origin": origin, "appearances": [{"source": source, "origin": origin, "label": finding["label"],
                        "reported": copy.deepcopy(finding), "step": a["step"]}],
                    "history": [{"status": "OPEN", "reason": "Original finding", "evidence": []}]}
            current = a["findings"][finding["id"]]
            current["reopening_episode"] = None
            if origin == self.independent_origin:
                require(reconciliation in a["reconciliations"] and a["initial_handoff"], "RECONCILIATION_MISSING")
                current["reopening_episode"] = self._remember(state, "finding_reopening", {
                    "tag": self.tag, "episode_kind": "INDEPENDENT_REOPENING", "step": a["step"],
                    "finding_id": finding["id"], "claim": finding["claim"], "source": source,
                    "initial_handoff": a["initial_handoff"], "reconciliation": reconciliation,
                    "appearance_index": len(current["appearances"]) - 1,
                    "history_index": len(current["history"]) - 1})

    def reassess_finding(self, finding_id, material, reason, evidence, *, approval=None,
                         affected_closed_steps=None):
        """Explicit current assessment; immutable originals and closures remain.

        A supplied impact judgment is not a mathematical oracle. Historical-only
        changes automatically block their owning closures; current-step changes
        record any declared earlier impact. Reopening those closures is unsupported.
        """
        require(type(material) is bool and isinstance(reason, str) and reason.strip(), "REASSESSMENT_SCHEMA")
        affected = [] if affected_closed_steps is None else list(affected_closed_steps)
        def action(state):
            require(not state["pause"] and not state["cancel"] and not state["plan_restriction"], "AUTHORITY_PAUSED")
            self._capture_barrier(state)
            self._decision_barrier(state)
            a = state["active"]
            require(a is None or a["phase"] in {"SELF_REASSESSMENT", "REVIEW_READY", "FINDINGS_RECONCILIATION", "CORRECTING", "FINAL_VALIDATION"}, "REASSESSMENT_PHASE")
            current_finding = a is not None and finding_id in a["findings"]
            if current_finding:
                finding = a["findings"][finding_id]
            else:
                require(finding_id in state["finding_registry"], "UNKNOWN_FINDING")
                finding = copy.deepcopy(self.store.get(state["finding_registry"][finding_id], "finding_history"))
            owners = [step for step, ref in state["completed"].items()
                      if finding_id in self.store.get(ref, "closure")["findings"]]
            affected_now = affected if current_finding else owners
            require(all(isinstance(x, str) and x in owners for x in affected_now), "HISTORICAL_IMPACT_SCOPE")
            risk_material = finding["material"] or any(x["reported"]["material"] for x in finding["pending_assessment"])
            authority = None
            if (risk_material and not material) or affected_now:
                authority = self._authority(state, approval, "REASSESS_FINDING", finding_id)
            self._evidence(state, evidence, self.current(state))
            decision = self._remember(state, "finding_assessment", {"tag": self.tag,
                "finding_id": finding_id, "claim": finding["original"]["claim"],
                "actor": self.implementer_actor, "source": self._manifest(state, "FINDING_REASSESSMENT_SOURCE"),
                "before_material": finding["material"], "material": material, "reason": reason,
                "evidence": list(evidence), "authority": authority,
                "pending_assessment": copy.deepcopy(finding["pending_assessment"]),
                "affected_closed_steps": affected_now, "current_step": a["step"] if current_finding else None})
            finding["assessments"].append(decision)
            finding["material"] = material
            finding["pending_assessment"] = []
            if finding["history"][-1]["status"] != "OPEN":
                finding["reopening_episode"] = None
            finding["history"].append({"status": "OPEN", "reason": "Explicit reassessment requires fresh disposition",
                                       "evidence": [], "assessment": decision})
            if not current_finding or affected_now:
                state["finding_registry"][finding_id] = self._remember(state, "finding_history", finding)
            if affected_now:
                state["external_blocker"] = "HISTORICAL_FINDING_REASSESSMENT"
                state["audit"].append(decision)
        return self._change("EXPLICIT_FINDING_REASSESSMENT", action)

    def _finding_exit(self, state, finding, current):
        require(not finding["pending_assessment"], "FINDING_REASSESSMENT_REQUIRED")
        latest = finding["history"][-1]
        if finding["material"]:
            require(latest["status"] in {"RESOLVED", "REFUTED_WITH_EVIDENCE"}, "MATERIAL_FINDING_OPEN")
        else:
            require(latest["status"] in {"RESOLVED", "REFUTED_WITH_EVIDENCE", "OPTIONAL_DECLINED", "OPTIONAL_DEFERRED"}, "FINDING_UNDISPOSED")
        if latest["status"] in {"RESOLVED", "REFUTED_WITH_EVIDENCE"}:
            self._evidence(state, latest["evidence"], current)

    def _round_for_attempt(self, state, a, attempt):
        if a["rounds"]:
            last = a["rounds"][-1]
            if self.store.get(last, "round_decision")["next_attempt"] == attempt:
                return last
        if a["requests"]:
            previous = a["requests"][-1]
            record = self.store.get(previous, "review_request")
            if (self._registration(state, previous)["status"] == "SUPERSEDED"
                    and record["payload"]["attempt"] + 1 == attempt):
                return record["round_decision"]  # same causal round, not new approval
        return None

    def _self_exit(self, state, a, validation, round_ref=None):
        require(a["self_review"] and a["reassessment"], "SELF_REVIEW_REQUIRED")
        require(all(x["status"] in {"APPLIED", "REVERSED"} for x in a["edits"]), "UNFINISHED_EDIT")
        current = self.current(state)
        self._evidence(state, validation, current)
        review = self.store.get(a["self_review"], "self_review")
        round_data = None
        if round_ref:
            require(round_ref in a["rounds"] and a["initial_handoff"], "ADDITIONAL_REVIEW_LINK")
            round_data = self.store.get(round_ref, "round_decision")
            require(round_data["progress_decision"] == "PRODUCTIVE", "PROGRESS_DECISION_REQUIRED")
            require(round_data["step"] == a["step"] and round_data["initial_handoff"] == a["initial_handoff"]
                    and round_data["prior_review"] == a["report"]
                    and round_data["prior_review"] in a["reports"]
                    and round_data["latest_reconciliation"] == a["reconciliations"][-1]
                    and self._reconciliation(state, round_data["latest_reconciliation"])["report"] == a["report"],
                    "ADDITIONAL_REVIEW_LINK")
            require(same_source(self.store.get(round_data["source"], "manifest"), current), "ROUND_SOURCE_MISMATCH")
            for finding_id, fingerprint in round_data["target_findings"].items():
                require(digest(a["findings"][finding_id]) == fingerprint, "ADDITIONAL_FINDING_CHANGED")
                require(not a["findings"][finding_id]["pending_assessment"], "FINDING_REASSESSMENT_REQUIRED")
        for original in review["recommendations"]:
            finding = a["findings"][original["id"]]
            if round_data and original["id"] in round_data["findings"] and finding["history"][-1]["status"] == "OPEN":
                handoff = self.store.get(a["initial_handoff"], "self_handoff")
                require(not finding["pending_assessment"], "FINDING_REASSESSMENT_REQUIRED")
                episode_ref = finding["reopening_episode"]
                require(episode_ref and round_data["reopening_episodes"][original["id"]] == episode_ref,
                        "INDEPENDENT_REOPEN_REQUIRED")
                episode = self.store.get(episode_ref, "finding_reopening")
                require(episode["step"] == a["step"] and episode["finding_id"] == original["id"]
                        and episode["claim"] == original["claim"]
                        and episode["reconciliation"] in a["reconciliations"], "INDEPENDENT_REOPEN_REQUIRED")
                self._finding_exit(state, handoff["findings"][original["id"]], self.store.get(handoff["source"], "manifest"))
                continue  # open targeted concern remains a final-closure blocker
            self._finding_exit(state, finding, current)

    def self_review(self, recommendations, narrative):
        def action(state):
            a = self._active(state, {"INITIAL_VALIDATION"})
            source = self._manifest(state, "SELF_REVIEW_SOURCE")
            a["self_review"] = self._remember(state, "self_review", {"tag": self.tag, "source": source,
                "recommendations": recommendations, "narrative": narrative, "phase": "READ_ONLY_SECTIONS_1_TO_7"})
            self._findings(state, recommendations, "SELF", source)
            a["phase"] = "SELF_REVIEW"
        return self._change("SELF_REVIEW_RECOMMENDATIONS_BEFORE_EDITS", action)

    def reassess(self, decisions):
        def action(state):
            a = self._active(state, {"SELF_REVIEW"})
            review = self.store.get(a["self_review"], "self_review")
            require(same_source(self.store.get(review["source"], "manifest"), self.current(state)), "EDIT_BEFORE_REASSESSMENT")
            require(set(decisions) == {x["id"] for x in review["recommendations"]}, "REASSESSMENT_INCOMPLETE")
            require(all(isinstance(v, str) and v.strip() for v in decisions.values()), "REASSESSMENT_REASON")
            a["reassessment"] = self._remember(state, "reassessment", {"tag": self.tag,
                "original": a["self_review"], "decisions": decisions, "independent": False})
            a["phase"] = "SELF_REASSESSMENT"
        return self._change("IMPLEMENTER_SECOND_DECISION_PASS", action)

    def own_edit(self, path, content):
        require(path.startswith("project/") and path != "project/plan.json"
                and path != "project/environment.json", "EDIT_SCOPE")
        patch = {}
        def intent(state):
            a = self._active(state, {"IMPLEMENTING", "SELF_REASSESSMENT", "CORRECTING"})
            before = self.fs.read(path)
            after = content.encode() if isinstance(content, str) else content
            ref = self._remember(state, "own_edit", {"tag": self.tag, "path": path,
                "before": before.hex(), "after": after.hex(), "before_hash": digest(before), "after_hash": digest(after)})
            a["edits"].append({"ref": ref, "status": "INTENT"})
            patch.update(ref=ref, before=before, after=after)
        self._change("OWN_EDIT_INTENT", intent)
        require(self.fs.read(path) == patch["before"], "INTERVENING_EDIT")
        self.fs.write(path, patch["after"])
        self._change("OWN_EDIT_APPLIED", lambda s: s["active"]["edits"][-1].update(status="APPLIED"))
        return patch["ref"]

    def reverse_own_edit(self, ref):
        patch = self.store.get(ref, "own_edit")
        state = self.inspect()["state"]
        a = self._active(state, {"IMPLEMENTING", "SELF_REASSESSMENT", "CORRECTING"})
        require(a is not None and any(x["ref"] == ref and x["status"] == "APPLIED" for x in a["edits"]), "NOT_OWN_APPLIED_EDIT")
        require(a["phase"] in {"IMPLEMENTING", "SELF_REASSESSMENT", "CORRECTING"} and a["blocker"] is None, "EDIT_PHASE")
        require(digest(self.fs.read(patch["path"])) == patch["after_hash"], "INTERVENING_EDIT")
        self.fs.write(patch["path"], bytes.fromhex(patch["before"]))
        return self._change("OWN_EDIT_REVERSED", lambda s: next(x for x in s["active"]["edits"] if x["ref"] == ref).update(status="REVERSED"))

    def prepare_review(self, request_id, validation, question="Initial review"):
        output = {}
        def action(state):
            a = self._active(state, {"SELF_REASSESSMENT", "REVIEW_READY"})
            self._reconciliation_barrier(state)
            require(a["pending"] is None, "REVIEW_ALREADY_PENDING")
            require(a["self_review"] and a["reassessment"], "SELF_REVIEW_REQUIRED")
            require(isinstance(request_id, str) and request_id not in state["request_registry"], "REQUEST_ID_REUSED")
            current = self.current(state)
            require(self._contract_hash(state) == state["plan"]["contract_hash"], "CONTRACT_CHANGED")
            self._evidence(state, validation, current)
            round_ref = self._round_for_attempt(state, a, len(a["requests"]) + 1)
            self._self_exit(state, a, validation, round_ref)
            a["R"] = self._manifest(state, f"R{len(a['requests'])+1}")
            offered = [FactualEvidence(ref, self.store.get(ref, "evidence")["actor"],
                self.store.get(ref, "evidence")["source"], self.store.get(ref, "evidence")["method"],
                "Supplied fixture observation: " + self.store.get(ref, "evidence")["outcome"],
                self.store.get(ref, "evidence")["limitations"]) for ref in validation]
            payload, text = self._render(self.identity, request_id, len(a["requests"])+1, "STEP", a["R"],
                [Criterion(**c) for c in self._criteria(state)], offered,
                ["Synthetic fixture, not production source or native transport.", "Semantic neutrality is not mechanically proved."],
                question, a["step"])
            if round_ref:
                candidate = self.store.get(round_ref, "round_decision")
                require(candidate["progress_decision"] == "PRODUCTIVE", "PROGRESS_DECISION_REQUIRED")
                require(candidate["question"] == question, "ROUND_QUESTION_MISMATCH")
            ref = self._remember(state, "review_request", {"payload": payload, "text": text, "round_decision": round_ref,
                                                          "validation": list(validation)})
            state["request_registry"][request_id] = {"ref": ref, "target": a["step"], "attempt": payload["attempt"],
                                                       "status": "READY", "dispatched": False}
            a["requests"].append(ref)
            a["pending"] = {"request": ref, "status": "READY"}
            a["phase"] = "REVIEW_READY"
            output.update(payload=payload, text=text, reference=ref)
        self._change("NEUTRAL_REQUEST_GENERATED", action)
        return output

    def simulate_dispatch(self, *, acknowledged=True):
        return self._dispatch_transition(acknowledged, True,
            {"synthetic_dispatch_intent": True, "synthetic_ack": acknowledged},
            "SYNTHETIC_DISPATCH_EVENT_NO_TRANSPORT")

    def _dispatch_transition(self, acknowledged, dispatched, facts, operation):
        """Shared handoff gate; inputs describe local observations, not transport."""
        def action(state):
            a = self._active(state, {"REVIEW_READY"})
            self._reconciliation_barrier(state)
            require(a["pending"] and a["pending"]["status"] == "READY", "REQUEST_REQUIRED")
            require(same_source(self.store.get(a["R"], "manifest"), self.current(state)), "SOURCE_DIVERGED")
            request = self.store.get(a["pending"]["request"], "review_request")
            self._self_exit(state, a, request["validation"], request["round_decision"])
            if a["initial_handoff"] is None:
                a["initial_handoff"] = self._remember(state, "self_handoff", {"tag": self.tag,
                    "step": a["step"], "request": a["pending"]["request"], "source": a["R"],
                    "self_review": a["self_review"], "reassessment": a["reassessment"],
                    "validation": list(request["validation"]), "findings": copy.deepcopy(a["findings"])})
            self._request_status(state, "PENDING")
            self._registration(state, a["pending"]["request"])["dispatched"] = dispatched
            a["pending"].update(facts)
            a["phase"] = "REVIEW_PENDING"
            if not acknowledged:
                a["blocker"] = "DISPATCH_UNCERTAIN"
        return self._change(operation, action)

    def wait_event(self, event):
        require(event in {"TIMEOUT", "MISSING", "FAILED", "SUSPEND"}, "WAIT_EVENT")
        def action(state):
            a = self._active(state, {"REVIEW_PENDING"}, allow_blocked=True)
            require(a["pending"]["status"] in {"PENDING", "FAILED"}, "WAIT_ON_TERMINAL_REQUEST")
            a["pending"]["last_wait"] = event
            if event in {"FAILED", "SUSPEND"}:
                if a["blocker"] is None:
                    a["blocker"] = "REVIEW_FAILED" if event == "FAILED" else "SUSPENDED"
                if event == "FAILED":
                    self._request_status(state, "FAILED")
        return self._change("SYNTHETIC_WAIT_EVENT", action)

    def _admissible_report(self, state, a, ref, *, deferred=False, accepted=False, check_source=True):
        self._capture_barrier(state)
        self._decision_barrier(state)
        require(not state["pause"] and not state["cancel"] and not state["plan_restriction"], "AUTHORITY_PAUSED")
        require(state["external_blocker"] is None, "EXTERNAL_BLOCKER")
        pending = a["pending"]
        require(pending is not None, "NO_ACTIVE_REVIEW")
        registration = self._registration(state, pending["request"])
        required_status = "ACCEPTED" if accepted else "PENDING"
        require(registration["status"] == required_status and registration["dispatched"], "REPORT_NOT_ADMISSIBLE")
        capture = self.store.get(ref, "capture")
        require(capture["classification"] == ("LATE_VALID_REPORT" if deferred else "VALID")
                or (accepted and capture["classification"] == "LATE_VALID_REPORT"), "INVALID_REVIEW_CLOSURE")
        require(capture["request_ref"] == pending["request"], "REPORT_REQUEST_ASSOCIATION")
        request = self.store.get(pending["request"], "review_request")["payload"]
        expected = {**request, "reviewer": self.identity.reviewer, "binding_digest": digest(asdict(self.identity))}
        classification, parsed = self._classify(state, capture["original_text"].encode(), capture["envelope"], expected, {})
        require(classification == "VALID" and parsed == capture["parsed"], "REPORT_REVALIDATION_FAILED")
        reviewed = self.store.get(request["source_ref"], "manifest")
        require(request["source_ref"] == a["R"], "REPORT_SOURCE_ASSOCIATION")
        if check_source:
            require(same_source(reviewed, self.current(state)), "SOURCE_DIVERGED")
        self._report_evidence(state, parsed, reviewed)
        for criterion in parsed["criteria"]:
            require(all(x in parsed["verification"] for x in criterion["evidence"]), "REPORT_CRITERION_EVIDENCE")
            if criterion["status"] == "SATISFIED":
                require(criterion["evidence"], "REPORT_CRITERION_EVIDENCE")

    def receive(self, raw, envelope):
        require(isinstance(raw, str), "REPORT_TEXT_REQUIRED")
        # Capture is a separate journal transaction before parsing/classification.
        # Unsupported non-JSON Python origin objects retain their type, not a
        # fabricated transport identity. Ordinary JSON origin values stay exact.
        try:
            origin = strict_json(canonical(envelope))
        except (TypeError, ValueError, Refusal, RecursionError):
            origin = {"unsupported_origin_type": type(envelope).__name__,
                      "origin_unavailable": True}
        receipt = []
        def save(state):
            a = state["active"]
            ref = self._remember(state, "capture", {"tag": self.tag, "original_text": raw,
                "envelope": origin, "parsed": None, "classification": "UNCLASSIFIED",
                "request_ref_at_arrival": a["pending"]["request"] if a and a["pending"] else None,
                "provenance": self.capture_provenance})
            state["captures"].append(ref)
            receipt.append(ref)
        self._change("RAW_REPORT_CAPTURED_BEFORE_CLASSIFICATION", save)
        raw_ref = receipt[0]
        output = {}
        def action(state):
            original = self.store.get(raw_ref, "capture")
            require(raw_ref in state["captures"], "RAW_CAPTURE_MISSING")
            a = state["active"]
            pending = a["pending"] if a else None
            request = self.store.get(pending["request"], "review_request")["payload"] if pending else {
                "request_id": "fixture-review-request:no-active", "attempt": -1,
                "source_ref": "none", "kind": "STEP"}
            expected = {**request, "reviewer": self.identity.reviewer, "binding_digest": digest(asdict(self.identity))}
            code, parsed = self._classify(state, raw.encode(), origin, expected, state["seen_reports"])
            deferred_reasons = []
            if pending is None:
                if code not in {"IDENTICAL_DUPLICATE", "CONFLICTING_DUPLICATE", "WRONG_SENDER", "BAD_ENVELOPE"}:
                    code = "NO_ACTIVE_REVIEW"
            elif code == "VALID":
                if pending["status"] == "READY":
                    code = "UNDISPATCHED_REPORT"
                elif pending["status"] in {"CANCELLED", "SUPERSEDED"}:
                    code = "CANCELLED_REPORT"
                elif not same_source(self.store.get(a["R"], "manifest"), self.current(state)):
                    code, a["blocker"] = "SOURCE_DIVERGED", "SOURCE_DIVERGED"
                else:
                    deferred_reasons = [name for name, value in {
                        "PAUSE": state["pause"], "CANCEL": state["cancel"],
                        "PLAN_RESTRICTION": state["plan_restriction"], "EXTERNAL_BLOCKER": state["external_blocker"],
                        "WORKFLOW_BLOCKER": a["blocker"], "REQUEST_NOT_PENDING": pending["status"] != "PENDING",
                        "PROGRESS_ESCALATION": state["progress_escalations"],
                        "SUBSTANTIVE_DECISION": state["decision_obligations"],
                        "OTHER_UNCLASSIFIED_CAPTURE": any(self.store.get(x, "capture")["classification"] == "UNCLASSIFIED"
                                                         for x in state["captures"] if x != raw_ref),
                        "REPORT_CONFLICT": any(self.store.get(x, "capture")["classification"] == "CONFLICTING_DUPLICATE"
                                               for x in state["captures"] if x != raw_ref)
                    }.items() if value]
                    if deferred_reasons:
                        code = "LATE_VALID_REPORT"
            if code in {"VALID", "LATE_VALID_REPORT"}:
                try:
                    require(parsed["verification"], "REPORT_VERIFICATION_REQUIRED")
                    self._report_evidence(state, parsed, self.store.get(a["R"], "manifest"))
                    for criterion in parsed["criteria"]:
                        require(all(x in parsed["verification"] for x in criterion["evidence"]), "REPORT_CRITERION_EVIDENCE")
                        if criterion["status"] == "SATISFIED":
                            require(criterion["evidence"], "REPORT_CRITERION_EVIDENCE")
                except Refusal:
                    code = "REPORT_EVIDENCE_INVALID"
            source_request = state["request_registry"].get(origin.get("request_id")) if (
                isinstance(origin, dict) and isinstance(origin.get("request_id"), str)) else None
            capture = self._remember(state, "capture", {**original, "original_capture": raw_ref,
                "parsed": parsed, "classification": code, "deferred_reasons": deferred_reasons,
                "request_ref": source_request["ref"] if source_request else None})
            # Keep one classified capture per arrival; raw immutable object stays
            # linked and retained. A failing second transaction leaves UNCLASSIFIED.
            state["captures"][state["captures"].index(raw_ref)] = capture
            if code in {"VALID", "LATE_VALID_REPORT"}:
                key = report_key(origin)
                state["seen_reports"][key] = digest(raw.encode())
                if code == "VALID":
                    self._admissible_report(state, a, capture)
                    self._accept_report(state, a, capture)
                else:
                    a["pending"]["late_capture"] = capture
                    a["pending"]["deferred_reasons"] = deferred_reasons
            elif code == "CONFLICTING_DUPLICATE":
                if a:
                    a["blocker"] = "REPORT_CONFLICT"
                else:
                    state["external_blocker"] = "REPORT_CONFLICT_AFTER_ACCEPTANCE"
            output.update(classification=code, capture=capture)
        # No broad exception suppression: defects remain visible, original stays
        # durable, and the unclassified receipt prevents further acceptance.
        self._change("CLASSIFY_PRESERVED_SYNTHETIC_REPORT", action)
        return output

    def _reconcile_report(self, state, *, identity_correction=None):
        a = self._active(state, {"REPORT_CHECK"})
        record = {"tag": self.tag, "reconciliation_kind": "ACCEPTED_INDEPENDENT_REPORT", "step": a["step"],
                  "report": a["report"], "request": a["pending"]["request"], "source": a["R"]}
        if identity_correction is not None:
            record["identity_correction"] = identity_correction
        # The adapter must validate the exact correction and bounded source delta
        # before this one exceptional source check can be replaced. Normal calls
        # retain byte-identical source admission and all original-report checks.
        findings = self._reconciliation_findings(state, record)
        self._admissible_report(state, a, a["report"], accepted=True,
                                check_source=identity_correction is None)
        parsed = self.store.get(a["report"], "capture")["parsed"]
        require(parsed is not None, "REPORT_REQUIRED")
        ids = [c["id"] for c in parsed["criteria"]]
        require(len(set(ids)) == len(ids) and set(ids) == {c["id"] for c in self._criteria(state)}, "REVIEW_CRITERIA_COVERAGE")
        reconciliation = self._remember(state, "review_reconciliation", record)
        require(reconciliation not in a["reconciliations"], "REPORT_ALREADY_RECONCILED")
        a["reconciliations"].append(reconciliation)
        self._findings(state, findings, self.independent_origin, a["R"], reconciliation)
        a["phase"] = "FINDINGS_RECONCILIATION"

    def reconcile_report(self):
        return self._change("IMPLEMENTER_REPORT_REASSESSMENT", self._reconcile_report)

    def disposition(self, finding_id, status, reason, evidence=None):
        require(status in {"RESOLVED", "REFUTED_WITH_EVIDENCE", "OPTIONAL_DECLINED", "OPTIONAL_DEFERRED", "ESCALATED"}, "DISPOSITION_STATUS")
        require(isinstance(reason, str) and reason.strip(), "DISPOSITION_REASON")
        evidence = [] if evidence is None else evidence
        def action(state):
            a = self._active(state, {"SELF_REASSESSMENT", "FINDINGS_RECONCILIATION", "CORRECTING", "FINAL_VALIDATION"},
                             adding_obligation=status == "ESCALATED")
            require(finding_id in a["findings"], "UNKNOWN_FINDING")
            finding = a["findings"][finding_id]
            require(not finding["pending_assessment"], "FINDING_REASSESSMENT_REQUIRED")
            require(not (finding["material"] and status.startswith("OPTIONAL_")), "MATERIAL_NOT_OPTIONAL")
            if status in {"RESOLVED", "REFUTED_WITH_EVIDENCE"}:
                self._evidence(state, evidence, self.current(state))
            entry = {"status": status, "reason": reason, "evidence": list(evidence),
                     "source": self._manifest(state, "DISPOSITION_SOURCE")}
            finding["reopening_episode"] = None
            if status == "ESCALATED":
                obligation = self._remember(state, "decision_obligation", {
                    "tag": self.tag, "decision_requirement": "FINDING_ESCALATION", "step": a["step"],
                    "finding_id": finding_id, "claim": finding["original"]["claim"],
                    "history_index": len(finding["history"]), "disposition": copy.deepcopy(entry)})
                entry["obligation"] = obligation
                state["decision_obligations"].append(obligation)
                a["blocker"] = "LEAD_DECISION_REQUIRED"
            finding["history"].append(entry)
        return self._change("FINDING_DECISION", action)

    def begin_corrections(self):
        return self._change("BEGIN_BOUNDED_CORRECTIONS", lambda s:
            self._active(s, {"FINDINGS_RECONCILIATION", "FINAL_VALIDATION"}).update(phase="CORRECTING"))

    def finish_corrections(self):
        return self._change("FINAL_VALIDATION_PHASE", lambda s:
            self._active(s, {"FINDINGS_RECONCILIATION", "CORRECTING"}).update(phase="FINAL_VALIDATION"))

    def assess(self, criterion_id, status, refs, explanation):
        require(status in {"SATISFIED", "CONTRADICTED_BY_FINDING", "NOT_ESTABLISHED"}, "ASSESSMENT_STATUS")
        require(explanation, "ASSESSMENT_REASON")
        def action(state):
            a = self._active(state, {"FINDINGS_RECONCILIATION", "CORRECTING", "FINAL_VALIDATION"})
            require(criterion_id in {c["id"] for c in self._criteria(state)}, "UNKNOWN_CRITERION")
            if status == "SATISFIED":
                self._evidence(state, refs, self.current(state))
            a["assessments"][criterion_id] = {"status": status, "evidence": list(refs), "explanation": explanation}
        return self._change("IMPLEMENTER_CRITERION_ASSESSMENT", action)

    def extra_review(self, question, finding_ids, expected_evidence, progress, rationale):
        require(question and expected_evidence and rationale, "ROUND_EVIDENCE_REQUIRED")
        require(progress in {"PRODUCTIVE", "ESCALATE_NONPROGRESS", "ESCALATE_OSCILLATION", "ESCALATE_INCOMPATIBLE"}, "PROGRESS_DECISION")
        def action(state):
            a = self._active(state, {"FINDINGS_RECONCILIATION", "CORRECTING", "FINAL_VALIDATION"},
                             adding_obligation=progress != "PRODUCTIVE")
            self._reconciliation_barrier(state)
            require(set(finding_ids).issubset(a["findings"]), "UNKNOWN_FINDING")
            require(a["initial_handoff"] and a["report"] in a["reports"], "ADDITIONAL_REVIEW_LINK")
            require(a["reconciliations"] and self._reconciliation(state, a["reconciliations"][-1])["report"] == a["report"],
                    "ADDITIONAL_REVIEW_LINK")
            record = {"tag": self.tag, "question": question, "findings": finding_ids,
                      "sequence": len(a["rounds"]),
                      "step": a["step"], "initial_handoff": a["initial_handoff"], "prior_review": a["report"],
                      "target_findings": {f: digest(a["findings"][f]) for f in finding_ids},
                      "latest_reconciliation": a["reconciliations"][-1],
                      "reopening_episodes": {f: a["findings"][f]["reopening_episode"] for f in finding_ids},
                      "source": self._manifest(state, "EXTRA_REVIEW_SOURCE"),
                      "next_attempt": len(a["requests"])+1, "expected_evidence": expected_evidence,
                      "progress_decision": progress, "rationale": rationale,
                      "assessment_provenance": self.round_provenance}
            a["rounds"].append(self._remember(state, "round_decision", record))
            if progress != "PRODUCTIVE":
                state["progress_escalations"].append(a["rounds"][-1])
                state["decision_obligations"].append(a["rounds"][-1])
                a["blocker"] = "PROGRESS_DECISION_REQUIRED"
            else:
                a["pending"] = None
                a["phase"] = "REVIEW_READY"
        return self._change("REVIEW_ROUND_PROGRESS_DECISION", action)

    def finalize_documents(self, log_entry):
        require(isinstance(log_entry, str) and log_entry, "DOCUMENTATION_REASON")
        state = self.inspect()["state"]
        self._active(state, {"FINAL_VALIDATION"})
        self._reconciliation_barrier(state)
        doc = strict_json(self.fs.read("project/plan.json"))
        require(digest(doc["contract"]) == state["plan"]["contract_hash"], "CONTRACT_CHANGED")
        doc["status"] = "PROVISIONAL_READY_NOT_WORKFLOW_COMPLETE"
        doc["log"].append(log_entry)
        self.fs.write("project/plan.json", canonical(doc))
        def action(current):
            a = self._active(current, {"FINAL_VALIDATION"})
            self._reconciliation_barrier(current)
            a["documentation"] = self._remember(current, "documentation", {"tag": self.tag,
                "contract_hash": digest(doc["contract"]), "file_hash": digest(self.fs.read("project/plan.json")),
                "status": "REQUIRED_ROUTINE_UPDATES_PREPARED", "not_completion_authority": True})
        return self._change("FINAL_DOCUMENT_UPDATES_BEFORE_F", action)

    def prepare_final(self, validation, *, impact, rationale):
        require(impact in {"NO_SEMANTIC_CHANGE", "BOUNDED_CORRECTION", "MATERIAL_REVIEW_INVALIDATED"}
                and rationale, "IMPACT_DECISION_REQUIRED")
        def action(state):
            a = self._active(state, {"FINAL_VALIDATION"})
            self._reconciliation_barrier(state)
            require(a["documentation"], "DOCUMENTATION_REQUIRED")
            doc = self.store.get(a["documentation"], "documentation")
            current = self.current(state)
            require(self._documentation_current(doc, current), "DOCUMENTATION_STALE")
            require(self._contract_hash(state) == state["plan"]["contract_hash"], "CONTRACT_CHANGED")
            require(impact != "MATERIAL_REVIEW_INVALIDATED", "REREVIEW_REQUIRED")
            reviewed = self.store.get(a["R"], "manifest")
            changes = delta(reviewed, current)
            semantic = self._semantic_changes(reviewed, current)
            require(not semantic or impact == "BOUNDED_CORRECTION", "IMPACT_MISMATCH")
            self._evidence(state, validation, current)
            a["F"] = self._manifest(state, "FINAL_F_AFTER_DOCUMENTATION")
            a["final_validation"] = list(validation)
            a["impact"] = self._remember(state, "impact_decision", {"tag": self.tag, "classification": impact,
                "rationale": rationale, "delta": changes, "reviewed": a["R"], "final": a["F"],
                "provenance": self.impact_provenance})
            a["phase"] = "CLOSE_READY"
        return self._change("CAPTURE_FINAL_SOURCE_AND_APPLICABILITY", action)

    def close(self, *, expected=None, fault=None):
        def action(state):
            a = self._active(state, {"CLOSE_READY"})
            self._reconciliation_barrier(state)
            final = self.store.get(a["F"], "manifest")
            require(same_source(final, self.current(state)), "FINAL_SOURCE_CHANGED")
            require(a["self_review"] and a["reassessment"] and a["report"] and a["documentation"], "CLOSURE_EVIDENCE")
            require(all(x["status"] in {"APPLIED", "REVERSED"} for x in a["edits"]), "UNFINISHED_EDIT")
            self._evidence(state, a["final_validation"], final)
            for finding in a["findings"].values():
                self._finding_exit(state, finding, final)
                latest = finding["history"][-1]
                if finding["material"]:
                    require(latest["status"] in {"RESOLVED", "REFUTED_WITH_EVIDENCE"}, "MATERIAL_FINDING_OPEN")
                    self._evidence(state, latest["evidence"], final)
                else:
                    require(latest["status"] in {"RESOLVED", "REFUTED_WITH_EVIDENCE", "OPTIONAL_DECLINED", "OPTIONAL_DEFERRED"}, "FINDING_UNDISPOSED")
            require(set(a["assessments"]) == {c["id"] for c in self._criteria(state)}, "CRITERIA_INCOMPLETE")
            for assessment in a["assessments"].values():
                require(assessment["status"] == "SATISFIED", "CRITERION_NOT_ESTABLISHED")
                self._evidence(state, assessment["evidence"], final)
            report = self.store.get(a["report"], "capture")
            self._admissible_report(state, a, a["report"], accepted=True, check_source=False)
            require(report["classification"] in {"VALID", "LATE_VALID_REPORT"}, "INVALID_REVIEW_CLOSURE")
            # Temporary conservative policy: the schema cannot distinguish an
            # evidence-only omission from substantive disagreement. Preserve the
            # original verdict; an implementer string cannot fill either gap.
            require(all(x["status"] == "SATISFIED" and x["evidence"] for x in report["parsed"]["criteria"]), "REVIEW_COVERAGE_GAP")
            cert = {"tag": self.tag, "schema": 1, "fixture_only": self.fixture_only, "production_acceptance": self.production_acceptance,
                    "step": a["step"], "authorization": a["authorization"], "B": a["B"], "R": a["R"], "F": a["F"],
                    "initial_handoff": a["initial_handoff"],
                    "review": a["report"], "review_history": a["reports"], "self_review": a["self_review"],
                    "reconciliations": a["reconciliations"],
                    "reassessment": a["reassessment"], "findings": a["findings"], "criteria": a["assessments"],
                    "validation": a["final_validation"], "documentation": a["documentation"], "impact": a["impact"]}
            # No own hash, journal revision or certificate embedded in source F.
            ref = self._remember(state, "closure", cert)
            for finding_id, history in a["findings"].items():
                state["finding_registry"][finding_id] = self._remember(state, "finding_history", history)
            state["completed"][a["step"]] = ref
            state["active"] = None
        return self._change("COMPLETE_FIXTURE_STEP_AND_STOP", action, expected, fault)

    def refresh_final(self, reason):
        """Explicit in-workflow finalization revisit; not a generic-next recovery."""
        require(isinstance(reason, str) and reason.strip(), "REFRESH_REASON_REQUIRED")
        def action(state):
            a = self._active(state, {"CLOSE_READY"})
            require(self._contract_hash(state) == state["plan"]["contract_hash"], "CONTRACT_CHANGED")
            state["audit"].append(self._remember(state, "final_refresh", {"tag": self.tag,
                "reason": reason, "old_F": a["F"], "old_documentation": a["documentation"],
                "step": a["step"], "authorization": a["authorization"]}))
            a["F"] = None
            a["documentation"] = None
            a["phase"] = "FINAL_VALIDATION"
        return self._change("EXPLICIT_FINALIZATION_REFRESH", action)

    def validate_restored_binding_and_source(self, *, expected_tip, dispatch_reconciled=False):
        result = self.inspect()
        require(result["tip"] == expected_tip, "STALE_RESTORED_STATE")
        state, a = result["state"], result["state"]["active"]
        if a:
            source = a["F"] or a["R"] or a["B"]
            require(same_source(self.store.get(source, "manifest"), self.current(state)), "RESTORED_SOURCE_CONFLICT")
            if a["pending"] and a["pending"]["status"] != "ACCEPTED":
                require(dispatch_reconciled, "OUTSTANDING_DISPATCH_UNRESOLVED")
        else:
            self._prerequisites(state)
        return {"tag": self.tag, "status": "FIXTURE_RESTORE_CHECKED", "automatic_resume": False,
                "pause": state["pause"], "cancel": state["cancel"]}
