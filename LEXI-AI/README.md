# LEXI AI: Intelligent Smart-Compliance & Legal Contract Networks

**4ta Escuela de Verano en Ciencias Cognitivas Computacionales y Procesamiento de Lenguaje Natural**
**Challenge:** ¿Qué nos dicen las leyes mexicanas?
**ESCOM IPN - Presentación: Viernes 3 de julio, 17:00 HRS**

**Live Demo:** https://spontaneous-marshmallow-9da514.netlify.app

## Architecture

```
                     LEXI ORCHESTRATOR
┌────────────────────────────────────────────────────────────┐
│  ┌──────────────┐   ┌──────────────────┐   ┌────────────┐ │
│  │ NLP Agent    │──▶│ Compliance Engine│──▶│ Crypto     │ │
│  │ (Python)     │   │ (Python/Rust)    │   │ (SHA-256)  │ │
│  └──────────────┘   └────────┬─────────┘   └────────────┘ │
│                              │                             │
│                              ▼                             │
│  ┌────────────────────────────────────────────────────┐    │
│  │        Soroban Smart Contract (Rust/WASM)           │    │
│  │      Immutable On-Chain Audit Registry              │    │
│  └────────────────────────────────────────────────────┘    │
└───────────────────────────┬────────────────────────────────┘
                            │
                            ▼
┌────────────────────────────────────────────────────────────┐
│              Flutter Dashboard (Dart/Web)                    │
│     https://spontaneous-marshmallow-9da514.netlify.app       │
└────────────────────────────────────────────────────────────┘
```

## Repo Structure

```
LEXI-AI/
├── agents/                    # NLP Layer (Python)
│   ├── lexi_nlp.py           # Universal legal axiom extractor
│   ├── tests/                # NLP unit tests (5 passing)
│   └── mock_laws/            # Sample Mexican laws (Fintech, CNBV)
├── core/                      # Rust Orchestrator
│   ├── src/main.rs           # Pipeline entrypoint
│   ├── src/compliance.rs     # Compliance evaluation engine
│   └── src/crypto.rs         # Cryptographic signing
├── contracts/                 # Soroban Smart Contract
│   └── lexi_compliance/
│       └── src/lib.rs        # On-chain audit registry
├── orchestrator/              # Python Pipeline Bridge
│   ├── lexi_pipeline.py      # End-to-end pipeline (mock or real)
│   └── api_server.py         # FastAPI REST server (localhost:8000)
├── flutter/                   # Flutter Web Dashboard
│   ├── lib/main.dart         # UI with backend connectivity
│   └── build/web/            # Production build (deployed)
├── integration_tests/        # End-to-end integration tests
├── netlify.toml              # Netlify deployment config
├── setup.ps1                 # Windows setup script
├── Makefile                  # Build/test/run automation
├── Cargo.toml                # Rust workspace
└── README.md
```

## Quick Start

```bash
# 1. Setup Python environment
make setup

# 2. Run all tests (12 total)
make test-nlp

# 3. Run the pipeline (mock mode)
python orchestrator/lexi_pipeline.py

# 4. Run the pipeline (with real law file)
python orchestrator/lexi_pipeline.py --law agents/mock_laws/ley_prueba.txt

# 5. Start the API server
python orchestrator/api_server.py

# 6. Launch Flutter (local dev)
make flutter-run

# 7. Build Rust core (requires Rust toolchain)
make build
make run-core
```

## Pipeline

```
Law Text (PDF/TXT)
    │
    ▼
NLP Agent (Python) ──── extracts Obligations, Prohibitions, Permissions
    │
    ▼
Compliance Engine (Python/Rust) ──── evaluates operational context against rules
    │
    ▼
Crypto Hash (SHA-256) ──── generates immutable audit fingerprint
    │
    ▼
Soroban Contract ──── registers hash on Stellar blockchain
    │
    ▼
Flutter Dashboard ──── displays results in real-time
```

## API

```bash
# Start the FastAPI server
python orchestrator/api_server.py

# Execute pipeline
curl http://localhost:8000/pipeline

# With custom law file
curl "http://localhost:8000/pipeline?law=agents/mock_laws/ley_prueba.txt"

# Health check
curl http://localhost:8000/health
```

## Tests (12 passing)

```bash
# NLP unit tests (5)
pytest agents/tests/ -v

# Integration tests (7)
pytest integration_tests/ -v

# All tests
pytest
```

## Evaluation Criteria

| Criterion | How LEXI AI addresses it |
|-----------|--------------------------|
| **Technical Application** | Multi-agent architecture: Python NLP + Rust engine + Soroban blockchain + Flutter UI |
| **AI & NLP Usage** | Universal legal axiom extraction via NLP patterns + sentence-level analysis |
| **Results Quality** | Deterministic compliance verification with SHA-256 cryptographic audit trail |
| **Creativity & Innovation** | Web3-anchored legal compliance + agentic network architecture + live demo on Netlify |
| **Presentation & Docs** | Full README, architecture diagrams, Makefile, API docs, deployable demo |

## Live Demo

https://spontaneous-marshmallow-9da514.netlify.app

## Team

Built with the LEXI AI agentic network architecture.
