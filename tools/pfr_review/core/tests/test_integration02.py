"""Targeted model-free Integration-02 regressions. All events are synthetic replay."""
import copy
import json
import unittest

from integration01_reassessment_probes import Integration01ReassessmentProbes
from test_integration import IntegrationTests
from diagnostic import DiagnosticWorkflow
from safe_store import BUNDLE, Refusal, canonical, digest


class Integration02Tests(unittest.TestCase):
    setUp=IntegrationTests.setUp
    auth=IntegrationTests.auth
    state=IntegrationTests.state
    refuse=IntegrationTests.refuse
    next=IntegrationTests.next
    ev=IntegrationTests.ev
    finding=IntegrationTests.finding
    prepared=IntegrationTests.prepared
    obs=IntegrationTests.obs
    submit=IntegrationTests.submit
    report=IntegrationTests.report
    receive=IntegrationTests.receive
    final_ready=IntegrationTests.final_ready
    failed_check_report=Integration01ReassessmentProbes.failed_check_report

    def trace(self,name,data):
        p=BUNDLE/'evidence'/'integration02-traces'/(name+'.json')
        p.parent.mkdir(parents=True,exist_ok=True);p.write_bytes(canonical(data))

    def records(self):return [self.w.store.get(r) for r in self.state()['records']]

    def passive(self):return self.w.detection_request('fixture-review-request:passive')

    def intent(self,req):return self.w.detection_record(req['reference'],'INTENT','Synthetic intent',{})

    def ack(self,req):return self.w.detection_record(req['reference'],'SUBMISSION','Exact synthetic ack',self.obs(req,submission_result='ACKNOWLEDGED'))

    def no_admitted(self,stage):
        self.assertFalse([r for r in self.records() if isinstance(r,dict) and r.get('admitted_stage')==stage])

    def test_negative_eventual_continuation_requires_handling_and_satisfactory_review(self):
        ev,req=self.prepared();self.submit(req);f,raw=self.failed_check_report(req)
        result=self.receive(req,raw);self.assertEqual(result['classification'],'VALID')
        cap=self.w.store.get(result['capture'],'capture')
        neg=cap['parsed']['verification'][0]
        self.assertEqual(self.w.store.get(neg,'evidence')['outcome'],'FAIL')
        self.assertEqual(cap['original_text'],raw)
        self.w=DiagnosticWorkflow(self.w.fs,self.w.identity)
        self.w.block('SUSPENDED')
        self.refuse('REPORT_RECONCILIATION_REQUIRED',lambda:self.w.recover(self.auth('RECOVER_RETRY','TEST-S01'),'retry'))
        self.w.recover(self.auth('RECOVER_CONTINUE','TEST-S01'))
        self.w.reconcile_report()
        self.refuse('EVIDENCE_NOT_PASSING',lambda:self.w.disposition(f['id'],'RESOLVED','Failed evidence cannot resolve',[neg]))
        self.w.disposition(f['id'],'REFUTED_WITH_EVIDENCE','Synthetic supported refutation, not actual mathematics',[ev])
        self.final_ready(ev)
        self.refuse('REVIEW_COVERAGE_GAP',self.w.diagnostic_closure)
        self.assertEqual(self.next('before-satisfactory')['status'],'SKIPPED_UNCLOSED')
        self.w.refresh_final('Need satisfactory independent review, not an implementer override')
        self.w.extra_review('Check supported handling',[f['id']],'Source inspection supporting C1','PRODUCTIVE','Synthetic new evidence')
        new=self.w.prepare_review('fixture-review-request:satisfactory',[ev],'Check supported handling');self.submit(new)
        self.assertEqual(self.receive(new)['classification'],'VALID')
        self.w.reconcile_report();self.final_ready(ev);closed=self.w.diagnostic_closure()
        cert=self.w.store.get(closed['core_closure'],'closure')
        self.assertIn(result['capture'],cert['review_history'])
        self.assertEqual(len(cert['reconciliations']),2)
        self.assertEqual(self.w.store.get(result['capture'],'capture')['parsed']['criteria'][0]['status'],'CONTRADICTED_BY_FINDING')
        self.assertEqual(self.w.store.get(neg,'evidence')['outcome'],'FAIL')
        next_step=self.next('after-satisfactory');self.assertEqual(next_step['target'],'TEST-S02')
        self.trace('negative-continuation',{'input_mode':'SYNTHETIC_REPLAY_NOT_LIVE','negative_capture':cap,
            'negative_evidence':self.w.store.get(neg,'evidence'),'certificate':cert,'closure':closed,'next':next_step})

    def test_not_established_negative_without_finding_is_reconcilable_but_not_sufficient(self):
        ev,req=self.prepared();self.submit(req)
        r=self.receive(req,self.report(req,status='NOT_ESTABLISHED',outcome='FAIL'))
        self.assertEqual(r['classification'],'VALID');self.w.reconcile_report();self.final_ready(ev)
        self.refuse('REVIEW_COVERAGE_GAP',self.w.diagnostic_closure)

    def test_negative_duplicate_and_conflict_persist_across_reconstruction(self):
        _,req=self.prepared();self.submit(req);_,raw=self.failed_check_report(req)
        self.assertEqual(self.receive(req,raw)['classification'],'VALID')
        self.w=DiagnosticWorkflow(self.w.fs,self.w.identity)
        self.assertEqual(self.receive(req,raw)['classification'],'IDENTICAL_DUPLICATE')
        self.assertEqual(self.receive(req)['classification'],'CONFLICTING_DUPLICATE')
        self.w=DiagnosticWorkflow(self.w.fs,self.w.identity)
        self.refuse('REPORT_CONFLICT_UNRESOLVED',self.w.reconcile_report)
        self.assertEqual(self.next('conflict')['status'],'SKIPPED_UNCLOSED')

    def test_negative_pause_release_requires_same_report_recovery_and_reconciliation(self):
        _,req=self.prepared();self.submit(req);_,raw=self.failed_check_report(req)
        self.w.control('PAUSE',self.auth('PAUSE','fixture-plan:v1'))
        r=self.receive(req,raw);self.assertEqual(r['classification'],'LATE_VALID_REPORT')
        self.w.control('RELEASE',self.auth('RELEASE','fixture-plan:v1'))
        self.assertIsNone(self.state()['active']['report'])
        self.w.recover(self.auth('RECOVER_RECONCILE','TEST-S01'),'reconcile');self.w.reconcile_report()
        self.assertEqual(self.state()['active']['findings'][self.finding()['id']]['history'][-1]['status'],'OPEN')
        self.assertEqual(self.state()['active']['report'],r['capture'])

    def test_initial_final_assessment_and_resolution_still_require_passing_evidence(self):
        self.next();fail=self.w.parent_evidence('Synthetic failed check','FAIL input','No command run',outcome='FAIL')
        self.refuse('EVIDENCE_NOT_PASSING',lambda:self.w.initial_validation([fail]))
        ev=self.ev();self.w.initial_validation([ev]);self.w.self_review([],'synthetic');self.w.reassess({})
        req=self.w.prepare_review('fixture-review-request:1',[ev]);self.submit(req);self.receive(req);self.w.reconcile_report()
        self.w.finish_corrections()
        self.refuse('EVIDENCE_NOT_PASSING',lambda:self.w.assess('C1','SATISFIED',[fail],'not valid success'))
        self.w.assess('C1','SATISFIED',[ev],'positive control');self.w.finalize_documents('metadata only')
        self.refuse('EVIDENCE_NOT_PASSING',lambda:self.w.prepare_final([fail],impact='NO_SEMANTIC_CHANGE',rationale='negative cannot validate'))
        self.w.prepare_final([ev],impact='NO_SEMANTIC_CHANGE',rationale='positive control');self.w.diagnostic_closure()

    def test_failed_unrelated_check_does_not_invalidate_genuinely_passing_criterion_evidence(self):
        ev,req=self.prepared();self.submit(req);obj=json.loads(self.report(req))
        negative=copy.deepcopy(obj['new_evidence'][0]);negative.update(id='reviewer:negative',outcome='FAIL',output='Synthetic ancillary negative observation')
        obj['new_evidence'].append(negative);obj['report']['verification'].append(negative['id'])
        self.assertEqual(self.receive(req,json.dumps(obj))['classification'],'VALID')
        self.w.reconcile_report();self.final_ready(ev);self.w.diagnostic_closure()

    def test_passive_failed_check_cannot_establish_satisfied_criterion(self):
        req=self.passive();self.intent(req);self.ack(req);raw=self.report(req,outcome='FAIL')
        r=self.w.detection_record(req['reference'],'REPORT',raw,self.obs(req,raw))
        self.assertEqual(r['classification'],'REPORT_EVIDENCE_INVALID')
        self.assertFalse(r['normal_step_acceptance']);self.assertIsNone(self.state()['active'])

    def test_cancel_before_preparation_and_release_cannot_reactivate(self):
        self.w.control('CANCEL',self.auth('CANCEL','fixture-plan:v1'))
        self.refuse('DETECTION_CANCELLED_NO_REACTIVATION',self.passive)
        self.w.control('RELEASE',self.auth('RELEASE','fixture-plan:v1'))
        self.w=DiagnosticWorkflow(self.w.fs,self.w.identity)
        self.refuse('DETECTION_CANCELLED_NO_REACTIVATION',self.passive)

    def test_pause_before_preparation_release_allows_passive_work(self):
        self.w.control('PAUSE',self.auth('PAUSE','fixture-plan:v1'))
        self.refuse('AUTHORITY_PAUSED',self.passive)
        self.w.control('RELEASE',self.auth('RELEASE','fixture-plan:v1'));req=self.passive();self.intent(req);self.ack(req)
        raw=self.report(req);r=self.w.detection_record(req['reference'],'REPORT',raw,self.obs(req,raw))
        self.assertEqual(r['classification'],'VALID');self.assertIsNone(self.state()['active'])

    def test_pause_before_intent_release_allows_exact_prepared_request(self):
        req=self.passive();self.w.control('PAUSE',self.auth('PAUSE','fixture-plan:v1'))
        self.refuse('AUTHORITY_PAUSED',lambda:self.intent(req));self.no_admitted('INTENT')
        self.w.control('RELEASE',self.auth('RELEASE','fixture-plan:v1'));self.intent(req);self.ack(req)

    def test_plan_restriction_between_preparation_and_intent_requires_supported_decision(self):
        req=self.passive();self.w.mark_plan_revision('proposed-synthetic-hash')
        self.refuse('AUTHORITY_PAUSED',lambda:self.intent(req));self.no_admitted('INTENT')
        self.w.resolve_plan_revision(self.auth('RETAIN_ORIGINAL_PLAN','fixture-plan:v1'),retain_original=True)
        self.intent(req);self.ack(req)

    def test_changed_contract_before_preparation_is_not_new_authority(self):
        p=json.loads(self.w.fs.read('project/plan.json'));p['contract']['claim']='Changed synthetic contract'
        self.w.fs.write('project/plan.json',canonical(p))
        self.refuse('CONTRACT_CHANGED',self.passive)

    def test_cancel_between_intent_and_submission_captures_but_does_not_admit(self):
        req=self.passive();self.intent(req);self.w.control('CANCEL',self.auth('CANCEL','fixture-plan:v1'))
        self.refuse('DETECTION_CANCELLED_NO_REACTIVATION',lambda:self.ack(req));self.no_admitted('SUBMISSION')
        self.assertTrue(any(isinstance(r,dict) and r.get('stage')=='SUBMISSION' and r.get('original_text')=='Exact synthetic ack' for r in self.records()))
        self.w.control('RELEASE',self.auth('RELEASE','fixture-plan:v1'))
        self.refuse('DETECTION_CANCELLED_NO_REACTIVATION',lambda:self.ack(req));self.no_admitted('SUBMISSION')

    def test_pause_between_intent_and_submission_release_allows_admission(self):
        req=self.passive();self.intent(req);self.w.control('PAUSE',self.auth('PAUSE','fixture-plan:v1'))
        self.refuse('AUTHORITY_PAUSED',lambda:self.ack(req));self.no_admitted('SUBMISSION')
        self.w.control('RELEASE',self.auth('RELEASE','fixture-plan:v1'));self.ack(req)

    def test_passive_cancel_after_submission_retains_late_report_without_result_admission(self):
        req=self.passive();self.intent(req);self.ack(req);self.w.control('CANCEL',self.auth('CANCEL','fixture-plan:v1'))
        _,raw=self.failed_check_report(req)
        self.refuse('DETECTION_CANCELLED_NO_REACTIVATION',lambda:self.w.detection_record(req['reference'],'REPORT',raw,self.obs(req,raw)))
        retained=[r for r in self.records() if isinstance(r,dict) and r.get('stage')=='REPORT']
        self.assertEqual(retained[-1]['original_text'],raw)
        self.assertFalse(any(isinstance(r,dict) and r.get('detection_classification')=='VALID' for r in self.records()))
        self.w.control('RELEASE',self.auth('RELEASE','fixture-plan:v1'))
        self.w=DiagnosticWorkflow(self.w.fs,self.w.identity)
        self.refuse('DETECTION_CANCELLED_NO_REACTIVATION',lambda:self.w.detection_record(req['reference'],'REPORT',raw,self.obs(req,raw)))
        self.assertIsNone(self.state()['active']);self.assertFalse(self.state()['completed'])
        self.trace('cancelled-late-report',{'mode':'SYNTHETIC_REPLAY_NOT_LIVE','retained':retained,
            'no_normal_closure':not self.state()['completed'],'admission':'REFUSED_AFTER_CANCEL_AND_RELEASE'})

    def test_passive_pause_late_report_release_allows_same_report_not_new_dispatch(self):
        req=self.passive();self.intent(req);self.ack(req);self.w.control('PAUSE',self.auth('PAUSE','fixture-plan:v1'))
        raw=self.report(req,status='NOT_ESTABLISHED',outcome='FAIL')
        self.refuse('AUTHORITY_PAUSED',lambda:self.w.detection_record(req['reference'],'REPORT',raw,self.obs(req,raw)))
        self.w.control('RELEASE',self.auth('RELEASE','fixture-plan:v1'))
        r=self.w.detection_record(req['reference'],'REPORT',raw,self.obs(req,raw))
        self.assertEqual(r['classification'],'VALID');self.assertFalse(r['normal_step_acceptance'])
        self.refuse('DETECTION_STAGE_ALREADY_RECORDED',lambda:self.intent(req))

    def test_plan_restriction_between_submission_and_report_blocks_result_only(self):
        req=self.passive();self.intent(req);self.ack(req);self.w.mark_plan_revision('proposed-synthetic-hash')
        raw=self.report(req)
        self.refuse('AUTHORITY_PAUSED',lambda:self.w.detection_record(req['reference'],'REPORT',raw,self.obs(req,raw)))
        self.assertTrue(any(isinstance(r,dict) and r.get('original_text')==raw for r in self.records()))
        self.w.resolve_plan_revision(self.auth('RETAIN_ORIGINAL_PLAN','fixture-plan:v1'),retain_original=True)
        self.assertEqual(self.w.detection_record(req['reference'],'REPORT',raw,self.obs(req,raw))['classification'],'VALID')

    def test_normalized_submission_status_retains_full_original_result(self):
        _,req=self.prepared();self.w.dispatch_intent(req['reference'])
        original='Exact SYNTHETIC tool result including auxiliary metadata, not a summary'
        ref=self.w.record_submission(req['reference'],'ACKNOWLEDGED',self.obs(req,original_event=original))
        record=self.w.store.get(ref,'submission_observation')
        self.assertEqual(record['observation']['original_event'],original)
        self.assertEqual(record['result'],'ACKNOWLEDGED');self.assertIsNone(self.state()['active']['report'])
