"""Shared extraction utilities for building high-quality CBR case facts from XML verdicts."""
from __future__ import annotations

from pathlib import Path
import re
import unicodedata
import xml.etree.ElementTree as ET

from backend.app.domain.shared.outcome_normalization import normalize_outcome
from src.verdict_annotation.verdict_parser import VerdictParser


FACT_KEY_ALIASES = {
    "injurytype": "injury_type",
    "injury_type": "injury_type",
    "location": "location",
    "weapon": "weapon",
    "weaponused": "weapon_used",
    "weapon_used": "weapon_used",
    "severeconsequence": "severe_consequence",
    "severe_consequence": "severe_consequence",
    "deathresult": "death_result",
    "death_result": "death_result",
    "negligence": "negligence",
    "provocation": "provocation",
    "fightparticipation": "fight_participation",
    "fight_participation": "fight_participation",
    "fightconsequence": "fight_consequence",
    "fight_consequence": "fight_consequence",
    "leftwithouthelp": "left_without_help",
    "left_without_help": "left_without_help",
    "previousconvictions": "previous_convictions",
    "previous_convictions": "previous_convictions",
    "repeatoffender": "repeat_offender",
    "repeat_offender": "repeat_offender",
    "confession": "confession",
    "remorse": "remorse",
    "pleaagreement": "plea_agreement",
    "plea_agreement": "plea_agreement",
    "aggravatingcircumstances": "aggravating_circumstances",
    "aggravating_circumstances": "aggravating_circumstances",
    "mitigatingcircumstances": "mitigating_circumstances",
    "mitigating_circumstances": "mitigating_circumstances",
    "familycircumstances": "family_circumstances",
    "family_circumstances": "family_circumstances",
    "poorfinancialstatus": "poor_financial_status",
    "poor_financial_status": "poor_financial_status",
    "alcoholintoxication": "alcohol_intoxication",
    "alcohol_intoxication": "alcohol_intoxication",
    "narcoticsinfluence": "narcotics_influence",
    "narcotics_influence": "narcotics_influence",
    "conditionalsentencerequested": "conditional_sentence_requested",
    "conditional_sentence_requested": "conditional_sentence_requested",
    "attemptedoffense": "attempted_offense",
    "attempted_offense": "attempted_offense",
}

CBR_FACT_KEYS = {
    "injury_type",
    "location",
    "weapon",
    "weapon_used",
    "severe_consequence",
    "death_result",
    "negligence",
    "provocation",
    "fight_participation",
    "fight_consequence",
    "left_without_help",
    "previous_convictions",
    "repeat_offender",
    "confession",
    "remorse",
    "plea_agreement",
    "aggravating_circumstances",
    "mitigating_circumstances",
    "family_circumstances",
    "poor_financial_status",
    "alcohol_intoxication",
    "narcotics_influence",
    "conditional_sentence_requested",
    "attempted_offense",
}

UNKNOWN_MARKERS = {
    "",
    "-",
    "none",
    "null",
    "n/a",
    "unknown",
    "nepoznato",
    "neodredjeno",
    "nepoznat",
    "непознато",
    "nije poznato",
}

_CITY_TOKENS = (
    "podgoric",
    "niksic",
    "danilovgrad",
    "bar",
    "budva",
    "ulcinj",
    "tivat",
    "kotor",
    "herceg",
    "bijelo",
    "berane",
    "pljev",
    "cetin",
)

_VERDICT_PARSER = VerdictParser()

_OUTCOME_CONVICTION_PATTERNS = (
    re.compile(r"\bosudj\w*\s+se\b", re.IGNORECASE),
    re.compile(r"\boglas\w*\s+kriv\w*\b", re.IGNORECASE),
    re.compile(r"\bproglas\w*\s+kriv\w*\b", re.IGNORECASE),
    re.compile(r"\bkriv\s+je\b", re.IGNORECASE),
    re.compile(r"\bkrivi\s+su\b", re.IGNORECASE),
)

