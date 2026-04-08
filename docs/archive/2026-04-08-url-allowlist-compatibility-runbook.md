> Archive reason: Production URL allowlist mode was adjusted and validated on 2026-04-08; this record preserves the compatibility decision and repeatable commands.

# URL Allowlist Compatibility Runbook

## Scope

- Target server: `43.153.150.195`
- Deploy directory: `/opt/sub2api-deploy`
- Compose file: `docker-compose.yml`
- Service: `sub2api`
- Scenario: Existing OpenAI proxy `base_url` entries (for example `https://fast.vpsairobot.com`) failed after enabling strict upstream allowlist.

## Incident Summary

- With `SECURITY_URL_ALLOWLIST_ENABLED=true`, upstream host validation is enforced.
- Existing account `base_url` host `fast.vpsairobot.com` was not in `SECURITY_URL_ALLOWLIST_UPSTREAM_HOSTS`, so requests were blocked.
- For current production usage, the chosen mode is:
  - `SECURITY_URL_ALLOWLIST_ENABLED=false`
  - `SECURITY_URL_ALLOWLIST_ALLOW_INSECURE_HTTP=false`
- This keeps HTTPS-only URL validation while disabling strict host allowlist enforcement.

## Applied Commands

```bash
cd /opt/sub2api-deploy
touch .env

grep -q '^SECURITY_URL_ALLOWLIST_ENABLED=' .env \
  && sed -i 's/^SECURITY_URL_ALLOWLIST_ENABLED=.*/SECURITY_URL_ALLOWLIST_ENABLED=false/' .env \
  || echo 'SECURITY_URL_ALLOWLIST_ENABLED=false' >> .env

grep -q '^SECURITY_URL_ALLOWLIST_ALLOW_INSECURE_HTTP=' .env \
  && sed -i 's/^SECURITY_URL_ALLOWLIST_ALLOW_INSECURE_HTTP=.*/SECURITY_URL_ALLOWLIST_ALLOW_INSECURE_HTTP=false/' .env \
  || echo 'SECURITY_URL_ALLOWLIST_ALLOW_INSECURE_HTTP=false' >> .env

docker compose -f docker-compose.yml up -d --force-recreate sub2api
docker compose -f docker-compose.yml config | grep -n 'SECURITY_URL_ALLOWLIST_'
docker exec sub2api env | grep '^SECURITY_URL_ALLOWLIST_'
docker compose -f docker-compose.yml logs --tail=120 sub2api | grep -E 'url_allowlist.enabled=false|Server started' || true
```

## Validation Snapshot

- `SECURITY_URL_ALLOWLIST_ENABLED: "false"` in `docker compose config`.
- `SECURITY_URL_ALLOWLIST_ENABLED=false` in container environment.
- `Server started on 0.0.0.0:8080` in runtime logs.
- `security.url_allowlist.enabled=false` warning is expected in this mode.

## Reminder Before Future Toggle

- Before changing `SECURITY_URL_ALLOWLIST_ENABLED` from `false` to `true`, first inventory all account-management `base_url` hosts and verify they are present in `SECURITY_URL_ALLOWLIST_UPSTREAM_HOSTS`.
- If host patterns are dynamic, evaluate wildcard coverage (for example `*.domain.com`) and rollout in a maintenance window.
