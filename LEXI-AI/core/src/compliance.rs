use serde::{Deserialize, Serialize};
use sha2::{Sha256, Digest};
use std::collections::HashMap;

#[derive(Serialize, Deserialize, Debug, Clone)]
pub enum RuleType {
    Obligation,
    Prohibition,
    Permission,
}

#[derive(Serialize, Deserialize, Debug, Clone)]
pub struct LegalRule {
    pub id: String,
    pub source_doc: String,
    pub rule_type: RuleType,
    pub condition_variable: String,
    pub threshold_value: u64,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct AuditReport {
    pub timestamp: u64,
    pub rules_evaluated: Vec<LegalRule>,
    pub compliance_status: bool,
    pub compliance_hash: String,
}

pub struct ComplianceEngine {
    pub rules: Vec<LegalRule>,
}

impl ComplianceEngine {
    pub fn new(rules: Vec<LegalRule>) -> Self {
        Self { rules }
    }

    pub fn evaluate(&self, context: &HashMap<String, u64>) -> AuditReport {
        let mut compliance_status = true;
        let now = std::time::SystemTime::now()
            .duration_since(std::time::UNIX_EPOCH)
            .unwrap_or_default()
            .as_secs();

        for rule in &self.rules {
            if let Some(&current_value) = context.get(&rule.condition_variable) {
                match rule.rule_type {
                    RuleType::Prohibition => {
                        if current_value >= rule.threshold_value {
                            compliance_status = false;
                        }
                    }
                    RuleType::Obligation => {
                        if current_value > rule.threshold_value {
                            compliance_status = false;
                        }
                    }
                    RuleType::Permission => {}
                }
            }
        }

        let mut hasher = Sha256::new();
        hasher.update(serde_json::to_string(&self.rules).unwrap_or_default().as_bytes());
        hasher.update(&[compliance_status as u8]);
        hasher.update(&now.to_le_bytes());
        let hash_result = hex::encode(hasher.finalize());

        AuditReport {
            timestamp: now,
            rules_evaluated: self.rules.clone(),
            compliance_status,
            compliance_hash: hash_result,
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_compliance_pass() {
        let rules = vec![LegalRule {
            id: "PRO-001".into(),
            source_doc: "test.txt".into(),
            rule_type: RuleType::Prohibition,
            condition_variable: "anonymous".into(),
            threshold_value: 1,
        }];
        let engine = ComplianceEngine::new(rules);
        let mut ctx = HashMap::new();
        ctx.insert("anonymous".to_string(), 0);
        let report = engine.evaluate(&ctx);
        assert!(report.compliance_status);
    }

    #[test]
    fn test_compliance_fail() {
        let rules = vec![LegalRule {
            id: "PRO-001".into(),
            source_doc: "test.txt".into(),
            rule_type: RuleType::Prohibition,
            condition_variable: "anonymous".into(),
            threshold_value: 1,
        }];
        let engine = ComplianceEngine::new(rules);
        let mut ctx = HashMap::new();
        ctx.insert("anonymous".to_string(), 1);
        let report = engine.evaluate(&ctx);
        assert!(!report.compliance_status);
    }
}
