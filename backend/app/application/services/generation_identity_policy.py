"""Deterministic identity policy for generated verdict artifacts."""

from __future__ import annotations

from hashlib import sha256
from pathlib import Path
import json

from backend.app.models.schemas import VerdictGenerationRequest


class GenerationIdentityPolicy:
    """Provides deterministic idempotency keys and file-safe case identifiers."""

    def compute_idempotency_key(
        self,
        payload: VerdictGenerationRequest,
        case_number: str,
        court_name: str,
        date_value: str,
        judges: list[str],
        selected_verdict: str,
        selected_sanction: str,
    ) -> str:
        canonical_payload = {
            "case_number": case_number,
            "court_name": court_name,
            "date": date_value,
            "judges": judges,
            "selected_verdict": selected_verdict,
            "selected_sanction": selected_sanction,
            "facts": payload.facts.model_dump(mode="json"),
            "reasoning": payload.reasoning.model_dump(mode="json"),
        }
        encoded = json.dumps(canonical_payload, ensure_ascii=False, sort_keys=True).encode("utf-8")
        return sha256(encoded).hexdigest()

    def resolve_case_id(self, verdicts_dir: Path, case_number: str, idempotency_key: str) -> str:
        base_case_id = self._sanitize_case_id(case_number)
        base_path = verdicts_dir / f"{base_case_id}.xml"
        if not base_path.exists():
            return base_case_id

        deterministic_suffix = idempotency_key[:8]
        deterministic_case_id = f"{base_case_id}-{deterministic_suffix}"
        return deterministic_case_id

    def _sanitize_case_id(self, value: str) -> str:
        return (
            value.replace("/", "_")
            .replace("\\", "_")
            .replace(":", "_")
            .replace(" ", "_")
        )