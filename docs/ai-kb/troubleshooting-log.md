# Troubleshooting Log

## [2026-04-03] `docker compose ps` returns `no configuration file provided`

- Symptom: Running `docker compose ps` on server returned `no configuration file provided: not found`.
- Reproduction: SSH into server, stay in `~`, execute `docker compose ps` without `-f` and without compose file in current directory.
- Root cause: Compose command was run from a non-deployment directory, so Docker Compose could not discover `docker-compose.yml` / `docker-compose.local.yml`.
- Fix: Run from the deployment directory or specify file path explicitly, for example `docker compose -f docker-compose.local.yml ps`.
- Validation: `docker inspect --format '{{.Config.Image}}' sub2api` returned `weishaw/sub2api:latest`; next validation step is successful `docker compose ... ps` in correct directory.
- Related commit or branch: `feature/project-bootstrap-docs-skills` (knowledge-base update only).

## [2026-04-03] `docker compose -f docker-compose.local.yml ps` returns file not found

- Symptom: In `/opt/sub2api-deploy`, command returned `open /opt/sub2api-deploy/docker-compose.local.yml: no such file or directory`.
- Reproduction: `cd /opt/sub2api-deploy && docker compose -f docker-compose.local.yml ps`.
- Root cause: The server deployment contains `docker-compose.yml` only; local variant content was saved under default filename.
- Fix: Use `docker compose -f docker-compose.yml ...` (or run `docker compose ...` directly in `/opt/sub2api-deploy`).
- Validation: `find` output shows `/opt/sub2api-deploy/docker-compose.yml` exists; `ll` confirms no `docker-compose.local.yml`.
- Related commit or branch: `feature/project-bootstrap-docs-skills` (knowledge-base update only).

## [2026-04-03] Pulled `latest` but no visible service version change

- Symptom: `docker compose pull sub2api` succeeded, but `docker compose ps` still showed container age as 3 days and service was not recreated.
- Reproduction: In `/opt/sub2api-deploy`, run `docker compose -f docker-compose.yml pull sub2api` then `up -d sub2api`.
- Root cause: `latest` is mutable; if pulled digest equals current local digest, Compose keeps existing container/image state and does not recreate.
- Fix: Verify image ID/digest explicitly, and pin production image to explicit release tag instead of floating `latest`.
- Validation:
  - Service remained healthy; application log returned `200`, but recreation indicator (`Created`) unchanged.
  - Local image: `sha256:0e7121c9af90...` with repo digest `sha256:39b734d34623...`.
  - Running container image ID: `sha256:0e7121c9af90...` (matches local pulled image).
- Related commit or branch: `feature/project-bootstrap-docs-skills` (knowledge-base update only).

## [2026-04-03] Digest pinning and forced deterministic deployment

- Symptom: Need deterministic production runtime version and explicit rollback anchor.
- Reproduction: Backup compose, replace image with digest, run `docker compose -f docker-compose.yml up -d sub2api`.
- Root cause: Floating tags (`latest`) are mutable and hide exact runtime artifact identity.
- Fix: Pin to verified digest and redeploy the service.
- Validation:
  - `sub2api` container recreated and became healthy.
  - `docker inspect sub2api` shows `config_image=weishaw/sub2api@sha256:39b734d...`.
  - `docker compose ps` shows `sub2api` healthy with recent `Created/Up` time.
- Related commit or branch: `feature/project-bootstrap-docs-skills` (knowledge-base update only).

## [2026-04-06] `manifest unknown` when pulling version tag from Docker Hub

- Symptom: `docker pull weishaw/sub2api:v0.1.108` failed with `manifest unknown`.
- Reproduction: In `/opt/sub2api-deploy`, run `docker pull weishaw/sub2api:v0.1.108` then inspect digest.
- Root cause: Upstream Git release version and Docker Hub tag publication cadence were not aligned; specific version tag did not exist in Docker Hub.
- Fix: Pull `weishaw/sub2api:latest`, resolve digest via `docker inspect ... RepoDigests`, then pin compose image to digest and redeploy.
- Validation:
  - Pull returned digest `sha256:9d6039a3339a...`.
  - `docker compose -f docker-compose.yml up -d sub2api` recreated the container successfully.
  - `docker compose ps` and `docker inspect sub2api` confirmed running `weishaw/sub2api@sha256:9d6039a3339a...`.
- Related commit or branch: `feature/project-bootstrap-docs-skills` (deployment script + KB updates).

## Template

## [YYYY-MM-DD] Issue title

- Symptom:
- Reproduction:
- Root cause:
- Fix:
- Validation:
- Related commit or branch:
