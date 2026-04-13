"""Normalize verdict outcome values across XML, annotations, and overrides."""
import json
from pathlib import Path
import sys
from xml.etree import ElementTree as ET

REPO_ROOT = Path(__file__).resolve().parents[1]
sys.path.append(str(REPO_ROOT))

from src.verdict_annotation.outcome_normalizer import normalize_outcome

AKN_NS = {"akn": "http://docs.oasis-open.org/legaldocml/ns/akn/3.0/WD17"}


def normalize_xml_outcomes(verdict_dir: Path) -> int:
    changed = 0
    for xml_file in sorted(verdict_dir.glob("*.xml")):
        tree = ET.parse(xml_file)
        root = tree.getroot()
        verdict_block = root.find(".//akn:block[@name='verdict']", AKN_NS)
        if verdict_block is None:
            continue
        current = verdict_block.get("outcome", "")
        normalized = normalize_outcome(current)
        if current != normalized:
            verdict_block.set("outcome", normalized)
            tree.write(xml_file, encoding="utf-8", xml_declaration=True)
            changed += 1
    return changed


def normalize_json_outcomes(json_file: Path, field: str) -> int:
    if not json_file.exists():
        return 0

    payload = json.loads(json_file.read_text(encoding="utf-8"))
    changed = 0

    if isinstance(payload, dict):
        for _, data in payload.items():
            if not isinstance(data, dict):
                continue
            current = data.get(field)
            if current is None:
                continue
            normalized = normalize_outcome(current)
            if current != normalized:
                data[field] = normalized
                changed += 1

    if changed:
        json_file.write_text(json.dumps(payload, ensure_ascii=False, indent=2), encoding="utf-8")
    return changed


def main() -> None:
    repo_root = Path(__file__).resolve().parents[1]
    verdict_dir = repo_root / "data" / "verdicts_xml"

    xml_changed = normalize_xml_outcomes(verdict_dir)
    annotations_changed = normalize_json_outcomes(verdict_dir / "verdicts_annotations.json", "case_outcome")
    overrides_changed = normalize_json_outcomes(verdict_dir / "verdicts_overrides.json", "outcome")

    print(f"XML files updated: {xml_changed}")
    print(f"Annotations updated: {annotations_changed}")
    print(f"Overrides updated: {overrides_changed}")


if __name__ == "__main__":
    main()
