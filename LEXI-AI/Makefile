.PHONY: all setup build test run clean flutter-run flutter-build setup-ps1

all: build

setup:
	pip install -r agents/requirements.txt

setup-ps1:
	powershell -ExecutionPolicy ByPass -File setup.ps1

build:
	cargo build --release 2>&1

build-core:
	cd core && cargo build 2>&1

test:
	cargo test --workspace 2>&1

test-nlp:
	python -m pytest agents/tests/ -v 2>&1 || python -m unittest agents/tests/test_nlp.py -v 2>&1

run-core:
	cd core && cargo run 2>&1

run-nlp:
	python agents/lexi_nlp.py agents/mock_laws/ley_prueba.txt

run-nlp-mock:
	python agents/lexi_nlp.py

contract-build:
	cd contracts/lexi_compliance && cargo build --target wasm32-unknown-unknown --release 2>&1

contract-test:
	cd contracts/lexi_compliance && cargo test 2>&1

flutter-run:
	cd flutter && flutter run -d chrome 2>&1

flutter-build:
	cd flutter && flutter build web 2>&1

flutter-clean:
	cd flutter && flutter clean 2>&1

clean:
	cargo clean 2>&1
	rm -rf flutter/build 2>/dev/null || true
	rm -rf __pycache__ 2>/dev/null || true
	find . -type d -name __pycache__ -exec rm -rf {} + 2>/dev/null || true
