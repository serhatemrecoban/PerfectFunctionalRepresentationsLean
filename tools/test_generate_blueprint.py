"""Model-free checks for curated blueprint validation, rendering and DAG views.

Synthetic cases exercise refusal boundaries. Repository cases additionally check
the real declaration inventory and evidence anchors at its pinned source commit;
these tests do not establish that the authored prose is mathematically equivalent
to a Lean contract.
"""
import copy
from collections import Counter
from html.parser import HTMLParser
from pathlib import Path
import subprocess
import unittest
from unittest.mock import patch
import xml.etree.ElementTree as ET

import generate_blueprint as blueprint


DECLARATION = "PerfectFunctionalRepresentations.fixture"
FIXTURE = "PerfectFunctionalRepresentations/Tests/Examples/Fixture.lean"


def entry(identity="foundation", section="foundations", depends=()):
    return {
        "id": identity, "section": section, "label": "Definition 1",
        "title": "A small fixture", "kind": "definition", "status": "formalized",
        "paper": "Synthetic test only", "statement_html": "<p>A statement.</p>",
        "proof_html": "<p>A proof idea.</p>", "qualifier_html": "",
        "declarations": [DECLARATION], "evidence": [],
        "depends": [{"id": other, "type": kind, "why": "A test prerequisite."}
                    for other, kind in depends],
    }


class MarkupIndex(HTMLParser):
    def __init__(self, source):
        super().__init__()
        self.ids = []
        self.articles = []
        self.hrefs = []
        self.graph_nodes = []
        self.feed(source)

    def handle_starttag(self, tag, attributes):
        attrs = dict(attributes)
        if "id" in attrs:
            self.ids.append(attrs["id"])
        if tag == "article":
            self.articles.append(attrs.get("id"))
        if "href" in attrs:
            self.hrefs.append(attrs["href"])
        if "graph-node" in attrs.get("class", "").split():
            self.graph_nodes.append(attrs)


