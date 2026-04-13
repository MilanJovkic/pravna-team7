"""Post-generation quality checks for generated verdict texts."""

from __future__ import annotations

from backend.app.models.schemas import CaseFacts, ReasoningResponse


class PostGenerationValidator:
    """Single-responsibility validator for stage-3 verdict quality checks."""

    def validate(
        self,
        verdict_text: str,
        facts: CaseFacts,
        reasoning: ReasoningResponse,
        generation_plan: dict,
    ) -> dict:
        del facts  # Kept in signature for stable call contract and future rules.
        errors = []
        has_legal_refs = False

        if reasoning.applied_articles:
            for article in reasoning.applied_articles:
                if f"Član {article}" in verdict_text or f"član {article.lower()}" in verdict_text.lower():
                    has_legal_refs = True
                    break

        verdict_keywords = ["osudjen", "opravdan", "decision", "presuda"]
        has_verdict = any(kw in verdict_text.lower() for kw in verdict_keywords)

        sanction_keywords = ["zatvor", "novčana", "kazna", "suspenzija"]
        has_sanction = any(kw in verdict_text.lower() for kw in sanction_keywords)

        if not has_legal_refs and reasoning.applied_articles:
            errors.append("Missing legal article references in verdict text")

        return {
            "stage_1_plan": {
                "status": "ok",
                "sections": list(generation_plan.keys()),
            },
            "stage_2_expansion": {
                "status": "ok",
                "length": len(verdict_text),
            },
            "post_validation": {
                "legal_references_valid": has_legal_refs or len(errors) == 0,
                "sanction_format_valid": has_sanction,
                "structure_valid": has_verdict and len(verdict_text) > 100,
                "errors": errors,
            },
            "overall_quality": "pass" if len(errors) == 0 else "warning",
        }