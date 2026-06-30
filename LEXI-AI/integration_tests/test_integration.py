"""Integration tests: NLP Agent → Compliance → Multi-Party Signatures → Report."""
import json
import sys
import os
import unittest

sys.path.insert(0, os.path.join(os.path.dirname(__file__), ".."))
from orchestrator.lexi_pipeline import run_pipeline


class TestIntegration(unittest.TestCase):

    def test_end_to_end_with_mock_law(self):
        law_path = os.path.join(os.path.dirname(__file__), "..", "agents", "mock_laws", "ley_prueba.txt")
        report = run_pipeline(law_path=law_path)
        self.assertIn("metadata", report)
        self.assertIn("agents", report)
        self.assertIn("contract", report)
        self.assertIn("compliance", report)
        self.assertIn("signatures", report)
        self.assertIsInstance(report["compliance"]["status"], bool)

    def test_end_to_end_mock_mode(self):
        report = run_pipeline()
        self.assertIn("compliance", report)
        self.assertIsInstance(report["compliance"]["status"], bool)
        self.assertGreater(report["compliance"]["rules_evaluated"], 0)

    def test_three_agents_present(self):
        report = run_pipeline()
        agents = report["agents"]
        self.assertIn("nlp_agent", agents)
        self.assertIn("compliance_agent", agents)
        self.assertIn("web3_agent", agents)

    def test_three_signatures_present(self):
        report = run_pipeline()
        sigs = report["signatures"]
        self.assertIn("regulator", sigs)
        self.assertIn("audited_entity", sigs)
        self.assertIn("independent_auditor", sigs)
        for s in sigs.values():
            self.assertTrue(s["verified"])

    def test_contract_info_present(self):
        report = run_pipeline()
        ct = report["contract"]
        self.assertIn("contract_id", ct)
        self.assertIn("network", ct)
        self.assertIn("registration_tx", ct)
        self.assertIn("source", ct)

    def test_audit_hash_format(self):
        report = run_pipeline()
        h = report["compliance"]["audit_hash"]
        self.assertEqual(len(h), 64)
        int(h, 16)

    def test_compliance_pass(self):
        report = run_pipeline()
        self.assertTrue(report["compliance"]["status"])
        self.assertEqual(len(report["compliance"]["violations"]), 0)

    def test_output_json_serializable(self):
        report = run_pipeline()
        dumped = json.dumps(report)
        loaded = json.loads(dumped)
        self.assertEqual(loaded["compliance"]["status"], report["compliance"]["status"])

    def test_agent_trace_has_timestamps(self):
        report = run_pipeline()
        for aid, agent in report["agents"].items():
            self.assertIn("started_at", agent)
            self.assertIn("completed_at", agent)
            self.assertIn("elapsed_ms", agent)

    def test_signature_recovery(self):
        report = run_pipeline()
        evidence = report["evidence"]
        self.assertIn("core_payload", evidence)
        self.assertIn("recovery_hash", evidence)


if __name__ == "__main__":
    unittest.main()
