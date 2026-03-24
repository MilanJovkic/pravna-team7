# Phase 0 Definition of Done (Spec Tasks 1-9)

This document defines objective acceptance criteria for each specification task.
A task is considered done only if all listed checks are true and linked evidence exists in the traceability matrix.

## Global Rules

- Every task must map to at least one implementation module.
- Every task must map to at least one API endpoint binding.
- Every task must map to at least one executable test artifact.
- Every task must map to at least one persisted evidence artifact.
- Missing mapping for any task means the phase is not complete.

## Task-Level Done Criteria

## Task 1

- Law XML is generated and loadable by the backend.
- Structural units (chapters/articles) are available through API.
- Reference annotations are queryable through service/API flow.

## Task 2

- Minimum 5 verdict XML files are available in current scoped phase.
- Verdict list and detail endpoints return metadata and text fields.
- Verdict artifacts are preserved under the verdict XML storage path.

## Task 3

- LegalRuleML source artifacts are present and versioned.
- Rule artifacts are transformable to executable rule files.
- Rule modeling is connected to legal facts used by reasoning.

## Task 4

- Automated extraction pipeline exists for metadata and legal facts.
- Manual correction mechanism exists for extracted verdict data.
- Annotation outputs are persisted in structured data files.

## Task 5

- dr-device reasoning runs through backend integration.
- Rulebase contains at least 10 modeled rules.
- Reasoning output exposes applied norms or explicit no-proof status.

## Task 6

- CBR model uses at least 7 relevant facts.
- Similarity model executes over case attributes.
- Combined reasoning includes CBR matches in API response.

## Task 7

- UI can browse law and verdict content through API.
- Navigation is supported via legal reference metadata.
- End-user UI does not expose raw Akoma XML markup.

## Task 8

- User can submit case facts for combined reasoning.
- User-selected outcome can be persisted as new case.
- Persisted case is reusable in next CBR query cycle.

## Task 9

- Verdict generation endpoint returns generated verdict payload.
- Generated verdict can be persisted to XML output.
- Generation consumes reasoning context and legal support text.

## Quality Gate

Phase 0 is complete only when:

- Traceability data passes automated validation test.
- Every spec task 1-9 has non-empty mappings and evidence.
- No invalid/missing file path remains in traceability references.
