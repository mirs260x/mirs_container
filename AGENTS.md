# AGENTS.md — mirs_container

ROS 2開発コンテナ（humble / jazzy）定義。

## ブランチ運用

- `main` / `develop` 直commit・直push禁止。`feature/*` → `develop` → `main` のPRのみ
- 1コミット1話題

## 検証

```bash
cd jazzy   # または humble
docker compose build
```

## 注意

- aptパッケージ追加時は `Dockerfile` の一覧を更新する（現状: `ros-jazzy-fields2cover` まで導入済み）
- opennav_coverageはソース導入（jazzy-v2ブランチ）。手順は `coverage` パッケージのDESIGN.md参照
