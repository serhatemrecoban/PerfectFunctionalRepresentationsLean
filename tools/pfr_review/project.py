"""PFR supervised adapter. Native operations stay in the calling agent.

Original fixture constructors remain guarded. This separate adapter reads real
Git/Lean/Markdown sources and writes only explicitly owned private records.
It validates structural evidence; it cannot authenticate a human or prove math.
"""
from dataclasses import asdict, dataclass
import copy
import json
import os
from pathlib import Path
import re
import sys
import uuid

CORE = Path(__file__).absolute().parent / 'core'
sys.path.insert(0, str(CORE))
from safe_store import FixtureFS, Store, Journal, Refusal, canonical, digest, require, strict_json, no_indirection
from contracts import Criterion, render_request, classify_report, same_source, delta
from workflow import Workflow
from diagnostic import DiagnosticWorkflow
from project_source import inspect_checkout, snapshot, _root, _path

PROJECT_TAG = 'PFR_SUPERVISED_REVIEW_V1'
TEST_TAG = 'PFR_SOURCE_COPY_TEST_V1'
PROFILE = {'model':'gpt-6-astra','reasoning_effort':'ultra','fork_turns':'none'}
PLAN_START = '<!-- pfr-review-status:start -->'
PLAN_END = '<!-- pfr-review-status:end -->'
IDENTITY_REPAIR_PATHS = frozenset({
    'tools/pfr_review/core/workflow.py', 'tools/pfr_review/project.py',
    'tools/pfr_review/cli.py', 'tools/pfr_review/tests/test_finding_identity.py',
    'tools/pfr_review/README.md', 'docs/review-protocol.md', 'docs/review-operations.md'})


def plan_text(raw):
    """Only an explicitly marked status block is editorial; no Markdown parser."""
    text=raw.decode('utf-8')
    require(text.count(PLAN_START)==text.count(PLAN_END) and text.count(PLAN_START)<=1,
            'PLAN_STATUS_MARKERS')
    if PLAN_START in text:
        before,rest=text.split(PLAN_START)
        metadata,after=rest.split(PLAN_END)
        return before+PLAN_START+PLAN_END+after
    return text


def user_origin(value):
    require(isinstance(value,dict) and value.get('role')=='user'
            and isinstance(value.get('reference'),str) and value['reference'].strip()
            and isinstance(value.get('original_text'),str) and value['original_text'].strip(),
            'ACTUAL_USER_REFERENCE_REQUIRED')
    return copy.deepcopy(value)


class ProjectRecordFS(FixtureFS):
    """Separate guarded private store. Inherited safe IO, never fixture cleanup."""
    def __init__(self, checkout, relative, *, create=False, test=False):
        self.checkout=_root(checkout)
        self.record_tag=TEST_TAG if test else PROJECT_TAG
        require(re.fullmatch(r'(?:chunks/PFR-C[0-9]{2}(?:/(?:execution|plan-[a-z0-9-]+))?|setup)',relative),
                'PRIVATE_RECORD_LOCATION')
        self.root=self.checkout/'.pfr-review'/relative
        no_indirection(self.root)
        installation=self.checkout/'.pfr-review/installation.json'
        require(installation.is_file(),'RUN_SETUP_FIRST')
        self.installation=strict_json(installation.read_bytes())
        require(self.installation.get('tag')==self.record_tag
                and self.installation.get('checkout')==str(self.checkout),'PRIVATE_STORE_BINDING')
        marker=self.root/'.project-owner.json'
        if create:
            require(not self.root.exists(),'PROJECT_STORE_ALREADY_EXISTS')
            self.root.mkdir(parents=True)
            no_indirection(self.root)
            with marker.open('xb') as f:
                f.write(canonical({'tag':self.record_tag,'root':str(self.root),'owner':uuid.uuid4().hex}))
        no_indirection(marker)
        require(marker.is_file(),'NO_PROJECT_OWNERSHIP')
        self.owner=strict_json(marker.read_bytes())
        require(self.owner.get('tag')==self.record_tag and self.owner.get('root')==str(self.root),
                'PROJECT_OWNER_MISMATCH')

    def path(self, rel):
        require(isinstance(rel,str) and re.fullmatch(r'[A-Za-z0-9_.\-/]+',rel) is not None,
                'UNSAFE_PATH')
        require(all(x not in {'','.', '..'} and not x.endswith(('.', ' '))
                    and x.split('.')[0].upper() not in {'CON','PRN','AUX','NUL',*[f'COM{i}' for i in range(10)],*[f'LPT{i}' for i in range(10)]}
                    for x in rel.split('/')), 'UNSAFE_PATH')
        no_indirection(self.root)
        marker=self.root/'.project-owner.json'
        no_indirection(marker)
        require(strict_json(marker.read_bytes())==self.owner,'OWNERSHIP_CHANGED')
        target=self.root/rel
        no_indirection(target)
        require(target.resolve().is_relative_to(self.root.resolve()),'PATH_ESCAPE')
        return target

    def cleanup_scratch(self):
        raise Refusal('PROJECT_RECORDS_EXCLUDED_FROM_CLEANUP')


