FROM osrf/ros:jazzy-desktop-full
SHELL ["/bin/bash", "-c"]
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y \
    build-essential \
    cmake \
    git \
    sudo \
    vim \
    usbutils

ARG UID=1000
ARG GID=1000
ARG USERNAME=developer
ARG ROS_DOMAIN_ID=90

RUN deluser ubuntu && \
		groupadd -g ${GID} ${USERNAME} && \
    useradd -m -u ${UID} -g ${GID} -s /bin/bash ${USERNAME} && \
    usermod -aG dialout ${USERNAME} && \
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
    echo "alias mirs='ros2 launch mirs mirs_launch.py'" >> /home/${USERNAME}/.bashrc && \
    echo "alias slam='ros2 launch mirs slam_launch.py'" >> /home/${USERNAME}/.bashrc && \
    echo "alias nav='ros2 launch mirs nav_launch.py'" >> /home/${USERNAME}/.bashrc && \
    echo "alias bagrec='ros2 bag record /imu/data_raw /imu/mag /scan /odom /tf /tf_static /cmd_vel -o field_\$(date +%F_%H%M)'" >> /home/${USERNAME}/.bashrc && \
    echo "savemap() { ros2 run nav2_map_server map_saver_cli -f \"/home/${USERNAME}/ws/src/original/mirs/maps/\$1\" --ros-args -p map_subscribe_transient_local:=true -p save_map_timeout:=10.0; }" >> /home/${USERNAME}/.bashrc

CMD ["bash"]
