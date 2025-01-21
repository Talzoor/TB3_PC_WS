#!/bin/bash
# from https://docs.ros.org/en/humble/Installation/Ubuntu-Install-Debians.html

# package to check on src/ dir:
#   image_transport_plugins
#   image_transport_tutorials
#   turtlebot3_simulations
#   web_video_server

RED="\e[31m"
GREEN="\e[32m"
BLUE="\e[34m"
LBLUE="\e[94m"
BOLDGREEN="\e[1;${GREEN}"
BOLDRED="\e[1;${RED}"
ITALICRED="\e[3;${RED}"
ITALICREG="\e[3;"
ENDCOLOR="\e[0m"

echo -e "${BOLDGREEN}\n---ROS2 packages installation---\n${ENDCOLOR}"

dirMainPath=~/TB3_PC_WS

if [ ! -d $dirMainPath ]; then
    echo -e "${BOLDRED}\n Dir ${dirPath} does not exist! quitting script!\n${ENDCOLOR}"
    exit 1;
fi

echo -e "${BOLDGREEN}\n Installing Gazebo ${ENDCOLOR}"
sudo apt-get install -y ros-humble-gazebo* 
sudo apt-get install -y ros-humble-cartographer ros-humble-cartographer-ros

echo -e "${BOLDGREEN}\n Installing turtlebot3 pkgs ${ENDCOLOR}"
source ~/.bashrc
sudo apt-get install -y ros-humble-dynamixel-sdk ros-humble-turtlebot3-msgs ros-humble-turtlebot3

echo -e "${BOLDGREEN}\n Installing rviz ${ENDCOLOR}"
sudo apt-get install -y rviz


dirPath=${dirMainPath}/src/turtlebot3_simulations-humble-devel
if [ ! -d $dirPath ]; then
    echo -e "${BOLDGREEN}\n Downloading TB3 Simulation ${ENDCOLOR}"
    cd $dirPath
    wget https://github.com/ROBOTIS-GIT/turtlebot3_simulations/archive/humble-devel.zip
    unzip humble-devel.zip
    rm -rf humble-devel.zip
fi

echo -e "${BOLDGREEN}\n --- Building (colcon) --- ${ENDCOLOR}"
dirPath=${dirMainPath}
cd $dirPath
colcon build --symlink-install

source ~/.bashrc
#echo -e "${BOLDGREEN}\n${ENDCOLOR}"
echo -e "${LBLUE}\nIf 'ros2' return error message, source .bashrc or reopen terminal.${ENDCOLOR}"

