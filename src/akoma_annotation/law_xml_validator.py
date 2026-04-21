"""Semantic validation for generated Akoma law XML."""
from pathlib import Path
from typing import List
import re
from xml.etree import ElementTree as ET

from .references import parse_reference_href

AKN_NS = "http://docs.oasis-open.org/legaldocml/ns/akn/3.0/WD17"
NS = {"akn": AKN_NS}

_ARTICLE_EID_RE = re.compile(r"^art_\d+[a-z]?$", re.IGNORECASE)
_PARAGRAPH_EID_RE = re.compile(r"^art_\d+[a-z]?__para_\d+$", re.IGNORECASE)


def validate_law_xml(xml_path: str) -> List[str]:
    """Validate law XML and return list of validation errors."""
    path = Path(xml_path)
    errors: List[str] = []

    if not path.exists():
        return [f"XML file does not exist: {xml_path}"]

    try:
        tree = ET.parse(path)
    except Exception as exc:
        return [f"XML parse error: {exc}"]

    root = tree.getroot()
    if not root.tag.endswith("akomaNtoso"):
        errors.append("Root element must be akomaNtoso")

    act = root.find("akn:act", NS)
    if act is None:
        errors.append("Missing act element")
        return errors

    meta = act.find("akn:meta", NS)
    body = act.find("akn:body", NS)

    if meta is None:
        errors.append("Missing act/meta element")
    if body is None:
        errors.append("Missing act/body element")

    articles = root.findall(".//akn:article", NS)
    paragraphs = root.findall(".//akn:paragraph", NS)

    if not articles:
        errors.append("No article elements found")
    if not paragraphs:
        errors.append("No paragraph elements found")

    article_ids = set()
    for article in articles:
        article_id = article.get("eId", "")
        if not _ARTICLE_EID_RE.match(article_id):
            errors.append(f"Invalid article eId format: {article_id}")
        if article_id in article_ids:
            errors.append(f"Duplicate article eId: {article_id}")
        article_ids.add(article_id)

    for paragraph in paragraphs:
        paragraph_id = paragraph.get("eId", "")
        if not _PARAGRAPH_EID_RE.match(paragraph_id):
            errors.append(f"Invalid paragraph eId format: {paragraph_id}")

    if meta is not None:
        frbr_dates = meta.findall(".//akn:FRBRdate", NS)
        if not frbr_dates:
            errors.append("Missing FRBRdate in metadata")

        org_refs = meta.findall(".//akn:TLCOrganization", NS)
        if not org_refs:
            errors.append("Missing TLCOrganization metadata reference")

    for ref in root.findall(".//akn:ref", NS):
        href = (ref.get("href") or "").strip()
        parsed = parse_reference_href(href)

        if parsed["kind"] == "unknown" or parsed["kind"] == "empty":
            errors.append(f"Invalid ref href format: {href}")
            continue

        if parsed["kind"].startswith("internal"):
            target_article = f"art_{parsed['article_number']}" if parsed["article_number"] else None
            if target_article and target_article not in article_ids:
                errors.append(f"Reference points to missing article: {href}")

    return errors
