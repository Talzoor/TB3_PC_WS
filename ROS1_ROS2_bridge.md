<!-- https://github.com/Talzoor/TB3_PC_WS -->
# ![ROS](https://img.shields.io/badge/ros-%230A0FF9.svg?style=for-the-badge&logo=ros&logoColor=black)  TB3_PC_WS  ![ROS](https://img.shields.io/badge/ros-%230A0FF9.svg?style=for-the-badge&logo=ros&logoColor=black)

## Use bridge, Install, Run, Test - [URL](https://www.youtube.com/watch?v=uPN2pDWK6hQ)

### Install package (for ROS2)
```bash
sudo apt-get update
sudo apt-get install ros-galactic-ros1-bridge
```

### Run ROS2 bridge package: (for ROS1 used 'noetic')
```bash
source /opt/ros/galactic/setup.bash
ros2 run ros1_bridge dynamic_bridge --bridge-all-topics # use --help to see options
```

### Run ROS1 test topic
First terminal-
```bash
source /opt/ros/noetic/setup.bash
roscore
```

Second terminal-
```bash
source /opt/ros/noetic/setup.bash
rosrun roscpp_tutorials talker
```

### Listen with ROS2
```bash
source /opt/ros/galactic/setup.bash
ros2 topic list
ros2 topic echo /chatter
```



