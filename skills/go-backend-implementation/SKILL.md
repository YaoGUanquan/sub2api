---
name: go-backend-implementation
description: Implement backend features and refactors for this repository's Go services. Use when requests involve API behavior, backend business logic, data flow, service integration, or backend test updates.
---

# Go Backend Implementation

## Goal

Deliver safe backend changes that are minimal, testable, and aligned with existing repository patterns.

## Workflow

1. Read the relevant plan and affected AI-KB notes.
2. Locate impacted code paths with search before editing.
3. Implement the smallest coherent change set.
4. Keep compatibility unless the user explicitly asks for breaking changes.
5. Update or add tests close to changed behavior.
6. Report validations and any residual risks.

## Guardrails

- Avoid unrelated refactors during feature delivery.
- Keep configuration, env variables, and API contracts consistent.
- Surface uncertain assumptions before broad edits.

## Verification

- Run targeted tests first, then broader checks when practical.
- If tests cannot run, state it explicitly and explain why.

## References

- Use `references/backend-checklist.md` as a pre-commit checklist.
