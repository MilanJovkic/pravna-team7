# ADR-004: Observability Standards

- Status: Accepted
- Date: 2026-03-31

## Context
Logs are inconsistent and lack correlation across requests.

## Decision
Adopt structured JSON logging, per-request correlation IDs and centralized exception handling with a stable error envelope.

## Consequences
- Faster incident triage
- Reliable traceability between API request and subsystem failures
