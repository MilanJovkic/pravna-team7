"""Filesystem adapter for verdict XML documents and annotations."""
from __future__ import annotations

import json
from pathlib import Path
from typing import Any
from xml.etree import ElementTree as ET


class FileSystemVerdictRepository:
    """Read verdict XML artifacts and annotation JSON from filesystem."""

    @staticmethod
    def _resolve_project_root(start_path: Path) -> Path:
        """Find workspace root by looking for expected verdict data layout."""
        for parent in [start_path, *start_path.parents]:
            if (parent / "data" / "verdicts_xml").exists() and (parent / "backend").exists():
                return parent
        # Fallback for legacy relative layout assumptions.
        return start_path.parents[5]

    def __init__(self, project_root: Path | None = None) -> None:
        root = project_root or self._resolve_project_root(Path(__file__).resolve())
        self._xml_dir = root / "data" / "verdicts_xml"
        self._annotations_file = self._xml_dir / "verdicts_annotations.json"

    def load_verdict_documents(self) -> dict[str, dict[str, Any]]:
        documents: dict[str, dict[str, Any]] = {}
        for case_id, document in self.iter_verdict_documents():
            documents[case_id] = document

        return documents

    def iter_verdict_documents(self):
        if not self._xml_dir.exists():
            return

        for xml_file in self._xml_dir.glob("*.xml"):
            try:
                tree = ET.parse(xml_file)
                root = tree.getroot()
                judgment = root.find(".//{http://docs.oasis-open.org/legaldocml/ns/akn/3.0/WD17}judgment")
                if judgment is None:
                    judgment = root.find(".//judgment")
                if judgment is None:
                    continue

                case_id = judgment.get("name", xml_file.stem)
                yield case_id, {
                    "file": str(xml_file),
                    "tree": tree,
                    "root": root,
                }
            except Exception:
                continue

    def load_annotations(self) -> dict[str, Any]:
        if not self._annotations_file.exists():
            return {}
        try:
            return json.loads(self._annotations_file.read_text(encoding="utf-8"))
        except Exception:
            return {}
