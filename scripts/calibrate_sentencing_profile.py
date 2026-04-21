#!/usr/bin/env python3
"""Calibrate sentencing severity profile from real verdict corpus and report alignment."""
from __future__ import annotations

import argparse
import json
import re
import sys
import unicodedata
from dataclasses import asdict, dataclass
from datetime import datetime, timezone
from pathlib import Path
from statistics import mean, median
from typing import Any


ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

from backend.app.domain.reasoning.policies import ReasoningPolicy
from backend.app.models.schemas import CaseFacts
from src.verdict_annotation.verdict_parser import VerdictParser

DEFAULT_TXT_DIR = ROOT / "data" / "verdicts_txt"
DEFAULT_PROFILE_PATH = ROOT / "backend" / "app" / "resources" / "sentencing_profile.json"
DEFAULT_REPORT_JSON = ROOT / "output" / "sentencing_calibration_report.json"
DEFAULT_REPORT_MD = ROOT / "output" / "sentencing_calibration_report.md"

TRUE_FEATURES = [
    "repeat_offender",
    "previous_convictions",
    "aggravating_circumstances",
    "mitigating_circumstances",
    "death_result",
    "severe_consequence",
    "weapon_used",
    "alcohol_intoxication",
    "narcotics_influence",
    "confession",
    "remorse",
    "plea_agreement",
    "family_circumstances",
    "poor_financial_status",
    "high_intensity_distress",
    "provocation",
    "negligence",
    "attempted_offense",
]
FALSE_FEATURES = ["previous_convictions"]
POSITIVE_FEATURES = {
    "repeat_offender",
    "previous_convictions",
    "aggravating_circumstances",
    "death_result",
    "severe_consequence",
    "weapon_used",
    "alcohol_intoxication",
    "narcotics_influence",
}
NEGATIVE_FEATURES = {
    "mitigating_circumstances",
    "confession",
    "remorse",
    "plea_agreement",
    "family_circumstances",
    "poor_financial_status",
    "high_intensity_distress",
    "provocation",
    "negligence",
    "attempted_offense",
}


@dataclass
class CorpusCase:
    file_name: str
    case_number: str
    primary_article: str
    offense_articles: list[str]
    article_numbers: list[str]
    min_months: int
    max_months: int
    actual_months: int
    facts: CaseFacts


@dataclass
class EvalResult:
    file_name: str
    case_number: str
    primary_article: str
    offense_articles: list[str]
    actual_months: int
    predicted_months: int | None
    absolute_error: int | None
    suggested_sanction: str | None
    true_features: list[str]
    false_features: list[str]


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Calibrate sentencing profile from verdict corpus.")
    parser.add_argument("--txt-dir", type=Path, default=DEFAULT_TXT_DIR)
    parser.add_argument("--profile-path", type=Path, default=DEFAULT_PROFILE_PATH)
    parser.add_argument("--report-json", type=Path, default=DEFAULT_REPORT_JSON)
    parser.add_argument("--report-md", type=Path, default=DEFAULT_REPORT_MD)
    parser.add_argument("--min-support", type=int, default=3)
    parser.add_argument("--dry-run", action="store_true")
    return parser.parse_args()


def normalize_text(text: str) -> str:
    lowered = text.lower().replace("\u00a0", " ")
    normalized = unicodedata.normalize("NFD", lowered)
    normalized = "".join(ch for ch in normalized if unicodedata.category(ch) != "Mn")
    normalized = re.sub(r"[^a-z0-9\s]", " ", normalized)
    return re.sub(r"\s+", " ", normalized).strip()


def parse_bool_token(value: str | None) -> bool | None:
    if value is None:
        return None
    token = str(value).strip().lower()
    if token in {"da", "true", "1", "yes"}:
        return True
    if token in {"ne", "false", "0", "no"}:
        return False
    return None


def first_fact(facts: dict[str, list[str]], key: str) -> str | None:
    values = facts.get(key) or []
    if not values:
        return None
    return str(values[0]).strip()


