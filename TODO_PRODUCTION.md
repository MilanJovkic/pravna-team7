# TODO - Production Readiness

This file lists remaining work needed to fully satisfy the 9 project tasks and harden the system for production use.

## Spec Completion (Tasks 1-9)

- [x] Task 1: Ensure full law annotation coverage (pipeline + UI support)
  - [x] Add/confirm annotations for orgs, dates, and other entities in law text (not only structural refs).
  - [x] Verify all law chapters are parsed and exported to Akoma Ntoso.
- [x] Task 2: Minimum 5 court decisions (temporarily reduced from 15)
  - [x] Add at least 5 decisions in the same legal domain as the chosen law.
  - [x] Convert and annotate all decisions into Akoma Ntoso XML.
  - [x] Verify references to other laws and include any relevant ones.
- [x] Task 3: LegalRuleML rules
  - [x] Confirm rule set matches selected law articles and facts in decisions.
- [x] Task 4: NLP extraction + manual edits
  - [x] Provide UI or API to manually edit extracted metadata and factual state.
  - [x] Persist edits and show them in verdict display.
- [x] Task 5: Rule-based reasoning
  - [x] Validate dr-device output on multiple known cases.
- [x] Task 6: CBR case base
  - [x] Confirm 7+ key facts are used for similarity functions in jColibri.
  - [x] Rebuild case base after adding decisions.
- [x] Task 7: Law + verdict navigation
  - [x] Verify navigation from verdict references to law articles for all sample cases.
- [x] Task 8: User case entry and reuse
  - [x] Add explicit selection/confirmation for verdict type and sanction.
  - [x] Verify newly saved cases are used in subsequent CBR queries.
- [x] Task 9: Verdict generation
  - [x] Validate LLM-generated verdicts against the required structure.
  - [x] Ensure generated XML is visible in the UI.
