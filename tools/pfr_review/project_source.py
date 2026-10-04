"""Read-only PFR source capture; no Lean dependency inference or Git mutations.

Exact working bytes include dirty and relevant untracked files. Double observation
detects ordinary concurrent edits; it is not an atomic filesystem snapshot or an
OS isolation boundary. Source bytes are retained for inspection, never restoration.
"""
from __future__ import annotations

import hashlib
import json
import os
from pathlib import Path, PurePosixPath
import re
import stat
import subprocess

TAG = "PFR_SUPERVISED_REVIEW_V1"
C01_PLAN = "docs/plans/pfr-c01-semantic-functional-representations.md"
C01_COMMIT = "60913637e7a8a982730112415cfd9ddeea59d367"
CONFIG = ("lean-toolchain", "lakefile.toml", "lake-manifest.json")
EXCLUDED_ROOTS = {".git", ".pfr-review", "tmp", "build", "__pycache__"}
DOCUMENT_SUFFIXES = {".pdf", ".png", ".jpg", ".jpeg", ".docx", ".zip"}
UNTRACKED_SUFFIXES = {".lean", ".md", ".py", ".json", ".toml", ".yml",
                      ".yaml", ".ps1", ".sh", ".txt"}


def _digest(value):
    raw = value if isinstance(value, bytes) else json.dumps(
        value, sort_keys=True, separators=(",", ":"), ensure_ascii=False,
        allow_nan=False).encode("utf-8")
    return hashlib.sha256(raw).hexdigest()


def _no_indirection(path):
    for item in (path, *path.parents):
        if item.exists() or item.is_symlink():
            info = item.lstat()
            if stat.S_ISLNK(info.st_mode) or getattr(info, "st_file_attributes", 0) & 0x400:
                raise ValueError(f"SOURCE_INDIRECTION: {item}")
            if stat.S_ISREG(info.st_mode) and info.st_nlink != 1:
                raise ValueError(f"SOURCE_HARDLINK: {item}")


def _root(root):
    root = Path(root).absolute()
    _no_indirection(root)
    if not root.is_dir():
        raise ValueError("CHECKOUT_NOT_DIRECTORY")
    _no_indirection(root / ".git")
    actual = Path(_git(root, "rev-parse", "--show-toplevel").decode().strip())
    if actual.resolve() != root.resolve():
        raise ValueError("NOT_CHECKOUT_ROOT")
    return root


def _path(root, rel):
    if not isinstance(rel, str) or not rel or "\\" in rel or ":" in rel:
        raise ValueError("UNSAFE_SOURCE_PATH")
    if rel.casefold() == "@environment" or any(ord(c) < 32 for c in rel):
        raise ValueError("UNSAFE_SOURCE_PATH")
    parts = PurePosixPath(rel).parts
    if PurePosixPath(rel).is_absolute() or any(p in {".", ".."} for p in parts):
        raise ValueError("UNSAFE_SOURCE_PATH")
    if "/".join(parts) != rel or any(p.endswith((" ", ".")) for p in parts):
        raise ValueError("UNSAFE_SOURCE_PATH")
    if any(re.match(r"(?i)^(con|prn|aux|nul|com[1-9]|lpt[1-9])(?:\.|$)", p) for p in parts):
        raise ValueError("UNSAFE_SOURCE_PATH")
    path = root.joinpath(*parts)
    _no_indirection(path)
    if path.exists() and not path.is_file():
        raise ValueError(f"SOURCE_NOT_REGULAR_FILE: {rel}")
    return path


def _git(root, *args, absent=False):
    env = dict(os.environ, GIT_OPTIONAL_LOCKS="0", GIT_TERMINAL_PROMPT="0")
    result = subprocess.run(["git", "--no-optional-locks", "-c", "core.fsmonitor=false",
                             "-C", str(root), *args], stdout=subprocess.PIPE,
                            stderr=subprocess.PIPE, env=env, check=False)
    if result.returncode and not absent:
        raise ValueError(f"GIT_READ_FAILED: {args!r}: {result.stderr.decode(errors='replace')}")
    return None if result.returncode else result.stdout


def _names(raw):
    return sorted(x.decode("utf-8") for x in raw.split(b"\0") if x)


