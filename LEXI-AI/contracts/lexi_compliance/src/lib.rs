#![no_std]
use soroban_sdk::{contract, contractimpl, symbol_short, vec, Env, Symbol, Vec, Address, BytesN};

const REQUIRED_SIGS: u32 = 2;

#[contract]
pub struct LexiAuditContract;

#[contractimpl]
impl LexiAuditContract {
    pub fn init(env: Env, regulator: Address, entity: Address, auditor: Address) {
        let has = |k: &str| env.storage().persistent().has(&symbol_short!(k));
        if has("reg") { panic!("already initialized") }
        env.storage().persistent().set(&symbol_short!("reg"), &regulator);
        env.storage().persistent().set(&symbol_short!("ent"), &entity);
        env.storage().persistent().set(&symbol_short!("aud"), &auditor);
    }

    pub fn register_audit(
        env: Env,
        sig1: Address,
        sig2: Address,
        doc_id: Symbol,
        audit_hash: BytesN<32>,
        is_compliant: bool,
    ) {
        sig1.require_auth();
        sig2.require_auth();

        let reg: Address = env.storage().persistent().get(&symbol_short!("reg")).unwrap();
        let ent: Address = env.storage().persistent().get(&symbol_short!("ent")).unwrap();
        let aud: Address = env.storage().persistent().get(&symbol_short!("aud")).unwrap();
        let valid = vec![&env, reg, ent, aud];
        let mut found = 0;
        for v in valid.iter() {
            if v == sig1 { found += 1; }
            if v == sig2 { found += 1; }
        }
        if found < REQUIRED_SIGS { panic!("not enough authorised signers"); }

        let key = (symbol_short!("audit"), doc_id);
        env.storage().persistent().set(&key, &audit_hash);
        env.storage().persistent().bump(&key, 500000, 1000000);

        env.events().publish(
            (symbol_short!("lexi_evt"), sig1, sig2),
            (doc_id, audit_hash, is_compliant, found),
        );
    }

    pub fn verify_status(env: Env, doc_id: Symbol) -> Vec<u8> {
        let key = (symbol_short!("audit"), doc_id);
        if env.storage().persistent().has(&key) {
            env.storage().persistent().get::<_, BytesN<32>>(&key).unwrap().to_array().to_vec()
        } else {
            Vec::new(&env)
        }
    }

    pub fn get_signers(env: Env) -> Vec<Address> {
        let reg: Address = env.storage().persistent().get(&symbol_short!("reg")).unwrap();
        let ent: Address = env.storage().persistent().get(&symbol_short!("ent")).unwrap();
        let aud: Address = env.storage().persistent().get(&symbol_short!("aud")).unwrap();
        vec![&env, reg, ent, aud]
    }
}

#[cfg(test)]
mod test {
    use super::*;
    use soroban_sdk::{Env, BytesN, Symbol};

    #[test]
    fn test_multi_sig_register() {
        let env = Env::default();
        let cid = env.register_contract(None, LexiAuditContract);
        let client = LexiAuditContractClient::new(&env, &cid);

        let reg = Address::random(&env);
        let ent = Address::random(&env);
        let aud = Address::random(&env);

        client.init(&reg, &ent, &aud);

        let doc = Symbol::new(&env, "ley_fintech_v2");
        let hash = BytesN::from_array(&env, &[1u8; 32]);

        client.register_audit(&ent, &aud, &doc, &hash, &true);
        let stored = client.verify_status(&doc);
        assert_eq!(stored.len(), 32);
    }

    #[test]
    #[should_panic(expected = "not enough authorised signers")]
    fn test_rejects_single_sig() {
        let env = Env::default();
        let cid = env.register_contract(None, LexiAuditContract);
        let client = LexiAuditContractClient::new(&env, &cid);

        let reg = Address::random(&env);
        let ent = Address::random(&env);
        let aud = Address::random(&env);

        client.init(&reg, &ent, &aud);
        let rogue = Address::random(&env);

        let doc = Symbol::new(&env, "fraud_doc");
        let hash = BytesN::from_array(&env, &[0u8; 32]);

        client.register_audit(&reg, &rogue, &doc, &hash, &false);
    }
}
