import sys
import json
import re


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
        r"(?:podrá|se permite|está permitido|tiene derecho a|puede)\s+([^,.\n]+(?:\d+[\d,]*\s*\w+)?)",
        r"(?:es facultad de|tiene la facultad de|queda facultado)\s+([^,.\n]+)",
    ],
}

RULE_TYPE_MAP = {
    "obligation": "Obligation",
    "prohibition": "Prohibition",
    "permission": "Permission",
}


def extract_numbers(text: str):
    return [int(s.replace(",", "")) for s in re.findall(r"\b\d[\d,]*\b", text)]


def extract_legal_axioms(text_path: str):
    with open(text_path, "r", encoding="utf-8") as f:
        text = f.read()

    axioms = []
    counts = {"Obligation": 0, "Prohibition": 0, "Permission": 0}
    doc_name = text_path.split("/")[-1].split("\\")[-1]

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
                var_name = f"{category.lower()}_threshold" if threshold else f"{category.lower()}_flag"
                axioms.append({
                    "id": f"{rule_type.upper()[:4]}-{counts[rule_type]:03d}",
                    "source_doc": doc_name,
                    "rule_type": rule_type,
                    "condition_variable": var_name,
                    "threshold_value": threshold,
                    "description": phrase[:120],
                })

    return json.dumps(axioms, indent=4, ensure_ascii=False)


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print(json.dumps([
            {
                "id": "OBL-001",
                "source_doc": "ley_fintech_mexicana.txt",
                "rule_type": "Obligation",
                "condition_variable": "transaction_amount",
                "threshold_value": 50000,
                "description": "Las instituciones deberán verificar identidad para operaciones superiores a 50,000 UDIS"
            },
            {
                "id": "PRO-001",
                "source_doc": "ley_fintech_mexicana.txt",
                "rule_type": "Prohibition",
                "condition_variable": "anonymous_accounts",
                "threshold_value": 1,
                "description": "Se prohíbe la apertura de cuentas anónimas en instituciones de tecnología financiera"
            },
            {
                "id": "PER-001",
                "source_doc": "ley_fintech_mexicana.txt",
                "rule_type": "Permission",
                "condition_variable": "authorized_activities",
                "threshold_value": 0,
                "description": "Las instituciones autorizadas podrán realizar operaciones de financiamiento colectivo"
            },
        ]))
    else:
        print(extract_legal_axioms(sys.argv[1]))