def parse_months_from_sanction(text: str | None) -> int | None:
    if not text:
        return None
    value = text.lower()
    if "novcana kazna" in value:
        return 0

    years_match = re.search(r"(\d+)\s+godin", value)
    months_match = re.search(r"(\d+)\s+mes", value)

    years = int(years_match.group(1)) if years_match else 0
    months = int(months_match.group(1)) if months_match else 0
    total = years * 12 + months
    return total if total > 0 else None


def extract_article_numbers_from_refs(article_refs: list[str]) -> list[str]:
    numbers: list[str] = []
    for ref in article_refs:
        match = re.search(r"(\d+[a-z]?)", str(ref).lower())
        if not match:
            continue
        number = match.group(1)
        if number not in numbers:
            numbers.append(number)
    return numbers


def extract_offense_articles(text: str, fallback_refs: list[str]) -> list[str]:
    normalized = normalize_text(text)
    offense_articles: list[str] = []
    patterns = [
        re.compile(r"krivicn\w*\s+djel\w*.{0,180}?iz\s+clan\w*\s+(\d+[a-z]?)", re.IGNORECASE),
        re.compile(r"zbog\s+krivicn\w*\s+djel\w*.{0,180}?iz\s+clan\w*\s+(\d+[a-z]?)", re.IGNORECASE),
    ]

    for pattern in patterns:
        for match in pattern.finditer(normalized):
            article = match.group(1)
            if article not in offense_articles:
                offense_articles.append(article)

    if offense_articles:
        return offense_articles
    return extract_article_numbers_from_refs(fallback_refs)


def build_case_facts(metadata, text: str) -> CaseFacts:
    factual = metadata.factual_state or {}
    normalized_text = normalize_text(text)

    injury_type = first_fact(factual, "injury_type")
    weapon_value = first_fact(factual, "weapon")

    attempted = parse_bool_token(first_fact(factual, "attempted_offense"))
    if attempted is None and re.search(r"\bu\s+pokusaj\w*\b|\bpokusao\s+da\b|\bpokusala\s+da\b", normalized_text):
        attempted = True

    severe = parse_bool_token(first_fact(factual, "severe_consequence"))
    if severe is None and injury_type:
        severe = "tesk" in injury_type.lower()

    death = parse_bool_token(first_fact(factual, "death_result"))
    if death is None and re.search(r"\blisio\s+zivota\b|\busmrtio\b|\bsmrt\b", normalized_text):
        death = True

    return CaseFacts(
        defendant=metadata.case_number or metadata.case_number or "nepoznato",
        injury_type=injury_type,
        location=first_fact(factual, "location"),
        weapon=weapon_value,
        weapon_used=parse_bool_token(first_fact(factual, "weapon_used")) if first_fact(factual, "weapon_used") is not None else (True if weapon_value else None),
        severe_consequence=severe,
        death_result=death,
        negligence=parse_bool_token(first_fact(factual, "negligence")),
        provocation=parse_bool_token(first_fact(factual, "provocation")),
        fight_participation=parse_bool_token(first_fact(factual, "fight_participation")),
        fight_consequence=first_fact(factual, "fight_consequence"),
        left_without_help=parse_bool_token(first_fact(factual, "left_without_help")),
        previous_convictions=parse_bool_token(first_fact(factual, "previous_convictions")),
        repeat_offender=parse_bool_token(first_fact(factual, "repeat_offender")),
        confession=parse_bool_token(first_fact(factual, "confession")),
        remorse=parse_bool_token(first_fact(factual, "remorse")),
        plea_agreement=parse_bool_token(first_fact(factual, "plea_agreement")),
        aggravating_circumstances=parse_bool_token(first_fact(factual, "aggravating_circumstances")),
        mitigating_circumstances=parse_bool_token(first_fact(factual, "mitigating_circumstances")),
        family_circumstances=parse_bool_token(first_fact(factual, "family_circumstances")),
        poor_financial_status=parse_bool_token(first_fact(factual, "poor_financial_status")),
        alcohol_intoxication=parse_bool_token(first_fact(factual, "alcohol_intoxication")),
        narcotics_influence=parse_bool_token(first_fact(factual, "narcotics_influence")),
        conditional_sentence_requested=parse_bool_token(first_fact(factual, "conditional_sentence_requested")),
        attempted_offense=attempted,
    )


