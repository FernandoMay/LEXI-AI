use sha2::{Sha256, Digest};
use crate::compliance::AuditReport;

const AUTHORITY_SEED: &[u8] = b"LEXI_AI_AUTHORITY_SEED_v0.1";

pub fn sign_report(report: &AuditReport) -> String {
    let mut hasher = Sha256::new();
    hasher.update(AUTHORITY_SEED);
    hasher.update(report.compliance_hash.as_bytes());
    hasher.update(&report.timestamp.to_le_bytes());
    hex::encode(hasher.finalize())
}

pub fn verify_signature(report: &AuditReport, signature: &str) -> bool {
    let expected = sign_report(report);
    expected == signature
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::compliance::{LegalRule, RuleType};
    use std::collections::HashMap;

    #[test]
    fn test_sign_and_verify() {
        let rule = LegalRule {
            id: "OBL-001".into(),
            source_doc: "test.txt".into(),
            rule_type: RuleType::Obligation,
            condition_variable: "amount".into(),
            threshold_value: 100,
        };
        let engine = super::super::compliance::ComplianceEngine::new(vec![rule]);
        let mut ctx = HashMap::new();
        ctx.insert("amount".to_string(), 50);
        let report = engine.evaluate(&ctx);
        let sig = sign_report(&report);
        assert!(verify_signature(&report, &sig));
        assert!(!verify_signature(&report, "bad_sig"));
    }
}
