"""Additional independent R02 checks, fixture-only and using public Workflow APIs.
No supplied helper or test is changed. Recorded traces precede invariant assertions.
"""
import json
from test_workflow import FixtureCase
from safe_store import BUNDLE, Refusal
from workflow import Workflow


class Remediation02BoundaryProbes(FixtureCase):
    def trace(self, name, value):
        p = BUNDLE / 'evidence' / 'independent-r02-traces'
        p.mkdir(parents=True, exist_ok=True)
        (p / (name + '.json')).write_text(json.dumps(value, indent=2), encoding='utf-8')

    def test_control_finding_escalation_without_overwrite_rejects_retry(self):
        f = self.finding(True)
        self.to_final_validation([f])
        self.w.disposition(f['id'], 'ESCALATED', 'Material disagreement needs a project-lead decision.')
        with self.assertRaises(Refusal):
            self.w.recover(self.auth('RECOVER_RETRY', 'TEST-S01'), 'retry')
        self.assertFalse(self.state()['completed'])

    def test_finding_escalation_survives_transport_blocker_and_generic_recovery(self):
        f = self.finding(True)
        ev, _, _, _ = self.to_final_validation([f])
        self.w.disposition(f['id'], 'ESCALATED', 'Unresolved material disagreement requires a substantive project-lead decision.')
        trace = {'initial_blocker': self.state()['active']['blocker'], 'lead_adjudication': None}
        self.w.block('SUSPENDED')
        self.w = Workflow(self.fs, self.identity)
        try:
            self.w.recover(self.auth('RECOVER_RETRY', 'TEST-S01'), 'retry')
            trace['recovery'] = 'ACCEPTED'
            trace['still_escalated_after_recovery'] = self.state()['active']['findings'][f['id']]['history'][-1]['status']
            req = self.w.prepare_review('fixture-review-request:retry-after-finding-escalation', [ev])
            self.w.simulate_dispatch()
            trace['dispatch'] = 'ACCEPTED'
            self.w.receive(*self.report(req, ev))
            self.w.reconcile_report()
            self.w.disposition(f['id'], 'RESOLVED', 'Implementer now favors the original solution; supplied unchanged evidence.', [ev])
            self.w.finish_corrections(); self.ready(ev); self.w.close()
            trace['next'] = self.start('fixture-ingress:after-unadjudicated-finding')
        except Refusal as exc:
            trace['refusal'] = exc.code
        s = self.state()
        trace['completed'] = list(s['completed'])
        trace['authorities'] = [self.w.store.get(r, 'authority')['action'] for r in s['authority_history']]
        trace['finding_history'] = (s['active']['findings'][f['id']]['history'] if s['active'] and f['id'] in s['active']['findings'] else self.w.store.get(s['finding_registry'][f['id']], 'finding_history')['history'])
        self.trace('finding-escalation-overwrite', trace)
        self.assertNotIn('TEST-S01', s['completed'], 'A generic transport retry is not a substantive lead adjudication of an ESCALATED material finding.')
        self.assertNotEqual(trace.get('dispatch'), 'ACCEPTED')

    def round_with_unrepeated_finding(self, self_origin):
        f = self.finding(True)
        if self_origin:
            ev = self.to_self_review([f]); self.w.reassess({f['id']: 'Original self-review concern investigated.'})
            self.w.disposition(f['id'], 'RESOLVED', 'Supported historical handoff.', [ev])
            req = self.w.prepare_review('fixture-review-request:original-self-handoff', [ev]); self.w.simulate_dispatch()
            self.w.receive(*self.report(req, ev, [f])); self.w.reconcile_report()
        else:
            ev, _, _, _ = self.to_final_validation([f])
        self.w.extra_review('Investigate the independent challenge', [f['id']], 'An argument resolving the open concern', 'PRODUCTIVE', 'A concrete independent challenge remains open.')
        r2 = self.w.prepare_review('fixture-review-request:second', [ev], 'Investigate the independent challenge'); self.w.simulate_dispatch()
        raw, env = self.report(r2, ev, [], 'NOT_ESTABLISHED')
        data = json.loads(raw)
        data['earlier_reconciliation'] = [{'finding_id': f['id'], 'status': 'OPEN', 'explanation': 'The previous finding remains unresolved; this round has no new finding.'}]
        data['conclusion'] = 'The concern is retained in the registry; criterion C1 is still not established. A different targeted check may resolve it.'
        self.w.receive(json.dumps(data), env); self.w.reconcile_report()
        self.assertEqual(self.state()['active']['findings'][f['id']]['history'][-1]['status'], 'OPEN')
        self.w = Workflow(self.fs, self.identity)
        self.w.extra_review('Check a different source argument', [f['id']], 'New evidence for the unchanged open concern', 'PRODUCTIVE', 'The earlier attempt left uncertainty; this is a different source argument, not an assertion that the finding is resolved.')
        trace = {'self_origin': self_origin, 'criterion_status_in_latest_report': 'NOT_ESTABLISHED', 'repeated_in_findings_list': False}
        try:
            r3 = self.w.prepare_review('fixture-review-request:third', [ev], 'Check a different source argument'); self.w.simulate_dispatch()
            trace['outcome'] = 'DISPATCHED'
        except Refusal as exc:
            trace['outcome'] = exc.code
        s=self.state()
        trace['phase'] = s['active']['phase']; trace['completed'] = list(s['completed'])
        trace['finding'] = s['active']['findings'][f['id']]
        trace['rounds'] = [self.w.store.get(r, 'round_decision') for r in s['active']['rounds']]
        self.trace('unrepeated-self-finding' if self_origin else 'unrepeated-independent-finding', trace)
        self.assertEqual(trace['outcome'], 'DISPATCHED', 'A still-open independently reopened concern must not lose targeted-review eligibility merely because the latest report references its existing ID without duplicating it in findings.')
        self.assertEqual(s['active']['findings'][f['id']]['history'][-1]['status'], 'OPEN')
        self.assertFalse(s['completed'])

    def test_targeted_review_keeps_independent_reopening_provenance_across_no_new_findings_report(self):
        self.round_with_unrepeated_finding(True)

    def test_control_independent_origin_survives_no_new_findings_report(self):
        self.round_with_unrepeated_finding(False)
