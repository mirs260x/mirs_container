# AGENTS.md — mirs_container

ROS 2開発コンテナ（humble / jazzy）定義。

## ブランチ運用

- `main` / `develop` 直commit・直push禁止。`feature/*` → `develop` → `main` のPRのみ
- 1コミット1話題

## 検証

```bash
cd jazzy   # または humble
docker compose build               # ros サービス (baseステージ)
docker compose --profile coverage build   # coverage サービス (依存焼き込み)
```

## 注意

- aptパッケージ追加時は `Dockerfile` の一覧を更新する
- coverage用依存 (opennav_coverage + Fields2Cover v2) は `coverage`
  ステージで `/opt/deps` に焼き込む。ws側へのcloneは不要。
  バージョン固定はbuild args (`OPENNAV_BRANCH`, `F2C_TAG`) で上書き可
- 起動: 通常は `docker compose up -d`、カバレージ用は
  `docker compose --profile coverage up -d coverage`
