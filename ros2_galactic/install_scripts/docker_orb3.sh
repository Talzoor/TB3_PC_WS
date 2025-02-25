#!/bin/bash

RED="\e[31m"
GREEN="\e[32m"
LGREEN="\e[92m"
BLUE="\e[34m"
LBLUE="\e[94m"
WHITE="\e[97m"

BOLDGREEN="\e[1;${GREEN}"
BOLDRED="\e[1;${RED}"
BOLDWHITE="\e[1;${WHITE}"

ITALICRED="\e[3;${RED}"
ITALICREG="\e[3;"
ENDCOLOR="\e[0m"


SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
# echo "Script directory: $SCRIPT_DIR"
VAR_FILE_PATH=$SCRIPT_DIR/variables.sh
save_var_file () {
    rm -rf $VAR_FILE_PATH
    echo "#!/bin/bash" > $VAR_FILE_PATH
    echo "" >> $VAR_FILE_PATH
    printf "echo -e \"\\\n\t---Setting vars from 'variables.sh'---\"" >> $VAR_FILE_PATH
    echo "" >> $VAR_FILE_PATH
    echo "export ORB_DOCKER_CNAME=${ORB_DOCKER_CNAME_new}" >> $VAR_FILE_PATH
    echo "export ORB_DOCKER_VER=${ORB_DOCKER_VER_new}" >> $VAR_FILE_PATH
}

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

source $VAR_FILE_PATH

ORB_DOCKER_CNAME=$ORB_DOCKER_CNAME
ORB_DOCKER_VER=$ORB_DOCKER_VER

echo -e "${BOLDGREEN}\n ORB_DOCKER_CNAME=${BOLDWHITE}${ORB_DOCKER_CNAME}${ENDCOLOR} ${ENDCOLOR}"
echo -e "${BOLDGREEN} ORB_DOCKER_VER=${BOLDWHITE}${ORB_DOCKER_VER}${ENDCOLOR} ${ENDCOLOR}"
echo -e "${BOLDWHITE} \n\t\t\tChange it? [y/N] ${ENDCOLOR}:"

read -p "" ans
ans=${ans:-n}
declare -l ans_lower=${ans}
# echo -e "${BOLDGREEN} answer = ${ans_lower} ${ENDCOLOR}"

if [ $ans_lower = "n" ]; then
    echo -e "${BOLDGREEN} ${ENDCOLOR}"
else
    echo -e "${BOLDWHITE} ORB_DOCKER_CNAME : [CURRENT/new]${ENDCOLOR}"
    read -p "" ORB_DOCKER_CNAME_new
    ORB_DOCKER_CNAME_new=${ORB_DOCKER_CNAME_new:-$ORB_DOCKER_CNAME}
    
    echo -e "${BOLDWHITE} ORB_DOCKER_VER : (REPO:TAG) [CURRENT/new]${ENDCOLOR}"
    read -p "" ORB_DOCKER_VER_new
    ORB_DOCKER_VER_new=${ORB_DOCKER_VER_new:-$ORB_DOCKER_VER}
    
    save_var_file

    echo -e "${LGREEN} File 'variables.sh' was saved. Sourcing again. ${ENDCOLOR}"
    source $VAR_FILE_PATH
fi

sudo xhost +local:root
dockerVersion="talzzz/${ORB_DOCKER_VER}"
echo -e "${BOLDGREEN}\n Running container ${ENDCOLOR}(${BOLDWHITE}${dockerVersion}${ENDCOLOR}) --> ${LBLUE}${ORB_DOCKER_CNAME}${ENDCOLOR} \n${ENDCOLOR}"

