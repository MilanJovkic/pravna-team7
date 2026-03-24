import unittest
from types import SimpleNamespace
from unittest.mock import patch

from backend.app.models.schemas import CaseFacts, CbrMatch, CbrResult
from backend.app.services.cbr_service import CbrService
from backend.app.services.reasoning_explain_service import ReasoningExplainService
from backend.app.services.verdict_service import VerdictService


class TestOutcomeCanonicalizationPaths(unittest.TestCase):
    def test_reasoning_suggest_verdict_normalizes_cyrillic_cbr_outcome(self):
        service = ReasoningExplainService()
        cbr = CbrResult(matches=[CbrMatch(similarity=0.9, outcome="усвојено")])

        suggested = service.suggest_verdict(norms=[], cbr=cbr)

        self.assertEqual("usvojeno", suggested)

    def test_cbr_query_normalizes_match_outcome(self):
        service = CbrService()
        fake_stdout = (
            '{"matches":[{"case_number":"K-1","similarity":0.81,"outcome":"усвојено",'
            '"feature_contributions":{"injury_type":0.22}}]}'
        )

        with patch.object(service, "_ensure_case_base", return_value=None), patch(
            "backend.app.services.cbr_service.subprocess.run",
            return_value=SimpleNamespace(stdout=fake_stdout),
        ):
            result = service.query(
                CaseFacts(injury_type="teska tjelesna povreda", weapon_used=True),
                top_k=1,
            )

        self.assertEqual("usvojeno", result.matches[0].outcome)

    def test_reasoning_suggest_verdict_ignores_weak_cbr_signal(self):
        service = ReasoningExplainService()
        cbr = CbrResult(matches=[CbrMatch(similarity=0.42, outcome="усвојено")])

        suggested = service.suggest_verdict(norms=[], cbr=cbr)

        self.assertEqual("odbijeno", suggested)

    def test_verdict_override_application_normalizes_outcome(self):
        service = VerdictService()
        metadata = {"outcome": "odbijeno"}

        merged = service._apply_override(metadata, {"outcome": "ослобођен"})

        self.assertEqual("oslobodjen", merged["outcome"])

    def test_sanction_is_fact_aware_for_serious_harm(self):
        service = ReasoningExplainService()
        sanction = service.suggest_sanction(
            ["151"],
            facts=CaseFacts(severe_consequence=True, weapon_used=True),
            verdict="usvojeno",
        )

        self.assertEqual("kazna zatvora 1 do 8 godina (predlog)", sanction)

    def test_sanction_is_empty_when_verdict_is_odbijeno(self):
        service = ReasoningExplainService()
        sanction = service.suggest_sanction(["151"], facts=CaseFacts(severe_consequence=True), verdict="odbijeno")

        self.assertEqual("bez sankcije", sanction)


if __name__ == "__main__":
    unittest.main()