_OUTCOME_ACQUITTAL_PATTERNS = (
    re.compile(r"\boslobadj\w*\s+se\b", re.IGNORECASE),
    re.compile(r"\bnije\s+kriv\b", re.IGNORECASE),
    re.compile(r"\bnijes\w*\s+krivi\b", re.IGNORECASE),
)

_OUTCOME_REJECTION_PATTERNS = (
    re.compile(r"\bodbij\w*\s+se\b", re.IGNORECASE),
    re.compile(r"\bodbij\w*\s+optuzb\w*\b", re.IGNORECASE),
)

_OUTCOME_QUASH_PATTERNS = (
    re.compile(r"\bukid\w*\s+se\b", re.IGNORECASE),
    re.compile(r"\bukinut\w*\s+presud\w*\b", re.IGNORECASE),
)


def canonical_fact_key(raw_key: str | None) -> str | None:
    if not raw_key:
        return None
    collapsed = "".join(ch for ch in raw_key.strip().lower() if ch.isalnum() or ch == "_")
    return FACT_KEY_ALIASES.get(collapsed) or FACT_KEY_ALIASES.get(raw_key.strip().lower())


def normalize_case_number(raw_value: str | None, fallback_stem: str) -> str:
    text = (raw_value or "").strip()
    text = re.sub(r"^[^\w\d]+", "", text)
    text = re.sub(r"[^\w\d]+$", "", text)
    if text and any(ch.isalnum() for ch in text):
        return " ".join(text.split())
    return fallback_stem


def extract_case_facts(xml_path: Path) -> dict[str, str]:
    tree = ET.parse(xml_path)
    root = tree.getroot()

    case_number_elem = root.find(".//{*}docNumber")
    case_number = normalize_case_number(
        case_number_elem.text if case_number_elem is not None else "",
        xml_path.stem,
    )

    facts: dict[str, str] = {
        "case_number": case_number,
        "outcome": _extract_outcome(root),
    }

    for fact in root.findall(".//{*}facts/{*}fact"):
        key = canonical_fact_key(fact.attrib.get("key"))
        value = _clean_value(fact.text)
        if key and value:
            facts[key] = value

    for metadata in root.findall(".//{*}metadata"):
        key = canonical_fact_key(metadata.attrib.get("key"))
        value = _clean_value(metadata.attrib.get("value"))
        if key and value and key not in facts:
            facts[key] = value

    narrative_text = _collect_narrative_text(root)
    if narrative_text:
        inferred = _infer_from_narrative(narrative_text)
        for key, value in inferred.items():
            if key not in CBR_FACT_KEYS or not value:
                continue
            if _should_override_existing(key, facts.get(key), value):
                facts[key] = value

    _derive_dependent_values(facts)
    return facts


def _extract_outcome(root: ET.Element) -> str:
    outcome_elem = root.find(".//{*}block[@name='verdict']")
    outcome_candidates: list[str] = []

    if outcome_elem is not None:
        outcome = _clean_value(outcome_elem.get("outcome"))
        if outcome:
            normalized = normalize_outcome(outcome)
            if normalized != "nepoznato":
                return normalized
            outcome_candidates.append(outcome)

        verdict_text = _clean_value(" ".join(outcome_elem.itertext()))
        if verdict_text:
            outcome_candidates.append(verdict_text)

    for metadata in root.findall(".//{*}metadata"):
        if (metadata.attrib.get("key") or "").strip().lower() != "outcome":
            continue
        value = _clean_value(metadata.attrib.get("value"))
        if value:
            normalized = normalize_outcome(value)
            if normalized != "nepoznato":
                return normalized
            outcome_candidates.append(value)

    summary_block = root.find(".//{*}block[@name='summary']")
    if summary_block is not None:
        summary_text = _clean_value(" ".join(summary_block.itertext()))
        if summary_text:
            outcome_candidates.append(summary_text)

    for candidate in outcome_candidates:
        inferred = _infer_outcome_from_text(candidate)
        if inferred != "nepoznato":
            return inferred

    inferred_from_full_text = _infer_outcome_from_text(_collect_narrative_text(root))
    if inferred_from_full_text != "nepoznato":
        return inferred_from_full_text

    return ""


