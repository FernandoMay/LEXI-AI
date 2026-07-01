#!/usr/bin/env python3
"""
LEXI AI — FastAPI REST Server
Pydantic-validated endpoints with strict input sanitization.
"""
import sys
import os
import re
from typing import Optional
from fastapi import FastAPI, Query, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field, field_validator
import uvicorn

sys.path.insert(0, os.path.join(os.path.dirname(__file__), ".."))
from orchestrator.lexi_pipeline import run_pipeline

app = FastAPI(title="LEXI AI Pipeline API", version="2.0.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)


# ── Strict input models ──────────────────────────────────────────────────────
class PipelineRequest(BaseModel):
    law: Optional[str] = Field(None, description="Path to legal text file")

    @field_validator("law")
    @classmethod
    def sanitize_path(cls, v):
        if v is None:
            return v
        # Block path traversal and shell injection
        if ".." in v or ";" in v or "|" in v or "`" in v or "$" in v:
            raise HTTPException(400, "Invalid path: path traversal or shell metacharacters detected")
        # Only allow alphanumeric, slash, dot, underscore, hyphen
        if not re.match(r"^[\w/\\.\-]+$", v):
            raise HTTPException(400, "Invalid path: only alphanumeric, /, ., -, _ allowed")
        # Verify file exists and is within project tree
        full = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", v))
        project = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
        if not full.startswith(project):
            raise HTTPException(400, "Path escapes project directory")
        if not os.path.isfile(full):
            raise HTTPException(404, f"File not found: {v}")
        return v


class ContextValue(BaseModel):
    key: str = Field(..., pattern=r"^[a-zA-Z_][a-zA-Z0-9_]*$")
    value: (int, float)


# ── Endpoints ────────────────────────────────────────────────────────────────
@app.get("/pipeline")
def execute_pipeline(law: Optional[str] = Query(None, description="Path to legal text file (sanitized)")):
    validated = PipelineRequest(law=law)
    return run_pipeline(law_path=validated.law)


@app.get("/report")
def get_report():
    return run_pipeline()


@app.get("/contract")
def get_contract():
    return run_pipeline()["contract"]


@app.get("/signatures")
def get_signatures():
    return run_pipeline()["signatures"]


@app.get("/agents")
def get_agents():
    return run_pipeline()["agents"]


@app.get("/health")
def health():
    return {"status": "ok", "service": "LEXI AI Audit Pipeline v2.0.0", "version": "2.0.0"}


def main():
    port = int(os.environ.get("PORT", "8000"))
    uvicorn.run(app, host="0.0.0.0", port=port, log_level="info")


if __name__ == "__main__":
    main()
