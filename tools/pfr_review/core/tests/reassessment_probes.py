"""Independent remediation-01 boundary probes; synthetic fixtures only.
No helpers are modified and no live agents or transports are called.
Trace files record observations; assertions express the inspected contract.
"""
import json
from test_workflow import FixtureCase
from safe_store import BUNDLE, Refusal
from workflow import Workflow

class ReassessmentProbes(FixtureCase):
    def trace(self, name, data):
        out = BUNDLE / 'evidence' / 'independent-r01-traces'
        out.mkdir(parents=True, exist_ok=True)
        (out / (name + '.json')).write_text(json.dumps(data, indent=2), encoding='utf-8')

    def test_open_repeated_self_finding_can_receive_targeted_additional_review(self):
        f = self.finding(True)
        ev = self.to_self_review([f])
        self.w.reassess({f['id']: 'Original self concern addressed using source evidence.'})
        self.w.disposition(f['id'], 'RESOLVED', 'Initial source check supports closure of self concern.', [ev])
        first = self.w.prepare_review('fixture-review-request:initial-self-origin', [ev])
        self.w.simulate_dispatch()
        self.w.receive(*self.report(first, ev, [f]))
        self.w.reconcile_report()
        self.assertEqual(self.state()['active']['findings'][f['id']]['history'][-1]['status'], 'OPEN')
        self.w.extra_review('Recheck this independent challenge against the specification', [f['id']],
                            'Targeted source argument answering the reviewer challenge', 'PRODUCTIVE',
                            'Earlier self disposition is challenged; another substantive review can resolve the uncertainty.')
        try:
            nxt = self.w.prepare_review('fixture-review-request:independent-clarification', [ev],
                                       'Recheck this independent challenge against the specification')
            self.w.simulate_dispatch()
            outcome = 'DISPATCHED'
        except Refusal as err:
            outcome = err.code
        s = self.state()
        self.trace('targeted-review-self-origin', {'outcome': outcome, 'phase': s['active']['phase'],
             'finding': s['active']['findings'][f['id']], 'completed': s['completed'],
             'rounds': [self.w.store.get(r, 'round_decision') for r in s['active']['rounds']]})
        self.assertEqual(outcome, 'DISPATCHED',
                         'A reopened independent challenge must not require a false RESOLVED disposition before targeted re-review.')

    def test_control_independent_only_open_finding_allows_targeted_review(self):
        f = self.finding(True)
        ev, _, _, _ = self.to_final_validation([f])
        self.w.extra_review('Recheck independent-only challenge', [f['id']], 'New source argument',
                            'PRODUCTIVE', 'Resolve an open independent concern without claiming it is already resolved.')
        self.w.prepare_review('fixture-review-request:independent-only', [ev], 'Recheck independent-only challenge')
        self.w.simulate_dispatch()
        self.assertEqual(self.state()['active']['phase'], 'REVIEW_PENDING')
        self.assertEqual(self.state()['active']['findings'][f['id']]['history'][-1]['status'], 'OPEN')
        self.assertFalse(self.state()['completed'])

    def test_progress_escalation_survives_later_suspension_and_generic_retry(self):
        ev, _, _, _ = self.to_final_validation()
        self.w.extra_review('Choose between incompatible approaches', [], 'Lead decision then targeted check',
                            'ESCALATE_OSCILLATION', 'Repeated changes oscillate; affected work needs a project-lead decision.')
        self.assertEqual(self.state()['active']['blocker'], 'PROGRESS_DECISION_REQUIRED')
        # A subsequent ordinary interruption is reported through the public API.
        self.w.block('SUSPENDED')
        self.w = Workflow(self.fs, self.identity)
        trace = {'attempted_authority': 'RECOVER_RETRY', 'progress_lead_decision': None}
        try:
            self.w.recover(self.auth('RECOVER_RETRY', 'TEST-S01'), 'retry')
            trace['recovery'] = 'ACCEPTED'
            second = self.w.prepare_review('fixture-review-request:generic-retry-after-escalation', [ev],
                                           'Choose between incompatible approaches')
            trace['round_ref'] = second['reference']
            self.w.simulate_dispatch()
            trace['dispatch'] = 'ACCEPTED'
            self.w.receive(*self.report(second, ev))
            self.w.reconcile_report()
            self.w.finish_corrections()
            self.ready(ev)
            self.w.close()
            trace['step1_closed'] = 'TEST-S01' in self.state()['completed']
            trace['next_request'] = self.start()
        except Refusal as err:
            trace['refusal'] = err.code
        s = self.state()
        trace['completed'] = list(s['completed'])
        trace['authorities'] = [self.w.store.get(r, 'authority')['action'] for r in s['authority_history']]
        self.trace('progress-escalation-generic-retry', trace)
        self.assertNotIn('TEST-S01', s['completed'],
                         'A transport retry must not resolve a recorded substantive progress escalation.')

    def test_control_progress_escalation_without_overwrite_refuses_retry(self):
        ev, _, _, _ = self.to_final_validation()
        self.w.extra_review('Lead decision needed', [], 'Lead choice', 'ESCALATE_OSCILLATION', 'Oscillation unresolved.')
        with self.assertRaises(Refusal):
            self.w.recover(self.auth('RECOVER_RETRY', 'TEST-S01'), 'retry')
        self.assertFalse(self.state()['completed'])
        self.assertEqual(self.start()['status'], 'SKIPPED_UNCLOSED')
