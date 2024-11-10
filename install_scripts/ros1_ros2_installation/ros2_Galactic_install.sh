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

echo -e "${BOLDGREEN}\n---ROS2 (Galactic) installation---\n${ENDCOLOR}"

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

sudo apt-get install -y software-properties-common
sudo add-apt-repository universe

sudo apt-get update && sudo apt-get install -y curl
sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null

sudo apt-get update
sudo apt-get upgrade

echo -e "${BOLDGREEN}\nInstalling ROS base version:${ENDCOLOR}"

sudo apt-get install -y pip
sudo apt-get install -y ros-galactic-ros-base
sudo apt-get install -y python3-colcon-common-extensions
sudo apt-get install -y ros-galactic-turtlesim
sudo apt-get install -y ros-galactic-gazebo*
sudo apt-get install -y gh

# Adding auto complete to colcon
isInFile=$(cat ~/.bashrc | grep -c "source ~/.local/share/colcon_argcomplete/hook/colcon-argcomplete.bash")
if [ $isInFile -eq 0 ]; then
    echo -e "${BOLDGREEN}\nAdding source to /.bashrc:${ENDCOLOR}"
    echo "source ~/.local/share/colcon_argcomplete/hook/colcon-argcomplete.bash" >> ~/.bashrc
fi

echo -e "${BOLDGREEN}\nInstalling demo nodes (py and cpp):${ENDCOLOR}"

sudo apt-get install -y ros-galactic-demo-nodes-py ros-galactic-demo-nodes-cpp

isInFile=$(cat ~/.bashrc | grep -c "source /opt/ros/galactic/setup.bash")
if [ $isInFile -eq 0 ]; then
    echo -e "${BOLDGREEN}\nAdding source to /.bashrc:${ENDCOLOR}"
    echo "source /opt/ros/galactic/setup.bash" >> ~/.bashrc
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

# package to check on src/ dir:
#   image_transport_plugins
#   image_transport_tutorials
#   turtlebot3_simulations
#   web_video_server

echo -e "${LBLUE}\nIf 'ros2' return error message, source .bashrc or reopen terminal.${ENDCOLOR}"
echo -e "${LBLUE}\nLog in to github? (Type 'gh auth login')${ENDCOLOR}"
echo -e "\n"
