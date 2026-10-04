"""Independent, model-free boundary probes for the exact integration-01 source.

All events/results here are SYNTHETIC REPLAY inputs, never native observations.
Helper files and submitted tests are unchanged. No model or transport is invoked.
"""
import json
import unittest
from pathlib import Path
from dataclasses import asdict

from test_integration import IntegrationTests
from diagnostic import DiagnosticWorkflow
from safe_store import BUNDLE, Refusal, canonical


class Integration01ReassessmentProbes(unittest.TestCase):
    setUp = IntegrationTests.setUp
    auth = IntegrationTests.auth
    state = IntegrationTests.state
    refuse = IntegrationTests.refuse
    next = IntegrationTests.next
    ev = IntegrationTests.ev
    finding = IntegrationTests.finding
    prepared = IntegrationTests.prepared
    obs = IntegrationTests.obs
    submit = IntegrationTests.submit
    report = IntegrationTests.report
    receive = IntegrationTests.receive
    final_ready = IntegrationTests.final_ready

    def trace(self, name, data):
        p = BUNDLE / 'evidence' / 'independent-integration01-traces' / (name + '.json')
        p.parent.mkdir(parents=True, exist_ok=True)
        p.write_bytes(canonical(data))

    def failed_check_report(self, req):
        f = self.finding()
        f['claim'] = 'The reviewer reports that a required contract check failed; the discrepancy is unresolved.'
        raw = self.report(req, [f], status='CONTRADICTED_BY_FINDING',
            method='synthetic checker execution', command='toy-contract-check Case.lean',
            output='SYNTHETIC REPLAY: exit 1; required contract check failed; no real command executed',
            outcome='FAIL', limitations='Synthetic negative-check result for ingestion testing; not an actual mathematical or compiler result')
        return f, raw

    def test_control_complete_replay_and_reconstruction(self):
        ev, req = self.prepared(); self.submit(req)
        raw = self.report(req)
        self.assertEqual(self.receive(req, raw)['classification'], 'VALID')
        self.w = DiagnosticWorkflow(self.w.fs, self.w.identity)
        self.w.reconcile_report(); self.final_ready(ev)
        closed = self.w.diagnostic_closure()
        self.assertEqual(closed['input_mode'], 'REPLAYED')
        self.assertFalse(closed['production_acceptance'])
        self.assertEqual(self.next('second-control')['target'], 'TEST-S02')
        self.trace('clean-control', {'closure': closed, 'mode': 'SYNTHETIC_REPLAY_NOT_LIVE'})

    def test_control_failed_check_cannot_establish_satisfied_criterion(self):
        _, req = self.prepared(); self.submit(req)
        bad = self.report(req, status='SATISFIED', outcome='FAIL')
        result = self.receive(req, bad)
        self.assertNotEqual(result['classification'], 'VALID')
        self.assertIsNone(self.state()['active']['report'])
        self.assertEqual(self.next('after-failed-satisfied')['status'], 'SKIPPED_UNCLOSED')

    def test_negative_check_can_be_reconciled_without_claiming_success(self):
        _, req = self.prepared(); self.submit(req)
        finding, raw = self.failed_check_report(req)
        result = self.receive(req, raw)
        cap = self.w.store.get(result['capture'], 'capture')
        self.trace('negative-check-reception', {'classification': result['classification'],
            'report_retained': cap['original_text'] == raw, 'parsed': cap['parsed'],
            'active_report': self.state()['active']['report'], 'findings': self.state()['active']['findings'],
            'mode': 'SYNTHETIC_REPLAY_NOT_LIVE'})
        self.assertEqual(result['classification'], 'VALID',
            'A valid failed check is negative review evidence, not malformed input; it must be reconcilable without satisfying the criterion.')
        self.w.reconcile_report()
        self.assertEqual(self.state()['active']['findings'][finding['id']]['history'][-1]['status'], 'OPEN')
        self.assertEqual(self.state()['active']['assessments'], {})

    def test_material_negative_check_cannot_be_silently_bypassed_by_clean_report(self):
        ev, req = self.prepared(); self.submit(req)
        finding, raw = self.failed_check_report(req)
        first = self.receive(req, raw)
        # This is a second conflicting synthetic response, not an authorized
        # amendment, corrected-source review, or explicit disposition of F.
        clean = self.report(req)
        blocked = None; closed = None; next_step = None
        try:
            second = self.receive(req, clean)
            if second['classification'] == 'VALID':
                self.w.reconcile_report(); self.final_ready(ev)
                closed = self.w.diagnostic_closure()
                next_step = self.next('after-negative')
        except Refusal as exc:
            blocked = {'code': exc.code, 'message': str(exc)}
        state = self.state()
        self.trace('negative-check-then-clean', {'mode': 'SYNTHETIC_REPLAY_NOT_LIVE',
            'first': first, 'second': locals().get('second'), 'blocked': blocked,
            'closure': closed, 'next_step': next_step,
            'original_negative_report': json.loads(raw),
            'findings_in_history': state['finding_registry'], 'completed': state['completed']})
        self.assertIsNone(closed,
            'A complete correlated material negative report must be handled or explicitly quarantined; a clean same-request response cannot silently erase it.')
        self.assertTrue(blocked or second['classification'] != 'VALID')

    def test_control_passive_detection_keeps_negative_result_without_normal_closure(self):
        req = self.w.detection_request('fixture-review-request:passive-negative')
        self.w.detection_record(req['reference'], 'INTENT', 'Synthetic intent only', {})
        self.w.detection_record(req['reference'], 'SUBMISSION', 'Synthetic ack only', self.obs(req, submission_result='ACKNOWLEDGED'))
        _, raw = self.failed_check_report(req)
        result = self.w.detection_record(req['reference'], 'REPORT', raw, self.obs(req, raw))
        self.assertEqual(result['classification'], 'VALID')
        self.assertFalse(result['normal_step_acceptance'])
        self.assertFalse(self.state()['completed'])
        self.assertIsNone(self.state()['active'])

    def test_passive_intent_must_not_be_admitted_after_explicit_cancel(self):
        req = self.w.detection_request('fixture-review-request:passive-cancel')
        self.w.control('CANCEL', self.auth('CANCEL', 'fixture-plan:v1'))
        result = None; refused = None
        try:
            result = self.w.detection_record(req['reference'], 'INTENT', 'New dispatch after cancellation should not be admitted', {})
        except Refusal as exc:
            refused = exc.code
        state=self.state()
        stages=[self.w.store.get(r) for r in state['records'] if isinstance(self.w.store.get(r),dict) and self.w.store.get(r).get('request') == req['reference'] and self.w.store.get(r).get('admitted_stage')=='INTENT']
        self.trace('passive-cancel', {'result':result,'refused':refused,'cancel':state['cancel'],'pause':state['pause'],'admitted_intents':stages,'mode':'SYNTHETIC_REPLAY_NOT_LIVE'})
        self.assertFalse(stages,'Cancelled authority must prevent admitting a new dispatch intent even for a passive detection task; capture can remain possible.')
