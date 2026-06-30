#!/usr/bin/env python3
"""FastAPI server that exposes the LEXI AI pipeline as a REST API."""
import sys
import os
import json
from fastapi import FastAPI, Query
from fastapi.middleware.cors import CORSMiddleware
import uvicorn

sys.path.insert(0, os.path.join(os.path.dirname(__file__), ".."))
from orchestrator.lexi_pipeline import run_pipeline

app = FastAPI(title="LEXI AI Pipeline API", version="0.1.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.get("/pipeline")
def execute_pipeline(law: str = Query(None, description="Path to legal text file")):
    report = run_pipeline(law_path=law)
    return report


@app.get("/health")
def health():
    return {"status": "ok", "service": "LEXI AI Pipeline"}


def main():
    uvicorn.run(app, host="0.0.0.0", port=8000, log_level="info")


if __name__ == "__main__":
    main()
