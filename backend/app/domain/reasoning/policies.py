"""Domain policies for reasoning confidence and sanction suggestions."""
from __future__ import annotations

import re

from backend.app.models.schemas import CbrResult, ReasoningConfidence
from backend.app.domain.shared.outcome_normalization import normalize_outcome
from backend.app.services.law_service import LawService


class ReasoningPolicy:
    """Domain policy module for confidence and sanction heuristics."""

    def __init__(self) -> None:
        self._law_service = LawService()

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
        candidate_articles = {str(item).strip() for item in article_numbers if str(item).strip()}

        best_candidate: tuple[tuple[int, int, int], str] | None = None
        for norm in candidate_norms:
            sanction = self._resolve_sanction_from_norm(norm)
            if not sanction:
                continue
            severity = self._rank_sanction(sanction)
            if best_candidate is None or severity > best_candidate[0]:
                best_candidate = (severity, sanction)

        if best_candidate is not None:
            return best_candidate[1]

        for article in candidate_articles:
            sanction = self._resolve_sanction_from_article(article)
            if sanction:
                return sanction

        return "bez sankcije"

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