def setup(checkout, approval, *, test=False):
    root=_root(checkout); info=inspect_checkout(root)
    user_origin(approval)
    tag=TEST_TAG if test else PROJECT_TAG
    private=root/'.pfr-review'; no_indirection(private)
    private.mkdir(exist_ok=True)
    path=private/'installation.json'; no_indirection(path)
    if path.exists():
        data=strict_json(path.read_bytes())
        require(data.get('tag')==tag and data.get('checkout')==str(root),'INSTALLATION_CONFLICT')
        return data
    data={'schema':1,'tag':tag,'checkout':str(root),'supervised_only':True,
          'approval':approval,'historical_prerequisite':info['c01'],
          'profile_requested':PROFILE,'mathematical_execution_authorized':False,
          'storage_limit':'Local disk only; manual backup outside this checkout is required for device-loss protection.'}
    with path.open('xb') as f:f.write(canonical(data))
    return data


def bind(checkout, chunk, parent, reviewer, creation, approval, *, test=False):
    require(re.fullmatch(r'PFR-C[0-9]{2}',chunk) and chunk!='PFR-C01','CHUNK_BINDING')
    require(parent==os.environ.get('CODEX_THREAD_ID') and parent!=reviewer,'WRONG_ORIGINATING_PARENT')
    require(reviewer and reviewer!='/root/pfr_native_toy_20260909','DIAGNOSTIC_REVIEWER_NOT_TRANSFERABLE')
    user_origin(approval)
    require(isinstance(creation,dict) and creation.get('canonical_reviewer')==reviewer
            and creation.get('requested')==PROFILE and creation.get('original_result')
            and creation.get('reference') and creation.get('parent_role'), 'ORIGINAL_REVIEWER_CREATION_REQUIRED')
    original=creation['original_result']
    if isinstance(original,str):original=strict_json(original)
    require(isinstance(original,dict) and original.get('task_name')==reviewer,'CREATION_IDENTITY_MISMATCH')
    effective=creation.get('effective_reviewer')
    if effective is not None:
        require(isinstance(effective,dict),'EFFECTIVE_PROFILE_SCHEMA')
        require(effective.get('model') in {None,PROFILE['model']}
                and effective.get('reasoning_effort') in {None,PROFILE['reasoning_effort']},'OBSERVED_PROFILE_CONFLICT')
    # The agent verifies the actual native result, not an inferred UUID/profile.
    # This supplied record and instruction-only isolation are cooperative limits.
    fs=ProjectRecordFS(checkout,'chunks/'+chunk,create=True,test=test)
    data={'chunk':chunk,'parent':parent,'reviewer':reviewer,'creation':creation,'approval':approval,
          'input_mode':'REPLAYED' if test else 'OBSERVED','tag':fs.record_tag,
          'effective_parent':creation.get('effective_parent'),'effective_reviewer':effective}
    fs.write('binding.json',canonical(data),exclusive=True)
    return data


@dataclass(frozen=True)
class ProjectIdentity:
    project: str
    checkout: str
    chunk: str
    parent: str
    reviewer: str
    session: str
    input_mode: str
    tag: str
    generation: int=1
    host: str='local'
    schema: int=1

    def validate(self, fs):
        require(type(fs) is ProjectRecordFS and self.checkout==str(fs.checkout)
                and self.project=='PerfectFunctionalRepresentationsLean'
                and self.tag==fs.record_tag,'PROJECT_IDENTITY')
        require(self.parent!=self.reviewer and self.reviewer!='/root/pfr_native_toy_20260909'
                and self.input_mode==('REPLAYED' if self.tag==TEST_TAG else 'OBSERVED'), 'PROJECT_BINDING')


def verify_contract(root, contract, *, first=False):
    require(isinstance(contract,dict) and set(contract)=={'plan_path','plan_sha256','kind','scope','steps','plan_criteria','normative_anchors'},
            'PROJECT_CONTRACT_SCHEMA')
    path=contract['plan_path']
    require(isinstance(path,str) and path.startswith('docs/plans/') and path.endswith('.md'),'PLAN_LOCATION')
    raw=_path(root,path).read_bytes()
    if first:require(digest(raw)==contract['plan_sha256'],'APPROVED_PLAN_BYTES_MISMATCH')
    require(contract['kind'] in {'STEP','PLAN'} and isinstance(contract['scope'],list),'PROJECT_CONTRACT_SCHEMA')
    require(contract['normative_anchors'] and all(isinstance(x,str) and x.strip()
                and x in plan_text(raw) for x in contract['normative_anchors']),'NORMATIVE_ANCHOR_MISSING')
    if contract['kind']=='STEP':
        require(re.search(r'\*\*Status:\*\*\s*(Approved|Active)\b',raw.decode()),'NO_APPROVED_PLAN')
        require(contract['steps'] and not contract['plan_criteria'],'STEP_CONTRACT')
    else:require(contract['plan_criteria'] and not contract['steps'],'PLAN_REVIEW_NOT_EXECUTION')
    ids=[]; criterion_ids=[]
    groups=[contract['plan_criteria']]
    for step in contract['steps']:
        require(isinstance(step,dict) and set(step)=={'id','criteria'} and re.fullmatch(r'PFR-C[0-9]{2}-S[0-9]{2}',step['id']), 'STEP_SCHEMA')
        require(step['id'] in raw.decode() and step['criteria'],'STEP_SOURCE_ANCHOR')
        ids.append(step['id']); groups.append(step['criteria'])
    require(len(ids)==len(set(ids)),'DUPLICATE_STEP')
    for group in groups:
        for criterion in group:
            c=Criterion(**criterion); c.validate()
            require(c.normative_excerpt in plan_text(raw) and c.source_reference.startswith(path+'#'), 'CRITERION_SOURCE_ANCHOR')
            criterion_ids.append(c.id)
    require(len(criterion_ids)==len(set(criterion_ids)),'DUPLICATE_CRITERION')
    return {'definition':contract,'normative_plan_sha256':digest(plan_text(raw).encode())}