class BlueprintValidationTests(unittest.TestCase):
    def setUp(self):
        self.api = {
            "source_commit": "1234567890abcdef", "repository": "https://example.test/pfr",
            "declarations": [{"name": DECLARATION, "page": "Fixture.html",
                              "source_url": "https://example.test/pfr/blob/1234567890abcdef/Fixture.lean#L2"}],
        }

    def test_valid_synthetic_registry(self):
        first = entry()
        second = entry("consumer", "dual", [("foundation", "statement")])
        second["depends"].append({"id": "foundation", "type": "proof", "why": "Also used in the proof."})
        blueprint.validate([first, second], self.api)
        self.assertEqual(blueprint.ranks([first, second]), {"foundation": 0, "consumer": 1})

    def test_empty_registry_rejected(self):
        with self.assertRaisesRegex(ValueError, "Empty blueprint"):
            blueprint.validate([], self.api)

    def test_duplicate_ids_rejected(self):
        with self.assertRaisesRegex(ValueError, "Duplicate blueprint id"):
            blueprint.validate([entry(), entry()], self.api)

    def test_unknown_and_self_dependencies_rejected(self):
        for identity in ("unknown", "foundation"):
            with self.subTest(identity=identity), self.assertRaisesRegex(ValueError, "Unknown/self dependency"):
                blueprint.validate([entry(depends=[(identity, "proof")])], self.api)

    def test_repeated_dependency_rejected(self):
        consumer = entry("consumer", depends=[("foundation", "proof"), ("foundation", "proof")])
        with self.assertRaisesRegex(ValueError, "Repeated dependency"):
            blueprint.validate([entry(), consumer], self.api)

    def test_cycles_rejected_including_mixed_edge_types(self):
        for kinds in (("proof", "proof"), ("statement", "statement"), ("proof", "statement")):
            with self.subTest(kinds=kinds), self.assertRaisesRegex(ValueError, "Cyclic blueprint"):
                blueprint.validate([entry("first", depends=[("second", kinds[0])]),
                                    entry("second", depends=[("first", kinds[1])])], self.api)
        with self.assertRaisesRegex(ValueError, "Cyclic blueprint"):
            blueprint.validate([entry("first", depends=[("third", "statement")]),
                                entry("second", depends=[("first", "proof")]),
                                entry("third", depends=[("second", "proof")])], self.api)

    def test_invalid_or_reserved_ids_rejected(self):
        for identity in ("Bad", "bad id", "bad\"id", "foundations", "lemma-2"):
            with self.subTest(identity=identity), self.assertRaises(ValueError):
                blueprint.validate([entry(identity)], self.api)

    def test_unverified_and_repeated_declarations_rejected(self):
        for names in (["PerfectFunctionalRepresentations.invented"], [DECLARATION, DECLARATION]):
            candidate = entry()
            candidate["declarations"] = names
            with self.subTest(names=names), self.assertRaises(ValueError):
                blueprint.validate([candidate], self.api)

    def test_formalized_status_requires_public_api_evidence(self):
        candidate = entry()
        candidate["declarations"] = []
        candidate["evidence"] = [{"file": FIXTURE, "line": 2, "needle": "fixture", "label": "Private fixture"}]
        with self.assertRaisesRegex(ValueError, "Formalized entry needs API evidence"):
            blueprint.validate([candidate], self.api)

    def test_fixture_status_requires_exact_source_evidence(self):
        candidate = entry()
        candidate["status"] = "fixture"
        candidate["declarations"] = []
        with self.assertRaisesRegex(ValueError, "Fixture needs exact source evidence"):
            blueprint.validate([candidate], self.api)

    def test_context_entry_can_explicitly_lack_formalized_evidence(self):
        candidate = entry()
        candidate.update(status="not-formalized", declarations=[], proof_html="")
        blueprint.validate([candidate], self.api)

    def test_invalid_status_kind_and_section_rejected(self):
        for key, values in {"status": ("proved", "", None),
                            "kind": ("arbitrary", "", None),
                            "section": ("unpublished", "", None)}.items():
            for value in values:
                candidate = entry()
                candidate[key] = value
                with self.subTest(key=key, value=value), self.assertRaises(ValueError):
                    blueprint.validate([candidate], self.api)

    def test_invalid_dependency_type_or_rationale_rejected(self):
        for kind, why in (("import", "A reason"), ("", "A reason"),
                          (None, "A reason"), ("proof", "  ")):
            consumer = entry("consumer", depends=[("foundation", "proof")])
            consumer["depends"][0].update(type=kind, why=why)
            with self.subTest(kind=kind, why=why), self.assertRaises(ValueError):
                blueprint.validate([entry(), consumer], self.api)

    def test_required_text_cannot_be_blank_or_nontext(self):
        for key in ("label", "title", "paper", "statement_html"):
            for value in ("  ", None, 17):
                candidate = entry()
                candidate[key] = value
                with self.subTest(key=key, value=value), self.assertRaises(ValueError):
                    blueprint.validate([candidate], self.api)

    def test_safe_prose_and_relative_links_allowed(self):
        candidate = entry()
        candidate["statement_html"] = ('<p class="formula">H(X<sub>1</sub>) &ge; 0. '
                                       '<a href="#foundation">Here</a> '
                                       '<a href="../discussion.html#limitations">Scope</a><br>'
                                       'Another line.<br/>Final line.</p>')
        blueprint.validate([candidate], self.api)

    def test_active_html_and_nonlocal_links_rejected_in_all_fragments(self):
        payloads = (
            '<script>alert(1)</script>', '<iframe src="https://example.test"></iframe>',
            '<img src="x" onerror="alert(1)">', '<p onclick="alert(1)">Text</p>',
            '<a href="javascript:alert(1)">Bad</a>',
            '<a href="HTTPS://example.test">External</a>', '<a href="//example.test">External</a>',
            '<a href=" javascript:alert(1)">Bad</a>',
            '<a href="java&#x09;script:alert(1)">Bad</a>',
            '<a href="&#10;//example.test">External</a>',
        )
        for field in ("statement_html", "proof_html", "qualifier_html"):
            for payload in payloads:
                candidate = entry()
                candidate[field] = payload
                with self.subTest(field=field, payload=payload), self.assertRaises(ValueError):
                    blueprint.validate([candidate], self.api)

    def test_incomplete_active_fragments_rejected_before_wrapping(self):
        # A browser completes an unfinished tag with the renderer's closing div.
        # The trailing JS comment makes this a working handler, not merely bad HTML.
        payloads = ('<img src=x onerror=window.__blueprintProbe=1//', '<script', '<!--')
        for field in ("statement_html", "proof_html", "qualifier_html"):
            for payload in payloads:
                candidate = entry()
                candidate[field] = payload
                with self.subTest(field=field, payload=payload), self.assertRaises(ValueError):
                    blueprint.validate([candidate], self.api)

    def test_unbalanced_and_escaping_end_tags_rejected(self):
        payloads = ('</div><p>Escaped wrapper.</p>', '<p>Unclosed paragraph.',
                    '<p><strong>Wrong nesting.</p></strong>', '</template>',
                    '<p>Closed.</p></article>', '<p>Text.</p></br>')
        for payload in payloads:
            candidate = entry()
            candidate["statement_html"] = payload
            with self.subTest(payload=payload), self.assertRaises(ValueError):
                blueprint.validate([candidate], self.api)

    def evidence_entry(self, **changes):
        candidate = entry()
        item = {"file": FIXTURE, "line": 2, "needle": "private theorem fixture", "label": "Test fixture"}
        item.update(changes)
        candidate.update(status="fixture", declarations=[], evidence=[item])
        return candidate

    def test_fixture_anchor_uses_pinned_snapshot_and_caches_source(self):
        candidate = self.evidence_entry()
        second = copy.deepcopy(candidate)
        second["id"] = "another"
        response = subprocess.CompletedProcess([], 0, "namespace Test\nprivate theorem fixture : True := by trivial\n")
        with patch.object(blueprint.subprocess, "run", return_value=response) as run:
            links = blueprint.evidence_links([candidate, second], self.api, Path("test-root"))
        self.assertEqual(links, {f"{self.api['repository']}/blob/{self.api['source_commit']}/{FIXTURE}#L2"})
        run.assert_called_once_with(["git", "show", f"{self.api['source_commit']}:{FIXTURE}"],
                                    cwd=Path("test-root"), text=True, encoding="utf-8", capture_output=True, check=True)

    def test_invalid_fixture_paths_rejected_before_git(self):
        paths = ("../Fixture.lean", "/Fixture.lean", "C:/Fixture.lean",
                 "PerfectFunctionalRepresentations/../Fixture.lean",
                 "PerfectFunctionalRepresentations\\Fixture.lean",
                 "https://example.test/Fixture.lean", "PerfectFunctionalRepresentations/Fixture.py")
        for path in paths:
            with self.subTest(path=path), patch.object(blueprint.subprocess, "run") as run:
                with self.assertRaisesRegex(ValueError, "Invalid fixture path"):
                    blueprint.evidence_links([self.evidence_entry(file=path)], self.api)
                run.assert_not_called()

    def test_invalid_fixture_anchor_rejected_before_git(self):
        for changes in ({"line": 0}, {"line": -1}, {"line": True}, {"line": "2"}, {"needle": "  "}):
            with self.subTest(changes=changes), patch.object(blueprint.subprocess, "run") as run:
                with self.assertRaisesRegex(ValueError, "Invalid fixture anchor"):
                    blueprint.evidence_links([self.evidence_entry(**changes)], self.api)
                run.assert_not_called()

    def test_missing_or_drifted_source_anchor_rejected(self):
        response = subprocess.CompletedProcess([], 0, "namespace Test\nprivate theorem different : True := by trivial\n")
        for changes in ({}, {"line": 30}):
            with self.subTest(changes=changes), patch.object(blueprint.subprocess, "run", return_value=response):
                with self.assertRaisesRegex(ValueError, "Fixture anchor drift"):
                    blueprint.evidence_links([self.evidence_entry(**changes)], self.api)

    def test_missing_pinned_source_is_not_silently_accepted(self):
        error = subprocess.CalledProcessError(128, ["git", "show"], stderr="Missing source")
        with patch.object(blueprint.subprocess, "run", side_effect=error), self.assertRaises(subprocess.CalledProcessError):
            blueprint.evidence_links([self.evidence_entry()], self.api)

    def test_subset_includes_transitive_ancestors_and_preserves_order(self):
        entries = [entry("root"), entry("unrelated", "channels"),
                   entry("bridge", "operations", [("root", "statement")]),
                   entry("target", "dual", [("bridge", "proof")])]
        original = copy.deepcopy(entries)
        self.assertEqual([e["id"] for e in blueprint.subset(entries, {"dual"})], ["root", "bridge", "target"])
        self.assertEqual(blueprint.subset(entries, set()), [])
        self.assertEqual(entries, original)

    def test_graph_places_prerequisites_above_consumers_regardless_of_entry_order(self):
        entries = [entry("consumer", "dual", [("root", "proof")]), entry("root")]
        blueprint.validate(entries, self.api)
        svg = ET.fromstring(blueprint.graph_svg(entries, "all", set(blueprint.SECTIONS)))
        namespace = {"svg": "http://www.w3.org/2000/svg"}
        rectangles = {node.attrib["data-entry"]: node.find("svg:rect", namespace).attrib
                      for node in svg.findall("svg:a", namespace)}
        self.assertLess(float(rectangles["root"]["y"]) + float(rectangles["root"]["height"]),
                        float(rectangles["consumer"]["y"]))


class RepositoryBlueprintTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.entries = blueprint.load_entries()
        cls.api = blueprint.api_data()

    def test_whole_registry_validates_against_actual_api(self):
        blueprint.validate(self.entries, self.api)

    def test_whole_registry_evidence_matches_pinned_source(self):
        actual = blueprint.evidence_links(self.entries, self.api)
        expected = {f"{self.api['repository']}/blob/{self.api['source_commit']}/{item['file']}#L{item['line']}"
                    for e in self.entries for item in e.get("evidence", [])}
        self.assertTrue(expected)
        self.assertEqual(actual, expected)

    def test_all_numbered_paper_items_have_entries(self):
        ids = {e["id"] for e in self.entries}
        expected = {f"definition-{n}" for n in range(1, 5)}
        expected |= {"lemma-1", "lemma-2-necessary", "lemma-2-input", "lemma-2-output",
                     "lemma-3-optimum", "lemma-3-equality", "lemma-4", "lemma-5", "lemma-6"}
        expected |= {"theorem-1", "theorem-2", "corollary-1", "prior-bridge", "remark-2"}
        expected |= {f"example-{n}" for n in range(1, 8)}
        self.assertTrue(expected <= ids, f"Missing numbered paper entries: {expected - ids}")

    def test_every_topic_graph_is_ancestor_closed(self):
        for view, (_, sections) in blueprint.VIEWS.items():
            with self.subTest(view=view):
                selected = blueprint.subset(self.entries, sections)
                ids = {e["id"] for e in selected}
                self.assertTrue({e["id"] for e in self.entries if e["section"] in sections} <= ids)
                for e in selected:
                    self.assertTrue({d["id"] for d in e["depends"]} <= ids)
                blueprint.validate(selected, self.api)

    def test_render_is_deterministic_and_every_entry_is_linked(self):
        original = copy.deepcopy(self.entries)
        first = blueprint.render()
        second = blueprint.render()
        self.assertEqual(first, second)
        self.assertEqual(self.entries, original)
        self.assertEqual({path.name for path in first}, {"index.html", "dep_graph_document.html", "guide.html"})
        documents = {path.name: MarkupIndex(source) for path, source in first.items()}
        ids = {e["id"] for e in self.entries}
        self.assertEqual(Counter(documents["index.html"].articles), Counter(ids))
        for page, document in documents.items():
            with self.subTest(page=page):
                self.assertEqual(len(document.ids), len(set(document.ids)), "Repeated HTML id")
        for identity in ids:
            self.assertIn(f"dep_graph_document.html#all-{identity}", documents["index.html"].hrefs)
            self.assertIn(f"index.html#{identity}", documents["dep_graph_document.html"].hrefs)
        for alias, target in blueprint.ALIASES.items():
            self.assertIn(alias, documents["index.html"].ids)
            self.assertIn(target, ids)
        for source in first.values():
            self.assertNotIn("{{TITLE}}", source)
            self.assertNotIn("{{CANONICAL}}", source)
            self.assertNotIn("{{MAIN}}", source)

    def test_graph_nodes_match_topic_subset_and_link_to_statements(self):
        for view, (_, sections) in blueprint.VIEWS.items():
            selected = blueprint.subset(self.entries, sections)
            source = blueprint.graph_svg(selected, view, sections)
            with self.subTest(view=view):
                self.assertEqual(source, blueprint.graph_svg(selected, view, sections))
                document = MarkupIndex(source)
                self.assertEqual({node["data-entry"] for node in document.graph_nodes}, {e["id"] for e in selected})
                for node in document.graph_nodes:
                    self.assertEqual(node["id"], f"{view}-{node['data-entry']}")
                    self.assertEqual(node["href"], f"index.html#{node['data-entry']}")

    def test_graph_zoom_controls_and_mouse_help_are_published(self):
        source = blueprint.graph_page(self.entries, self.api)
        self.assertIn('class="graph-controls" hidden', source)
        self.assertIn('aria-label="Graph zoom controls"', source)
        self.assertIn('aria-controls="graph-canvas">− Zoom out</button>', source)
        self.assertIn('aria-controls="graph-canvas">+ Zoom in</button>', source)
        self.assertIn('aria-label="Graph zoom" aria-live="polite"', source)
        self.assertIn('mouse wheel over the graph', source)
        self.assertIn('hold Shift', source)
        self.assertIn('Without JavaScript, the graph remains scrollable', source)


if __name__ == "__main__":
    unittest.main()
