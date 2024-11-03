#!/bin/bash

RED="\e[31m"
GREEN="\e[32m"
BLUE="\e[34m"
LBLUE="\e[94m"
WHITE="\e[97m"

BOLDGREEN="\e[1;${GREEN}"
BOLDRED="\e[1;${RED}"
BOLDWHITE="\e[1;${WHITE}"

ITALICRED="\e[3;${RED}"
ITALICREG="\e[3;"
ENDCOLOR="\e[0m"

echo -e "${BOLDGREEN}\n--- Docker installation ---${ENDCOLOR}"
echo -e "${BOLDGREEN}\n docker.hub url = ${ENDCOLOR}https://hub.docker.com/repository/docker/talzzz/orbslam3/general \n${ENDCOLOR}"
sudo apt-get install -y docker.io


filePath=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg
if [ ! -f $filePath ]; then
    echo -e "${BOLDGREEN}\n file ..keyring.gpg does not exist. ${ENDCOLOR}"
    echo -e "${BOLDGREEN}\n--- NVIDIA Container Toolkit packages ---${ENDCOLOR}"
    curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg
    curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
    sudo apt-get update
    sudo apt-get install -y nvidia-container-toolkit
    sudo nvidia-ctk runtime configure --runtime=docker
    sudo systemctl restart docker
fi



sudo xhost +local:root
dockerVersion="talzzz/orbslam3:v24_10_27_working"
echo -e "${BOLDGREEN}\n Running container ${ENDCOLOR}(${BOLDWHITE}${dockerVersion}${ENDCOLOR}) \n${ENDCOLOR}"

echo -e "${BOLDGREEN}Docker VM instruction${ENDCOLOR}"
echo -e "${BOLDGREEN}1. > . ~/catkin_ws/devel/setup.bash${ENDCOLOR}"
echo -e "${BOLDGREEN}2. > roslaunch orb_slam3_ros_wrapper euroc_monoimu.launch (make sure you see ORB viewer)${ENDCOLOR}"
echo -e "${BOLDGREEN}3. now run  (make sure you see ORB viewer)${ENDCOLOR}"
echo -e "${BOLDGREEN}running another inctance > sudo docker exec -it orb-3-container bash${ENDCOLOR}"

#sudo docker run --privileged --name orb-3-container --rm -p 8087:8087 -e DISPLAY=$DISPLAY -e QT_X11_NO_MITSHM=1 -v /tmp/.X11-unix:/tmp/.X11-unix -v /dev:/dev:ro --gpus all -it ${dockerVersion}
sudo docker run --privileged --name orb-3-container --rm --net=host -e DISPLAY=$DISPLAY -e QT_X11_NO_MITSHM=1 -v /tmp/.X11-unix:/tmp/.X11-unix -v /dev:/dev:ro --gpus all -it ${dockerVersion}

# commit and push
# sudo docker login
# sudo docker ps    # will list all containers  
# sudo docker commit [container-name] talzzz/orbslam3:v24_mm_dd
# sudo docker push talzzz/orbslam3:v24_mm_dd