# Spec Traceability Matrix

Canonical source: docs/spec_traceability.json

| Task | Spec Theme | Key Modules | Endpoint Bindings | Tests | Evidence Artifacts |
|---|---|---|---|---|---|
| 1 | Law in Akoma Ntoso | src/akoma_annotation/*, backend/app/services/law_service.py | GET /api/laws/chapters, GET /api/laws/articles/{article_number} | tests/api_smoke.py | output/annotated_law.xml |
| 2 | Verdicts in Akoma Ntoso | src/verdict_annotation/*, backend/app/services/verdict_service.py | GET /api/verdicts, GET /api/verdicts/{case_id} | tests/api_smoke.py | data/verdicts_xml/, verdicts_annotations.json |
| 3 | LegalRuleML norms | dr-device/dr-device/rulebase.lrml, rulebase.ruleml, rule_reasoning_service.py | POST /api/reasoning/ | tests/test_final_validation.py | rulebase.lrml, rulebase.ruleml |
| 4 | NLP extraction + manual correction | verdict_annotator.py, verdict_pipeline.py, backend/app/api/verdicts.py | POST /api/verdicts/{case_id}/overrides | tests/api_smoke.py | verdicts_annotations.json, verdicts_overrides.json |
| 5 | Rule reasoning (dr-device) | rule_reasoning_service.py, rulebase.clp | POST /api/reasoning/ | tests/test_final_validation.py | rulebase.clp, proof.ruleml |
| 6 | CBR + similarity | cbr-jcolibri CaseDescription.java, TabularSimilarity.java, cbr_service.py | POST /api/reasoning/ | tests/test_cbr.py, tests/test_final_validation.py | cbr-jcolibri/pom.xml, sql/schema.sql |
| 7 | Law and verdict browsing | frontend/src, backend/app/api/laws.py, backend/app/api/verdicts.py | GET /api/laws/articles/{article_number}, GET /api/verdicts/{case_id} | tests/api_smoke.py | frontend/angular.json, data/verdicts_xml/ |
| 8 | Combined reasoning + persist case | backend/app/api/reasoning.py, cases.py, case_service.py | POST /api/reasoning/, POST /api/cases/ | tests/test_case_save.py, tests/test_final_validation.py | sql/schema.sql, backend/app/models/ |
| 9 | Verdict generation | verdict_generation.py, verdict_generation_service.py | POST /api/verdict-generation/ | tests/test_final_validation.py | data/verdicts_xml/, verdict generation service |

## Scope Note

- In this implementation phase, Task 2 keeps minimum 5 verdicts due to token-budget constraints.
- Matrix completeness is enforced by automated test in tests/test_phase0_governance.py.
