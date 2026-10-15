"""Model-free freshness regressions; no TeX installation required."""
import contextlib
import io
import json
from pathlib import Path
import tempfile
import unittest
from unittest.mock import patch

import build_lemma4_proof as proof


class ProofAssetsTests(unittest.TestCase):
    def setUp(self):
        temp = tempfile.TemporaryDirectory()
        self.addCleanup(temp.cleanup)
        self.root = Path(temp.name)
        self.assets = self.root / "site/assets/proofs"
        self.assets.mkdir(parents=True)
        self.source = self.root / "lemma-4.tex"
        self.source.write_bytes(b"Test source\n")
        (self.assets / "lemma-4.tex.txt").write_bytes(self.source.read_bytes())
        (self.assets / "lemma-4-1.svg").write_bytes(b"<svg/>\n")
        self.html = self.root / "site/discussion.html"
        self.html.write_text('<img src="assets/proofs/lemma-4-1.svg">', encoding="utf-8")
        self.manifest = self.assets / "lemma-4.json"
        self.record = {"source_sha256": proof.digest(self.source), "page_count": 1,
                       "files": {p.name: proof.digest(p) for p in self.assets.iterdir()}}
        self.save_record()
        for name, value in [("ROOT", self.root), ("SOURCE", self.source),
                            ("ASSETS", self.assets), ("MANIFEST", self.manifest)]:
            override = patch.object(proof, name, value)
            override.start()
            self.addCleanup(override.stop)

    def save_record(self):
        self.manifest.write_text(json.dumps(self.record), encoding="utf-8")

    def check(self):
        with contextlib.redirect_stdout(io.StringIO()):
            proof.check()

    def test_matching_reviewed_assets(self):
        self.check()

    def test_source_checkout_line_endings(self):
        self.source.write_bytes(b"Test source\r\n")
        self.check()

    def test_source_drift(self):
        self.source.write_bytes(b"Changed source\n")
        with self.assertRaisesRegex(ValueError, "source changed"):
            self.check()

    def test_asset_drift(self):
        (self.assets / "lemma-4-1.svg").write_bytes(b"<svg>changed</svg>")
        with self.assertRaisesRegex(ValueError, "Changed proof asset"):
            self.check()

    def test_stale_page(self):
        (self.assets / "lemma-4-2.svg").write_bytes(b"<svg/>")
        with self.assertRaisesRegex(ValueError, "Missing or stale"):
            self.check()

    def test_incorrect_inventory(self):
        self.record["page_count"] = 2
        self.save_record()
        with self.assertRaisesRegex(ValueError, "inventory"):
            self.check()

    def test_published_source_mismatch_even_if_fingerprint_updated(self):
        copy = self.assets / "lemma-4.tex.txt"
        copy.write_bytes(b"Different source\n")
        self.record["files"][copy.name] = proof.digest(copy)
        self.save_record()
        with self.assertRaisesRegex(ValueError, "source differs"):
            self.check()

    def test_missing_page_reference(self):
        self.html.write_text("No proof image here", encoding="utf-8")
        with self.assertRaisesRegex(ValueError, "does not display"):
            self.check()


if __name__ == "__main__":
    unittest.main()
