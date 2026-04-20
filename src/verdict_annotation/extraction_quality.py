"""Quality assessment helpers for extraction confidence and review flags."""
from __future__ import annotations

from typing import List, Tuple

from .verdict_annotator import VerdictAnnotation


DEFAULT_CONFIDENCE_THRESHOLD = 0.65


def assess_annotation_quality(
    annotation: VerdictAnnotation,
    confidence_threshold: float = DEFAULT_CONFIDENCE_THRESHOLD,
) -> Tuple[bool, List[str]]:
    """Return needs_review flag and reasons for extraction quality checks."""
    reasons: List[str] = []

    confidence = annotation.confidence
    if confidence is None:
        reasons.append("missing_confidence")
    elif confidence < confidence_threshold:
        reasons.append(f"low_confidence<{confidence_threshold}")

    if not (annotation.applied_articles or []):
        reasons.append("missing_applied_articles")
    if not (annotation.applied_laws or []):
        reasons.append("missing_applied_laws")
    if not (annotation.factual_state or {}):
        reasons.append("missing_factual_state")

    return (len(reasons) > 0, reasons)
