"""Model-free regression tests for the source-preserving website link policy."""

from contextlib import redirect_stdout
from html.parser import HTMLParser
from io import StringIO
from pathlib import Path
import tempfile
import unittest
from unittest.mock import patch

import website_links as policy


class Anchors(HTMLParser):
    def __init__(self, source: str) -> None:
        super().__init__()
        self.anchors: list[dict[str, str | None]] = []
        self.feed(source)

    def handle_starttag(self, tag, attrs):
        if tag == "a":
            self.anchors.append(dict(attrs))


def document(content: str) -> str:
    return f"<!doctype html>\n<html><head><title>Test</title></head><body>{content}</body></html>"


class LinkPolicyTests(unittest.TestCase):
    def transform(self, content: str) -> tuple[str, list[dict[str, str | None]]]:
        result = policy.apply_link_policy(document(content))
        return result, Anchors(result).anchors

    def assert_resource(self, attrs):
        self.assertEqual(attrs["target"], "_blank")
        self.assertTrue({"noopener", "noreferrer"}.issubset(attrs["rel"].split()))
        self.assertIn(policy.HINT_TEXT, attrs["title"])
        self.assertIn(policy.HINT_ID, attrs["aria-describedby"].split())

    def test_external_resource(self):
        output, anchors = self.transform('<a href="https://example.org/paper">Paper</a>')
        self.assert_resource(anchors[0])
        self.assertIn(policy.HINT_HTML + "</body>", output)
        self.assertEqual(output.count(f'id="{policy.HINT_ID}"'), 1)

    def test_internal_content_pages_and_declarations(self):
        _, anchors = self.transform('<a href="api/index.html">API</a><a href="Module.html#Theorem">Theorem</a>')
        for attrs in anchors:
            self.assert_resource(attrs)

    def test_local_hash_links_are_untouched(self):
        source = document('<a href="#lemma">Lemma</a><a class="skip-link" href="#main">Skip</a>')
        self.assertEqual(policy.apply_link_policy(source), source)

    def test_navigation_context_classes(self):
        for name in policy.LOCAL_NAV_CLASSES:
            with self.subTest(name=name):
                source = document(f'<div class="other {name}"><span><a href="other.html">Go</a></span></div>')
                self.assertEqual(policy.apply_link_policy(source), source)

    def test_navigation_class_on_anchor(self):
        source = document('<a class="project-name" href="index.html">PFR</a><a class="same-tab" href="index.html">All modules</a>')
        self.assertEqual(policy.apply_link_policy(source), source)

    def test_nav_and_void_elements_do_not_leak_context(self):
        _, anchors = self.transform('<nav><img src="icon.svg"><a href="other.html">Navigate</a></nav><a href="other.html">Read</a>')
        self.assertNotIn("target", anchors[0])
        self.assert_resource(anchors[1])

    def test_external_navigation_is_still_resource(self):
        for context in ("nav", 'div class="footer-links"', 'div class="same-tab"'):
            with self.subTest(context=context):
                _, anchors = self.transform(f'<{context}><a class="same-tab" href="https://example.org">External</a></{context.split()[0]}>')
                self.assert_resource(anchors[0])

    def test_mailto_download_empty_and_named_anchors_unchanged(self):
        source = document('<a href="mailto:hello@example.org">Email</a><a href="https://example.org/file.pdf" download>PDF</a><a href="file.json" download="data.json">Data</a><a href="">Empty</a><a id="named">Named</a>')
        self.assertEqual(policy.apply_link_policy(source), source)

    def test_title_and_description_are_retained(self):
        _, anchors = self.transform('<a href="other.html" title="A &amp; B &quot;result&quot;" aria-describedby="existing second">Read</a>')
        attrs = anchors[0]
        self.assertEqual(attrs["title"], 'A & B "result" — Opens in a new tab')
        self.assertEqual(attrs["aria-describedby"], "existing second new-tab-hint")

    def test_existing_rel_and_target(self):
        _, anchors = self.transform('<a href="other.html" rel="nofollow noopener" target="_self">Read</a>')
        self.assert_resource(anchors[0])
        self.assertEqual(anchors[0]["rel"], "nofollow noopener noreferrer")

    def test_idempotence_and_single_shared_hint(self):
        output, _ = self.transform('<a href="a.html">A</a><a href="b.html">B</a><a href="https://example.org">C</a>')
        self.assertEqual(policy.apply_link_policy(output), output)
        self.assertEqual(output.count(policy.HINT_HTML), 1)
        self.assertNotIn("<script", output)

    def test_existing_hint_is_reused(self):
        output, anchors = self.transform('<a href="a.html">A</a>' + policy.HINT_HTML)
        self.assert_resource(anchors[0])
        self.assertEqual(output.count(policy.HINT_HTML), 1)

    def test_duplicate_or_conflicting_hint_is_refused(self):
        for content in (policy.HINT_HTML * 2, '<div id="new-tab-hint">Wrong</div>', '<template>' + policy.HINT_HTML + '</template>'):
            with self.subTest(content=content):
                with self.assertRaises(ValueError):
                    policy.apply_link_policy(document(content))

    def test_existing_title_hint_is_not_repeated(self):
        output, anchors = self.transform('<a href="a.html" title="Result — Opens in a new tab" aria-describedby="new-tab-hint existing">A</a>')
        self.assertEqual(anchors[0]["title"], "Result — Opens in a new tab")
        self.assertEqual(anchors[0]["aria-describedby"], "new-tab-hint existing")
        self.assertEqual(policy.apply_link_policy(output), output)

    def test_source_outside_anchor_start_tags_is_identical(self):
        prefix = '<!DOCTYPE html>\r\n<html lang="en"><body> α &copy; <!-- <a href="fake"> -->\r\n'
        anchor = "<A data-note='target=\"fake\" > untouched' HREF='other.html' >"
        suffix = '<b>Original &amp; exact</b></A>\r\n<script>const text = \'<a href="fake">\';</script>\r\n</body></html>'
        output = policy.apply_link_policy(prefix + anchor + suffix)
        self.assertTrue(output.startswith(prefix))
        self.assertIn("data-note='target=\"fake\" > untouched' HREF='other.html'", output)
        self.assertTrue(output.endswith(suffix.replace("</body>", policy.HINT_HTML + "</body>")))
        self.assertEqual(policy.apply_link_policy(output), output)

    def test_svg_nodes_and_template_content(self):
        svg = '<svg><a class="graph-node" href="index.html#lemma"><title>Lemma</title><rect x="0"/><text>Lemma</text></a></svg>'
        output, anchors = self.transform(svg + '<template><a href="api/Module.html#Lemma">API</a></template>')
        self.assertIn(svg, output)
        self.assertNotIn("target", anchors[0])
        self.assert_resource(anchors[1])
        self.assertIn('</template>' + policy.HINT_HTML + '</body>', output)

    def test_fragment_has_accessible_hint(self):
        output = policy.apply_link_policy('<a href="other.html">Read</a>')
        self.assertTrue(output.endswith(policy.HINT_HTML))
        self.assertEqual(policy.apply_link_policy(output), output)

    def test_self_closing_anchor_preserves_terminator(self):
        output = policy.apply_link_policy('<a href="other.html" />')
        self.assertIn('aria-describedby="new-tab-hint"/>', output)
        self.assertEqual(policy.apply_link_policy(output), output)

    def test_cli_applies_top_level_but_checks_generated_pages(self):
        with tempfile.TemporaryDirectory() as temporary:
            site = Path(temporary)
            top = site / "index.html"
            nested = site / "api" / "index.html"
            nested.parent.mkdir()
            source = document('<a href="other.html">Read</a>')
            top.write_bytes(source.encode())
            nested.write_bytes(source.encode())
            with patch.object(policy, "SITE_ROOT", site), redirect_stdout(StringIO()):
                self.assertEqual(policy.main([]), 0)
                self.assertEqual(top.read_bytes().decode(), policy.apply_link_policy(source))
                self.assertEqual(nested.read_bytes().decode(), source)
                self.assertEqual(policy.main(["--check"]), 1)
                self.assertEqual(nested.read_bytes().decode(), source)
                nested.write_bytes(policy.apply_link_policy(source).encode())
                self.assertEqual(policy.main(["--check"]), 0)


if __name__ == "__main__":
    unittest.main()
