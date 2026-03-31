import unittest

from backend.app.services.rule_reasoning_service import RuleReasoningService


class TestRuleNormConflicts(unittest.TestCase):
    def setUp(self):
        self.service = RuleReasoningService()

    def test_higher_priority_homicide_norm_wins(self):
        norms = ["crime_art143", "crime_art144", "crime_art147"]
        resolved = self.service._resolve_norm_conflicts(norms)
        self.assertEqual(["crime_art147"], resolved)

    def test_higher_priority_injury_norm_wins(self):
        norms = ["crime_art151_1", "crime_art151_2", "crime_art151_4"]
        resolved = self.service._resolve_norm_conflicts(norms)
        self.assertEqual(["crime_art151_4"], resolved)

    def test_non_conflicting_norms_are_preserved(self):
        norms = ["crime_art151a", "crime_art150", "crime_art152_2"]
        resolved = self.service._resolve_norm_conflicts(norms)
        self.assertEqual(["crime_art150", "crime_art151a", "crime_art152_2"], resolved)


if __name__ == "__main__":
    unittest.main()
