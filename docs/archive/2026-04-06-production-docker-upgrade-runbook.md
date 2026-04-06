> Archive reason: This runbook was validated in production on 2026-04-06 and is archived as a stable, reusable ops reference.

# Production Docker Upgrade Runbook (Digest Pinning)

## Scope

- Target server: `43.153.150.195`
- Deploy directory: `/opt/sub2api-deploy`
- Compose file: `docker-compose.yml`
- Service: `sub2api`
- Script: `docker-upgrade-digest.sh`

## 1) Sync script to server

Run from local repo root (`d:/codes/ph-shub2api`):

```bash
scp ./deploy/docker-upgrade-digest.sh ubuntu@43.153.150.195:/opt/sub2api-deploy/
```

## 2) Execute one-click upgrade

Run on server:

```bash
cd /opt/sub2api-deploy
chmod +x docker-upgrade-digest.sh
./docker-upgrade-digest.sh upgrade
```

## 3) Validate runtime status

```bash
docker compose -f docker-compose.yml ps
docker inspect sub2api --format '{{.Config.Image}}'
docker compose -f docker-compose.yml logs --tail=80 sub2api
```

## 4) Rollback if needed

```bash
cd /opt/sub2api-deploy
./docker-upgrade-digest.sh rollback
```

Or rollback to a specific backup:

```bash
./docker-upgrade-digest.sh rollback /opt/sub2api-deploy/docker-compose.yml.bak-YYYY-MM-DD-HHMMSS
```

## 5) Known caveat

- If `docker pull weishaw/sub2api:vX.Y.Z` returns `manifest unknown`, use default `latest` flow:
  - `./docker-upgrade-digest.sh upgrade`
  - The script will still pin to immutable digest after pull.
