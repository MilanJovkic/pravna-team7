"""Explicit mappers between domain verdict metadata and API DTO models."""
from __future__ import annotations

from typing import Optional

from backend.app.domain.verdict.entities import VerdictMetadata as DomainVerdictMetadata
from backend.app.models.schemas import VerdictMetadataDTO


def verdict_domain_to_dto(
    metadata: DomainVerdictMetadata,
    *,
    case_id: str,
    summary: Optional[str] = None,
    legal_issues: Optional[list[str]] = None,
    decision: Optional[str] = None,
    outcome: Optional[str] = None,
    extraction_confidence: Optional[float] = None,
    needs_review: bool = False,
    legal_concepts: Optional[list[str]] = None,
) -> VerdictMetadataDTO:
    """Map domain verdict metadata into API DTO shape."""
    return VerdictMetadataDTO(
        case_id=case_id,
        case_number=metadata.case_number,
        court_name=metadata.court_name,
        date=metadata.date,
        judges=list(metadata.judges or []),
        summary=summary,
        legal_issues=list(legal_issues or []),
        applied_laws=list(metadata.legal_references or []),
        applied_articles=list(metadata.article_references or []),
        decision=decision,
        outcome=outcome,
        extraction_confidence=extraction_confidence,
        needs_review=needs_review,
        legal_concepts=list(legal_concepts or []),
        parties=dict(metadata.parties or {}),
        factual_state=dict(metadata.factual_state or {}),
    )


def verdict_dto_to_domain(dto: VerdictMetadataDTO) -> DomainVerdictMetadata:
    """Map API DTO model back into canonical domain metadata."""
    return DomainVerdictMetadata(
        case_number=dto.case_number,
        court_name=dto.court_name,
        date=dto.date,
        judges=list(dto.judges or []),
        parties=dict(dto.parties or {}),
        organizations=[],
        legal_references=list(dto.applied_laws or []),
        article_references=list(dto.applied_articles or []),
        factual_state=dict(dto.factual_state or {}),
        raw_text="",
    )
