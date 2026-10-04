"""Six unchanged inherited expectations; IR-006 adapted to explicit reassessment.
The supplied module is preserved byte-for-byte as independent_probes_original.py.
Observation procedures remain historical baseline diagnostics, not corrected tests.
"""
from independent_probes_original import IndependentReviewProbes as OriginalProbes

class IndependentReviewProbes(OriginalProbes):
    def test_finding_materiality_can_be_reassessed_without_losing_stable_identity(self):
        f = self.finding(False)
        ev, _, _, _ = self.to_final_validation([f])
        self.w.disposition(f["id"], "OPTIONAL_DECLINED", "Not yet needed in this step.")
        self.ready(ev); self.w.close()
        ev2, req2 = self.to_pending()
        f["material"] = True; f["severity"] = "important"
        raw, env = self.report(req2, ev2, [f])
        self.w.receive(raw, env); self.w.reconcile_report()
        # Incoming materiality is a proposed assessment, not automatic authority.
        self.assertTrue(self.state()["active"]["findings"][f["id"]]["pending_assessment"])
        self.w.reassess_finding(f["id"], True, "Current consumer makes this concern material; source inspection supplied.", [ev2])
        updated = self.state()["active"]["findings"][f["id"]]
        self.assertTrue(updated["material"])
        self.assertFalse(updated["original"]["material"])
        self.assertEqual(updated["history"][-1]["status"], "OPEN")

