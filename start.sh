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
  echo "先に ./install.sh ${DISTRO} を実行してください。" >&2
  exit 1
fi

if [ "${MIRS_XHOST:-0}" = "1" ] && command -v xhost >/dev/null 2>&1 && [ -n "${DISPLAY:-}" ]; then
  echo "GUI転送を許可します。終了後は xhost -local: を実行してください。"
  xhost +local:
fi

docker compose --env-file "${ENV_FILE}" -f "${COMPOSE_FILE}" up -d
docker compose --env-file "${ENV_FILE}" -f "${COMPOSE_FILE}" exec ros bash
