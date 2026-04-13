"""Filesystem override repository with optimistic locking and atomic writes."""
from __future__ import annotations

import hashlib
import json
from pathlib import Path
from tempfile import NamedTemporaryFile
from typing import Any

from backend.app.ports.outbound.override_repository import OptimisticLockConflictError


class FileSystemOverrideRepository:
    """Store overrides/audit as JSON files with revision checks."""

    def __init__(self, project_root: Path | None = None) -> None:
        root = project_root or Path(__file__).resolve().parents[6]
        xml_dir = root / "data" / "verdicts_xml"
        self._overrides_file = xml_dir / "verdicts_overrides.json"
        self._audit_file = xml_dir / "verdicts_overrides_audit.json"

    @property
    def overrides_file_path(self) -> str:
        return str(self._overrides_file)

    @property
    def audit_file_path(self) -> str:
        return str(self._audit_file)

    def load_overrides(self) -> tuple[dict[str, Any], str]:
        return self._load_json_with_revision(self._overrides_file)

    def save_overrides(self, data: dict[str, Any], expected_revision: str) -> str:
        return self._save_json_with_revision(self._overrides_file, data, expected_revision)

    def load_audit(self) -> tuple[dict[str, Any], str]:
        return self._load_json_with_revision(self._audit_file)

    def save_audit(self, data: dict[str, Any], expected_revision: str) -> str:
        return self._save_json_with_revision(self._audit_file, data, expected_revision)

    def _load_json_with_revision(self, file_path: Path) -> tuple[dict[str, Any], str]:
        if not file_path.exists():
            return {}, "missing"

        content = file_path.read_text(encoding="utf-8")
        try:
            payload = json.loads(content)
            if not isinstance(payload, dict):
                payload = {}
        except Exception:
            payload = {}

        return payload, self._hash_content(content)

    def _save_json_with_revision(
        self,
        file_path: Path,
        data: dict[str, Any],
        expected_revision: str,
    ) -> str:
        current_data, current_revision = self._load_json_with_revision(file_path)
        _ = current_data
        if expected_revision != current_revision:
            raise OptimisticLockConflictError("Override storage changed concurrently.")

        serialized = json.dumps(data, ensure_ascii=False, indent=2)
        file_path.parent.mkdir(parents=True, exist_ok=True)
        with NamedTemporaryFile("w", encoding="utf-8", delete=False, dir=str(file_path.parent)) as tmp:
            tmp.write(serialized)
            tmp_path = Path(tmp.name)

        tmp_path.replace(file_path)
        return self._hash_content(serialized)

    def _hash_content(self, content: str) -> str:
        return hashlib.sha256(content.encode("utf-8")).hexdigest()
