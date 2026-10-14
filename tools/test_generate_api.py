"""Model-free fixture tests for compiler-output processing and API publication checks."""
import copy
import json
from pathlib import Path
import subprocess
import tempfile
import unittest
from unittest.mock import patch

import generate_api as gate


class ApiTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        self.file = "PerfectFunctionalRepresentations/Semantics/Fixture.lean"
        self.module = gate.module_name(self.file)
        self.name = "PerfectFunctionalRepresentations.fixture"
        source = self.root / self.file
        source.parent.mkdir(parents=True)
        source.write_text("namespace PerfectFunctionalRepresentations\ntheorem fixture : True := by trivial\nend PerfectFunctionalRepresentations\n", encoding="utf-8")
        for file in gate.CONFIG:
            (self.root / file).write_text("fixture\n", encoding="utf-8")
        (self.root / "tools").mkdir()
        for file in ["tools/api_search.js", "tools/api_style.css"]:
            (self.root / file).write_text(gate.text(gate.ROOT / file), encoding="utf-8")
        self.url = f"{gate.REPOSITORY}/blob/{gate.SOURCE_COMMIT}/{self.file}#L2"
        self.row = {"name": self.name, "module": self.module, "kind": "theorem", "type": "True",
                    "universes": [], "documentation": "A fixture.", "line": 2, "end_line": 2,
                    "source_path": self.file, "source_line_text": "theorem fixture : True := by trivial",
                    "source_url": self.url, "page": "Semantics.Fixture.html", "in_compiler_source_index": True}
        self.data = {"schema": 1, "source_commit": gate.SOURCE_COMMIT, "repository": gate.REPOSITORY,
                     "source_hashes": {self.file: "fixture-hash"}, "generator_hashes": {"fixture": "hash"},
                     "boundary": gate.BOUNDARY, "modules": [{"name": self.module, "page": "Semantics.Fixture.html", "declarations": 1}],
                     "declarations": [self.row]}
        for name, value in [("source_snapshot", self.data["source_hashes"]),
                            ("tool_hashes", self.data["generator_hashes"]),
                            ("selected_sources", [self.file])]:
            patcher = patch.object(gate, name, return_value=value)
            patcher.start()
            self.addCleanup(patcher.stop)

    def validate(self, data=None):
        return gate.validate_data(data or self.data, self.root)

    def test_valid_inventory_and_source_allowlist(self):
        urls = self.validate()
        self.assertEqual(urls, {self.url, self.url.removesuffix("2") + "1"})

    def test_source_identity_and_generator_drift_refused(self):
        for key, value in [("source_commit", "master"), ("source_hashes", {}),
                           ("generator_hashes", {}), ("repository", "https://example.org")]:
            data = copy.deepcopy(self.data)
            data[key] = value
            with self.assertRaises(ValueError):
                self.validate(data)

    def test_private_wrong_owner_kind_and_path_refused(self):
        for field, value in [("name", "_private.fixture"), ("module", "PerfectFunctionalRepresentations.Tests.Fixture"),
                             ("kind", "axiom"), ("kind", "recursor"), ("source_path", "../secret.lean"),
                             ("page", "../secret.html")]:
            data = copy.deepcopy(self.data)
            data["declarations"][0][field] = value
            with self.assertRaises(ValueError):
                self.validate(data)

    def test_line_range_url_and_type_drift_refused(self):
        for field, value in [("line", 0), ("line", True), ("end_line", 99),
                             ("source_line_text", "wrong source"), ("source_url", "https://example.org"),
                             ("type", ""), ("type", "∀ x, ⋯")]:
            data = copy.deepcopy(self.data)
            data["declarations"][0][field] = value
            with self.assertRaises(ValueError):
                self.validate(data)

    def test_duplicate_module_or_declaration_refused(self):
        for key in ["modules", "declarations"]:
            data = copy.deepcopy(self.data)
            data[key].append(copy.deepcopy(data[key][0]))
            with self.assertRaises(ValueError):
                self.validate(data)

    def test_incorrect_counts_refused(self):
        self.data["modules"][0]["declarations"] = 2
        with self.assertRaises(ValueError):
            self.validate()

    def test_deterministic_render_and_escaping(self):
        self.row["documentation"] = '<script>alert("not executable")</script>'
        first = gate.render(self.data, self.root)
        self.assertEqual(first, gate.render(copy.deepcopy(self.data), self.root))
        self.assertIn("&lt;script&gt;", first["Semantics.Fixture.html"])
        self.assertNotIn('<script>alert', first["Semantics.Fixture.html"])
        self.assertIn('href="../blueprint/index.html"', first["index.html"])

    def test_missing_extra_or_changed_generated_file_refused(self):
        directory = self.root / "api"
        directory.mkdir()
        expected = {"index.html": "reference\n"}
        with self.assertRaises(ValueError):
            gate.compare_outputs(directory, expected)
        (directory / "index.html").write_text("reference\n", encoding="utf-8")
        gate.compare_outputs(directory, expected)
        (directory / "extra.html").write_text("extra", encoding="utf-8")
        with self.assertRaises(ValueError):
            gate.compare_outputs(directory, expected)
        (directory / "extra.html").unlink()
        (directory / "index.html").write_text("changed", encoding="utf-8")
        with self.assertRaises(ValueError):
            gate.compare_outputs(directory, expected)

    def test_static_integration_requires_manifest_and_used_source_links(self):
        site = self.root / "site"
        (site / "api").mkdir(parents=True)
        with self.assertRaises(OSError):
            gate.check_api_source_links(site, set(), self.root)
        for file, content in gate.render(self.data, self.root).items():
            (site / "api" / file).write_text(content, encoding="utf-8")
        urls = self.validate()
        self.assertEqual(gate.check_api_source_links(site, urls, self.root), urls)
        with self.assertRaises(ValueError):
            gate.check_api_source_links(site, set(), self.root)

    def test_parse_compiler_output_not_source_regex(self):
        output = "compiler notice\nPFR_API_MODULE " + json.dumps(self.module)
        output += "\nPFR_API_DECL " + json.dumps(self.row)
        modules, rows, missing = gate.parse_export(output)
        self.assertEqual(modules, [self.module])
        self.assertEqual(rows[0]["type"], "True")
        self.assertFalse(missing)
        with self.assertRaises(ValueError):
            gate.parse_export(output + "\nPFR_API_DECL " + json.dumps(self.row))

    def test_public_source_inventory_uses_compiler_decl_keys(self):
        folder = self.root / ".lake/build/lib/lean/PerfectFunctionalRepresentations/Semantics"
        folder.mkdir(parents=True)
        data = {"version": 5, "module": self.module,
                "decls": {self.name: [1, 0], "_private.fixture": [2, 0]}}
        (folder / "Fixture.ilean").write_text(json.dumps(data), encoding="utf-8")
        self.assertEqual(gate.source_declarations(self.root, [self.module]), {self.name})

    def test_module_page_is_flat(self):
        self.assertEqual(gate.module_page("PerfectFunctionalRepresentations"), "Root.html")
        self.assertEqual(gate.module_page(self.module), "Semantics.Fixture.html")

    def test_compiler_export_verifies_installed_pins_before_and_after(self):
        output = "PFR_API_MODULE " + json.dumps(self.module) + "\nPFR_API_DECL " + json.dumps(self.row)
        result = subprocess.CompletedProcess([], 0, stdout=output, stderr="")
        with patch.object(gate.build_gate, "validate_pins", return_value={"fixture": True}) as pins, \
             patch.object(gate.build_gate, "verify_installed") as installed, \
             patch.object(gate.subprocess, "run", return_value=result) as run:
            modules, rows, _ = gate.compiler_export(self.root, [self.file])
        self.assertEqual(modules, [self.module])
        self.assertEqual(len(rows), 1)
        self.assertEqual(pins.call_count, 2)
        self.assertEqual(installed.call_count, 2)
        self.assertEqual(run.call_args_list[0].args[0], ["lake", "build", self.module])
        self.assertEqual(run.call_args_list[1].args[0], ["lake", "env", "lean", "tools/export_api.lean"])

    def test_dirty_installed_dependency_blocks_export(self):
        with patch.object(gate.build_gate, "validate_pins", return_value={}), \
             patch.object(gate.build_gate, "verify_installed", side_effect=ValueError("dirty dependency")), \
             patch.object(gate.subprocess, "run") as run:
            with self.assertRaisesRegex(ValueError, "dirty dependency"):
                gate.compiler_export(self.root, [self.file])
        self.assertEqual(run.call_count, 1)


if __name__ == "__main__":
    unittest.main()
