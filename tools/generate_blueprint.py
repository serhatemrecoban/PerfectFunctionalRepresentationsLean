"""Render the curated PFR blueprint and its directed mathematical dependency graph.

Standard library only. The JSON entries are author-maintained exposition, not
compiler-extracted dependencies. Public declarations resolve against the separate
compiler-backed API inventory; private fixture anchors are checked at its commit.
Run --check in CI to require exact deterministic output.
"""
from __future__ import annotations

import argparse
from collections import defaultdict
import html
from html.parser import HTMLParser
import json
from pathlib import Path
import re
import subprocess
import textwrap

ROOT = Path(__file__).resolve().parents[1]
SECTIONS = {
    "foundations": "1. The representation problem",
    "canonical": "2. Canonical representations",
    "channels": "3. Perfect channels and singularity",
    "binary": "4. The binary optimum",
    "operations": "5. Column operations",
    "normalization": "6. Normal form",
    "preservation": "7. Preservation",
    "constructive": "8. Constructive characterization",
    "incidence": "9. Partition incidence",
    "primal": "10. The primal criterion",
    "dual": "11. The dual criterion",
}
STATUS = {"formalized": "Formalized", "fixture": "Checked fixture",
          "not-formalized": "Not formalized · cited context"}
VIEWS = {
    "all": ("Whole development", set(SECTIONS)),
    "semantic": ("Representations and binary results", {"foundations", "canonical", "channels", "binary"}),
    "operations": ("Operations and constructive characterization", {"operations", "normalization", "preservation", "constructive"}),
    "lp": ("Linear-programming criteria", {"incidence", "primal", "dual"}),
}
ALIASES = {"lemma-2": "lemma-2-necessary", "lemma-3": "lemma-3-optimum"}


def require(condition, message):
    if not condition:
        raise ValueError(message)


def esc(value):
    return html.escape(str(value), quote=True)


class Fragment(HTMLParser):
    """Keep authored mathematical prose inert and structurally bounded."""
    def __init__(self):
        super().__init__()
        self.stack = []

    def handle_starttag(self, tag, attrs):
        require(tag in {"p", "em", "strong", "sub", "sup", "code", "div", "span", "br", "ul", "ol", "li", "a"},
                f"Unsupported blueprint prose tag: {tag}")
        for key, value in attrs:
            require(key in {"class", "href"}, f"Unsupported blueprint prose attribute: {key}")
            if key == "href":
                require(value and not any(ord(c) <= 32 or c in ':\\' for c in value)
                        and not value.startswith('/'),
                        "Blueprint prose links must be local; put verified source links in evidence")
        require(len(dict(attrs)) == len(attrs), "Duplicate blueprint prose attribute")
        if tag != 'br':
            self.stack.append(tag)

    def handle_endtag(self, tag):
        require(bool(self.stack) and self.stack[-1] == tag, "Unbalanced blueprint prose tags")
        self.stack.pop()

    def handle_startendtag(self, tag, attrs):
        require(tag == 'br', "Only br may be self-closing in blueprint prose")
        self.handle_starttag(tag, attrs)

    def finish(self):
        require(not self.rawdata and not self.stack, "Incomplete blueprint prose fragment")


def api_data(root=ROOT):
    return json.loads((root / "site/api/api-data.json").read_text(encoding="utf-8"))


def load_entries(root=ROOT):
    entries = []
    for name in ("semantics", "operations", "examples"):
        entries.extend(json.loads((root / f"tools/blueprint/{name}.json").read_text(encoding="utf-8"))["entries"])
    return entries


