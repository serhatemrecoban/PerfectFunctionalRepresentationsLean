"""Generate/check a PFR-only reference from elaborated Lean, without doc-gen dependencies.

Run normally to build/export/render, --check for compiler-backed reproducibility,
or --check-render for a fast source-identity and deterministic-render check.
The latter does not replace the compiler-backed check in Lean CI.
"""
from __future__ import annotations

import argparse
from collections import Counter
import hashlib
import html
import json
from pathlib import Path
import re
import subprocess
import sys
from urllib.parse import quote

import check_public_build as build_gate

ROOT = Path(__file__).resolve().parents[1]
REPOSITORY = "https://github.com/serhatemrecoban/PerfectFunctionalRepresentationsLean"
SOURCE_COMMIT = "da44e39a2ec2936d32195dd97df21c1bd19e63bc"
CONFIG = ("lakefile.toml", "lake-manifest.json", "lean-toolchain")
TOOL_FILES = ("tools/generate_api.py", "tools/export_api.lean", "tools/api_search.js", "tools/api_style.css",
              "tools/check_public_build.py")
PREFIX = "PerfectFunctionalRepresentations."
BOUNDARY = (
    "All public source declarations in the production modules, plus the four public "
    "Nonrepresentable3x3 example declarations and public structure/inductive constructors "
    "and projections, including the derived DecidableEq instance for OperationKind. "
    "Private declarations, internal/generated proof auxiliaries, recursors, "
    "test modules and private demonstration fixtures are excluded. Imported dependency "
    "declarations are not duplicated. This is reference coverage, not a new API stability promise."
)


def require(condition: bool, message: str) -> None:
    if not condition:
        raise ValueError(message)


def text(path: Path) -> str:
    return path.read_text(encoding="utf-8").replace("\r\n", "\n")


def digest(value: str) -> str:
    return hashlib.sha256(value.encode("utf-8")).hexdigest()


def git(*args: str, root: Path = ROOT) -> str:
    result = subprocess.run(["git", *args], cwd=root, capture_output=True,
                            text=True, encoding="utf-8")
    require(result.returncode == 0, f"Git could not resolve {' '.join(args[:2])}")
    return result.stdout


def selected_sources(root: Path) -> list[str]:
    result = []
    for name in git("ls-files", "-z", root=root).split("\0"):
        if not name.endswith(".lean"):
            continue
        if name == "PerfectFunctionalRepresentations.lean":
            result.append(name)
        elif name.startswith("PerfectFunctionalRepresentations/") and "/Tests/" not in name:
            if "/Examples/" not in name or name.endswith("/Examples/Nonrepresentable3x3.lean"):
                result.append(name)
    require("PerfectFunctionalRepresentations.lean" in result, "Missing mathematical root")
    return sorted(result)


def module_name(path: str) -> str:
    return path[:-5].replace("/", ".")


def module_page(name: str) -> str:
    return (name.removeprefix(PREFIX) if name != PREFIX[:-1] else "Root") + ".html"


def source_snapshot(root: Path) -> dict[str, str]:
    snapshot = {}
    for file in [*selected_sources(root), *CONFIG]:
        current = text(root / file)
        original = git("show", f"{SOURCE_COMMIT}:{file}", root=root)
        require(current == original, f"API source snapshot changed: {file}; review/re-pin explicitly")
        snapshot[file] = digest(current)
    return snapshot


def tool_hashes(root: Path) -> dict[str, str]:
    return {file: digest(text(root / file)) for file in TOOL_FILES}


def parse_export(output: str) -> tuple[list[str], list[dict], list[str]]:
    modules, declarations, no_range = [], [], []
    for line in output.splitlines():
        if line.startswith("PFR_API_MODULE "):
            modules.append(json.loads(line.removeprefix("PFR_API_MODULE ")))
        elif line.startswith("PFR_API_DECL "):
            declarations.append(json.loads(line.removeprefix("PFR_API_DECL ")))
        elif line.startswith("PFR_API_NO_RANGE "):
            no_range.append(json.loads(line.removeprefix("PFR_API_NO_RANGE ")))
    require(bool(modules) and bool(declarations), "Lean exporter returned no API")
    names = [row["name"] for row in declarations]
    require(len(names) == len(set(names)), "Duplicate compiler declaration")
    return sorted(modules), sorted(declarations, key=lambda row: (row["module"], row["line"], row["name"])), no_range


