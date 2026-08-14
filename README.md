# mirs_container

MIRS 260x 用の ROS 2 Docker 開発環境です。このREADMEでは、コンテナの操作とコンテナ内エイリアスだけを説明します。

## 起動

```bash
cd mirs_workspace/mirs_container/jazzy
docker compose build
docker compose up -d
docker compose exec ros bash
```

RViz や rqt を使うLinux環境では、起動前にX11転送を許可します。

```bash
xhost +local:
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

```bash
cd /home/developer/ws
ru
ri
cb
si
mirs
```

ROS 2パッケージの使い方は [mirs](https://github.com/mirs260x/mirs) を参照してください。

## 終了

```bash
exit
docker compose down
xhost -local:
```