def validate(entries, api):
    require(bool(entries), "Empty blueprint")
    ids = [e["id"] for e in entries]
    require(len(ids) == len(set(ids)), "Duplicate blueprint id")
    names = {d["name"] for d in api["declarations"]}
    for e in entries:
        require(re.fullmatch(r"[a-z][a-z0-9-]*", e["id"]), "Invalid blueprint id")
        require(e["id"] not in SECTIONS and e["id"] not in ALIASES, "Reserved blueprint id")
        require(e["section"] in SECTIONS, "Unknown section")
        require(e["kind"] in {"definition", "theorem", "lemma", "example", "remark"}, "Unknown entry kind")
        require(e["status"] in STATUS, "Unknown entry status")
        for key in ("label", "title", "paper", "statement_html"):
            require(isinstance(e[key], str) and e[key].strip(), f"Missing {key}: {e['id']}")
        for key in ("statement_html", "proof_html", "qualifier_html"):
            fragment = Fragment()
            fragment.feed(e[key])
            fragment.finish()
        require(all(n in names for n in e["declarations"]), f"Unverified API declaration: {e['id']}")
        require(len(e["declarations"]) == len(set(e["declarations"])), "Repeated declaration")
        require(e["status"] != "formalized" or bool(e["declarations"]), "Formalized entry needs API evidence")
        require(e["status"] != "fixture" or bool(e.get("evidence")), "Fixture needs exact source evidence")
        seen = set()
        for d in e["depends"]:
            require(d["id"] in ids and d["id"] != e["id"], f"Unknown/self dependency: {e['id']}")
            require(d["type"] in {"statement", "proof"} and bool(d["why"].strip()), "Invalid dependency type/rationale")
            require((d["id"], d["type"]) not in seen, "Repeated dependency")
            seen.add((d["id"], d["type"]))
    ranks(entries)  # Reject cycles, including vocabulary/proof mixed cycles.


def ranks(entries):
    by_id = {e["id"]: e for e in entries}
    result, active = {}, set()
    def visit(identity):
        require(identity not in active, "Cyclic blueprint dependencies")
        if identity not in result:
            active.add(identity)
            result[identity] = max((visit(d["id"]) + 1 for d in by_id[identity]["depends"] if d["id"] in by_id), default=0)
            active.remove(identity)
        return result[identity]
    for identity in by_id:
        visit(identity)
    return result


def evidence_links(entries, api, root=ROOT):
    result, contents = set(), {}
    for e in entries:
        for item in e.get("evidence", []):
            path, line, needle = item["file"], item["line"], item["needle"]
            require(re.fullmatch(r"PerfectFunctionalRepresentations/[A-Za-z0-9_/]+\.lean", path)
                    or path == "docs/pfr-c16-coverage-audit.md", "Invalid fixture path")
            require(type(line) is int and line > 0 and bool(needle.strip()), "Invalid fixture anchor")
            if path not in contents:
                proc = subprocess.run(["git", "show", f"{api['source_commit']}:{path}"], cwd=root,
                                      text=True, encoding="utf-8", capture_output=True, check=True)
                contents[path] = proc.stdout.splitlines()
            require(line <= len(contents[path]) and needle in contents[path][line - 1], f"Fixture anchor drift: {path}:{line}")
            result.add(f"{api['repository']}/blob/{api['source_commit']}/{path}#L{line}")
    return result


def check_blueprint_source_links(site, hrefs, root=ROOT):
    if not (root / "tools/blueprint/semantics.json").exists():
        return set()
    entries, api = load_entries(root), api_data(root)
    validate(entries, api)
    expected = evidence_links(entries, api, root)
    require(expected <= hrefs, "Blueprint fixture anchor missing from published HTML")
    return expected


def source_links(e, api):
    by_name = {d["name"]: d for d in api["declarations"]}
    links = []
    for name in e["declarations"]:
        d = by_name[name]
        short = name.removeprefix("PerfectFunctionalRepresentations.")
        links.append(f'<li><a class="bp-declaration" href="../api/{esc(d["page"])}#{esc(name)}">{esc(short)}</a> '
                     f'<a class="small" href="{esc(d["source_url"])}">Source ↗</a></li>')
    for item in e.get("evidence", []):
        url = f'{api["repository"]}/blob/{api["source_commit"]}/{item["file"]}#L{item["line"]}'
        kind = 'private fixture' if item['file'].endswith('.lean') else 'coverage record'
        links.append(f'<li><a href="{esc(url)}">{esc(item["label"])} ↗</a> <span class="small">({kind})</span></li>')
    if not links:
        links.append(f'<li><a href="{api["repository"]}/blob/{api["source_commit"]}/docs/pfr-c16-coverage-audit.md">Coverage ledger and omission rationale ↗</a></li>')
    return '<ul class="bp-sources">' + "".join(links) + '</ul>'


