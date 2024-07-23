#!/usr/bin/env python3

import rclpy
from rclpy.node import Node
import signal

from geometry_msgs.msg import Twist
from sensor_msgs.msg import LaserScan, Imu
from nav_msgs.msg import Odometry
from rclpy.qos import qos_profile_sensor_data

import time
import math


# def handler(signum, frame):
#     msg = "Ctrl-c was pressed."
#     print(msg, end='', flush=True)
#     exit(1)

WITH_ODOM = 'odom'
WITH_IMU = 'imu'

class MyScript(Node):

    def __init__(self):
        super().__init__("run_script")

        self.turn_data = WITH_IMU  # WITH_ODOM or WITH_IMU
        self.current_angle = 0.0
        self.start_angle = 0.0

        self.publisher_ = self.create_publisher(Twist, 'cmd_vel', 10)
        self.subscription = self.create_subscription(
            LaserScan,
            'scan',
            self.laser_callback,
            qos_profile_sensor_data
        )
        self.odom_subscription = self.create_subscription(
            Odometry,
            'odom',
            self.odom_callback,
            10
        )
        self.imu_subscription = self.create_subscription(
            Imu,
            'imu',
            self.imu_callback,
            10
        )
        # self.timer = self.create_timer(1.0, self.timer_callback)
        self.timer_accel = self.create_timer(0.1, self.timer_accel_callback)
        self.laser_data = None

        self.current_yaw = 0.0
        self.start_yaw = 0.0
        self.is_turning = False
        self.turn_target = 0.0
        self.initial_laser_distance = None
        
        self.counter = 0
        
        self.robot_start_speed = 0.02
        self.robot_accelration = 0.005   # -1 = No
        self.robot_end_speed = 0.1
        self.robot_speed = self.robot_start_speed

        self.robot_angular_speed = 0.5  # radians per second

        self.robot_min_range = 0.3      # 0.5m
        self.robot_turn_angle = math.pi / 2  # 90 degrees in radians
        self.robot_turn_count = 0
        self.robot_max_turn_count = -1   # -1 = inf
        self.turn_direction = 1  # 1 for clockwise, -1 for counter-clockwise
        self.turn_start_time = None
        self.max_turn_duration = 10.0  # Maximum turn duration in seconds
        
        self.get_logger().info("---SCRIPT BEGIN---")

    def odom_callback(self, msg):
        if self.turn_data == WITH_ODOM:
            orientation = msg.pose.pose.orientation
            _, _, yaw = self.euler_from_quaternion(orientation.x, orientation.y, orientation.z, orientation.w)
            self.current_angle = yaw

    def imu_callback(self, msg):
        if self.turn_data == WITH_IMU:
            orientation = msg.orientation
            _, _, yaw = self.euler_from_quaternion(orientation.x, orientation.y, orientation.z, orientation.w)
            self.current_angle = yaw
            
    def timer_accel_callback(self):
        if self.robot_accelration != -1 and not self.is_turning:
            if self.robot_speed < self.robot_end_speed:
                self.robot_speed += self.robot_accelration
        # self.get_logger().info("robot_speed:{}".format(self.robot_speed))

    def timer_callback(self):
        self.counter += 1
        self.get_logger().info("counter = {}".format(self.counter))

        if self.laser_data is None:
            return

        twist = Twist()
        twist.linear.x = self.robot_start_speed
        self.publisher_.publish(twist)
        time.sleep(2)   # wait for 2 sec

        # now stop robot
        twist.linear.x = 0.0
        self.publisher_.publish(twist)
    
    def laser_callback(self, msg):
        # get distance
        angle = 0
        index = int((angle - msg.angle_min) / msg.angle_increment)
        self.laser_data = msg.ranges[index]

        self.get_logger().info("index:{}, data:{}".format(index, self.laser_data))

        # Check distance and move until specific output
        twist = Twist()
        twist.linear.x = 0.0

        if not self.is_turning:
            if self.laser_data != 0.0:
                if self.laser_data > self.robot_min_range:   # 0.5m
                    twist.linear.x = self.robot_speed
                    self.publisher_.publish(twist)
                else:
                    if self.robot_max_turn_count == -1 or self.robot_turn_count < self.robot_max_turn_count:
                        self.start_turn()
                    else:
                        self.get_logger().info("Turn number reached max")
            else:
                twist.linear.x = self.robot_speed 
                self.publisher_.publish(twist)
        else:
            self.check_turn_completion(msg)

        
    def start_turn(self):
        self.is_turning = True
        self.start_angle = self.current_angle
        self.turn_target = self.normalize_angle(self.start_angle + self.robot_turn_angle)
        self.initial_laser_distance = self.laser_data
        self.turn_direction = 1 if self.robot_turn_angle > 0 else -1
        self.turn_start_time = self.get_clock().now()
        self.get_logger().info(f"Starting turn. Current angle: {self.start_angle}, Target angle: {self.turn_target}")


    def check_turn_completion(self, laser_msg):
        current_time = self.get_clock().now()
        turn_duration = (current_time - self.turn_start_time).nanoseconds / 1e9

        if turn_duration > self.max_turn_duration:
            self.get_logger().warn("Turn timeout reached. Stopping turn.")
            self.is_turning = False
            twist = Twist()
            self.publisher_.publish(twist)
            return

        angle_diff = self.normalize_angle(self.turn_target - self.current_yaw)
        
        # Check if we've completed the turn
        if abs(angle_diff) < 0.05:  # Allow small error margin
            self.is_turning = False
            twist = Twist()
            self.publisher_.publish(twist)
            self.get_logger().info("Turn completed")
            self.robot_turn_count += 1
            return

        # Continue turning
        twist = Twist()
        twist.angular.z = self.robot_angular_speed * self.turn_direction
        self.publisher_.publish(twist)
        self.get_logger().info(f"Turning. Current yaw: {self.current_yaw}, Target yaw: {self.turn_target}, Difference: {angle_diff}")

    @staticmethod
    def euler_from_quaternion(x, y, z, w):
        """
        Convert a quaternion into euler angles (roll, pitch, yaw)
        roll is rotation around x in radians (counterclockwise)
        pitch is rotation around y in radians (counterclockwise)
        yaw is rotation around z in radians (counterclockwise)
        """
        t0 = +2.0 * (w * x + y * z)
        t1 = +1.0 - 2.0 * (x * x + y * y)
        roll_x = math.atan2(t0, t1)
     
        t2 = +2.0 * (w * y - z * x)
        t2 = +1.0 if t2 > +1.0 else t2
        t2 = -1.0 if t2 < -1.0 else t2
        pitch_y = math.asin(t2)
     
        t3 = +2.0 * (w * z + x * y)
        t4 = +1.0 - 2.0 * (y * y + z * z)
        yaw_z = math.atan2(t3, t4)
     
        return roll_x, pitch_y, yaw_z

    @staticmethod
    def normalize_angle(angle):
        """
        Normalize an angle to [-pi, pi].
        """
        while angle > math.pi:
            angle -= 2 * math.pi
        while angle < -math.pi:
            angle += 2 * math.pi
        return angle

    def shutdown(self):
        self.get_logger().info('Stopping the robot...')
        
        twist = Twist()
        twist.linear.x = 0.0
        twist.angular.z = 0.0
        try:
            # Publish the stop command a couple more times
            for _ in range(3):
                self.publisher_.publish(twist)
                time.sleep(0.1)
        except Exception as e:
            self.get_logger().error(f'Error during shutdown: {str(e)}')


def main(args=None):
    # signal.signal(signal.SIGINT, handler)
    rclpy.init(args=args)

    node = MyScript()

    def signal_handler(sig, frame):
            node.get_logger().info('Interrupt received, shutting down...')
            node.shutdown()
            rclpy.try_shutdown()
        
    signal.signal(signal.SIGINT, signal_handler)

    try:
        rclpy.spin(node)
    except KeyboardInterrupt:
        pass
    finally:
        rclpy.try_shutdown()


if __name__ == "__main__":
    main()
    