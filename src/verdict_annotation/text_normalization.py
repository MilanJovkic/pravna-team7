"""Shared text normalization utilities for verdict extraction pipelines."""
from __future__ import annotations

import re
import unicodedata


_DIACRITICS = "čćžšđČĆŽŠĐ"
_CASE_SUFFIXES = {
    "a",
    "e",
    "u",
    "i",
    "o",
    "ao",
    "eo",
    "io",
    "ja",
    "je",
    "ju",
    "ji",
    "la",
    "le",
    "li",
    "lo",
    "lu",
    "na",
    "ne",
    "ni",
    "no",
    "nu",
    "ka",
    "ke",
    "ki",
    "ko",
    "ku",
    "ta",
    "te",
    "ti",
    "to",
    "tu",
    "om",
    "em",
    "am",
    "en",
    "an",
    "on",
    "in",
    "og",
    "oj",
    "im",
    "ih",
    "eg",
    "ić",
    "iću",
    "aju",
    "ama",
    "ima",
}


def _split_glued_camel_tokens(text: str) -> str:
    """Split OCR-glued words like 'RadevićSanje' -> 'Radević Sanje'."""
    # OCR pattern: "GolubovićŽ eljka" -> "Golubović Željka".
    split = re.sub(
        r"(?<=[a-zčćžšđ])([A-ZČĆŽŠĐ])\s+([a-zčćžšđ]{2,})",
        r" \1\2",
        text,
    )
    split = re.sub(r"(?<=[a-zčćžšđ])(?=[A-ZČĆŽŠĐ])", " ", split)
    return split


def _merge_suffix_after_diacritic(text: str) -> str:
    """Merge OCR splits like 'vijeć a' -> 'vijeća', while avoiding very short words."""

    def _repl(match: re.Match[str]) -> str:
        stem = match.group(1)
        suffix = match.group(2)

        if len(stem) < 4:
            return match.group(0)
        if suffix != suffix.lower():
            return match.group(0)
        if suffix.lower() not in _CASE_SUFFIXES:
            return match.group(0)
        return f"{stem}{suffix}"

    return re.sub(
        rf"\b([A-Za-z0-9{_DIACRITICS}]{{3,}}[{_DIACRITICS}])\s+([A-Za-z{_DIACRITICS}]{{1,3}})\b",
        _repl,
        text,
    )


def _merge_split_aju_suffix(text: str) -> str:
    """Merge splits like 'sluč aj u' -> 'slučaju'."""

    def _repl(match: re.Match[str]) -> str:
        stem = match.group(1)
        first = match.group(2)
        second = match.group(3)
        combined = f"{first}{second}"

        if len(stem) < 4:
            return match.group(0)
        if first != first.lower() or second != second.lower():
            return match.group(0)
        if combined not in _CASE_SUFFIXES:
            return match.group(0)
        return f"{stem}{combined}"

    return re.sub(
        rf"\b([A-Za-z0-9{_DIACRITICS}]{{3,}}[{_DIACRITICS}])\s+([A-Za-z{_DIACRITICS}]{{2}})\s+([A-Za-z{_DIACRITICS}]{{1}})\b",
        _repl,
        text,
    )


def _merge_trailing_isolated_diacritic(text: str) -> str:
    """Merge artifacts like 'Šoški ć' -> 'Šoškić'."""

    def _repl(match: re.Match[str]) -> str:
        stem = match.group(1)
        suffix = match.group(2)
        if len(stem) < 4:
            return match.group(0)
        return f"{stem}{suffix}"

    return re.sub(
        rf"\b([A-Za-z{_DIACRITICS}]{{3,}})\s+([{_DIACRITICS}])(?!\.)\b",
        _repl,
        text,
    )


def normalize_legal_text(text: str) -> str:
    """Normalize noisy PDF/OCR text while preserving paragraph structure."""
    if not text:
        return ""

    normalized = text.replace("\r\n", "\n").replace("\r", "\n")
    normalized = normalized.replace("\u00a0", " ")
    normalized = normalized.replace("\u200b", "")
    normalized = normalized.replace("\ufeff", "")
    normalized = normalized.replace("\u00ad", "")
    normalized = unicodedata.normalize("NFC", normalized)

    # Split OCR-glued CamelCase fragments (mostly person names and roles).
    normalized = _split_glued_camel_tokens(normalized)

    # Fix glued phrase starts frequently seen in OCR output.
    normalized = re.sub(r"\bkao(?=[a-zčćžšđ])", "kao ", normalized, flags=re.IGNORECASE)

    # Merge words split around isolated/clustered diacritic letters.
    # Examples: "krivi c ni" -> "krivicni", "uče šć e" -> "učešće".
    previous = None
    while previous != normalized:
        previous = normalized
        normalized = re.sub(
            rf"(?<=\w)\s+([{_DIACRITICS}]{{1,3}})\s+(?=\w)",
            r"\1",
            normalized,
        )
        normalized = _merge_suffix_after_diacritic(normalized)
        normalized = _merge_split_aju_suffix(normalized)
        normalized = _merge_trailing_isolated_diacritic(normalized)

    # Remove line-break hyphenation artifacts.
    normalized = re.sub(r"(\w)-\n(\w)", r"\1\2", normalized)

    # Normalize punctuation spacing and initials.
    normalized = re.sub(r"\s+([,.;:!?])", r"\1", normalized)
    normalized = re.sub(r"\b([A-ZČĆŽŠĐ])\s*\.\s*([A-ZČĆŽŠĐ])\s*\.", r"\1.\2.", normalized)

    # Collapse horizontal whitespace while preserving newlines.
    normalized = re.sub(r"[ \t]+", " ", normalized)
    normalized = re.sub(r" *\n *", "\n", normalized)
    normalized = re.sub(r"\n{3,}", "\n\n", normalized)

    return normalized.strip()


def text_quality_score(text: str) -> float:
    """Simple heuristic score to compare candidate extraction outputs."""
    if not text:
        return 0.0

    letters = sum(1 for ch in text if ch.isalpha())
    digits = sum(1 for ch in text if ch.isdigit())
    replacement_penalty = text.count("\ufffd") * 120
    control_penalty = sum(1 for ch in text if ord(ch) < 32 and ch not in "\n\t") * 40

    score = float(letters + (0.25 * digits) - replacement_penalty - control_penalty)
    return score
