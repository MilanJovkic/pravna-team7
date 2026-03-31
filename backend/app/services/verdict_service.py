"""Service for loading and processing verdict documents."""
from datetime import datetime, timezone
from pathlib import Path
from typing import List, Optional

from backend.app.infrastructure.persistence.filesystem.override_repository_fs import (
    FileSystemOverrideRepository,
)
from backend.app.infrastructure.persistence.filesystem.verdict_repository_fs import (
    FileSystemVerdictRepository,
)
from backend.app.ports.outbound.override_repository import (
    OptimisticLockConflictError,
    OverrideRepository,
)
from backend.app.ports.outbound.verdict_repository import VerdictRepository
from backend.app.domain.shared.outcome_normalization import normalize_outcome


class VerdictService:
    """Service for verdict document operations."""

    AKOMA_NS = {"akn": "http://docs.oasis-open.org/legaldocml/ns/akn/3.0/WD17"}

    def __init__(
        self,
        override_repository: OverrideRepository | None = None,
        verdict_repository: VerdictRepository | None = None,
    ):
        self.xml_dir = Path(__file__).parent.parent.parent.parent / "data" / "verdicts_xml"
        self.annotations_file = self.xml_dir / "verdicts_annotations.json"
        self._verdict_repository = verdict_repository or FileSystemVerdictRepository()
        self._override_repository = override_repository or FileSystemOverrideRepository()
        self.overrides_file = self._override_repository.overrides_file_path
        self.overrides_audit_file = self._override_repository.audit_file_path
        self._verdicts = None
        self._annotations = None
        self._overrides = None
        self._overrides_revision = "missing"
        self._overrides_audit = None
        self._overrides_audit_revision = "missing"

    def _load_verdicts(self):
        """Load all verdict XML files."""
        if self._verdicts is None:
            self._verdicts = self._verdict_repository.load_verdict_documents()

        return self._verdicts

    def _load_annotations(self):
        """Load verdict annotations."""
        if self._annotations is None:
            self._annotations = self._verdict_repository.load_annotations()
        return self._annotations

    def _load_overrides(self):
        """Load manual overrides for verdicts."""
        if self._overrides is None:
            self._overrides, self._overrides_revision = self._override_repository.load_overrides()
        return self._overrides

    def _load_overrides_audit(self):
        """Load manual override audit history."""
        if self._overrides_audit is None:
            self._overrides_audit, self._overrides_audit_revision = self._override_repository.load_audit()
        return self._overrides_audit

    def get_overrides(self, case_id: str) -> dict:
        """Return manual overrides for a verdict if present."""
        overrides = self._load_overrides()
        return overrides.get(case_id, {})

    def update_overrides(self, case_id: str, payload: dict) -> dict:
        """Persist manual overrides for a verdict."""
        overrides = self._load_overrides()
        existing = overrides.get(case_id, {})
        changes = []
        for key, value in payload.items():
            old_value = existing.get(key)
            if value is None:
                existing.pop(key, None)
            else:
                if key == "outcome":
                    existing[key] = normalize_outcome(value)
                else:
                    existing[key] = value

            new_value = existing.get(key)
            if old_value != new_value:
                changes.append(
                    {
                        "field": key,
                        "old_value": old_value,
                        "new_value": new_value,
                    }
                )
        overrides[case_id] = existing
        try:
            self._overrides_revision = self._override_repository.save_overrides(
                overrides,
                expected_revision=self._overrides_revision,
            )
        except OptimisticLockConflictError:
            self._overrides, self._overrides_revision = self._override_repository.load_overrides()
            raise
        self._overrides = overrides

        if changes:
            audit = self._load_overrides_audit()
            audit.setdefault(case_id, [])
            timestamp = datetime.now(timezone.utc).replace(microsecond=0).isoformat().replace("+00:00", "Z")
            for change in changes:
                audit[case_id].append(
                    {
                        "timestamp": timestamp,
                        "source": "api_override",
                        **change,
                    }
                )
            try:
                self._overrides_audit_revision = self._override_repository.save_audit(
                    audit,
                    expected_revision=self._overrides_audit_revision,
                )
            except OptimisticLockConflictError:
                self._overrides_audit, self._overrides_audit_revision = self._override_repository.load_audit()
                raise
            self._overrides_audit = audit

        return existing

    def get_override_history(self, case_id: str) -> list[dict]:
        """Return audit trail entries for a verdict override history."""
        audit = self._load_overrides_audit()
        return audit.get(case_id, [])

    def get_all_verdicts(self):
        """Get list of all verdicts."""
        annotations = self._load_annotations()
        overrides = self._load_overrides()
        
        result = []
        for case_id, root in self._iter_verdict_roots():
            metadata = self._build_metadata_from_root(
                case_id=case_id,
                root=root,
                annotation=annotations.get(case_id, {}),
                override=overrides.get(case_id, {}),
            )
            result.append(metadata)
        
        return result

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
        return self._build_metadata_from_root(
            case_id=case_id,
            root=root,
            annotation=annotations.get(case_id, {}),
            override=overrides.get(case_id, {}),
        )

    def _iter_verdict_roots(self):
        """Iterate verdict XML roots lazily when repository supports streaming."""
        iter_documents = getattr(self._verdict_repository, "iter_verdict_documents", None)
        if callable(iter_documents):
            for case_id, document in iter_documents():
                root = document.get("root")
                if root is not None:
                    yield case_id, root
            return

        for case_id, document in self._load_verdicts().items():
            root = document.get("root")
            if root is not None:
                yield case_id, root

    def _build_metadata_from_root(self, case_id: str, root, annotation: dict, override: dict) -> dict:
        xml_summary = self._find_text(root, ".//block[@name='summary']/p")
        xml_legal_issues = self._find_all_text(root, ".//block[@name='legalIssues']/p")
        xml_applied_laws = self._find_all_text(root, ".//block[@name='appliedLaws']/ref")
        xml_applied_articles = self._find_all_text(root, ".//block[@name='appliedArticles']/ref")
        xml_decision = self._find_text(root, ".//block[@name='verdict']/p")
        xml_outcome = self._find_attr(root, ".//block[@name='verdict']", "outcome")
        xml_full_text = self._find_text(root, ".//block[@name='fullText']/p")
        text_summary = (xml_full_text[:300] + "...") if xml_full_text and len(xml_full_text) > 300 else xml_full_text

        metadata = {
            "case_id": case_id,
            "case_number": self._find_text(root, ".//docNumber"),
            "court_name": self._find_text(root, ".//docTitle"),
            "date": self._find_attr(root, ".//docDate", "date") or self._find_text(root, ".//docDate"),
            "judges": self._find_all_text(root, ".//judge"),
            "summary": annotation.get("verdict_summary") or xml_summary or text_summary,
            "legal_issues": annotation.get("legal_issues") or xml_legal_issues,
            "applied_laws": annotation.get("applied_laws") or xml_applied_laws,
            "applied_articles": annotation.get("applied_articles") or xml_applied_articles,
            "decision": annotation.get("decision") or xml_decision,
            "outcome": normalize_outcome(annotation.get("case_outcome") or xml_outcome),
            "extraction_confidence": annotation.get("confidence"),
            "needs_review": bool(annotation.get("needs_review", False)),
            "legal_concepts": annotation.get("legal_concepts", []),
            "parties": self._extract_participants(root),
            "factual_state": self._extract_factual_state(root, annotation),
            "full_text": xml_full_text,
        }

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
                if key == "outcome":
                    merged[key] = normalize_outcome(override.get(key))
                else:
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
        """Extract factual state from XML or annotations when XML facts are absent."""
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

        if not facts:
            return annotation.get("factual_state") or {}

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
        results = []
        annotations = self._load_annotations()
        overrides = self._load_overrides()

        query_lower = query.lower()

        for case_id, root in self._iter_verdict_roots():
            verdict = self._build_metadata_from_root(
                case_id=case_id,
                root=root,
                annotation=annotations.get(case_id, {}),
                override=overrides.get(case_id, {}),
            )
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
                        if verdict.get("outcome") == normalize_outcome(query):
                            results.append(verdict)
                    elif filter_by == "law":
                        laws = verdict.get("applied_laws", [])
                        if any(query_lower in law.lower() for law in laws):
                            results.append(verdict)
                else:
                    results.append(verdict)
        
        return results
