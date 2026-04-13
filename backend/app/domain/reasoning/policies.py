"""Domain policies for reasoning confidence and sanction suggestions."""
from __future__ import annotations

import json
import re
from pathlib import Path

from backend.app.models.schemas import CbrResult, ReasoningConfidence
from backend.app.domain.shared.outcome_normalization import normalize_outcome
from backend.app.services.law_service import LawService


class ReasoningPolicy:
    """Domain policy module for confidence and sanction heuristics."""

    def __init__(self, profile_path: str | Path | None = None, load_profile: bool = True) -> None:
        self._law_service = LawService()
        self._profile_path = Path(profile_path) if profile_path else self._default_profile_path()
        self._sentencing_profile = self._default_sentencing_profile()
        if load_profile:
            self._load_sentencing_profile()

    def _default_profile_path(self) -> Path:
        for parent in Path(__file__).resolve().parents:
            candidate = parent / "backend" / "app" / "resources" / "sentencing_profile.json"
            if candidate.exists():
                return candidate
            backend_dir = parent / "backend"
            if backend_dir.exists() and (backend_dir / "app" / "resources").exists():
                return backend_dir / "app" / "resources" / "sentencing_profile.json"
        return Path("backend/app/resources/sentencing_profile.json")

    def _default_sentencing_profile(self) -> dict[str, object]:
        return {
            "base_severity": 0.5,
            "min_severity": 0.1,
            "max_severity": 0.95,
            "attempted_max_factor": 0.6,
            "fine_threshold_both_mode": 0.36,
            "true_feature_weights": {
                "repeat_offender": 0.2,
                "previous_convictions": 0.144,
                "aggravating_circumstances": 0.08,
                "mitigating_circumstances": -0.08,
                "death_result": 0.24,
                "severe_consequence": 0.096,
                "weapon_used": 0.064,
                "alcohol_intoxication": 0.04,
                "narcotics_influence": 0.048,
                "confession": -0.08,
                "remorse": -0.064,
                "plea_agreement": -0.08,
                "family_circumstances": -0.032,
                "poor_financial_status": -0.024,
                "high_intensity_distress": -0.056,
                "provocation": -0.064,
                "negligence": -0.048,
                "attempted_offense": -0.18,
            },
            "false_feature_weights": {
                "previous_convictions": -0.064,
            },
        }

    def _load_sentencing_profile(self) -> None:
        if not self._profile_path.exists():
            return
        try:
            loaded = json.loads(self._profile_path.read_text(encoding="utf-8"))
        except Exception:
            return

        if not isinstance(loaded, dict):
            return

        merged = dict(self._sentencing_profile)
        for key in ("base_severity", "min_severity", "max_severity", "attempted_max_factor", "fine_threshold_both_mode"):
            value = loaded.get(key)
            if isinstance(value, (int, float)):
                merged[key] = float(value)

        for key in ("true_feature_weights", "false_feature_weights"):
            raw = loaded.get(key)
            if isinstance(raw, dict):
                normalized: dict[str, float] = {}
                for name, value in raw.items():
                    if isinstance(name, str) and isinstance(value, (int, float)):
                        normalized[name] = float(value)
                merged[key] = normalized

        self._sentencing_profile = merged

    def build_confidence_report(
        self,
        norms: list[str],
        cbr: CbrResult | None,
        suggested_verdict: str | None,
        subsystem_status: dict[str, str] | None = None,
    ) -> ReasoningConfidence:
        _ = suggested_verdict
        cbr_verdict, cbr_confidence = self._cbr_consensus(cbr)
        top_similarity = 0.0
        if cbr and cbr.matches:
            top_similarity = max(float(match.similarity or 0.0) for match in cbr.matches)

        rule_signal = "supports_conviction" if norms else "supports_rejection"
        cbr_signal = "unavailable"
        if cbr_verdict:
            cbr_signal = "supports_conviction" if self._is_positive(cbr_verdict) else "supports_rejection"

        conflict = cbr_signal != "unavailable" and cbr_signal != rule_signal

        decision_basis = "rule_only"
        final_confidence = 0.7 if norms else 0.6

        if subsystem_status and subsystem_status.get("cbr") == "error":
            cbr_signal = "unavailable"
            cbr_confidence = 0.0
            top_similarity = 0.0
            decision_basis = "rule_only"

        if subsystem_status and subsystem_status.get("rule") == "error":
            rule_signal = "unavailable"
            decision_basis = "manual_review"
            final_confidence = 0.2

        return ReasoningConfidence(
            decision_basis=decision_basis,
            final_confidence=round(final_confidence, 3),
            rule_signal=rule_signal,
            cbr_signal=cbr_signal,
            cbr_confidence=round(cbr_confidence, 3),
            cbr_top_similarity=round(top_similarity, 3),
            conflict=conflict,
        )

    def suggest_sanction(
        self,
        article_numbers: list[str],
        facts,
        norms: list[str] | None = None,
        verdict: str | None = None,
    ) -> str | None:
        normalized_verdict = normalize_outcome(verdict)
        if verdict == "manual_review":
            return "manualna procjena sankcije"
        if normalized_verdict in {"odbijeno", "oslobodjen", "nepoznato"}:
            return "bez sankcije"

        if not article_numbers:
            return "bez sankcije"

        candidate_norms = [str(item).strip() for item in (norms or []) if str(item).strip()]
        candidate_articles = self._unique_article_numbers(article_numbers)

        best_candidate: tuple[tuple[int, int, int], dict[str, object]] | None = None
        for norm in candidate_norms:
            structured = self._resolve_structured_sanction_from_norm(norm)
            if not structured:
                continue
            severity = self._rank_structured_sanction(structured)
            if best_candidate is None or severity > best_candidate[0]:
                best_candidate = (severity, structured)

        if best_candidate is not None:
            return self._suggest_exact_from_structured(best_candidate[1], facts, candidate_articles)

        best_article_candidate: tuple[tuple[int, int, int], dict[str, object]] | None = None
        for article in candidate_articles:
            structured = self._resolve_structured_sanction_from_article(article)
            if not structured:
                continue
            severity = self._rank_structured_sanction(structured)
            if best_article_candidate is None or severity > best_article_candidate[0]:
                best_article_candidate = (severity, structured)

        if best_article_candidate is not None:
            return self._suggest_exact_from_structured(best_article_candidate[1], facts, candidate_articles)

        # Compatibility fallback when structured parsing fails.
        for norm in candidate_norms:
            sanction = self._resolve_sanction_from_norm(norm)
            if sanction:
                return sanction

        for article in candidate_articles:
            sanction = self._resolve_sanction_from_article(article)
            if sanction:
                return sanction

        return "bez sankcije"

    def _unique_article_numbers(self, article_numbers: list[str]) -> list[str]:
        result: list[str] = []
        for article in article_numbers:
            normalized = str(article).strip()
            if normalized and normalized not in result:
                result.append(normalized)
        return result

    def _cbr_consensus(self, cbr: CbrResult | None) -> tuple[str | None, float]:
        if not cbr or not cbr.matches:
            return None, 0.0

        weighted_scores: dict[str, float] = {}
        total_weight = 0.0
        for match in cbr.matches[:3]:
            similarity = float(match.similarity or 0.0)
            if similarity < 0.55:
                continue
            outcome = normalize_outcome(match.outcome)
            if outcome == "nepoznato":
                continue
            weighted_scores[outcome] = weighted_scores.get(outcome, 0.0) + similarity
            total_weight += similarity

        if not weighted_scores or total_weight <= 0.0:
            return None, 0.0

        best_outcome, best_weight = max(weighted_scores.items(), key=lambda item: item[1])
        return best_outcome, (best_weight / total_weight)

    def _is_positive(self, verdict: str) -> bool:
        return normalize_outcome(verdict) in {"osudjen", "usvojeno"}

    def _resolve_sanction_from_norm(self, norm: str) -> str | None:
        match = re.match(r"crime_art(\d+[a-z]?)(?:_(\d+))?$", str(norm).strip().lower())
        if not match:
            return None

        article_number = match.group(1)
        paragraph_number = match.group(2)
        article = self._law_service.get_article(article_number)
        if not article:
            return None

        content = str(article.get("content") or "")
        paragraph_text = self._extract_paragraph_text(content, paragraph_number)
        if paragraph_text:
            sentence = self._extract_sanction_sentence(paragraph_text)
            canonical = self._canonicalize_sanction_sentence(sentence)
            if canonical:
                return canonical

        return self._resolve_sanction_from_metadata(article.get("sanctions"))

    def _resolve_sanction_from_article(self, article_number: str) -> str | None:
        article = self._law_service.get_article(article_number)
        if not article:
            return None
        return self._resolve_sanction_from_metadata(article.get("sanctions"))

    def _resolve_structured_sanction_from_norm(self, norm: str) -> dict[str, object] | None:
        match = re.match(r"crime_art(\d+[a-z]?)(?:_(\d+))?$", str(norm).strip().lower())
        if not match:
            return None

        article_number = match.group(1)
        paragraph_number = match.group(2)
        article = self._law_service.get_article(article_number)
        if not article:
            return None

        content = str(article.get("content") or "")
        paragraph_text = self._extract_paragraph_text(content, paragraph_number)
        if paragraph_text:
            sentence = self._extract_sanction_sentence(paragraph_text)
            structured = self._extract_structured_sanction_from_sentence(sentence)
            if structured:
                return structured

        return self._resolve_structured_sanction_from_metadata(article.get("sanctions"))

    def _resolve_structured_sanction_from_article(self, article_number: str) -> dict[str, object] | None:
        article = self._law_service.get_article(article_number)
        if not article:
            return None
        return self._resolve_structured_sanction_from_metadata(article.get("sanctions"))

    def _resolve_structured_sanction_from_metadata(self, sanctions) -> dict[str, object] | None:
        if not isinstance(sanctions, dict):
            return None

        sanction_type = str(sanctions.get("type") or "").lower()
        min_value = sanctions.get("min_value")
        max_value = sanctions.get("max_value")
        min_unit = str(sanctions.get("min_unit") or "").lower()
        max_unit = str(sanctions.get("max_unit") or "").lower()
        details = str(sanctions.get("details") or "").strip()

        min_months = self._to_months(min_value, min_unit) if min_value is not None else None
        max_months = self._to_months(max_value, max_unit) if max_value is not None else None

        if sanction_type in {"prison", "both"}:
            return {
                "mode": sanction_type,
                "min_months": min_months,
                "max_months": max_months,
                "raw": details or sanction_type,
            }

        if details:
            return {
                "mode": "other",
                "min_months": None,
                "max_months": None,
                "raw": details,
            }
        return None

    def _extract_structured_sanction_from_sentence(self, sentence: str) -> dict[str, object] | None:
        if not sentence:
            return None

        text = sentence.lower()
        text_ascii = (
            text.replace("č", "c")
            .replace("ć", "c")
            .replace("š", "s")
            .replace("ž", "z")
            .replace("đ", "dj")
        )
        text_ascii = re.sub(r"\s+", " ", text_ascii)

        both_match = re.search(
            r"novcanom kaznom ili zatvorom\s+do\s+([a-z0-9]+)\s+(godina|godine|godinu|mjeseci|mjeseca|mjesec|meseci|meseca|mesec)",
            text_ascii,
            re.IGNORECASE,
        )
        if both_match:
            max_months = self._to_months(self._parse_number_token(both_match.group(1)), both_match.group(2))
            return {
                "mode": "both",
                "min_months": 0,
                "max_months": max_months,
                "raw": sentence,
            }

        full_range = re.search(
            r"zatvorom\s+od\s+([a-z0-9]+)\s+(godina|godine|godinu|mjeseci|mjeseca|mjesec|meseci|meseca|mesec)\s+do\s+([a-z0-9]+)\s+(godina|godine|godinu|mjeseci|mjeseca|mjesec|meseci|meseca|mesec)",
            text_ascii,
            re.IGNORECASE,
        )
        if full_range:
            min_months = self._to_months(self._parse_number_token(full_range.group(1)), full_range.group(2))
            max_months = self._to_months(self._parse_number_token(full_range.group(3)), full_range.group(4))
            return {
                "mode": "prison",
                "min_months": min_months,
                "max_months": max_months,
                "raw": sentence,
            }

        compact_range = re.search(
            r"zatvorom\s+od\s+([a-z0-9]+)\s+do\s+([a-z0-9]+)\s+(godina|godine|godinu|mjeseci|mjeseca|mjesec|meseci|meseca|mesec)",
            text_ascii,
            re.IGNORECASE,
        )
        if compact_range:
            unit = compact_range.group(3)
            min_months = self._to_months(self._parse_number_token(compact_range.group(1)), unit)
            max_months = self._to_months(self._parse_number_token(compact_range.group(2)), unit)
            return {
                "mode": "prison",
                "min_months": min_months,
                "max_months": max_months,
                "raw": sentence,
            }

        max_only = re.search(
            r"zatvorom\s+do\s+([a-z0-9]+)\s+(godina|godine|godinu|mjeseci|mjeseca|mjesec|meseci|meseca|mesec)",
            text_ascii,
            re.IGNORECASE,
        )
        if max_only:
            max_months = self._to_months(self._parse_number_token(max_only.group(1)), max_only.group(2))
            return {
                "mode": "prison",
                "min_months": 0,
                "max_months": max_months,
                "raw": sentence,
            }

        return None

    def _suggest_exact_from_structured(
        self,
        sanction: dict[str, object],
        facts,
        article_numbers: list[str] | None = None,
    ) -> str:
        mode = str(sanction.get("mode") or "")
        min_months = sanction.get("min_months")
        max_months = sanction.get("max_months")
        raw = str(sanction.get("raw") or "").strip()

        min_value = int(min_months) if isinstance(min_months, int) else 0
        max_value = int(max_months) if isinstance(max_months, int) else None
        conditional_max = max_value or 0

        if mode == "other":
            return raw or "kazna po slobodnoj sudijskoj ocjeni (predlog)"

        if max_value is None and min_value <= 0:
            return raw or "kazna po slobodnoj sudijskoj ocjeni (predlog)"

        if max_value is None:
            exact_months = max(1, min_value)
        elif max_value <= min_value:
            exact_months = max_value
            conditional_max = max_value
        else:
            effective_min, effective_max = self._effective_range(min_value, max_value, facts, article_numbers)
            severity = self._sentencing_severity(facts)
            exact_months = int(round(effective_min + (effective_max - effective_min) * severity))
            exact_months = max(effective_min, min(effective_max, exact_months))
            conditional_max = effective_max

            fine_threshold = float(self._sentencing_profile.get("fine_threshold_both_mode") or 0.36)
            if mode == "both" and severity <= fine_threshold:
                return "novcana kazna (predlog)"

        if self._is_true(getattr(facts, "conditional_sentence_requested", None)) and conditional_max <= 60:
            return f"uslovna osuda uz utvrdjenu kaznu zatvora {self._format_duration(exact_months)} (predlog)"

        return f"kazna zatvora {self._format_duration(exact_months)} (predlog)"

    def _effective_range(
        self,
        min_value: int,
        max_value: int,
        facts,
        article_numbers: list[str] | None,
    ) -> tuple[int, int]:
        if not self._is_attempt_case(facts, article_numbers):
            return min_value, max_value

        factor = float(self._sentencing_profile.get("attempted_max_factor") or 0.6)
        factor = max(0.2, min(0.95, factor))
        adjusted_max = max(1, int(round(max_value * factor)))
        if adjusted_max < min_value:
            return 0, adjusted_max
        return 0, adjusted_max

    def _is_attempt_case(self, facts, article_numbers: list[str] | None) -> bool:
        if self._is_true(getattr(facts, "attempted_offense", None)):
            return True
        normalized_articles = {str(item).strip() for item in (article_numbers or []) if str(item).strip()}
        return "20" in normalized_articles

    def _sentencing_severity(self, facts) -> float:
        if facts is None:
            return float(self._sentencing_profile.get("base_severity") or 0.5)

        severity = float(self._sentencing_profile.get("base_severity") or 0.5)

        true_weights = self._sentencing_profile.get("true_feature_weights") or {}
        if isinstance(true_weights, dict):
            for feature_name, feature_weight in true_weights.items():
                if not isinstance(feature_name, str) or not isinstance(feature_weight, (int, float)):
                    continue
                if self._is_true(getattr(facts, feature_name, None)):
                    severity += float(feature_weight)

        false_weights = self._sentencing_profile.get("false_feature_weights") or {}
        if isinstance(false_weights, dict):
            for feature_name, feature_weight in false_weights.items():
                if not isinstance(feature_name, str) or not isinstance(feature_weight, (int, float)):
                    continue
                if self._is_false(getattr(facts, feature_name, None)):
                    severity += float(feature_weight)

        min_severity = float(self._sentencing_profile.get("min_severity") or 0.1)
        max_severity = float(self._sentencing_profile.get("max_severity") or 0.95)
        return max(min_severity, min(max_severity, severity))

    def _is_true(self, value) -> bool:
        return value is True

    def _is_false(self, value) -> bool:
        return value is False

    def _to_months(self, value, unit: str) -> int | None:
        if value is None:
            return None
        try:
            number = int(value)
        except (TypeError, ValueError):
            return None
        unit_lower = str(unit or "").lower()
        if unit_lower.startswith("month") or unit_lower.startswith("mjes") or unit_lower.startswith("mes"):
            return number
        return number * 12

    def _parse_number_token(self, token: str) -> int | None:
        text = str(token or "").strip().lower()
        text = re.sub(r"[^0-9a-zčćžšđ]", "", text)
        if not text:
            return None
        if text.isdigit():
            return int(text)

        word_map = {
            "jedan": 1,
            "jedna": 1,
            "jedne": 1,
            "jednog": 1,
            "dva": 2,
            "dvije": 2,
            "tri": 3,
            "četiri": 4,
            "cetiri": 4,
            "pet": 5,
            "šest": 6,
            "sest": 6,
            "sedam": 7,
            "osam": 8,
            "devet": 9,
            "deset": 10,
            "jedanaest": 11,
            "dvanaest": 12,
            "trinaest": 13,
            "četrnaest": 14,
            "cetrnaest": 14,
            "petnaest": 15,
            "šesnaest": 16,
            "sesnaest": 16,
            "sedamnaest": 17,
            "osamnaest": 18,
            "devetnaest": 19,
            "dvadeset": 20,
        }
        return word_map.get(text)

    def _format_duration(self, months: int) -> str:
        total = max(1, int(months))
        years = total // 12
        rem_months = total % 12

        if years and rem_months:
            return f"{self._year_label(years)} i {self._month_label(rem_months)}"
        if years:
            return self._year_label(years)
        return self._month_label(rem_months)

    def _year_label(self, years: int) -> str:
        if years == 1:
            suffix = "godina"
        elif 2 <= (years % 10) <= 4 and not 12 <= (years % 100) <= 14:
            suffix = "godine"
        else:
            suffix = "godina"
        return f"{years} {suffix}"

    def _month_label(self, months: int) -> str:
        if months == 1:
            suffix = "mesec"
        elif 2 <= (months % 10) <= 4 and not 12 <= (months % 100) <= 14:
            suffix = "meseca"
        else:
            suffix = "meseci"
        return f"{months} {suffix}"

    def _rank_structured_sanction(self, sanction: dict[str, object]) -> tuple[int, int, int]:
        mode = str(sanction.get("mode") or "")
        min_months = int(sanction.get("min_months") or 0)
        max_months_raw = sanction.get("max_months")
        max_months = int(max_months_raw) if isinstance(max_months_raw, int) else min_months

        if mode == "prison":
            return (3, max_months, min_months)
        if mode == "both":
            return (2, max_months, min_months)
        return (1, max_months, min_months)

    def _resolve_sanction_from_metadata(self, sanctions) -> str | None:
        if not sanctions:
            return None

        if isinstance(sanctions, dict):
            sanction_type = str(sanctions.get("type") or "").lower()
            min_value = sanctions.get("min_value")
            max_value = sanctions.get("max_value")
            min_unit = str(sanctions.get("min_unit") or "").lower()
            max_unit = str(sanctions.get("max_unit") or "").lower()
            details = str(sanctions.get("details") or "").strip()

            if sanction_type == "prison" and min_value is not None and max_value is not None:
                return self._format_prison_sanction(min_value, max_value, min_unit, max_unit)
            if sanction_type == "both" and details:
                return details
            if details:
                return details
        return None

    def _extract_paragraph_text(self, content: str, paragraph_number: str | None) -> str:
        if not content or not paragraph_number:
            return content

        pattern = re.compile(rf"\({re.escape(str(paragraph_number))}\)\s*(.*?)(?=\(\d+\)\s*|$)", re.DOTALL)
        match = pattern.search(content)
        if match:
            return match.group(0).strip()
        return ""

    def _extract_sanction_sentence(self, paragraph_text: str) -> str:
        if not paragraph_text:
            return ""

        lower = paragraph_text.lower()
        sanction_markers = ["kazniće se", "kazniti", "kazniće se"]
        for marker in sanction_markers:
            index = lower.find(marker)
            if index >= 0:
                sentence = paragraph_text[index:]
                sentence = sentence.split("\n", maxsplit=1)[0].strip()
                if sentence.endswith("."):
                    return sentence
                return sentence + "."
        return ""

    def _canonicalize_sanction_sentence(self, sentence: str) -> str | None:
        if not sentence:
            return None

        text = sentence.lower().replace("č", "c").replace("ć", "c").replace("š", "s").replace("ž", "z").replace("đ", "d")
        text = re.sub(r"\s+", " ", text).strip(" .")

        if "novcanom kaznom ili zatvorom do jedne godine" in text:
            return "novcana kazna ili zatvor do 1 godine (predlog)"
        if "zatvorom od sest mjeseci do pet godina" in text or "zatvorom od šest mjeseci do pet godina" in sentence.lower():
            return "kazna zatvora 6 meseci do 5 godina (predlog)"
        if "zatvorom od jedne do osam godina" in text:
            return "kazna zatvora 1 do 8 godina (predlog)"
        if "zatvorom od dvije do dvanaest godina" in text or "zatvorom od dve do dvanaest godina" in text:
            return "kazna zatvora 2 do 12 godina (predlog)"
        if "zatvorom od tri mjeseca do tri godine" in text or "zatvorom od tri meseca do tri godine" in text:
            return "kazna zatvora 3 meseca do 3 godine (predlog)"
        if "zatvorom do tri godine" in text:
            return "kazna zatvora do 3 godine (predlog)"
        if "zatvorom do sest mjeseci" in text or "zatvorom do šest mjeseci" in sentence.lower():
            return "kazna zatvora do 6 meseci (predlog)"
        if "zatvorom od tri mjeseca do pet godina" in text:
            return "kazna zatvora 3 meseca do 5 godina (predlog)"
        return None

    def _format_prison_sanction(self, min_value, max_value, min_unit: str, max_unit: str) -> str:
        min_label = self._unit_label(min_value, min_unit)
        max_label = self._unit_label(max_value, max_unit)
        if min_value == max_value:
            return f"kazna zatvora {min_label} (predlog)"
        return f"kazna zatvora {min_label} do {max_label} (predlog)"

    def _unit_label(self, value, unit: str) -> str:
        number = str(value).strip()
        if unit.startswith("month") or unit.startswith("mjes") or unit.startswith("mes"):
            return f"{number} meseci" if number != "1" else "1 mesec"
        return f"{number} godina" if number == "1" else f"{number} godina"

    def _rank_sanction(self, sanction: str) -> tuple[int, int, int]:
        text = sanction.lower()
        digits = [int(item) for item in re.findall(r"\d+", text)]
        if not digits:
            return (0, 0, 0)

        if "do" in text and len(digits) == 1:
            return (1, digits[0], 0)
        if len(digits) >= 2:
            return (2, digits[-1], digits[0])
        return (1, digits[0], 0)
