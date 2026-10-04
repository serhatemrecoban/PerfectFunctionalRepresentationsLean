"""INACTIVE fixture-only filesystem, content records, and journal. No transport.

Only roots created by FixtureFS.create below this bundle's fixtures/runs are used.
This is cooperative path/race protection, not an OS security or tamper boundary.
"""
from __future__ import annotations

import copy
import hashlib
import json
import os
from pathlib import Path, PurePosixPath
import re
import shutil
import stat
import tempfile
import uuid

BUNDLE = Path(__file__).resolve().parent
RUNS = BUNDLE / "fixtures" / "runs"
TAG = "INACTIVE_FIXTURE_ONLY_V1"


class Refusal(Exception):
    def __init__(self, code, detail=""):
        self.code = code
        super().__init__(f"{code}: {detail}")


def require(condition, code, detail=""):
    if not condition:
        raise Refusal(code, detail)


def canonical(value):
    return json.dumps(value, sort_keys=True, separators=(",", ":"), ensure_ascii=False,
                      allow_nan=False).encode("utf-8")


def digest(value):
    return hashlib.sha256(value if isinstance(value, bytes) else canonical(value)).hexdigest()


def strict_json(data):
    def pairs(items):
        result = {}
        for key, value in items:
            require(key not in result, "DUPLICATE_JSON_KEY", key)
            result[key] = value
        return result
    try:
        return json.loads(data, object_pairs_hook=pairs,
                          parse_constant=lambda _: (_ for _ in ()).throw(Refusal("NONFINITE_JSON")))
    except (ValueError, UnicodeError) as exc:
        raise Refusal("INVALID_JSON", str(exc)) from exc


def no_indirection(path):
    """Reject symlinks, Windows reparse points and multiply-linked files."""
    for item in [path, *path.parents]:
        if item.exists() or item.is_symlink():
            info = item.lstat()
            require(not stat.S_ISLNK(info.st_mode) and
                    not (getattr(info, "st_file_attributes", 0) & 0x400),
                    "INDIRECTION", str(item))
            if stat.S_ISREG(info.st_mode):
                require(info.st_nlink == 1, "HARDLINK", str(item))


class FixtureFS:
    def __init__(self, root):
        self.root = Path(root).absolute()
        no_indirection(self.root)
        require(self.root.parent == RUNS and self.root.name.startswith("fixture-"),
                "NOT_FIXTURE_ROOT", str(root))
        marker = self.root / ".fixture-owner.json"
        require(marker.is_file(), "NO_FIXTURE_OWNERSHIP")
        no_indirection(marker)
        self.owner = strict_json(marker.read_bytes())
        require(self.owner.get("tag") == TAG and self.owner.get("root") == str(self.root),
                "BAD_FIXTURE_OWNERSHIP")

    @classmethod
    def create(cls):
        no_indirection(RUNS)
        RUNS.mkdir(parents=True, exist_ok=True)
        root = Path(tempfile.mkdtemp(prefix="fixture-", dir=RUNS))
        (root / ".fixture-owner.json").write_bytes(canonical(
            {"tag": TAG, "root": str(root), "owner": uuid.uuid4().hex}))
        return cls(root)

    def path(self, rel):
        require(isinstance(rel, str) and rel and "\\" not in rel, "UNSAFE_PATH", str(rel))
        bits = rel.split("/")
        require(not PurePosixPath(rel).is_absolute() and all(
            re.fullmatch(r"[A-Za-z0-9_.-]+", x) and x not in (".", "..")
            and not x.endswith((".", " "))
            and x.split(".")[0].upper() not in
            {"CON", "PRN", "AUX", "NUL", *[f"COM{i}" for i in range(10)],
             *[f"LPT{i}" for i in range(10)]} for x in bits), "UNSAFE_PATH", rel)
        no_indirection(self.root)
        require(strict_json((self.root / ".fixture-owner.json").read_bytes()) == self.owner,
                "OWNERSHIP_CHANGED")
        target = self.root.joinpath(*bits)
        no_indirection(target)
        require(target.resolve().is_relative_to(self.root.resolve()), "PATH_ESCAPE")
        return target

    def read(self, rel):
        path = self.path(rel)
        require(path.is_file(), "MISSING_RECORD", rel)
        return path.read_bytes()

    def write(self, rel, data, exclusive=False):
        path = self.path(rel)
        path.parent.mkdir(parents=True, exist_ok=True)
        self.path(rel)  # recheck newly created ancestors
        data = data.encode("utf-8") if isinstance(data, str) else data
        try:
            with path.open("xb" if exclusive else "wb") as handle:
                handle.write(data)
                handle.flush()
                os.fsync(handle.fileno())
        except FileExistsError as exc:
            raise Refusal("ALREADY_EXISTS", rel) from exc

    def replace(self, rel, data):
        temp = f"{rel}.{uuid.uuid4().hex}.pending"
        self.write(temp, data, exclusive=True)
        os.replace(self.path(temp), self.path(rel))

    def files(self, rel):
        root = self.path(rel)
        require(root.is_dir(), "MISSING_DIRECTORY", rel)
        result = []
        for directory, names, files in os.walk(root, followlinks=False):
            for name in names + files:
                item = Path(directory) / name
                relative = item.relative_to(self.root).as_posix()
                self.path(relative)
                if item.is_file():
                    result.append(relative)
        return sorted(result)

    def cleanup_scratch(self):
        target = self.path("scratch")
        require(target == self.root / "scratch", "CLEANUP_ESCAPE")
        if target.exists():
            self.files("scratch")  # validate ALL targets before recursive removal
            shutil.rmtree(target)
        return "OWNED_SCRATCH_REMOVED"


