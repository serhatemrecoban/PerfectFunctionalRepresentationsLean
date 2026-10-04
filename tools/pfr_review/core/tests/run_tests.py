"""Reproducible stdlib test runner. Writes only within this inactive bundle."""
import ast
import hashlib
import io
import json
import os
from pathlib import Path
import sys
import time
import unittest

BUNDLE = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(BUNDLE))
sys.path.insert(0, str(BUNDLE / "tests"))
sys.dont_write_bytecode = True
DENIED = []


def audit(event, args):
    if (event.startswith("socket.") or event.startswith("subprocess.") or
            event in {"os.system", "os.posix_spawn", "os.spawn", "os.startfile", "ctypes.dlopen"}):
        DENIED.append(event)
        raise PermissionError(f"Fixture-only runner forbids {event}")
    targets = []
    if event == "open":
        path, mode, flags = args
        if isinstance(path, (str, bytes, os.PathLike)) and (flags & (os.O_WRONLY | os.O_RDWR | os.O_CREAT)):
            targets = [path]
    elif event in {"os.remove", "os.rmdir", "os.mkdir", "os.chmod", "os.truncate"}:
        targets = [args[0]]
    elif event in {"os.rename", "os.link", "os.symlink"}:
        targets = list(args[:2])
    for path in targets:
        if not Path(os.fsdecode(path)).absolute().resolve().is_relative_to(BUNDLE):
            DENIED.append(event + ":outside-bundle")
            raise PermissionError("Fixture runner refuses writes outside bundle")


sys.addaudithook(audit)
ALLOWED = {"__future__", "copy", "hashlib", "json", "os", "pathlib", "re", "shutil", "stat",
           "tempfile", "uuid", "dataclasses", "safe_store", "contracts", "workflow", "diagnostic"}
for source in BUNDLE.glob("*.py"):
    tree = ast.parse(source.read_text(encoding="utf-8"), filename=str(source))
    for node in ast.walk(tree):
        if isinstance(node, ast.Import):
            assert all(n.name.split(".")[0] in ALLOWED for n in node.names), f"Unexpected import: {source}:{node.lineno}"
        if isinstance(node, ast.ImportFrom):
            assert node.module.split(".")[0] in ALLOWED, f"Unexpected import: {source}:{node.lineno}"
        if isinstance(node, ast.Call) and isinstance(node.func, ast.Name):
            assert node.func.id not in {"eval", "exec", "__import__"}, f"Dynamic execution: {source}:{node.lineno}"


class RecordingResult(unittest.TextTestResult):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.cases = []

    def addSuccess(self, test):
        super().addSuccess(test)
        self.cases.append({"test": test.id(), "outcome": "PASS"})

    def addFailure(self, test, err):
        super().addFailure(test, err)
        self.cases.append({"test": test.id(), "outcome": "FAIL", "detail": self._exc_info_to_string(err, test)})

    def addError(self, test, err):
        super().addError(test, err)
        self.cases.append({"test": test.id(), "outcome": "ERROR", "detail": self._exc_info_to_string(err, test)})

    def addSkip(self, test, reason):
        super().addSkip(test, reason)
        self.cases.append({"test": test.id(), "outcome": "SKIP", "reason": reason})


if __name__ == "__main__":
    run_id = str(time.time_ns())
    output = BUNDLE / "evidence" / "test-runs" / run_id
    output.mkdir(parents=True, exist_ok=False)
    code_paths = sorted([*BUNDLE.glob("*.py"), *(BUNDLE / "tests").glob("*.py")])
    code_hashes = {p.relative_to(BUNDLE).as_posix(): hashlib.sha256(p.read_bytes()).hexdigest() for p in code_paths}
    stream = io.StringIO()
    suite = (unittest.defaultTestLoader.loadTestsFromNames(sys.argv[1:]) if len(sys.argv) > 1
             else unittest.defaultTestLoader.discover(str(BUNDLE / "tests"), pattern="test_*.py"))
    started = time.monotonic()
    result = unittest.TextTestRunner(stream=stream, verbosity=2, resultclass=RecordingResult).run(suite)
    elapsed = time.monotonic() - started
    report = {"status": "FIXTURE_ONLY_PASS" if result.wasSuccessful() else "FIXTURE_ONLY_FAILED",
              "python": sys.version, "executable": sys.executable,
              "command": "python -B tests/run_tests.py" + (" " + " ".join(sys.argv[1:]) if len(sys.argv) > 1 else ""), "run_id": run_id,
              "tests_run": result.testsRun, "failures": len(result.failures), "errors": len(result.errors),
              "skipped": len(result.skipped), "seconds": elapsed, "cases": result.cases,
              "deliberately_denied_events": DENIED,
              "code_sha256_at_start": code_hashes,
              "code_unchanged_during_run": all(hashlib.sha256(p.read_bytes()).hexdigest() == code_hashes[p.relative_to(BUNDLE).as_posix()] for p in code_paths),
              "live_integration": "NOT_RUN_NOT_AUTHORIZED", "production_acceptance": False}
    (output / "unittest.log").write_text(stream.getvalue(), encoding="utf-8")
    (output / "results.json").write_text(json.dumps(report, indent=2), encoding="utf-8")
    print(stream.getvalue())
    print(f"Evidence: {output}")
    sys.exit(0 if result.wasSuccessful() else 1)
