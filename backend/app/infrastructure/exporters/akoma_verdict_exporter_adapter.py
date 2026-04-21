"""Adapter around legacy verdict exporter implementation."""

from __future__ import annotations

from backend.app.domain.verdict.annotation import VerdictAnnotation
from backend.app.domain.verdict.entities import VerdictMetadata
from backend.app.infrastructure.exporters.verdict_exporter import VerdictAkomaExporter


class AkomaVerdictExporterAdapter:
    """Hexagonal adapter that delegates export to legacy implementation."""

    def __init__(self, enable_db_insert: bool = True) -> None:
        self._legacy_exporter = VerdictAkomaExporter(enable_db_insert=enable_db_insert)

    def export(
        self,
        verdict_metadata: VerdictMetadata,
        annotation: VerdictAnnotation | None,
        output_file: str,
        case_id: str,
    ) -> str:
        return self._legacy_exporter.export(
            verdict_metadata=verdict_metadata,
            annotation=annotation,
            output_file=output_file,
            case_id=case_id,
        )
