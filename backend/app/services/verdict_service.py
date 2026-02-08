"""Service for loading and processing verdict documents."""
import json
from pathlib import Path
from typing import List, Optional
from xml.etree import ElementTree as ET


class VerdictService:
    """Service for verdict document operations."""

    AKOMA_NS = {"akn": "http://docs.oasis-open.org/legaldocml/ns/akn/3.0/WD17"}

    def __init__(self):
        self.xml_dir = Path(__file__).parent.parent.parent.parent / "data" / "verdicts_xml"
        self.annotations_file = self.xml_dir / "verdicts_annotations.json"
        self._verdicts = None
        self._annotations = None

    def _load_verdicts(self):
        """Load all verdict XML files."""
        if self._verdicts is None:
            self._verdicts = {}
            
            if not self.xml_dir.exists():
                return self._verdicts

            for xml_file in self.xml_dir.glob("*.xml"):
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
        if self._annotations is None:
            if self.annotations_file.exists():
                with open(self.annotations_file, "r", encoding="utf-8") as f:
                    self._annotations = json.load(f)
            else:
                self._annotations = {}
        return self._annotations

    def get_all_verdicts(self):
        """Get list of all verdicts."""
        verdicts = self._load_verdicts()
        annotations = self._load_annotations()
        
        result = []
        for case_id in verdicts.keys():
            metadata = self._extract_metadata(case_id)
            result.append(metadata)
        
        return result

    def get_verdict(self, case_id: str):
        """Get specific verdict details."""
        verdicts = self._load_verdicts()
        annotations = self._load_annotations()
        
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
        
        return metadata

    def _extract_metadata(self, case_id: str):
        """Extract metadata from verdict XML."""
        verdicts = self._load_verdicts()
        annotations = self._load_annotations()
        
        if case_id not in verdicts:
            return None
        
        root = verdicts[case_id]["root"]
        annotation = annotations.get(case_id, {})
        
        metadata = {
            "case_id": case_id,
            "case_number": self._find_text(root, ".//docNumber"),
            "court_name": self._find_text(root, ".//docTitle"),
            "date": self._find_attr(root, ".//docDate", "date") or self._find_text(root, ".//docDate"),
            "judges": self._find_all_text(root, ".//judge"),
            "summary": annotation.get("verdict_summary"),
            "legal_issues": annotation.get("legal_issues", []),
            "applied_laws": annotation.get("applied_laws", []),
            "applied_articles": annotation.get("applied_articles", []),
            "decision": annotation.get("decision"),
            "outcome": annotation.get("case_outcome"),
            "legal_concepts": annotation.get("legal_concepts", [])
        }
        
        return metadata

    def _find_text(self, root, xpath):
        """Find element text."""
        elem = root.find(xpath, self.AKOMA_NS)
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
            tag = xpath.split('/')[-1]
            elem = root.find(f".//{{{self.AKOMA_NS['akn']}}}{tag}")
        if elem is None:
            elem = root.find(f".//{tag}")
        return elem.get(attr) if elem is not None else None

    def _find_all_text(self, root, xpath):
        """Find all elements text."""
        elems = root.findall(xpath, self.AKOMA_NS)
        if not elems:
            tag = xpath.split('/')[-1]
            elems = root.findall(f".//{{{self.AKOMA_NS['akn']}}}{tag}")
        if not elems:
            elems = root.findall(f".//{tag}")
        return [elem.text for elem in elems if elem.text]

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