def deps_html(e, by_id, graph=False):
    prefix = "index.html" if graph else ""
    parts = []
    for d in e["depends"]:
        other = by_id[d["id"]]
        kind = "Statement vocabulary" if d["type"] == "statement" else "Proof ingredient"
        parts.append(f'<li><span class="bp-edge-kind">{kind}</span> '
                     f'<a href="{prefix}#{other["id"]}">{esc(other["label"])} · {esc(other["title"])}</a>: {esc(d["why"])}</li>')
    return '<ul class="bp-dependencies">' + "".join(parts) + '</ul>' if parts else '<p class="small">No earlier project result is selected as a prerequisite in this graph.</p>'


def card(e, entries, api):
    identity = e["id"]
    aliases = ''.join(f'<span id="{a}" class="anchor-alias"></span>' for a, target in ALIASES.items() if target == identity)
    proof = f'<details class="bp-proof"><summary>Proof idea</summary>{e["proof_html"]}</details>' if e["proof_html"] else ''
    consumers = [x for x in entries if any(d["id"] == identity for d in x["depends"])]
    used = ', '.join(f'<a href="#{x["id"]}">{esc(x["label"])} · {esc(x["title"])}</a>' for x in consumers)
    by_id = {x["id"]: x for x in entries}
    return f'''{aliases}<article class="bp-entry bp-{e['kind']}" id="{identity}" aria-labelledby="title-{identity}">
<header><p class="bp-kicker">{esc(e['paper'])}<span class="bp-status status-{e['status']}">{STATUS[e['status']]}</span></p>
<h3 id="title-{identity}"><a class="bp-permalink" href="#{identity}" aria-label="Permanent link to {esc(e['label'])}">#</a> <strong>{esc(e['label'])}.</strong> {esc(e['title'])}</h3></header>
<div class="bp-statement">{e['statement_html']}</div>
<div class="bp-qualification">{e['qualifier_html']}</div>{proof}
<details><summary>Lean declarations and evidence</summary>{source_links(e, api)}</details>
<details><summary>Dependencies and uses</summary>{deps_html(e, by_id)}
<p class="small"><strong>Used by:</strong> {used or 'No later result selected in this graph.'}</p></details>
<p class="bp-graph-link"><a href="dep_graph_document.html#all-{identity}">Locate in dependency graph →</a></p>
</article>'''


def subnav(current):
    items = [('index.html', 'Statements'), ('dep_graph_document.html', 'Dependency graph'), ('guide.html', 'How the ideas connect')]
    return '<nav class="subnav" aria-label="Blueprint navigation">' + ''.join(
        f'<a href="{url}"' + (' aria-current="page"' if url == current else '') + f'>{label}</a>' for url, label in items) + '</nav>'


def index_page(entries, api, manifest):
    toc, body = [], []
    for section, title in SECTIONS.items():
        part = [e for e in entries if e["section"] == section]
        toc.append(f'<li><a href="#{section}">{esc(title)}</a><ul>' + ''.join(
            f'<li><a href="#{e["id"]}">{esc(e["label"])} · {esc(e["title"])}</a></li>' for e in part) + '</ul></li>')
        body.append(f'<section id="{section}" class="bp-section"><h2>{esc(title)}</h2>' + ''.join(card(e, entries, api) for e in part) + '</section>')
    anchors = ''.join(f'<li><a href="{manifest["repository"]}/blob/{manifest["commit"]}/{x["file"]}#L{x["line"]}">{esc(x["label"])}</a></li>' for x in manifest['entries'])
    return f'''<main id="main" class="wrap blueprint-wrap">
<div class="page-intro"><h1>Mathematical blueprint</h1><p class="lead">The definitions, lemmas, theorems and examples, one statement at a time. Read a proof idea, inspect its Lean contract, or trace the prerequisites in the graph.</p></div>
{subnav('index.html')}
<div class="note"><p>Numbering follows the six-page ISIT 2026 paper. These are original, source-linked explanations, not a reproduction of the manuscript. <strong>Formalized</strong> means the precise contract described here; <strong>Checked fixture</strong> means a private verified example, not a public API theorem. Assumptions and intentional omissions remain visible.</p></div>
<p id="dependency-guide" class="small">Looking for the overview? Read <a href="guide.html">how the ideas connect</a>. For all implementation declarations, use the <a href="../api/index.html">Lean API</a>.</p>
<p class="bp-conventions"><strong>Conventions.</strong> Information is measured in nats. Information-theoretic statements use finite value alphabets; the underlying probability source may be infinite. Channel predicates are prior-free. PPS/PPM/VPS/VPM denote the four column operations defined below.</p>
<div class="bp-layout"><aside class="bp-sidebar"><details open><summary>Contents · {len(entries)} entries</summary><nav aria-label="Statement contents"><ol>{''.join(toc)}<li><a href="#scope">Scope and provenance</a></li></ol></nav></details></aside>
<div class="bp-document">{''.join(body)}
<section id="scope" class="bp-section"><h2>Scope and provenance</h2>
<p>The target is the six-page ISIT 2026 paper. This blueprint covers that paper's numbered definitions, lemmas, theorems, corollary and examples, with the two remarks distinguished from new theorem claims. The extended companion supplied omitted proofs; only selected sections of its newer version have been compared. This is not complete coverage of the extended draft or of cited literature.</p>
<p>Finite-auxiliary limits, prior support, the corrected full/reduced LP indexing, and the normalization proof are explained in <a href="../discussion.html">Discussion</a>. The <a href="{api['repository']}/blob/{api['source_commit']}/docs/pfr-c16-coverage-audit.md">coverage ledger</a> records the full internal disposition history. Supporting entries here are selected mathematical units, not every implementation helper.</p>
<p>The structure follows the conventions of <a href="https://github.com/PatrickMassot/leanblueprint">Lean Blueprint</a>, using PFR's own static renderer and visual design. Graph edges are curated mathematical dependencies, not compiler-extracted calls; declaration links are checked against the compiler-backed API inventory.</p>
<details><summary>Verified source anchor index</summary><ul class="bp-sources">{anchors}</ul></details>
<p class="provenance">Source snapshot: <code>{api['source_commit']}</code>. LeanInfoTheory remains pinned to v0.1.0. The prose and graph are reviewed exposition, not an additional machine-checked proof.</p></section>
</div></div></main>'''


