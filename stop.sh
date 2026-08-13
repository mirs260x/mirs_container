#!/usr/bin/env bash
set -euo pipefail

SETUP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DISTRO="${1:-humble}"
ENV_FILE="${SETUP_DIR}/.env"
COMPOSE_FILE="${SETUP_DIR}/docker/${DISTRO}/docker-compose.yml"

case "${DISTRO}" in
  humble|jazzy) ;;
  *) echo "使い方: $0 [humble|jazzy]" >&2; exit 2 ;;
esac

if [ ! -f "${ENV_FILE}" ]; then
  echo "起動済みの環境設定がありません。" >&2
  exit 1
fi

docker compose --env-file "${ENV_FILE}" -f "${COMPOSE_FILE}" down
