"""Canonical internal legal reference helpers used by backend domain/infrastructure."""

from __future__ import annotations

import re


_ARTICLE_EID_RE = re.compile(r"^art_(\d+[a-z]?)$", re.IGNORECASE)
_PARAGRAPH_EID_RE = re.compile(r"^art_(\d+[a-z]?)__para_(\d+)$", re.IGNORECASE)
_POINT_EID_RE = re.compile(r"^art_(\d+[a-z]?)__para_(\d+)__point_(\d+)$", re.IGNORECASE)


def canonical_article_href(article_number: str) -> str:
    """Return canonical internal href for article references."""
    normalized = str(article_number).strip().lower()
    return f"#art_{normalized}"


def canonical_paragraph_href(article_number: str, paragraph_number: str) -> str:
    """Return canonical internal href for paragraph references."""
    art = str(article_number).strip().lower()
    para = str(paragraph_number).strip()
    return f"#art_{art}__para_{para}"


def parse_reference_href(href: str) -> dict[str, str | None]:
    """Parse href into normalized reference metadata."""
    raw = (href or "").strip()
    if not raw:
        return {
            "kind": "empty",
            "href": raw,
            "normalized_href": raw,
            "article_number": None,
            "paragraph_number": None,
            "point_number": None,
        }

    value = raw[1:] if raw.startswith("#") else raw
    value = value.strip()

    point_match = _POINT_EID_RE.match(value)
    if point_match:
        article_number, paragraph_number, point_number = point_match.groups()
        return {
            "kind": "internal_point",
            "href": raw,
            "normalized_href": f"#art_{article_number.lower()}__para_{paragraph_number}__point_{point_number}",
            "article_number": article_number.lower(),
            "paragraph_number": paragraph_number,
            "point_number": point_number,
        }

    para_match = _PARAGRAPH_EID_RE.match(value)
    if para_match:
        article_number, paragraph_number = para_match.groups()
        return {
            "kind": "internal_paragraph",
            "href": raw,
            "normalized_href": canonical_paragraph_href(article_number, paragraph_number),
            "article_number": article_number.lower(),
            "paragraph_number": paragraph_number,
            "point_number": None,
        }

    article_match = _ARTICLE_EID_RE.match(value)
    if article_match:
        article_number = article_match.group(1)
        return {
            "kind": "internal_article",
            "href": raw,
            "normalized_href": canonical_article_href(article_number),
            "article_number": article_number.lower(),
            "paragraph_number": None,
            "point_number": None,
        }

    if value.startswith("/akn/"):
        return {
            "kind": "external_law",
            "href": raw,
            "normalized_href": value,
            "article_number": None,
            "paragraph_number": None,
            "point_number": None,
        }

    return {
        "kind": "unknown",
        "href": raw,
        "normalized_href": raw,
        "article_number": None,
        "paragraph_number": None,
        "point_number": None,
    }
