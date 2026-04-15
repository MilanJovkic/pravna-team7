"""Pre-reasoning validation for case facts."""
from __future__ import annotations

from backend.app.domain.shared.errors import ValidationError
from backend.app.models.schemas import CaseFacts, ReasoningRequest


class ReasoningInputValidator:
    """Validate reasoning requests before invoking external engines."""

    def validate(self, request: ReasoningRequest) -> None:
        facts = request.facts
        if facts.material_fact_count() == 0:
            raise ValidationError("Nedostaju činjenice: glavni tok rezonovanja zahteva makar jednu materijalnu činjenicu.")
        issues = facts.validation_issues(strict_mode=request.strict_mode)
        if issues:
            raise ValidationError("; ".join(issues))

    def validate_facts(self, facts: CaseFacts, strict_mode: bool = True) -> None:
        if facts.material_fact_count() == 0:
            raise ValidationError("Nedostaju činjenice: glavni tok rezonovanja zahteva makar jednu materijalnu činjenicu.")
        issues = facts.validation_issues(strict_mode=strict_mode)
        if issues:
            raise ValidationError("; ".join(issues))