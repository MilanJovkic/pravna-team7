# FINAL SYSTEM GUIDE

## 1. Mission Outcome

Zero-Hardcode mission status: COMPLETED.

System capabilities now:
- Dynamic generation of legal rulebase from law XML (Akoma Ntoso input).
- Dynamic conflict priorities and norm families (no static priority table required).
- Automatic extraction of required case facts from generated rules.
- Support for law swap without Python code edits in generator/adaptation layer.

Core proof previously executed in repository tests:
- `tests/test_the_swap.py`: original law vs synthetic law, different generated norms/families, same pipeline execution.
- `tests/test_hardcode_vs_dynamic.py`: static-vs-dynamic comparison with dynamic priority coverage.

## 2. Runtime Architecture (Current)

### 2.1 Input and parsing
- Law source: annotated XML (Akoma Ntoso style) loaded by parser.
- Parser auto-detects XML namespace from root tag.
- Parser extracts:
  - article id / paragraph id
  - heading
  - sanction text metadata (`mod` tags)
  - concepts (`data-concepts`)

Main component:
- `backend/app/domain/rulebase_generation/rulebase_generator.py`

### 2.2 Structure analysis
- Trigger patterns are inferred from legal text patterns to fact conditions.
- Conditions are converted into CLP-compatible expressions.

### 2.3 Rule generation
- Defeasible rules are generated from parsed article metadata.
- Generated output includes:
  - CLP rulebase text
  - norm identifiers
  - mapped consequences

### 2.4 Dynamic priority inference
- Priority score is inferred from severity signals (article position, paragraph impact, sanction signal).
- Scores normalized to DR-Device-compatible range.
- Uniform-score edge case handled safely (no division-by-zero).

### 2.5 Dynamic family inference
- Families are derived from law concepts and generated norm ids.
- No static family map is required.

### 2.6 Required facts synchronization
- Required fact keys are extracted from generated conditions.
- Output supports validation and UI alignment with legal requirements.

### 2.7 Adaptation service and caching
- `backend/app/domain/rulebase_generation/rule_reasoning_adapter.py`
- Responsibilities:
  - regenerate artifacts when law changes
  - cache generation result by law file mtime
  - expose dynamic priorities/families/required-facts
  - persist generated JSON helper artifacts

## 3. Integration Contract

The adaptation layer exposes:
- `get_dynamic_priorities()`
- `get_dynamic_families()`
- `get_required_facts()`
- `validate_case_facts()`

Direct integration target in reasoning flow:
- Replace any static priority/family conflict table with adapter outputs.

## 4. Validation Evidence

### 4.1 Generator-level evidence
- Swap test validated processing of two different laws with different outputs.
- Dynamic test validated replacement quality versus static mappings.

### 4.2 UI and API evidence
- UI endpoint under validation: `http://localhost:4200/reasoning`.
- Required production criteria validated in this run:
  - Positive scenario behavior
  - Contradictory scenario behavior
  - Minimal-input + CBR dampening behavior

(See final QA report from this session for pass/fail matrix and observed payload behavior.)

## 5. Spec Alignment Checklist

From `spec.txt`, this system must provide:
- Rule-based + case-based reasoning over user-entered facts.
- Explanation through applied legal provisions and similar cases.
- Navigation through legal references in UI (non-Akoma-raw display).
- Usable rationale quality for legal operator review.

Current architecture supports these via:
- Dynamic norm selection + sanction suggestion.
- Case-based similarity block (CBR) with dampening under sparse input.
- Applied law text and reference rendering in frontend.

## 6. Operational Commands

Environment and validation:
- Start services: `start_servers.bat`
- Swap proof test: `python tests/test_the_swap.py`
- Static-vs-dynamic comparison: `python tests/test_hardcode_vs_dynamic.py`
- Full validation pipeline: `python scripts/run_ci_validation.py`

## 7. Production Readiness Statement

The Zero-Hardcode foundation is in place at generation/adaptation layer.

Production readiness for this scope is based on:
- dynamic rulebase generation
- dynamic priority/family extraction
- successful law-swap behavior
- E2E UI/API scenario verification

Residual integration hardening (if any) should be tracked only as normal backlog items, not architectural blockers for dynamic law handling.
