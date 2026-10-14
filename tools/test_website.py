"""Model-free tests for the static website guard; no network or Lean build."""
import json
from pathlib import Path
import subprocess
import tempfile
import unittest
from unittest.mock import patch

import check_website as gate


class WebsiteTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        self.site = self.root / "site"
        self.site.mkdir()
        (self.site / "assets").mkdir()
        self.commit = "a" * 40
        self.file = "PerfectFunctionalRepresentations/Semantics/Example.lean"
        self.url = f"{gate.REPOSITORY}/blob/{self.commit}/{self.file}#L2"
        self.manifest = {"commit": self.commit, "repository": gate.REPOSITORY, "entries": [
            {"file": self.file, "line": 2, "needle": "theorem demo", "label": "Demo"}]}
        self.write("source-links.json", json.dumps(self.manifest))
        self.write("assets/site.css", "body { color: black; }")
        self.write("assets/site.js", "document.documentElement.classList.add('js');")
        self.write("assets/diagram.svg", '<svg xmlns="http://www.w3.org/2000/svg"><g id="shape"/></svg>')
        self.html = ('<!doctype html><html lang="en"><head><title>PFR</title>'
                     '<meta name="viewport" content="width=device-width, initial-scale=1">'
                     '<link rel="stylesheet" href="assets/site.css">'
                     '<script src="assets/site.js" defer></script></head>'
                     '<body><main id="main"><h1>PFR</h1>'
                     '<img src="assets/diagram.svg" alt="Representation">'
                     f'<a href="{self.url}">Source</a><a href="#main">Top</a>'
                     '</main></body></html>')
        self.write("index.html", self.html)
        self.git = patch.object(gate.subprocess, "run", return_value=subprocess.CompletedProcess([], 0))
        self.git.start()
        self.addCleanup(self.git.stop)
        self.source = patch.object(gate, "git_source", return_value="namespace PFR\ntheorem demo : True := by trivial\n")
        self.source.start()
        self.addCleanup(self.source.stop)

    def write(self, path, text):
        (self.site / path).write_text(text, encoding="utf-8")

    def check(self):
        return gate.check_site(self.site, self.root)

    def test_valid_self_contained_site(self):
        self.write(".nojekyll", "")
        self.assertEqual(self.check(), (1, 5))

    def test_cross_page_fragment_and_svg_fragment(self):
        self.write("results.html", self.html.replace('id="main"', 'id="result"').replace('href="#main"', 'href="#result"'))
        self.write("index.html", self.html.replace('href="#main"', 'href="results.html#result"')
                   .replace('src="assets/diagram.svg"', 'src="assets/diagram.svg#shape"'))
        self.assertEqual(self.check()[0], 2)

    def test_missing_or_duplicate_fragment_refused(self):
        for html in [self.html.replace('href="#main"', 'href="#missing"'),
                     self.html.replace("<h1>", '<h1 id="main">')]:
            self.write("index.html", html)
            with self.assertRaises(ValueError):
                self.check()

    def test_missing_asset_and_escape_refused(self):
        for url in ["missing.svg", "../outside.svg", "/assets/diagram.svg", "%2e%2e/outside.svg"]:
            self.write("index.html", self.html.replace("assets/diagram.svg", url))
            with self.assertRaises(ValueError):
                self.check()

    def test_external_navigation_allowed(self):
        self.write("index.html", self.html.replace('</main>', '<a href="https://example.org/">Link</a><a href="mailto:a@example.org">Email</a></main>'))
        self.check()

    def test_external_assets_and_unsafe_schemes_refused(self):
        for old, new in [("assets/site.js", "https://example.org/script.js"),
                         ("assets/site.css", "https://example.org/style.css"),
                         ("assets/diagram.svg", "//example.org/a.svg"),
                         ("#main", "javascript:alert(1)"),
                         ("#main", "https://user:secret@example.org/")]:
            self.write("index.html", self.html.replace(old, new))
            with self.assertRaises(ValueError):
                self.check()

    def test_inline_script_or_event_refused(self):
        for html in [self.html.replace(' src="assets/site.js"', ''),
                     self.html.replace('</script>', 'alert(1)</script>'),
                     self.html.replace('<h1>', '<h1 onclick="alert(1)">')]:
            self.write("index.html", html)
            with self.assertRaises(ValueError):
                self.check()

    def test_accessibility_basics_required(self):
        for old, new in [(' lang="en"', ''), ('<title>PFR</title>', ''),
                         ('name="viewport"', 'name="other"'), ('<main', '<section'),
                         ('<h1>', '<h2>'), (' alt="Representation"', '')]:
            self.write("index.html", self.html.replace(old, new))
            with self.assertRaises(ValueError):
                self.check()

    def test_aria_and_copy_targets_exist(self):
        for attribute in ["aria-labelledby", "aria-describedby", "aria-controls", "data-copy"]:
            self.write("index.html", self.html.replace('<h1>', f'<h1 {attribute}="main">'))
            self.check()
            self.write("index.html", self.html.replace('<h1>', f'<h1 {attribute}="missing">'))
            with self.assertRaisesRegex(ValueError, "missing .* target"):
                self.check()

    def test_css_assets_and_import_refused(self):
        for css in ['@import "https://example.org/font.css";',
                    'body { background: url(https://example.org/pic.svg); }',
                    'body { background: url(missing.svg); }']:
            self.write("assets/site.css", css)
            with self.assertRaises(ValueError):
                self.check()
        self.write("assets/site.css", "body { background: url(diagram.svg#shape); }")
        self.check()

    def test_active_svg_refused(self):
        for content in ['<script/>', '<foreignObject/>', '<g onload="alert(1)"/>',
                        '<image href="https://example.org/a.svg"/>',
                        '<g fill="url(https://example.org/a.svg)"/>']:
            self.write("assets/diagram.svg", f'<svg xmlns="http://www.w3.org/2000/svg">{content}</svg>')
            with self.assertRaises(ValueError):
                self.check()

    def test_malformed_metadata_or_svg_root_refused(self):
        self.write("index.html", self.html.replace('name="viewport"', 'name'))
        with self.assertRaises(ValueError):
            self.check()
        self.write("index.html", self.html)
        self.write("assets/diagram.svg", "<html/>")
        with self.assertRaises(ValueError):
            self.check()

    def test_js_network_loading_refused(self):
        for text in ["fetch('data.json');", "import('extra.js');", "new WebSocket('wss://example.org');"]:
            self.write("assets/site.js", text)
            with self.assertRaises(ValueError):
                self.check()

    def test_private_files_and_disallowed_extensions_refused(self):
        for name in ["paper.pdf", "key.pem", ".env", "binary.exe"]:
            self.write(name, "private")
            with self.assertRaises(ValueError):
                self.check()
            (self.site / name).unlink()
        (self.site / "tmp").mkdir()
        with self.assertRaises(ValueError):
            self.check()

    def test_local_paths_and_obvious_credentials_refused(self):
        for value in ['file:///C:/Users/person/paper.pdf', r'C:\Users\person\paper.pdf',
                      "ghp_" + "a" * 30, 'password="long-secret"']:
            self.write("notes.txt", value)
            with self.assertRaises(ValueError):
                self.check()

    def test_symlink_refused_when_platform_permits(self):
        link = self.site / "linked.txt"
        try:
            link.symlink_to(self.site / "source-links.json")
        except OSError as error:
            self.skipTest(f"OS does not permit test symlinks: {error}")
        with self.assertRaises(ValueError):
            self.check()

    def test_source_line_and_needle_drift_refused(self):
        for field, value in [("line", 1), ("line", 999), ("line", True),
                             ("needle", "invented theorem"), ("file", "../Secret.lean")]:
            original = self.manifest["entries"][0][field]
            self.manifest["entries"][0][field] = value
            self.write("source-links.json", json.dumps(self.manifest))
            with self.assertRaises(ValueError):
                self.check()
            self.manifest["entries"][0][field] = original

    def test_manifest_commit_and_origin_required(self):
        for field, value in [("commit", "master"), ("repository", "https://example.org/"), ("entries", [])]:
            original = self.manifest[field]
            self.manifest[field] = value
            self.write("source-links.json", json.dumps(self.manifest))
            with self.assertRaises(ValueError):
                self.check()
            self.manifest[field] = original

    def test_missing_commit_refused(self):
        gate.subprocess.run.return_value = subprocess.CompletedProcess([], 1)
        with self.assertRaisesRegex(ValueError, "commit is unavailable"):
            self.check()

    def test_unused_manifest_and_unregistered_source_links_refused(self):
        for html in [self.html.replace(self.url, "https://example.org/"),
                     self.html.replace('</main>', f'<a href="{self.url.replace(self.commit, "master")}">Unpinned</a></main>')]:
            self.write("index.html", html)
            with self.assertRaises(ValueError):
                self.check()

    def test_git_source_uses_exact_commit_and_path(self):
        self.source.stop()
        gate.subprocess.run.return_value = subprocess.CompletedProcess([], 0, stdout="theorem demo\n")
        self.assertEqual(gate.git_source(self.commit, self.file, self.root), "theorem demo\n")
        self.assertEqual(gate.subprocess.run.call_args.args[0], ["git", "show", f"{self.commit}:{self.file}"])
        gate.subprocess.run.return_value = subprocess.CompletedProcess([], 1, stdout="")
        with self.assertRaises(ValueError):
            gate.git_source(self.commit, self.file, self.root)


if __name__ == "__main__":
    unittest.main()