def _clean_value(value: str | None) -> str | None:
    if value is None:
        return None
    cleaned = " ".join(value.split()).strip()
    return cleaned or None


def _collect_narrative_text(root: ET.Element) -> str:
    parts: list[str] = []
    for paragraph in root.findall(".//{*}p"):
        value = _clean_value(paragraph.text)
        if value:
            parts.append(value)

    if parts:
        return "\n".join(parts)

    fallback = _clean_value(" ".join((text or "") for text in root.itertext()))
    return fallback or ""


def _infer_from_narrative(text: str) -> dict[str, str]:
    inferred: dict[str, str] = {}
    metadata = _VERDICT_PARSER.parse(text)
    factual_state = metadata.factual_state or {}

    for raw_key, values in factual_state.items():
        key = canonical_fact_key(raw_key)
        if key is None:
            continue
        value = _pick_fact_value(key, values)
        if value:
            inferred[key] = value

    inferred.update(_infer_booleans_from_text(text, inferred))

    return inferred


def _infer_outcome_from_text(text: str) -> str:
    if not text:
        return "nepoznato"

    normalized = normalize_outcome(text)
    if normalized != "nepoznato":
        return normalized

    compact_text = _normalize_for_matching(text)
    if not compact_text:
        return "nepoznato"

    for pattern in _OUTCOME_ACQUITTAL_PATTERNS:
        if pattern.search(compact_text):
            return "oslobodjen"

    for pattern in _OUTCOME_REJECTION_PATTERNS:
        if pattern.search(compact_text):
            return "odbijeno"

    for pattern in _OUTCOME_QUASH_PATTERNS:
        if pattern.search(compact_text):
            return "ukinuto"

    for pattern in _OUTCOME_CONVICTION_PATTERNS:
        if pattern.search(compact_text):
            return "osudjen"

    return "nepoznato"


def _infer_booleans_from_text(text: str, existing: dict[str, str]) -> dict[str, str]:
    normalized = _normalize_for_matching(text)
    compact = normalized.replace(" ", "")
    if not normalized:
        return {}

    inferred: dict[str, str] = {}

    if _contains_phrase_or_compact(
        normalized,
        compact,
        regexes=(r"\biz\s+nehata\b", r"\bnehatn\w*\b"),
        compact_tokens=("iznehata", "nehatnolisiozivota", "ubistvoiznehata"),
    ):
        inferred["negligence"] = "da"

    if _contains_phrase_or_compact(
        normalized,
        compact,
        regexes=(r"\bprovokac\w*\b", r"\bisprovociran\w*\b", r"\bizazvan\w*\b"),
        compact_tokens=("provokacij", "isprovociran", "izazvan"),
    ):
        inferred["provocation"] = "da"

    if _contains_phrase_or_compact(
        normalized,
        compact,
        regexes=(r"\buces\w*\s+u\s+tuc\w*\b",),
        compact_tokens=("ucestvovanjeutuci", "ucesceutuci", "ucestvovaliutuci", "prilikomtuce"),
    ):
        inferred["fight_participation"] = "da"

    if _contains_phrase_or_compact(
        normalized,
        compact,
        regexes=(
            r"\bnije\s+pruzio\s+pomoc\b",
            r"\bnije\s+ukazao\s+pomoc\b",
            r"\bbez\s+pruzanja\s+pomoci\b",
            r"\bostavio\s+bez\s+pomoci\b",
            r"\bnapusti\w*\s+lice\s+mjesta\b",
            r"\bnapusti\w*\s+lice\s+mesta\b",
        ),
        compact_tokens=("nijepruziopomoc", "nijeukazaopomoc", "bezpruzanjapomoci", "ostaviobezpomoci"),
    ):
        inferred["left_without_help"] = "da"
    elif _contains_phrase_or_compact(
        normalized,
        compact,
        regexes=(r"\bpruzio\s+pomoc\b", r"\bukazao\s+pomoc\b", r"\bpozvao\s+hitn\w*\s+pomoc\b"),
        compact_tokens=("pruziopomoc", "ukazaopomoc", "pozvaohitnupomoc"),
    ):
        inferred["left_without_help"] = "ne"

    if _contains_phrase_or_compact(
        normalized,
        compact,
        regexes=(r"\bpovratnik\b", r"\bspecijaln\w*\s+povrat\w*\b"),
        compact_tokens=("povratnik", "specijalnipovrat"),
    ):
        inferred["repeat_offender"] = "da"

    if (
        inferred.get("fight_participation") == "da"
        and "fight_consequence" not in inferred
        and "fight_consequence" not in existing
    ):
        if _is_true_like(existing.get("death_result")):
            inferred["fight_consequence"] = "death_or_serious_injury"
        elif _is_true_like(existing.get("severe_consequence")):
            inferred["fight_consequence"] = "death_or_serious_injury"
        elif _contains_phrase_or_compact(
            normalized,
            compact,
            regexes=(r"\bbez\s+posledic\w*\b", r"\bbez\s+tez\w*\s+posledic\w*\b"),
            compact_tokens=("bezposledica", "bezteskihposledica"),
        ):
            inferred["fight_consequence"] = "none"

    return inferred


