# Project Agents Guide

This repository uses a local skill router for development tasks.
Read this file at task start, then pick one skill from `./skills` based on user intent.

## Startup Checklist

1. Read `docs/ai-kb/project-context.md` and `docs/ai-kb/architecture-map.md`.
2. Classify the user request by intent.
3. Load one primary skill from `skills/` and execute its workflow.
4. Update AI knowledge base files after any substantial change.

## Skill Routing

Use this routing table for automatic selection:

- Requirement clarification, implementation plan, cross-module scoping:
  use `skills/project-intake-planning/SKILL.md`
- Backend feature implementation, refactor, API behavior updates:
  use `skills/go-backend-implementation/SKILL.md`
- Bug report, regression, test failure, production issue:
  use `skills/bug-triage-debugging/SKILL.md`
- Documentation updates, knowledge capture, conversation summarization:
  use `skills/knowledge-base-maintenance/SKILL.md`

If multiple skills apply, start with `project-intake-planning`, then hand off to one execution skill.

## Git Branch and Upload Rules

Use this repository workflow consistently:

1. Keep `main` as the sync branch for upstream updates.
2. Do feature work only on `feature/*` branches.
3. Sync `main` first, then update the feature branch from `main`.
4. Push feature branches to `origin` and open PRs from feature branch to `main`.

### Main Sync Commands

```bash
git checkout main
git fetch upstream
git rebase upstream/main
git push origin main
```

### Feature Development Commands

```bash
git checkout -b feature/<topic>
# implement + commit
git push -u origin feature/<topic>
```

### Keep Feature Branch Updated

```bash
git checkout feature/<topic>
git fetch origin
git rebase origin/main
# or: git merge origin/main
```

### Daily Upload Safety Checks

```bash
git status -sb
git branch --show-current
git remote -v
```

## Knowledge Base Policy

After major work, update:

- `docs/ai-kb/session-notes.md` for what happened
- `docs/ai-kb/decision-log.md` for decision and rationale
- `docs/ai-kb/troubleshooting-log.md` for incident and fix
- `docs/ai-kb/backlog.md` for next tasks and follow-ups

Keep entries concise and dated.
