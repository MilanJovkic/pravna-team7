"""Stage-1 generation plan builder for verdict generation workflow."""
from __future__ import annotations

from backend.app.models.schemas import CaseFacts, ReasoningResponse


class VerdictGenerationPlanBuilder:
    """Build deterministic generation plan from facts and reasoning context."""

    def build(
        self,
        facts: CaseFacts,
        reasoning: ReasoningResponse,
        selected_verdict: str,
        selected_sanction: str,
    ) -> dict:
        return {
            "case_summary": {
                "defendant": facts.defendant,
                "injury_type": facts.injury_type,
                "location": facts.location,
                "weapon": facts.weapon,
            },
            "applicable_laws": {
                "applied_norms": reasoning.rule_reasoning.applied_norms if reasoning.rule_reasoning else [],
                "applied_articles": reasoning.applied_articles or [],
            },
            "key_facts": {
                "weapon_used": facts.weapon_used,
                "severe_consequence": facts.severe_consequence,
                "death_result": facts.death_result,
                "negligence": facts.negligence,
                "provocation": facts.provocation,
                "fight_participation": facts.fight_participation,
                "left_without_help": facts.left_without_help,
            },
            "proposed_verdict": selected_verdict,
            "proposed_sanction": selected_sanction,
            "reasoning_summary": reasoning.suggested_verdict,
        }