def _contains_phrase_or_compact(
    normalized_text: str,
    compact_text: str,
    *,
    regexes: tuple[str, ...],
    compact_tokens: tuple[str, ...],
) -> bool:
    for pattern in regexes:
        if re.search(pattern, normalized_text):
            return True
    for token in compact_tokens:
        if token and token in compact_text:
            return True
    return False


def _normalize_for_matching(text: str) -> str:
    lowered = text.lower().replace("\u00a0", " ")
    normalized = unicodedata.normalize("NFD", lowered)
    normalized = "".join(ch for ch in normalized if unicodedata.category(ch) != "Mn")
    normalized = re.sub(r"[^a-z0-9\s]", " ", normalized)
    return re.sub(r"\s+", " ", normalized).strip()


def _is_true_like(value: str | None) -> bool:
    return (value or "").strip().lower() in {"da", "true", "1", "yes"}


def _pick_fact_value(key: str, values: list[str]) -> str | None:
    cleaned_values = [candidate for candidate in (_clean_value(v) for v in values) if candidate]
    if not cleaned_values:
        return None

    if key == "location":
        return _pick_best_location(cleaned_values)

    return cleaned_values[0]


def _pick_best_location(values: list[str]) -> str:
    best = values[0]
    best_score = _location_quality(best)
    for candidate in values[1:]:
        score = _location_quality(candidate)
        if score > best_score:
            best = candidate
            best_score = score
    return best


def _location_quality(value: str) -> int:
    lowered = value.lower()
    score = 0

    if any(token in lowered for token in _CITY_TOKENS):
        score += 4
    if re.search(r"\bkv\b", lowered):
        score -= 2
    if len(lowered.split()) <= 2:
        score += 1
    if len(lowered) <= 20:
        score += 1

    return score


def _is_unknown(value: str | None) -> bool:
    if value is None:
        return True
    return value.strip().lower() in UNKNOWN_MARKERS


def _should_override_existing(key: str, existing: str | None, inferred: str) -> bool:
    if _is_unknown(existing):
        return True
    if key == "location" and existing is not None:
        return _location_quality(inferred) > _location_quality(existing)
    return False


def _derive_dependent_values(facts: dict[str, str]) -> None:
    injury = (facts.get("injury_type") or "").lower()

    if not facts.get("severe_consequence"):
        if "tesk" in injury and "povred" in injury:
            facts["severe_consequence"] = "da"

    if not facts.get("weapon_used") and facts.get("weapon"):
        facts["weapon_used"] = "da"

    if not facts.get("fight_consequence"):
        if (facts.get("death_result") or "").strip().lower() == "da":
            facts["fight_consequence"] = "death_or_serious_injury"
        elif "tesk" in injury and "povred" in injury:
            facts["fight_consequence"] = "death_or_serious_injury"
