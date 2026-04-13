"""Pipeline orchestration for verdict annotation workflow."""
from pathlib import Path
import json
import re
import sys
import io
import os
from typing import Dict, Optional

# Fix Windows console encoding for Cyrillic/Latin characters
# Only wrap if not already wrapped and stdout is a TTY
if sys.platform == 'win32' and hasattr(sys.stdout, 'buffer') and not isinstance(sys.stdout, io.TextIOWrapper):
    try:
        sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8', errors='replace')
        sys.stderr = io.TextIOWrapper(sys.stderr.buffer, encoding='utf-8', errors='replace')
    except Exception:
        pass

from .txt_extractor import TextExtractor
from .verdict_parser import VerdictParser, VerdictMetadata
from .verdict_annotator import VerdictAnnotator, VerdictAnnotation
from .extraction_quality import assess_annotation_quality, DEFAULT_CONFIDENCE_THRESHOLD
from .verdict_exporter import VerdictAkomaExporter
from src.config.llm_config import DEFAULT_MODEL


class VerdictAnnotationPipeline:
    """Orchestrates TXT loading, parsing, annotation, and XML export for verdicts."""

    def __init__(
        self,
        txt_folder: str,
        output_xml_dir: str,
        output_json: Optional[str] = None,
        api_token: Optional[str] = None,
        model: Optional[str] = None,
        provider: Optional[str] = None,
        limit: Optional[int] = None,
        overrides_file: Optional[str] = None,
        enable_llm: bool = True
    ):
        self.txt_folder = Path(txt_folder)
        self.output_xml_dir = Path(output_xml_dir)
        self.output_json = output_json or str(self.output_xml_dir / "verdicts_annotations.json")
        self.limit = limit
        self.overrides_file = overrides_file
        self.enable_llm = enable_llm
        self.confidence_threshold = DEFAULT_CONFIDENCE_THRESHOLD
        # Use passed model or centralized default
        display_model = model or DEFAULT_MODEL

        self.text_extractor = TextExtractor()
        self.parser = VerdictParser()
        self.annotator = None
        if self.enable_llm:
            self.annotator = VerdictAnnotator(api_token=api_token, model=model, provider=provider)
        self.exporter = VerdictAkomaExporter()

        print("=" * 70)
        print("ANOTACIJA SUDSKIH PRESUDA (Zadatak 2)")
        print("=" * 70)
        print(f"TXT folder:  {txt_folder}")
        print(f"XML output:  {output_xml_dir}")
        print(f"Provider:    {provider or 'openai' if self.enable_llm else 'disabled'}")
        print(f"Model:       {display_model if self.enable_llm else 'n/a'}")
        if limit:
            print(f"Limit:       {limit} presuda (test mode)")
        print("=" * 70)

    def run(self) -> bool:
        """Executes the full verdict annotation pipeline."""
        try:
            print("\n[FAZA 1/4] Ucitavanje teksta iz TXT fajlova...")
            texts = self._extract_texts()

            if not texts:
                print("[X] Greska: Nema ekstraktovanih tekstova.")
                return False

            print("\n[FAZA 2/4] Parsiranje strukture presuda...")
            verdicts = self._parse_verdicts(texts)

            if not verdicts:
                print("[X] Greska: Nijedna presuda nije parsovana.")
                return False

            if self.enable_llm:
                print("\n[FAZA 3/4] LLM semanticka anotacija presuda...")
                annotations = self._annotate_verdicts(verdicts)
            else:
                print("\n[FAZA 3/4] LLM semanticka anotacija presuda... (preskoceno)")
                annotations = {}

            self._merge_llm_metadata(verdicts, annotations)
            self._apply_overrides(verdicts, annotations)
            self._normalize_annotation_fields(verdicts, annotations)
            self._apply_quality_flags(annotations)

            print("\n[FAZA 4/4] Generisanje Akoma Ntoso XML fajlova...")
            self._export_results(verdicts, annotations)

            self._print_statistics(verdicts, annotations)

            print("\n" + "=" * 70)
            print("[OK] PIPELINE ZAVRSEN USPESNO")
            print("=" * 70)
            return True

        except KeyboardInterrupt:
            print("\n\n[!] Pipeline prekinut (Ctrl+C)")
            return False

        except Exception as exc:
            print(f"\n[X] KRITICNA GRESKA: {exc}")
            import traceback
            traceback.print_exc()
            return False

    def _extract_texts(self) -> Dict[str, str]:
        """Phase 1: Load text from TXT files."""
        texts = self.text_extractor.extract_from_folder(self.txt_folder)
        
        # Apply limit if set
        if self.limit:
            items = list(texts.items())[:self.limit]
            texts = dict(items)
            print(f"\n  -> Procesira se {len(texts)} presuda (limit primenjen)")
        
        print(f"\n  [OK] Ucitano {len(texts)} tekstova")
        return texts

    def _parse_verdicts(self, texts: Dict[str, str]) -> Dict[str, VerdictMetadata]:
        """Phase 2: Parse verdict structure and metadata."""
        verdicts = self.parser.parse_batch(texts)
        
        success_count = sum(1 for v in verdicts.values() if v.case_number)
        print(f"\n  [OK] Parsovano {success_count}/{len(verdicts)} presuda")
        return verdicts

    def _annotate_verdicts(self, verdicts: Dict[str, VerdictMetadata]) -> Dict[str, VerdictAnnotation]:
        """Phase 3: LLM annotation of verdicts."""
        # Prepare texts for annotation
        texts_for_annotation = {
            case_id: metadata.raw_text
            for case_id, metadata in verdicts.items()
        }
        
        if not self.annotator:
            return {}
        annotations = self.annotator.annotate_batch(texts_for_annotation)
        
        if texts_for_annotation:
            success_rate = len(annotations) / len(texts_for_annotation) * 100
            print(f"\n  [OK] Anotirano: {len(annotations)}/{len(texts_for_annotation)} ({success_rate:.1f}% uspesnosti)")
        
        return annotations

    def _merge_llm_metadata(
        self,
        verdicts: Dict[str, VerdictMetadata],
        annotations: Dict[str, VerdictAnnotation]
    ) -> None:
        """Merge LLM-extracted metadata and factual state into regex metadata."""
        for case_id, metadata in verdicts.items():
            annotation = annotations.get(case_id)
            if not annotation:
                continue

            llm_meta = annotation.metadata if isinstance(annotation.metadata, dict) else {}
            if not metadata.case_number and llm_meta.get("case_number"):
                metadata.case_number = llm_meta.get("case_number")
            if not metadata.court_name and llm_meta.get("court_name"):
                metadata.court_name = llm_meta.get("court_name")
            if not metadata.date and llm_meta.get("date"):
                metadata.date = llm_meta.get("date")
            if llm_meta.get("judges"):
                merged_judges = list({*metadata.judges, *[self._normalize_person_name(j) for j in llm_meta.get("judges")]})
                metadata.judges = self._prefer_full_names(merged_judges)

            llm_parties = llm_meta.get("parties") if isinstance(llm_meta.get("parties"), dict) else {}
            for role, people in llm_parties.items():
                if not people:
                    continue
                normalized_people = [self._normalize_person_name(p) for p in people]
                existing = metadata.parties.get(role, [])
                merged = list({*(existing or []), *normalized_people})
                metadata.parties[role] = merged

            llm_orgs = llm_meta.get("organizations") or []
            if llm_orgs:
                metadata.organizations = list({*metadata.organizations, *llm_orgs})

            if annotation.factual_state:
                metadata.factual_state = self._merge_dict_lists(
                    metadata.factual_state, annotation.factual_state
                )

    def _merge_dict_lists(
        self,
        base: Dict[str, list[str]],
        override: Dict[str, list[str]]
    ) -> Dict[str, list[str]]:
        merged = {k: list(v) for k, v in (base or {}).items()}
        if isinstance(override, str):
            # Some LLM responses return factual_state as a JSON string.
            try:
                parsed = json.loads(override)
            except Exception:
                return merged
            override = parsed if isinstance(parsed, dict) else {}

        if not isinstance(override, dict):
            return merged

        for key, values in (override or {}).items():
            if not values:
                continue
            merged.setdefault(key, [])
            if isinstance(values, str):
                values = [values]
            elif not isinstance(values, list):
                continue
            for value in values:
                if value not in merged[key]:
                    merged[key].append(value)
        return merged

    def _normalize_person_name(self, name: str) -> str:
        cleaned = " ".join(str(name).replace("\u00a0", " ").split())
        tokens = cleaned.split()
        merged_tokens = []
        idx = 0
        while idx < len(tokens):
            token = tokens[idx]
            if (
                len(token) == 1
                and token.isupper()
                and idx + 1 < len(tokens)
                and tokens[idx + 1][0].isupper()
                and tokens[idx + 1][1:].islower()
            ):
                next_token = tokens[idx + 1]
                merged = token + next_token[0].lower() + next_token[1:]
                merged_tokens.append(merged)
                idx += 2
                continue
            merged_tokens.append(token)
            idx += 1
        fixed_tokens = []
        for token in merged_tokens:
            if len(token) == 1 and token.isalpha() and fixed_tokens:
                prev = fixed_tokens[-1]
                if prev and prev[-1].isalpha():
                    fixed_tokens[-1] = prev + token
                    continue
            fixed_tokens.append(token)
        cleaned = " ".join(fixed_tokens)
        cleaned = re.sub(r"([A-ZČĆŽŠĐ])\s+([a-zčćžšđ])", r"\1\2", cleaned)
        cleaned = re.sub(r"([a-zčćžšđ])\s+([čćžšđ])\b", r"\1\2", cleaned)
        cleaned = re.sub(r"\s+,", ",", cleaned)
        return cleaned.strip()

    def _prefer_full_names(self, names: list[str]) -> list[str]:
        if not names:
            return []
        full = [n for n in names if " " in n.strip()]
        if full:
            return full
        return names

    def _normalize_annotation_fields(
        self,
        verdicts: Dict[str, VerdictMetadata],
        annotations: Dict[str, VerdictAnnotation]
    ) -> None:
        for case_id, annotation in annotations.items():
            annotation.applied_articles = self._normalize_article_labels(
                (annotation.applied_articles or []) + (verdicts.get(case_id).article_references if verdicts.get(case_id) else [])
            )
            annotation.applied_laws = [
                self._normalize_law_name(law)
                for law in (annotation.applied_laws or [])
            ]
            if verdicts.get(case_id) and verdicts.get(case_id).legal_references:
                annotation.applied_laws = list({
                    *annotation.applied_laws,
                    *[self._normalize_law_name(law) for law in verdicts.get(case_id).legal_references]
                })
            annotation.legal_concepts = self._normalize_legal_concepts(annotation.legal_concepts)

            metadata = verdicts.get(case_id)
            if metadata:
                existing_meta = annotation.metadata if isinstance(annotation.metadata, dict) else {}
                annotation.metadata = {
                    "case_number": metadata.case_number or existing_meta.get("case_number"),
                    "court_name": metadata.court_name or existing_meta.get("court_name"),
                    "date": metadata.date or existing_meta.get("date"),
                    "judges": metadata.judges or existing_meta.get("judges", []),
                    "parties": metadata.parties or existing_meta.get("parties", {}),
                    "organizations": metadata.organizations or existing_meta.get("organizations", [])
                }
                metadata.factual_state = self._normalize_factual_state(metadata.factual_state)

            if annotation.factual_state:
                annotation.factual_state = self._normalize_factual_state(annotation.factual_state)

    def _normalize_factual_state(self, factual_state: Dict[str, list[str]]) -> Dict[str, list[str]]:
        if not factual_state:
            return {}

        if isinstance(factual_state, str):
            try:
                parsed = json.loads(factual_state)
            except Exception:
                return {}
            factual_state = parsed if isinstance(parsed, dict) else {}

        if not isinstance(factual_state, dict):
            return {}

        normalized: Dict[str, list[str]] = {}
        for key, values in factual_state.items():
            if isinstance(values, str):
                values = [values]
            elif not isinstance(values, list):
                continue
            cleaned_values: list[str] = []
            for value in values or []:
                v = str(value).strip()
                if not v:
                    continue
                v = self._normalize_fact_value(key, v)
                if v not in cleaned_values:
                    cleaned_values.append(v)
            if cleaned_values:
                normalized[key] = cleaned_values
        return normalized

    def _normalize_fact_value(self, key: str, value: str) -> str:
        lowered = value.lower()
        if key == "weapon":
            if re.search(r"metaln\w*\s+klju\w*", lowered):
                return "metalni ključ"
            if "nož" in lowered or "noz" in lowered:
                return "nož"
            if "pistol" in lowered:
                return "pistolj"
            if "palic" in lowered:
                return "palica"
            if "kamen" in lowered:
                return "kamen"
            if "flaš" in lowered or "flas" in lowered:
                return "staklena flaša"

        if key == "injury_type":
            if ("tešk" in lowered or "tesk" in lowered) and "povred" in lowered:
                return "teška tjelesna povreda"
            if "lak" in lowered and "povred" in lowered:
                return "laka tjelesna povreda"

        if key == "location":
            mapping = {
                "podgorici": "Podgorica",
                "podgorica": "Podgorica",
                "danilovgradu": "Danilovgrad",
                "skadru": "Skadar"
            }
            candidate = value.strip()
            key_lower = candidate.lower()
            if key_lower in mapping:
                return mapping[key_lower]
            if candidate.isupper():
                return candidate.title()
            return candidate

        return value

    def _normalize_article_labels(self, articles: list[str]) -> list[str]:
        normalized = []
        for label in articles or []:
            match = re.search(r"\d+[a-z]?", label, re.IGNORECASE)
            if match:
                normalized.append(f"Član {match.group(0)}")
            else:
                normalized.append(label)
        return list(dict.fromkeys(normalized))

    def _normalize_law_name(self, law_name: str) -> str:
        name_lower = law_name.lower()
        if "krivični zakonik" in name_lower or "krivicni zakonik" in name_lower:
            if "crne gore" not in name_lower:
                return "Krivični zakonik Crne Gore"
        if "krivični zakon" in name_lower or "krivicni zakon" in name_lower:
            return "Krivični zakonik Crne Gore"
        if "zakonik o krivičnom postupku" in name_lower or "zakonik o krivicnom postupku" in name_lower:
            if "crne gore" not in name_lower:
                return "Zakonik o krivičnom postupku"
        return law_name

    def _normalize_legal_concepts(self, concepts: list[str]) -> list[str]:
        mapping = {
            "heavy bodily injury": "teška tjelesna povreda",
            "serious bodily injury": "teška tjelesna povreda",
            "light bodily injury": "laka tjelesna povreda",
            "teško tjelesno povređenje": "teška tjelesna povreda",
            "tesko tjelesno povredjenje": "teška tjelesna povreda",
            "teško telesno povređenje": "teška tjelesna povreda",
            "tesko telesno povredjenje": "teška tjelesna povreda",
            "lakša povreda": "laka tjelesna povreda",
            "laka povreda": "laka tjelesna povreda",
            "conditioned sentence": "uslovna osuda",
            "criminal offense": "krivično djelo",
            "criminal offence": "krivično djelo",
            "crime": "krivično djelo",
        }
        skip = {"lacuna"}
        normalized = []
        for concept in concepts or []:
            key = concept.strip().lower()
            if key in skip:
                continue
            normalized.append(mapping.get(key, concept))
        return list(dict.fromkeys(normalized))

    def _apply_quality_flags(self, annotations: Dict[str, VerdictAnnotation]) -> None:
        """Set needs_review flag for weak or incomplete extraction outputs."""
        for annotation in annotations.values():
            needs_review, reasons = assess_annotation_quality(
                annotation,
                confidence_threshold=self.confidence_threshold,
            )
            annotation.needs_review = needs_review
            annotation.review_reason = ",".join(reasons) if reasons else None
            annotation.extraction_method = "hybrid_regex_llm"

    def _apply_overrides(
        self,
        verdicts: Dict[str, VerdictMetadata],
        annotations: Dict[str, VerdictAnnotation]
    ) -> None:
        """Apply optional manual overrides for metadata/factual state."""
        if not self.overrides_file:
            return

        overrides_path = Path(self.overrides_file)
        if not overrides_path.exists():
            return

        try:
            with open(overrides_path, "r", encoding="utf-8") as f:
                overrides = json.load(f)
        except Exception as exc:
            print(f"[!] Ne mogu da ucitam overrides: {exc}")
            return

        for case_id, override in overrides.items():
            metadata = verdicts.get(case_id)
            if not metadata:
                continue

            meta_override = override.get("metadata") or {}
            if meta_override.get("case_number"):
                metadata.case_number = meta_override.get("case_number")
            if meta_override.get("court_name"):
                metadata.court_name = meta_override.get("court_name")
            if meta_override.get("date"):
                metadata.date = meta_override.get("date")
            if meta_override.get("judges"):
                metadata.judges = meta_override.get("judges")
            if meta_override.get("parties"):
                metadata.parties = self._merge_dict_lists(
                    metadata.parties, meta_override.get("parties")
                )
            if meta_override.get("organizations"):
                metadata.organizations = list({*metadata.organizations, *meta_override.get("organizations")})

            if override.get("factual_state"):
                metadata.factual_state = self._merge_dict_lists(
                    metadata.factual_state, override.get("factual_state")
                )

            ann_override = override.get("annotation") or {}
            if ann_override and case_id in annotations:
                annotation = annotations[case_id]
                for key, value in ann_override.items():
                    setattr(annotation, key, value)

    def _export_results(
        self,
        verdicts: Dict[str, VerdictMetadata],
        annotations: Dict[str, VerdictAnnotation]
    ) -> None:
        """Phase 4: Export to Akoma Ntoso XML and JSON."""
        xml_files = self.exporter.export_batch(verdicts, annotations, str(self.output_xml_dir))
        print(f"\n  [OK] Generirano {len(xml_files)} XML fajlova")
        
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
            print("\nNema semantickih anotacija.")
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

        print(f"\nSemanticka anotacija:")
        print(f"  - Anotirano presuda:      {len(annotations)}")
        print("\nIshodi predmeta:")
        for outcome, count in sorted(outcomes.items(), key=lambda x: -x[1]):
            safe_outcome = outcome.encode('ascii', 'replace').decode('ascii')
            print(f"  - {safe_outcome}: {count}")

        print(f"\nUkupno pravnih koncepata: {len(all_concepts)}")
        
        if applied_laws_count:
            print("\nNajcesce primenjeni zakoni:")
            for law, count in sorted(applied_laws_count.items(), key=lambda x: -x[1])[:5]:
                safe_law = law.encode('ascii', 'replace').decode('ascii')
                print(f"  - {safe_law}: {count}x")

        print("=" * 70)
