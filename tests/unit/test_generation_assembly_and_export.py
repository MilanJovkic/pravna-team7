from __future__ import annotations

import json
from pathlib import Path
from tempfile import TemporaryDirectory
import unittest

from backend.app.application.services.annotation_assembler import AnnotationAssembler
from backend.app.application.services.export_orchestrator import ExportOrchestrator
from backend.app.models.schemas import CaseFacts, CbrResult, ReasoningResponse, RuleReasoningResult


class _FakeExporter:
    def export(self, metadata, annotation, output_file, case_id):
        Path(output_file).write_text(f"{case_id}:{metadata.case_number}:{annotation.case_outcome}", encoding="utf-8")


class TestGenerationAssemblyAndExport(unittest.TestCase):
    def setUp(self):
        self.assembler = AnnotationAssembler()
        self.facts = CaseFacts(
            injury_type="teska tjelesna povreda",
            location="Podgorica",
            weapon="noz",
            weapon_used=True,
            severe_consequence=True,
            death_result=False,
            negligence=False,
            provocation=False,
            fight_participation=False,
            left_without_help=False,
            defendant="P. P.",
        )
        self.reasoning = ReasoningResponse(
            rule_reasoning=RuleReasoningResult(applied_norms=["crime_art151_2"], proofs=[]),
            cbr=CbrResult(matches=[]),
            applied_articles=["151"],
            applied_law_texts=[],
            suggested_verdict="osudjen",
            suggested_sanction="kazna zatvora",
        )

    def test_annotation_assembler_builds_metadata_and_annotation(self):
        metadata = self.assembler.build_metadata(
            case_number="GEN-1",
            court_name="Osnovni sud",
            date_value="2026-03-31",
            judges=["Sudija"],
            facts=self.facts,
            reasoning=self.reasoning,
            verdict_text="Tekst presude",
        )
        annotation = self.assembler.build_structured_annotation(metadata, self.reasoning)
        self.assembler.fill_annotation_defaults(annotation, metadata, self.reasoning)

        self.assertEqual(metadata.article_references, ["Clan 151"])
        self.assertEqual(annotation.case_outcome, "osudjen")
        self.assertIn("Krivicni zakonik Crne Gore", annotation.applied_laws)

    def test_export_orchestrator_writes_xml_and_annotations_index(self):
        with TemporaryDirectory() as tmp_dir:
            orchestrator = ExportOrchestrator(Path(tmp_dir))
            metadata = self.assembler.build_metadata(
                case_number="GEN-2",
                court_name="Osnovni sud",
                date_value="2026-03-31",
                judges=["Sudija"],
                facts=self.facts,
                reasoning=self.reasoning,
                verdict_text="Tekst presude",
            )
            annotation = self.assembler.build_structured_annotation(metadata, self.reasoning)
            self.assembler.fill_annotation_defaults(annotation, metadata, self.reasoning)

            out_file = orchestrator.export(_FakeExporter(), "GEN-2", metadata, annotation)

            self.assertTrue(out_file.exists())
            annotations_index = Path(tmp_dir) / "verdicts_annotations.json"
            self.assertTrue(annotations_index.exists())
            parsed = json.loads(annotations_index.read_text(encoding="utf-8"))
            self.assertIn("GEN-2", parsed)


if __name__ == "__main__":
    unittest.main()