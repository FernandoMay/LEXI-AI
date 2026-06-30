#![no_std]
use soroban_sdk::{contract, contractimpl, symbol_short, Env, Symbol, String, Address};

#[contract]
pub struct LexiAuditContract;

#[contractimpl]
impl LexiAuditContract {
    pub fn register_audit(
        env: Env,
        client: Address,
        doc_id: String,
        audit_hash: String,
        is_compliant: bool,
    ) {
        client.require_auth();
        let key = (symbol_short!("audit"), client.clone(), doc_id.clone());
        env.storage().persistent().set(&key, &audit_hash);
        env.events().publish(
            (symbol_short!("lexi_evt"), client),
            (doc_id, audit_hash, is_compliant),
        );
    }

    pub fn verify_status(env: Env, client: Address, doc_id: String) -> String {
        let key = (symbol_short!("audit"), client, doc_id);
        if env.storage().persistent().has(&key) {
            env.storage().persistent().get(&key).unwrap()
        } else {
            String::from_str(&env, "NOT_FOUND")
        }
    }
}

#[cfg(test)]
mod test {
    use super::*;
    use soroban_sdk::{Env, String, Address};

    #[test]
    fn test_register_and_verify() {
        let env = Env::default();
        let contract_id = env.register_contract(None, LexiAuditContract);
        let client = LexiAuditContractClient::new(&env, &contract_id);

        let user = Address::random(&env);
        let doc_id = String::from_str(&env, "ley_fintech_v1");
        let hash = String::from_str(&env, "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855");

        client.register_audit(&user, &doc_id, &hash, &true);
        let stored = client.verify_status(&user, &doc_id);
        assert_eq!(stored, hash);
    }
}
