---
name: bug-triage-debugging
description: Reproduce, isolate, and fix defects in this repository with evidence-based debugging. Use when users report failures, regressions, flaky tests, unexpected behavior, or production incidents.
---

# Bug Triage Debugging

## Goal

Move from symptom to verified fix with a reproducible record.

## Workflow

1. Capture symptom, expected behavior, and observed behavior.
2. Reproduce with smallest reliable steps.
3. Isolate scope to module, commit range, or dependency path.
4. Form and test hypotheses using logs, tests, and targeted instrumentation.
5. Implement the fix with minimal blast radius.
6. Validate with reproduction case and regression checks.
7. Document root cause and fix in AI knowledge base.

## Required Evidence

- Reproduction steps
- Root cause summary
- Validation result
- Residual risk or follow-up tasks

## References

- Use `references/debug-playbook.md` for structured triage.
