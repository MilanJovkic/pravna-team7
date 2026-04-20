"""Append-only audit logger for verdict generation events."""

from __future__ import annotations

from datetime import datetime, timezone
from pathlib import Path
import json


class GenerationAuditLogger:
    """Writes deterministic JSONL audit events for generation operations."""

    def __init__(self, verdicts_dir: Path) -> None:
        self.verdicts_dir = verdicts_dir
        self.audit_file = verdicts_dir / "generation_audit.jsonl"

    def log_event(self, case_id: str, event_type: str, payload: dict) -> None:
        self.verdicts_dir.mkdir(parents=True, exist_ok=True)
        event = {
            "timestamp": datetime.now(timezone.utc).isoformat(),
            "case_id": case_id,
            "event_type": event_type,
            "payload": payload,
        }
        with self.audit_file.open("a", encoding="utf-8") as handle:
            handle.write(json.dumps(event, ensure_ascii=False) + "\n")