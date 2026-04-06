#!/usr/bin/env bash
set -euo pipefail

SCRIPT_NAME="$(basename "$0")"
ACTION="${1:-upgrade}"
DEPLOY_DIR="${DEPLOY_DIR:-/opt/sub2api-deploy}"
COMPOSE_FILE_NAME="${COMPOSE_FILE_NAME:-docker-compose.yml}"
SERVICE_NAME="${SERVICE_NAME:-sub2api}"
IMAGE_REF="${IMAGE_REF:-weishaw/sub2api:latest}"
COMPOSE_FILE="${DEPLOY_DIR}/${COMPOSE_FILE_NAME}"

print_info() {
    echo "[INFO] $*"
}

print_error() {
    echo "[ERROR] $*" >&2
}

usage() {
    cat <<EOF
Usage:
  ${SCRIPT_NAME} upgrade
  ${SCRIPT_NAME} rollback [backup_file]

Environment overrides:
  DEPLOY_DIR          default: /opt/sub2api-deploy
  COMPOSE_FILE_NAME   default: docker-compose.yml
  SERVICE_NAME        default: sub2api
  IMAGE_REF           default: weishaw/sub2api:latest

Examples:
  ${SCRIPT_NAME} upgrade
  IMAGE_REF=weishaw/sub2api:v0.1.999 ${SCRIPT_NAME} upgrade
  ${SCRIPT_NAME} rollback
  ${SCRIPT_NAME} rollback /opt/sub2api-deploy/docker-compose.yml.bak-2026-04-06-120000
EOF
}

require_cmd() {
    local cmd="$1"
    if ! command -v "${cmd}" >/dev/null 2>&1; then
        print_error "Missing required command: ${cmd}"
        exit 1
    fi
}

compose() {
    docker compose -f "${COMPOSE_FILE}" "$@"
}

ensure_prerequisites() {
    require_cmd docker
    require_cmd awk
    require_cmd sed
    require_cmd cp
    require_cmd ls

    if ! docker compose version >/dev/null 2>&1; then
        print_error "docker compose plugin is not available."
        exit 1
    fi

    if [[ ! -d "${DEPLOY_DIR}" ]]; then
        print_error "Deployment directory does not exist: ${DEPLOY_DIR}"
        exit 1
    fi

    if [[ ! -f "${COMPOSE_FILE}" ]]; then
        print_error "Compose file does not exist: ${COMPOSE_FILE}"
        exit 1
    fi

    if ! grep -Eq '^[[:space:]]*image:[[:space:]]*weishaw/sub2api' "${COMPOSE_FILE}"; then
        print_error "No weishaw/sub2api image line found in ${COMPOSE_FILE}."
        exit 1
    fi
}

latest_backup_file() {
    local candidate
    candidate="$(ls -1t "${COMPOSE_FILE}".bak-* 2>/dev/null | head -n 1 || true)"
    echo "${candidate}"
}

running_image() {
    local container_id
    container_id="$(compose ps -q "${SERVICE_NAME}")"
    if [[ -z "${container_id}" ]]; then
        echo ""
        return
    fi
    docker inspect "${container_id}" --format '{{.Config.Image}}'
}

running_health() {
    local container_id
    container_id="$(compose ps -q "${SERVICE_NAME}")"
    if [[ -z "${container_id}" ]]; then
        echo "unknown"
        return
    fi
    docker inspect "${container_id}" --format '{{if .State.Health}}{{.State.Health.Status}}{{else}}none{{end}}'
}

upgrade() {
    local ts backup_file new_image current_image before_image after_image health_state

    ts="$(date +%F-%H%M%S)"
    backup_file="${COMPOSE_FILE}.bak-${ts}"

    print_info "Deployment dir: ${DEPLOY_DIR}"
    print_info "Compose file: ${COMPOSE_FILE}"
    print_info "Target image ref: ${IMAGE_REF}"

    before_image="$(running_image)"
    if [[ -n "${before_image}" ]]; then
        print_info "Current running image: ${before_image}"
    fi

    cp "${COMPOSE_FILE}" "${backup_file}"
    print_info "Backup created: ${backup_file}"

    print_info "Pulling image: ${IMAGE_REF}"
    docker pull "${IMAGE_REF}"

    new_image="$(docker inspect --format '{{index .RepoDigests 0}}' "${IMAGE_REF}" 2>/dev/null || true)"
    if [[ -z "${new_image}" ]]; then
        print_error "Failed to resolve digest from ${IMAGE_REF}."
        print_error "If you used a version tag, verify the tag exists on Docker Hub."
        exit 1
    fi
    print_info "Resolved digest image: ${new_image}"

    sed -i -E "0,/^([[:space:]]*image:[[:space:]]*)weishaw\/sub2api[^[:space:]]*/s||\1${new_image}|" "${COMPOSE_FILE}"
    current_image="$(awk '/^[[:space:]]*image:[[:space:]]*weishaw\/sub2api/ {print $2; exit}' "${COMPOSE_FILE}")"
    if [[ "${current_image}" != "${new_image}" ]]; then
        print_error "Compose image update failed. Expected ${new_image}, found ${current_image}."
        exit 1
    fi

    print_info "Applying compose changes..."
    compose up -d "${SERVICE_NAME}"

    after_image="$(running_image)"
    health_state="$(running_health)"
    compose ps "${SERVICE_NAME}"
    print_info "Running image after upgrade: ${after_image}"
    print_info "Health status: ${health_state}"
    print_info "Rollback command: ./${SCRIPT_NAME} rollback ${backup_file}"
}

rollback() {
    local requested_backup backup_file after_image health_state

    requested_backup="${2:-}"
    if [[ -n "${requested_backup}" ]]; then
        if [[ "${requested_backup}" == /* ]]; then
            backup_file="${requested_backup}"
        else
            backup_file="${DEPLOY_DIR}/${requested_backup}"
        fi
    else
        backup_file="$(latest_backup_file)"
    fi

    if [[ -z "${backup_file}" ]]; then
        print_error "No backup file found. Provide backup path explicitly."
        exit 1
    fi

    if [[ ! -f "${backup_file}" ]]; then
        print_error "Backup file does not exist: ${backup_file}"
        exit 1
    fi

    print_info "Restoring compose from backup: ${backup_file}"
    cp "${backup_file}" "${COMPOSE_FILE}"

    print_info "Recreating service from restored compose..."
    compose up -d "${SERVICE_NAME}"

    after_image="$(running_image)"
    health_state="$(running_health)"
    compose ps "${SERVICE_NAME}"
    print_info "Running image after rollback: ${after_image}"
    print_info "Health status: ${health_state}"
}

ensure_prerequisites

case "${ACTION}" in
    upgrade)
        upgrade
        ;;
    rollback)
        rollback "$@"
        ;;
    -h|--help|help)
        usage
        ;;
    *)
        print_error "Unknown action: ${ACTION}"
        usage
        exit 1
        ;;
esac