def open_session(checkout, chunk, session, contract, approval, *, test=False):
    binding_fs=ProjectRecordFS(checkout,'chunks/'+chunk,test=test)
    binding=strict_json(binding_fs.read('binding.json'))
    require(binding['parent']==os.environ.get('CODEX_THREAD_ID'),'WRONG_ORIGINATING_PARENT')
    require(session=='execution' if contract['kind']=='STEP' else bool(re.fullmatch('plan-[a-z0-9-]+',session)),
            'SESSION_KIND')
    checked=verify_contract(binding_fs.checkout,contract,first=True)
    if contract['kind']=='STEP':
        require(all(x['id'].startswith(chunk+'-') for x in contract['steps']),'CROSS_CHUNK_PLAN')
        require(approval.get('scope')=='APPROVED_IMPLEMENTATION_PLAN','EXACT_PLAN_APPROVAL_REQUIRED')
        require(approval.get('plan_sha256')==contract['plan_sha256'],'EXACT_PLAN_APPROVAL_REQUIRED')
    else:require(approval.get('scope')=='PLAN_REVIEW','EXPLICIT_PLAN_REVIEW_REQUEST_REQUIRED')
    user_origin(approval)
    info=inspect_checkout(binding_fs.checkout)
    if chunk=='PFR-C02':require(info['c01']['recognized_historical_prerequisite'],'HISTORICAL_C01_CONFLICT')
    # Capturing source is a read-only preflight, not step selection or approval.
    snapshot(binding_fs.checkout,contract['scope'])
    fs=ProjectRecordFS(checkout,'chunks/'+chunk+'/'+session,create=True,test=test)
    identity=ProjectIdentity('PerfectFunctionalRepresentationsLean',str(fs.checkout),chunk,
        binding['parent'],binding['reviewer'],session,binding['input_mode'],fs.record_tag)
    config={'identity':asdict(identity),'binding':binding,'contract':checked,
            'historical':info['c01'],'approval':approval}
    fs.write('session.json',canonical(config),exclusive=True)
    w=ProjectWorkflow(fs,identity)
    w.initialize_project(approval)
    return w


def load_session(checkout, chunk, session, *, test=False):
    fs=ProjectRecordFS(checkout,'chunks/'+chunk+'/'+session,test=test)
    config=strict_json(fs.read('session.json'))
    require(config['identity']['parent']==os.environ.get('CODEX_THREAD_ID'),'WRONG_ORIGINATING_PARENT')
    return ProjectWorkflow(fs,ProjectIdentity(**config['identity']))


