<!-- https://github.com/Talzoor/TB3_PC_WS -->
# ![ROS](https://img.shields.io/badge/ros-%230A0FF9.svg?style=for-the-badge&logo=ros&logoColor=black)  TB3_PC_WS  ![ROS](https://img.shields.io/badge/ros-%230A0FF9.svg?style=for-the-badge&logo=ros&logoColor=black)

## build ros2 workspace

clone git (https://github.com/Talzoor/TB3_PC_WS)

```bash
cd /home/tal/TB3_PC_WS
mkdir src
```

create or clone your pkg's into `src`

```bash
cd /home/tal/TB3_PC_WS
rosdep install -i --from-path src --rosdistro humble
colcon build
```

add `setup.bash` to `.bashrc`:

```bash
echo "source /home/tal/TB3_PC_WS/install/setup.bash" >> ~/.bashrc
```