def compiler_export(root: Path, sources: list[str]) -> tuple[list[str], list[dict], list[str]]:
    manifest = build_gate.validate_pins(root)
    modules = [module_name(file) for file in sources]
    subprocess.run(["lake", "build", *modules], cwd=root, check=True)
    build_gate.verify_installed(manifest, root)
    result = subprocess.run(["lake", "env", "lean", "tools/export_api.lean"], cwd=root,
                            capture_output=True, text=True, encoding="utf-8")
    if result.returncode:
        diagnostics = [line for line in (result.stdout + result.stderr).splitlines()
                       if not line.startswith("PFR_API_")]
        raise ValueError("Lean API export failed:\n" + "\n".join(diagnostics[-20:]))
    require(build_gate.validate_pins(root) == manifest, "Dependency manifest changed during API export")
    build_gate.verify_installed(manifest, root)
    return parse_export(result.stdout)


def source_declarations(root: Path, modules: list[str]) -> set[str]:
    """Compiler source-position inventory, not regex-extracted signatures."""
    names = set()
    for module in modules:
        path = root / ".lake/build/lib/lean" / (module.replace(".", "/") + ".ilean")
        data = json.loads(text(path))
        require(data["version"] == 5 and data["module"] == module, "Unexpected compiler index")
        names.update(name for name in data["decls"]
                     if not any(part.startswith("_") for part in name.split(".")))
    return names


def generate_data(root: Path) -> dict:
    sources = selected_sources(root)
    snapshot = source_snapshot(root)
    modules, declarations, no_range = compiler_export(root, sources)
    require(set(modules) == {module_name(file) for file in sources}, "API module closure differs from scope")
    expected = source_declarations(root, modules)
    actual = {row["name"] for row in declarations}
    require(expected <= actual, "Compiler source declarations missing: " + ", ".join(sorted(expected - actual)))
    # This compiler-generated enumeration helper has no authored source range.
    require(all(name.endswith(".ofNat_ctorIdx") for name in no_range),
            "Unclassified public constant without source range: " + ", ".join(no_range))
    for row in declarations:
        path = row["module"].replace(".", "/") + ".lean"
        lines = text(root / path).splitlines()
        require(0 < row["line"] <= row["end_line"] <= len(lines), f"Invalid source range: {row['name']}")
        require(bool(row["type"]) and "⋯" not in row["type"], f"Truncated compiler type: {row['name']}")
        require(row["kind"] not in {"axiom", "opaque", "quotient", "recursor"}, f"Unexpected API kind: {row['name']}")
        row["source_path"] = path
        row["source_line_text"] = lines[row["line"] - 1]
        row["source_url"] = f"{REPOSITORY}/blob/{SOURCE_COMMIT}/{path}#L{row['line']}"
        row["page"] = module_page(row["module"])
        row["in_compiler_source_index"] = row["name"] in expected
    counts = Counter(row["module"] for row in declarations)
    manifest = json.loads(text(root / "lake-manifest.json"))
    dependencies = {p["name"]: p["rev"] for p in manifest["packages"]}
    require(source_snapshot(root) == snapshot, "Source changed during API generation")
    return {"schema": 1, "repository": REPOSITORY, "source_commit": SOURCE_COMMIT,
            "toolchain": text(root / "lean-toolchain").strip(),
            "leaninfotheory_revision": dependencies["LeanInfoTheory"],
            "mathlib_revision": dependencies["mathlib"],
            "source_hash_method": "SHA-256 of UTF-8 text with LF line endings",
            "source_hashes": snapshot, "generator_hashes": tool_hashes(root),
            "boundary": BOUNDARY, "type_method": "Lean.Meta.ppExpr of elaborated ConstantInfo.type; universes, full names, deep terms and proofs enabled",
            "source_named_index_count": len(expected),
            "excluded_generated_without_range": len(no_range),
            "modules": [{"name": name, "page": module_page(name), "declarations": counts[name]} for name in modules],
            "declarations": declarations}


def page_shell(title: str, body: str, scripts: str = "", filename: str = "index.html") -> str:
    return f'''<!doctype html>
<html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="description" content="Lean API for the ISIT 2026 paper On Perfect Functional Representations, with compiler-generated types, documentation and commit-pinned source links.">
<meta name="theme-color" content="#155799"><link rel="canonical" href="https://serhatemrecoban.github.io/PerfectFunctionalRepresentationsLean/api/{quote(filename)}">
<title>{html.escape(title)} · On Perfect Functional Representations API</title><link rel="icon" href="../assets/favicon.svg" type="image/svg+xml">
<link rel="stylesheet" href="../assets/site.css"><link rel="stylesheet" href="api.css">{scripts}</head><body>
<a class="skip" href="#main">Skip to content</a>
<header class="site-header"><div class="wrap header-inner"><p class="project-name"><a href="../index.html">On Perfect Functional Representations</a></p>
<p class="project-tagline">A Lean formalization of the ISIT 2026 paper, built on LeanInfoTheory v0.1.0.</p>
<nav class="nav" aria-label="Main navigation"><a href="../index.html">Overview</a><a href="../blueprint/index.html">Blueprint</a><a href="index.html" aria-current="page">Lean API</a><a href="../discussion.html">Discussion</a><a href="../reproduce.html">Reproduce &amp; cite</a><a class="repo-link" href="{REPOSITORY}">GitHub</a><a href="https://doi.org/10.1109/ISIT62367.2026.11653684">Paper</a><a href="https://serhatemrecoban.github.io/LeanInfoTheory/">LeanInfoTheory</a></nav></div></header>
<main id="main" class="wrap api-page">{body}</main>
<footer class="site-footer"><div class="wrap footer-inner"><p>PFR API · LeanInfoTheory v0.1.0 · Lean 4.33.1<br>Generated from Lean; no dependency upgrade.</p><div class="footer-links"><a href="index.html">API index</a><a href="../discussion.html#limitations">Limitations</a><a href="{REPOSITORY}">Repository</a></div></div></footer>
</body></html>
'''


def declaration_html(row: dict) -> str:
    esc = html.escape
    documentation = row["documentation"].strip()
    doc = f'<pre class="api-docstring">{esc(documentation)}</pre>' if documentation else '<p class="small">No declaration docstring is present in the source.</p>'
    link = quote(row["name"], safe=".")
    return (f'<article class="api-declaration" id="{esc(row["name"], quote=True)}">'
            f'<p class="label">{esc(row["kind"])} · <a href="{row["source_url"]}">Source line {row["line"]}</a></p>'
            f'<h2><a href="#{link}"><code>{esc(row["name"])}</code></a></h2>{doc}'
            f'<pre class="api-type" tabindex="0" aria-label="Elaborated Lean type"><code>{esc(row["type"])}</code></pre></article>')


def render(data: dict, root: Path) -> dict[str, str]:
    esc = html.escape
    declarations = data["declarations"]
    modules = data["modules"]
    outputs = {"api-data.json": json.dumps(data, ensure_ascii=False, indent=2) + "\n",
               "api.js": text(root / "tools/api_search.js"), "api.css": text(root / "tools/api_style.css")}
    module_links = ''.join(f'<li><a href="{m["page"]}"><code>{esc(m["name"])}</code></a> '
                           f'<span class="small">{m["declarations"]} declarations</span></li>' for m in modules)
    search_rows = []
    for row in declarations:
        terms = " ".join((row["name"], row["module"], row["kind"], row["type"], row["documentation"]))
        search_rows.append(f'<li data-api-entry data-search="{esc(terms, quote=True)}"><a title="{esc(row["name"], quote=True)}" href="{row["page"]}#{quote(row["name"], safe=".")}"><code>{esc(row["name"].removeprefix(PREFIX))}</code></a> <span class="small">{esc(row["kind"])}</span><div class="small">{esc(row["module"])}</div></li>')
    body = f'''<div class="page-intro"><p class="eyebrow">Compiler-generated reference</p><h1>Lean API documentation</h1>
<p class="lead">{len(declarations)} declarations across {len(modules)} modules, with elaborated types, source docstrings and exact source links.</p></div>
<section class="api-search" aria-labelledby="search-heading"><h2 id="search-heading">Search declarations</h2>
<label for="api-query">Name, mathematical term, module or type</label><input id="api-query" type="search" autocomplete="off" placeholder="Try singular, coupling, normal form, or IsGreatest" aria-controls="api-results">
<p id="api-count" role="status" aria-live="polite">{len(declarations)} declarations. Search becomes available when JavaScript is enabled; the complete list and module pages work without it.</p>
<ul id="api-results" class="api-search-results" tabindex="0" aria-label="Matching declarations">{''.join(search_rows)}</ul></section>
<section class="section" id="modules"><h2>Modules</h2><ul class="api-module-list">{module_links}</ul></section>
<section class="section" id="scope"><h2>Reference scope</h2><p>{esc(data["boundary"])}</p>
<p>Types are pretty-printed from Lean's elaborated environment—not reconstructed from source text. Source docstrings are displayed verbatim as text; historical development wording in them is not a new project-status claim. Structure constructors and projections may have no separate docstring.</p>
<p>This deliberately focused reference does not duplicate mathlib or LeanInfoTheory documentation, provide tactic search, or promise doc-gen4's linked-type and instance navigation. A source link remains authoritative for notation, declaration bodies and surrounding context.</p>
<p class="small">Source snapshot: <a href="{REPOSITORY}/tree/{SOURCE_COMMIT}"><code>{SOURCE_COMMIT}</code></a>. <a href="api-data.json">Download the machine-readable inventory</a>. Reproduce with <code>python -B tools/generate_api.py --check</code>.</p></section>'''
    outputs["index.html"] = page_shell("Search", body, '<script src="api.js" defer></script>')
    for module in modules:
        name = module["name"]
        rows = [row for row in declarations if row["module"] == name]
        source = name.replace(".", "/") + ".lean"
        contents = ''.join(f'<li><a href="#{quote(row["name"], safe=".")}"><code>{esc(row["name"].removeprefix(PREFIX))}</code></a></li>' for row in rows)
        body = f'''<div class="page-intro"><p class="eyebrow">Module reference</p><h1><code>{esc(name.removeprefix(PREFIX) if name != PREFIX[:-1] else "Root imports")}</code></h1>
<p class="lead">{len(rows)} public reference entries.</p><pre><code>import {esc(name)}</code></pre>
<p><a href="index.html">All modules &amp; search</a> · <a href="{REPOSITORY}/blob/{SOURCE_COMMIT}/{source}#L1">Module source</a></p></div>'''
        if rows:
            body += f'<nav class="api-module-contents" aria-label="Module declarations"><details><summary>Declarations in this module</summary><ul>{contents}</ul></details></nav>'
            body += ''.join(declaration_html(row) for row in rows)
        else:
            body += '<p>This module adds no public reference entries. It is an import aggregate, bootstrap check or private proof-support module; its inclusion does not expose its private machinery as public API.</p>'
        outputs[module["page"]] = page_shell(name, body, filename=module["page"])
    return outputs


