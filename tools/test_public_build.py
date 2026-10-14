"""Small model-free tests for the public build gate."""
import copy
import json
from pathlib import Path
import tempfile
import unittest
from unittest.mock import patch

import check_public_build as gate


class PublicBuildTests(unittest.TestCase):
    def test_module_inventory_includes_top_level_child(self):
        names = ["PerfectFunctionalRepresentations.lean",
                 "PerfectFunctionalRepresentations/Basic.lean",
                 "PerfectFunctionalRepresentations/Tests/Example.lean",
                 ".lake/packages/Other.lean", "tmp/Probe.lean"]
        self.assertEqual(gate.maintained_sources(names), sorted(names[:3]))

    def test_missing_root_or_tests_refused(self):
        for names in [[], ["PerfectFunctionalRepresentations.lean"],
                      ["PerfectFunctionalRepresentations/Tests/A.lean"]]:
            with self.assertRaises(ValueError):
                gate.maintained_sources(names)

    def test_current_release_contract(self):
        packages = {p["name"]: p for p in gate.validate_pins(gate.ROOT)["packages"]}
        self.assertEqual(packages["LeanInfoTheory"]["rev"], gate.LIT_REV)

    def test_changed_release_or_commit_refused(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            for name in gate.CONFIG:
                (root / name).write_bytes((gate.ROOT / name).read_bytes())
            manifest = json.loads((root / "lake-manifest.json").read_text())
            for field, value in [("rev", "0" * 40), ("inputRev", "master")]:
                changed = copy.deepcopy(manifest)
                next(p for p in changed["packages"] if p["name"] == "LeanInfoTheory")[field] = value
                (root / "lake-manifest.json").write_text(json.dumps(changed))
                with self.assertRaises(ValueError):
                    gate.validate_pins(root)

    def test_manifest_order_is_irrelevant(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            for name in gate.CONFIG:
                (root / name).write_bytes((gate.ROOT / name).read_bytes())
            manifest = json.loads((root / "lake-manifest.json").read_text())
            manifest["packages"].reverse()
            (root / "lake-manifest.json").write_text(json.dumps(manifest))
            gate.validate_pins(root)

    def test_exact_build_commands(self):
        sources = ["PerfectFunctionalRepresentations.lean", "PerfectFunctionalRepresentations/Basic.lean",
                   "PerfectFunctionalRepresentations/Tests/A.lean"]
        with patch.object(gate.subprocess, "run") as run:
            gate.build_all(sources, gate.ROOT)
        self.assertEqual(run.call_args_list[0].args[0], ["lake", "build", "PerfectFunctionalRepresentations",
                         "PerfectFunctionalRepresentations.Basic", "PerfectFunctionalRepresentations.Tests.A"])
        self.assertEqual(run.call_args_list[1].args[0], ["lake", "build"])
        self.assertTrue(all(call.kwargs["check"] for call in run.call_args_list))

    def test_installed_mismatch_or_dirty_dependency_refused(self):
        manifest = {"packagesDir": ".lake/packages", "packages": [
            {"name": "LeanInfoTheory", "type": "git", "rev": gate.LIT_REV}]}
        for results in [["0" * 40], [gate.LIT_REV, " M Source.lean"]]:
            with patch.object(gate, "output", side_effect=results):
                with self.assertRaises(ValueError):
                    gate.verify_installed(manifest, gate.ROOT)

    def test_installed_clean_release_accepted(self):
        manifest = {"packagesDir": ".lake/packages", "packages": [
            {"name": "LeanInfoTheory", "type": "git", "rev": gate.LIT_REV}]}
        with patch.object(gate, "output", side_effect=[gate.LIT_REV, ""]):
            gate.verify_installed(manifest, gate.ROOT)

    def test_private_material_refused(self):
        for path in ["output/pdf/private.pdf", ".pfr-review/state.json", "tmp/notes.txt",
                     "paper.pdf", ".env", "private.pem"]:
            with self.assertRaises(ValueError):
                gate.check_tracked_content([path], [], gate.ROOT)

    def test_ordinary_public_documents_allowed(self):
        gate.check_tracked_content(["README.md", "CITATION.cff", "docs/project-log.md"], [], gate.ROOT)

    def test_placeholder_scan(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            source = root / "Example.lean"
            for token in ["sorry", "admit", "axiom", "opaque", "undefined"]:
                source.write_text(f"example : True := {token}\n")
                with self.assertRaises(ValueError):
                    gate.check_tracked_content([source.name], [source.name], root)
            source.write_text("example : True := True.intro\n")
            gate.check_tracked_content([source.name], [source.name], root)


if __name__ == "__main__":
    unittest.main()
