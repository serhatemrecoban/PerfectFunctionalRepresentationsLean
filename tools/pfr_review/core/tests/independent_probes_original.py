"""Independent reviewer regression expectations. Unchanged submitted helpers.
All state and report inputs below are synthetic. No native/model calls.
"""
import json
from test_workflow import FixtureCase, COMMAND
from safe_store import Refusal, strict_json, canonical, TAG


class IndependentReviewProbes(FixtureCase):
    def test_pause_arrival_release_should_allow_authorized_reconciliation(self):
        ev, req = self.to_pending()
        raw, env = self.report(req, ev)
        self.w.control('PAUSE', self.auth('PAUSE', 'fixture-plan:v1'))
        self.assertEqual(self.w.receive(raw, env)['classification'], 'LATE_VALID_REPORT')
        self.w.control('RELEASE', self.auth('RELEASE', 'fixture-plan:v1'))
        # Correct original report is already retained, but normal explicit
        # reconciliation should be possible after user release.
        self.w.recover(self.auth('RECOVER_RECONCILE', 'TEST-S01'), 'reconcile')
        self.w.reconcile_report()
        self.assertEqual(self.state()['active']['phase'], 'FINDINGS_RECONCILIATION')

    def test_malformed_criterion_status_is_captured_not_typeerror(self):
        ev, req = self.to_pending()
        raw, env = self.report(req, ev)
        data = json.loads(raw)
        data['criteria'][0]['status'] = ['SATISFIED']
        malformed = json.dumps(data)
        result = self.w.receive(malformed, env)
        self.assertNotEqual(result['classification'], 'VALID')
        self.assertEqual(self.w.store.get(result['capture'], 'capture')['original_text'], malformed)
        self.assertEqual(self.state()['active']['phase'], 'REVIEW_PENDING')

    def test_cancelled_late_report_must_not_be_accepted_by_generic_reconcile(self):
        ev, req = self.to_pending()
        raw, env = self.report(req, ev)
        self.w.wait_event('SUSPEND')
        self.assertEqual(self.w.receive(raw, env)['classification'], 'LATE_VALID_REPORT')
        self.w.control('CANCEL', self.auth('CANCEL', 'fixture-plan:v1'))
        self.w.control('RELEASE', self.auth('RELEASE', 'fixture-plan:v1'))
        self.assertEqual(self.state()['active']['pending']['status'], 'CANCELLED')
        # RECOVER_RECONCILE has no authority to uncancel the old review request,
        # select a replacement, or count its report as current acceptance.
        with self.assertRaises(Refusal):
            self.w.recover(self.auth('RECOVER_RECONCILE', 'TEST-S01'), 'reconcile')

    def test_conflicting_late_reports_must_not_be_resolved_without_adjudication(self):
        ev, req = self.to_pending()
        raw, env = self.report(req, ev)
        self.w.wait_event('SUSPEND')
        self.w.receive(raw, env)
        data = json.loads(raw)
        data['findings'] = [self.finding(True)]
        data['conclusion'] = 'Material concern in this revised diagnostic report.'
        self.assertEqual(self.w.receive(json.dumps(data), env)['classification'], 'CONFLICTING_DUPLICATE')
        self.assertEqual(self.state()['active']['blocker'], 'REPORT_CONFLICT')
        # A generic reconcile authority carries no explicit decision/evidence
        # resolving the contradictory captures. Do not silently choose raw #1.
        with self.assertRaises(Refusal):
            self.w.recover(self.auth('RECOVER_RECONCILE', 'TEST-S01'), 'reconcile')

    def test_self_material_issue_must_be_disposed_before_independent_dispatch(self):
        finding = self.finding(True)
        ev = self.to_self_review([finding])
        self.w.reassess({finding['id']: 'Need to investigate this material question before closing self-review.'})
        with self.assertRaises(Refusal):
            self.w.prepare_review('fixture-review-request:self-open', [ev])

    def test_request_identifier_reuse_across_steps_rejected_before_dispatch(self):
        ev, req, _, _ = self.to_final_validation()
        first_id = req['payload']['request_id']
        self.ready(ev); self.w.close()
        ev2 = self.to_self_review(); self.w.reassess({})
        with self.assertRaises(Refusal):
            self.w.prepare_review(first_id, [ev2])

    def test_finding_materiality_can_be_reassessed_without_losing_stable_identity(self):
        f = self.finding(False)
        ev, _, _, _ = self.to_final_validation([f])
        self.w.disposition(f['id'], 'OPTIONAL_DECLINED', 'Not yet needed in this step.')
        self.ready(ev); self.w.close()
        ev2, req2 = self.to_pending()
        f['material'] = True
        f['severity'] = 'important'
        raw, env = self.report(req2, ev2, [f])
        self.w.receive(raw, env)
        self.w.reconcile_report()
        updated = self.state()['active']['findings'][f['id']]
        self.assertTrue(updated['material'])
        self.assertFalse(updated['original']['material'])
        self.assertEqual(updated['history'][-1]['status'], 'OPEN')

