"""Evaluate extraction quality on a mini labeled set with precision/recall/F1."""
import json
from pathlib import Path
from typing import Dict, Iterable, Set, Tuple


def _norm(v: str) -> str:
    return " ".join(str(v).strip().lower().split())


def _to_set(values: Iterable[str]) -> Set[str]:
    return {_norm(v) for v in values if str(v).strip()}


def _prf(tp: int, fp: int, fn: int) -> Tuple[float, float, float]:
    precision = tp / (tp + fp) if (tp + fp) else 0.0
    recall = tp / (tp + fn) if (tp + fn) else 0.0
    f1 = (2 * precision * recall) / (precision + recall) if (precision + recall) else 0.0
    return precision, recall, f1


def main() -> None:
    repo = Path(__file__).resolve().parents[1]
    pred_file = repo / "data" / "verdicts_xml" / "verdicts_annotations.json"
    gold_file = repo / "data" / "verdicts_xml" / "eval_mini_gold.json"

    preds = json.loads(pred_file.read_text(encoding="utf-8"))
    gold = json.loads(gold_file.read_text(encoding="utf-8"))

    stats: Dict[str, Dict[str, int]] = {
        "date": {"tp": 0, "fp": 0, "fn": 0},
        "injury_type": {"tp": 0, "fp": 0, "fn": 0},
        "location": {"tp": 0, "fp": 0, "fn": 0},
    }

    for case_id, truth in gold.items():
        pred = preds.get(case_id, {})
        meta = pred.get("metadata") or {}
        factual = pred.get("factual_state") or {}

        date_pred = _to_set([meta.get("date")] if meta.get("date") else [])
        date_gold = _to_set([truth.get("date")])
        stats["date"]["tp"] += len(date_pred & date_gold)
        stats["date"]["fp"] += len(date_pred - date_gold)
        stats["date"]["fn"] += len(date_gold - date_pred)

        injury_pred = _to_set(factual.get("injury_type", []))
        injury_gold = _to_set(truth.get("injury_type", []))
        stats["injury_type"]["tp"] += len(injury_pred & injury_gold)
        stats["injury_type"]["fp"] += len(injury_pred - injury_gold)
        stats["injury_type"]["fn"] += len(injury_gold - injury_pred)

        location_pred = _to_set(factual.get("location", []))
        location_gold = _to_set(truth.get("location", []))
        stats["location"]["tp"] += len(location_pred & location_gold)
        stats["location"]["fp"] += len(location_pred - location_gold)
        stats["location"]["fn"] += len(location_gold - location_pred)

    report = {}
    for field, values in stats.items():
        p, r, f1 = _prf(values["tp"], values["fp"], values["fn"])
        report[field] = {
            "precision": round(p, 4),
            "recall": round(r, 4),
            "f1": round(f1, 4),
            **values,
        }

    out_file = repo / "output" / "nlp_eval_report.json"
    out_file.parent.mkdir(parents=True, exist_ok=True)
    out_file.write_text(json.dumps(report, ensure_ascii=False, indent=2), encoding="utf-8")

    print(json.dumps(report, ensure_ascii=False, indent=2))
    print(f"Report written to: {out_file}")


if __name__ == "__main__":
    main()
