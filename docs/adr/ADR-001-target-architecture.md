# ADR-001: Target Architecture

- Status: Accepted
- Date: 2026-03-31

## Context
Current backend mixes routing, domain logic, infrastructure access and process orchestration.

## Decision
Adopt layered Clean/Hexagonal architecture with explicit boundaries:
- Interfaces: FastAPI routes/controllers
- Application: use-cases and orchestration
- Domain: business rules and value objects
- Infrastructure: DB/filesystem/subprocess/HTTP adapters

## Consequences
- Improved testability and dependency control
- Migration performed incrementally using strangler pattern