def _git_state(root):
    index = _git(root, "ls-files", "--stage", "-z")
    cached = _git(root, "diff", "--cached", "--binary", "--no-ext-diff", "--no-textconv")
    return {"head": _git(root, "rev-parse", "HEAD").decode().strip(),
            "status_porcelain": _git(root, "status", "--porcelain=v1", "-z",
                                     "--untracked-files=all").decode("utf-8"),
            "index_entries_sha256": _digest(index), "cached_diff_sha256": _digest(cached),
            "index_representation": "sha256 of git ls-files --stage -z; no write-tree",
            "tracked": _names(_git(root, "ls-files", "-z")),
            "untracked": _names(_git(root, "ls-files", "--others", "--exclude-standard", "-z"))}


def _read(root, rel):
    path = _path(root, rel)
    if not path.exists():
        raise ValueError(f"SOURCE_MISSING: {rel}")
    return path.read_bytes()


def _dependencies(root, manifest):
    if manifest.get("packagesDir") != ".lake/packages" or not isinstance(manifest.get("packages"), list):
        raise ValueError("UNSUPPORTED_LAKE_MANIFEST")
    result = {}
    for package in manifest["packages"]:
        name = package.get("name")
        if not isinstance(name, str) or not re.fullmatch(r"[A-Za-z0-9_-]+", name) or name in result:
            raise ValueError("UNSUPPORTED_PACKAGE_NAME")
        path = root / ".lake" / "packages" / name
        _no_indirection(path)
        configured = {key: package.get(key) for key in ("type", "rev", "inputRev", "url")}
        if not path.exists():
            result[name] = {"configured": configured, "installed": False}
            continue
        if package.get("type") != "git":
            raise ValueError("UNSUPPORTED_PACKAGE_TYPE")
        _root(path)
        state = _git_state(path)
        result[name] = {"configured": configured, "installed": True,
                        "head": state["head"], "status_porcelain": state["status_porcelain"],
                        "index_entries_sha256": state["index_entries_sha256"],
                        "matches_configured_revision": state["head"] == package.get("rev")}
    return result


def _historical_c01(root, tracked):
    exists = _git(root, "cat-file", "-e", C01_COMMIT + "^{commit}", absent=True) is not None
    ancestor = exists and _git(root, "merge-base", "--is-ancestor", C01_COMMIT, "HEAD", absent=True) is not None
    plan_path = _path(root, C01_PLAN)
    raw = plan_path.read_bytes() if plan_path.exists() else b""
    match = re.search(rb"(?m)^\*\*Status:\*\*\s*([^\r\n]+)", raw)
    status = match.group(1).decode("utf-8").strip() if match else None
    historical_plan = _git(root, "show", f"{C01_COMMIT}:{C01_PLAN}", absent=True) if exists else None
    hashes, differences = {}, []
    for rel in tracked:
        if rel.endswith(".lean") and (rel == "PerfectFunctionalRepresentations.lean" or
                                       rel.startswith("PerfectFunctionalRepresentations/")):
            current = _path(root, rel)
            original = _git(root, "show", f"{C01_COMMIT}:{rel}", absent=True) if exists else None
            hashes[rel] = {"current": _digest(current.read_bytes()) if current.exists() else None,
                           "closeout": _digest(original) if original is not None else None}
            if hashes[rel]["current"] != hashes[rel]["closeout"]:
                differences.append(rel)
    historical_complete = bool(ancestor and historical_plan and
                               re.search(rb"(?m)^\*\*Status:\*\*\s*Complete\s*$", historical_plan))
    return {"plan": C01_PLAN, "plan_sha256": _digest(raw) if raw else None,
            "current_plan_status": status, "closeout_commit": C01_COMMIT,
            "closeout_exists": exists, "closeout_is_ancestor": ancestor,
            "historical_complete": historical_complete,
            "recognized_historical_prerequisite": historical_complete and status == "Complete",
            "source_hashes": hashes, "changed_since_closeout": differences,
            "automation_closure_created": False, "validation_rerun": False}


def inspect_checkout(root):
    """Read actual configuration/Git facts; never infer mathematical authorization."""
    root = _root(root)
    git = _git_state(root)
    config = {rel: _read(root, rel) for rel in CONFIG}
    manifest = json.loads(config["lake-manifest.json"])
    return {"schema": 1, "tag": TAG, "checkout": str(root), "git": git,
            "configuration": {p: {"sha256": _digest(raw), "text": raw.decode("utf-8")}
                              for p, raw in config.items()},
            "dependencies": _dependencies(root, manifest),
            "c01": _historical_c01(root, git["tracked"]),
            "mathematical_execution_authorized": False,
            "authorization_note": "Checkout inspection does not approve a plan or step.",
            "plan_candidates": sorted(p for p in set(git["tracked"] + git["untracked"])
                                      if p.startswith("docs/plans/") and p.endswith(".md"))}


