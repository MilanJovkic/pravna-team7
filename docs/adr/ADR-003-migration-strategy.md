# ADR-003: Migration Strategy

- Status: Accepted
- Date: 2026-03-31

## Context
A full rewrite has high regression risk.

## Decision
Use strangler migration phase-by-phase with contract lock tests and compatibility adapters.

## Consequences
- Existing behavior preserved during transition
- Refactor can be validated continuously in CI
