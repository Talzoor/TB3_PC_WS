#!/bin/bash
# from https://docs.ros.org/en/humble/Installation/Ubuntu-Install-Debians.html

RED="\e[31m"
GREEN="\e[32m"
BLUE="\e[34m"
LBLUE="\e[94m"
BOLDGREEN="\e[1;${GREEN}"
ITALICRED="\e[3;${RED}"
ITALICREG="\e[3;"
ENDCOLOR="\e[0m"

echo -e "${BOLDGREEN}\n---ROS1 (Noetic) installation---\n${ENDCOLOR}"

echo -e "${BOLDGREEN}\nSetting timezone\n${ENDCOLOR}"
sudo timedatectl set-timezone Asia/Jerusalem

sudo apt-get install -y ntpdate
sudo ntpdate time.windows.com

locale  # check for UTF-8

sudo apt-get update && sudo apt-get install -y locales
sudo locale-gen en_US en_US.UTF-8
sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
export LANG=en_US.UTF-8

locale  # verify settings

sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
sudo apt-get install -y curl # if you haven't already installed curl
curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -
sudo apt-get update

echo -e "${BOLDGREEN}\nInstalling ROS base version:${ENDCOLOR}"

#sudo apt-get install -y pip
sudo apt-get install -y ros-noetic-ros-base

sudo apt-get install -y gh

sudo apt-get install -y python3-rosdep python3-rosinstall python3-rosinstall-generator python3-wstool build-essential
sudo apt install python3-rosdep
sudo rosdep init
rosdep update

#echo -e "${BOLDGREEN}\nInstalling demo nodes (py and cpp):${ENDCOLOR}"
#sudo apt-get install -y ros-humble-demo-nodes-py ros-humble-demo-nodes-cpp

isInFile=$(cat ~/.bashrc | grep -c "source /opt/ros/noetic/setup.bash")
if [ $isInFile -eq 0 ]; then
    echo -e "${BOLDGREEN}\nAdding source to /.bashrc:${ENDCOLOR}"
    echo "source /opt/ros/noetic/setup.bash" >> ~/.bashrc
    echo "source ~/TB3_PC_WS/install/setup.bash" >> ~/.bashrc
fi

isInFile=$(cat ~/.bashrc | grep -c "export ROS_DOMAIN_ID")
if [ $isInFile -eq 0 ]; then
    echo -e "${BOLDGREEN}\nAdding ROS_DOMAIN_ID to /.bashrc:"
    echo "export ROS_DOMAIN_ID=5" >> ~/.bashrc
fi

isInFile=$(cat ~/.bashrc | grep -c "export TURTLEBOT3_MODEL")
if [ $isInFile -eq 0 ]; then
    echo -e "${BOLDGREEN}\nAdding TURTLEBOT3_MODEL to /.bashrc:${ENDCOLOR}"
    echo "export TURTLEBOT3_MODEL=burger" >> ~/.bashrc
fi

isInFile=$(cat ~/.bashrc | grep -c "export LDS_MODEL")
if [ $isInFile -eq 0 ]; then
    echo -e "${BOLDGREEN}\nAdding LDS_MODEL to /.bashrc:${ENDCOLOR}"
    echo "export LDS_MODEL=LDS-01" >> ~/.bashrc
fi

source ~/.bashrc

#   package to check on src/ dir:
#   image_transport_plugins
#   image_transport_tutorials
#   turtlebot3_simulations
#   web_video_server

echo -e "${LBLUE}\nIf 'roscore' return error message, source .bashrc or reopen terminal.${ENDCOLOR}"
echo -e "${LBLUE}\nLog in to github? (Type 'gh auth login')${ENDCOLOR}"
echo -e "\n"
