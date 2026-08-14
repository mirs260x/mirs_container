FROM osrf/ros:humble-desktop-full
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
		ros-humble-diagnostic-updater \
		python3-serial \
		ros-humble-realsense2-camera \
		ros-humble-realsense2-description \
		ros-humble-rtabmap \
		ros-humble-rtabmap-ros

ENV ROS_DISTRO=humble
ENV AMENT_PREFIX_PATH=/opt/ros/humble
ENV COLCON_PREFIX_PATH=/opt/ros/humble
ENV LD_LIBRARY_PATH=/opt/ros/humble/lib
ENV PATH=/opt/ros/humble/bin:$PATH
ENV PYTHONPATH=/opt/ros/humble/lib/python3.10/site-packages:$PYTHONPATH
ENV ROS_PYTHON_VERSION=3
ENV ROS_VERSION=2

ARG MIRS_UID=1000
ARG MIRS_GID=1000
ARG USERNAME=developer

RUN groupadd -g ${MIRS_GID} ${USERNAME} && \
    useradd -m -u ${MIRS_UID} -g ${MIRS_GID} -s /bin/bash ${USERNAME} && \
    usermod -aG dialout ${USERNAME} && \
		echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${USERNAME} && \
		chmod 0440 /etc/sudoers.d/${USERNAME}

USER ${USERNAME}
WORKDIR /home/${USERNAME}/ws


RUN echo "source /opt/ros/humble/setup.bash" >> /home/${USERNAME}/.bashrc && \
		echo "export RCUTILS_COLORIZED_OUTPUT=1" >> /home/${USERNAME}/.bashrc && \
    echo 'export PS0="\[\e[32m\]\u@mirs-sim\[\e[m\]:\[\e[34m\]\w\[\e[m\]\\$ "' >> /home/${USERNAME}/.bashrc && \
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
