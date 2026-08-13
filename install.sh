#!/usr/bin/env bash
set -euo pipefail

SETUP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DISTRO="${1:-humble}"
WORKSPACE_DIR="${MIRS_WORKSPACE:-${SETUP_DIR}/../mirs260x_workspace}"
ENV_FILE="${SETUP_DIR}/.env"
COMPOSE_FILE="${SETUP_DIR}/docker/${DISTRO}/docker-compose.yml"
REPOS_FILE="${SETUP_DIR}/repos/${DISTRO}.repos"

case "${DISTRO}" in
  humble|jazzy) ;;
  *) echo "使い方: $0 [humble|jazzy]" >&2; exit 2 ;;
esac

for command_name in docker git vcs; do
  if ! command -v "${command_name}" >/dev/null 2>&1; then
    echo "必要なコマンドがありません: ${command_name}" >&2
    echo "Ubuntuでは例として次を実行してください: sudo apt install docker.io docker-compose-v2 git python3-vcstool" >&2
    exit 1
  fi
done

if ! docker compose version >/dev/null 2>&1; then
  echo "Docker Compose v2 が必要です。" >&2
  exit 1
fi

mkdir -p "${WORKSPACE_DIR}/src"

if [ -n "$(find "${WORKSPACE_DIR}/src" -mindepth 1 -maxdepth 1 -type d -print -quit)" ]; then
  echo "既存のsrcを更新します。不要なファイルは削除しません。"
fi
vcs import "${WORKSPACE_DIR}/src" < "${REPOS_FILE}"

cat > "${ENV_FILE}" <<EOF
MIRS_WORKSPACE=${WORKSPACE_DIR}
MIRS_UID=$(id -u)
MIRS_GID=$(id -g)
ROS_DISTRO=${DISTRO}
EOF

docker compose --env-file "${ENV_FILE}" -f "${COMPOSE_FILE}" build
docker compose --env-file "${ENV_FILE}" -f "${COMPOSE_FILE}" up -d

docker compose --env-file "${ENV_FILE}" -f "${COMPOSE_FILE}" exec ros bash -lc \
  "source /opt/ros/${DISTRO}/setup.bash && rosdep update && sudo rosdep install --from-paths src --ignore-src -r -y && colcon build --symlink-install"

echo
echo "構築が完了しました。コンテナへ入るには次を実行してください。"
echo "  ./start.sh ${DISTRO}"
