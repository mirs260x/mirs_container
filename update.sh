#!/usr/bin/env bash
set -euo pipefail

SETUP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DISTRO="${1:-humble}"

ENV_FILE="${SETUP_DIR}/.env"
if [ -f "${ENV_FILE}" ]; then
  set -a
  # shellcheck disable=SC1090
  . "${ENV_FILE}"
  set +a
  if [ -d "${MIRS_WORKSPACE}/src" ]; then
    vcs pull "${MIRS_WORKSPACE}/src"
  fi
fi

"${SETUP_DIR}/install.sh" "${DISTRO}"
