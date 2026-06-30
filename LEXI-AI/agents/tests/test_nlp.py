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

    def test_extract_from_file(self):
        result = extract_legal_axioms(self.mock_law_path)
        axioms = json.loads(result)
        self.assertIsInstance(axioms, list)
        self.assertGreater(len(axioms), 0)

    def test_axiom_structure(self):
        result = extract_legal_axioms(self.mock_law_path)
        axioms = json.loads(result)
        for axiom in axioms:
            self.assertIn("id", axiom)
            self.assertIn("source_doc", axiom)
            self.assertIn("rule_type", axiom)
            self.assertIn("condition_variable", axiom)
            self.assertIn("threshold_value", axiom)
            self.assertIn("description", axiom)

    def test_rule_types_present(self):
        result = extract_legal_axioms(self.mock_law_path)
        axioms = json.loads(result)
        types = {a["rule_type"] for a in axioms}
        self.assertIn("Obligation", types)
        self.assertIn("Prohibition", types)
        self.assertIn("Permission", types)

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
        result = extract_legal_axioms(self.mock_law_path)
        axioms = json.loads(result)
        for axiom in axioms:
            self.assertIsInstance(axiom["threshold_value"], int)
            self.assertGreaterEqual(axiom["threshold_value"], 0)


if __name__ == "__main__":
    unittest.main()
