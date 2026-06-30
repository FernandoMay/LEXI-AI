use std::collections::HashMap;
use std::process::Command;
use std::path::Path;

mod compliance;
mod crypto;

use compliance::{LegalRule, RuleType, AuditReport, ComplianceEngine};

fn main() {
    println!("╔══════════════════════════════════════════════╗");
    println!("║     LEXI AI - Orchestrator Core v0.1        ║");
    println!("║  Intelligent Smart-Compliance & Legal        ║");
    println!("║         Contract Networks                    ║");
    println!("╚══════════════════════════════════════════════╝");

    let rules = fetch_rules_from_nlp();
    let engine = ComplianceEngine::new(rules);

    let mut context = HashMap::new();
    context.insert("transaction_amount".to_string(), 45000);
    context.insert("anonymous_accounts".to_string(), 0);
    context.insert("kyc_threshold".to_string(), 0);
    context.insert("max_interest_rate".to_string(), 36);

    let report = engine.evaluate(&context);
    let signed_hash = crypto::sign_report(&report);

    println!();
    println!("  Rules evaluated:  {}", report.rules_evaluated.len());
    println!("  Compliance:       {}", if report.compliance_status { "PASS ✅" } else { "FAIL ❌" });
    println!("  Audit Hash:       {}", report.compliance_hash);
    println!("  Signed Hash:      {}", signed_hash);
    println!();

    if report.compliance_status {
        println!("  >> System is COMPLIANT. Ready for on-chain anchoring.");
    } else {
        println!("  >> System is NON-COMPLIANT. Review flagged rules.");
        for rule in &report.rules_evaluated {
            if let Some(&val) = context.get(&rule.condition_variable) {
                let violated = match rule.rule_type {
                    RuleType::Prohibition => val >= rule.threshold_value,
                    RuleType::Obligation => val > rule.threshold_value,
                    RuleType::Permission => false,
                };
                if violated {
                    println!("     - Violation: {} ({}: {} > {})",
                        rule.id, rule.condition_variable, val, rule.threshold_value);
                }
            }
        }
    }

    println!();
    println!("  Audit JSON:");
    println!("{}", serde_json::to_string_pretty(&report).unwrap());
}

fn fetch_rules_from_nlp() -> Vec<LegalRule> {
    let agent_path = Path::new("../agents/lexi_nlp.py");
    let law_path = Path::new("../agents/mock_laws/ley_prueba.txt");

    let output = if agent_path.exists() {
        Command::new("python3")
            .arg(agent_path)
            .arg(law_path)
            .output()
            .ok()
    } else {
        None
    };

    match output {
        Some(out) if out.status.success() => {
            let stdout = String::from_utf8_lossy(&out.stdout);
            serde_json::from_str(&stdout).unwrap_or_else(|_| get_default_rules())
        }
        _ => {
            println!("  [NLP Agent] Using fallback mock rules (Python agent not available)");
            get_default_rules()
        }
    }
}

fn get_default_rules() -> Vec<LegalRule> {
    vec![
        LegalRule {
            id: "OBL-001".into(),
            source_doc: "ley_fintech_mexicana.txt".into(),
            rule_type: RuleType::Obligation,
            condition_variable: "transaction_amount".into(),
            threshold_value: 50000,
        },
        LegalRule {
            id: "PRO-001".into(),
            source_doc: "ley_fintech_mexicana.txt".into(),
            rule_type: RuleType::Prohibition,
            condition_variable: "anonymous_accounts".into(),
            threshold_value: 1,
        },
        LegalRule {
            id: "OBL-002".into(),
            source_doc: "ley_proteccion_datos.txt".into(),
            rule_type: RuleType::Obligation,
            condition_variable: "kyc_threshold".into(),
            threshold_value: 0,
        },
    ]
}
