# mirs_container

MIRS 260x 用 ROS 2 Docker 開発環境です。ROS 2 のバージョン、依存パッケージ、ビルドツールをコンテナにまとめます。

## 対応環境

| ROS 2 | Compose ファイル | コンテナ内ワークスペース |
|---|---|---|
| Humble | `humble/docker-compose.yml` | `/home/developer/mirsws` |
| Jazzy | `jazzy/docker-compose.yml` | `/home/developer/ws` |

## クローン
```bash
# ワークスペース直下に置いてね
cd your_path/mirs_workspace/
git clone https://github.com/mirs260x/mirs_container.git
```

## GUI

RViz や rqt を使う Linux 環境では、起動前に X11 転送を許可します。
Windows の場合はやらなくて OK です。

```bash
xhost +local:
```

### Compose ファイルのディレクトリへ移動

```bash
cd mirs_workspace/mirs_container/jazzy
```

### コンテナを起動

```bash
# docker イメージのビルド
docker compose build
# コンテナ起動
docker compose up -d
# コンテナの中に入る
docker compose exec ros bash
```

## USB デバイスと権限
USBの権限がコンテナ内のユーザーに降りてこない場合の対処

```bash
docker compose exec -u root ros bash
```

## 終了

```bash
docker compose down
xhost -local:
```


---
## ソースコードの編集

ホストマシンの `src/` はコンテナ内にマウントされているため、ホストで編集した内容は起動中のコンテナに即座に反映されます。

### エイリアス

コンテナ内では以下のエイリアスが使用できます。

| エイリアス | 実体 | 説明 |
|---|---|---|
| `ru`  | `rosdep update` | rosdep の更新 |
| `ri`  | `rosdep install --from-path src --ignore-src -r -y` | 依存パッケージのインストール |
| `cb`  | `colcon build --symlink-install` | 全パッケージをビルド|
| `cbs` | `colcon build --symlink-install --packages-select` | 指定パッケージのみビルド |
| `cbt` | `colcon build --symlink-install --packages-up-to` | 依存関係込みでビルド |
| `si`  | `source install/setup.bash` | ビルド結果を読み込み |
| `mirs`| `ros2 launch mirs mirs.launch.py` | システム起動 |
| `slam`| `ros2 launch mirs slam.launch.py` | マップ作成 |
| `nav` | `ros2 launch mirs nav.launch.py` | 自律走行 |

```bash
# .bashrcに記述済み
source /opt/ros/jazzy/setup.bash
```

ROS 2 パッケージのビルド・起動方法は [mirs](https://github.com/mirs260x/mirs) を参照してください。




Docker を使う場合はコンテナ内でエイリアスを使うことができます。
以下はコンテナ内で実行します。

```bash
cd /home/developer/ws
ru # rosdep update の意
ri # rosdep install --from-path src --ignore -r -y の意
cb # colcon build --symlink-install の意
si # source install/setup.bash の意
```
#### ビルド

次にソースコードをビルドします。これによってインストールするパッケージやソフトウェアのバージョンが統一されます。

```bash
# rosdepの更新
ru
# 依存パッケージのインストール
ri
# 全パッケージのビルド
cb
# ビルド結果の読み込み
si
```


Docker を使うとき、特定のパッケージだけをビルドする場合

```bash
cbs mirs
cbs mapping_3d
```

## 起動

ESP32、LiDAR などの機器を接続してから、コンテナ内で実行します。
機器の接続はコンテナの起動前に行ってください。また、Docker から外部のセンサやマイコンを認識できないことがあります。大抵、権限問題ですからコンテナ内で `/dev/ttyUSB*` を chmod してください。

Docker を使っている場合はエイリアスを使うことができます。

```bash
mirs   # 車体制御、LiDAR など基本構成
slam   # SLAM 構成
nav    # Navigation 構成
```


## ソースコードの編集

ホストマシンの `src/` はコンテナ内にマウントされているため、ホストで編集した内容は起動中のコンテナに即座に反映されます。

## 停止・終了

Docker を使っている場合

```bash
exit
docker compose down
xhost -local:
```

## エイリアス

コンテナ内では以下のエイリアスが使用できます。

| エイリアス | 実体 | 説明 |
|---|---|---|
| `ru`  | `rosdep update` | rosdep の更新 |
| `ri`  | `rosdep install --from-path src --ignore-src -r -y` | 依存パッケージのインストール |
| `cb`  | `colcon build --symlink-install` | 全パッケージをビルド |
| `cbs` | `colcon build --symlink-install --packages-select` | 指定パッケージのみビルド |
| `cbt` | `colcon build --symlink-install --packages-up-to` | 依存関係込みでビルド |
| `si`  | `source install/setup.bash` | ビルド結果を読み込み |
| `mirs`| `ros2 launch mirs mirs.launch.py` | システム起動 |
| `slam`| `ros2 launch mirs slam.launch.py` | マップ作成 |
| `nav` | `ros2 launch mirs nav.launch.py` | 自律走行 |
