# Backlog

## Priorities

## P0

- Keep `upstream/main` synced into local `main` on a regular cadence.
- Add a production runbook section for digest-based upgrades and rollback (`docker-compose.yml` path variant).
- Add explicit app endpoint smoke checks after each container recreation (health API + login/session flow).

## P1

- Add module-level architecture notes as implementation context grows.
- Add troubleshooting entries from first production-grade bugfix session.
- Add a concise upgrade/rollback runbook for production Docker operations.
- Evaluate whether PostgreSQL and Redis images also need controlled pinning cadence in production.

## P2

- Add optional automation scripts for docs/ai-kb entry generation.