def _exclusion(rel):
    parts = PurePosixPath(rel).parts
    if any(p.casefold() in EXCLUDED_ROOTS for p in parts):
        return "private records, temporary files, Git internals or generated outputs"
    if parts[0].casefold() == ".lake":
        return "installed dependencies require explicit file scope; builds are excluded"
    if PurePosixPath(rel).suffix.lower() in DOCUMENT_SUFFIXES:
        return "reference/media/archive files are not source-capture inputs"
    return None


def _capture_once(root, scope, label, tag):
    inspection = inspect_checkout(root)
    for name, dep in inspection["dependencies"].items():
        if not dep["installed"] or not dep["matches_configured_revision"] or dep["status_porcelain"]:
            raise ValueError(f"DEPENDENCY_NOT_CLEAN_PIN: {name}")
    tracked = set(inspection["git"]["tracked"])
    untracked = set(inspection["git"]["untracked"])
    selected, excluded = set(), {}
    for rel in tracked | untracked:
        reason = _exclusion(rel)
        if reason:
            excluded[rel] = reason
        elif rel in tracked or PurePosixPath(rel).suffix.lower() in UNTRACKED_SUFFIXES or rel in CONFIG:
            selected.add(rel)
        else:
            excluded[rel] = "untracked file outside supported source/document/tooling types"
    for rel in scope:
        _path(root, rel)
        reason = _exclusion(rel)
        parts = PurePosixPath(rel).parts
        dependency = (len(parts) >= 4 and parts[:2] == (".lake", "packages") and
                      parts[2] in inspection["dependencies"] and
                      not any(p.casefold() in EXCLUDED_ROOTS for p in parts) and
                      PurePosixPath(rel).suffix.lower() not in DOCUMENT_SUFFIXES)
        if reason and not dependency:
            raise ValueError(f"EXCLUDED_EXPLICIT_SCOPE: {rel}")
        selected.add(rel)
        excluded.pop(rel, None)
    if len({p.casefold() for p in selected}) != len(selected):
        raise ValueError("CASE_COLLIDING_SOURCE_PATHS")
    inventory, source_bytes, deleted = {}, {}, []
    for rel in sorted(selected):
        path = _path(root, rel)
        if not path.exists():
            if rel not in tracked:
                raise ValueError(f"EXPLICIT_SOURCE_MISSING: {rel}")
            deleted.append(rel)
            continue
        raw = path.read_bytes()
        role = "environment" if rel in CONFIG or rel.startswith(".lake/packages/") else "semantic"
        inventory[rel] = {"hash": _digest(raw), "semantic": _digest(raw), "role": role,
                          "size": len(raw), "git_classification": "tracked" if rel in tracked else "untracked-or-explicit"}
        source_bytes[rel] = raw.hex()
    environment = {"configuration": inspection["configuration"], "dependencies": inspection["dependencies"]}
    environment_raw = json.dumps(environment, sort_keys=True, separators=(",", ":"),
                                 ensure_ascii=False).encode("utf-8")
    inventory["@environment"] = {"hash": _digest(environment_raw), "semantic": _digest(environment_raw),
                                  "role": "environment", "size": len(environment_raw)}
    source_bytes["@environment"] = environment_raw.hex()
    return {"schema": 1, "tag": tag, "label": label, "checkout": str(root),
            "inventory": inventory, "source_bytes": source_bytes, "excluded": excluded,
            "scope": {"policy": "tracked plus relevant nonignored untracked; no import inference",
                      "explicit_files": scope, "dependency_policy": "all installed pins clean; explicit dependency files"},
            "git": inspection["git"], "deleted_tracked": deleted,
            "environment": environment, "capture_limit": "two cooperative observations, not atomic isolation"}


def snapshot(root, scope=None, label="CURRENT", tag=TAG):
    """Capture exact B/R/F source bytes and reject observed concurrent mutation."""
    root = _root(root)
    scope = [] if scope is None else scope
    if not isinstance(scope, list) or not all(isinstance(p, str) for p in scope):
        raise ValueError("SOURCE_SCOPE_MUST_BE_FILE_LIST")
    scope = sorted(set(scope))
    first = _capture_once(root, scope, label, tag)
    second = _capture_once(root, scope, label, tag)
    if first != second:
        raise ValueError("UNSTABLE_SOURCE_CAPTURE")
    return first
