from __future__ import annotations

import html
from pathlib import Path
import xml.etree.ElementTree as ET


ROOT = Path(__file__).resolve().parent
VERDICTS_DIR = ROOT / "data" / "verdicts_xml"
OUTPUT_PATH = ROOT / "dr-device" / "dr-device" / "facts.rdf"

FACT_KEYS = {"injury_type", "weapon", "location"}
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


def _text(node: ET.Element | None) -> str | None:
    if node is None:
        return None
    text = (node.text or "").strip()
    return text or None


def _normalize(value: str) -> str:
    for src, dst in ASCII_MAP.items():
        value = value.replace(src, dst)
    return value


def _find_defendant(root: ET.Element) -> str | None:
    for person in root.findall(".//{*}participants/{*}block[@name='defendants']/{*}person"):
        value = _text(person)
        if value:
            return value
    return None


def _collect_facts(root: ET.Element) -> dict[str, list[str]]:
    facts: dict[str, list[str]] = {key: [] for key in FACT_KEYS}
    for fact in root.findall(".//{*}facts/{*}fact"):
        key = fact.attrib.get("key")
        if key in FACT_KEYS:
            value = _text(fact)
            if value:
                facts[key].append(_normalize(value))
    return facts


def _escape(value: str) -> str:
    return html.escape(value, quote=True)


def main() -> int:
    verdict_files = sorted(VERDICTS_DIR.glob("*.xml"))
    if not verdict_files:
        raise SystemExit(f"No verdict XML files found in {VERDICTS_DIR}")

    lines: list[str] = []
    lines.append("<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>")
    lines.append(
        "<rdf:RDF xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\"\n"
        "        xmlns:rdfs=\"http://www.w3.org/2000/01/rdf-schema#\"\n"
        "        xmlns:xsd=\"http://www.w3.org/2001/XMLSchema#\"\n"
        "        xmlns:lc=\"http://ftn.uns.ac.rs/legal-case#\">"
    )

    for key in ("defendant", "injury_type", "weapon", "location"):
        lines.append(f"    <rdf:Property rdf:about=\"http://ftn.uns.ac.rs/legal-case#{key}\">")
        lines.append("        <rdfs:domain rdf:resource=\"http://ftn.uns.ac.rs/legal-case#case\" />")
        lines.append("        <rdfs:range rdf:resource=\"http://www.w3.org/2001/XMLSchema#string\" />")
        lines.append("    </rdf:Property>")
    lines.append("")

    case_index = 1
    for verdict_path in verdict_files:
        tree = ET.parse(verdict_path)
        root = tree.getroot()

        defendant = _find_defendant(root)
        facts = _collect_facts(root)

        locations = facts.get("location", [])
        location_groups = locations or [""]

        for location_value in location_groups:
            case_id = f"case{case_index:02d}"
            case_index += 1

            lines.append(f"    <lc:case rdf:about=\"http://ftn.uns.ac.rs/legal-case#{case_id}\">")
            lines.append("        <rdf:type rdf:resource=\"http://ftn.uns.ac.rs/legal-case#case\" />")
            if defendant:
                lines.append(f"        <lc:defendant>{_escape(defendant)}</lc:defendant>")

            for value in facts.get("injury_type", []):
                lines.append(f"        <lc:injury_type>{_escape(value)}</lc:injury_type>")
            for value in facts.get("weapon", []):
                lines.append(f"        <lc:weapon>{_escape(value)}</lc:weapon>")
            if location_value:
                lines.append(f"        <lc:location>{_escape(location_value)}</lc:location>")

            lines.append("    </lc:case>")
            lines.append("")

    if lines and lines[-1] == "":
        lines.pop()

    lines.append("</rdf:RDF>")
    OUTPUT_PATH.write_text("\n".join(lines) + "\n", encoding="utf-8")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
