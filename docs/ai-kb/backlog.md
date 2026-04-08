# Backlog

## Priorities

## P0

- Keep `upstream/main` synced into local `main` on a regular cadence.
- Add explicit app endpoint smoke checks after each container recreation (health API + login/session flow).
- Reminder gate: Before toggling `SECURITY_URL_ALLOWLIST_ENABLED` from `false` to `true`, warn operator first, inventory all account `base_url` hosts, and verify host coverage in `SECURITY_URL_ALLOWLIST_UPSTREAM_HOSTS`.

## P1

- Add module-level architecture notes as implementation context grows.
- Add troubleshooting entries from first production-grade bugfix session.
- Evaluate whether PostgreSQL and Redis images also need controlled pinning cadence in production.
- Add a remote bootstrap command to install/update `docker-upgrade-digest.sh` directly on server from raw URL.
- Add a pre-upgrade check that verifies candidate version tags exist before attempting pull.

## P2

- Add optional automation scripts for docs/ai-kb entry generation.
