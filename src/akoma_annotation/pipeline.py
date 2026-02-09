"""Pipeline orchestration for Akoma annotation flow."""
from pathlib import Path
from typing import Dict, List, Optional

from .annotator import LLMAnnotator, SemanticAnnotation
from .exporter import AkomaExporter
from .parser import LegalChapter, LegalTextParser


class AnnotationPipeline:
    """Orchestrates parsing, annotation, and XML export."""

    def __init__(
        self,
        input_file: str,
        output_xml: str,
        output_json: Optional[str] = None,
        api_token: Optional[str] = None,
        model: str = "gpt-5-nano",
        provider: str = "openai",
        article_limit: Optional[int] = None
    ):
        self.input_file = input_file
        self.output_xml = output_xml
        self.output_json = output_json or output_xml.replace('.xml', '_annotations.json')
        self.article_limit = article_limit

        self.parser = LegalTextParser()
        self.annotator = LLMAnnotator(api_token=api_token, model=model, provider=provider)
        self.exporter = AkomaExporter()

        print("=" * 70)
        print("AUTOMATSKA ANOTACIJA KRIVIČNOG ZAKONIKA")
        print("=" * 70)
        print(f"Input:    {input_file}")
        print(f"Output:   {output_xml}")
        print(f"Provider: {provider}")
        print(f"Model:    {model}")
        if article_limit:
            print(f"Limit:    {article_limit} članaka (test mode)")
        print("=" * 70)

    def run(self) -> bool:
        """Executes the full annotation pipeline."""
        try:
            print("\n[FAZA 1/3] Parsiranje zakona...")
            chapters = self._parse_law()

            if not chapters:
                print("✗ Greška: Nijedan član nije parsovan.")
                return False

            print("\n[FAZA 2/3] LLM semantička anotacija...")
            annotations = self._annotate_articles(chapters)

            print("\n[FAZA 3/3] Generisanje AKOMA Ntoso XML-a...")
            self._export_results(chapters, annotations)
            self._print_statistics(chapters, annotations)

            print("\n" + "=" * 70)
            print("✓ PIPELINE ZAVRŠEN USPEŠNO")
            print("=" * 70)
            return True

        except KeyboardInterrupt:
            print("\n\n⚠ Pipeline prekinut od strane korisnika (Ctrl+C)")
            print("Delimični rezultati mogu biti sačuvani.")
            return False

        except Exception as exc:
            print(f"\n✗ KRITIČNA GREŠKA: {exc}")
            import traceback
            traceback.print_exc()
            return False

    def _parse_law(self) -> List[LegalChapter]:
        with open(self.input_file, "r", encoding="utf-8") as f:
            text = f.read()

        chapters = self.parser.parse(text)
        total_articles = sum(len(ch.articles) for ch in chapters)
        print(f"  ✓ Parsovano: {len(chapters)} glava, {total_articles} članaka")
        return chapters

    def _annotate_articles(self, chapters: List[LegalChapter]) -> Dict[str, SemanticAnnotation]:
        all_articles = self.parser.get_all_articles(chapters)

        if self.article_limit:
            all_articles = all_articles[:self.article_limit]
            print(f"  → Procesiraće se {len(all_articles)} članaka (limit primenjen)")

        articles_batch = [
            (art.number, self.parser.get_article_full_text(art))
            for art in all_articles
        ]

        annotations = self.annotator.annotate_batch(articles_batch)

        if articles_batch:
            success_rate = len(annotations) / len(articles_batch) * 100
            print(f"\n  ✓ Anotirano: {len(annotations)}/{len(articles_batch)} ({success_rate:.1f}% uspešnosti)")

        return annotations

    def _export_results(self, chapters: List[LegalChapter], annotations: Dict[str, SemanticAnnotation]) -> None:
        output_xml_path = Path(self.output_xml)
        output_xml_path.parent.mkdir(parents=True, exist_ok=True)

        output_json_path = Path(self.output_json)
        output_json_path.parent.mkdir(parents=True, exist_ok=True)

        self.exporter.export(chapters, annotations, self.output_xml)
        if annotations:
            self.exporter.export_annotations_json(annotations, self.output_json)

    def _print_statistics(self, chapters: List[LegalChapter], annotations: Dict[str, SemanticAnnotation]) -> None:
        print("\n" + "=" * 70)
        print("STATISTIKA ANOTACIJE")
        print("=" * 70)

        total_articles = sum(len(ch.articles) for ch in chapters)
        total_paragraphs = sum(
            len(art.paragraphs)
            for ch in chapters
            for art in ch.articles
        )

        print("Struktura:")
        print(f"  - Glave:      {len(chapters)}")
        print(f"  - Članaka:    {total_articles}")
        print(f"  - Paragrafa:  {total_paragraphs}")

        if not annotations:
            print("\nNema semantičkih anotacija za prikaz.")
            print("=" * 70)
            return

        norm_types = {}
        all_concepts = set()
        aggravated_count = 0

        for ann in annotations.values():
            norm_types[ann.norm_type] = norm_types.get(ann.norm_type, 0) + 1
            all_concepts.update(ann.legal_concepts)
            if ann.qualifiers.get("aggravated"):
                aggravated_count += 1

        print("\nSemantika:")
        print(f"  - Anotirano:  {len(annotations)}/{total_articles} članaka")
        print("\nTipovi normi:")
        for norm_type, count in sorted(norm_types.items(), key=lambda x: -x[1]):
            print(f"  - {norm_type}: {count}")

        print(f"\nUkupno pravnih koncepata: {len(all_concepts)}")
        print(f"Kvalifikovanih dela: {aggravated_count}")

        concept_freq = {}
        for ann in annotations.values():
            for concept in ann.legal_concepts:
                concept_freq[concept] = concept_freq.get(concept, 0) + 1

        if concept_freq:
            print("\nNajčešći koncepti:")
            for concept, count in sorted(concept_freq.items(), key=lambda x: -x[1])[:10]:
                print(f"  - {concept}: {count}x")

        print("=" * 70)
