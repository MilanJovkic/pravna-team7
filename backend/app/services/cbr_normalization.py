"""Normalization helpers for CBR inputs and stored facts."""
from __future__ import annotations

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


def normalize_ascii(value: str | None) -> str | None:
    if value is None:
        return None
    text = value.strip()
    if not text:
        return None
    for src, dst in ASCII_MAP.items():
        text = text.replace(src, dst)
    return text


def normalize_text(value: str | None) -> str | None:
    text = normalize_ascii(value)
    if text is None:
        return None
    text = " ".join(text.split())
    return text.lower()


def normalize_injury_type(value: str | None) -> str | None:
    text = normalize_text(value)
    if not text:
        return None
    if "povred" in text:
        if "tesk" in text:
            return "teska tjelesna povreda"
        if "lak" in text:
            return "laka tjelesna povreda"
    return text


def normalize_fight_consequence(value: str | None) -> str | None:
    text = normalize_text(value)
    if not text:
        return None
    if text in {
        "smrt",
        "death",
        "death_or_serious_injury",
        "teska_povreda",
        "teska tjelesna povreda",
        "teska_tjelesna_povreda",
        "ozbiljna_povreda",
    }:
        return "death_or_serious_injury"
    if text in {"laka_povreda", "laka tjelesna povreda", "laka_tjelesna_povreda"}:
        return "none"
    if text in {"none", "nema", "bez", "bez posledica", "bez posljedica"}:
        return "none"
    return text


def normalize_weapon(value: str | None) -> str | None:
    text = normalize_text(value)
    if not text:
        return None

    if text in {"opasno_orudje", "sredstvo_podobno_za_tesku_povredu"}:
        return text

    if any(token in text for token in ("noz", "pistolj", "pusk", "vatreno", "oruzje")):
        return "opasno_orudje"

    if any(token in text for token in ("palic", "kamen", "metalni", "kljuc", "fla", "sipk", "letv", "predmet")):
        return "sredstvo_podobno_za_tesku_povredu"

    return text


def parse_bool(value: str | bool | None) -> bool | None:
    if value is None:
        return None
    if isinstance(value, bool):
        return value
    text = normalize_text(value)
    if text in {"true", "1", "yes", "da", "t", "y"}:
        return True
    if text in {"false", "0", "no", "ne", "f", "n"}:
        return False
    return None


def bool_to_text(value: bool | None) -> str | None:
    if value is None:
        return None
    return "true" if value else "false"
