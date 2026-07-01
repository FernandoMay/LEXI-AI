"""Integration tests: NLP → Compliance → Multi-Party Signatures → AST-bound hash."""
import json
import sys
import os
import unittest
import hashlib

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
        self.assertIn("multi_sig_required", ct)
        self.assertEqual(ct["multi_sig_required"], 2)

    def test_ast_hash_present(self):
        report = run_pipeline()
        self.assertIn("ast_hash", report["compliance"])
        h = report["compliance"]["ast_hash"]
        self.assertEqual(len(h), 64)
        int(h, 16)

    def test_audit_hash_includes_ast(self):
        """Audit hash must differ from AST hash (it binds AST + compliance status)."""
        report = run_pipeline()
        self.assertNotEqual(
            report["compliance"]["audit_hash"],
            report["compliance"]["ast_hash"],
        )

    def test_compliance_pass(self):
        report = run_pipeline()
        self.assertTrue(report["compliance"]["status"])
        self.assertEqual(len(report["compliance"]["violations"]), 0)

    def test_compliance_fail_high_transaction(self):
        """Transaction amount exceeding threshold triggers violation."""
        report = run_pipeline(operational_context={
            "transaction_amount": 60000,
            "anonymous_accounts": 0,
            "kyc_threshold": 0,
            "max_interest_rate": 36,
            "crowdfunding_limit": 500000,
            "money_laundering_flag": 0,
        })
        self.assertFalse(report["compliance"]["status"])
        self.assertIn("OBL-001", report["compliance"]["violations"])

    def test_compliance_fail_anonymous_accounts(self):
        """Anonymous accounts flag triggers prohibition violation."""
        report = run_pipeline(operational_context={
            "transaction_amount": 0,
            "anonymous_accounts": 1,
            "kyc_threshold": 0,
            "max_interest_rate": 36,
            "crowdfunding_limit": 500000,
            "money_laundering_flag": 0,
        })
        self.assertFalse(report["compliance"]["status"])
        self.assertIn("PRO-001", report["compliance"]["violations"])

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

    def test_nlp_method_in_rules(self):
        report = run_pipeline()
        for rule in report["agents"]["nlp_agent"]["outputs"]["rules"]:
            self.assertIn("method", rule)

    def test_version_2_metadata(self):
        report = run_pipeline()
        self.assertEqual(report["metadata"]["version"], "2.0.0")


if __name__ == "__main__":
    unittest.main()
