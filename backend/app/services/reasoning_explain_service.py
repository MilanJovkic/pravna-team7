"""Service for mapping norms to law texts and suggesting outcomes."""
from __future__ import annotations

import json
import re
from pathlib import Path

from backend.app.models.schemas import CbrResult, ReasoningConfidence
from backend.app.services.law_service import LawService
from backend.app.domain.shared.outcome_normalization import normalize_outcome


ROOT = Path(__file__).resolve().parents[3]
DEFAULT_MAP_PATH = ROOT / "backend" / "app" / "resources" / "norms_to_articles.json"


class ReasoningExplainService:
    """Builds explanations and suggestions from reasoning results."""

    def __init__(self, map_path: Path | None = None):
        self.map_path = map_path or DEFAULT_MAP_PATH
        self._mapping = None
        self._law_service = LawService()

    def map_norms_to_articles(self, norms: list[str]) -> list[str]:
        mapping = self._load_mapping()
        articles = []
        for norm in norms:
            article = mapping.get(norm)
            if not article:
                article = self._infer_article(norm)
            if article and article not in articles:
                articles.append(article)
        return articles

    def get_applied_law_texts(self, article_numbers: list[str], norms: list[str] | None = None) -> list[dict]:
        paragraph_map = self._norm_paragraph_map(norms or [])
        texts = []
        for number in article_numbers:
            article = self._law_service.get_article(number)
            if not article:
                continue
            filtered_content = self._filter_article_content(
                content=article.get("content") or "",
                selected_paragraphs=paragraph_map.get(str(number).strip(), set()),
            )
            texts.append(
                {
                    "article_number": article["number"],
                    "title": article.get("title"),
                    "content": filtered_content,
                }
            )
        return texts

    def suggest_verdict(
        self,
        norms: list[str],
        cbr: CbrResult | None,
    ) -> str | None:
        rule_verdict = normalize_outcome("osudjen" if norms else "odbijeno")

        cbr_verdict, cbr_confidence = self._cbr_consensus(cbr)

        if not cbr_verdict:
            return self._normalize_criminal_outcome(rule_verdict)

        if self._is_positive(rule_verdict) == self._is_positive(cbr_verdict):
            if cbr_confidence >= 0.75:
                return self._normalize_criminal_outcome(cbr_verdict)
            return self._normalize_criminal_outcome(rule_verdict)

        rule_score = 0.65 if norms else -0.65
        cbr_score = cbr_confidence if self._is_positive(cbr_verdict) else -cbr_confidence
        fused = normalize_outcome("osudjen" if (rule_score + cbr_score) >= 0 else "odbijeno")
        return self._normalize_criminal_outcome(fused)

    def build_confidence_report(
        self,
        norms: list[str],
        cbr: CbrResult | None,
        suggested_verdict: str | None,
        subsystem_status: dict[str, str] | None = None,
    ) -> ReasoningConfidence:
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
        if cbr_signal != "unavailable":
            if conflict:
                decision_basis = "hybrid_conflict_resolution"
                final_confidence = max(0.55, min(0.88, 0.55 + (cbr_confidence * 0.25)))
            else:
                decision_basis = "hybrid_consensus"
                final_confidence = max(0.65, min(0.95, 0.65 + (cbr_confidence * 0.30)))

        if subsystem_status and subsystem_status.get("cbr") == "error":
            cbr_signal = "unavailable"
            cbr_confidence = 0.0
            top_similarity = 0.0
            decision_basis = "rule_only"

        if subsystem_status and subsystem_status.get("rule") == "error":
            rule_signal = "unavailable"
            if cbr_signal != "unavailable":
                decision_basis = "cbr_only"
                final_confidence = max(0.55, min(0.9, cbr_confidence))

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
        facts: CaseFacts | None = None,
        verdict: str | None = None,
    ) -> str | None:
        normalized_verdict = normalize_outcome(verdict)
        if normalized_verdict in {"odbijeno", "oslobodjen", "nepoznato"}:
            return "bez sankcije"

        if not article_numbers:
            return "bez sankcije"

        article_set = {str(item).strip() for item in article_numbers if str(item).strip()}
        has_151 = "151" in article_set
        has_152 = "152" in article_set

        if facts and facts.death_result:
            return "kazna zatvora 3 do 12 godina (predlog)"

        if facts and facts.severe_consequence and facts.weapon_used:
            return "kazna zatvora 1 do 8 godina (predlog)"

        if has_151 or (facts and facts.severe_consequence):
            return "kazna zatvora 6 meseci do 5 godina (predlog)"

        if has_152 or (facts and facts.injury_type and "laka" in facts.injury_type.lower()):
            return "novcana kazna ili zatvor do 1 godine (predlog)"

        if facts and facts.negligence:
            return "uslovna osuda ili novcana kazna (predlog)"

        return "kazna zatvora (predlog)"

    def _load_mapping(self) -> dict:
        if self._mapping is None:
            if self.map_path.exists():
                self._mapping = json.loads(self.map_path.read_text(encoding="utf-8"))
            else:
                self._mapping = {}
        return self._mapping

    def _infer_article(self, norm: str) -> str | None:
        match = re.search(r"crime_art(\d+[a-z]?)", norm, re.IGNORECASE)
        if not match:
            return None
        return match.group(1)

    def _cbr_consensus(self, cbr: CbrResult | None) -> tuple[str | None, float]:
        if not cbr or not cbr.matches:
            return None, 0.0

        weighted_scores: dict[str, float] = {}
        total_weight = 0.0
        considered = 0
        for match in cbr.matches[:3]:
            similarity = float(match.similarity or 0.0)
            if similarity < 0.5:
                continue
            outcome = normalize_outcome(match.outcome)
            if outcome == "nepoznato":
                continue
            considered += 1
            weighted_scores[outcome] = weighted_scores.get(outcome, 0.0) + similarity
            total_weight += similarity

        if not weighted_scores or total_weight <= 0.0 or considered <= 0:
            return None, 0.0

        best_outcome, best_weight = max(weighted_scores.items(), key=lambda item: item[1])
        confidence = (best_weight / total_weight) * (total_weight / considered)
        return best_outcome, confidence

    def _is_positive(self, verdict: str) -> bool:
        return normalize_outcome(verdict) in {"osudjen", "usvojeno"}

    def _normalize_criminal_outcome(self, verdict: str | None) -> str:
        normalized = normalize_outcome(verdict)
        if normalized == "usvojeno":
            return "osudjen"
        if normalized == "ukinuto":
            return "odbijeno"
        return normalized

    def _norm_paragraph_map(self, norms: list[str]) -> dict[str, set[str]]:
        mapping: dict[str, set[str]] = {}
        full_article_refs: set[str] = set()
        for norm in norms:
            value = str(norm or "").strip().lower()
            match = re.match(r"crime_art(\d+[a-z]?)(?:_(\d+))?$", value)
            if not match:
                continue
            article = match.group(1)
            paragraph = match.group(2)

            if article in full_article_refs:
                continue

            if paragraph:
                mapping.setdefault(article, set()).add(paragraph)
            else:
                full_article_refs.add(article)
                mapping[article] = set()
        return mapping

    def _filter_article_content(self, content: str, selected_paragraphs: set[str]) -> str:
        if not content or not selected_paragraphs:
            return content

        # Support both paragraph markers: "(1)" and "1)".
        matches = list(re.finditer(r"(?m)^\s*(?:\((\d+)\)|(\d+)\))", content))
        if not matches:
            return content

        slices: list[str] = []
        for i, match in enumerate(matches):
            paragraph_no = match.group(1) or match.group(2)
            start = match.start()
            end = matches[i + 1].start() if i + 1 < len(matches) else len(content)
            if paragraph_no in selected_paragraphs:
                text = content[start:end].strip()
                if text:
                    slices.append(text)

        if not slices:
            return content

        # Keep introductory sentence before enumerated items when present.
        preface = content[: matches[0].start()].strip()
        if preface:
            return preface + "\n\n" + "\n\n".join(slices)
        return "\n\n".join(slices)