def choose_primary_article(policy: ReasoningPolicy, offense_articles: list[str]) -> tuple[str, dict[str, object]] | None:
    best: tuple[tuple[int, int, int], str, dict[str, object]] | None = None
    for article in offense_articles:
        structured = policy._resolve_structured_sanction_from_article(article)
        if not structured:
            continue
        mode = str(structured.get("mode") or "")
        max_months = structured.get("max_months")
        if mode not in {"prison", "both"} or not isinstance(max_months, int):
            continue
        rank = policy._rank_structured_sanction(structured)
        if best is None or rank > best[0]:
            best = (rank, article, structured)

    if best is None:
        return None
    return best[1], best[2]


def load_corpus_cases(txt_dir: Path, policy: ReasoningPolicy) -> list[CorpusCase]:
    parser = VerdictParser()
    cases: list[CorpusCase] = []

    for txt_file in sorted(txt_dir.glob("*.txt")):
        text = txt_file.read_text(encoding="utf-8", errors="ignore")
        metadata = parser.parse(text, txt_file.name)
        factual = metadata.factual_state or {}

        imposed = first_fact(factual, "imposed_prison_sentence_months")
        if not imposed:
            continue
        try:
            actual_months = int(imposed)
        except ValueError:
            continue

        offense_articles = extract_offense_articles(text, metadata.article_references or [])
        if not offense_articles:
            continue

        primary = choose_primary_article(policy, offense_articles)
        if not primary:
            continue

        primary_article, structured = primary
        min_months = int(structured.get("min_months") or 0)
        max_months = int(structured.get("max_months") or 0)
        if max_months <= 0:
            continue

        facts = build_case_facts(metadata, text)
        article_numbers = [primary_article]
        for article in offense_articles:
            if article not in article_numbers:
                article_numbers.append(article)

        cases.append(
            CorpusCase(
                file_name=txt_file.name,
                case_number=metadata.case_number or txt_file.stem,
                primary_article=primary_article,
                offense_articles=offense_articles,
                article_numbers=article_numbers,
                min_months=min_months,
                max_months=max_months,
                actual_months=actual_months,
                facts=facts,
            )
        )

    return cases


def evaluate_cases(policy: ReasoningPolicy, cases: list[CorpusCase]) -> list[EvalResult]:
    results: list[EvalResult] = []
    for case in cases:
        sanction = policy.suggest_sanction(
            article_numbers=case.article_numbers,
            facts=case.facts,
            norms=[f"crime_art{case.primary_article}"],
            verdict="osudjen",
        )
        predicted = parse_months_from_sanction(sanction)
        error = abs(case.actual_months - predicted) if predicted is not None else None

        true_features = [name for name in TRUE_FEATURES if getattr(case.facts, name, None) is True]
        false_features = [name for name in FALSE_FEATURES if getattr(case.facts, name, None) is False]

        results.append(
            EvalResult(
                file_name=case.file_name,
                case_number=case.case_number,
                primary_article=case.primary_article,
                offense_articles=case.offense_articles,
                actual_months=case.actual_months,
                predicted_months=predicted,
                absolute_error=error,
                suggested_sanction=sanction,
                true_features=true_features,
                false_features=false_features,
            )
        )
    return results


def summarize_metrics(results: list[EvalResult]) -> dict[str, Any]:
    scored = [r for r in results if r.predicted_months is not None and r.absolute_error is not None]
    if not scored:
        return {
            "evaluated_cases": 0,
            "mae_months": None,
            "median_ae_months": None,
            "within_6_months": 0,
            "within_12_months": 0,
            "within_24_months": 0,
        }

    errors = [int(r.absolute_error or 0) for r in scored]
    return {
        "evaluated_cases": len(scored),
        "mae_months": round(mean(errors), 3),
        "median_ae_months": int(median(errors)),
        "within_6_months": sum(1 for e in errors if e <= 6),
        "within_12_months": sum(1 for e in errors if e <= 12),
        "within_24_months": sum(1 for e in errors if e <= 24),
    }


