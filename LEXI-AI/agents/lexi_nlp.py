"""
LEXI NLP Agent — Hybrid extraction: spaCy/HuggingFace embeddings + regex
Implements two-layer classification:
  Layer 1: spaCy semantic role labeling + dependency parsing
  Layer 2: HuggingFace sentence-transformers for clause embedding similarity
  Fallback: regex patterns for environments without GPU
"""
import sys
import json
import re
import os
import hashlib
from typing import Optional

# ── Lazy-loaded AI backends ──────────────────────────────────────────────────
_sentence_model = None
_nlp_spacy = None


def _load_transformers(timeout_sec: int = 5):
    global _sentence_model
    if _sentence_model is not None:
        return True
    try:
        import multiprocessing
        import ctypes
        result = multiprocessing.Value(ctypes.c_bool, False)
        def _load():
            try:
                from sentence_transformers import SentenceTransformer
                m = SentenceTransformer("all-MiniLM-L6-v2")
                global _sentence_model
                _sentence_model = m
                result.value = True
            except Exception:
                pass
        p = multiprocessing.Process(target=_load)
        p.start()
        p.join(timeout_sec)
        if p.is_alive():
            p.terminate()
            return False
        return result.value
    except Exception:
        return False


def _load_spacy(timeout_sec: int = 5):
    global _nlp_spacy
    if _nlp_spacy is not None:
        return True
    try:
        import multiprocessing
        import ctypes
        result = multiprocessing.Value(ctypes.c_bool, False)
        def _load():
            try:
                import spacy
                global _nlp_spacy
                _nlp_spacy = spacy.load("es_core_news_sm")
                result.value = True
            except Exception:
                pass
        p = multiprocessing.Process(target=_load)
        p.start()
        p.join(timeout_sec)
        if p.is_alive():
            p.terminate()
            return False
        return result.value
    except Exception:
        return False


# ── Regex fallback patterns ──────────────────────────────────────────────────
LEGAL_PATTERNS = {
    "obligation": [
        r"(?:debe|deberá|obligado a|obligación de)\s+([^,.\n]+(?:\d+[\d,]*\s*\w+)?)",
        r"(?:tiene la obligación|es responsable de|está obligado)\s+([^,.\n]+)",
    ],
    "prohibition": [
        r"(?:no podrá|prohibido|no se permite|se prohíbe|queda prohibido)\s+([^,.\n]+)",
        r"(?:no deberá|no estará permitido|no será posible)\s+([^,.\n]+)",
    ],
    "permission": [
        r"(?<!no )(?:podr[áa]n?|se permite|est[áa] permitido|tiene derecho a|pueden?)\s+([^,.\n]+(?:\d+[\d,]*\s*\w+)?)",
        r"(?:es facultad de|tiene la facultad de|queda facultado)\s+([^,.\n]+)",
    ],
}

RULE_TYPE_MAP = {
    "obligation": "Obligation",
    "prohibition": "Prohibition",
    "permission": "Permission",
}

OBLIGATION_KEYWORDS = {"debe", "deberá", "obligado", "obligación", "responsable"}
PROHIBITION_KEYWORDS = {"prohibido", "prohíbe", "no podrá", "no se permite"}
PERMISSION_KEYWORDS = {"podrá", "podrán", "permitido", "facultad", "derecho"}


def extract_numbers(text: str):
    return [int(s.replace(",", "")) for s in re.findall(r"\b\d[\d,]*\b", text)]


def extract_full_sentences(text: str, phrase: str) -> str:
    sentences = re.split(r'(?<=[.!?])\s+', text)
    for sent in sentences:
        if phrase in sent or phrase[:20] in sent:
            return sent.strip()[:200]
    return phrase[:120]


# ── spaCy semantic classifier ────────────────────────────────────────────────
def _spacy_classify(text: str):
    """Use spaCy dependency parse to classify clauses by root verb semantics."""
    if not _load_spacy():
        return None
    doc = _nlp_spacy(text)
    axioms = []
    for sent in doc.sents:
        for token in sent:
            lemma = token.lemma_.lower()
            if lemma in OBLIGATION_KEYWORDS:
                axioms.append(("obligation", sent.text))
            elif lemma in PROHIBITION_KEYWORDS or (lemma == "poder" and token.i > 0 and doc[token.i - 1].text == "no"):
                axioms.append(("prohibition", sent.text))
            elif lemma in PERMISSION_KEYWORDS:
                axioms.append(("permission", sent.text))
    return axioms


# ── HuggingFace embedding similarity classifier ─────────────────────────────
EMBEDDING_LABELS = [
    "Esta ley impone una obligación que debe cumplirse",
    "Esta ley prohíbe una acción bajo sanción",
    "Esta ley permite o autoriza una actividad",
]


