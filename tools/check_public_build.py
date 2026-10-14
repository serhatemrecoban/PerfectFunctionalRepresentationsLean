"""Public build gate. Python 3.11+; standard library only; never updates pins."""
from __future__ import annotations

import argparse
import json
from pathlib import Path
import re
import subprocess
import tomllib

ROOT = Path(__file__).resolve().parents[1]
LIT_REV = "0bef5ef5124d7c33afc1aaed8d4f34a1c3a5ce8f"
MATHLIB_REV = "0df444a360eaa60ab8c11dca51a86af692955474"
TOOLCHAIN = "leanprover/lean4:v4.33.1"
CONFIG = ("lakefile.toml", "lake-manifest.json", "lean-toolchain")
PLACEHOLDERS = re.compile(r"\b(sorry|admit|axiom|opaque|undefined)\b")
PRIVATE_DIRS = (".lake/", ".pfr-review/", "tmp/", "papers/", "references/",
                "info theory e-books/", "output/pdf/")


def require(condition: bool, message: str) -> None:
    if not condition:
        raise ValueError(message)


def output(*args: str, root: Path = ROOT) -> str:
    return subprocess.check_output(args, cwd=root, text=True, encoding="utf-8").strip()


def maintained_sources(files: list[str]) -> list[str]:
    sources = sorted(p for p in files if p.endswith(".lean") and
                     (p == "PerfectFunctionalRepresentations.lean" or
                      p.startswith("PerfectFunctionalRepresentations/")))
    require("PerfectFunctionalRepresentations.lean" in sources, "Missing mathematical root")
    require(any("/Tests/" in p for p in sources), "No maintained regression modules found")
    return sources


def validate_pins(root: Path) -> dict:
    config = tomllib.loads((root / "lakefile.toml").read_text(encoding="utf-8"))
    manifest = json.loads((root / "lake-manifest.json").read_text(encoding="utf-8"))
    deps = config.get("require", [])
    require(len(deps) == 1 and deps[0].get("name") == "LeanInfoTheory",
            "Expected the single approved LeanInfoTheory dependency")
    require(deps[0].get("rev") == "v0.1.0" and
            deps[0].get("git") == "https://github.com/serhatemrecoban/LeanInfoTheory"
            and "path" not in deps[0], "LeanInfoTheory release pin or origin changed")
    packages = {p["name"]: p for p in manifest["packages"]}
    require(len(packages) == len(manifest["packages"]), "Duplicate dependency names")
    require(packages["LeanInfoTheory"]["rev"] == LIT_REV and
            packages["LeanInfoTheory"]["inputRev"] == "v0.1.0" and
            packages["LeanInfoTheory"]["url"] == deps[0]["git"],
            "LeanInfoTheory manifest identity changed")
    require(packages["mathlib"]["rev"] == MATHLIB_REV and
            packages["mathlib"]["url"] == "https://github.com/leanprover-community/mathlib4",
            "Mathlib manifest identity changed")
    require((root / "lean-toolchain").read_text(encoding="utf-8").strip() == TOOLCHAIN,
            "Lean toolchain changed")
    return manifest


def check_tracked_content(files: list[str], sources: list[str], root: Path) -> None:
    for file in files:
        low = file.lower()
        require(not low.startswith(PRIVATE_DIRS), f"Private/generated path tracked: {file}")
        require(Path(low).suffix not in {".pdf", ".pem", ".key", ".p12", ".pfx"},
                f"Manuscript or key material needs explicit publication review: {file}")
        require(Path(low).name not in {".env", ".netrc", ".git-credentials", "id_rsa", "id_ed25519"},
                f"Credential-store filename tracked: {file}")
    for file in sources:
        text = (root / file).read_text(encoding="utf-8")
        match = PLACEHOLDERS.search(text)
        require(match is None, f"Forbidden Lean placeholder token in {file}")


def verify_installed(manifest: dict, root: Path) -> None:
    for package in manifest["packages"]:
        require(package["type"] == "git", "Expected Git-pinned dependencies")
        path = root / manifest["packagesDir"] / package["name"]
        actual = output("git", "rev-parse", "HEAD", root=path)
        require(actual == package["rev"], f"Installed revision mismatch: {package['name']}")
        dirty = output("git", "status", "--porcelain", "--untracked-files=no", root=path)
        require(not dirty, f"Tracked dependency files modified: {package['name']}")
    print(f"Verified {len(manifest['packages'])} installed dependency revisions and clean tracked files.", flush=True)


def build_all(sources: list[str], root: Path) -> None:
    modules = [p[:-5].replace("/", ".") for p in sources]
    subprocess.run(["lake", "build", *modules], cwd=root, check=True)
    subprocess.run(["lake", "build"], cwd=root, check=True)


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("mode", choices=("static", "build"))
    args = parser.parse_args()
    files = output("git", "ls-files", "-z").split("\0")
    files = [p for p in files if p]
    sources = maintained_sources(files)
    manifest = validate_pins(ROOT)
    check_tracked_content(files, sources, ROOT)
    print(f"Static gate passed: {len(sources)} maintained Lean modules; LeanInfoTheory v0.1.0.", flush=True)
    if args.mode == "static":
        return
    before = {p: (ROOT / p).read_bytes() for p in CONFIG}
    print("Building all maintained modules, including tests and examples.", flush=True)
    build_all(sources, ROOT)
    verify_installed(manifest, ROOT)
    require(all((ROOT / p).read_bytes() == content for p, content in before.items()),
            "Build changed a committed dependency/toolchain configuration")
    subprocess.run(["git", "diff", "--exit-code", "--", *CONFIG], cwd=ROOT, check=True)
    print("Complete public build gate passed; dependency configuration unchanged.", flush=True)


if __name__ == "__main__":
    main()