def subset(entries, sections):
    ids = {e['id'] for e in entries if e['section'] in sections}
    while True:
        expanded = ids | {d['id'] for e in entries if e['id'] in ids for d in e['depends']}
        if expanded == ids:
            return [e for e in entries if e['id'] in ids]
        ids = expanded


def graph_svg(entries, view, sections):
    """Layered DAG layout; long edges use outer lanes, never pass through nodes."""
    levels = ranks(entries)
    layers = defaultdict(list)
    for e in entries:
        layers[levels[e['id']]].append(e)
    # Stable barycentric sweeps reduce crossings without an external Graphviz runtime.
    order = {e['id']: i for row in layers.values() for i, e in enumerate(row)}
    for level in sorted(layers):
        layers[level].sort(key=lambda e: sum(order[d['id']] for d in e['depends']) / max(1, len(e['depends'])) if e['depends'] else order[e['id']])
        order.update({e['id']: i for i, e in enumerate(layers[level])})
    node_w, node_h, gap_x, gap_y = 226, 92, 38, 96
    columns = min(4, max(map(len, layers.values())))
    content_w = columns * (node_w + gap_x) - gap_x
    width = content_w + 230
    bands = sum((len(row) + columns - 1) // columns for row in layers.values())
    height = bands * (node_h + gap_y) + 40
    positions = {}
    band = 0
    for level in sorted(layers):
        row = layers[level]
        for i, e in enumerate(row):
            row_size = min(columns, len(row) - (i // columns) * columns)
            offset = 30 + (content_w - (row_size * (node_w + gap_x) - gap_x)) / 2
            positions[e['id']] = (offset + (i % columns) * (node_w + gap_x), 28 + (band + i // columns) * (node_h + gap_y))
        band += (len(row) + columns - 1) // columns
    edges, nodes = [], []
    lane = 0
    for e in entries:
        x2, y2 = positions[e['id']]
        for d in e['depends']:
            x1, y1 = positions[d['id']]
            start, end = (x1 + node_w / 2, y1 + node_h), (x2 + node_w / 2, y2)
            if end[1] - start[1] == gap_y:
                middle = (start[1] + end[1]) / 2
                path = f'M {start[0]} {start[1]} C {start[0]} {middle}, {end[0]} {middle}, {end[0]} {end[1]}'
            else:
                outside = content_w + 60 + (lane % 19) * 7
                lane += 1
                path = f'M {start[0]} {start[1]} V {start[1]+22} H {outside} V {end[1]-26} H {end[0]} V {end[1]}'
            edges.append(f'<path class="graph-edge edge-{d["type"]}" data-from="{d["id"]}" data-to="{e["id"]}" d="{path}" marker-end="url(#{view}-arrow-{d["type"]})"><title>{esc(d["why"])}</title></path>')
        title_lines = textwrap.wrap(e['title'], 27)[:3]
        text = ''.join(f'<tspan x="{x2+node_w/2}" dy="17">{esc(line)}</tspan>' for line in title_lines)
        graph_label = e['label'].split(' · ')[0]
        graph_label = {'Definition and equality criterion': 'Definition / criterion',
                       'Supporting definitions and lemma': 'Incidence definitions',
                       'Supporting characterization': 'Characterization',
                       'Four operation definitions': 'Operation definitions',
                       'Remark 1 and supporting bridge': 'Remark 1 / bridge'}.get(graph_label, graph_label)
        graph_label = {'formalized': '✓ ', 'fixture': '◇ ', 'not-formalized': '— '}[e['status']] + graph_label
        radius = 3 if e['kind'] == 'definition' else 22
        context = ' graph-context' if e['section'] not in sections else ''
        nodes.append(f'<a id="{view}-{e["id"]}" class="graph-node status-{e["status"]}{context}" data-entry="{e["id"]}" data-deps="{esc(" ".join(d["id"] for d in e["depends"]))}" href="index.html#{e["id"]}" aria-label="{esc(e["label"]+": "+e["title"])}"><title>{esc(e["label"])}: {esc(e["title"])} — {STATUS[e["status"]]}</title><rect x="{x2}" y="{y2}" width="{node_w}" height="{node_h}" rx="{radius}"/><text class="graph-label" x="{x2+node_w/2}" y="{y2+23}">{esc(graph_label)}</text><text x="{x2+node_w/2}" y="{y2+30}">{text}</text></a>')
    markers = ''.join(f'<marker id="{view}-arrow-{kind}" markerWidth="8" markerHeight="8" refX="7" refY="4" orient="auto"><path d="M0,0 L8,4 L0,8 Z" fill="{color}"/></marker>' for kind, color in [('proof','#398164'),('statement','#6c8aa8')])
    return f'<svg class="dependency-svg" xmlns="http://www.w3.org/2000/svg" width="{width}" height="{height}" viewBox="0 0 {width} {height}" role="group" aria-label="Directed dependencies: {esc(VIEWS[view][0])}"><defs>{markers}</defs>{"".join(edges)}{"".join(nodes)}</svg>'


def graph_page(entries, api):
    options = ''.join(f'<option value="{key}">{esc(label)}</option>' for key, (label, _) in VIEWS.items())
    nodes = ''.join(f'<option value="{e["id"]}">{esc(e["label"])} · {esc(e["title"])}</option>' for e in entries)
    graphs = ''.join(f'<div class="graph-view" data-view="{key}"' + (' hidden' if key != 'all' else '') + f'>{graph_svg(subset(entries, sections), key, sections)}</div>' for key, (_, sections) in VIEWS.items())
    templates = ''.join(f'<template id="preview-{e["id"]}"><p class="label">{STATUS[e["status"]]} · {esc(e["paper"])}</p><h3>{esc(e["label"])}. {esc(e["title"])}</h3>{e["statement_html"]}<div class="bp-qualification">{e["qualifier_html"]}</div><p><a href="index.html#{e["id"]}">Read this entry and its proof idea →</a></p><details><summary>Lean evidence</summary>{source_links(e, api)}</details></template>' for e in entries)
    by_id = {e['id']: e for e in entries}
    listing = ''.join(f'<details><summary>{esc(e["label"])} · {esc(e["title"])}</summary>{deps_html(e, by_id, graph=True)}</details>' for e in entries)
    return f'''<main id="main" class="wrap graph-wrap"><div class="page-intro"><h1>Dependency graph</h1><p class="lead">Follow the prerequisites from independent randomness to constructive and linear-programming characterizations.</p></div>{subnav('dep_graph_document.html')}
<p>Arrows run <strong>from prerequisite to dependent result</strong>. Solid green edges identify proof ingredients; dashed blue edges identify statement vocabulary. An edge may support one part of a bundled entry. This is a selected, source-audited mathematical graph—not a module-import graph or an automatically extracted Lean proof graph.</p>
<div class="graph-legend"><span><i class="legend-proof" aria-hidden="true"></i>Proof ingredient</span><span><i class="legend-statement" aria-hidden="true"></i>Statement vocabulary</span><span>Square corners: definition · Rounded: result</span><span>✓ Formalized · ◇ Checked fixture · — Cited context</span></div>
<div class="graph-controls" hidden><label>View <select id="graph-view">{options}</select></label><label>Locate an entry <select id="graph-entry"><option value="">Choose a statement…</option>{nodes}</select></label><div class="graph-zoom"><button id="zoom-out" type="button" aria-label="Zoom out">−</button><button id="zoom-in" type="button" aria-label="Zoom in">+</button><button id="zoom-fit" type="button">Fit width</button><button id="zoom-readable" type="button">Readable size</button><button id="graph-reset" type="button">Reset</button><output id="zoom-label" aria-live="polite">100%</output></div></div>
<p class="small" id="graph-help">Scroll to explore; follow a node to its statement. With JavaScript, select a node for a preview, use the view selector to focus a topic, or zoom with the buttons. Drag empty canvas space to pan. Keyboard: Tab to nodes, Enter to preview; the canvas supports arrow-key scrolling.</p>
<div class="graph-layout"><div id="graph-canvas" class="graph-canvas" tabindex="0" role="region" aria-label="Scrollable dependency graph" aria-describedby="graph-help">{graphs}</div><aside id="graph-preview" class="graph-preview" aria-live="polite"><h2>Explore a statement</h2><p>Select a node to read its statement and reveal its immediate prerequisites and uses. Use the full entry for proof ideas and exact Lean links.</p><p class="small">Topic views include prerequisite context. Muted nodes come from earlier sections.</p></aside></div>
{templates}
<div class="note graph-note"><p><strong>Why Lemma 4 is not on every path.</strong> The paper uses normal form to explain the partition-mixture picture. Lean proves Lemma 4 separately: Theorem 1 constructs its stages directly, and LP necessity extracts weights from decoder fibres. Accordingly, the graph adds no false Lemma 4 → Theorem 1 or Lemma 4 → LP proof edge. See <a href="guide.html">the argument guide</a>.</p></div>
<details class="graph-text"><summary>Text version: all entries and their direct dependencies</summary><p>Every arrow's rationale is recorded below. This list and the linked statement pages also work without JavaScript.</p>{listing}</details>
<p class="provenance">Curated dependencies against source snapshot <code>{api['source_commit']}</code>; precise API contracts remain authoritative. This graph records the selected Lean proof routes, not every possible mathematical proof.</p></main>'''


def render(root=ROOT):
    entries, api = load_entries(root), api_data(root)
    validate(entries, api)
    evidence_links(entries, api, root)
    # Keep publication order separate from graph's topological layout.
    entries.sort(key=lambda e: (list(SECTIONS).index(e['section']), e.get('order', 0)))
    template = (root / 'tools/blueprint/page.html').read_text(encoding='utf-8')
    manifest = json.loads((root / 'site/source-links.json').read_text(encoding='utf-8'))
    guide = (root / 'tools/blueprint/guide.html').read_text(encoding='utf-8')
    pages = {
        'index.html': ('Mathematical blueprint', index_page(entries, api, manifest)),
        'dep_graph_document.html': ('Dependency graph', graph_page(entries, api)),
        'guide.html': ('How the ideas connect', '<main id="main" class="wrap"><h1>How the ideas connect</h1>' + subnav('guide.html') + guide + '</main>'),
    }
    return {root / 'site/blueprint' / name: template.replace('{{TITLE}}', title).replace('{{CANONICAL}}', 'https://serhatemrecoban.github.io/PerfectFunctionalRepresentationsLean/blueprint/' + ('' if name == 'index.html' else name)).replace('{{MAIN}}', body) for name, (title, body) in pages.items()}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--check', action='store_true')
    args = parser.parse_args()
    output = render()
    for path, value in output.items():
        if args.check:
            require(path.exists() and path.read_text(encoding='utf-8') == value, f'Stale generated blueprint: {path.name}')
        else:
            path.write_text(value, encoding='utf-8', newline='\n')
    print(f'Blueprint {"checked" if args.check else "rendered"}: {len(load_entries())} entries, {len(output)} pages; declaration and fixture anchors verified.')


if __name__ == '__main__':
    main()
