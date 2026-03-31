"""Domain annotation model for generated verdict semantics."""

from __future__ import annotations

from dataclasses import dataclass
from typing import Any


@dataclass
class VerdictAnnotation:
    """Semantic annotation attached to generated verdicts."""

    verdict_summary: str
    legal_issues: list[str]
    applied_laws: list[str]
    applied_articles: list[str]
    legal_reasoning: str
    decision: str
    case_outcome: str
    legal_concepts: list[str]
    precedent_value: str | None = None
    confidence: float | None = None
    needs_review: bool = False
    review_reason: str | None = None
    extraction_method: str = "hybrid_regex_llm"
    metadata: dict[str, Any] | None = None
    factual_state: dict[str, list[str]] | None = None
    raw_response: str | None = None
