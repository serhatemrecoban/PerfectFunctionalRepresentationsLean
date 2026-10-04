"""Model-free adapter-hook tests; custom tags are synthetic, never PFR records."""
from dataclasses import asdict
import unittest

from contracts import classify_report, valid_finding
from safe_store import FixtureFS, Refusal, Store, TAG, canonical
from test_workflow import CRITERION
from workflow import Workflow


class PolicyHookTests(unittest.TestCase):
    def test_fixture_defaults_remain_explicit(self):
        self.assertEqual(Workflow.tag, TAG)
        self.assertTrue(Workflow.fixture_only)
        self.assertFalse(Workflow.production_acceptance)
        self.assertEqual(Workflow.ingress_prefix, "fixture-ingress:")
        self.assertEqual(Workflow.finding_prefix, "fixture-finding:")

    def test_store_namespace_cannot_read_foreign_records(self):
        fs = FixtureFS.create()
        fixture = Store(fs)
        ref = fixture.put("example", {"synthetic": True})
        # A synthetic alternate adapter policy, still inside the owned fixture.
        fs.record_tag = "ISOLATED_TEST_ADAPTER"
        alternate = Store(fs)
        with self.assertRaises(Refusal) as caught:
            alternate.get(ref)
        self.assertEqual(caught.exception.code, "OBJECT_SCHEMA")
        other = alternate.put("example", {"synthetic": True})
        self.assertNotEqual(ref, other)
        with self.assertRaises(Refusal) as caught:
            fixture.get(other)
        self.assertEqual(caught.exception.code, "OBJECT_SCHEMA")

    def test_report_tag_and_finding_namespace_are_explicit(self):
        tag = "ISOLATED_TEST_ADAPTER"
        finding = {"id": "alternate-finding:one", "label": "A",
                   "material": True, "claim": "Synthetic contract concern",
                   "severity": "HIGH", "confidence": "HIGH"}
        self.assertFalse(valid_finding(finding))
        self.assertTrue(valid_finding(finding, prefix="alternate-finding:"))
        expected = {"reviewer": "synthetic-reviewer", "request_id": "alternate-request:one",
                    "attempt": 1, "source_ref": "synthetic-source", "binding_digest": "synthetic-binding",
                    "kind": "STEP", "requirements": [asdict(CRITERION)]}
        envelope = {"tag": tag, "provenance": "SYNTHETIC_TRANSPORT", "sender": expected["reviewer"],
                    "request_id": expected["request_id"], "attempt": 1}
        report = {k: expected[k] for k in ("request_id", "attempt", "source_ref", "binding_digest", "kind")}
        report.update(schema=1, tag=tag, scope="Synthetic scope", findings=[finding],
                      criteria=[{"id": "C1", "status": "CONTRADICTED_BY_FINDING", "evidence": ["synthetic"]}],
                      verification=["synthetic"], earlier_reconciliation=[], conclusion="Not established")
        self.assertEqual(classify_report(canonical(report), envelope, expected, {})[0], "BAD_ENVELOPE")
        self.assertEqual(classify_report(canonical(report), envelope, expected, {}, tag=tag)[0], "INCOMPLETE")
        self.assertEqual(classify_report(canonical(report), envelope, expected, {}, tag=tag,
                                        finding_prefix="alternate-finding:")[0], "VALID")
