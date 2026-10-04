"""Independent R03 reassessment: public Workflow operations, isolated fixtures only.
These tests do not mutate helper source or bypass its Journal interface.
"""
import json
from test_workflow import FixtureCase
from safe_store import BUNDLE, Refusal
from workflow import Workflow
from contracts import same_source


class Remediation03ReassessmentProbes(FixtureCase):
    def trace(self, name, value):
        root = BUNDLE / 'evidence' / 'independent-r03-traces'
        root.mkdir(parents=True, exist_ok=True)
        (root / (name + '.json')).write_text(json.dumps(value, indent=2), encoding='utf-8')

    def accepted_before_reconcile(self):
        f = self.finding(True)
        ev, req = self.to_pending()
        raw, env = self.report(req, ev, [f], 'CONTRADICTED_BY_FINDING')
        payload = json.loads(raw)
        payload['conclusion'] = 'Material contract concern F remains unresolved; no resolution or supersession has been assessed.'
        raw = json.dumps(payload)
        receipt = self.w.receive(raw, env)
        self.assertEqual(receipt['classification'], 'VALID')
        self.assertEqual(self.state()['active']['phase'], 'REPORT_CHECK')
        return ev, req, raw, env, f, receipt

    def test_accepted_unreconciled_material_report_cannot_be_lost_through_generic_retry(self):
        ev, first, raw, env, f, receipt = self.accepted_before_reconcile()
        trace = {'initial_capture': receipt['capture'], 'initial_report': json.loads(raw),
                 'initial_phase': self.state()['active']['phase'],
                 'source_changed_before_retry': False,
                 'explicit_disposition_or_adjudication': None}
        self.w.block('SUSPENDED')
        self.w = Workflow(self.fs, self.identity)
        try:
            self.w.recover(self.auth('RECOVER_RETRY', 'TEST-S01'), 'retry')
            trace['recovery'] = 'ACCEPTED'
            second = self.w.prepare_review('fixture-review-request:after-unreconciled-report', [ev])
            self.w.simulate_dispatch()
            trace['dispatch'] = 'ACCEPTED'
            trace['same_reviewed_source_bytes'] = same_source(
                self.w.store.get(first['payload']['source_ref'], 'manifest'),
                self.w.store.get(second['payload']['source_ref'], 'manifest'))
            self.assertTrue(trace['same_reviewed_source_bytes'])
            trace['second_receipt'] = self.w.receive(*self.report(second, ev, [], 'SATISFIED'))
            self.w.reconcile_report()
            self.w.finish_corrections(); self.ready(ev)
            self.w.close()
            cert = self.w.store.get(self.state()['completed']['TEST-S01'], 'closure')
            trace['certificate'] = cert
            trace['next'] = self.start('fixture-ingress:after-unhandled-report')
        except Refusal as exc:
            trace['refusal'] = exc.code
        state = self.state()
        trace['completed'] = list(state['completed'])
        trace['registry'] = state['finding_registry']
        trace['authorities'] = [self.w.store.get(r, 'authority')['action'] for r in state['authority_history']]
        trace['first_original_retained'] = self.w.store.get(receipt['capture'], 'capture')['original_text'] == raw
        trace['requests'] = state['request_registry']
        self.trace('accepted-unreconciled-report-retry', trace)
        self.assertNotIn('TEST-S01', state['completed'],
            'An accepted report containing a material finding and contradicted criterion cannot be skipped via a generic transport retry and a clean replacement; it needs explicit findings reconciliation, not merely retained raw text.')

    def test_control_normal_reconciliation_preserves_material_finding_when_later_report_omits_it(self):
        ev, first, raw, env, f, receipt = self.accepted_before_reconcile()
        self.w.reconcile_report()
        self.w.extra_review('Examine unresolved F', [f['id']], 'A current argument about F', 'PRODUCTIVE', 'Targeted substantive question, not transport retry')
        second = self.w.prepare_review('fixture-review-request:proper-followup', [ev], 'Examine unresolved F')
        self.w.simulate_dispatch()
        self.w.receive(*self.report(second, ev, [], 'SATISFIED')); self.w.reconcile_report()
        self.w.finish_corrections(); self.ready(ev)
        self.refuse('MATERIAL_FINDING_OPEN', self.w.close)
        self.assertFalse(self.state()['completed'])
        self.assertEqual(self.state()['active']['findings'][f['id']]['history'][-1]['status'], 'OPEN')

    def test_control_failed_pending_request_retry_can_still_close(self):
        ev, req = self.to_pending()
        self.w.wait_event('FAILED')
        self.w.recover(self.auth('RECOVER_RETRY','TEST-S01'), 'retry')
        second = self.w.prepare_review('fixture-review-request:legitimate-retry', [ev]); self.w.simulate_dispatch()
        self.w.receive(*self.report(second, ev)); self.w.reconcile_report(); self.w.finish_corrections()
        self.ready(ev); self.w.close()
        self.assertEqual(self.start()['target'], 'TEST-S02')

    def test_control_finding_and_explicit_obligations_survive_source_restoration_and_rebuild(self):
        ev, req, raw, env = self.to_final_validation([self.finding(True)])
        self.w.disposition('fixture-finding:1','ESCALATED','Substantive decision remains required')
        self.w.block('LEAD_DECISION_REQUIRED')
        obligations = self.state()['decision_obligations'][:]
        self.w.block('SUSPENDED'); self.w = Workflow(self.fs,self.identity)
        with self.assertRaises(Refusal):
            self.w.recover(self.auth('RECOVER_RETRY','TEST-S01'),'retry')
        self.assertEqual(self.state()['decision_obligations'],obligations)
        self.assertFalse(self.state()['completed'])

    def test_control_multiround_two_self_findings_keep_distinct_current_episodes(self):
        f = self.finding(True)
        g = dict(f, id='fixture-finding:2',label='R-F02',claim='A separate current material concern.')
        ev = self.to_self_review([f,g]); self.w.reassess({f['id']:'Investigated',g['id']:'Investigated'})
        for finding in (f,g): self.w.disposition(finding['id'],'RESOLVED','Initial checked evidence',[ev])
        first = self.w.prepare_review('fixture-review-request:two-first',[ev]); self.w.simulate_dispatch()
        self.w.receive(*self.report(first,ev,[f,g])); self.w.reconcile_report()
        anchors = {x:self.state()['active']['findings'][x]['reopening_episode'] for x in (f['id'],g['id'])}
        for idx in range(2,4):
            question=f'Distinct concrete inquiry {idx}'
            self.w.extra_review(question,[f['id'],g['id']],'New specific argument','PRODUCTIVE','Prior report leaves a different uncertainty')
            req=self.w.prepare_review(f'fixture-review-request:two-{idx}',[ev],question); self.w.simulate_dispatch()
            self.w.receive(*self.report(req,ev,[], 'NOT_ESTABLISHED')); self.w.reconcile_report()
            self.w=Workflow(self.fs,self.identity)
            self.assertEqual({x:self.state()['active']['findings'][x]['reopening_episode'] for x in anchors}, anchors)
        self.assertFalse(self.state()['completed'])
