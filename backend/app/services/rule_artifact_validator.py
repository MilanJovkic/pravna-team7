"""Validation for RuleML/LegalRuleML/CLP artifacts before dr-device execution."""
from __future__ import annotations

from pathlib import Path
from typing import List
import re
import xml.etree.ElementTree as ET


def validate_rule_artifacts(dr_device_dir: Path, min_rules: int = 10) -> List[str]:
    errors: List[str] = []

    clp_path = dr_device_dir / "rulebase.clp"
    lrml_path = dr_device_dir / "rulebase.lrml"
    ruleml_path = dr_device_dir / "rulebase.ruleml"

    for path in (clp_path, lrml_path, ruleml_path):
        if not path.exists():
            errors.append(f"missing rule artifact: {path.name}")

    if errors:
        return errors

    clp_text = clp_path.read_text(encoding="utf-8")
    clp_rules = re.findall(r"\(defeasiblerule\s+(rule\d+)\b", clp_text)
    if len(clp_rules) < min_rules:
        errors.append(f"rulebase.clp has {len(clp_rules)} rules, expected at least {min_rules}")

    overfit_literals = [
        "metalni kljuc",
        "staklena flasa",
        "Podgorica",
        "Skadar",
        "Danilovgrad",
        "Podgorici Kv",
        "Sto",
    ]
    for token in overfit_literals:
        if token in clp_text:
            errors.append(f"rulebase.clp contains overfit literal: {token}")

    try:
        lrml_tree = ET.parse(lrml_path)
        lrml_root = lrml_tree.getroot()
    except Exception as exc:
        errors.append(f"rulebase.lrml parse error: {exc}")
        lrml_root = None

    try:
        ruleml_tree = ET.parse(ruleml_path)
        ruleml_root = ruleml_tree.getroot()
    except Exception as exc:
        errors.append(f"rulebase.ruleml parse error: {exc}")
        ruleml_root = None

    if lrml_root is not None:
        lrml_text = lrml_path.read_text(encoding="utf-8")
        lrml_rule_ids = set(re.findall(r'key=":(rule\d+)"', lrml_text))
        if len(lrml_rule_ids) < min_rules:
            errors.append(f"rulebase.lrml has {len(lrml_rule_ids)} rules, expected at least {min_rules}")
        if set(clp_rules) != lrml_rule_ids:
            errors.append("rule IDs mismatch between rulebase.clp and rulebase.lrml")

    _ = ruleml_root

    return errors
