"""Outcome normalization helpers for verdict metadata consistency."""
from typing import Optional


_CYR_TO_LAT = str.maketrans({
    "а": "a", "б": "b", "в": "v", "г": "g", "д": "d", "ђ": "dj", "е": "e", "ж": "z", "з": "z",
    "и": "i", "ј": "j", "к": "k", "л": "l", "љ": "lj", "м": "m", "н": "n", "њ": "nj", "о": "o",
    "п": "p", "р": "r", "с": "s", "т": "t", "ћ": "c", "у": "u", "ф": "f", "х": "h", "ц": "c",
    "ч": "c", "џ": "dz", "ш": "s", "А": "A", "Б": "B", "В": "V", "Г": "G", "Д": "D", "Ђ": "Dj",
    "Е": "E", "Ж": "Z", "З": "Z", "И": "I", "Ј": "J", "К": "K", "Л": "L", "Љ": "Lj", "М": "M",
    "Н": "N", "Њ": "Nj", "О": "O", "П": "P", "Р": "R", "С": "S", "Т": "T", "Ћ": "C", "У": "U",
    "Ф": "F", "Х": "H", "Ц": "C", "Ч": "C", "Џ": "Dz", "Ш": "S",
})


def _latinize(value: str) -> str:
    return value.translate(_CYR_TO_LAT)


def normalize_outcome(value: Optional[str]) -> str:
    """Normalize outcome to canonical enum used across API/UI."""
    raw = (value or "").strip()
    if not raw:
        return "nepoznato"

    normalized = _latinize(raw).lower()

    if "usvoj" in normalized:
        return "usvojeno"
    if "odbij" in normalized:
        return "odbijeno"
    if "oslobod" in normalized:
        return "oslobodjen"
    if "osud" in normalized:
        return "osudjen"
    if "ukinut" in normalized:
        return "ukinuto"

    return "nepoznato"
