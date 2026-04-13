"""Rule-based reasoning service using dr-device."""
from __future__ import annotations

from pathlib import Path
import subprocess
import xml.etree.ElementTree as ET

from backend.app.models.schemas import CaseFacts, RuleReasoningResult


ROOT = Path(__file__).resolve().parents[3]
DR_DEVICE_DIR = ROOT / "dr-device" / "dr-device"
FACTS_PATH = DR_DEVICE_DIR / "facts.rdf"
EXPORT_PATH = DR_DEVICE_DIR / "export.rdf"

ASCII_MAP = {
    "č": "c",
    "ć": "c",
    "š": "s",
    "ž": "z",
    "đ": "dj",
    "Č": "C",
    "Ć": "C",
    "Š": "S",
    "Ž": "Z",
    "Đ": "Dj",
}


class RuleReasoningService:
    """Service that runs dr-device reasoning on provided facts."""

    def run(self, facts: CaseFacts, strict_mode: bool = True) -> RuleReasoningResult:
        _ = strict_mode
        self._write_facts(facts)
        self._run_dr_device()
        return self._parse_export(facts)

    def _normalize(self, value: str) -> str:
        for src, dst in ASCII_MAP.items():
            value = value.replace(src, dst)
        return value

    def _write_facts(self, facts: CaseFacts) -> None:
        defendant = (facts.defendant or "Unknown").strip()
        values = {
            "defendant": self._normalize(defendant),
            "injury_type": self._normalize(facts.injury_type.strip()) if facts.injury_type else None,
            "location": self._normalize(facts.location.strip()) if facts.location else None,
            "weapon": self._normalize(facts.weapon.strip()) if facts.weapon else None,
            "weapon_used": self._bool_value(facts.weapon_used),
            "severe_consequence": self._bool_value(facts.severe_consequence),
            "death_result": self._bool_value(facts.death_result),
            "negligence": self._bool_value(facts.negligence),
            "provocation": self._bool_value(facts.provocation),
            "fight_participation": self._bool_value(facts.fight_participation),
            "fight_consequence": self._normalize(facts.fight_consequence.strip()) if facts.fight_consequence else None,
            "left_without_help": self._bool_value(facts.left_without_help),
        }

        lines = []
        lines.append("<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>")
        lines.append(
            "<rdf:RDF xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\"\n"
            "        xmlns:rdfs=\"http://www.w3.org/2000/01/rdf-schema#\"\n"
            "        xmlns:xsd=\"http://www.w3.org/2001/XMLSchema#\"\n"
            "        xmlns:lc=\"http://ftn.uns.ac.rs/legal-case#\">"
        )
        for key in values.keys():
            lines.append(f"    <rdf:Property rdf:about=\"http://ftn.uns.ac.rs/legal-case#{key}\">")
            lines.append("        <rdfs:domain rdf:resource=\"http://ftn.uns.ac.rs/legal-case#case\" />")
            lines.append("        <rdfs:range rdf:resource=\"http://www.w3.org/2001/XMLSchema#string\" />")
            lines.append("    </rdf:Property>")
        lines.append("")

        lines.append("    <lc:case rdf:about=\"http://ftn.uns.ac.rs/legal-case#case01\">")
        lines.append("        <rdf:type rdf:resource=\"http://ftn.uns.ac.rs/legal-case#case\" />")
        for key, value in values.items():
            if value in (None, ""):
                continue
            lines.append(f"        <lc:{key}>{self._escape(str(value))}</lc:{key}>")
        lines.append("    </lc:case>")
        lines.append("</rdf:RDF>")

        FACTS_PATH.write_text("\n".join(lines) + "\n", encoding="utf-8")

    def _run_dr_device(self) -> None:
        bat_path = DR_DEVICE_DIR / "start-optimized.bat"
        subprocess.run(
            str(bat_path),
            cwd=str(DR_DEVICE_DIR),
            check=True,
            capture_output=True,
            text=True,
            shell=True,
            timeout=60,
        )

    def _parse_export(self, facts: CaseFacts) -> RuleReasoningResult:
        if not EXPORT_PATH.exists():
            return RuleReasoningResult()

        export_ns = "http://startrek.csd.auth.gr/dr-device/export/export.rdf#"
        defeasible_ns = "http://lpis.csd.auth.gr/systems/dr-device/defeasible.rdfs#"
        ns = {"export": export_ns, "def": defeasible_ns}

        tree = ET.parse(EXPORT_PATH)
        root = tree.getroot()

        requested_defendant = (facts.defendant or "").strip()
        norms = []
        proofs = []

        for elem in root:
            if not elem.tag.startswith(f"{{{export_ns}}}"):
                continue
            norm_name = elem.tag.replace(f"{{{export_ns}}}", "")
            truth_status = elem.find("def:truthStatus", ns)
            if truth_status is None or (truth_status.text or "").strip() != "defeasibly-proven-positive":
                continue
            if requested_defendant:
                def_elem = elem.find("export:defendant", ns)
                def_value = (def_elem.text or "").strip() if def_elem is not None else ""
                if def_value != requested_defendant:
                    continue
            if norm_name not in norms:
                norms.append(norm_name)
            proof_elem = elem.find("def:proof", ns)
            if proof_elem is not None and proof_elem.text:
                proofs.append(proof_elem.text.strip())

        return RuleReasoningResult(applied_norms=norms, proofs=proofs)

    def _escape(self, value: str) -> str:
        return (
            value.replace("&", "&amp;")
            .replace("<", "&lt;")
            .replace(">", "&gt;")
            .replace('"', "&quot;")
            .replace("'", "&apos;")
        )

    def _bool_value(self, value: bool | None) -> str | None:
        if value is None:
            return None
        return "true" if value else "false"

