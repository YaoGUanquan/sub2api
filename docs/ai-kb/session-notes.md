# Session Notes

## [2026-03-31] Bootstrap docs and skill routing

- Request: Create a docs structure, AI knowledge base, AGENTS guide, and project skills for intent-based execution.
- Actions taken: Created branch, added `AGENTS.md`, initialized four skills, added docs/plans/archive/ai-kb structure, updated `.gitignore` to track docs.
- Files touched: `.gitignore`, `AGENTS.md`, `docs/*`, `skills/*`.
- Tests run: Skill schema checks with `quick_validate.py` for all four skills.
- Open items: Commit and push this bootstrap branch.

## [2026-04-03] Production deployment status capture and upgrade guidance

- Request: Confirm whether official Docker image should be updated on Tokyo server 2 and keep this context in project KB for long-term tracking.
- Actions taken: Parsed server output, confirmed running image `weishaw/sub2api:latest`, identified `docker compose ps` failure caused by missing compose file in current working directory (`~`), reviewed repo deployment upgrade flow.
- Files touched: `docs/ai-kb/session-notes.md`, `docs/ai-kb/decision-log.md`, `docs/ai-kb/troubleshooting-log.md`, `docs/ai-kb/backlog.md`.
- Tests run: N/A (ops diagnosis and doc updates only).
- Open items: Locate actual deployment directory on server and execute a controlled image upgrade with pre/post checks.

### Update (same day)

- Deployment directory confirmed: `/opt/sub2api-deploy`.
- Compose file confirmed: only `docker-compose.yml` exists (no `docker-compose.local.yml` file on server).
- Interpretation: one-click script local-directory deployment was likely used, but compose file was saved as `docker-compose.yml`; operational commands should use that filename.

### Upgrade execution result (same day)

- Commands executed on server: `docker compose -f docker-compose.yml pull sub2api` and `docker compose -f docker-compose.yml up -d sub2api`.
- Current runtime status: `sub2api`, `postgres`, `redis` all healthy; application request log shows normal `200` response.
- Observation: `docker compose ps` still shows `sub2api` container `Created`/`Up` as 3 days, indicating no container recreation.
- Interpretation: pulled `latest` did not produce a changed image digest locally (or no newer digest was available at pull time).
- Evidence:
  - Local image inspect: `id=sha256:0e7121c9af90...`, `created=2026-03-30T08:12:40Z`, `digest=weishaw/sub2api@sha256:39b734d34623...`.
  - Running container inspect: `container_image_id=sha256:0e7121c9af90...`, `config_image=weishaw/sub2api:latest`.
  - Conclusion: running container image ID equals pulled local `latest` image ID.

### Hardening execution result (same day)

- Action: Backed up compose file and pinned app image from `weishaw/sub2api:latest` to `weishaw/sub2api@sha256:39b734d34623df70f08f869cb0177c90f5d75ebc1a4b3152be277becb1c41a5c`.
- Runtime change: `docker compose -f docker-compose.yml up -d sub2api` recreated `sub2api` container (new `Created` timestamp).
- Validation:
  - `docker inspect sub2api` shows `config_image=weishaw/sub2api@sha256:39b734d...`.
  - `docker compose -f docker-compose.yml ps` shows `sub2api` healthy with recent uptime.
  - `postgres` and `redis` remained healthy and unchanged.

## [2026-04-06] Standardize one-click production upgrade/rollback script

- Request: Provide a one-click production upgrade/rollback workflow that can be reused for every deployment.
- Actions taken: Added `deploy/docker-upgrade-digest.sh` with `upgrade` and `rollback` actions, then updated `deploy/README.md` with direct usage commands for digest-pinned deployments.
- Runtime validation evidence (operator session): `weishaw/sub2api:latest` pulled to digest `sha256:9d6039a...`, compose image pinned to `weishaw/sub2api@sha256:9d6039a...`, container recreated and healthy.
- Files touched: `deploy/docker-upgrade-digest.sh`, `deploy/README.md`, `docs/ai-kb/*`.
- Tests run: Local script syntax check (`bash -n`) planned in repo; production runtime check completed by operator via `docker compose ps` and `docker inspect`.
- Open items: Optionally publish a single remote install command that fetches this script from fork raw URL.

### Operator command set (2026-04-06 validated)

- Local sync script to server:
  - `scp ./deploy/docker-upgrade-digest.sh ubuntu@43.153.150.195:/opt/sub2api-deploy/`
- Server execute:
  - `cd /opt/sub2api-deploy`
  - `chmod +x docker-upgrade-digest.sh`
  - `./docker-upgrade-digest.sh upgrade`
  - `./docker-upgrade-digest.sh rollback` (if needed)
- Validation:
  - `docker compose -f docker-compose.yml ps`
  - `docker inspect sub2api --format '{{.Config.Image}}'`

### Archival reference

- Archived runbook: `docs/archive/2026-04-06-production-docker-upgrade-runbook.md`
- Archive rationale: Completed and validated ops runbook kept as stable reference.

## Template

## [YYYY-MM-DD] Session summary

- Request:
- Actions taken:
- Files touched:
- Tests run:
- Open items:
