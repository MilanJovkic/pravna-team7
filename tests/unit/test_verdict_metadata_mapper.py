import unittest

from backend.app.application.mappers.verdict_metadata_mapper import (
    verdict_domain_to_dto,
    verdict_dto_to_domain,
)
from backend.app.domain.verdict.entities import VerdictMetadata as DomainVerdictMetadata


class TestVerdictMetadataMapper(unittest.TestCase):
    def test_domain_to_dto_maps_core_fields(self):
        metadata = DomainVerdictMetadata(
            case_number="K-123/24",
            court_name="Osnovni sud u Podgorici",
            date="2026-03-31",
            judges=["Sudija A"],
            parties={"defendant": ["Ime Prezime"]},
            legal_references=["Krivicni zakonik Crne Gore"],
            article_references=["Clan 151"],
            factual_state={"injury_type": ["teska tjelesna povreda"]},
            raw_text="tekst",
        )

        dto = verdict_domain_to_dto(
            metadata,
            case_id="GEN-1",
            summary="sum",
            outcome="osudjen",
            extraction_confidence=0.91,
        )

        self.assertEqual(dto.case_id, "GEN-1")
        self.assertEqual(dto.case_number, "K-123/24")
        self.assertEqual(dto.court_name, "Osnovni sud u Podgorici")
        self.assertEqual(dto.applied_laws, ["Krivicni zakonik Crne Gore"])
        self.assertEqual(dto.applied_articles, ["Clan 151"])
        self.assertEqual(dto.factual_state.get("injury_type"), ["teska tjelesna povreda"])
        self.assertEqual(dto.outcome, "osudjen")
        self.assertAlmostEqual(dto.extraction_confidence, 0.91)

    def test_dto_to_domain_roundtrip_preserves_domain_relevant_fields(self):
        original = DomainVerdictMetadata(
            case_number="K-777/25",
            court_name="Visi sud",
            date="2026-02-02",
            judges=["Sudija B"],
            parties={"victim": ["NN"]},
            legal_references=["Zakonik o krivicnom postupku"],
            article_references=["Clan 153"],
            factual_state={"location": ["Podgorica"]},
            raw_text="raw",
        )

        dto = verdict_domain_to_dto(original, case_id="GEN-777")
        restored = verdict_dto_to_domain(dto)

        self.assertEqual(restored.case_number, original.case_number)
        self.assertEqual(restored.court_name, original.court_name)
        self.assertEqual(restored.date, original.date)
        self.assertEqual(restored.judges, original.judges)
        self.assertEqual(restored.parties, original.parties)
        self.assertEqual(restored.legal_references, original.legal_references)
        self.assertEqual(restored.article_references, original.article_references)
        self.assertEqual(restored.factual_state, original.factual_state)

    def test_domain_to_dto_uses_safe_defaults(self):
        metadata = DomainVerdictMetadata()

        dto = verdict_domain_to_dto(metadata, case_id="GEN-EMPTY")

        self.assertEqual(dto.case_id, "GEN-EMPTY")
        self.assertEqual(dto.judges, [])
        self.assertEqual(dto.applied_laws, [])
        self.assertEqual(dto.applied_articles, [])
        self.assertEqual(dto.parties, {})
        self.assertEqual(dto.factual_state, {})


if __name__ == "__main__":
    unittest.main()
