"""Filesystem adapter for law document persistence."""
from __future__ import annotations

import json
from pathlib import Path
from typing import Any
from xml.etree import ElementTree as ET

from backend.app.domain.law.references import parse_reference_href


class FileSystemLawRepository:
    """Read law text, annotations, and XML references from project files."""

    AKOMA_NS = "{http://docs.oasis-open.org/legaldocml/ns/akn/3.0/WD17}"

    @staticmethod
    def _resolve_project_root(start_path: Path) -> Path:
        """Find workspace root by looking for expected project files."""
        for parent in [start_path, *start_path.parents]:
            if (parent / "data" / "zakon.txt").exists() and (parent / "backend").exists():
                return parent
        # Fallback for legacy relative layout assumptions.
        return start_path.parents[5]

    def __init__(self, project_root: Path | None = None) -> None:
        root = project_root or self._resolve_project_root(Path(__file__).resolve())
        self._law_file = root / "data" / "zakon.txt"
        self._xml_file = root / "output" / "annotated_law.xml"
        self._output_dir = root / "output"
        self._data_dir = root / "data"

    def load_law_text(self) -> str:
        return self._law_file.read_text(encoding="utf-8")

    def get_cache_version(self) -> str:
        def mtime_or_zero(path: Path) -> float:
            if not path.exists():
                return 0.0
            return path.stat().st_mtime

        annotations_candidates = list(self._output_dir.glob("*_annotations.json"))
        if not annotations_candidates:
            annotations_candidates = list(self._data_dir.glob("*_annotations.json"))
        annotations_path = annotations_candidates[0] if annotations_candidates else None

        parts = [
            f"law:{mtime_or_zero(self._law_file)}",
            f"xml:{mtime_or_zero(self._xml_file)}",
            f"ann:{mtime_or_zero(annotations_path) if annotations_path else 0.0}",
        ]
        return "|".join(parts)

    def load_annotations(self) -> dict[str, Any]:
        potential_files = list(self._output_dir.glob("*_annotations.json"))
        if not potential_files:
            potential_files = list(self._data_dir.glob("*_annotations.json"))
        if not potential_files:
            return {}
        return json.loads(potential_files[0].read_text(encoding="utf-8"))

    def load_xml_references(self) -> dict[str, list[dict[str, Any]]]:
        if not self._xml_file.exists():
            return {}

        references_by_article: dict[str, list[dict[str, Any]]] = {}
        tree = ET.parse(self._xml_file)
        root = tree.getroot()

        for article in root.findall(f".//{self.AKOMA_NS}article"):
            article_id = article.get("eId", "")
            if not article_id.startswith("art_"):
                continue

            article_number = article_id.replace("art_", "")
            article_refs: list[dict[str, Any]] = []
            for ref in article.findall(f".//{self.AKOMA_NS}ref"):
                href = ref.get("href", "")
                parsed_ref = parse_reference_href(href)
                article_refs.append(
                    {
                        "href": href,
                        "text": ref.text or "",
                        "normalized_href": parsed_ref["normalized_href"],
                        "reference_kind": parsed_ref["kind"],
                        "target_article": parsed_ref["article_number"],
                        "target_paragraph": parsed_ref["paragraph_number"],
                        "target_point": parsed_ref["point_number"],
                    }
                )

            if article_refs:
                references_by_article[article_number] = article_refs

        return references_by_article
