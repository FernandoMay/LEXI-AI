#!/usr/bin/env python3
"""FastAPI server exposing the LEXI AI full audit pipeline as a REST API."""
import sys
import os
import json
from fastapi import FastAPI, Query
from fastapi.middleware.cors import CORSMiddleware
import uvicorn

sys.path.insert(0, os.path.join(os.path.dirname(__file__), ".."))
from orchestrator.lexi_pipeline import run_pipeline

app = FastAPI(title="LEXI AI Pipeline API", version="1.0.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.get("/pipeline")
def execute_pipeline(law: str = Query(None, description="Path to legal text file")):
    return run_pipeline(law_path=law)


@app.get("/report")
def get_report():
    return run_pipeline()


@app.get("/contract")
def get_contract():
    report = run_pipeline()
    return report["contract"]


@app.get("/signatures")
def get_signatures():
    report = run_pipeline()
    return report["signatures"]


@app.get("/agents")
def get_agents():
    report = run_pipeline()
    return report["agents"]


@app.get("/health")
def health():
    return {"status": "ok", "service": "LEXI AI Audit Pipeline v1.0.0"}


def main():
    port = int(os.environ.get("PORT", "8000"))
    uvicorn.run(app, host="0.0.0.0", port=port, log_level="info")


if __name__ == "__main__":
    main()
