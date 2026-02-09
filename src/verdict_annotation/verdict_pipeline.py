"""Pipeline orchestration for verdict annotation workflow."""
from pathlib import Path
from typing import Dict, Optional

from .pdf_extractor import PDFExtractor
from .verdict_parser import VerdictParser, VerdictMetadata
from .verdict_annotator import VerdictAnnotator, VerdictAnnotation
from .verdict_exporter import VerdictAkomaExporter


class VerdictAnnotationPipeline:
    """Orchestrates PDF extraction, parsing, annotation, and XML export for verdicts."""

    def __init__(
        self,
        pdf_folder: str,
        output_xml_dir: str,
        output_json: Optional[str] = None,
        api_token: Optional[str] = None,
        model: str = "gpt-5-nano",
        provider: str = "openai",
        limit: Optional[int] = None
    ):
        self.pdf_folder = Path(pdf_folder)
        self.output_xml_dir = Path(output_xml_dir)
        self.output_json = output_json or str(self.output_xml_dir / "verdicts_annotations.json")
        self.limit = limit

        self.pdf_extractor = PDFExtractor()
        self.parser = VerdictParser()
        self.annotator = VerdictAnnotator(api_token=api_token, model=model, provider=provider)
        self.exporter = VerdictAkomaExporter()

        print("=" * 70)
        print("ANOTACIJA SUDSKIH PRESUDA (Zadatak 2)")
        print("=" * 70)
        print(f"PDF folder:  {pdf_folder}")
        print(f"XML output:  {output_xml_dir}")
        print(f"Provider:    {provider}")
        print(f"Model:       {model}")
        if limit:
            print(f"Limit:       {limit} presuda (test mode)")
        print("=" * 70)

    def run(self) -> bool:
        """Executes the full verdict annotation pipeline."""
        try:
            print("\n[FAZA 1/4] Ekstrakcija teksta iz PDF fajlova...")
            texts = self._extract_pdfs()

            if not texts:
                print("✗ Greška: Nema ekstraktovanih tekstova.")
                return False

            print("\n[FAZA 2/4] Parsiranje strukture presuda...")
            verdicts = self._parse_verdicts(texts)

            if not verdicts:
                print("✗ Greška: Nijedna presuda nije parsovana.")
                return False

            print("\n[FAZA 3/4] LLM semantička anotacija presuda...")
            annotations = self._annotate_verdicts(verdicts)

            print("\n[FAZA 4/4] Generisanje Akoma Ntoso XML fajlova...")
            self._export_results(verdicts, annotations)

            self._print_statistics(verdicts, annotations)

            print("\n" + "=" * 70)
            print("✓ PIPELINE ZAVRŠEN USPEŠNO")
            print("=" * 70)
            return True

        except KeyboardInterrupt:
            print("\n\n⚠ Pipeline prekinut (Ctrl+C)")
            return False

        except Exception as exc:
            print(f"\n✗ KRITIČNA GREŠKA: {exc}")
            import traceback
            traceback.print_exc()
            return False

    def _extract_pdfs(self) -> Dict[str, str]:
        """Phase 1: Extract text from PDF files."""
        texts = self.pdf_extractor.extract_from_folder(self.pdf_folder)
        
        # Apply limit if set
        if self.limit:
            items = list(texts.items())[:self.limit]
            texts = dict(items)
            print(f"\n  → Procesiraće se {len(texts)} presuda (limit primenjen)")
        
        print(f"\n  ✓ Ekstrahovano {len(texts)} tekstova")
        return texts

    def _parse_verdicts(self, texts: Dict[str, str]) -> Dict[str, VerdictMetadata]:
        """Phase 2: Parse verdict structure and metadata."""
        verdicts = self.parser.parse_batch(texts)
        
        success_count = sum(1 for v in verdicts.values() if v.case_number)
        print(f"\n  ✓ Parsovano {success_count}/{len(verdicts)} presuda")
        return verdicts

    def _annotate_verdicts(self, verdicts: Dict[str, VerdictMetadata]) -> Dict[str, VerdictAnnotation]:
        """Phase 3: LLM annotation of verdicts."""
        # Prepare texts for annotation
        texts_for_annotation = {
            case_id: metadata.raw_text
            for case_id, metadata in verdicts.items()
        }
        
        annotations = self.annotator.annotate_batch(texts_for_annotation)
        
        if texts_for_annotation:
            success_rate = len(annotations) / len(texts_for_annotation) * 100
            print(f"\n  ✓ Anotirano: {len(annotations)}/{len(texts_for_annotation)} ({success_rate:.1f}% uspešnosti)")
        
        return annotations

    def _export_results(
        self,
        verdicts: Dict[str, VerdictMetadata],
        annotations: Dict[str, VerdictAnnotation]
    ) -> None:
        """Phase 4: Export to Akoma Ntoso XML and JSON."""
        xml_files = self.exporter.export_batch(verdicts, annotations, str(self.output_xml_dir))
        print(f"\n  ✓ Generirano {len(xml_files)} XML fajlova")
        
        if annotations:
            self.exporter.export_annotations_json(annotations, self.output_json)

    def _print_statistics(
        self,
        verdicts: Dict[str, VerdictMetadata],
        annotations: Dict[str, VerdictAnnotation]
    ) -> None:
        """Prints detailed statistics."""
        print("\n" + "=" * 70)
        print("STATISTIKA PRESUDA")
        print("=" * 70)

        print(f"Ukupno presuda: {len(verdicts)}")
        
        # Metadata statistics
        with_court = sum(1 for v in verdicts.values() if v.court_name)
        with_date = sum(1 for v in verdicts.values() if v.date)
        with_judges = sum(1 for v in verdicts.values() if v.judges)
        total_article_refs = sum(len(v.article_references) for v in verdicts.values())
        
        print("\nMetadata:")
        print(f"  - Sa nazivom suda:        {with_court}")
        print(f"  - Sa datumom:             {with_date}")
        print(f"  - Sa sudijama:            {with_judges}")
        print(f"  - Ukupno referenci:       {total_article_refs}")

        if not annotations:
            print("\nNema semantičkih anotacija.")
            print("=" * 70)
            return

        # Annotation statistics
        outcomes = {}
        all_concepts = set()
        applied_laws_count = {}
        
        for ann in annotations.values():
            outcomes[ann.case_outcome] = outcomes.get(ann.case_outcome, 0) + 1
            all_concepts.update(ann.legal_concepts)
            for law in ann.applied_laws:
                applied_laws_count[law] = applied_laws_count.get(law, 0) + 1

        print(f"\nSemantička anotacija:")
        print(f"  - Anotirano presuda:      {len(annotations)}")
        print("\nIshodi predmeta:")
        for outcome, count in sorted(outcomes.items(), key=lambda x: -x[1]):
            print(f"  - {outcome}: {count}")

        print(f"\nUkupno pravnih koncepata: {len(all_concepts)}")
        
        if applied_laws_count:
            print("\nNajčešće primenjeni zakoni:")
            for law, count in sorted(applied_laws_count.items(), key=lambda x: -x[1])[:5]:
                print(f"  - {law}: {count}x")

        print("=" * 70)
