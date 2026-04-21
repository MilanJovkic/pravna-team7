"""Coordinates verdict XML export and annotation index persistence."""

from __future__ import annotations

from dataclasses import asdict
from pathlib import Path
import json

from backend.app.domain.verdict.annotation import VerdictAnnotation
from backend.app.domain.verdict.entities import VerdictMetadata


class ExportOrchestrator:
    """Single-responsibility export coordinator for generated verdict artifacts."""

    def __init__(self, verdicts_dir: Path) -> None:
        self.verdicts_dir = verdicts_dir

    def export(
        self,
        exporter: object,
        case_id: str,
        metadata: VerdictMetadata,
        annotation: VerdictAnnotation,
    ) -> Path:
        self.verdicts_dir.mkdir(parents=True, exist_ok=True)
        output_file = self.verdicts_dir / f"{case_id}.xml"

        exporter.export(metadata, annotation, str(output_file), case_id)
        self._update_annotations_json(case_id, annotation)
        return output_file

    def _update_annotations_json(self, case_id: str, annotation: VerdictAnnotation) -> None:
        annotations_file = self.verdicts_dir / "verdicts_annotations.json"
        existing: dict[str, dict] = {}
        if annotations_file.exists():
            try:
                existing = json.loads(annotations_file.read_text(encoding="utf-8"))
            except Exception:
                existing = {}
        existing[case_id] = asdict(annotation)
        annotations_file.write_text(json.dumps(existing, ensure_ascii=False, indent=2), encoding="utf-8")