"""
Glavni orchestrator skript za automatsku anotaciju krivičnog zakonika.

Pipeline:
1. Parse zakona (legal_parser)
2. LLM anotacija (llm_annotator)
3. XML export (akoma_exporter)

Usage:
    python main.py --input zakon.txt --output output.xml --limit 10
"""

import argparse
import sys
from pathlib import Path
from typing import Optional

from legal_parser import LegalTextParser
from llm_annotator import LLMAnnotator
from akoma_exporter import AkomaExporter


class AnnotationPipeline:
    """
    Glavni orchestrator koji koordinira sve faze anotacije.
    
    Dizajniran za produkcijsku upotrebu:
    - Inkrementalno procesiranje (može se prekinuti i nastaviti)
    - Error handling sa detaljnim logovima
    - Konfigurabilnost (batch size, rate limiting)
    """
    
    def __init__(
        self,
        input_file: str,
        output_xml: str,
        output_json: Optional[str] = None,
        api_token: Optional[str] = None,
        model: str = "gpt-4o",
        provider: str = "github",
        article_limit: Optional[int] = None
    ):
        """
        Inicijalizacija pipeline-a.
        
        Args:
            input_file: Putanja do zakon.txt fajla
            output_xml: Putanja do izlaznog AKOMA XML fajla
            output_json: Putanja do izlaznog JSON fajla sa anotacijama (opciono)
            api_token: API token (GitHub ili OpenRouter)
            model: LLM model
            provider: "github" ili "openrouter"
            article_limit: Limit broja članaka za procesiranje (za testiranje)
        """
        self.input_file = input_file
        self.output_xml = output_xml
        self.output_json = output_json or output_xml.replace('.xml', '_annotations.json')
        self.article_limit = article_limit
        
        # Inicijalizuj komponente
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
        """
        Pokreće kompletan pipeline.
        
        Returns:
            True ako je uspešno, False ako je došlo do greške
        """
        try:
            # FAZA 1: Parsiranje
            print("\n[FAZA 1/3] Parsiranje zakona...")
            chapters = self._parse_law()
            
            if not chapters:
                print("✗ Greška: Nijedan član nije parsovan.")
                return False
            
            # FAZA 2: LLM anotacija
            print("\n[FAZA 2/3] LLM semantička anotacija...")
            annotations = self._annotate_articles(chapters)
            
            if not annotations:
                print("⚠ Upozorenje: Nijedan član nije anotiran.")
                # Nastavi sa export-om bez anotacija
            
            # FAZA 3: XML export
            print("\n[FAZA 3/3] Generisanje AKOMA Ntoso XML-a...")
            self._export_results(chapters, annotations)
            
            # Statistika
            self._print_statistics(chapters, annotations)
            
            print("\n" + "=" * 70)
            print("✓ PIPELINE ZAVRŠEN USPEŠNO")
            print("=" * 70)
            
            return True
        
        except KeyboardInterrupt:
            print("\n\n⚠ Pipeline prekinut od strane korisnika (Ctrl+C)")
            print("Delimični rezultati mogu biti sačuvani.")
            return False
        
        except Exception as e:
            print(f"\n✗ KRITIČNA GREŠKA: {e}")
            import traceback
            traceback.print_exc()
            return False
    
    def _parse_law(self):
        """Faza 1: Parsiranje pravnog teksta."""
        with open(self.input_file, "r", encoding="utf-8") as f:
            text = f.read()
        
        chapters = self.parser.parse(text)
        
        total_articles = sum(len(ch.articles) for ch in chapters)
        print(f"  ✓ Parsovano: {len(chapters)} glava, {total_articles} članaka")
        
        return chapters
    
    def _annotate_articles(self, chapters):
        """Faza 2: LLM anotacija članaka."""
        # Prikupi sve članke
        all_articles = self.parser.get_all_articles(chapters)
        
        # Primeni limit ako je postavljen
        if self.article_limit:
            all_articles = all_articles[:self.article_limit]
            print(f"  → Procesiraće se {len(all_articles)} članaka (limit primenjen)")
        
        # Pripremi batch
        articles_batch = [
            (art.number, self.parser.get_article_full_text(art))
            for art in all_articles
        ]
        
        # LLM batch anotacija (rate limiting je automatski)
        annotations = self.annotator.annotate_batch(articles_batch)
        
        success_rate = len(annotations) / len(articles_batch) * 100
        print(f"\n  ✓ Anotirano: {len(annotations)}/{len(articles_batch)} "
              f"({success_rate:.1f}% uspešnosti)")
        
        return annotations
    
    def _export_results(self, chapters, annotations):
        """Faza 3: Export rezultata u XML i JSON."""
        # XML export
        self.exporter.export(chapters, annotations, self.output_xml)
        
        # JSON export (za validaciju)
        if annotations:
            self.exporter.export_annotations_json(annotations, self.output_json)
    
    def _print_statistics(self, chapters, annotations):
        """Ispisuje detaljnu statistiku anotacije."""
        print("\n" + "=" * 70)
        print("STATISTIKA ANOTACIJE")
        print("=" * 70)
        
        # Strukturna statistika
        total_articles = sum(len(ch.articles) for ch in chapters)
        total_paragraphs = sum(
            len(art.paragraphs)
            for ch in chapters
            for art in ch.articles
        )
        
        print(f"Struktura:")
        print(f"  - Glave:      {len(chapters)}")
        print(f"  - Članaka:    {total_articles}")
        print(f"  - Paragrafa:  {total_paragraphs}")
        
        # Semantička statistika
        if annotations:
            norm_types = {}
            all_concepts = set()
            aggravated_count = 0
            
            for ann in annotations.values():
                norm_types[ann.norm_type] = norm_types.get(ann.norm_type, 0) + 1
                all_concepts.update(ann.legal_concepts)
                if ann.qualifiers.get("aggravated"):
                    aggravated_count += 1
            
            print(f"\nSemantika:")
            print(f"  - Anotirano:  {len(annotations)}/{total_articles} članaka")
            print(f"\nTipovi normi:")
            for norm_type, count in sorted(norm_types.items(), key=lambda x: -x[1]):
                print(f"  - {norm_type}: {count}")
            
            print(f"\nUkupno pravnih koncepata: {len(all_concepts)}")
            print(f"Kvalifikovanih dela: {aggravated_count}")
            
            # Top 10 koncepata
            concept_freq = {}
            for ann in annotations.values():
                for concept in ann.legal_concepts:
                    concept_freq[concept] = concept_freq.get(concept, 0) + 1
            
            if concept_freq:
                print("\nNajčešći koncepti:")
                for concept, count in sorted(concept_freq.items(), key=lambda x: -x[1])[:10]:
                    print(f"  - {concept}: {count}x")
        
        print("=" * 70)


