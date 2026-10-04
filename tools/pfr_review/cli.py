"""Explicit local command entry point; never calls a model/native agent."""
import argparse
import inspect
import json
from pathlib import Path
import sys
import uuid

from project import (ProjectRecordFS, bind, setup, open_session, load_session,
                     inspect_checkout, snapshot, Refusal, canonical, strict_json)

ROOT=Path(__file__).absolute().parents[2]
METHODS=('inspect','current','authority','process_next','parent_evidence',
    'initial_validation','self_review','reassess','disposition','reassess_finding',
    'begin_edit','finish_edit','finish_reversal','prepare_review','dispatch_intent',
    'record_submission','record_wait','confirm_delivery','receive_report',
    'reconcile_report','reconcile_report_identity','begin_corrections','finish_corrections','assess','extra_review',
    'finalize_documents','prepare_final','project_closure','refresh_final',
    'block','control','recover','mark_plan_revision','resolve_plan_revision',
    'plan_review_request','plan_review_record','plan_review_result','reconcile_plan_review',
    'validate_restored_binding_and_source')


def entry(checkout,command,data=None,chunk=None,session='execution'):
    root=Path(checkout).absolute(); data={} if data is None else data
    if command=='setup':return setup(root,data['approval'])
    if command=='inspect':
        info=inspect_checkout(root)
        marker=root/'.pfr-review/installation.json'
        info['installation_present']=marker.is_file()
        info['instructions']=['docs/review-protocol.md','docs/review-operations.md']
        info['instructions_present']=all((root/p).is_file() for p in info['instructions'])
        info['c02_binding_present']=(root/'.pfr-review/chunks/PFR-C02/binding.json').exists()
        info['c02_execution_present']=(root/'.pfr-review/chunks/PFR-C02/execution/session.json').exists()
        return info
    if command=='snapshot':return snapshot(root,data.get('scope',[]))
    if command=='instructions':return {p:(root/p).read_text(encoding='utf-8')
        for p in ['docs/review-protocol.md','docs/review-operations.md']}
    if command=='api':
        from project import ProjectWorkflow
        return {'native_calls':'Agent invokes its actual tools; Python never does.',
            'methods':{m:str(inspect.signature(getattr(ProjectWorkflow,m))) for m in METHODS}}
    if command=='bind':return bind(root,**data)
    if command=='open':
        w=open_session(root,**data)
        return {'status':'SESSION_OPENED_NOT_A_STEP','root':str(w.fs.root),'state':w.inspect()}
    if command in {'call','next','backup'}:
        if chunk is None:raise ValueError('CHUNK_REQUIRED')
        w=load_session(root,chunk,session)
        if command=='next':
            origin=data['user_observation']
            mid=data['message_id']
            approval=w.authority('NEXT_STEP',w.plan_id,'pfr-auth:'+uuid.uuid4().hex,origin)
            return w.process_next(mid,origin['original_text'],approval)
        if command=='backup':
            return {'tip':w.journal.backup(data['name']),
                'scope':'Consistent local journal backup only, not an off-device backup or automatic restore.'}
        method=data['method']
        if method not in METHODS:raise ValueError('METHOD_NOT_EXPOSED')
        args=data.get('args',[]);kwargs=data.get('kwargs',{})
        if not isinstance(args,list) or not isinstance(kwargs,dict):raise ValueError('CALL_ARGUMENTS')
        return getattr(w,method)(*args,**kwargs)
    raise ValueError('UNKNOWN_COMMAND')


def main():
    if hasattr(sys.stdout,'reconfigure'):sys.stdout.reconfigure(encoding='utf-8')
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('command',choices=['setup','inspect','snapshot','instructions','api','bind','open','call','next','backup'])
    parser.add_argument('--checkout',default=str(ROOT))
    parser.add_argument('--input',type=Path,help='Exact JSON packet file. No code evaluation.')
    parser.add_argument('--chunk')
    parser.add_argument('--session',default='execution')
    parser.add_argument('--save',help='Exclusive result filename within .pfr-review/setup/.')
    options=parser.parse_args()
    try:
        data=strict_json(options.input.read_bytes()) if options.input else {}
        result=entry(options.checkout,options.command,data,options.chunk,options.session)
        if options.save:
            root=Path(options.checkout)
            exists=(root/'.pfr-review/setup').exists()
            fs=ProjectRecordFS(root,'setup',create=not exists)
            fs.write(options.save,canonical(result),exclusive=True)
            print(json.dumps({'saved':str(fs.path(options.save))}))
        else:print(json.dumps(result,indent=2,ensure_ascii=False))
        return 0
    except (Refusal,ValueError,KeyError,TypeError,OSError) as exc:
        print(json.dumps({'status':'REFUSED','reason':getattr(exc,'code',type(exc).__name__),'detail':str(exc)}))
        return 2


if __name__=='__main__':raise SystemExit(main())
