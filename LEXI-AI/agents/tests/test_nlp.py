import json
import sys
import os
import unittest

sys.path.insert(0, os.path.join(os.path.dirname(__file__), ".."))
from lexi_nlp import extract_legal_axioms


class TestLexiNLP(unittest.TestCase):

    def setUp(self):
        self.mock_law_path = os.path.join(
            os.path.dirname(__file__), "..", "mock_laws", "ley_prueba.txt"
        )

    def _load(self, path=None):
        return json.loads(extract_legal_axioms(path or self.mock_law_path, method='regex'))

    def test_extract_from_file(self):
        result = self._load()
        self.assertIn("axioms", result)
        self.assertIn("ast_hash", result)
        self.assertIn("method", result)
        self.assertGreater(result["total_axioms"], 0)
        self.assertEqual(len(result["axioms"]), result["total_axioms"])

    def test_axiom_structure(self):
        result = self._load()
        for axiom in result["axioms"]:
            self.assertIn("id", axiom)
            self.assertIn("source_doc", axiom)
            self.assertIn("rule_type", axiom)
            self.assertIn("condition_variable", axiom)
            self.assertIn("threshold_value", axiom)
            self.assertIn("description", axiom)
            self.assertIn("method", axiom)

    def test_rule_types_present(self):
        result = self._load()
        types = {a["rule_type"] for a in result["axioms"]}
        self.assertIn("Obligation", types)
        self.assertIn("Prohibition", types)
        self.assertIn("Permission", types)

    def test_ast_hash_format(self):
        result = self._load()
        h = result["ast_hash"]
        self.assertEqual(len(h), 64)
        int(h, 16)

    def test_mock_fallback(self):
        import lexi_nlp
        original_argv = sys.argv
        sys.argv = [lexi_nlp.__file__]
        try:
            lexi_nlp.extract_legal_axioms("nonexistent.txt")
        except FileNotFoundError:
            pass
        finally:
            sys.argv = original_argv

    def test_threshold_values(self):
        result = self._load()
        for axiom in result["axioms"]:
            self.assertIsInstance(axiom["threshold_value"], int)
            self.assertGreaterEqual(axiom["threshold_value"], 0)

    def test_method_field(self):
        result = self._load()
        for axiom in result["axioms"]:
            self.assertIn(axiom["method"], ("regex", "spacy", "transformers"))

    def test_ast_hash_deterministic(self):
        path = self.mock_law_path
        r1 = json.loads(extract_legal_axioms(path, method='regex'))
        r2 = json.loads(extract_legal_axioms(path, method='regex'))
        self.assertEqual(r1["ast_hash"], r2["ast_hash"])


if __name__ == "__main__":
    unittest.main()