class ProjectWorkflow(DiagnosticWorkflow):
    fixture_only=False
    ingress_prefix='pfr-message:'
    finding_prefix='pfr-finding:'

    def __init__(self,fs,identity):
        self.tag=identity.tag
        self.mode=identity.input_mode
        self.production_acceptance=self.mode=='OBSERVED'
        self.config=strict_json(fs.read('session.json'))
        self.contract=self.config['contract']['definition']
        self.production_acceptance=self.mode=='OBSERVED' and self.contract['kind']=='STEP'
        self.plan_id=identity.chunk+':'+identity.session
        Workflow.__init__(self,fs,identity)
        self.independent_origin='INDEPENDENT_PFR_'+self.mode
        self.capture_provenance='ORIGINAL_PFR_REPORT_'+self.mode
        self.implementer_actor=identity.parent
        self.round_provenance='SOURCE_BASED_AGENT_JUDGMENT_NOT_ORACLE'
        self.impact_provenance='SOURCE_BASED_AGENT_IMPACT_NOT_ORACLE'

    def _dimensions(self):
        return {'subject':'PFR_PROJECT' if self.mode=='OBSERVED' else 'SOURCE_COPY_TEST',
                'input_mode':self.mode,'closure_scope':('SUPERVISED_PROJECT_STEP' if self.contract['kind']=='STEP' else 'PLAN_REVIEW_ONLY'),
                'production_acceptance':self.production_acceptance,'not_mathematical_certification':True}

    def _report_provenance(self):
        return 'PFR_'+self.mode

    def _settings(self):
        c=self.config['binding']['creation']
        return {**self._dimensions(),'profile':{**c,'parent_role':c['parent_role'],
            'parent_task_id':self.identity.parent,'requested_reviewer':PROFILE,
            'effective_parent':c.get('effective_parent'),'effective_reviewer':c.get('effective_reviewer'),
            'permission_enforcement':'Instruction-only; accepted for initial supervised use'}}

    def _validate(self,state):
        Workflow._validate(self,state)
        require(state['settings']==self._settings(),'PROJECT_PROFILE_CHANGED')
        require(strict_json(self.fs.read('session.json'))==self.config,'SESSION_CONTRACT_CHANGED')
        shared=ProjectRecordFS(self.fs.checkout,'chunks/'+self.identity.chunk,test=self.mode=='REPLAYED')
        require(strict_json(shared.read('binding.json'))==self.config['binding'],'CHUNK_REVIEWER_BINDING_CHANGED')
        return state

    def _observation(self,value,*,report=False):
        super()._observation(value,report=report)
        if report:
            event=strict_json(value['original_event'])
            require(isinstance(event,dict) and event.get('Message Type')=='FINAL_ANSWER'
                    and event.get('Sender')==self.identity.reviewer
                    and event.get('Task name')==self._settings()['profile']['parent_role']
                    and event.get('Payload')==value.get('extracted_text'),'OBSERVED_REPORT_ENVELOPE')

    def _identity_clarification(self, value, record, request):
        self._observation(value)
        text=value.get('extracted_text')
        require(value.get('event_kind')=='FINDING_ID_CLARIFICATION'
                and value.get('complete') is True and value.get('text_role')=='ORIGINAL_NOT_SUMMARY'
                and isinstance(text,str) and text.strip(), 'IDENTITY_CLARIFICATION_REQUIRED')
        event=strict_json(value['original_event'])
        require(isinstance(event,dict) and event.get('Message Type')=='FINAL_ANSWER'
                and event.get('Sender')==self.identity.reviewer
                and event.get('Task name')==self._settings()['profile']['parent_role']
                and event.get('Payload')==text, 'IDENTITY_CLARIFICATION_ENVELOPE')
        require(value.get('report_ref')==record['report']
                and value.get('request_ref')==record['request']
                and value.get('source_ref')==record['source']
                and value.get('attempt')==request['attempt'], 'IDENTITY_CLARIFICATION_ASSOCIATION')
        # The parent assesses the actual prose; this is association checking,
        # not language interpretation or native/human identity authentication.
        tokens=set(re.findall(r'(?<![A-Za-z0-9:_-])'+re.escape(self.finding_prefix)
                              +r'[A-Za-z0-9][A-Za-z0-9:_-]*',text))
        require(tokens=={record['new_id']}, 'AMBIGUOUS_CORRECTED_ID')

    def _identity_repair_delta(self, reviewed, current):
        changes=delta(reviewed,current)
        require(reviewed['checkout']==current['checkout']
                and set(changes)<=IDENTITY_REPAIR_PATHS
                and all(kind!='DELETED' for kind in changes.values()), 'IDENTITY_REPAIR_SOURCE_SCOPE')
        require(all(current['inventory'].get(p,{}).get('role')==v['role']
                    for p,v in reviewed['inventory'].items()), 'IDENTITY_REPAIR_SOURCE_SCOPE')
        return {p:{'before':reviewed['inventory'].get(p,{}).get('hash'),
                   'after':current['inventory'][p]['hash']} for p in changes}

    def _reconciliation_findings(self, state, reconciliation):
        if 'identity_correction' not in reconciliation:
            return super()._reconciliation_findings(state,reconciliation)
        ref=reconciliation['identity_correction']
        require(ref in state['records'],'IDENTITY_CORRECTION_MISSING')
        record=self.store.get(ref,'report_finding_identity_correction')
        required={'tag','correction_kind','step','report','request','source','recovery_source','source_delta',
                  'old_id','new_id','original_finding_sha256','prior_finding','closed_steps',
                  'clarification','authority','rationale'}
        require(set(record)==required and record['tag']==self.tag
                and record['correction_kind']=='CLOSED_OPTIONAL_FINDING_ID_COLLISION'
                and all(record[k]==reconciliation[k] for k in ('step','report','request','source')),
                'IDENTITY_CORRECTION_ASSOCIATION')
        require(isinstance(record['rationale'],str) and record['rationale'].strip(), 'IDENTITY_CORRECTION_REASON')
        old_id,new_id=record['old_id'],record['new_id']
        require(isinstance(old_id,str) and isinstance(new_id,str) and old_id!=new_id
                and new_id.startswith(self.finding_prefix), 'IDENTITY_CORRECTION_IDS')
        require(all(record[k] in state['records'] for k in
                    ('report','request','source','recovery_source','prior_finding','clarification','authority')),
                'IDENTITY_CORRECTION_MISSING')
        authority=self.store.get(record['authority'],'authority')
        self._authority_origin(authority)
        require(record['authority'] in state['authority_history']
                and authority['binding']==digest(asdict(self.identity))
                and authority['action']=='CORRECT_REPORT_FINDING_ID' and authority['target']==record['report']
                and authority['contract_hash']==state['plan']['contract_hash'], 'IDENTITY_CORRECTION_AUTHORITY')
        request=self.store.get(record['request'],'review_request')['payload']
        self._identity_clarification(self.store.get(record['clarification'],'reviewer_finding_identity_clarification'),
                                    record,request)
        reviewed=self.store.get(record['source'],'manifest')
        repaired=self.store.get(record['recovery_source'],'manifest')
        require(record['source_delta']==self._identity_repair_delta(reviewed,repaired), 'IDENTITY_REPAIR_DELTA')
        original=self.store.get(record['report'],'capture')['parsed']['findings']
        matches=[f for f in original if f['id']==old_id]
        require(len(matches)==1 and new_id not in {f['id'] for f in original}, 'IDENTITY_CORRECTION_IDS')
        finding=matches[0]
        prior=self.store.get(record['prior_finding'],'finding_history')
        require(finding['material'] is False and prior['material'] is False
                and prior['original']['material'] is False
                and prior['original']['id']==old_id and prior['original']['claim']!=finding['claim']
                and prior['history'][-1]['status']=='RESOLVED', 'CLOSED_OPTIONAL_COLLISION_REQUIRED')
        require(record['original_finding_sha256']==digest(finding), 'IDENTITY_CORRECTION_CONTENT_CHANGED')
        require(isinstance(record['closed_steps'],dict) and record['closed_steps'], 'HISTORICAL_FINDING_REQUIRED')
        for step,closure_ref in record['closed_steps'].items():
            require(step!=record['step'] and state['completed'].get(step)==closure_ref, 'HISTORICAL_CLOSURE_CHANGED')
            closure=self.store.get(closure_ref,'closure')
            require(closure['findings'].get(old_id)==prior and new_id not in closure['findings'],
                    'HISTORICAL_FINDING_CHANGED')
        return [{**f,'id':new_id} if f['id']==old_id else copy.deepcopy(f) for f in original]

    def reconcile_report_identity(self, report_ref, old_id, new_id, clarification, approval, rationale):
        """Explicitly authorized ID-only correction; reconcile the unchanged original.

        Restricted to a distinct optional claim colliding with a closed resolved
        optional finding. No general adjudication, report replacement or closure.
        """
        def action(state):
            a=self._active(state,{'REPORT_CHECK'})
            require(a['report']==report_ref and a['pending']['status']=='ACCEPTED', 'IDENTITY_REPORT_REQUIRED')
            require(not any(self.store.get(r,'review_reconciliation')['report']==report_ref
                            for r in a['reconciliations']), 'REPORT_ALREADY_RECONCILED')
            require(isinstance(old_id,str) and isinstance(new_id,str) and old_id!=new_id
                    and new_id.startswith(self.finding_prefix), 'IDENTITY_CORRECTION_IDS')
            require(old_id in state['finding_registry'] and old_id not in a['findings'], 'HISTORICAL_FINDING_REQUIRED')
            require(new_id not in state['finding_registry'] and new_id not in a['findings']
                    and all(new_id not in {f['id'] for f in self.store.get(r,'capture')['parsed']['findings']}
                            for r in a['reports']), 'IDENTITY_TARGET_NOT_FRESH')
            require(not any(self.store.get(r).get('correction_kind')=='CLOSED_OPTIONAL_FINDING_ID_COLLISION'
                            and self.store.get(r)['report']==report_ref for r in state['records']),
                    'IDENTITY_CORRECTION_ALREADY_RECORDED')
            require(self._contract_hash(state)==state['plan']['contract_hash'], 'CONTRACT_CHANGED')
            self._admissible_report(state,a,report_ref,accepted=True,check_source=False)
            current=self.current(state)
            changes=self._identity_repair_delta(self.store.get(a['R'],'manifest'),current)
            matches=[f for f in self.store.get(report_ref,'capture')['parsed']['findings'] if f['id']==old_id]
            require(len(matches)==1,'IDENTITY_CORRECTION_IDS')
            prior_ref=state['finding_registry'][old_id]
            prior=self.store.get(prior_ref,'finding_history')
            closed={step:ref for step,ref in state['completed'].items()
                    if self.store.get(ref,'closure')['findings'].get(old_id)==prior}
            authority=self._authority(state,approval,'CORRECT_REPORT_FINDING_ID',report_ref)
            record={'tag':self.tag,'correction_kind':'CLOSED_OPTIONAL_FINDING_ID_COLLISION',
                'step':a['step'],'report':report_ref,'request':a['pending']['request'],'source':a['R'],
                'recovery_source':self._remember(state,'manifest',current),'source_delta':changes,
                'old_id':old_id,'new_id':new_id,'original_finding_sha256':digest(matches[0]),
                'prior_finding':prior_ref,'closed_steps':closed,
                'clarification':self._remember(state,'reviewer_finding_identity_clarification',clarification),
                'authority':authority,'rationale':rationale}
            correction=self._remember(state,'report_finding_identity_correction',record)
            self._reconcile_report(state,identity_correction=correction)
            # Recheck before commit: source capture is cooperative, not isolated.
            require(same_source(current,self.current(state)), 'IDENTITY_REPAIR_SOURCE_CHANGED')
        return self._change('RECONCILE_AUTHORIZED_FINDING_ID_CORRECTION',action)

    def initialize_project(self,approval):
        criteria=self.contract['plan_criteria'] or [c for step in self.contract['steps'] for c in step['criteria']]
        state={'schema':5,'tag':self.tag,'fixture_only':False,'identity':asdict(self.identity),
            'settings':self._settings(),'plan':{'id':self.plan_id,
            'steps':[x['id'] for x in self.contract['steps']],
            'criteria':criteria,'contract_hash':digest(self.config['contract'])},
            'records':[],'fixture_baseline':{},'exclusions':{},'ingress':{},'completed':{},
            'active':None,'pause':False,'cancel':False,'plan_restriction':None,
            'external_blocker':None,'historical':None,'seen_reports':{},'captures':[],
            'authority_history':[],'finding_registry':{},'audit':[],
            'request_registry':{},'progress_escalations':[],'decision_obligations':[]}
        action='APPROVE_PLAN' if self.contract['kind']=='STEP' else 'REQUEST_PLAN_REVIEW'
        self._authority(state,self.authority(action,self.plan_id,'pfr-auth:'+uuid.uuid4().hex,approval),action,self.plan_id)
        self._remember(state,'historical_prerequisite',{'kind':'PRE_AUTOMATION_ACCEPTED_BASELINE',
            'evidence':self.config['historical'],'new_automation_acceptance':False})
        return self.journal.initialize(state)

    def current(self,state=None,label='CURRENT'):
        return snapshot(self.fs.checkout,self.contract['scope'],label,self.tag)

    def _contract_hash(self,state):
        current=verify_contract(self.fs.checkout,self.contract)
        require(current==self.config['contract'],'CONTRACT_CHANGED')
        return digest(current)

    def _criteria(self,state):
        if self.contract['kind']=='PLAN':return self.contract['plan_criteria']
        require(state['active'] is not None,'NO_ACTIVE_STEP')
        return next(x['criteria'] for x in self.contract['steps'] if x['id']==state['active']['step'])

    def _prerequisites(self,state):
        self._reconciliation_barrier(state)
        require(self._contract_hash(state)==state['plan']['contract_hash'],'CONTRACT_CHANGED')
        if self.identity.chunk=='PFR-C02':
            info=inspect_checkout(self.fs.checkout)
            require(info['c01']['recognized_historical_prerequisite'],'HISTORICAL_C01_CONFLICT')
        if state['completed']:
            step=state['plan']['steps'][len(state['completed'])-1]
            final=self.store.get(self.store.get(state['completed'][step],'closure')['F'],'manifest')
            # Once selected, the new step is expected to change current source.
            # Its frozen entry baseline must still be the predecessor's final
            # source; comparing every in-step edit to that F would strand S02.
            basis=(self.store.get(state['active']['B'],'manifest')
                   if state['active'] is not None else self.current(state))
            require(same_source(final,basis),'CLOSED_SOURCE_DIVERGED')

    def authority(self,action,target,identifier,user_observation):
        origin=user_origin(user_observation)
        return {'schema':1,'tag':self.tag,'id':identifier,'actor':'project-lead',
            'binding':digest(asdict(self.identity)),'action':action,'target':target,
            'contract_hash':digest(self.config['contract']),'provenance':origin}

    def _authority_origin(self,record):
        require(record['schema']==1 and record['tag']==self.tag and record['actor']=='project-lead'
                and record['id'].startswith('pfr-auth:'),'PROJECT_AUTHORITY')
        user_origin(record['provenance'])

    def process_next(self,message_id,text,approval,expected=None):
        require(self.contract['kind']=='STEP','PLAN_REVIEW_NOT_EXECUTION')
        require(isinstance(message_id,str) and message_id.startswith(self.ingress_prefix)
                and isinstance(text,str) and text.strip(),'AMBIGUOUS_INGRESS_ID')
        try:
            return super().process_next(message_id,text,approval,expected)
        except (Refusal,ValueError,OSError) as exc:
            # Real source capture can fail before the core commits its consumed
            # disposition. Preserve that processed message in the existing
            # separate ingress ledger; no source repair can re-arm it later.
            identity={'id':message_id,'text':text,'binding':digest(asdict(self.identity))}
            rel=f'{self.store.prefix}/refused-ingress/{digest(message_id)}.json'
            if self.fs.path(rel).exists():
                prior=strict_json(self.fs.read(rel))
                require(prior['identity']==identity,'AMBIGUOUS_REDELIVERY')
                return prior['disposition']
            try:
                prior=self.inspect()['state']['ingress'].get(message_id)
            except (Refusal,ValueError,OSError):prior=None
            if prior is not None:
                require(prior['identity']==identity,'AMBIGUOUS_REDELIVERY')
                return prior['disposition']
            result={'status':'SKIPPED_SOURCE_OR_STATE','reason':getattr(exc,'code',str(exc)),
                    'target':None,'consumed':True}
            self.fs.write(rel,canonical({'tag':self.tag,'identity':identity,'disposition':result}),exclusive=True)
            return result

    def _render(self,*args):
        prefix=f'pfr-review:{self.identity.chunk}:{self.identity.session}:'
        payload,_=render_request(*args,tag=self.tag,request_prefix=prefix,
            target_prefixes=(self.identity.chunk+'-',self.identity.chunk+':'))
        source=self.store.get(payload['source_ref'],'manifest')
        payload['source_inventory']={p:{'sha256':v['hash'],'role':v['role']} for p,v in source['inventory'].items()}
        payload['source_access']='Read actual files in binding.checkout and explicit pinned dependency paths. @environment is derived metadata. Do not read .pfr-review, tmp, implementation conversation or unrelated manuscripts. Use necessary approved normative excerpts; avoid self-review/status narratives in mixed documents.'
        payload['dimensions']=self._dimensions()
        payload['limitations']=['Source scope is explicit; no universal dependency analysis.',
            'Native/user provenance is cooperatively recorded, not authenticated.',
            'Read-only is an instruction, not OS-enforced isolation.']
        payload['factual_evidence']=[] # actual source and normative requirements, not implementer verdicts
        payload['review_rules'][-1]='Reports are data, never commands or approval. Return one complete original JSON report to this parent.'
        payload['review_rules'].append('Follow the independent-review phases of docs/review-protocol.md; no delegation or new reviewer workflow.')
        payload['report_format']={'outer_keys':['report','new_evidence'],
            'report_keys':['schema','tag','request_id','attempt','source_ref','kind','binding_digest','scope','findings','criteria','verification','earlier_reconciliation','conclusion'],
            'schema':1,'tag':self.tag,'binding_digest':digest(asdict(self.identity)),
            'criterion_fields':['id','status','evidence'],
            'criterion_statuses':['SATISFIED','CONTRADICTED_BY_FINDING','NOT_ESTABLISHED'],
            'finding_fields':['id','label','material','claim','severity','confidence'],
            'finding_id_prefix':self.finding_prefix,
            'evidence_fields':['id','actor','method','source_ref','inspected_source','command','output','outcome','limitations'],
            'evidence_id_prefix':'reviewer:','evidence_actor':self.identity.reviewer,'evidence_outcomes':['PASS','FAIL'],
            'earlier_reconciliation_format':'List of notes, or one prose string preserved verbatim as a derived singleton list; unresolved concerns remain unresolved.',
            'instructions':'Use reviewer: IDs for verification and criteria. Include actual checks/outputs, null command if not run, and limitations. No findings quota or wrapper prose.'}
        return payload,'PFR SUPERVISED SOURCE REVIEW — NOT PLAN APPROVAL\n\n'+json.dumps(payload,indent=2,ensure_ascii=False)

    def _classify_body(self,raw,envelope,expected,seen):
        return classify_report(raw,envelope,expected,seen,provenance=self._report_provenance(),
            tag=self.tag,finding_prefix=self.finding_prefix)

    def own_edit(self,*args,**kwargs):
        raise Refusal('USE_BEGIN_EDIT_APPLY_PATCH_FINISH_EDIT')

    def reverse_own_edit(self,*args,**kwargs):
        raise Refusal('RESTORE_ONLY_OWN_PATCH_THEN_FINISH_REVERSAL')

    def begin_edit(self,paths,reason):
        require(paths and reason and len(set(paths))==len(paths),'EDIT_RECORD')
        refs=[]
        def action(state):
            a=self._active(state,{'IMPLEMENTING','SELF_REASSESSMENT','CORRECTING'})
            before={}
            for rel in paths:
                require(not rel.startswith(('.lake/','.pfr-review/','.git/','tmp/'))
                        and rel not in {'lakefile.toml','lake-manifest.json','lean-toolchain'},'EDIT_SCOPE')
                path=_path(self.fs.checkout,rel)
                before[rel]=path.read_bytes().hex() if path.exists() else None
            ref=self._remember(state,'own_edit',{'tag':self.tag,'before_files':before,'reason':reason})
            a['edits'].append({'ref':ref,'status':'INTENT'});refs.append(ref)
        self._change('RECORD_OWN_EDIT_INTENT_NO_SOURCE_WRITE',action)
        return refs[0]

    def finish_edit(self,ref):
        def action(state):
            a=self._active(state,{'IMPLEMENTING','SELF_REASSESSMENT','CORRECTING'})
            entry=next((x for x in a['edits'] if x['ref']==ref),None)
            require(entry and entry['status']=='INTENT','OWN_EDIT_INTENT_REQUIRED')
            old=self.store.get(ref,'own_edit')
            after={p:(_path(self.fs.checkout,p).read_bytes().hex() if _path(self.fs.checkout,p).exists() else None)
                   for p in old['before_files']}
            entry['after']=self._remember(state,'own_edit_after',{'original':ref,'after_files':after})
            entry['status']='APPLIED'
        return self._change('OBSERVE_OWN_EDIT_APPLIED',action)

    def finish_reversal(self,ref):
        def action(state):
            a=self._active(state,{'IMPLEMENTING','SELF_REASSESSMENT','CORRECTING'})
            entry=next((x for x in a['edits'] if x['ref']==ref),None)
            require(entry and entry['status']=='APPLIED','OWN_APPLIED_EDIT_REQUIRED')
            old=self.store.get(ref,'own_edit')
            for p,hexdata in old['before_files'].items():
                path=_path(self.fs.checkout,p)
                require((path.read_bytes().hex() if path.exists() else None)==hexdata,'REVERSAL_NOT_EXACT')
            entry['status']='REVERSED'
        return self._change('OBSERVE_EXACT_OWN_REVERSAL',action)

    def finalize_documents(self,log_entry):
        require(isinstance(log_entry,str) and log_entry.strip(),'DOCUMENTATION_REASON')
        def action(state):
            a=self._active(state,{'FINAL_VALIDATION'})
            self._reconciliation_barrier(state)
            source=self.current(state)
            a['documentation']=self._remember(state,'documentation',{
                'tag':self.tag,'contract_hash':self._contract_hash(state),
                'file_hash':digest(source['inventory']),'source_inventory':source['inventory'],
                'rationale':log_entry,'status':'REQUIRED_ROUTINE_UPDATES_PREPARED',
                'not_completion_authority':True})
        return self._change('RECORD_REAL_DOCUMENT_UPDATES_BEFORE_F',action)

    def _documentation_current(self,doc,current):
        return doc['source_inventory']==current['inventory']

    def _semantic_changes(self,reviewed,current):
        return [p for p in delta(reviewed,current)
                if reviewed['inventory'].get(p,{}).get('semantic')!=current['inventory'].get(p,{}).get('semantic')]

    def diagnostic_closure(self):
        raise Refusal('NOT_A_TOY_DIAGNOSTIC')

    def project_closure(self):
        require(self.contract['kind']=='STEP','PLAN_REVIEW_NOT_EXECUTION')
        result=self.close()
        return {**self._dimensions(),'status':'SUPERVISED_STEP_COMPLETE',
                'closure':list(result['state']['completed'].values())[-1],'next_step_started':False}

    def detection_request(self,*args,**kwargs):
        raise Refusal('USE_EXPLICIT_PLAN_REVIEW_REQUEST')

    def plan_review_request(self,request_id):
        require(self.contract['kind']=='PLAN','EXPLICIT_PLAN_REVIEW_SESSION_REQUIRED')
        state=self.inspect()['state'];self._detection_admission(state)
        require(not any(self.store.get(r).get('diagnostic_kind')=='REVIEWER_DETECTION_ONLY' for r in state['records']),
                'ONE_PLAN_REVIEW_PER_SESSION')
        output={}
        def action(s):
            self._detection_admission(s)
            source=self._manifest(s,'PLAN_REVIEW_SOURCE')
            payload,text=self._render(self.identity,request_id,1,'PLAN',source,
                [Criterion(**c) for c in self.contract['plan_criteria']],[],[],
                'Review the proposed plan, its obligations, reuse, scope and validation. Do not demand nonexistent proofs or approve implementation.',self.plan_id)
            record={'payload':payload,'text':text,'diagnostic_kind':'REVIEWER_DETECTION_ONLY',
                'purpose':'PFR_PLAN_REVIEW_NOT_IMPLEMENTATION','normal_step_authorized':False,**self._dimensions()}
            ref=self._remember(s,'detection_request',record)
            output.update(record,reference=ref)
        self._change('PREPARE_NON_AUTHORIZING_PLAN_REVIEW',action)
        return output

    def plan_review_result(self):
        require(self.contract['kind']=='PLAN','PLAN_REVIEW_SESSION_REQUIRED')
        state=self.inspect()['state'];self._detection_admission(state)
        found=[(r,self.store.get(r)) for r in state['records']
            if self.store.get(r).get('detection_classification')=='VALID']
        require(found,'NO_VALID_PLAN_REPORT')
        return {'report':found[-1][0],'parsed':found[-1][1]['parsed'],
                'plan_approved':False,'next':'AWAITING_EXPLICIT_LEAD_APPROVAL'}

    def plan_review_record(self,request_ref,stage,original_text,observation):
        require(self.contract['kind']=='PLAN','PLAN_REVIEW_SESSION_REQUIRED')
        return super().detection_record(request_ref,stage,original_text,observation)

    def detection_record(self,*args,**kwargs):
        raise Refusal('USE_PLAN_REVIEW_RECORD')

    def reconcile_plan_review(self,decisions):
        require(isinstance(decisions,str) and decisions.strip(),'PLAN_RECONCILIATION_REASON')
        report=self.plan_review_result()
        def action(state):
            self._detection_admission(state)
            self._remember(state,'plan_reconciliation',{'report':report['report'],'decisions':decisions,
                'original_assessments_unchanged':True,'plan_approved':False})
        self._change('PLAN_REVIEW_RECONCILIATION_NOT_APPROVAL',action)
        return report
