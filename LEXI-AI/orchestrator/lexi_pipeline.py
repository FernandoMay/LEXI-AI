#!/usr/bin/env python3
"""
LEXI AI - Python Pipeline Orchestrator
Bridges NLP Agent -> Compliance Engine -> Audit Report -> JSON output
Mirrors the Rust core logic for environments where Rust compilation is unavailable.
"""
import sys
import json
import hashlib
import time
import os

sys.path.insert(0, os.path.join(os.path.dirname(__file__), ".."))
from agents.lexi_nlp import extract_legal_axioms


class ComplianceEngine:
    def __init__(self, rules: list):
        self.rules = rules

    def evaluate(self, context: dict) -> dict:
        compliant = True
        violations = []

        for rule in self.rules:
            var = rule["condition_variable"]
            val = context.get(var)
            if val is None:
                continue

            rtype = rule["rule_type"]
            threshold = rule["threshold_value"]

            if rtype == "Prohibition" and val >= threshold:
                compliant = False
                violations.append(rule["id"])
            elif rtype == "Obligation" and val > threshold:
                compliant = False
                violations.append(rule["id"])

        raw = json.dumps(self.rules, sort_keys=True).encode()
        h = hashlib.sha256(raw)
        h.update(str(compliant).encode())
        h.update(str(int(time.time())).encode())

        return {
            "timestamp": int(time.time()),
            "rules_evaluated": self.rules,
            "compliance_status": compliant,
            "compliance_hash": h.hexdigest(),
            "violations": violations,
            "signed": hashlib.sha256(b"LEXI_AI_AUTHORITY_v0.1" + h.hexdigest().encode()).hexdigest(),
        }


def run_pipeline(law_path: str = None, operational_context: dict = None) -> dict:
    if law_path:
        print(f"[Pipeline] Ingesting: {law_path}")
        rules_raw = extract_legal_axioms(law_path)
        rules = json.loads(rules_raw)
    else:
        print("[Pipeline] Using mock rules (no law file provided)")
        rules = [
            {"id": "OBL-001", "source_doc": "ley_fintech.txt", "rule_type": "Obligation",
             "condition_variable": "transaction_amount", "threshold_value": 50000,
             "description": "Verificar identidad para operaciones > 50,000 UDIS"},
            {"id": "PRO-001", "source_doc": "ley_fintech.txt", "rule_type": "Prohibition",
             "condition_variable": "anonymous_accounts", "threshold_value": 1,
             "description": "Prohibición de cuentas anónimas"},
            {"id": "OBL-002", "source_doc": "ley_general.txt", "rule_type": "Obligation",
             "condition_variable": "kyc_threshold", "threshold_value": 0,
             "description": "Obligación de verificar identidad"},
        ]

    if operational_context is None:
        operational_context = {
            "transaction_amount": 45000,
            "anonymous_accounts": 0,
            "kyc_threshold": 0,
            "max_interest_rate": 36,
        }

    print(f"[Pipeline] Rules extracted: {len(rules)}")
    print(f"[Pipeline] Evaluating context: {json.dumps(operational_context, indent=2)}")

    engine = ComplianceEngine(rules)
    report = engine.evaluate(operational_context)

    print(f"[Pipeline] Compliance: {'PASS' if report['compliance_status'] else 'FAIL'}")
    print(f"[Pipeline] Audit Hash: {report['compliance_hash']}")

    return report


def main():
    import argparse
    parser = argparse.ArgumentParser(description="LEXI AI Pipeline Orchestrator")
    parser.add_argument("--law", help="Path to legal text file", default=None)
    parser.add_argument("--context", help="Path to JSON context file", default=None)
    parser.add_argument("--output", help="Output JSON file path", default=None)
    args = parser.parse_args()

    context = None
    if args.context:
        with open(args.context) as f:
            context = json.load(f)

    report = run_pipeline(law_path=args.law, operational_context=context)
    output = json.dumps(report, indent=2, ensure_ascii=False)

    if args.output:
        with open(args.output, "w", encoding="utf-8") as f:
            f.write(output)
        print(f"[Pipeline] Report written to: {args.output}")
    else:
        print("\n=== AUDIT REPORT ===")
        print(output)

    return 0 if report["compliance_status"] else 1


if __name__ == "__main__":
    sys.exit(main())