def clamp(value: float, low: float, high: float) -> float:
    return max(low, min(high, value))


def calibrate_profile(cases: list[CorpusCase], min_support: int, default_profile: dict[str, Any]) -> dict[str, Any]:
    default_base = float(default_profile.get("base_severity") or 0.5)
    default_attempt_factor = float(default_profile.get("attempted_max_factor") or 0.6)
    default_true_weights = dict(default_profile.get("true_feature_weights") or {})
    default_false_weights = dict(default_profile.get("false_feature_weights") or {})

    attempt_ratios: list[float] = []
    for case in cases:
        if not bool(case.facts.attempted_offense) and "20" not in case.article_numbers:
            continue
        if case.max_months > 0 and case.actual_months > 0:
            attempt_ratios.append(case.actual_months / case.max_months)

    attempted_factor = default_attempt_factor
    if attempt_ratios:
        learned_attempt = clamp(median(attempt_ratios), 0.25, 0.9)
        attempt_blend = len(attempt_ratios) / (len(attempt_ratios) + 6)
        attempted_factor = default_attempt_factor * (1 - attempt_blend) + learned_attempt * attempt_blend

    rows: list[tuple[CorpusCase, float]] = []
    for case in cases:
        is_attempt = bool(case.facts.attempted_offense) or ("20" in case.article_numbers)
        if is_attempt:
            eff_min = 0
            eff_max = max(1, int(round(case.max_months * attempted_factor)))
        else:
            eff_min = case.min_months
            eff_max = case.max_months

        if eff_max <= eff_min:
            target = 0.5
        else:
            target = (case.actual_months - eff_min) / (eff_max - eff_min)
        target = clamp(target, 0.05, 0.95)
        rows.append((case, target))

    learned_baseline = mean(target for _, target in rows) if rows else default_base
    base_blend = len(rows) / (len(rows) + 10)
    baseline = default_base * (1 - base_blend) + learned_baseline * base_blend

    true_weights: dict[str, float] = {k: float(v) for k, v in default_true_weights.items() if isinstance(v, (int, float))}
    for feature in TRUE_FEATURES:
        prior = float(default_true_weights.get(feature, 0.0))
        values = [target for case, target in rows if getattr(case.facts, feature, None) is True]
        if len(values) < min_support:
            if feature in POSITIVE_FEATURES and prior < 0:
                true_weights[feature] = 0.0
            if feature in NEGATIVE_FEATURES and prior > 0:
                true_weights[feature] = 0.0
            continue
        raw_delta = mean(values) - baseline
        learned = raw_delta * (len(values) / (len(values) + 5))
        blend = len(values) / (len(values) + 8)
        weight = prior * (1 - blend) + learned * blend

        if feature in POSITIVE_FEATURES and weight < 0:
            weight = 0.0
        if feature in NEGATIVE_FEATURES and weight > 0:
            weight = 0.0

        true_weights[feature] = round(weight, 4)

    false_weights: dict[str, float] = {k: float(v) for k, v in default_false_weights.items() if isinstance(v, (int, float))}
    for feature in FALSE_FEATURES:
        prior = float(default_false_weights.get(feature, 0.0))
        values = [target for case, target in rows if getattr(case.facts, feature, None) is False]
        if len(values) < min_support:
            false_weights[feature] = round(prior, 4)
            continue
        raw_delta = mean(values) - baseline
        learned = raw_delta * (len(values) / (len(values) + 5))
        blend = len(values) / (len(values) + 8)
        weight = prior * (1 - blend) + learned * blend
        false_weights[feature] = round(weight, 4)

    targets = [target for _, target in rows] or [0.5]
    learned_min = clamp(min(targets) - 0.02, 0.05, 0.5)
    learned_max = clamp(max(targets) + 0.02, 0.5, 0.98)
    min_severity = (float(default_profile.get("min_severity") or 0.1) * 0.4) + (learned_min * 0.6)
    max_severity = (float(default_profile.get("max_severity") or 0.95) * 0.4) + (learned_max * 0.6)

    profile = {
        "generated_at": datetime.now(timezone.utc).isoformat().replace("+00:00", "Z"),
        "sample_count": len(rows),
        "base_severity": round(baseline, 4),
        "min_severity": round(min_severity, 4),
        "max_severity": round(max_severity, 4),
        "attempted_max_factor": round(float(attempted_factor), 4),
        "fine_threshold_both_mode": 0.36,
        "true_feature_weights": true_weights,
        "false_feature_weights": false_weights,
    }

    # Optimize attempted offense range factor against corpus MAE.
    candidate_factors = [round(0.2 + (i * 0.02), 2) for i in range(31)]
    best_factor = float(profile["attempted_max_factor"])
    best_mae = _estimate_profile_mae(cases, profile)

    for factor in candidate_factors:
        candidate_profile = dict(profile)
        candidate_profile["attempted_max_factor"] = factor
        mae = _estimate_profile_mae(cases, candidate_profile)
        if mae < best_mae:
            best_mae = mae
            best_factor = factor

    profile["attempted_max_factor"] = round(best_factor, 4)
    return profile


