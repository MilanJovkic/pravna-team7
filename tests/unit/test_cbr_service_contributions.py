import unittest
from types import SimpleNamespace
from unittest.mock import patch

from backend.app.models.schemas import CaseFacts
from backend.app.services.cbr_service import CbrService


class TestCbrServiceContributions(unittest.TestCase):
    def test_query_parses_feature_contributions(self):
        service = CbrService()
        fake_stdout = (
            '{"matches":[{"case_number":"K-1","similarity":0.81,"outcome":"osudjen",'
            '"feature_contributions":{"injury_type":0.22,"location":0.08}}]}'
        )

        with patch.object(service, "_ensure_case_base", return_value=None), patch(
            "backend.app.services.cbr_service.subprocess.run",
            return_value=SimpleNamespace(stdout=fake_stdout),
        ):
            result = service.query(
                CaseFacts(
                    injury_type="teska tjelesna povreda",
                    location="mostar",
                    weapon="noz",
                    weapon_used=True,
                ),
                top_k=1,
            )

        self.assertEqual(1, len(result.matches))
        match = result.matches[0]
        self.assertEqual("K-1", match.case_number)
        self.assertIn("injury_type", match.feature_contributions)
        self.assertGreater(match.feature_contributions["injury_type"], 0.0)


if __name__ == "__main__":
    unittest.main()