def validate_data(data: dict, root: Path) -> set[str]:
    require(data.get("schema") == 1 and data.get("source_commit") == SOURCE_COMMIT
            and data.get("repository") == REPOSITORY, "API inventory identity changed")
    require(data.get("source_hashes") == source_snapshot(root), "API source/config hash mismatch")
    require(data.get("generator_hashes") == tool_hashes(root), "API generator changed; regenerate inventory")
    expected_modules = {module_name(p) for p in selected_sources(root)}
    require(len(data["modules"]) == len(expected_modules)
            and {m["name"] for m in data["modules"]} == expected_modules, "API module inventory changed")
    names, urls = set(), set()
    for module in data["modules"]:
        require(module["page"] == module_page(module["name"]), "Unsafe API module filename")
        path = module["name"].replace(".", "/") + ".lean"
        urls.add(f"{REPOSITORY}/blob/{SOURCE_COMMIT}/{path}#L1")
    for row in data["declarations"]:
        require(row["name"] not in names and row["name"].startswith(PREFIX)
                and not any(part.startswith("_") for part in row["name"].split(".")), "Private/duplicate API declaration")
        names.add(row["name"])
        require(row["module"] in expected_modules and row["page"] == module_page(row["module"]), "Invalid API owner")
        require(row["kind"] in {"theorem", "def", "abbrev", "structure", "inductive", "constructor", "projection"},
                "Invalid public API declaration kind")
        path = row["module"].replace(".", "/") + ".lean"
        require(row["source_path"] == path, "Invalid API source file")
        lines = text(root / path).splitlines()
        require(type(row["line"]) is int and type(row["end_line"]) is int
                and 0 < row["line"] <= row["end_line"] <= len(lines), "Invalid API source range")
        require(lines[row["line"] - 1] == row["source_line_text"], "API source line drift")
        url = f"{REPOSITORY}/blob/{SOURCE_COMMIT}/{path}#L{row['line']}"
        require(row["source_url"] == url, "API source URL drift")
        require(row["type"] and "⋯" not in row["type"], "Empty/truncated API type")
        urls.add(url)
    require(bool(names), "Empty API declaration inventory")
    counts = Counter(row["module"] for row in data["declarations"])
    require(all(m["declarations"] == counts[m["name"]] for m in data["modules"]), "API counts disagree")
    return urls


def compare_outputs(directory: Path, expected: dict[str, str]) -> None:
    actual = {p.name for p in directory.iterdir() if p.is_file()} if directory.exists() else set()
    require(actual == set(expected), "API output inventory differs; regenerate (unexpected files are not deleted)")
    require(not any(p.is_symlink() or p.is_dir() for p in directory.iterdir()), "Unexpected API symlink/subdirectory")
    for file, content in expected.items():
        require(text(directory / file) == content, f"Generated API drift: {file}")


def check_api_source_links(site: Path, hrefs: set[str], repo_root: Path = ROOT) -> set[str]:
    data = json.loads(text(site / "api/api-data.json"))
    urls = validate_data(data, repo_root)
    compare_outputs(site / "api", render(data, repo_root))
    require(urls <= hrefs, "API source URL missing from generated HTML")
    return urls


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    mode = parser.add_mutually_exclusive_group()
    mode.add_argument("--check", action="store_true")
    mode.add_argument("--check-render", action="store_true")
    args = parser.parse_args()
    try:
        if args.check_render:
            data = json.loads(text(ROOT / "site/api/api-data.json"))
            validate_data(data, ROOT)
        else:
            data = generate_data(ROOT)
        outputs = render(data, ROOT)
        directory = ROOT / "site/api"
        if args.check or args.check_render:
            compare_outputs(directory, outputs)
        else:
            directory.mkdir(parents=True, exist_ok=True)
            existing = {p.name for p in directory.iterdir()}
            require(existing <= set(outputs), "Unexpected API files present; inspect instead of deleting")
            for file, content in outputs.items():
                (directory / file).write_text(content, encoding="utf-8", newline="\n")
        label = "Compiler-backed" if not args.check_render else "Source/render"
        print(f"{label} API check passed: {len(data['declarations'])} declarations, {len(data['modules'])} modules.")
    except (ValueError, OSError, subprocess.CalledProcessError) as error:
        print(f"API generation/check failed: {error}", file=sys.stderr)
        raise SystemExit(1) from None


if __name__ == "__main__":
    main()
