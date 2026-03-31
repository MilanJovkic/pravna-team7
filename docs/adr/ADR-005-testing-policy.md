# ADR-005: Testing Policy

- Status: Accepted
- Date: 2026-03-31

## Context
Refactor safety requires explicit behavior lock.

## Decision
Mandatory test stack for migration:
- API contract-lock tests for critical endpoints
- Domain unit tests for business rules
- Adapter integration tests for external boundaries

## Consequences
- Lower regression risk during architecture changes
- Clear quality gate before entering next migration phase
