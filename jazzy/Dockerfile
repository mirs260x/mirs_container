FROM osrf/ros:jazzy-desktop-full AS base
SHELL ["/bin/bash", "-c"]
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y \
    build-essential \
    cmake \
    git \
    sudo \
    python3-vcstool \
    vim \
    usbutils \
    x11-apps \
    libcanberra-gtk-module \
    libcanberra-gtk3-module \
    python3-pip \
    ros-jazzy-rmw-cyclonedds-cpp \
    ros-jazzy-nav2-bringup \
    ros-jazzy-navigation2 && \
    pip3 install --no-cache-dir --break-system-packages dbus-fast bleak

ARG MIRS_UID=1000
ARG MIRS_GID=1000
ARG USERNAME=developer
ARG ROS_DOMAIN_ID=90

RUN if id ubuntu >/dev/null 2>&1; then userdel -r ubuntu; fi && \
	groupadd -g ${MIRS_GID} ${USERNAME} && \
    useradd -m -u ${MIRS_UID} -g ${MIRS_GID} -s /bin/bash ${USERNAME} && \
		echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${USERNAME} && \
		chmod 0440 /etc/sudoers.d/${USERNAME}

USER ${USERNAME}
WORKDIR /home/${USERNAME}/ws

RUN echo "source /opt/ros/jazzy/setup.bash" >> /home/${USERNAME}/.bashrc && \
	echo "export ROS_DOMAIN_ID=${ROS_DOMAIN_ID}" >> ~/.bashrc && \
 	echo "[ -f install/setup.bash ] && source install/setup.bash" >> /home/${USERNAME}/.bashrc && \
    echo 'export PS1="\[\e[32m\]\u@mirs-sim\[\e[m\]:\[\e[34m\]\w\[\e[m\]\\$ "' >> /home/${USERNAME}/.bashrc && \
		echo "export RCUTILS_COLORIZED_OUTPUT=1" >> /home/${USERNAME}/.bashrc && \
    echo "alias cb='colcon build --symlink-install'" >> /home/${USERNAME}/.bashrc && \
    echo "alias cbs='colcon build --symlink-install --packages-select'" >> /home/${USERNAME}/.bashrc && \
    echo "alias cbt='colcon build --symlink-install --packages-up-to'" >> /home/${USERNAME}/.bashrc && \
    echo "alias ru='rosdep update'" >> /home/${USERNAME}/.bashrc && \
    echo "alias ri='rosdep install --from-path src --ignore-src -r -y'" >> /home/${USERNAME}/.bashrc && \
    echo "alias si='source install/setup.bash'" >> /home/${USERNAME}/.bashrc && \
    echo "alias mirs='ros2 launch mirs mirs.launch.py'" >> /home/${USERNAME}/.bashrc && \
    echo "alias slam='ros2 launch mirs slam.launch.py'" >> /home/${USERNAME}/.bashrc && \
    echo "alias nav='ros2 launch mirs nav.launch.py'" >> /home/${USERNAME}/.bashrc

CMD ["bash"]

# ---------------------------------------------------------------------------
# coverage: カバレージ走行用依存 (opennav_coverage + Fields2Cover v2) を焼き込み。
# wsは実行時にマウントされるため、ここでは /opt/deps に独立wsとしてビルドする。
# 実行時は /opt/ros -> /opt/deps -> ~/ws/install の順でsourceされる。
# バージョン固定はARGで上書き可:
#   docker compose build --build-arg OPENNAV_BRANCH=xxx --build-arg F2C_TAG=yyy coverage
# ---------------------------------------------------------------------------
FROM base AS coverage

ARG USERNAME=developer
ARG OPENNAV_BRANCH=jazzy-v2
ARG F2C_TAG=v2.0.0

USER root
RUN mkdir -p /opt/deps/src && \
    cd /opt/deps/src && \
    git clone -b ${OPENNAV_BRANCH} https://github.com/open-navigation/opennav_coverage.git && \
    git clone -b ${F2C_TAG} https://github.com/Fields2Cover/Fields2Cover.git && \
    . /opt/ros/jazzy/setup.sh && \
    rosdep update && \
    rosdep install --from-paths /opt/deps/src --ignore-src -r -y && \
    colcon build --base-paths /opt/deps/src \
        --build-base /opt/deps/build --install-base /opt/deps/install && \
    rm -rf /opt/deps/src /opt/deps/build /opt/deps/log /root/.ros

USER ${USERNAME}
# source順を ros -> deps -> ws に整える (既存のws行を一旦除去して付け直す)
RUN sed -i '/install\/setup.bash/d' /home/${USERNAME}/.bashrc && \
    echo "[ -f /opt/deps/install/setup.bash ] && source /opt/deps/install/setup.bash" >> /home/${USERNAME}/.bashrc && \
    echo "[ -f install/setup.bash ] && source install/setup.bash" >> /home/${USERNAME}/.bashrc
