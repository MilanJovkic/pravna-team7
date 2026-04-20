"""Pipeline orchestration for Akoma annotation flow."""
from pathlib import Path
import re
from typing import Dict, List, Optional

from .annotator import LLMAnnotator, SemanticAnnotation
from .exporter import AkomaExporter
from .law_xml_validator import validate_law_xml
from .parser import LegalArticle, LegalChapter, LegalTextParser
from src.config.llm_config import DEFAULT_MODEL


class AnnotationPipeline:
    """Orchestrates parsing, annotation, and XML export."""

    def __init__(
        self,
        input_file: str,
        output_xml: str,
        output_json: Optional[str] = None,
        api_token: Optional[str] = None,
        model: Optional[str] = None,
        provider: Optional[str] = None,
        article_limit: Optional[int] = None,
        enable_llm: bool = True
    ):
        self.input_file = input_file
        self.output_xml = output_xml
        self.output_json = output_json or output_xml.replace('.xml', '_annotations.json')
        self.article_limit = article_limit
        self.enable_llm = enable_llm
        # Use passed model or centralized default
        display_model = model or DEFAULT_MODEL

        self.parser = LegalTextParser()
        self.annotator = None
        if self.enable_llm:
            self.annotator = LLMAnnotator(api_token=api_token, model=model, provider=provider)
        self.exporter = AkomaExporter()

        print("=" * 70)
        print("AUTOMATSKA ANOTACIJA KRIVIČNOG ZAKONIKA")
        print("=" * 70)
        print(f"Input:    {input_file}")
        print(f"Output:   {output_xml}")
        print(f"Provider: {provider or 'openai' if self.enable_llm else 'disabled'}")
        print(f"Model:    {display_model if self.enable_llm else 'n/a'}")
        if article_limit:
            print(f"Limit:    {article_limit} članaka (test mode)")
        print("=" * 70)

    def run(self) -> bool:
        """Executes the full annotation pipeline."""
        try:
            print("\n[FAZA 1/3] Parsiranje zakona...")
            chapters = self._parse_law()

            if not chapters:
                print("[X] Greska: Nijedan clan nije parsovan.")
                return False

            if self.enable_llm:
                print("\n[FAZA 2/3] LLM semanticka anotacija...")
            else:
                print("\n[FAZA 2/3] LLM semanticka anotacija... (preskoceno)")
            annotations = self._annotate_articles(chapters)

            print("\n[FAZA 3/3] Generisanje AKOMA Ntoso XML-a...")
            self._export_results(chapters, annotations)
            self._print_statistics(chapters, annotations)

            print("\n" + "=" * 70)
            print("[OK] PIPELINE ZAVRSEN USPESNO")
            print("=" * 70)
            return True

        except KeyboardInterrupt:
            print("\n\n[!] Pipeline prekinut od strane korisnika (Ctrl+C)")
            print("Delimicni rezultati mogu biti sacuvani.")
            return False

        except Exception as exc:
            print(f"\n[X] KRITICNA GRESKA: {exc}")
            import traceback
            traceback.print_exc()
            return False

    def _parse_law(self) -> List[LegalChapter]:
        with open(self.input_file, "r", encoding="utf-8") as f:
            text = f.read()

        chapters = self.parser.parse(text)
        total_articles = sum(len(ch.articles) for ch in chapters)
        print(f"  [OK] Parsovano: {len(chapters)} glava, {total_articles} clanaka")
        return chapters

    def _annotate_articles(self, chapters: List[LegalChapter]) -> Dict[str, SemanticAnnotation]:
        all_articles = self.parser.get_all_articles(chapters)

        if self.article_limit:
            all_articles = all_articles[:self.article_limit]
            print(f"  -> Procesira se {len(all_articles)} clanaka (limit primenjen)")

        articles_batch = [
            (art.number, self.parser.get_article_full_text(art))
            for art in all_articles
        ]

        if not self.annotator:
            return self._rule_based_annotations(all_articles)
        annotations = self.annotator.annotate_batch(articles_batch)

        if articles_batch:
            success_rate = len(annotations) / len(articles_batch) * 100
            print(f"\n  [OK] Anotirano: {len(annotations)}/{len(articles_batch)} ({success_rate:.1f}% uspesnosti)")

        return annotations

    def _rule_based_annotations(self, articles: List[LegalArticle]) -> Dict[str, SemanticAnnotation]:
        annotations: Dict[str, SemanticAnnotation] = {}

        for article in articles:
            text = self.parser.get_article_full_text(article)
            norm_type = self._infer_norm_type(text)
            sanctions = self._extract_sanctions(text)
            references = self._extract_references(text, article.number)
            conditions = self._extract_conditions(text)
            concepts = self._extract_concepts(text)

            annotations[article.number] = SemanticAnnotation(
                norm_type=norm_type,
                subjects=["perpetrator"],
                conditions=conditions,
                sanctions=sanctions,
                references=references,
                legal_concepts=concepts,
                qualifiers={"aggravated": False, "mitigated": False, "special_conditions": []},
                confidence=0.6,
                raw_response=None
            )

        return annotations

    def _infer_norm_type(self, text: str) -> str:
        normalized = text.lower()
        if normalized.lstrip().startswith("kazniće se") or normalized.lstrip().startswith("kazniti"):
            return "sanction"
        if "sud može" in normalized or "sud moze" in normalized:
            return "permission"
        if "kazniće se" in normalized or "kazniti" in normalized:
            return "prohibition"
        if "dozvoljeno" in normalized or "može" in normalized:
            return "permission"
        if "dužan" in normalized or "obavezan" in normalized:
            return "obligation"
        return "definition"

    def _extract_conditions(self, text: str) -> List[str]:
        normalized = text.lower()
        conditions = []
        if "nehata" in normalized:
            conditions.append("negligence")
        if "umišljaj" in normalized or "umisl" in normalized:
            conditions.append("intent")
        if "na mah" in normalized:
            conditions.append("heat_of_passion")
        return conditions

    def _extract_concepts(self, text: str) -> List[str]:
        normalized = text.lower()
        concepts = []
        if "liši života" in normalized:
            concepts.append("ubistvo")
        if "teško tjelesno" in normalized:
            concepts.append("teska tjelesna povreda")
        if "lako tjelesno" in normalized:
            concepts.append("laka tjelesna povreda")
        if "samoubistvo" in normalized:
            concepts.append("samoubistvo")
        if "pobačaj" in normalized:
            concepts.append("pobacaj")
        if "tuč" in normalized:
            concepts.append("ucesce u tuci")
        if "bez pomoći" in normalized or "bez pomoci" in normalized:
            concepts.append("nepruzanje pomoci")
        return concepts

    def _extract_references(self, text: str, article_number: str) -> List[str]:
        refs = []
        for match in re.finditer(r"\bčlan(?:a|u|om)?\s+(\d+[a-z]?)", text, re.IGNORECASE):
            if match.group(1) != article_number:
                refs.append(f"Član {match.group(1)}")
        for match in re.finditer(r"\bstav(?:a|u|om)?\s+(\d+)", text, re.IGNORECASE):
            refs.append(f"stav {match.group(1)}")
        return list(dict.fromkeys(refs))

    def _extract_sanctions(self, text: str) -> Dict[str, Optional[object]]:
        normalized = text.lower()
        if "novčanom kaznom" in normalized or "novcanom kaznom" in normalized:
            if "zatvorom" in normalized:
                return {"type": "both", "min_value": None, "max_value": None, "min_unit": None, "max_unit": None, "details": "fine or prison"}
            return {"type": "fine", "min_value": None, "max_value": None, "min_unit": None, "max_unit": None, "details": None}

        match = re.search(r"zatvorom\s+od\s+([\wčćžšđ]+)\s+do\s+([\wčćžšđ]+)\s+(godina|godine|godinu|mjeseci|mjeseca|mjesec)", normalized)
        if match:
            return {
                "type": "prison",
                "min_value": self._parse_number(match.group(1)),
                "max_value": self._parse_number(match.group(2)),
                "min_unit": self._normalize_unit(match.group(3)),
                "max_unit": self._normalize_unit(match.group(3)),
                "details": None
            }

        match = re.search(
            r"zatvorom\s+od\s+([\wčćžšđ]+)\s+(mjeseci|mjeseca|mjesec)\s+do\s+([\wčćžšđ]+)\s+(godina|godine|godinu)",
            normalized
        )
        if match:
            return {
                "type": "prison",
                "min_value": self._parse_number(match.group(1)),
                "max_value": self._parse_number(match.group(3)),
                "min_unit": "months",
                "max_unit": "years",
                "details": None
            }

        match = re.search(r"kaznom\s+dugotrajnog\s+zatvora", normalized)
        if match:
            return {
                "type": "prison",
                "min_value": None,
                "max_value": None,
                "min_unit": None,
                "max_unit": None,
                "details": "long-term imprisonment"
            }

        match = re.search(r"zatvorom\s+do\s+([\wčćžšđ]+)\s+(godina|godine|godinu|mjeseci|mjeseca|mjesec)", normalized)
        if match:
            return {
                "type": "prison",
                "min_value": None,
                "max_value": self._parse_number(match.group(1)),
                "min_unit": None,
                "max_unit": self._normalize_unit(match.group(2)),
                "details": None
            }

        match = re.search(r"zatvorom\s+najmanje\s+([\wčćžšđ]+)\s+(godina|godine|godinu|mjeseci|mjeseca|mjesec)", normalized)
        if match:
            return {
                "type": "prison",
                "min_value": self._parse_number(match.group(1)),
                "max_value": None,
                "min_unit": self._normalize_unit(match.group(2)),
                "max_unit": None,
                "details": None
            }

        return {"type": "prison", "min_value": None, "max_value": None, "min_unit": None, "max_unit": None, "details": None}

    def _parse_number(self, token: str) -> Optional[int]:
        if not token:
            return None
        token = re.sub(r"[^0-9a-zčćžšđ]", "", token.lower())
        if token.isdigit():
            return int(token)
        word_map = {
            "jedan": 1, "jedna": 1, "jedne": 1, "jednog": 1,
            "dva": 2, "dvije": 2,
            "tri": 3, "četiri": 4, "cetiri": 4,
            "pet": 5, "šest": 6, "sest": 6,
            "sedam": 7, "osam": 8, "devet": 9,
            "deset": 10, "jedanaest": 11, "dvanaest": 12,
            "trinaest": 13, "četrnaest": 14, "cetrnaest": 14,
            "petnaest": 15, "šesnaest": 16, "sesnaest": 16,
            "sedamnaest": 17, "osamnaest": 18, "devetnaest": 19,
            "dvadeset": 20
        }
        return word_map.get(token)

    def _normalize_unit(self, unit: str) -> str:
        unit = unit.lower()
        if unit.startswith("god"):
            return "years"
        return "months"

    def _export_results(self, chapters: List[LegalChapter], annotations: Dict[str, SemanticAnnotation]) -> None:
        output_xml_path = Path(self.output_xml)
        output_xml_path.parent.mkdir(parents=True, exist_ok=True)

        output_json_path = Path(self.output_json)
        output_json_path.parent.mkdir(parents=True, exist_ok=True)

        self.exporter.export(chapters, annotations, self.output_xml)
        if annotations:
            self.exporter.export_annotations_json(annotations, self.output_json)

        validation_errors = validate_law_xml(self.output_xml)
        if validation_errors:
            formatted = "\n".join(f"- {err}" for err in validation_errors)
            raise ValueError(f"Law XML validation failed:\n{formatted}")

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
