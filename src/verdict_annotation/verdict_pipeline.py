"""Pipeline orchestration for verdict annotation workflow."""
from pathlib import Path
import json
import re
import sys
import io
import os
from typing import Any, Dict, Optional, Set

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
from .outcome_normalizer import normalize_outcome
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
        enable_llm: bool = True,
        include_stems: Optional[Set[str]] = None,
    ):
        self.txt_folder = Path(txt_folder)
        self.output_xml_dir = Path(output_xml_dir)
        self.output_json = output_json or str(self.output_xml_dir / "verdicts_annotations.json")
        self.limit = limit
        self.overrides_file = overrides_file
        self.enable_llm = enable_llm
        self.include_stems = set(include_stems or [])
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
        if self.include_stems:
            print(f"Filter:      {len(self.include_stems)} ciljnih TXT fajlova")
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

        if self.include_stems:
            texts = {
                case_id: value
                for case_id, value in texts.items()
                if case_id in self.include_stems
            }
        
        # Apply limit if set
        if self.limit:
            items = list(texts.items())[:self.limit]
            texts = dict(items)
            print(f"\n  -> Procesira se {len(texts)} presuda (limit primenjen)")

        texts = self._repair_texts_with_llm(texts)
        
        print(f"\n  [OK] Ucitano {len(texts)} tekstova")
        return texts

    def _needs_llm_ocr_repair(self, text: str) -> bool:
        if not text:
            return False
        patterns = (
            re.compile(r"\b[A-Za-zČĆŽŠĐčćžšđ]{2,}[a-zčćžšđ][A-ZČĆŽŠĐ]\s*[a-zčćžšđ]{1,}\b"),
            re.compile(r"\b[A-Za-zČĆŽŠĐčćžšđ]{3,}[čćžšđ]\s+[a-zčćžšđ]{1,4}\b"),
            re.compile(r"\b[A-Za-zČĆŽŠĐčćžšđ]{3,}\s+[čćžšđ]\b"),
            re.compile(r"\bkao[a-zčćžšđ]{4,}\b", re.IGNORECASE),
        )
        return any(pattern.search(text) for pattern in patterns)

    def _repair_texts_with_llm(self, texts: Dict[str, str]) -> Dict[str, str]:
        """Optional fallback: LLM-based OCR spacing repair for residual artifacts."""
        if not self.enable_llm or not self.annotator:
            return texts

        total = len(texts)
        repaired: Dict[str, str] = {}
        attempted = 0
        changed = 0

        for idx, (case_id, text) in enumerate(texts.items(), 1):
            if not self._needs_llm_ocr_repair(text):
                repaired[case_id] = text
                continue

            attempted += 1
            safe_case = case_id.encode('ascii', 'replace').decode('ascii')
            print(f"  [LLM OCR {idx}/{total}] Popravka spacing artefakata: {safe_case}")
            fixed = self.annotator.repair_ocr_artifacts(text, case_id)
            repaired[case_id] = fixed
            if fixed != text:
                changed += 1

        if attempted:
            print(f"\n  [OK] LLM OCR fallback: pokusano {attempted}, izmenjeno {changed}")

        return repaired

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

            llm_meta = annotation.metadata if annotation and isinstance(annotation.metadata, dict) else {}

            if self.annotator and self.enable_llm and self._needs_metadata_repair(metadata, llm_meta):
                repaired_meta = self.annotator.extract_metadata_only(
                    metadata.raw_text or "",
                    metadata.case_number or case_id,
                )
                if repaired_meta:
                    llm_meta = self._merge_metadata_payload(llm_meta, repaired_meta)
                    if annotation:
                        annotation.metadata = llm_meta

            llm_case_number = str(llm_meta.get("case_number") or "").strip()
            if llm_case_number and (not metadata.case_number or metadata.case_number == case_id):
                metadata.case_number = llm_case_number

            metadata.court_name = self._sanitize_court_name(metadata.court_name or "")
            llm_court_name = self._sanitize_court_name(str(llm_meta.get("court_name") or ""))
            if llm_court_name and (not metadata.court_name or self._is_suspicious_court_name(metadata.court_name)):
                metadata.court_name = llm_court_name

            if self._is_suspicious_court_name(metadata.court_name):
                recovered_court = self._sanitize_court_name(self.parser._extract_court_name(metadata.raw_text or "") or "")
                if recovered_court and not self._is_suspicious_court_name(recovered_court):
                    metadata.court_name = recovered_court

            llm_date = str(llm_meta.get("date") or "").strip()
            if llm_date and self._looks_like_iso_date(llm_date) and not metadata.date:
                metadata.date = llm_date

            llm_judges_raw = llm_meta.get("judges") or []
            llm_judges = [self.parser._normalize_judge_name(j) for j in llm_judges_raw]
            llm_judges = [j for j in llm_judges if self.parser._looks_like_judge_name(j)]
            selected_judges = self._select_better_judges(
                metadata.judges or [],
                llm_judges,
                metadata.raw_text or "",
            )
            if selected_judges:
                metadata.judges = self._prefer_full_names(selected_judges)
            else:
                cleaned_existing = [
                    self.parser._normalize_judge_name(name)
                    for name in (metadata.judges or [])
                    if name
                ]
                cleaned_existing = [name for name in cleaned_existing if self.parser._looks_like_judge_name(name)]
                metadata.judges = self._prefer_full_names(cleaned_existing)

            llm_outcome = normalize_outcome(str(llm_meta.get("case_outcome") or ""))
            if llm_outcome != "nepoznato" and normalize_outcome(metadata.case_outcome or "") == "nepoznato":
                metadata.case_outcome = llm_outcome

            llm_parties = llm_meta.get("parties") if isinstance(llm_meta.get("parties"), dict) else {}
            for role, people in llm_parties.items():
                if not people:
                    continue
                normalized_people = [self._normalize_person_name(p) for p in people]
                existing = metadata.parties.get(role, [])
                merged_candidates = [*(existing or []), *normalized_people]
                cleaned_people = self.parser._clean_party_values(role, merged_candidates)
                if cleaned_people:
                    metadata.parties[role] = cleaned_people
                elif role in metadata.parties:
                    metadata.parties.pop(role, None)

            llm_orgs = llm_meta.get("organizations") or []
            if llm_orgs:
                metadata.organizations = list({*metadata.organizations, *llm_orgs})

            if annotation and annotation.factual_state:
                metadata.factual_state = self._merge_dict_lists(
                    metadata.factual_state, annotation.factual_state
                )

    def _merge_metadata_payload(self, base: Dict[str, Any], update: Dict[str, Any]) -> Dict[str, Any]:
        merged = dict(base or {})

        for key in ("case_number", "court_name", "date", "case_outcome"):
            value = update.get(key)
            if value:
                merged[key] = value

        update_judges = update.get("judges") or []
        base_judges = merged.get("judges") or []
        if update_judges:
            merged["judges"] = self._ordered_unique([*base_judges, *update_judges])

        if isinstance(update.get("parties"), dict):
            parties = merged.get("parties") if isinstance(merged.get("parties"), dict) else {}
            for role, values in update["parties"].items():
                existing = parties.get(role, [])
                if isinstance(values, list):
                    parties[role] = self._ordered_unique([*existing, *values])
            merged["parties"] = parties

        update_orgs = update.get("organizations")
        if isinstance(update_orgs, list) and update_orgs:
            merged_orgs = merged.get("organizations") if isinstance(merged.get("organizations"), list) else []
            merged["organizations"] = self._ordered_unique([*merged_orgs, *update_orgs])

        return merged

    def _looks_like_iso_date(self, value: str) -> bool:
        return bool(re.fullmatch(r"\d{4}-\d{2}-\d{2}", (value or "").strip()))

    def _sanitize_court_name(self, court_name: str) -> str:
        cleaned = " ".join(str(court_name or "").split())
        cleaned = re.sub(r"(?i)\s+(?:dana|kao|optu[žz]en\w*|okrivljen\w*)\b.*$", "", cleaned)
        return cleaned.strip(" ,.;")

    def _is_suspicious_court_name(self, court_name: str) -> bool:
        normalized = self.parser._normalize_for_matching(court_name or "")
        if not normalized:
            return True

        padded = f" {normalized} "
        tokens = (" dana", " kao ", "optuzen", "okrivljen", "zakonik", "predsjednik", "sudija")
        if any(token in padded for token in tokens):
            return True

        if " sud u " not in padded:
            return True

        if re.search(r"\bsud\s+u\s+[a-z]\b", normalized):
            return True

        try:
            location = normalized.split("sud u", 1)[1].strip()
        except Exception:
            return True

        if len(location) <= 2:
            return True

        return False

    def _is_panel_case(self, text: str) -> bool:
        normalized = self.parser._normalize_for_matching(text or "")
        return (
            "u vijecu" in normalized
            and "predsjednika vijeca" in normalized
            and "sudija" in normalized
        )

    def _judge_name_score(self, name: str) -> int:
        value = (name or "").strip()
        if not value:
            return -10

        score = 0
        normalized = self.parser._normalize_for_matching(value)

        if self.parser._looks_like_judge_name(value):
            score += 4
        if " " in value:
            score += 1
        if re.search(r"[a-zčćžšđ][A-ZČĆŽŠĐ]", value):
            score -= 4
        if re.search(r"(?i)\b(kao|sudija|predsjednik|vijeca|vijecu|dana|optu[žz]en|okrivljen)\b", value):
            score -= 4
        if normalized.endswith("i") and not normalized.endswith("ic"):
            score -= 2
        if len(value.split()) > 3:
            score -= 2

        return score

    def _judge_list_score(self, judges: list[str]) -> int:
        if not judges:
            return -20
        return sum(self._judge_name_score(judge) for judge in judges)

    def _select_better_judges(self, regex_judges: list[str], llm_judges: list[str], raw_text: str) -> list[str]:
        regex_clean = self._ordered_unique([self.parser._normalize_judge_name(j) for j in (regex_judges or []) if j])
        regex_clean = [j for j in regex_clean if self.parser._looks_like_judge_name(j)]

        llm_clean = self._ordered_unique([self.parser._normalize_judge_name(j) for j in (llm_judges or []) if j])
        llm_clean = [j for j in llm_clean if self.parser._looks_like_judge_name(j)]

        if not llm_clean:
            return regex_clean
        if not regex_clean:
            return llm_clean

        expected = 3 if self._is_panel_case(raw_text) else 1
        llm_score = self._judge_list_score(llm_clean)
        regex_score = self._judge_list_score(regex_clean)

        if len(llm_clean) >= expected and llm_score >= regex_score - 1:
            return llm_clean
        if llm_score >= regex_score + 2:
            return llm_clean
        return regex_clean

    def _needs_metadata_repair(self, metadata: VerdictMetadata, llm_meta: Dict[str, Any]) -> bool:
        if self._is_suspicious_court_name(metadata.court_name or ""):
            return True

        judges = metadata.judges or []
        if not judges:
            return True

        if self._is_panel_case(metadata.raw_text or "") and len(judges) < 3:
            return True

        if any(self._judge_name_score(judge) < 1 for judge in judges):
            return True

        llm_judges = llm_meta.get("judges") if isinstance(llm_meta.get("judges"), list) else []
        if not llm_judges:
            return True

        return False

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
        return self.parser._normalize_person_name(str(name or ""))

    def _ordered_unique(self, values: list[str]) -> list[str]:
        unique: list[str] = []
        seen: set[str] = set()
        for value in values:
            key = (value or "").strip()
            if not key:
                continue
            lowered = key.lower()
            if lowered in seen:
                continue
            seen.add(lowered)
            unique.append(key)
        return unique

    def _prefer_full_names(self, names: list[str]) -> list[str]:
        if not names:
            return []

        full = [n for n in names if " " in n.strip()]
        pool = full if full else names

        deduped: list[str] = []
        seen_signatures: set[str] = set()
        soft_signature_index: dict[str, int] = {}

        for raw_name in pool:
            normalized_name = " ".join((raw_name or "").split())
            if not normalized_name:
                continue

            display_name = self._prefer_display_name_order(normalized_name)
            signature = self._judge_name_signature(display_name)
            if signature in seen_signatures:
                continue

            soft_signature = self._judge_name_soft_signature(display_name)
            if soft_signature in soft_signature_index:
                idx = soft_signature_index[soft_signature]
                existing = deduped[idx]
                deduped[idx] = self._choose_better_judge_variant(existing, display_name)
                seen_signatures.add(signature)
                continue

            seen_signatures.add(signature)
            soft_signature_index[soft_signature] = len(deduped)
            deduped.append(display_name)

        return deduped

    def _judge_name_signature(self, name: str) -> str:
        tokens = [token for token in (name or "").split() if token]
        if len(tokens) == 2:
            first = tokens[0].lower()
            second = tokens[1].lower()
            ordered = tuple(sorted((first, second)))
            return f"two:{ordered[0]}:{ordered[1]}"
        return "multi:" + " ".join(token.lower() for token in tokens)

    def _prefer_display_name_order(self, name: str) -> str:
        tokens = [token for token in (name or "").split() if token]
        if len(tokens) != 2:
            return " ".join(tokens)

        first, second = tokens
        if self._looks_like_surname(first) and not self._looks_like_surname(second):
            return f"{second} {first}"
        return f"{first} {second}"

    def _judge_name_soft_signature(self, name: str) -> str:
        tokens = [token for token in (name or "").split() if token]
        if len(tokens) != 2:
            return self._judge_name_signature(name)

        first, surname = tokens
        first_base = re.sub(r"[aeiou]$", "", first.lower())
        return f"soft:{surname.lower()}:{first_base}"

    def _choose_better_judge_variant(self, current: str, candidate: str) -> str:
        current_tokens = [token for token in current.split() if token]
        candidate_tokens = [token for token in candidate.split() if token]
        if len(current_tokens) == 2 and len(candidate_tokens) == 2:
            cur_first, _ = current_tokens
            cand_first, _ = candidate_tokens
            cur_score = self._given_name_variant_score(cur_first)
            cand_score = self._given_name_variant_score(cand_first)
            if cand_score > cur_score:
                return candidate
            if cand_score < cur_score:
                return current

        # Tie-breaker: keep the more concise normalized form.
        if len(candidate) < len(current):
            return candidate
        return current

    def _given_name_variant_score(self, value: str) -> int:
        lowered = (value or "").lower()
        score = 0

        if lowered.endswith("e"):
            score -= 1
        if lowered.endswith("i") and len(lowered) > 3:
            score -= 1
        if lowered and not lowered.endswith("a"):
            score += 1

        return score

    def _looks_like_surname(self, token: str) -> bool:
        lowered = token.lower()
        return lowered.endswith(("ić", "ic", "ović", "ovic", "ević", "evic", "ski", "ska", "čki", "cki"))

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
