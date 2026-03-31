import unittest

from backend.app.models.schemas import CaseFacts
from backend.app.services.case_service import CaseService


class _FakeCaseRepository:
    def __init__(self):
        self._records = []

    def find_existing_case(self, facts, outcome, verdict_type, sanction):
        for row in self._records:
            if (
                row["facts"].injury_type == facts.injury_type
                and row["facts"].location == facts.location
                and row["facts"].weapon == facts.weapon
                and row["facts"].weapon_used == facts.weapon_used
                and row["facts"].severe_consequence == facts.severe_consequence
                and row["facts"].death_result == facts.death_result
                and row["facts"].negligence == facts.negligence
                and row["facts"].provocation == facts.provocation
                and row["facts"].fight_participation == facts.fight_participation
                and row["facts"].fight_consequence == facts.fight_consequence
                and row["facts"].left_without_help == facts.left_without_help
                and row["outcome"] == outcome
                and row["verdict_type"] == verdict_type
                and row["sanction"] == sanction
            ):
                return row["id"], row["case_number"]
        return None

    def next_version(self, facts):
        count = 0
        for row in self._records:
            if (
                row["facts"].injury_type == facts.injury_type
                and row["facts"].location == facts.location
                and row["facts"].weapon == facts.weapon
                and row["facts"].weapon_used == facts.weapon_used
                and row["facts"].severe_consequence == facts.severe_consequence
                and row["facts"].death_result == facts.death_result
                and row["facts"].negligence == facts.negligence
                and row["facts"].provocation == facts.provocation
                and row["facts"].fight_participation == facts.fight_participation
                and row["facts"].fight_consequence == facts.fight_consequence
                and row["facts"].left_without_help == facts.left_without_help
            ):
                count += 1
        return count + 1

    def insert_case(self, payload):
        case_id = len(self._records) + 1
        self._records.append(
            {
                "id": case_id,
                "case_number": payload.case_number,
                "facts": payload.facts,
                "outcome": payload.outcome,
                "verdict_type": payload.verdict_type,
                "sanction": payload.sanction,
            }
        )
        return case_id, payload.case_number


class TestCaseServiceRepositoryPort(unittest.TestCase):
    def test_reuses_existing_case_if_same_signature(self):
        repo = _FakeCaseRepository()
        service = CaseService(repository=repo)
        facts = CaseFacts(injury_type="teska tjelesna povreda", location="Podgorica", weapon="noz")

        first = service.insert_case(
            facts=facts,
            outcome="osudjen",
            case_number="USER-CASE",
            verdict_type="osudjujuca",
            sanction="zatvor",
        )
        second = service.insert_case(
            facts=facts,
            outcome="osudjen",
            case_number="USER-CASE",
            verdict_type="osudjujuca",
            sanction="zatvor",
        )

        self.assertFalse(first["reused_existing"])
        self.assertTrue(second["reused_existing"])
        self.assertEqual(first["id"], second["id"])

    def test_appends_version_suffix_when_signature_exists(self):
        repo = _FakeCaseRepository()
        service = CaseService(repository=repo)
        facts = CaseFacts(injury_type="teska tjelesna povreda", location="Niksic", weapon="palica")

        first = service.insert_case(
            facts=facts,
            outcome="osudjen",
            case_number="USER-ABC",
            verdict_type="osudjujuca",
            sanction="zatvor",
        )
        second = service.insert_case(
            facts=CaseFacts(
                injury_type="teska tjelesna povreda",
                location="Niksic",
                weapon="palica",
            ),
            outcome="oslobodjen",
            case_number="USER-ABC",
            verdict_type="oslobadjajuca",
            sanction="",
        )

        self.assertEqual(1, first["version"])
        self.assertEqual(2, second["version"])
        self.assertTrue(second["case_number"].endswith("-v2"))


if __name__ == "__main__":
    unittest.main()
