# Decision Log

## [2026-03-31] Establish project-local agent workflow

- Context: The repository is a fork that must track upstream while enabling custom feature development.
- Decision: Add `AGENTS.md`, project-local `skills/`, and `docs/ai-kb/` to preserve structured context across long conversations.
- Alternatives considered: Keep ad-hoc chat-only context without persistent docs.
- Tradeoffs: Slight maintenance overhead for docs updates, better long-term execution speed and consistency.
- Affected paths: `AGENTS.md`, `skills/`, `docs/ai-kb/`.
- Follow-up: Keep entries updated after major implementation tasks.

## [2026-04-03] Record deployment baseline before production image upgrades

- Context: Tokyo server 2 (43.153.150.195) is running `weishaw/sub2api:latest`, and compose command checks were executed outside deployment directory, causing false-negative status checks.
- Decision: Always capture deployment baseline and troubleshooting evidence in `docs/ai-kb/*` before production upgrades, then perform controlled Docker update with validation.
- Alternatives considered: Continue ad-hoc command runs and verbal-only tracking.
- Tradeoffs: Slightly more documentation work, but better repeatability and faster incident recovery.
- Affected paths: `docs/ai-kb/session-notes.md`, `docs/ai-kb/decision-log.md`, `docs/ai-kb/troubleshooting-log.md`, `docs/ai-kb/backlog.md`.
- Follow-up: Pin image to explicit release tag and add upgrade/rollback checklist for server operations.

## [2026-04-03] Pin production app image by digest

- Context: Runtime previously tracked floating `weishaw/sub2api:latest`, making upgrade results and rollback boundaries less deterministic.
- Decision: Pin production app image to verified digest `weishaw/sub2api@sha256:39b734d34623df70f08f869cb0177c90f5d75ebc1a4b3152be277becb1c41a5c` and keep backup compose file for rollback.
- Alternatives considered: Continue using `latest` and rely on manual inspection after each pull.
- Tradeoffs: Better reproducibility and safer rollback, with extra step required for each planned version upgrade.
- Affected paths: `/opt/sub2api-deploy/docker-compose.yml` (server runtime), `docs/ai-kb/*` (tracking).
- Follow-up: Add a small runbook that covers digest update, health checks, and rollback command sequence.

## Template

## [YYYY-MM-DD] Decision title

- Context:
- Decision:
- Alternatives considered:
- Tradeoffs:
- Affected paths:
- Follow-up:
