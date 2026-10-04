"""IR-007/008 public-operation interactions; low-level tests explicitly labeled."""
from unittest.mock import patch
from test_workflow import FixtureCase
from workflow import Workflow
from safe_store import Refusal

QUESTION = "Investigate the independently reopened concern"

class Remediation02Tests(FixtureCase):
    def rebuild(self):self.w=Workflow(self.fs,self.identity)

    def reopened(self, independent_repeats=True):
        f=self.finding(True);ev=self.to_self_review([f]);self.w.reassess({f['id']:'Address self concern'})
        self.w.disposition(f['id'],'RESOLVED','Applicable initial evidence',[ev])
        req=self.w.prepare_review('fixture-review-request:initial',[ev]);self.w.simulate_dispatch()
        handoff=self.state()['active']['initial_handoff']
        raw,env=self.report(req,ev,[f] if independent_repeats else [])
        self.w.receive(raw,env);self.w.reconcile_report()
        return ev,f,handoff,raw,env

    def target(self, ev, f, ids=None):
        self.w.extra_review(QUESTION,[f['id']] if ids is None else ids,'Source argument','PRODUCTIVE','Concrete uncertainty remains')
        return self.w.prepare_review('fixture-review-request:target',[ev],QUESTION)

    def escalation(self, kind):
        ev,_,_,_=self.to_final_validation()
        self.w.extra_review('Need substantive decision',[],'Lead decision',kind,'Concrete unresolved alternatives')
        self.w.block('SUSPENDED');self.rebuild()
        refs=list(self.state()['progress_escalations']);self.assertEqual(len(refs),1)
        for mode in ['continue','retry','reconcile']:
            self.refuse('PROGRESS_DECISION_REQUIRED',lambda:self.w.recover(self.auth('RECOVER_'+mode.upper(),'TEST-S01'),mode))
        self.w.control('PAUSE',self.auth('PAUSE','fixture-plan:v1'))
        self.w.control('RELEASE',self.auth('RELEASE','fixture-plan:v1'))
        self.w.block('SOURCE_DIVERGED')
        self.refuse('PROGRESS_DECISION_REQUIRED',lambda:self.w.recover(self.auth('RECOVER_RETRY','TEST-S01'),'retry'))
        self.assertEqual(self.state()['progress_escalations'],refs)
        with self.assertRaises(Refusal):self.w.extra_review('Replace decision',[],'Evidence','PRODUCTIVE','Try to continue')
        with self.assertRaises(Refusal):self.ready(ev)
        with self.assertRaises(Refusal):self.w.close()
        self.assertFalse(self.state()['completed']);self.assertEqual(self.start()['status'],'SKIPPED_UNCLOSED')

    def test_IR007_oscillation_survives_recovery_controls_and_reconstruction(self):self.escalation('ESCALATE_OSCILLATION')
    def test_IR007_nonprogress_survives_recovery_controls_and_reconstruction(self):self.escalation('ESCALATE_NONPROGRESS')
    def test_IR007_incompatibility_survives_recovery_controls_and_reconstruction(self):self.escalation('ESCALATE_INCOMPATIBLE')

    def test_IR007_ordinary_failed_retry_still_closes_and_advances(self):
        ev,_=self.to_pending();self.w.wait_event('FAILED')
        self.w.recover(self.auth('RECOVER_RETRY','TEST-S01'),'retry');self.rebuild()
        req=self.w.prepare_review('fixture-review-request:ordinary-retry',[ev]);self.w.simulate_dispatch()
        self.w.receive(*self.report(req,ev));self.w.reconcile_report();self.w.finish_corrections();self.ready(ev);self.w.close()
        self.assertEqual(self.state()['progress_escalations'],[]);self.assertEqual(self.start()['target'],'TEST-S02')

    def test_IR007_supported_restore_keeps_substantive_barrier(self):
        self.to_final_validation();self.w.extra_review('Decision',[],'Lead decision','ESCALATE_NONPROGRESS','No progress')
        self.w.block('SUSPENDED');tip=self.w.journal.backup('fixture-backup-progress')
        self.w.journal.restore('fixture-backup-progress',tip,authorized=True)
        self.w=Workflow(self.fs,self.identity,'restored')
        self.w.validate_restored_binding_and_source(expected_tip=tip)
        self.refuse('PROGRESS_DECISION_REQUIRED',lambda:self.w.recover(self.auth('RECOVER_RETRY','TEST-S01'),'retry'))
        self.assertFalse(self.state()['completed'])

    def test_IR007_fault_injection_missing_escalation_registry_refuses_reconstruction(self):
        self.to_final_validation();self.w.extra_review('Decision',[],'Lead decision','ESCALATE_OSCILLATION','Oscillation')
        state=self.w.journal.load()
        def corrupt(s):s['progress_escalations']=[];return s
        self.w.journal.transact(state['rev'],'FAULT_DROP_ESCALATION_REGISTRY',corrupt)
        self.rebuild();self.refuse('ESCALATION_REGISTRY_MISMATCH',self.w.inspect)
        self.assertEqual(self.start()['status'],'SKIPPED_INVALID_STATE')

    def test_IR007_fault_injection_favorable_phase_does_not_bypass_entry_gates(self):
        self.to_final_validation();self.w.extra_review('Decision',[],'Lead decision','ESCALATE_OSCILLATION','Oscillation')
        for phase,operation in [('REVIEW_READY',lambda:self.w.prepare_review('fixture-review-request:fault',[ ])),
                                ('REVIEW_READY',self.w.simulate_dispatch),('CLOSE_READY',self.w.close)]:
            state=self.w.journal.load()
            def corrupt(s):s['active']['phase']=phase;s['active']['blocker']=None;return s
            self.w.journal.transact(state['rev'],'FAULT_FAVORABLE_PHASE',corrupt)
            self.rebuild();self.refuse('PROGRESS_DECISION_REQUIRED',operation)
        self.assertFalse(self.state()['completed'])

    def test_IR008_targeted_review_keeps_open_concern_until_supported_final_disposition(self):
        ev,f,handoff,_,_=self.reopened();original=self.w.store.get(handoff,'self_handoff')
        req=self.target(ev,f);self.rebuild();self.w.simulate_dispatch()
        self.assertEqual(self.state()['active']['findings'][f['id']]['history'][-1]['status'],'OPEN')
        self.w.receive(*self.report(req,ev,[f]));self.w.reconcile_report();self.w.finish_corrections();self.ready(ev)
        self.refuse('MATERIAL_FINDING_OPEN',self.w.close)
        self.w.refresh_final('Resolve challenged finding');self.w.disposition(f['id'],'RESOLVED','New sufficient evidence',[ev])
        self.ready(ev);self.w.close()
        cert=self.w.store.get(self.state()['completed']['TEST-S01'],'closure')
        self.assertEqual(cert['initial_handoff'],handoff);self.assertEqual(self.w.store.get(handoff,'self_handoff'),original)
        self.assertEqual(self.start()['target'],'TEST-S02')

    def test_IR008_initial_unresolved_self_concern_still_cannot_dispatch(self):
        f=self.finding(True);ev=self.to_self_review([f]);self.w.reassess({f['id']:'Investigate'})
        self.refuse('MATERIAL_FINDING_OPEN',lambda:self.w.prepare_review('fixture-review-request:incomplete',[ev]))
        with self.assertRaises(Refusal):self.w.extra_review(QUESTION,[f['id']],'Evidence','PRODUCTIVE','Request bypass')
        self.assertIsNone(self.state()['active']['initial_handoff']);self.assertFalse(self.state()['active']['requests'])

    def test_IR008_unlinked_reopened_self_finding_stays_blocked(self):
        ev,f,_,_,_=self.reopened()
        self.refuse('MATERIAL_FINDING_OPEN',lambda:self.target(ev,f,[]))
        self.assertEqual(len(self.state()['active']['requests']),1)

    def test_IR008_own_reclassification_not_independent_reopening(self):
        ev,f,_,_,_=self.reopened(False)
        self.w.reassess_finding(f['id'],True,'Own new assessment',[ev])
        self.refuse('INDEPENDENT_REOPEN_REQUIRED',lambda:self.target(ev,f))

    def test_IR008_stale_validation_after_edit_refuses(self):
        ev,f,_,_,_=self.reopened();self.w.begin_corrections()
        self.w.own_edit('project/src/Example.lean','def fixtureValue : Nat := 2\n')
        self.refuse('EVIDENCE_STALE',lambda:self.target(ev,f))

    def test_IR008_fresh_validation_after_bounded_edit_allows_targeted_round(self):
        _,f,_,_,_=self.reopened();self.w.begin_corrections()
        self.w.own_edit('project/src/Example.lean','def fixtureValue : Nat := 2\n')
        fresh=self.w.add_evidence('Current source validation');self.target(fresh,f);self.w.simulate_dispatch()
        self.assertEqual(self.state()['active']['phase'],'REVIEW_PENDING')
        self.assertEqual(self.state()['active']['findings'][f['id']]['history'][-1]['status'],'OPEN')

    def test_IR008_source_changed_after_preparation_blocks_dispatch(self):
        ev,f,_,_,_=self.reopened();self.target(ev,f)
        self.fs.write('project/src/Example.lean','def fixtureValue : Nat := 3\n')
        self.refuse('SOURCE_DIVERGED',self.w.simulate_dispatch)

    def test_IR008_finding_changed_after_preparation_blocks_dispatch(self):
        ev,f,_,_,_=self.reopened();self.target(ev,f)
        self.w.reassess_finding(f['id'],True,'Later assessment changes frozen review context',[ev])
        self.refuse('ADDITIONAL_FINDING_CHANGED',self.w.simulate_dispatch)
        self.assertEqual(self.state()['active']['pending']['status'],'READY')

    def test_IR008_pause_release_preserves_targeted_continuation(self):
        ev,f,_,_,_=self.reopened();self.target(ev,f)
        self.w.control('PAUSE',self.auth('PAUSE','fixture-plan:v1'))
        self.refuse('AUTHORITY_PAUSED',self.w.simulate_dispatch)
        self.w.control('RELEASE',self.auth('RELEASE','fixture-plan:v1'));self.w.simulate_dispatch()
        self.assertEqual(self.state()['active']['phase'],'REVIEW_PENDING')

    def test_IR008_cancel_release_cannot_revive_prepared_target(self):
        ev,f,_,_,_=self.reopened();self.target(ev,f)
        self.w.control('CANCEL',self.auth('CANCEL','fixture-plan:v1'))
        self.w.control('RELEASE',self.auth('RELEASE','fixture-plan:v1'));self.w.block('SUSPENDED')
        with self.assertRaises(Refusal):self.w.simulate_dispatch()
        self.refuse('REQUEST_REACTIVATION_UNSUPPORTED',lambda:self.w.recover(self.auth('RECOVER_RETRY','TEST-S01'),'retry'))
        self.assertFalse(self.state()['completed'])

    def test_IR008_conflicting_capture_still_blocks_targeted_dispatch(self):
        ev,f,_,raw,env=self.reopened();self.target(ev,f)
        self.assertEqual(self.w.receive(raw+' ',env)['classification'],'CONFLICTING_DUPLICATE')
        with self.assertRaises(Refusal):self.w.simulate_dispatch()
        self.assertFalse(self.state()['completed'])

    def test_IR008_targeted_transport_retry_inherits_same_round_not_new_authority(self):
        ev,f,handoff,_,_=self.reopened();req=self.target(ev,f)
        round_ref=self.w.store.get(req['reference'],'review_request')['round_decision']
        self.w.simulate_dispatch();self.w.wait_event('FAILED')
        self.w.recover(self.auth('RECOVER_RETRY','TEST-S01'),'retry');self.rebuild()
        retry=self.w.prepare_review('fixture-review-request:target-retry',[ev],QUESTION);self.w.simulate_dispatch()
        self.assertEqual(self.w.store.get(retry['reference'],'review_request')['round_decision'],round_ref)
        self.assertEqual(self.state()['active']['initial_handoff'],handoff)
        self.assertEqual(retry['payload']['attempt'],3)
        self.w.receive(*self.report(retry,ev));self.w.reconcile_report()
        self.w.disposition(f['id'],'RESOLVED','Supported after retry',[ev]);self.w.finish_corrections();self.ready(ev);self.w.close()

    def test_IR008_substantive_escalation_cannot_be_replaced_by_targeted_round(self):
        ev,f,_,_,_=self.reopened()
        self.w.extra_review(QUESTION,[f['id']],'Lead choice','ESCALATE_INCOMPATIBLE','Incompatible requirements')
        self.w.block('SUSPENDED')
        self.refuse('PROGRESS_DECISION_REQUIRED',lambda:self.w.recover(self.auth('RECOVER_RETRY','TEST-S01'),'retry'))
        with self.assertRaises(Refusal):self.target(ev,f)
        self.assertFalse(self.state()['completed'])

    def test_IR008_fault_injection_unfinished_edit_still_blocks_targeted_handoff(self):
        ev,f,_,_,_=self.reopened();self.w.begin_corrections();original_write=self.fs.write
        def fail(path,*args,**kwargs):
            if path=='project/src/Example.lean':raise OSError('injected source-write interruption')
            return original_write(path,*args,**kwargs)
        with patch.object(self.fs,'write',side_effect=fail):
            with self.assertRaises(OSError):self.w.own_edit('project/src/Example.lean','changed')
        self.refuse('UNFINISHED_EDIT',lambda:self.target(ev,f))
