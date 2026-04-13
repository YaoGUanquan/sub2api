# Debug Playbook

1. Define exact failure signal.
2. Reproduce in the smallest environment possible.
3. Collect evidence: logs, inputs, stack traces, test output.
4. Narrow to one fault domain at a time.
5. Patch with smallest fix that resolves root cause.
6. Verify no obvious regressions in adjacent behavior.
7. Write an entry in `docs/ai-kb/troubleshooting-log.md`.
