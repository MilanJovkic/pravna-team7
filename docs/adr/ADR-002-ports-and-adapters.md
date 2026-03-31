# ADR-002: Ports and Adapters

- Status: Accepted
- Date: 2026-03-31

## Context
External systems (PostgreSQL, dr-device, jColibri, filesystem, LLM providers) are currently called directly from services.

## Decision
Introduce outbound ports for all external dependencies and infrastructure adapters implementing those ports.

## Consequences
- Application/domain layers stop depending on concrete IO technology
- Integration tests become isolated per adapter
