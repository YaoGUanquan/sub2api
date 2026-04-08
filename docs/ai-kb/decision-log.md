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

## [2026-04-06] Adopt scripted digest-based Docker upgrades for production

- Context: Manual upgrade commands were repeated across sessions and release tag availability was not guaranteed (`v0.1.108` tag missing in Docker Hub image tags).
- Decision: Add a dedicated deployment script (`deploy/docker-upgrade-digest.sh`) to run backup, pull, digest resolution, compose rewrite, service recreation, and rollback in a consistent flow.
- Alternatives considered: Keep manual ad-hoc commands in chat only; rely on floating `latest` without digest pinning.
- Tradeoffs: Adds one script to maintain, but significantly reduces operator error and improves rollback speed and auditability.
- Affected paths: `deploy/docker-upgrade-digest.sh`, `deploy/README.md`, `docs/ai-kb/*`.
- Follow-up: Optionally expose a raw-download install snippet for servers that do not keep a full repo clone.

## [2026-04-06] Promote upgrade commands to AGENTS and archive runbook

- Context: Upgrade script was validated on production server, but command memory remained scattered across chat and notes.
- Decision: Record the validated command set in `AGENTS.md` and archive a dedicated runbook in `docs/archive/` for stable future reuse.
- Alternatives considered: Keep only session-level notes in `docs/ai-kb/session-notes.md`.
- Tradeoffs: Slight duplication between AGENTS and archive doc, but much faster operator onboarding and lower command drift risk.
- Affected paths: `AGENTS.md`, `docs/archive/2026-04-06-production-docker-upgrade-runbook.md`, `docs/ai-kb/session-notes.md`.
- Follow-up: Keep AGENTS and archive runbook aligned whenever script parameters or server path conventions change.

## [2026-04-08] Keep production URL allowlist in compatibility mode (`enabled=false`, HTTPS-only)

- Context: Existing account-management OpenAI proxy endpoint `https://fast.vpsairobot.com` worked before strict allowlist enforcement; after setting `SECURITY_URL_ALLOWLIST_ENABLED=true`, requests failed because upstream host allowlist checks became mandatory.
- Decision: Keep production runtime at `SECURITY_URL_ALLOWLIST_ENABLED=false` while preserving `SECURITY_URL_ALLOWLIST_ALLOW_INSECURE_HTTP=false` so URL format remains validated and only `https://` is accepted.
- Alternatives considered: Keep `enabled=true` and continuously extend `SECURITY_URL_ALLOWLIST_UPSTREAM_HOSTS` with every proxy host/path pattern.
- Tradeoffs: Better compatibility for heterogeneous proxy routing and less operational churn; reduced SSRF/domain restriction strength compared with strict allowlist mode.
- Affected paths: `/opt/sub2api-deploy/.env` (server runtime), `docs/archive/2026-04-08-url-allowlist-compatibility-runbook.md`, `docs/ai-kb/*`, `AGENTS.md`.
- Follow-up: If moving back to `enabled=true`, first inventory all account `base_url` hosts, pre-fill `SECURITY_URL_ALLOWLIST_UPSTREAM_HOSTS`, and announce compatibility risk before rollout.

## Template

## [YYYY-MM-DD] Decision title

- Context:
- Decision:
- Alternatives considered:
- Tradeoffs:
- Affected paths:
- Follow-up:
