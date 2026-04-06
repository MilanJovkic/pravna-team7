from __future__ import annotations

import re
from pathlib import Path
from typing import Iterator

RULEBASE_PATH = Path(__file__).resolve().parents[1] / "dr-device" / "dr-device" / "rulebase.clp"


def _read_rulebase() -> str:
    return RULEBASE_PATH.read_text(encoding="utf-8")


def _extract_rule_blocks(text: str) -> list[str]:
    blocks: list[str] = []
    index = 0
    marker = "(defeasiblerule"

    while True:
        start = text.find(marker, index)
        if start == -1:
            break

        depth = 0
        end = start
        for cursor in range(start, len(text)):
            char = text[cursor]
            if char == "(":
                depth += 1
            elif char == ")":
                depth -= 1
                if depth == 0:
                    end = cursor + 1
                    break

        blocks.append(text[start:end])
        index = end

    return blocks


def _tokenize(source: str) -> list[str]:
    # String literals in rulebase do not contain escaped quotes.
    return re.findall(r'"[^"]*"|\(|\)|[^\s()]+', source)


def _parse_sexpr(tokens: list[str], pos: int = 0) -> tuple[object, int]:
    token = tokens[pos]
    if token != "(":
        return token, pos + 1

    pos += 1
    out: list[object] = []
    while pos < len(tokens) and tokens[pos] != ")":
        node, pos = _parse_sexpr(tokens, pos)
        out.append(node)

    if pos >= len(tokens) or tokens[pos] != ")":
        raise ValueError("Unbalanced parenthesis while parsing rulebase expression")

    return out, pos + 1


def _iter_lc_cases(node: object) -> Iterator[list[object]]:
    if not isinstance(node, list) or not node:
        return
    if node[0] == "lc:case":
        yield node
    for child in node:
        if isinstance(child, list):
            yield from _iter_lc_cases(child)


def _unquote(token: str) -> str:
    return token[1:-1] if token.startswith('"') and token.endswith('"') else token


def _eval_node(node: object, facts: dict[str, set[str]]) -> bool:
    if not isinstance(node, list) or not node:
        return True

    head = node[0]

    if head == "lc:case":
        for pred in node[1:]:
            if not isinstance(pred, list) or len(pred) < 2:
                continue
            key = pred[0]
            if not isinstance(key, str) or not key.startswith("lc:"):
                continue
            field = key.split(":", 1)[1]
            if field == "defendant":
                continue
            raw_val = pred[1]
            if not isinstance(raw_val, str):
                continue
            value = _unquote(raw_val)
            if value not in facts.get(field, set()):
                return False
        return True

    if head == "or":
        return any(_eval_node(branch, facts) for branch in node[1:])

    if head == "and":
        return all(_eval_node(branch, facts) for branch in node[1:])

    if head == "not":
        if len(node) < 2:
            return True
        return not _eval_node(node[1], facts)

    # Unknown head: treat as non-blocking for this structural test.
    return True


def _merge_fact_maps(dst: dict[str, set[str]], src: dict[str, set[str]]) -> None:
    for key, values in src.items():
        dst.setdefault(key, set()).update(values)


def _collect_positive_facts(node: object) -> dict[str, set[str]]:
    facts: dict[str, set[str]] = {}

    if not isinstance(node, list) or not node:
        return facts

    head = node[0]

    if head == "lc:case":
        for pred in node[1:]:
            if not isinstance(pred, list) or len(pred) < 2:
                continue
            key = pred[0]
            if not isinstance(key, str) or not key.startswith("lc:"):
                continue
            field = key.split(":", 1)[1]
            if field == "defendant":
                continue
            raw_val = pred[1]
            if not isinstance(raw_val, str):
                continue
            facts.setdefault(field, set()).add(_unquote(raw_val))
        return facts

    if head == "or":
        # One satisfied branch is enough for a positive scenario.
        if len(node) >= 2:
            return _collect_positive_facts(node[1])
        return facts

    if head == "and":
        for branch in node[1:]:
            _merge_fact_maps(facts, _collect_positive_facts(branch))
        return facts

    if head == "not":
        # Negations are naturally satisfied by absence, no positive fact needed.
        return facts

    for child in node[1:]:
        _merge_fact_maps(facts, _collect_positive_facts(child))
    return facts


def _parse_rule_block(block: str) -> dict[str, object]:
    rid_match = re.search(r"\(defeasiblerule\s+(rule\d+[a-z]?)", block)
    norm_match = re.search(r"=>\s*\((crime_art[0-9a-zA-Z_]+)", block, flags=re.S)
    if not rid_match or not norm_match:
        raise ValueError("Malformed rule block: missing id or consequent norm")

    if "=>" not in block:
        raise ValueError("Malformed rule block: missing implication")

    antecedent_raw = block.split("=>", 1)[0]
    # Drop the wrapper '(defeasiblerule ruleX' and parse the body forms only.
    prefix_match = re.match(r"\(defeasiblerule\s+rule\d+[a-z]?", antecedent_raw)
    if not prefix_match:
        raise ValueError("Malformed rule block prefix")
    body_raw = antecedent_raw[prefix_match.end():]

    tokens = _tokenize(body_raw)
    forms: list[object] = []
    pos = 0
    while pos < len(tokens):
        if tokens[pos] == ")":
            pos += 1
            continue
        node, pos = _parse_sexpr(tokens, pos)
        forms.append(node)

    return {
        "rule_id": rid_match.group(1),
        "norm": norm_match.group(1),
        "forms": forms,
    }


def _parse_exported_norms(text: str) -> set[str]:
    match = re.search(r"\(export-rdf\s+export\.rdf\s+(.*?)\)", text, flags=re.S)
    if not match:
        raise ValueError("Missing export-rdf declaration")
    return set(re.findall(r"crime_art[0-9a-zA-Z_]+", match.group(1)))


class TestRulebaseFullCoverage:
    def test_all_rules_are_present_and_unique(self) -> None:
        text = _read_rulebase()
        blocks = _extract_rule_blocks(text)
        parsed = [_parse_rule_block(block) for block in blocks]

        rule_ids = [item["rule_id"] for item in parsed]
        assert len(rule_ids) >= 60, "Expected a large ruleset, got too few rules"
        assert len(rule_ids) == len(set(rule_ids)), "Rule IDs must be unique"

    def test_every_rule_norm_is_exported(self) -> None:
        text = _read_rulebase()
        blocks = _extract_rule_blocks(text)
        parsed = [_parse_rule_block(block) for block in blocks]
        exported = _parse_exported_norms(text)

        missing = sorted({item["norm"] for item in parsed} - exported)
        assert not missing, f"Consequent norms missing from export-rdf: {missing}"

    def test_positive_scenario_exists_for_every_rule(self) -> None:
        text = _read_rulebase()
        blocks = _extract_rule_blocks(text)
        parsed = [_parse_rule_block(block) for block in blocks]

        for item in parsed:
            forms = item["forms"]
            assert isinstance(forms, list)

            facts: dict[str, set[str]] = {}
            for form in forms:
                _merge_fact_maps(facts, _collect_positive_facts(form))

            # Every rule in this rulebase should require at least one concrete fact.
            assert facts, f"No positive fact scenario generated for {item['rule_id']}"

            ok = all(_eval_node(form, facts) for form in forms)
            assert ok, f"Generated scenario does not satisfy antecedent for {item['rule_id']}"

    def test_every_rule_has_lc_case_condition(self) -> None:
        text = _read_rulebase()
        blocks = _extract_rule_blocks(text)
        parsed = [_parse_rule_block(block) for block in blocks]

        for item in parsed:
            lc_case_count = 0
            for form in item["forms"]:
                lc_case_count += sum(1 for _ in _iter_lc_cases(form))
            assert lc_case_count > 0, f"{item['rule_id']} must include at least one lc:case condition"
