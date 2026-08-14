# mirs_container

MIRS 260x 用の ROS 2 Docker 開発環境です。このREADMEでは、コンテナの操作とコンテナ内エイリアスだけを説明します。

RViz や rqt を使うネイティブLinux環境では、起動前にX11転送を許可します。
```bash
xhost +local:
```

## 起動

```bash
# git cloneはワークスペース直下で
cd mirs_workspace
git clone https://github.com/mirs260x/mirs_container.git
# 起動時には目的のディストリビューションのディレクトリに入ってください。
cd mirs_workspace/mirs_container/jazzy
# イメージのビルド
docker compose build
# コンテナの立ち上げ
docker compose up -d
# コンテナの中に入る
docker compose exec ros bash
```

## コンテナ内エイリアス

| エイリアス | 実体 |
|---|---|
| `ru` | `rosdep update` |
| `ri` | `rosdep install --from-path src --ignore-src -r -y` |
| `cb` | `colcon build --symlink-install` |
| `cbs` | `colcon build --symlink-install --packages-select` |
| `cbt` | `colcon build --symlink-install --packages-up-to` |
| `si` | `source install/setup.bash` |
| `mirs` | `ros2 launch mirs mirs.launch.py` |
| `slam` | `ros2 launch mirs slam.launch.py` |
| `nav` | `ros2 launch mirs nav.launch.py` |


ROS 2パッケージの使い方は [mirs](https://github.com/mirs260x/mirs) を参照してください。

## 終了

```bash
# コンテナから出る
exit
# コンテナを終了、削除
docker compose down
xhost -local:
```