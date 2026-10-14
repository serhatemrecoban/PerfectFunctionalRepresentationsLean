"""Reproduce explicit LeanInfoTheory source-reference counts from fresh .ilean files.

Run after building every maintained PFR module. No source/dependency files are
modified. This is a reference inventory, not a proof-term dependency analysis.
"""
from pathlib import Path
import argparse
import collections
import datetime
import hashlib
import html
import json
import subprocess


def audit(root, out):
    root, out = root.resolve(), out.resolve()
    out.mkdir(parents=True, exist_ok=True)
    def read_json(p):
        return json.loads(p.read_text(encoding="utf-8"))
    def sha(p):
        return hashlib.sha256(p.read_bytes()).hexdigest()
    def git(*args, cwd=root):
        return subprocess.check_output(["git", *args], cwd=cwd, text=True, encoding="utf-8").strip()
    lit = root / ".lake/packages/LeanInfoTheory"
    manifest_path = lit / "docs/v0.1-public-api.json"
    index_path = lit / "home_page/docs/declaration_index.json"
    api = {x["name"]: x for x in read_json(manifest_path)["declarations"]}
    index = {x["name"]: x for x in read_json(index_path)["declarations"]}
    files = [p for p in git("ls-files", "--", "*.lean").splitlines()
             if p == "PerfectFunctionalRepresentations.lean" or p.startswith("PerfectFunctionalRepresentations/")]
    refs, owners, used_modules = [], [], set()
    for file in files:
        source = root / file
        compiled = root / ".lake/build/lib/lean" / file.replace(".lean", ".ilean")
        data = read_json(compiled)
        module = file[:-5].replace("/", ".")
        assert data["version"] == 5 and data["module"] == module
        category = "tests" if "/Tests/" in file else "examples" if "/Examples/" in file else "implementation"
        lines = source.read_text(encoding="utf-8").splitlines()
        owners.append(dict(path=file, module=module, category=category,
                           source_sha256=sha(source), ilean_sha256=sha(compiled)))
        for key, entry in data["references"].items():
            symbol = json.loads(key).get("c", {})
            if not symbol.get("m", "").startswith("LeanInfoTheory."):
                continue
            name, owner = symbol["n"], symbol["m"]
            assert name in api and name in index, (name, "not indexed")
            assert owner == api[name]["module"] == index[name]["module"]
            assert api[name]["kind"] == index[name]["kind"]
            seen = set()
            for use in entry["usages"]:
                span = tuple(use[:4])
                assert span not in seen, (file, name, span, "duplicate")
                seen.add(span)
                start_line, start_col, end_line, end_col = span
                assert start_line == end_line
                # Lean source-position columns in this inventory are verified by
                # exact equality to the symbol or a namespace-shortened spelling.
                token = lines[start_line][start_col:end_col]
                assert token == name or name.endswith("." + token), (file, span, name, token)
                assert token, (file, span)
                used_modules.add(owner)
                refs.append(dict(name=name, dependency_module=owner, kind=api[name]["kind"],
                                 file=file, category=category, line=start_line + 1,
                                 column_zero_based=start_col, end_column_zero_based=end_col,
                                 spelling=token, containing_declaration=use[4] if len(use)>4 else None))
    refs.sort(key=lambda r: (r["file"], r["line"], r["column_zero_based"], r["name"]))
    declarations = []
    for name in sorted({r["name"] for r in refs}):
        uses = [r for r in refs if r["name"] == name]
        by = collections.Counter(r["category"] for r in uses)
        source = lit / index[name]["path"]
        source_line = source.read_text(encoding="utf-8").splitlines()[index[name]["line"] - 1]
        assert index[name]["short_name"] in source_line, (name, source_line)
        declarations.append(dict(name=name, kind=api[name]["kind"], module=api[name]["module"],
                                 source_path=index[name]["path"], source_line=index[name]["line"],
                                 source_sha256=sha(source), documentation=index[name].get("doc", ""),
                                 implementation=by["implementation"], tests=by["tests"],
                                 examples=by["examples"], total=len(uses)))
    summary = {}
    for category in ["all", "implementation", "tests", "examples"]:
        rr = refs if category == "all" else [r for r in refs if r["category"] == category]
        names = {r["name"] for r in rr}
        summary[category] = dict(references=len(rr), distinct_declarations=len(names),
                                files_with_references=len({r["file"] for r in rr}),
                                distinct_by_kind=dict(collections.Counter(api[n]["kind"] for n in names)),
                                references_by_kind=dict(collections.Counter(r["kind"] for r in rr)))
    main_refs = [r for r in refs if r["category"] == "implementation"]
    summary["implementation_inline_anonymous_example_references"] = sum(
        bool(r["containing_declaration"] and r["containing_declaration"].endswith("._example")) for r in main_refs)
    summary["implementation_named_consumers"] = len({r["containing_declaration"] for r in main_refs
        if r["containing_declaration"] and not r["containing_declaration"].endswith("._example")})
    summary["implementation_section_context_references"] = sum(r["containing_declaration"] is None for r in main_refs)
    summary["dependency_modules_with_references"] = len(used_modules)
    summary["maintained_source_files"] = len(files)
    summary["maintained_files_by_category"] = dict(collections.Counter(o["category"] for o in owners))
    totals = summary["all"]
    nk, rk = totals["distinct_by_kind"], totals["references_by_kind"]
    result_line = (f"{totals['distinct_declarations']} distinct declarations: "
                   f"{nk.get('theorem',0)} theorems, {nk.get('def',0)} definitions, {nk.get('abbrev',0)} abbreviations.")
    count_line = (f"{totals['references']:,} explicit compiler-resolved references: "
                  f"{rk.get('theorem',0):,} theorem + {rk.get('def',0):,} definition + {rk.get('abbrev',0):,} abbreviation references.")
    limitations = [
        "One use means one distinct compiler-recorded constant/name/source-span reference, not a runtime call.",
        "Counted references appear in definitions, theorem statements, proof scripts, section variables and checked examples.",
        "Implementation modules include inline anonymous examples and named regression fixtures; they are not exclusively production proofs.",
        "No comment mentions, import lines, scratch files, generated copies, dependency-internal uses or transitive uses are counted.",
        "Implicit elaborator/tactic/simp dependencies without a corresponding source-name reference are not counted.",
        "The same declaration may occur in several categories; distinct category counts must not be added.",
        "Owned PMF additions are credited to LeanInfoTheory; mathlib-owned PMF declarations are excluded.",
        "Repeated references are sensitive to notation, proof style and refactoring. Counts do not measure code, time or effort saved.",
        "Declarations may be mathematically important even when explicitly referenced only once.",
    ]
    record = dict(generated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),
                  project_head=git("rev-parse", "HEAD"),
                  dependency_head=git("rev-parse", "HEAD", cwd=lit),
                  dependency_dirty_status=git("status", "--short", cwd=lit),
                  mathlib_head=git("rev-parse", "HEAD", cwd=root / ".lake/packages/mathlib"),
                  manifest_sha256=sha(manifest_path), index_sha256=sha(index_path),
                  toolchain=(root/"lean-toolchain").read_text(encoding="utf-8").strip(),
                  counter_sha256=sha(Path(__file__)),
                  config_sha256={p: sha(root/p) for p in ["lakefile.toml", "lake-manifest.json", "lean-toolchain"]},
                  method="Lean .ilean v5 resolved constant usages; owner-module filtering; unique symbol/source spans; public-manifest/index and exact source-token checks.",
                  summary=summary, limitations=limitations, sources=owners, declarations=declarations, references=refs)
    (out/"leaninfotheory-pfr-reuse-evidence.json").write_text(json.dumps(record, ensure_ascii=False, indent=2)+"\n", encoding="utf-8")
    lines = ["LeanInfoTheory reuse in PerfectFunctionalRepresentationsLean", "Measured 13 October 2026", "",
             "Source baseline: " + record["project_head"], "Dependency: LeanInfoTheory v0.1.0 / " + record["dependency_head"], "",
             "RESULT", result_line, count_line, ""]
    for cat in ["implementation", "tests", "examples"]:
        s = summary[cat]
        lines.append(f"{cat}: {s['references']} references to {s['distinct_declarations']} distinct declarations.")
    lines += ["", "METHOD AND LIMITS", *["- " + s for s in limitations], "",
              f"Implementation-module total includes {summary['implementation_inline_anonymous_example_references']} references in anonymous inline examples.",
              f"There are {summary['implementation_named_consumers']} named implementation-module consumers (including private helpers and named fixtures),",
              f"plus {summary['implementation_section_context_references']} references in section-variable context. These consumers are not distinct paper results.", "",
              "COMPLETE DECLARATION LIST", "Columns: implementation modules | tests | examples | total", "",
              "Shannon names below have the prefix LeanInfoTheory.Shannon.; PMF names retain their full names."]
    for kind, title in [("def", "DEFINITIONS"), ("abbrev", "ABBREVIATIONS"), ("theorem", "THEOREMS")]:
        lines += ["", title]
        for d in declarations:
            if d["kind"] == kind:
                name=d["name"].removeprefix("LeanInfoTheory.Shannon.")
                lines.append(f"{d['implementation']:4d} | {d['tests']:4d} | {d['examples']:3d} | {d['total']:4d}  {name}")
                lines.append("       Owner/import: " + d["module"] + "; source line " + str(d["source_line"]))
    lines += ["", "HOW TO USE THESE NUMBERS",
              "Use these as concrete evidence of library adoption, together with examples of mathematical leverage.",
              "Do not convert them into an unmeasured code-size or development-time saving.", "",
              f"The companion JSON gives all {totals['references']:,} exact source locations, source hashes, owner modules, kinds and audit metadata.",
              "Rebuild all maintained modules, then rerun count_reuse.py to reproduce the inventory."]
    (out/"leaninfotheory-pfr-reuse-list.txt").write_text("\n".join(lines)+"\n", encoding="utf-8")
    esc=html.escape
    sections=[]
    for kind,title in [("def","Definitions"),("abbrev","Abbreviations"),("theorem","Theorems")]:
        rows=[]
        for d in declarations:
            if d["kind"] != kind:
                continue
            label=d["name"].removeprefix("LeanInfoTheory.Shannon.")
            rows.append(f'<tr><td><code>{esc(label)}</code><small>{esc(d["module"])}</small></td>'
                        f'<td>{d["implementation"]}</td><td>{d["tests"]}</td><td>{d["examples"]}</td><td>{d["total"]}</td></tr>')
        sections.append(f'<h2>{title} ({len(rows)})</h2><table><thead><tr><th>Declaration / owning module</th><th>Impl.</th><th>Tests</th><th>Ex.</th><th>Total</th></tr></thead><tbody>'+''.join(rows)+'</tbody></table>')
    page='''<!doctype html><html lang="en"><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>LeanInfoTheory reuse inventory — PFR</title>
<style>body{max-width:1120px;margin:44px auto;padding:0 24px;font:16px/1.55 system-ui,sans-serif;color:#172b3d;background:#fbfcfe}h1{line-height:1.15}h2{margin-top:36px}p{max-width:900px}table{border-collapse:collapse;width:100%;font-size:14px;background:white}th,td{padding:10px 12px;border-bottom:1px solid #dce3ea;text-align:right;vertical-align:top}th:first-child,td:first-child{text-align:left}th{background:#e8eff6}code{overflow-wrap:anywhere}small{display:block;color:#596674;font-size:11px}aside{border-left:4px solid #316fa4;background:#edf4fa;padding:12px 20px}.meta{font-size:13px;color:#596674}li{margin-bottom:7px}@media print{body{margin:0;max-width:none;font-size:11px}table{font-size:9px}tr{break-inside:avoid}th,td{padding:5px}small{font-size:8px}h2{break-after:avoid}}</style>
<h1>LeanInfoTheory reuse in PFR</h1><p class="meta">Private audit • 13 October 2026 • PFR 9e659bd • LeanInfoTheory v0.1.0</p>
<aside><strong>105 distinct declarations · 1,385 explicit source references</strong><br>76 theorems, 23 definitions and 6 abbreviations. The reference split is 341 theorem references and 1,044 definition/abbreviation references.</aside>
<p>This is useful evidence of actual library adoption, not a measure of code or time saved. Counts come from Lean's resolved reference index, not a text search. Each declaration and owning module is checked against the installed pinned public API manifest and declaration index.</p>
'''
    page+='<h2>Scope breakdown</h2><table><tr><th>Source category</th><th>References</th><th>Distinct declarations</th></tr>'
    for cat,label in [("implementation","Implementation modules, including inline checks"),("tests","Dedicated test modules"),("examples","Example modules"),("all","All maintained source")]:
        page+=f'<tr><td>{label}</td><td>{summary[cat]["references"]:,}</td><td>{summary[cat]["distinct_declarations"]}</td></tr>'
    page+=f'</table><p>The implementation total includes {summary["implementation_inline_anonymous_example_references"]} anonymous-example references and some named regression fixtures. Distinct declarations overlap across categories; do not add those column entries. All {len(files)} maintained source files are included; scratch material is excluded.</p>'
    page+='<h2>Reading the complete list</h2><p><code>LeanInfoTheory.Shannon.</code> is omitted from Shannon declaration names below; <code>PMF.</code> is retained. “Impl.” includes inline checks; “Ex.” means the dedicated examples directory. Owning modules are also focused import paths. Definitions include uses in theorem statements as well as proof bodies.</p>'
    page+=''.join(sections)
    page+='<h2>Method and qualifications</h2><ul>'+''.join('<li>'+esc(x)+'</li>' for x in limitations)+'</ul>'
    page+='<p>The original 13 October 2026 measurement was preceded by a successful all-module build (2,823 jobs). Independent read-only counting agreed with its totals. Rerunning this counter does not itself rebuild or repeat that independent check. The companion JSON records every counted location and the source identities; the Python counter is included for reproducibility. This does not change source, dependencies, project scope or publication status.</p>'
    page=page.replace('105 distinct declarations · 1,385 explicit source references',f'{totals["distinct_declarations"]} distinct declarations · {totals["references"]:,} explicit source references')
    page=page.replace('76 theorems, 23 definitions and 6 abbreviations. The reference split is 341 theorem references and 1,044 definition/abbreviation references.',f'{nk.get("theorem",0)} theorems, {nk.get("def",0)} definitions and {nk.get("abbrev",0)} abbreviations. The reference split is {rk.get("theorem",0):,} theorem references and {rk.get("def",0)+rk.get("abbrev",0):,} definition/abbreviation references.')
    page+='<p class="meta">Project '+esc(record['project_head'])+'<br>Dependency '+esc(record['dependency_head'])+'</p></html>'
    (out/"leaninfotheory-pfr-reuse-inventory.html").write_text(page,encoding="utf-8")
    print(json.dumps(summary,indent=2))


if __name__ == "__main__":
    parser=argparse.ArgumentParser()
    parser.add_argument("--root",type=Path,default=Path(__file__).resolve().parents[2])
    parser.add_argument("--out",type=Path,default=Path(__file__).resolve().parent)
    args=parser.parse_args()
    audit(args.root,args.out)
