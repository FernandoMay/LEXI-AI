# LEXI AI: Intelligent Smart-Compliance & Legal Contract Networks

**4ta Escuela de Verano en Ciencias Cognitivas Computacionales y Procesamiento de Lenguaje Natural**
**Challenge:** ¿Qué nos dicen las leyes mexicanas?
**ESCOM IPN - Presentación: Viernes 3 de julio, 17:00 HRS**

## Architecture

```
┌──────────────────────────────────────────────────────────────┐
│                     LEXI ORCHESTRATOR (Rust)                  │
│  ┌──────────────┐   ┌──────────────────┐   ┌──────────────┐  │
│  │ NLP Agent    │──▶│ Compliance Engine│──▶│ Crypto Auth  │  │
│  │ (Python)     │   │ (Rust Core)      │   │ (SHA-256)    │  │
│  └──────────────┘   └────────┬─────────┘   └──────────────┘  │
│                              │                               │
│                              ▼                               │
│  ┌──────────────────────────────────────────────────────┐    │
│  │           Soroban Smart Contract (Web3)               │    │
│  │         Immutable On-Chain Audit Registry             │    │
│  └──────────────────────────────────────────────────────┘    │
└──────────────────────────────────────────────────────────────┘
                         │
                         ▼
┌──────────────────────────────────────────────────────────────┐
│                  Flutter Dashboard (UI)                       │
│         Visual pipeline, real-time audit monitor             │
└──────────────────────────────────────────────────────────────┘
```

## Repo Structure

```
LEXI-AI/
├── agents/                    # NLP Layer (Python)
│   ├── lexi_nlp.py           # Universal legal axiom extractor
│   ├── requirements.txt
│   └── mock_laws/            # Sample Mexican laws
├── core/                      # Orchestrator (Rust)
│   ├── src/main.rs           # Pipeline entrypoint
│   ├── src/compliance.rs     # Compliance evaluation engine
│   └── src/crypto.rs         # Cryptographic signing
├── contracts/                 # Smart Contracts (Soroban/Rust)
│   └── lexi_compliance/
│       └── src/lib.rs        # On-chain audit registry
├── flutter/                   # Frontend (Dart/Flutter)
│   ├── lib/main.dart         # Dashboard UI
│   └── pubspec.yaml
├── Cargo.toml                 # Workspace root
├── Makefile                   # Build automation
└── README.md
```

## Quick Start

```bash
# 1. Setup Python agent
make setup

# 2. Build Rust core
make build

# 3. Run orchestrator
make run-core

# 4. Build Soroban contract
make contract-build

# 5. Launch Flutter dashboard
make flutter-run
```

## Evaluation Criteria

| Criterion | How LEXI AI addresses it |
|-----------|--------------------------|
| **Technical Application** | Multi-agent architecture: Python NLP + Rust engine + Soroban blockchain |
| **AI & NLP Usage** | Universal legal axiom extraction via regex/NER patterns |
| **Results Quality** | Deterministic compliance verification with cryptographic audit trail |
| **Creativity & Innovation** | Web3-anchored legal compliance with agentic network architecture |
| **Presentation & Docs** | Full README, architecture diagrams, Makefile automation |

## Team

Built with the LEXI AI agentic network architecture.
