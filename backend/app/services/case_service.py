"""Service for inserting new cases into PostgreSQL."""
from __future__ import annotations

from datetime import datetime

from backend.app.infrastructure.persistence.postgres.case_repository_pg import (
    PostgresCaseRepository,
)
from backend.app.models.schemas import CaseFacts
from backend.app.ports.outbound.case_repository import CaseRepository, PersistCaseRecord
from backend.app.services.cbr_normalization import (
    normalize_fight_consequence,
    normalize_injury_type,
    normalize_text,
)
from backend.app.domain.shared.outcome_normalization import normalize_outcome


class CaseService:
    """Service for persisting new cases in the CBR database."""

    def __init__(self, repository: CaseRepository | None = None) -> None:
        self._repository = repository or PostgresCaseRepository()

    def insert_case(
        self,
        facts: CaseFacts,
        outcome: str | None,
        case_number: str | None,
        verdict_type: str | None,
        sanction: str | None,
    ) -> dict:
        canonical_outcome = normalize_outcome(outcome)

        payload = facts.model_dump()
        payload.update(
            {
                "injury_type": normalize_injury_type(facts.injury_type),
                "location": normalize_text(facts.location),
                "weapon": normalize_text(facts.weapon),
                "fight_consequence": normalize_fight_consequence(facts.fight_consequence),
            }
        )
        normalized = CaseFacts(**payload)

        existing = self._repository.find_existing_case(
            facts=normalized,
            outcome=canonical_outcome,
            verdict_type=verdict_type,
            sanction=sanction,
        )
        if existing:
            existing_id, existing_case_number = existing
            return {
                "id": existing_id,
                "case_number": existing_case_number,
                "reused_existing": True,
                "version": self._extract_version(existing_case_number),
            }

        version = self._repository.next_version(facts=normalized)
        if case_number:
            case_number = case_number.strip()
        if not case_number:
            case_number = self._generate_case_number(version=version)
        elif version > 1 and "-v" not in case_number.lower():
            case_number = f"{case_number}-v{version}"

        new_id, new_case_number = self._repository.insert_case(
            PersistCaseRecord(
                case_number=case_number,
                facts=normalized,
                outcome=canonical_outcome,
                verdict_type=verdict_type,
                sanction=sanction,
            )
        )

        return {
            "id": new_id,
            "case_number": new_case_number,
            "reused_existing": False,
            "version": version,
        }

    def _generate_case_number(self, version: int = 1) -> str:
        stamp = datetime.now().strftime("%Y%m%d-%H%M%S")
        base = f"USER-{stamp}"
        if version <= 1:
            return base
        return f"{base}-v{version}"

    def _extract_version(self, case_number: str) -> int:
        value = (case_number or "").strip()
        marker = "-v"
        idx = value.lower().rfind(marker)
        if idx == -1:
            return 1
        suffix = value[idx + len(marker):]
        if suffix.isdigit():
            return int(suffix)
        return 1

