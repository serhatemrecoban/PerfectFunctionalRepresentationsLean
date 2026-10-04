"""Model-free REPLAYED delivery/format controls, never native reviewer calls."""
import copy
import json
import unittest

from diagnostic import create_toy, DiagnosticWorkflow, CRITERION
from safe_store import BUNDLE, Refusal, canonical
from test_integration import IntegrationTests


class DeliveryTests(unittest.TestCase):
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

    def setUp(self):
        self.n=0
        self.w=create_toy('case-a','REPLAYED','replay-parent','replay-reviewer',
            profile={'parent_role':'/root','parent_task_id':'replay-parent'})
        self.w.initialize(['TEST-S01'],[CRITERION],self.auth('APPROVE_PLAN','fixture-plan:v1'))

    def arrival(self,req,raw):
        return self.obs(req,raw,original_event=json.dumps({'Message Type':'FINAL_ANSWER',
            'Task name':'/root','Sender':self.w.identity.reviewer,'Payload':raw}))

    def confirm(self,req,receipt,raw,observation=None,approval=None):
        return self.w.confirm_delivery(req['reference'],receipt,raw,
            self.arrival(req,raw) if observation is None else observation,
            self.auth('CONFIRM_DIAGNOSTIC_DELIVERY',req['reference']) if approval is None else approval)

    def confirmation_records(self):
        return [self.w.store.get(ref) for ref in self.state()['records']
            if self.w.store.get(ref).get('delivery_kind')=='REPORT_BACKED']

    def passive(self,status='UNCERTAIN'):
        req=self.w.detection_request('fixture-review-request:passive')
        self.w.detection_record(req['reference'],'INTENT','Synthetic replay intent',{})
        observation=self.obs(req,submission_result=status,original_event=json.dumps(''))
        if status=='ACKNOWLEDGED':
            result=self.w.detection_record(req['reference'],'SUBMISSION','',observation)
            receipt=result['record']
        else:
            self.refuse('DETECTION_SUBMISSION_UNCONFIRMED',lambda:self.w.detection_record(
                req['reference'],'SUBMISSION','',observation))
            receipt=[ref for ref in self.state()['records'] if self.w.store.get(ref).get('stage')=='SUBMISSION'][-1]
        return req,receipt

    def test_uncertain_report_confirmation_then_explicit_accept_reconcile_close(self):
        ev,req=self.prepared();receipt=self.submit(req,'UNCERTAIN');raw=self.report(req)
        original=self.w.fs.read('durable/objects/'+receipt+'.json')
        c=self.confirm(req,receipt,raw)
        self.assertFalse(c['report_accepted']);self.assertIsNone(self.state()['active']['report'])
        self.assertFalse(self.state()['completed']);self.assertEqual(self.state()['active']['phase'],'REVIEW_PENDING')
        self.assertEqual(self.w.fs.read('durable/objects/'+receipt+'.json'),original)
        self.w=DiagnosticWorkflow(self.w.fs,self.w.identity)
        result=self.receive(req,raw);self.assertEqual(result['classification'],'VALID')
        self.assertEqual(self.w.store.get(result['capture'],'capture')['original_text'],raw)
        self.w.reconcile_report();self.final_ready(ev)
        self.assertFalse(self.w.diagnostic_closure()['production_acceptance'])
        self.assertEqual(self.w.store.get(receipt,'submission_observation')['result'],'UNCERTAIN')

    def test_no_report_cannot_confirm_or_complete(self):
        _,req=self.prepared();receipt=self.submit(req,'UNCERTAIN')
        with self.assertRaises(Refusal):self.confirm(req,receipt,'',self.obs(req))
        self.assertFalse(self.confirmation_records())
        self.refuse('SUBMISSION_UNCERTAINTY_REQUIRES_SEPARATE_ADJUDICATION',
            lambda:self.w.recover(self.auth('RECOVER_RETRY','TEST-S01'),'retry'))
        self.assertEqual(self.next('after-absence')['status'],'SKIPPED_UNCLOSED')

    def test_original_output_and_observed_envelope_required(self):
        _,req=self.prepared();receipt=self.submit(req,'UNCERTAIN');raw=self.report(req)
        variants=[{'complete':False},{'text_role':'PARENT_SUMMARY'},{'extracted_text':'summary'},
            {'parent':'wrong-parent'},{'reviewer':'wrong-sender'},{'request_ref':'wrong'},
            {'origin':'UNSIGNED_OPERATOR_COPY'},{'original_event':'null'}]
        for changes in variants:
            o=self.arrival(req,raw);o.update(changes)
            with self.subTest(changes=changes),self.assertRaises(Refusal):self.confirm(req,receipt,raw,o)
        for field,value in [('Sender','body-claimed-reviewer'),('Task name','other-parent-role'),('Payload','summary')]:
            o=self.arrival(req,raw);e=json.loads(o['original_event']);e[field]=value;o['original_event']=json.dumps(e)
            with self.subTest(field=field),self.assertRaises(Refusal):self.confirm(req,receipt,raw,o)
        self.assertFalse(self.confirmation_records());self.assertFalse(self.state()['request_registry'][req['payload']['request_id']]['dispatched'])

    def test_wrong_request_attempt_binding_source_kind_refused(self):
        _,req=self.prepared();receipt=self.submit(req,'UNCERTAIN')
        for field,value in [('request_id','wrong'),('attempt',2),('source_ref','wrong'),('binding_digest','wrong'),('kind','PLAN')]:
            body=json.loads(self.report(req));body['report'][field]=value;raw=json.dumps(body)
            with self.subTest(field=field),self.assertRaises(Refusal):self.confirm(req,receipt,raw)
        self.assertFalse(self.confirmation_records())

    def test_current_source_must_match_then_positive_continuation(self):
        _,req=self.prepared();receipt=self.submit(req,'UNCERTAIN');raw=self.report(req)
        original=self.w.fs.read('project/Case.lean');self.w.fs.write('project/Case.lean',original+b'\n')
        self.refuse('SOURCE_DIVERGED',lambda:self.confirm(req,receipt,raw))
        self.w.fs.write('project/Case.lean',original)
        self.assertEqual(self.confirm(req,receipt,raw)['delivery'],'CONFIRMED_BY_ORIGINAL_REPORT')

    def test_negative_report_confirms_delivery_not_success(self):
        ev,req=self.prepared();receipt=self.submit(req,'UNCERTAIN')
        raw=self.report(req,[self.finding()],'CONTRADICTED_BY_FINDING',outcome='FAIL')
        self.confirm(req,receipt,raw);r=self.receive(req,raw)
        self.assertEqual(r['classification'],'VALID')
        e=self.w.store.get(r['capture'],'capture')['parsed']['verification'][0]
        self.assertEqual(self.w.store.get(e,'evidence')['outcome'],'FAIL')
        self.w.reconcile_report();self.final_ready(ev)
        with self.assertRaises(Refusal):self.w.diagnostic_closure()
        self.assertFalse(self.state()['completed'])

    def test_confirmation_is_not_report_validation(self):
        _,req=self.prepared();receipt=self.submit(req,'UNCERTAIN')
        body=json.loads(self.report(req));del body['report']['criteria'];raw=json.dumps(body)
        self.confirm(req,receipt,raw)
        self.assertEqual(self.receive(req,raw)['classification'],'INCOMPLETE')
        self.assertIsNone(self.state()['active']['report']);self.assertFalse(self.state()['completed'])

    def test_pause_can_release_but_cancel_cannot(self):
        _,req=self.prepared();receipt=self.submit(req,'UNCERTAIN');raw=self.report(req)
        self.w.control('PAUSE',self.auth('PAUSE','fixture-plan:v1'))
        self.refuse('AUTHORITY_PAUSED',lambda:self.confirm(req,receipt,raw))
        self.w.control('RELEASE',self.auth('RELEASE','fixture-plan:v1'))
        self.confirm(req,receipt,raw)
        self.setUp();_,req=self.prepared();receipt=self.submit(req,'UNCERTAIN');raw=self.report(req)
        self.w.control('CANCEL',self.auth('CANCEL','fixture-plan:v1'))
        self.w.control('RELEASE',self.auth('RELEASE','fixture-plan:v1'))
        with self.assertRaises(Refusal):self.confirm(req,receipt,raw)
        self.assertFalse(self.confirmation_records())

    def test_other_and_durable_blockers_not_cleared(self):
        _,req=self.prepared();receipt=self.submit(req,'UNCERTAIN');raw=self.report(req)
        self.w.block('LEAD_DECISION_REQUIRED');self.w.block('SUSPENDED')
        with self.assertRaises(Refusal):self.confirm(req,receipt,raw)
        self.assertTrue(self.state()['decision_obligations']);self.assertEqual(self.state()['active']['blocker'],'SUSPENDED')
        self.setUp();_,req=self.prepared();receipt=self.submit(req,'UNCERTAIN');raw=self.report(req)
        self.w.block('SUSPENDED')
        self.refuse('DELIVERY_UNRELATED_BLOCKER',lambda:self.confirm(req,receipt,raw))

    def test_duplicate_confirmation_idempotent_conflict_persistent(self):
        _,req=self.prepared();receipt=self.submit(req,'UNCERTAIN');raw=self.report(req)
        approval=self.auth('CONFIRM_DIAGNOSTIC_DELIVERY',req['reference'])
        first=self.confirm(req,receipt,raw,approval=approval)
        self.assertEqual(self.confirm(req,receipt,raw,approval=approval),first)
        self.assertEqual(len(self.confirmation_records()),1)
        self.refuse('REPORT_CONFLICT_UNRESOLVED',lambda:self.confirm(req,receipt,raw+' '))
        self.w.block('SUSPENDED')
        self.refuse('REPORT_CONFLICT_UNRESOLVED',lambda:self.confirm(req,receipt,raw))

    def test_conflicting_receive_after_delivery_never_accepted(self):
        _,req=self.prepared();receipt=self.submit(req,'UNCERTAIN');raw=self.report(req)
        self.confirm(req,receipt,raw)
        self.assertEqual(self.receive(req,raw+' ')['classification'],'CONFLICTING_DUPLICATE')
        self.assertIsNone(self.state()['active']['report'])

    def test_existing_deferred_report_can_continue_after_confirmation(self):
        ev,req=self.prepared();receipt=self.submit(req,'UNCERTAIN');raw=self.report(req)
        self.assertEqual(self.receive(req,raw)['classification'],'LATE_VALID_REPORT')
        self.confirm(req,receipt,raw)
        self.w.recover(self.auth('RECOVER_RECONCILE','TEST-S01'),'reconcile')
        self.w.reconcile_report();self.final_ready(ev);self.w.diagnostic_closure()

    def test_explicit_failures_refuse_both_paths(self):
        _,req=self.prepared();receipt=self.submit(req,'FAILED')
        self.refuse('DELIVERY_EXPLICIT_FAILURE',lambda:self.confirm(req,receipt,self.report(req)))
        self.setUp();req,receipt=self.passive('FAILED')
        self.refuse('DELIVERY_EXPLICIT_FAILURE',lambda:self.confirm(req,receipt,self.report(req)))

    def test_passive_positive_negative_and_duplicates(self):
        for negative in [False,True]:
            self.setUp();req,receipt=self.passive()
            raw=self.report(req,[self.finding()] if negative else [],
                'CONTRADICTED_BY_FINDING' if negative else 'SATISFIED',outcome='FAIL' if negative else 'PASS')
            prior=self.w.fs.read('durable/objects/'+receipt+'.json')
            self.confirm(req,receipt,raw)
            self.assertEqual(self.w.fs.read('durable/objects/'+receipt+'.json'),prior)
            r=self.w.detection_record(req['reference'],'REPORT',raw,self.arrival(req,raw))
            self.assertEqual(r['classification'],'VALID');self.assertFalse(r['normal_step_acceptance'])
            self.assertEqual(r['parsed']['criteria'][0]['status'],'CONTRADICTED_BY_FINDING' if negative else 'SATISFIED')
            self.assertIsNone(self.state()['active']);self.assertFalse(self.state()['completed'])
            self.assertEqual(self.w.detection_record(req['reference'],'REPORT',raw,self.arrival(req,raw))['classification'],'IDENTICAL_DUPLICATE')

    def test_passive_pause_cancel_and_conflict_preserved(self):
        req,receipt=self.passive();raw=self.report(req)
        self.w.control('PAUSE',self.auth('PAUSE','fixture-plan:v1'))
        self.refuse('AUTHORITY_PAUSED',lambda:self.confirm(req,receipt,raw))
        self.w.control('RELEASE',self.auth('RELEASE','fixture-plan:v1'));self.confirm(req,receipt,raw)
        self.assertEqual(self.w.detection_record(req['reference'],'REPORT',raw+' ',self.arrival(req,raw+' '))['classification'],'CONFLICTING_DUPLICATE')
        self.refuse('REPORT_CONFLICT_UNRESOLVED',lambda:self.confirm(req,receipt,raw))
        self.setUp();req,receipt=self.passive();raw=self.report(req)
        self.w.control('CANCEL',self.auth('CANCEL','fixture-plan:v1'));self.w.control('RELEASE',self.auth('RELEASE','fixture-plan:v1'))
        self.refuse('DETECTION_CANCELLED_NO_REACTIVATION',lambda:self.confirm(req,receipt,raw))

    def test_saved_report_replay_preserves_prose_and_original(self):
        ev,req=self.prepared();receipt=self.submit(req,'UNCERTAIN')
        original=(BUNDLE/'fixtures/saved-report.json').read_bytes();body=json.loads(original)
        prose=body['report']['earlier_reconciliation']
        # Only correlation/evidence ownership fields are rebound to this isolated
        # REPLAYED fixture. Mathematical prose, verdicts and outputs are unchanged.
        from dataclasses import asdict
        from safe_store import digest
        for k in ['request_id','attempt','source_ref','kind']:body['report'][k]=req['payload'][k]
        body['report']['binding_digest']=digest(asdict(self.w.identity))
        for e in body['new_evidence']:e['actor']=self.w.identity.reviewer;e['source_ref']=req['payload']['source_ref']
        raw=json.dumps(body,ensure_ascii=False)
        self.confirm(req,receipt,raw);r=self.receive(req,raw)
        self.assertEqual(r['classification'],'VALID')
        cap=self.w.store.get(r['capture'],'capture')
        self.assertEqual(cap['original_text'],raw);self.assertEqual(cap['parsed']['earlier_reconciliation'],[prose])
        self.assertEqual((BUNDLE/'fixtures/saved-report.json').read_bytes(),original)
        self.w.reconcile_report();self.final_ready(ev);self.w.diagnostic_closure()

    def test_prose_does_not_dispose_material_concern(self):
        ev,req=self.prepared();self.submit(req)
        body=json.loads(self.report(req,[self.finding()]));body['report']['earlier_reconciliation']='Still unresolved.\nKeep this exact text. '
        raw=json.dumps(body);r=self.receive(req,raw)
        self.assertEqual(self.w.store.get(r['capture'],'capture')['parsed']['earlier_reconciliation'],[body['report']['earlier_reconciliation']])
        self.w.reconcile_report();self.final_ready(ev)
        self.refuse('MATERIAL_FINDING_OPEN',self.w.diagnostic_closure)

    def test_existing_lists_preserved_and_other_invalid_types_refused(self):
        _,req=self.prepared();self.submit(req)
        body=json.loads(self.report(req))
        for bad in [None,{},4]:
            body['report']['earlier_reconciliation']=bad
            self.assertEqual(self.receive(req,json.dumps(body))['classification'],'INCOMPLETE')
        body['report']['earlier_reconciliation']=['Exact existing list note',{'retained':'structured entry'}]
        r=self.receive(req,json.dumps(body))
        self.assertEqual(self.w.store.get(r['capture'],'capture')['parsed']['earlier_reconciliation'],body['report']['earlier_reconciliation'])