echo -e "${BOLDGREEN}Docker VM instruction${ENDCOLOR}"
echo -e "${BOLDGREEN}‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾${ENDCOLOR}"
echo -e "${BOLDGREEN}${LBLUE}1.${ENDCOLOR} > . ~/catkin_ws/devel/setup.bash${ENDCOLOR}"
echo -e "${BOLDGREEN}${LBLUE}2.${ENDCOLOR} > roslaunch orb_slam3_ros_wrapper euroc_monoimu.launch (make sure you see ORB viewer)${ENDCOLOR}"
echo -e "${BOLDGREEN}${LBLUE}3.${ENDCOLOR} now run  (make sure you see ORB viewer)${ENDCOLOR}"
echo -e "${BOLDGREEN}running another inctance > sudo docker exec -it orb-3-container bash${ENDCOLOR}"
echo -e "${BOLDGREEN}\n${ENDCOLOR}"

#sudo docker run --privileged --name orb-3-container --rm -p 8087:8087 -e DISPLAY=$DISPLAY -e QT_X11_NO_MITSHM=1 -v /tmp/.X11-unix:/tmp/.X11-unix -v /dev:/dev:ro --gpus all -it ${dockerVersion}
# sudo docker run --privileged --name ${ORB_DOCKER_CNAME} --net=host --hostname dockerVM.${ORB_DOCKER_VER} -e DISPLAY=$DISPLAY -e QT_X11_NO_MITSHM=1 -v /tmp/.X11-unix:/tmp/.X11-unix -v /dev:/dev:ro --gpus all -it ${dockerVersion}
sudo docker run --privileged --name ${ORB_DOCKER_CNAME} --net=host -e DISPLAY=$DISPLAY -e QT_X11_NO_MITSHM=1 -v /tmp/.X11-unix:/tmp/.X11-unix -v /dev:/dev:ro --gpus all -it ${dockerVersion}

echo -e "\n${BOLDWHITE}\t\t\tDocker closed. commit to hub? [Y/n]\n${ENDCOLOR}"
read -p "" ans
ans=${ans:-y}
declare -l ans_lower=${ans}

if [ $ans_lower = "y" ]; then

    echo -e "\n${BOLDWHITE}\t\t\tChange TAG? [NO/new name lower]\n${ENDCOLOR}"
    echo -e "${BOLDWHITE}\t\t\tnew name lower, example: v24_11_11\n${ENDCOLOR}"

    read -p "" ans
    ans=${ans:-no}
    declare -l ans_lower=${ans}
    if [ $ans_lower = "no" ]; then
        echo ""
    else
        ORB_DOCKER_VER="orbslam3:${ans_lower}"
        ORB_DOCKER_VER_new=$ORB_DOCKER_VER
        save_var_file
    fi

    echo -e "${BOLDGREEN} Commiting, ${ENDCOLOR}"
    sudo docker commit $ORB_DOCKER_CNAME talzzz/$ORB_DOCKER_VER; sudo docker push talzzz/$ORB_DOCKER_VER

    echo -e "${BOLDGREEN} Removing container, ${ENDCOLOR}"
    sudo docker rm $ORB_DOCKER_CNAME
else
    echo -e "\n${BOLDWHITE}\t\t\tRemove container '${ORB_DOCKER_CNAME}' (docker rm)? [Y/n]\n${ENDCOLOR}"
    read -p "" ans
    ans=${ans:-y}
    declare -l ans_lower=${ans}

    if [ $ans_lower = "y" ]; then
        sudo docker rm $ORB_DOCKER_CNAME   
    fi
fi

echo -e "${BOLDGREEN} --- Script end ---${ENDCOLOR}"

# commit and push
# sudo docker login
# sudo docker ps    # will list all containers  
# sudo docker commit [container-name] talzzz/orbslam3:v24_mm_dd
# sudo docker push talzzz/orbslam3:v24_mm_dd

# OR - one liner:
# export ORB_DOCKER_NAME="orb-3-container"; export ORB_DOCKER_VER="orbslam3:v24_11_05"; sudo docker commit $ORB_DOCKER_NAME talzzz/$ORB_DOCKER_VER; sudo docker push talzzz/$ORB_DOCKER_VER