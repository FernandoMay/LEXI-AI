"""Integration test: NLP Agent → Compliance Engine → Audit Report."""
import json
import sys
import os
import unittest

sys.path.insert(0, os.path.join(os.path.dirname(__file__), ".."))
from orchestrator.lexi_pipeline import run_pipeline, ComplianceEngine


class TestIntegration(unittest.TestCase):

    def test_end_to_end_with_mock_law(self):
        """Full pipeline: parse a real law file, evaluate, produce report."""
        law_path = os.path.join(os.path.dirname(__file__), "..", "agents", "mock_laws", "ley_prueba.txt")
        report = run_pipeline(law_path=law_path)
        self.assertIn("timestamp", report)
        self.assertIn("compliance_hash", report)
        self.assertIn("rules_evaluated", report)
        self.assertIsInstance(report["compliance_status"], bool)
        self.assertGreater(len(report["rules_evaluated"]), 0)

    def test_end_to_end_mock_mode(self):
        """Pipeline with no law file -> uses mock rules."""
        report = run_pipeline()
        self.assertIn("compliance_hash", report)
        self.assertIsInstance(report["compliance_status"], bool)

    def test_compliance_pass(self):
        """All rules satisfied -> compliant."""
        engine = ComplianceEngine([
            {"id": "PRO-001", "rule_type": "Prohibition", "condition_variable": "x", "threshold_value": 1},
        ])
        report = engine.evaluate({"x": 0})
        self.assertTrue(report["compliance_status"])

    def test_compliance_fail_prohibition(self):
        """Prohibition violated -> non-compliant."""
        engine = ComplianceEngine([
            {"id": "PRO-001", "rule_type": "Prohibition", "condition_variable": "x", "threshold_value": 1},
        ])
        report = engine.evaluate({"x": 1})
        self.assertFalse(report["compliance_status"])

    def test_compliance_fail_obligation(self):
        """Obligation threshold exceeded -> non-compliant."""
        engine = ComplianceEngine([
            {"id": "OBL-001", "rule_type": "Obligation", "condition_variable": "amt", "threshold_value": 100},
        ])
        report = engine.evaluate({"amt": 200})
        self.assertFalse(report["compliance_status"])

    def test_hash_determinism(self):
        """Different timestamps produce different hashes."""
        rules = [{"id": "T1", "rule_type": "Prohibition", "condition_variable": "x", "threshold_value": 1}]
        ctx = {"x": 0}
        r1 = ComplianceEngine(rules).evaluate(ctx)
        import time; time.sleep(1.1)
        r2 = ComplianceEngine(rules).evaluate(ctx)
        self.assertNotEqual(r1["compliance_hash"], r2["compliance_hash"],
                            "Hashes differ because timestamp is included")

    def test_output_json_serializable(self):
        """Report must be valid JSON."""
        report = run_pipeline()
        dumped = json.dumps(report)
        loaded = json.loads(dumped)
        self.assertEqual(loaded["compliance_status"], report["compliance_status"])


if __name__ == "__main__":
    unittest.main()
