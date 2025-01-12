#!/bin/bash

RED="\e[31m"
GREEN="\e[32m"
BLUE="\e[34m"
LBLUE="\e[94m"
WHITE="\e[97m"

BOLDGREEN="\e[1;${GREEN}"
ITALICRED="\e[3;${RED}"
ITALICREG="\e[3;"
BOLDWHITE="\e[1;${WHITE}"
ENDCOLOR="\e[0m"

declare -a arr=("ROS_PACKAGE_PATH" 
                "ROS_ROOT" 
                "element3"
                "element4"
                )

echo -e "${BOLDWHITE}\n---Removing env variables---${ENDCOLOR}"
echo -e "${BOLDGREEN}\nList to unset:${ENDCOLOR}"

## now loop through the above array
for i in "${arr[@]}"
do
    echo -e "${RED}$i${ENDCOLOR}"
    unset "$i"
done

echo -e "${BOLDGREEN}\nDone.\n${ENDCOLOR}"
