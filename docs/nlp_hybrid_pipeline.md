# NLP Hybrid Pipeline (Regex + LLM)

This document formalizes Task 4 extraction as a hybrid pipeline and defines quality controls.

## Pipeline Stages

1. Regex metadata extraction:
- Module: src/verdict_annotation/verdict_parser.py
- Extracts case_number, court_name, date, judges, parties, applied law/article references, and factual state patterns.

2. LLM semantic extraction:
- Module: src/verdict_annotation/verdict_annotator.py
- Produces semantic summary, legal issues, applied laws/articles, legal reasoning, decision, confidence, metadata, factual_state.

3. Hybrid merge and normalization:
- Module: src/verdict_annotation/verdict_pipeline.py
- Merges regex + LLM outputs, normalizes legal labels/facts, and de-duplicates values.

4. Quality gating:
- Module: src/verdict_annotation/extraction_quality.py
- Flags weak extractions with needs_review when confidence is low/missing or key fields are missing.

5. Manual corrections:
- API: PUT /api/verdicts/{case_id}/overrides
- Service: backend/app/services/verdict_service.py
- Supports field-level manual correction on extracted data.

6. Audit trail:
- API: GET /api/verdicts/{case_id}/overrides/history
- Persists immutable change events in data/verdicts_xml/verdicts_overrides_audit.json.

## Confidence Policy

- Default threshold: 0.65
- Extraction is marked needs_review=true if:
  - confidence is missing
  - confidence < threshold
  - missing applied_laws
  - missing applied_articles
  - missing factual_state

## Fallback Rules

- Regex-only fallback is used when LLM annotation is unavailable.
- Manual override remains authoritative over extracted values.
- All override changes are tracked with old/new values and UTC timestamp.

## Quality Metrics

- Evaluation script: scripts/evaluate_nlp_extraction.py
- Metrics: precision, recall, F1 by field
- Gold mini-set: data/verdicts_xml/eval_mini_gold.json