def main():
    """CLI entry point."""
    parser = argparse.ArgumentParser(
        description="Automatska AKOMA/NtTSO anotacija krivičnog zakonika pomoću LLM-a"
    )
    
    parser.add_argument(
        "--input",
        type=str,
        default="zakon.txt",
        help="Putanja do ulaznog fajla sa tekstom zakona (default: zakon.txt)"
    )
    
    parser.add_argument(
        "--output",
        type=str,
        default="output_annotated.xml",
        help="Putanja do izlaznog AKOMA XML fajla (default: output_annotated.xml)"
    )
    
    parser.add_argument(
        "--output-json",
        type=str,
        default=None,
        help="Putanja do izlaznog JSON fajla sa anotacijama (default: auto)"
    )
    
    parser.add_argument(
        "--provider",
        type=str,
        default="github",
        choices=["github", "openrouter"],
        help="LLM provider (default: github)"
    )
    
    parser.add_argument(
        "--model",
        type=str,
        default="gpt-4o",
        help="LLM model za anotaciju (npr. 'gpt-4o' za GitHub, 'tngtech/deepseek-r1t2-chimera:free' za OpenRouter)"
    )
    
    parser.add_argument(
        "--limit",
        type=int,
        default=None,
        help="Procesuiraj samo prvih N članaka (za testiranje)"
    )
    
    args = parser.parse_args()
    
    # Proveri da li ulazni fajl postoji
    if not Path(args.input).exists():
        print(f"✗ Greška: Fajl '{args.input}' ne postoji.")
        sys.exit(1)
    
    # Proveri da li .env postoji
    if not Path(".env").exists():
        print("⚠ Upozorenje: .env fajl nije pronađen.")
        
        with open(".env", "w") as f:
            f.write("# API tokens\n")
            f.write("GITHUB_TOKEN=your_github_token_here\n")
            f.write("OPENROUTER_API_KEY=your_openrouter_key_here\n")
        
        print("  ✓ .env kreiran sa placeholder-ima.")
        print("\n  Za GitHub Models: dodaj GITHUB_TOKEN")
        print("  Za OpenRouter: dodaj OPENROUTER_API_KEY")
        print("\n  Pokreni ponovo nakon dodavanja odgovarajućeg tokena.")
        sys.exit(1)
    
    # Pokreni pipeline
    pipeline = AnnotationPipeline(
        input_file=args.input,
        output_xml=args.output,
        output_json=args.output_json,
        model=args.model,
        provider=args.provider,
        article_limit=args.limit
    )
    
    success = pipeline.run()
    sys.exit(0 if success else 1)


if __name__ == "__main__":
    main()
