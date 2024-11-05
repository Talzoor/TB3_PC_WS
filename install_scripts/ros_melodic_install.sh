#!/bin/bash
# from http://wiki.ros.org/melodic/Installation/Ubuntu

ROS_VER="melodic"

sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'

sudo apt-get install curl # if you haven't already installed curl
curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -

sudo apt-get update

sudo apt-get install ros-melodic-desktop

isInFile=$(cat ~/.bashrc | grep -c "source /opt/ros/${ROS_VER}/setup.bash")
if [ $isInFile -eq 0 ]; then
    echo -e "\nAdding source to /.bashrc:"
    echo "source /opt/ros/${ROS_VER}/setup.bash" >> ~/.bashrc
fi

source ~/.bashrc

sudo apt-get install python-rosdep python-rosinstall python-rosinstall-generator python-wstool build-essential

sudo apt-get install python-rosdep

sudo rosdep init
rosdep update