class Store:
    def __init__(self, fs, prefix="durable"):
        require(prefix in ("durable", "restored"), "BAD_STORE_PREFIX")
        self.fs, self.prefix = fs, prefix
        self.tag = getattr(fs, "record_tag", TAG)

    def put(self, kind, payload):
        obj = {"schema": 1, "tag": self.tag, "kind": kind, "payload": payload}
        raw = canonical(obj)
        ref = digest(raw)
        rel = f"{self.prefix}/objects/{ref}.json"
        if self.fs.path(rel).exists():
            require(self.fs.read(rel) == raw, "OBJECT_CONFLICT")
        else:
            self.fs.write(rel, raw, exclusive=True)
        return ref

    def get(self, ref, kind=None):
        require(isinstance(ref, str) and re.fullmatch("[0-9a-f]{64}", ref), "BAD_REFERENCE")
        raw = self.fs.read(f"{self.prefix}/objects/{ref}.json")
        require(digest(raw) == ref, "OBJECT_CORRUPT")
        obj = strict_json(raw)
        require(obj.get("schema") == 1 and obj.get("tag") == self.tag, "OBJECT_SCHEMA")
        require(kind is None or obj.get("kind") == kind, "OBJECT_KIND")
        return obj["payload"]


class Journal:
    """One event-file commit point; projection is checked/rebuildable, not truth.

    Event files are exclusive append-only writes. A torn event fails closed.
    A complete fsynced event followed by projection failure is recoverable ONLY
    with explicit repair authority and a supplied expected event tip. Directory
    fsync/power-loss durability is not claimed on Windows. Single-process fault
    points model interruptions; they do not simulate a Codex lifecycle event.
    """
    def __init__(self, store):
        self.store = store
        self.fs, self.prefix = store.fs, store.prefix

    def _events(self):
        root = self.fs.path(f"{self.prefix}/events")
        require(root.is_dir(), "MISSING_JOURNAL")
        files = self.fs.files(f"{self.prefix}/events")
        require(files, "MISSING_JOURNAL")
        prev = "0" * 64
        last = None
        for index, rel in enumerate(files, 1):
            require(rel == f"{self.prefix}/events/{index:08d}.json", "JOURNAL_GAP")
            event = strict_json(self.fs.read(rel))
            require(set(event) == {"schema", "tag", "rev", "prev", "operation", "state", "hash"},
                    "EVENT_SCHEMA")
            require(event["schema"] == 1 and event["tag"] == self.store.tag and
                    event["rev"] == index and event["prev"] == prev, "JOURNAL_CHAIN")
            raw = {k: value for k, value in event.items() if k != "hash"}
            require(digest(raw) == event["hash"], "JOURNAL_CORRUPT")
            prev, last = event["hash"], event
        return last

    def load(self):
        tip = self._events()
        projection = strict_json(self.fs.read(f"{self.prefix}/projection.json"))
        require(projection == {"rev": tip["rev"], "tip": tip["hash"], "state": tip["state"]},
                "PROJECTION_INCONSISTENT")
        require(isinstance(tip["state"], dict), "STATE_SCHEMA")
        for ref in tip["state"].get("records", []):
            self.store.get(ref)
        return copy.deepcopy(projection)

    def _lock(self):
        token = uuid.uuid4().hex
        try:
            self.fs.write(f"{self.prefix}/writer.lock", token, exclusive=True)
        except Refusal as exc:
            if exc.code == "ALREADY_EXISTS":
                raise Refusal("WRITER_BUSY") from exc
            raise
        return token

    def _unlock(self, token):
        rel = f"{self.prefix}/writer.lock"
        require(self.fs.read(rel).decode() == token, "LOCK_OWNER_CHANGED")
        self.fs.path(rel).unlink()

    def _append(self, revision, previous, operation, state, fault=None):
        event = {"schema": 1, "tag": self.store.tag, "rev": revision, "prev": previous,
                 "operation": operation, "state": state}
        event["hash"] = digest(event)
        raw = canonical(event)
        if fault == "before_event":
            raise Refusal("SIMULATED_INTERRUPTION", fault)
        self.fs.write(f"{self.prefix}/events/{revision:08d}.json",
                      raw[:len(raw)//2] if fault == "partial_event" else raw, exclusive=True)
        if fault in ("partial_event", "after_event"):
            raise Refusal("SIMULATED_INTERRUPTION", fault)
        projection = {"rev": revision, "tip": event["hash"], "state": state}
        self.fs.replace(f"{self.prefix}/projection.json", canonical(projection))
        return copy.deepcopy(projection)

    def initialize(self, state):
        token = self._lock()
        try:
            require(not self.fs.path(f"{self.prefix}/events").exists(), "ALREADY_INITIALIZED")
            return self._append(1, "0" * 64, "FIXTURE_GENESIS", state)
        finally:
            self._unlock(token)

    def transact(self, expected_revision, operation, update, fault=None):
        token = self._lock()
        try:
            prior = self.load()
            require(prior["rev"] == expected_revision, "STALE_REVISION")
            state = update(copy.deepcopy(prior["state"]))
            return self._append(prior["rev"] + 1, prior["tip"], operation, state, fault)
        finally:
            self._unlock(token)

    def repair_projection(self, expected_tip, *, authorized=False):
        require(authorized, "RECOVERY_AUTHORITY_REQUIRED")
        token = self._lock()
        try:
            tip = self._events()  # cannot repair a torn/missing event
            require(tip["hash"] == expected_tip, "STALE_RECOVERY_TIP")
            require(isinstance(tip["state"], dict), "STATE_SCHEMA")
            for ref in tip["state"].get("records", []):
                self.store.get(ref)
            data = {"rev": tip["rev"], "tip": tip["hash"], "state": tip["state"]}
            self.fs.replace(f"{self.prefix}/projection.json", canonical(data))
            return data
        finally:
            self._unlock(token)

    def backup(self, name):
        require(re.fullmatch("fixture-backup-[a-z0-9-]+", name), "BACKUP_NAME")
        token = self._lock()
        try:
            current = self.load()
            dest = f"backups/{name}"
            require(not self.fs.path(dest).exists(), "BACKUP_EXISTS")
            files = [x for x in self.fs.files(self.prefix) if not x.endswith("writer.lock")]
            inventory = {}
            for source in files:
                suffix = source[len(self.prefix)+1:]
                data = self.fs.read(source)
                self.fs.write(f"{dest}/store/{suffix}", data, exclusive=True)
                inventory[suffix] = digest(data)
            self.fs.write(f"{dest}/backup.json", canonical(
                {"tag": self.store.tag, "tip": current["tip"], "inventory": inventory}), exclusive=True)
            return current["tip"]
        finally:
            self._unlock(token)

    def restore(self, name, expected_tip, *, authorized=False):
        require(authorized, "RECOVERY_AUTHORITY_REQUIRED")
        require(re.fullmatch("fixture-backup-[a-z0-9-]+", name), "BACKUP_NAME")
        data = strict_json(self.fs.read(f"backups/{name}/backup.json"))
        require(data.get("tag") == self.store.tag and data.get("tip") == expected_tip, "STALE_BACKUP")
        prefix = f"backups/{name}/store"
        found = {x[len(prefix)+1:]: digest(self.fs.read(x)) for x in self.fs.files(prefix)}
        require(found == data.get("inventory"), "BACKUP_INCONSISTENT")
        require(not self.fs.path("restored").exists(), "RESTORE_TARGET_EXISTS")
        for suffix in found:
            self.fs.write(f"restored/{suffix}", self.fs.read(f"{prefix}/{suffix}"), exclusive=True)
        restored = Journal(Store(self.fs, "restored"))
        require(restored.load()["tip"] == expected_tip, "RESTORE_TIP_MISMATCH")
        return restored  # caller MUST check source/binding/outstanding authority
