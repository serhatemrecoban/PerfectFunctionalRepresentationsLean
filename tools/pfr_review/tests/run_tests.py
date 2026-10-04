"""Model-free adapter tests on private source copies; real Git read checks only."""
import hashlib
import io
import json
from pathlib import Path
import sys
import time
import unittest

BASE=Path(__file__).absolute().parents[1]
sys.path.insert(0,str(BASE.parents[1]))
sys.path.insert(0,str(BASE))
sys.path.insert(0,str(BASE/'tests'))
from project import ProjectRecordFS


def hashes():
    paths=[*BASE.glob('*.py'),*(BASE/'tests').glob('*.py'),
           *(BASE/'core').glob('*.py'),*(BASE/'core/tests').glob('*.py')]
    return {p.relative_to(BASE).as_posix():hashlib.sha256(p.read_bytes()).hexdigest() for p in sorted(paths)}


class RecordingResult(unittest.TextTestResult):
    def __init__(self,*args,**kwargs):
        super().__init__(*args,**kwargs);self.cases=[]
    def addSuccess(self,test):
        super().addSuccess(test);self.cases.append({'test':test.id(),'outcome':'PASS'})
    def addFailure(self,test,err):
        super().addFailure(test,err);self.cases.append({'test':test.id(),'outcome':'FAIL','detail':self._exc_info_to_string(err,test)})
    def addError(self,test,err):
        super().addError(test,err);self.cases.append({'test':test.id(),'outcome':'ERROR','detail':self._exc_info_to_string(err,test)})
    def addSkip(self,test,reason):
        super().addSkip(test,reason);self.cases.append({'test':test.id(),'outcome':'SKIP','reason':reason})


if __name__=='__main__':
    if hasattr(sys.stdout,'reconfigure'):sys.stdout.reconfigure(encoding='utf-8')
    fs=ProjectRecordFS(BASE.parents[1],'setup')
    run=str(time.time_ns()); before=hashes()
    fs.write(f'project-tests/{run}/source-start.json',json.dumps(before,indent=2),exclusive=True)
    suite=(unittest.defaultTestLoader.loadTestsFromNames(sys.argv[1:]) if len(sys.argv)>1
           else unittest.defaultTestLoader.discover(str(BASE/'tests'),pattern='test_*.py'))
    stream=io.StringIO(); start=time.monotonic()
    result=unittest.TextTestRunner(stream=stream,verbosity=2,resultclass=RecordingResult).run(suite)
    elapsed=time.monotonic()-start; after=hashes()
    record={'run_id':run,'model_free':True,'native_calls':0,'real_queue_test':False,
        'source_copy_test_acceptance_not_PFR_acceptance':True,'python':sys.version,
        'command':'python -B tools/pfr_review/tests/run_tests.py '+ ' '.join(sys.argv[1:]),
        'tests_run':result.testsRun,'failures':len(result.failures),'errors':len(result.errors),
        'skips':len(result.skipped),'seconds':elapsed,'cases':result.cases,
        'code_sha256_at_start':before,'code_sha256_at_end':after,
        'code_unchanged_during_run':before==after,
        'passed':result.wasSuccessful() and before==after,
        'isolation_limit':'Reviewed test code creates temporary Git source copies. Not OS-level isolation.'}
    fs.write(f'project-tests/{run}/results.json',json.dumps(record,indent=2),exclusive=True)
    fs.write(f'project-tests/{run}/unittest.log',stream.getvalue(),exclusive=True)
    print(stream.getvalue());print('Evidence: '+str(fs.path(f'project-tests/{run}/results.json')))
    raise SystemExit(0 if record['passed'] else 1)
