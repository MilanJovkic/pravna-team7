from __future__ import annotations

import re

from backend.app.domain.reasoning.policies import ReasoningPolicy
from backend.app.models.schemas import CaseFacts
from src.verdict_annotation.verdict_parser import VerdictParser


def _extract_months(label: str) -> int:
    text = label.lower()

    year_match = re.search(r"(\d+)\s+godina", text)
    month_match = re.search(r"(\d+)\s+mesec", text)

    years = int(year_match.group(1)) if year_match else 0
    months = int(month_match.group(1)) if month_match else 0
    total = years * 12 + months

    if total == 0:
        solo_month = re.search(r"(\d+)\s+meseci", text)
        if solo_month:
            total = int(solo_month.group(1))
    return total


def test_suggest_sanction_returns_exact_prison_term_not_range() -> None:
    policy = ReasoningPolicy()

    # Simulate an article sanction range 2-12 years.
    policy._resolve_structured_sanction_from_norm = lambda _norm: {
        "mode": "prison",
        "min_months": 24,
        "max_months": 144,
        "raw": "zatvorom od dvije do dvanaest godina",
    }

    sanction = policy.suggest_sanction(
        article_numbers=["151"],
        facts=CaseFacts(defendant="X"),
        norms=["crime_art151"],
        verdict="osudjen",
    )

    assert sanction is not None
    assert "kazna zatvora" in sanction
    assert " do " not in sanction

    months = _extract_months(sanction)
    assert 24 <= months <= 144


def test_aggravating_facts_increase_exact_sentence() -> None:
    policy = ReasoningPolicy()

    policy._resolve_structured_sanction_from_norm = lambda _norm: {
        "mode": "prison",
        "min_months": 24,
        "max_months": 144,
        "raw": "zatvorom od dvije do dvanaest godina",
    }

    severe_facts = CaseFacts(
        defendant="A",
        previous_convictions=True,
        repeat_offender=True,
        aggravating_circumstances=True,
        severe_consequence=True,
        weapon_used=True,
    )
    mild_facts = CaseFacts(
        defendant="B",
        previous_convictions=False,
        confession=True,
        remorse=True,
        plea_agreement=True,
        mitigating_circumstances=True,
    )

    severe = policy.suggest_sanction(["151"], severe_facts, norms=["crime_art151"], verdict="osudjen")
    mild = policy.suggest_sanction(["151"], mild_facts, norms=["crime_art151"], verdict="osudjen")

    assert severe is not None and mild is not None
    assert _extract_months(severe) > _extract_months(mild)


def test_qualified_legal_elements_are_not_double_counted_in_score() -> None:
    policy = ReasoningPolicy()

    policy._resolve_structured_sanction_from_norm = lambda _norm: {
        "mode": "prison",
        "min_months": 24,
        "max_months": 144,
        "raw": "zatvorom od dvije do dvanaest godina",
    }

    base_facts = CaseFacts(defendant="A")
    qualified_elements_facts = CaseFacts(
        defendant="A",
        execution_manner=["podmukao", "bezobzirno_nasilnicko_ponasanje"],
        offender_motive=["koristoljublje"],
    )

    base_sanction = policy.suggest_sanction(["151"], base_facts, norms=["crime_art151"], verdict="osudjen")
    qualified_sanction = policy.suggest_sanction(
        ["151"],
        qualified_elements_facts,
        norms=["crime_art151"],
        verdict="osudjen",
    )

    assert base_sanction is not None and qualified_sanction is not None
    assert _extract_months(base_sanction) == _extract_months(qualified_sanction)


def test_attempted_offense_reduces_effective_sentence_range() -> None:
    policy = ReasoningPolicy(load_profile=False)

    policy._resolve_structured_sanction_from_norm = lambda _norm: {
        "mode": "prison",
        "min_months": 60,
        "max_months": 180,
        "raw": "zatvorom od pet do petnaest godina",
    }

    regular = policy.suggest_sanction(
        ["143"],
        CaseFacts(defendant="A", severe_consequence=True),
        norms=["crime_art143"],
        verdict="osudjen",
    )
    attempted = policy.suggest_sanction(
        ["143", "20"],
        CaseFacts(defendant="A", severe_consequence=True, attempted_offense=True),
        norms=["crime_art143"],
        verdict="osudjen",
    )

    assert regular is not None and attempted is not None
    assert _extract_months(attempted) < _extract_months(regular)


def test_parser_extracts_sentencing_factors_and_imposed_months() -> None:
    parser = VerdictParser()
    sample_text = (
        "Okrivljeni je ranije osudjivan i priznanje krivice je dato. "
        "Sud cijeni iskreno kajanje i sporazum o priznanju krivice. "
        "Sud izriče kaznu zatvora u trajanju od 2 godine i 6 mjeseci, "
        "ali se ista neće izvršiti ukoliko u roku od 3 godine ne učini novo djelo."
    )

    metadata = parser.parse(sample_text, "test")
    facts = metadata.factual_state

    assert facts.get("previous_convictions") == ["da"]
    assert facts.get("confession") == ["da"]
    assert facts.get("remorse") == ["da"]
    assert facts.get("plea_agreement") == ["da"]
    assert facts.get("conditional_sentence_requested") == ["da"]
    assert facts.get("imposed_prison_sentence_months") == ["30"]


def test_parser_extracts_attempted_offense_flag() -> None:
    parser = VerdictParser()
    sample_text = (
        "Okrivljeni je sa umišljajem pokušao da liši života oštećenog. "
        "Sud zaključuje da je riječ o djelu u pokušaju."
    )

    metadata = parser.parse(sample_text, "test")
    facts = metadata.factual_state
    assert facts.get("attempted_offense") == ["da"]