class ObservedTraces(FixtureCase):
    def save(self, name, obj):
        from pathlib import Path
        import json
        out = Path(__file__).resolve().parents[1] / 'evidence' / 'independent-traces'
        out.mkdir(exist_ok=True)
        (out / (name + '.json')).write_text(json.dumps(obj, indent=2), encoding='utf-8')

    def test_conflicting_report_can_reach_complete_without_adjudication(self):
        ev, req = self.to_pending()
        raw1, env = self.report(req, ev)
        self.w.wait_event('SUSPEND')
        self.w.receive(raw1, env)
        data = json.loads(raw1); data['findings'] = [self.finding(True)]
        data['conclusion'] = 'Second conflicting report raises a material issue.'
        raw2 = json.dumps(data)
        second = self.w.receive(raw2, env)
        blocked = self.state()['active']['blocker']
        # Ordinary public recovery method; no direct state/journal modification.
        self.w.recover(self.auth('RECOVER_RECONCILE', 'TEST-S01'), 'reconcile')
        self.w.reconcile_report(); self.w.finish_corrections(); self.ready(ev); self.w.close()
        state = self.state(); cert = self.w.store.get(state['completed']['TEST-S01'], 'closure')
        accepted = self.w.store.get(cert['review'], 'capture')
        self.save('conflicting-late-report-completes', {
            'second_report_classification': second['classification'], 'blocker_before_recovery': blocked,
            'recovery_authority_action': 'RECOVER_RECONCILE',
            'explicit_conflict_adjudication': False, 'original_report_used': accepted['original_text'] == raw1,
            'material_finding_in_second_report': data['findings'][0], 'findings_in_closure': cert['findings'],
            'completed': list(state['completed']), 'external_blocker': state['external_blocker'],
            'next_request': self.start('fixture-ingress:after-conflict')})

    def test_cancelled_late_report_can_reach_complete(self):
        ev, req = self.to_pending(); raw, env = self.report(req, ev)
        self.w.wait_event('SUSPEND'); self.w.receive(raw, env)
        self.w.control('CANCEL', self.auth('CANCEL', 'fixture-plan:v1'))
        before = self.state()['active']['pending']['status']
        self.w.control('RELEASE', self.auth('RELEASE', 'fixture-plan:v1'))
        self.w.recover(self.auth('RECOVER_RECONCILE', 'TEST-S01'), 'reconcile')
        self.w.reconcile_report(); self.w.finish_corrections(); self.ready(ev); self.w.close()
        state = self.state(); cert = self.w.store.get(state['completed']['TEST-S01'], 'closure')
        self.save('cancelled-late-report-completes', {'pending_status_before_release': before,
            'new_request_dispatched': False, 'review_report_original': self.w.store.get(cert['review'],'capture')['original_text'] == raw,
            'completed': list(state['completed']), 'captured_report_classification': self.w.store.get(cert['review'],'capture')['classification']})

    def test_malformed_status_loses_capture(self):
        ev, req = self.to_pending(); raw, env = self.report(req, ev)
        data = json.loads(raw); data['criteria'][0]['status'] = []
        n = len(self.state()['captures'])
        try: result = self.w.receive(json.dumps(data), env); error = None
        except Exception as exc: error = {'type': type(exc).__name__, 'message': str(exc)}
        self.save('malformed-status-capture', {'exception':error, 'captures_before': n,
            'captures_after':len(self.state()['captures']), 'phase':self.state()['active']['phase']})

    def test_pause_recovery_block_and_duplicate(self):
        ev, req = self.to_pending(); raw, env = self.report(req, ev)
        self.w.control('PAUSE', self.auth('PAUSE', 'fixture-plan:v1'))
        classification = self.w.receive(raw, env)['classification']
        self.w.control('RELEASE', self.auth('RELEASE', 'fixture-plan:v1'))
        try: self.w.recover(self.auth('RECOVER_RECONCILE', 'TEST-S01'),'reconcile'); error = None
        except Refusal as exc: error = exc.code
        duplicate = self.w.receive(raw, env)['classification']
        s=self.state()
        self.save('pause-recovery-stuck', {'arrival':classification, 'recovery_error':error,
          'resubmitted_original':duplicate,'phase':s['active']['phase'], 'blocker':s['active']['blocker'],
          'late_capture_retained':bool(s['active']['pending'].get('late_capture')), 'next':self.start('fixture-ingress:after-pause')})

    def test_reused_request_id_misclassifies_next_report(self):
        ev, req, _, _ = self.to_final_validation(); old_id = req['payload']['request_id']
        self.ready(ev); self.w.close()
        ev2=self.to_self_review(); self.w.reassess({})
        req2=self.w.prepare_review(old_id,[ev2]); self.w.simulate_dispatch()
        result=self.w.receive(*self.report(req2,ev2))
        self.save('request-id-reuse-conflict', {'reused_id':old_id,'first_target':req['payload']['target_id'],
          'second_target':req2['payload']['target_id'],'first_attempt':req['payload']['attempt'],
          'second_attempt':req2['payload']['attempt'],'request_generation_accepted':True,
          'new_report_classification':result['classification'],'blocker':self.state()['active']['blocker']})

    def test_open_self_finding_reaches_dispatch(self):
        f=self.finding(True); ev=self.to_self_review([f]); self.w.reassess({f['id']:'Investigate; not yet resolved.'})
        req=self.w.prepare_review('fixture-review-request:open-self',[ev]); self.w.simulate_dispatch()
        a=self.state()['active']
        self.save('open-self-review-dispatched', {'request_id':req['payload']['request_id'],'phase':a['phase'],
            'material_finding_status':a['findings'][f['id']]['history'][-1]['status'],
            'reassessment_decision':'Investigate; not yet resolved.', 'blocker':a['blocker']})