def _estimate_profile_mae(cases: list[CorpusCase], profile: dict[str, Any]) -> float:
    policy = ReasoningPolicy(load_profile=False)
    policy._sentencing_profile = dict(profile)

    errors: list[int] = []
    for case in cases:
        sanction = policy.suggest_sanction(
            article_numbers=case.article_numbers,
            facts=case.facts,
            norms=[f"crime_art{case.primary_article}"],
            verdict="osudjen",
        )
        predicted = parse_months_from_sanction(sanction)
        if predicted is None:
            continue
        errors.append(abs(case.actual_months - predicted))

    if not errors:
        return 10_000.0
    return float(mean(errors))


def write_markdown_report(
    path: Path,
    baseline_metrics: dict[str, Any],
    calibrated_metrics: dict[str, Any],
    improvement_samples: list[dict[str, Any]],
    profile: dict[str, Any],
) -> None:
    lines: list[str] = []
    lines.append("# Sentencing Calibration Report")
    lines.append("")
    lines.append(f"Generated: {profile.get('generated_at')}")
    lines.append("")

    lines.append("## Baseline")
    lines.append(f"- Evaluated cases: {baseline_metrics.get('evaluated_cases')}")
    lines.append(f"- MAE (months): {baseline_metrics.get('mae_months')}")
    lines.append(f"- Median AE (months): {baseline_metrics.get('median_ae_months')}")
    lines.append(f"- Within 6 months: {baseline_metrics.get('within_6_months')}")
    lines.append(f"- Within 12 months: {baseline_metrics.get('within_12_months')}")
    lines.append(f"- Within 24 months: {baseline_metrics.get('within_24_months')}")
    lines.append("")

    lines.append("## Calibrated")
    lines.append(f"- Evaluated cases: {calibrated_metrics.get('evaluated_cases')}")
    lines.append(f"- MAE (months): {calibrated_metrics.get('mae_months')}")
    lines.append(f"- Median AE (months): {calibrated_metrics.get('median_ae_months')}")
    lines.append(f"- Within 6 months: {calibrated_metrics.get('within_6_months')}")
    lines.append(f"- Within 12 months: {calibrated_metrics.get('within_12_months')}")
    lines.append(f"- Within 24 months: {calibrated_metrics.get('within_24_months')}")
    lines.append("")

    lines.append("## Learned Profile")
    lines.append(f"- Base severity: {profile.get('base_severity')}")
    lines.append(f"- Attempted offense max factor: {profile.get('attempted_max_factor')}")
    lines.append(f"- True-feature weights: {len(profile.get('true_feature_weights') or {})}")
    lines.append(f"- False-feature weights: {len(profile.get('false_feature_weights') or {})}")
    lines.append("")

    lines.append("## Sample Case Analysis")
    for sample in improvement_samples:
        lines.append(f"### {sample['file_name']} ({sample['case_number']})")
        lines.append(f"- Primary article: {sample['primary_article']}")
        lines.append(f"- Offense articles: {', '.join(sample['offense_articles'])}")
        lines.append(f"- True features: {', '.join(sample['true_features']) if sample['true_features'] else 'none'}")
        lines.append(f"- Actual months: {sample['actual_months']}")
        lines.append(f"- Baseline predicted: {sample['baseline_predicted']} (error {sample['baseline_error']})")
        lines.append(f"- Calibrated predicted: {sample['calibrated_predicted']} (error {sample['calibrated_error']})")
        lines.append("")

    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text("\n".join(lines), encoding="utf-8")


