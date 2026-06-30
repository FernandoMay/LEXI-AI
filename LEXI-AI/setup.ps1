# LEXI AI - Setup Script for Windows
# Run this from the LEXI-AI/ directory

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  LEXI AI - Setup Script (Windows)" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

# --- Python ---
Write-Host "[1/4] Setting up Python environment..." -ForegroundColor Yellow
if (-not (Test-Path ".venv")) {
    python -m venv .venv
}
.\.venv\Scripts\pip install -r agents\requirements.txt
if ($LASTEXITCODE -ne 0) { Write-Host "Python setup failed!" -ForegroundColor Red; exit 1 }

# --- Rust ---
Write-Host "[2/4] Setting up Rust toolchain..." -ForegroundColor Yellow
rustup default stable 2>$null
if ($LASTEXITCODE -ne 0) {
    rustup toolchain install stable
    rustup default stable
}

# --- Soroban WASM target ---
Write-Host "[3/4] Adding WASM target for Soroban..." -ForegroundColor Yellow
rustup target add wasm32-unknown-unknown

# --- Cargo build ---
Write-Host "[4/4] Building Rust core..." -ForegroundColor Yellow
$env:CARGO_TARGET_DIR = "D:\.cargo\target"
cargo build --release
if ($LASTEXITCODE -ne 0) {
    Write-Host "Rust build failed - check linker availability (MSVC or GNU)" -ForegroundColor Red
    Write-Host "Try: rustup default stable-x86_64-pc-windows-gnu" -ForegroundColor Yellow
    exit 1
}

Write-Host "========================================" -ForegroundColor Green
Write-Host "  LEXI AI setup complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Run: make run-core    - Execute the orchestrator" -ForegroundColor White
Write-Host "Run: make run-nlp     - Test NLP agent standalone" -ForegroundColor White
Write-Host "Run: make flutter-run - Launch the Flutter dashboard" -ForegroundColor White