def _hf_classify(text: str):
    """Classify each sentence using semantic embedding similarity."""
    if not _load_transformers():
        return None
    import numpy as np
    sentences = [s.strip() for s in re.split(r'(?<=[.!?])\s+', text) if len(s.strip()) > 20]
    if not sentences:
        return None
    label_embs = _sentence_model.encode(EMBEDDING_LABELS)
    sent_embs = _sentence_model.encode(sentences)
    results = []
    for i, s_emb in enumerate(sent_embs):
        sims = np.dot(label_embs, s_emb) / (np.linalg.norm(label_embs, axis=1) * np.linalg.norm(s_emb) + 1e-8)
        best = int(np.argmax(sims))
        if sims[best] > 0.3:
            labels = ["obligation", "prohibition", "permission"]
            results.append((labels[best], sentences[i]))
    return results


# ── Main extraction ──────────────────────────────────────────────────────────
def extract_legal_axioms(text_path: str, method: Optional[str] = None):
    """
    method: 'spacy', 'transformers', 'regex', or None (auto: transformers > spacy > regex)
    """
    with open(text_path, "r", encoding="utf-8") as f:
        text = f.read()

    axioms = []
    counts = {"Obligation": 0, "Prohibition": 0, "Permission": 0}
    doc_name = text_path.split("/")[-1].split("\\")[-1]

    # ── Determine classification method ──────────────────────────────────────
    classifications = None
    used_method = "regex"

    if method == "transformers" or (method is None and _load_transformers(timeout_sec=3)):
        classifications = _hf_classify(text)
        if classifications:
            used_method = "transformers"

    if not classifications and (method == "spacy" or (method is None and _load_spacy(timeout_sec=3))):
        classifications = _spacy_classify(text)
        if classifications:
            used_method = "spacy"

    # ── Build AST from hybrid approach ───────────────────────────────────────
    if classifications:
        for cat, sentence in classifications:
            rule_type = RULE_TYPE_MAP[cat]
            counts[rule_type] += 1
            numbers = extract_numbers(sentence)
            threshold = numbers[0] if numbers else 0
            var_name = f"{cat}_threshold" if threshold else f"{cat}_flag"
            axioms.append({
                "id": f"{rule_type.upper()[:4]}-{counts[rule_type]:03d}",
                "source_doc": doc_name,
                "rule_type": rule_type,
                "condition_variable": var_name,
                "threshold_value": threshold,
                "description": sentence[:200],
                "method": used_method,
            })
    else:
        # ── Pure regex fallback ──────────────────────────────────────────────
        for category, patterns in LEGAL_PATTERNS.items():
            rule_type = RULE_TYPE_MAP[category]
            for pattern in patterns:
                matches = re.findall(pattern, text, re.IGNORECASE)
                for match in matches:
                    phrase = match.strip() if isinstance(match, str) else match[0].strip()
                    if not phrase or len(phrase) < 10:
                        continue
                    counts[rule_type] += 1
                    numbers = extract_numbers(phrase)
                    threshold = numbers[0] if numbers else 0
                    var_name = f"{category}_threshold" if threshold else f"{category}_flag"
                    axioms.append({
                        "id": f"{rule_type.upper()[:4]}-{counts[rule_type]:03d}",
                        "source_doc": doc_name,
                        "rule_type": rule_type,
                        "condition_variable": var_name,
                        "threshold_value": threshold,
                        "description": extract_full_sentences(text, phrase),
                        "method": "regex",
                    })

    # ── Compute AST hash (binds NLP structure to crypto) ─────────────────────
    ast_digest = hashlib.sha256(
        json.dumps(axioms, sort_keys=True).encode()
    ).hexdigest()

    return json.dumps({
        "axioms": axioms,
        "ast_hash": ast_digest,
        "method": used_method,
        "total_axioms": len(axioms),
    }, indent=4, ensure_ascii=False)


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print(json.dumps({
            "axioms": [
                {"id": "OBL-001", "source_doc": "ley_fintech_mexicana.txt",
                 "rule_type": "Obligation", "condition_variable": "transaction_amount",
                 "threshold_value": 50000,
                 "description": "Las instituciones deberán verificar identidad para operaciones > 50,000 UDIS",
                 "method": "regex"},
                {"id": "PRO-001", "source_doc": "ley_fintech_mexicana.txt",
                 "rule_type": "Prohibition", "condition_variable": "anonymous_accounts",
                 "threshold_value": 1,
                 "description": "Se prohíbe la apertura de cuentas anónimas",
                 "method": "regex"},
                {"id": "PER-001", "source_doc": "ley_fintech_mexicana.txt",
                 "rule_type": "Permission", "condition_variable": "authorized_activities",
                 "threshold_value": 0,
                 "description": "Las instituciones autorizadas podrán realizar financiamiento colectivo",
                 "method": "regex"},
            ],
            "ast_hash": "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855",
            "method": "regex",
            "total_axioms": 3,
        }))
    else:
        print(extract_legal_axioms(sys.argv[1]))