def main() -> int:
    args = parse_args()

    baseline_policy = ReasoningPolicy(load_profile=False)
    cases = load_corpus_cases(args.txt_dir, baseline_policy)

    baseline_results = evaluate_cases(baseline_policy, cases)
    baseline_metrics = summarize_metrics(baseline_results)

    profile = calibrate_profile(cases, min_support=args.min_support, default_profile=baseline_policy._sentencing_profile)

    if not args.dry_run:
        args.profile_path.parent.mkdir(parents=True, exist_ok=True)
        args.profile_path.write_text(json.dumps(profile, ensure_ascii=False, indent=2), encoding="utf-8")

    calibrated_policy = ReasoningPolicy(profile_path=args.profile_path, load_profile=True)
    calibrated_results = evaluate_cases(calibrated_policy, cases)
    calibrated_metrics = summarize_metrics(calibrated_results)

    baseline_by_file = {item.file_name: item for item in baseline_results}
    calibrated_by_file = {item.file_name: item for item in calibrated_results}

    samples: list[dict[str, Any]] = []
    for case in cases:
        b = baseline_by_file.get(case.file_name)
        c = calibrated_by_file.get(case.file_name)
        if not b or not c:
            continue
        if b.absolute_error is None or c.absolute_error is None:
            continue
        samples.append(
            {
                "file_name": case.file_name,
                "case_number": case.case_number,
                "primary_article": case.primary_article,
                "offense_articles": case.offense_articles,
                "actual_months": case.actual_months,
                "baseline_predicted": b.predicted_months,
                "baseline_error": b.absolute_error,
                "calibrated_predicted": c.predicted_months,
                "calibrated_error": c.absolute_error,
                "true_features": [name for name in TRUE_FEATURES if getattr(case.facts, name, None) is True],
            }
        )

    samples.sort(key=lambda item: (item["baseline_error"] - item["calibrated_error"]), reverse=True)
    improvement_samples = samples[:8]

    report = {
        "generated_at": datetime.now(timezone.utc).isoformat().replace("+00:00", "Z"),
        "corpus_size": len(cases),
        "profile_path": str(args.profile_path),
        "baseline": baseline_metrics,
        "calibrated": calibrated_metrics,
        "profile": profile,
        "sample_analysis": improvement_samples,
        "baseline_results": [asdict(item) for item in baseline_results],
        "calibrated_results": [asdict(item) for item in calibrated_results],
    }

    args.report_json.parent.mkdir(parents=True, exist_ok=True)
    args.report_json.write_text(json.dumps(report, ensure_ascii=False, indent=2), encoding="utf-8")
    write_markdown_report(args.report_md, baseline_metrics, calibrated_metrics, improvement_samples, profile)

    print("CORPUS_CASES", len(cases))
    print("BASELINE_MAE", baseline_metrics.get("mae_months"))
    print("CALIBRATED_MAE", calibrated_metrics.get("mae_months"))
    print("PROFILE_PATH", args.profile_path)
    print("REPORT_JSON", args.report_json)
    print("REPORT_MD", args.report_md)

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
