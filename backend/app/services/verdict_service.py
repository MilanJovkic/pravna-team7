"""Service for loading and processing verdict documents."""
import json
import math
from pathlib import Path
from typing import List, Optional
from xml.etree import ElementTree as ET


class VerdictService:
    """Service for verdict document operations."""

    AKOMA_NS = {"akn": "http://docs.oasis-open.org/legaldocml/ns/akn/3.0/WD17"}

    def __init__(self):
        self.xml_dir = Path(__file__).parent.parent.parent.parent / "data" / "verdicts_xml"
        self.annotations_file = self.xml_dir / "verdicts_annotations.json"
        self.overrides_file = self.xml_dir / "verdicts_overrides.json"
        self._verdicts = None
        self._annotations = None
        self._annotations_mtime = None
        self._overrides = None
        self._overrides_mtime = None

    def _load_verdicts(self):
        """Load all verdict XML files."""
        if not self.xml_dir.exists():
            self._verdicts = {}
            return self._verdicts

        xml_files = list(self.xml_dir.glob("*.xml"))
        file_stems = {file.stem for file in xml_files}
        if self._verdicts is not None and len(self._verdicts) == len(xml_files):
            if file_stems.issubset(self._verdicts.keys()):
                return self._verdicts

        self._verdicts = {}
        for xml_file in xml_files:
            try:
                tree = ET.parse(xml_file)
                root = tree.getroot()
                
                judgment = root.find(".//{http://docs.oasis-open.org/legaldocml/ns/akn/3.0/WD17}judgment")
                if judgment is None:
                    judgment = root.find(".//judgment")
                
                if judgment is not None:
                    case_id = judgment.get("name", xml_file.stem)
                    self._verdicts[case_id] = {
                        "file": str(xml_file),
                        "tree": tree,
                        "root": root
                    }
            except Exception as e:
                print(f"Error loading {xml_file}: {e}")

        return self._verdicts

    def _load_annotations(self):
        """Load verdict annotations."""
        if self.annotations_file.exists():
            mtime = self.annotations_file.stat().st_mtime
            if self._annotations is None or self._annotations_mtime != mtime:
                with open(self.annotations_file, "r", encoding="utf-8") as f:
                    self._annotations = json.load(f)
                self._annotations_mtime = mtime
        else:
            self._annotations = {}
            self._annotations_mtime = None
        return self._annotations

    def _load_overrides(self):
        """Load manual overrides for verdicts."""
        if self.overrides_file.exists():
            mtime = self.overrides_file.stat().st_mtime
            if self._overrides is None or self._overrides_mtime != mtime:
                with open(self.overrides_file, "r", encoding="utf-8") as f:
                    self._overrides = json.load(f)
                self._overrides_mtime = mtime
        else:
            self._overrides = {}
            self._overrides_mtime = None
        return self._overrides

    def get_overrides(self, case_id: str) -> dict:
        """Return manual overrides for a verdict if present."""
        overrides = self._load_overrides()
        return overrides.get(case_id, {})

    def update_overrides(self, case_id: str, payload: dict) -> dict:
        """Persist manual overrides for a verdict."""
        overrides = self._load_overrides()
        existing = overrides.get(case_id, {})
        for key, value in payload.items():
            if value is None:
                existing.pop(key, None)
            else:
                existing[key] = value
        overrides[case_id] = existing
        self.overrides_file.parent.mkdir(parents=True, exist_ok=True)
        with open(self.overrides_file, "w", encoding="utf-8") as f:
            json.dump(overrides, f, ensure_ascii=False, indent=2)
        self._overrides = overrides
        self._overrides_mtime = self.overrides_file.stat().st_mtime
        return existing

    def get_all_verdicts(self):
        """Get list of all verdicts."""
        verdicts = self._load_verdicts()
        annotations = self._load_annotations()
        
        result = []
        for case_id in verdicts.keys():
            if self._is_generated_case(case_id):
                continue
            metadata = self._extract_metadata(case_id)
            result.append(metadata)

        return self._sort_verdicts(result)

    def _is_generated_case(self, case_id: str) -> bool:
        return str(case_id or "").strip().upper().startswith("GEN")

    def get_verdicts_paginated(self, page: int = 1, page_size: int = 20) -> dict:
        """Return paginated verdict metadata for scalable list rendering."""
        all_verdicts = self.get_all_verdicts()
        total = len(all_verdicts)
        total_pages = max(1, math.ceil(total / page_size))
        current_page = min(max(1, page), total_pages)

        start_idx = (current_page - 1) * page_size
        end_idx = start_idx + page_size
        items = all_verdicts[start_idx:end_idx]

        return {
            "total": total,
            "page": current_page,
            "page_size": page_size,
            "total_pages": total_pages,
            "verdicts": items,
        }

    def _sort_verdicts(self, verdicts: list[dict]) -> list[dict]:
        """Sort verdicts by date descending, then case number for stable pagination."""
        def key(item: dict) -> tuple:
            date_value = (item.get("date") or "").strip()
            case_number = (item.get("case_number") or item.get("case_id") or "").strip()
            return (date_value, case_number)

        return sorted(verdicts, key=key, reverse=True)

    def get_verdict(self, case_id: str):
        """Get specific verdict details."""
        verdicts = self._load_verdicts()
        annotations = self._load_annotations()
        overrides = self._load_overrides()
        
        if case_id not in verdicts:
            return None
        
        metadata = self._extract_metadata(case_id)
        annotation = annotations.get(case_id, {})
        
        # Add full details
        metadata.update({
            "legal_reasoning": annotation.get("legal_reasoning"),
            "precedent_value": annotation.get("precedent_value"),
            "confidence": annotation.get("confidence")
        })

        override = overrides.get(case_id, {})
        if override:
            metadata = self._apply_override(metadata, override)
        
        return metadata

    def _extract_metadata(self, case_id: str):
        """Extract metadata from verdict XML."""
        verdicts = self._load_verdicts()
        annotations = self._load_annotations()
        overrides = self._load_overrides()
        
        if case_id not in verdicts:
            return None
        
        root = verdicts[case_id]["root"]
        annotation = annotations.get(case_id, {})

        xml_summary = self._find_text(root, ".//block[@name='summary']/p")
        xml_legal_issues = self._find_all_text(root, ".//block[@name='legalIssues']/p")
        xml_applied_laws = self._find_all_text(root, ".//block[@name='appliedLaws']/ref")
        xml_applied_articles = self._find_all_text(root, ".//block[@name='appliedArticles']/ref")
        xml_legal_reasoning = self._find_text(root, ".//block[@name='reasoning']/p")
        xml_decision = self._find_text(root, ".//block[@name='verdict']/p")
        xml_outcome = self._find_attr(root, ".//block[@name='verdict']", "outcome")
        xml_full_text = self._find_text(root, ".//block[@name='fullText']/p")
        
        metadata = {
            "case_id": case_id,
            "case_number": self._find_text(root, ".//docNumber"),
            "court_name": self._find_text(root, ".//docTitle"),
            "date": self._find_attr(root, ".//docDate", "date") or self._find_text(root, ".//docDate"),
            "judges": self._find_all_text(root, ".//judge"),
            "summary": annotation.get("verdict_summary") or xml_summary,
            "legal_issues": annotation.get("legal_issues") or xml_legal_issues,
            "applied_laws": annotation.get("applied_laws") or xml_applied_laws,
            "applied_articles": annotation.get("applied_articles") or xml_applied_articles,
            "decision": annotation.get("decision") or xml_decision,
            "outcome": annotation.get("case_outcome") or xml_outcome,
            "legal_concepts": annotation.get("legal_concepts", []),
            "parties": self._extract_participants(root),
            "factual_state": self._extract_factual_state(root, annotation),
            "full_text": xml_full_text
        }

        override = overrides.get(case_id, {})
        if override:
            metadata = self._apply_override(metadata, override)
        
        return metadata

    def _apply_override(self, metadata: dict, override: dict) -> dict:
        """Apply manual overrides on top of extracted metadata."""
        merged = dict(metadata)

        for key in (
            "summary",
            "legal_issues",
            "applied_laws",
            "applied_articles",
            "decision",
            "outcome",
            "legal_concepts",
            "legal_reasoning",
            "court_name",
            "date",
            "judges",
        ):
            if key in override:
                merged[key] = override.get(key)

        if "parties" in override:
            merged["parties"] = override.get("parties") or {}
        if "factual_state" in override:
            merged["factual_state"] = override.get("factual_state") or {}

        return merged

    def _extract_participants(self, root):
        """Extract participants by role from XML."""
        participants = {}
        role_map = {
            "defendants": "defendant",
            "victims": "victim",
            "witnesses": "witness",
            "clerks": "clerk",
        }

        for block_name, role in role_map.items():
            elems = root.findall(f".//block[@name='{block_name}']/person", self.AKOMA_NS)
            if not elems:
                elems = root.findall(f".//{{{self.AKOMA_NS['akn']}}}block[@name='{block_name}']/{{{self.AKOMA_NS['akn']}}}person")
            if not elems:
                elems = root.findall(f".//block[@name='{block_name}']/person")
            names = [elem.text for elem in elems if elem.text]
            if names:
                participants[role] = names

        return participants

    def _extract_factual_state(self, root, annotation: dict):
        """Extract factual state strictly from XML facts block."""
        facts = {}

        fact_elems = root.findall(".//facts/fact", self.AKOMA_NS)
        if not fact_elems:
            fact_elems = root.findall(f".//{{{self.AKOMA_NS['akn']}}}facts/{{{self.AKOMA_NS['akn']}}}fact")
        if not fact_elems:
            fact_elems = root.findall(".//facts/fact")

        for fact in fact_elems:
            key = fact.get("key")
            value = fact.text
            if not key or not value:
                continue
            facts.setdefault(key, [])
            if value not in facts[key]:
                facts[key].append(value)

        return facts

    def _find_text(self, root, xpath):
        """Find element text."""
        elem = root.find(xpath, self.AKOMA_NS)
        if elem is None:
            elem = root.find(self._to_ns_xpath(xpath), self.AKOMA_NS)
        if elem is None:
            tag = xpath.split('/')[-1]
            elem = root.find(f".//{{{self.AKOMA_NS['akn']}}}{tag}")
        if elem is None:
            elem = root.find(f".//{tag}")
        return elem.text if elem is not None else None

    def _find_attr(self, root, xpath, attr):
        """Find element attribute."""
        elem = root.find(xpath, self.AKOMA_NS)
        if elem is None:
            elem = root.find(self._to_ns_xpath(xpath), self.AKOMA_NS)
        if elem is None:
            tag = xpath.split('/')[-1]
            elem = root.find(f".//{{{self.AKOMA_NS['akn']}}}{tag}")
        if elem is None:
            elem = root.find(f".//{tag}")
        return elem.get(attr) if elem is not None else None

    def _find_all_text(self, root, xpath):
        """Find all elements text."""
        elems = root.findall(xpath, self.AKOMA_NS)
        if not elems:
            elems = root.findall(self._to_ns_xpath(xpath), self.AKOMA_NS)
        if not elems:
            tag = xpath.split('/')[-1]
            elems = root.findall(f".//{{{self.AKOMA_NS['akn']}}}{tag}")
        if not elems:
            elems = root.findall(f".//{tag}")
        return [elem.text for elem in elems if elem.text]

    def _to_ns_xpath(self, xpath: str) -> str:
        """Convert a simple XPath to a namespace-qualified XPath."""
        parts = xpath.split('/')
        ns = self.AKOMA_NS['akn']
        converted = []
        for part in parts:
            if not part or part in {'.', '..'}:
                converted.append(part)
                continue
            if part.startswith('.//'):
                tag_expr = part[3:]
                converted.append('.//' + self._qualify_xpath_tag(tag_expr, ns))
                continue
            converted.append(self._qualify_xpath_tag(part, ns))
        return "/".join(converted)

    def _qualify_xpath_tag(self, part: str, ns: str) -> str:
        if part.startswith('{'):
            return part
        if part.startswith('*'):
            return part
        if '[' in part:
            tag, rest = part.split('[', 1)
            return f"{{{ns}}}{tag}[{rest}"
        return f"{{{ns}}}{part}"

    def search_verdicts(self, query: str, filter_by: Optional[str] = None):
        """Search verdicts by query."""
        all_verdicts = self.get_all_verdicts()
        results = []
        
        query_lower = query.lower()
        
        for verdict in all_verdicts:
            # Search in various fields
            searchable = [
                verdict.get("case_number", ""),
                verdict.get("summary", ""),
                verdict.get("decision", ""),
                " ".join(verdict.get("legal_issues", [])),
                " ".join(verdict.get("applied_laws", [])),
                " ".join(verdict.get("legal_concepts", []))
            ]
            
            if any(query_lower in str(field).lower() for field in searchable):
                # Apply filter if specified
                if filter_by:
                    if filter_by == "outcome":
                        if verdict.get("outcome") == query:
                            results.append(verdict)
                    elif filter_by == "law":
                        laws = verdict.get("applied_laws", [])
                        if any(query_lower in law.lower() for law in laws):
                            results.append(verdict)
                else:
                    results.append(verdict)
        
        return results
