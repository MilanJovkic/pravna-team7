"""Quality gate validation for verdict XML corpus."""
from pathlib import Path
from typing import Dict, List
from xml.etree import ElementTree as ET

from .outcome_normalizer import normalize_outcome

AKN_NS = {"akn": "http://docs.oasis-open.org/legaldocml/ns/akn/3.0/WD17"}


def _text(root: ET.Element, xpath: str) -> str:
    node = root.find(xpath, AKN_NS)
    if node is None or node.text is None:
        return ""
    return node.text.strip()


def _nodes(root: ET.Element, xpath: str) -> List[ET.Element]:
    return root.findall(xpath, AKN_NS)


def validate_verdict_file(xml_path: Path) -> List[str]:
    errors: List[str] = []

    try:
        root = ET.parse(xml_path).getroot()
    except Exception as exc:
        return [f"{xml_path.name}: XML parse error: {exc}"]

    case_number = _text(root, ".//akn:docNumber")
    if not case_number:
        errors.append("missing docNumber")

    date_node = root.find(".//akn:docDate", AKN_NS)
    date_attr = (date_node.get("date") if date_node is not None else "") or ""
    if not date_attr:
        errors.append("missing docDate/@date")

    participants = _nodes(root, ".//akn:participants//akn:person")
    if not participants:
        errors.append("missing participants/person")

    applied_laws = _nodes(root, ".//akn:block[@name='appliedLaws']/akn:ref")
    if not applied_laws:
        errors.append("missing appliedLaws refs")

    applied_articles = _nodes(root, ".//akn:block[@name='appliedArticles']/akn:ref")
    if not applied_articles:
        errors.append("missing appliedArticles refs")

    facts = _nodes(root, ".//akn:facts/akn:fact")
    if not facts:
        errors.append("missing facts/fact")

    full_text = _text(root, ".//akn:block[@name='fullText']/akn:p")
    if not full_text:
        errors.append("missing fullText")

    verdict_block = root.find(".//akn:block[@name='verdict']", AKN_NS)
    if verdict_block is None:
        errors.append("missing verdict block")
    else:
        outcome = verdict_block.get("outcome", "")
        if not outcome:
            errors.append("missing verdict outcome")
        elif outcome != normalize_outcome(outcome):
            errors.append(f"non-canonical outcome value: {outcome}")

    if errors:
        return [f"{xml_path.name}: {message}" for message in errors]
    return []


def validate_verdict_corpus(verdict_dir: str, min_count: int = 5) -> Dict[str, List[str]]:
    base = Path(verdict_dir)
    if not base.exists():
        return {"global": [f"verdict directory missing: {verdict_dir}"]}

    xml_files = sorted(base.glob("*.xml"))
    problems: Dict[str, List[str]] = {"global": []}

    if len(xml_files) < min_count:
        problems["global"].append(f"expected at least {min_count} verdict XML files, found {len(xml_files)}")

    for xml_file in xml_files:
        file_errors = validate_verdict_file(xml_file)
        if file_errors:
            problems[xml_file.name] = file_errors

    if not problems["global"] and len(problems) == 1:
        return {}
    return problems
