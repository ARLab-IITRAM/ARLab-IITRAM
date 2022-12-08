#!/usr/bin/env python3
from plutodrone.srv import *
from plutodrone.msg import *
# from std_msgs.msg import Int16
import rospy


class send_data():
	"""docstring for request_data"""

	def __init__(self):
		rospy.init_node('drone_server')
		self.command_pub = rospy.Publisher('/drone_command', PlutoMsg, queue_size=1)
		
		self.key_value = 0
		self.cmd = PlutoMsg()
		self.cmd.rcRoll = 1500
		self.cmd.rcPitch = 1500
		self.cmd.rcYaw = 1500
		self.cmd.rcThrottle = 1500
		self.cmd.rcAUX1 = 1500
		self.cmd.rcAUX2 = 1500
		self.cmd.rcAUX3 = 1500
		self.cmd.rcAUX4 = 1000
		self.cmd.commandType = 0
		self.cmd.trim_roll = 0
		self.cmd.trim_pitch = 0
		self.cmd.isAutoPilotOn = 0
		# self.box_arm()
		self.waypoint_navigation_without_yaw()

		# self.waypoint_navigation_with_yaw()

		# rospy.Subscriber('/input_key', Int16, self.indentify_key)

	def arm(self):
		self.cmd.rcRoll = 1520
		self.cmd.rcYaw = 1500
		self.cmd.rcPitch = 1520
		self.cmd.rcThrottle = 1000
		self.cmd.rcAUX4 = 1500
		self.cmd.isAutoPilotOn = 0
		self.command_pub.publish(self.cmd)
		rospy.sleep(1)
		rospy.loginfo("Armed.")

	def box_arm(self):
		self.cmd.rcRoll = 1500
		self.cmd.rcYaw = 1500
		self.cmd.rcPitch = 1500
		self.cmd.rcThrottle = 1500
		self.cmd.rcAUX4 = 1500
		self.cmd.isAutoPilotOn = 0
		self.command_pub.publish(self.cmd)
		rospy.sleep(0.5)

	def disarm(self):
		self.cmd.rcThrottle = 1300
		self.cmd.rcAUX4 = 1200
		self.command_pub.publish(self.cmd)
		rospy.sleep(0.5)
		rospy.loginfo("Dis-armed!")

	def indentify_key(self, msg):
		self.key_value = msg.data

		if self.key_value == 70:
			if (self.cmd.rcAUX4 == 1500):
				self.disarm()
			else:
				self.arm()
		elif self.key_value == 10:
			self.forward()
		elif self.key_value == 30:
			self.left()
		elif self.key_value == 40:
			self.right()
		elif self.key_value == 80:
			self.reset()
		elif self.key_value == 90:
			if (self.cmd.isAutoPilotOn == 1):
				self.cmd.isAutoPilotOn = 0
			else:
				self.cmd.isAutoPilotOn = 1
		elif self.key_value == 50:
			self.increase_height()
		elif self.key_value == 60:
			self.decrease_height()
		elif self.key_value == 110:
			self.backward()
		elif self.key_value == 130:
			self.take_off()
		elif self.key_value == 140:
			self.land()
		elif self.key_value == 150:
			self.left_yaw()
		elif self.key_value == 160:
			self.right_yaw()
		self.command_pub.publish(self.cmd)

	def forward(self):
		self.cmd.rcThrottle = 1500
		self.cmd.rcRoll = 1520
		self.cmd.rcPitch = 1620
		self.command_pub.publish(self.cmd)
		rospy.loginfo("Going Forward!")

	def backward(self):
		self.cmd.rcThrottle = 1500
		self.cmd.rcRoll = 1520
		self.cmd.rcPitch = 1420
		self.command_pub.publish(self.cmd)
		rospy.loginfo("Going Backward!")

	def left(self):
		self.cmd.rcThrottle = 1500
		self.cmd.rcRoll = 1420
		self.cmd.rcPitch = 1520
		self.command_pub.publish(self.cmd)
		rospy.loginfo("Takking a Left!")

	def right(self):
		self.cmd.rcThrottle = 1500
		self.cmd.rcRoll = 1620
		self.cmd.rcPitch = 1520
		self.command_pub.publish(self.cmd)
		rospy.loginfo("Takking a Right!")

	def left_yaw(self):
		self.cmd.rcYaw = 1200
		self.command_pub.publish(self.cmd)
		rospy.loginfo("Heading towards left!")

	def right_yaw(self):
		self.cmd.rcYaw = 1800
		self.command_pub.publish(self.cmd)
		rospy.loginfo("Heading towards right!")

	def reset(self):
		self.cmd.rcRoll = 1520
		self.cmd.rcThrottle = 1500
		self.cmd.rcPitch = 1520
		self.cmd.rcYaw = 1500
		self.cmd.commandType = 0
		self.command_pub.publish(self.cmd)

	def increase_height(self):
		self.cmd.rcThrottle = 1600
		self.cmd.rcRoll = 1520
		self.cmd.rcPitch = 1520
		self.command_pub.publish(self.cmd)
		rospy.loginfo("Going to higher Altitude!")

	def decrease_height(self):
		self.cmd.rcThrottle = 1400
		self.command_pub.publish(self.cmd)
		rospy.loginfo("Decreaing Altitude!")

	def take_off(self):
		self.cmd.rcThrottle = 1500
		self.cmd.rcRoll = 1515
		self.cmd.rcPitch = 1520
		self.command_pub.publish(self.cmd)
		rospy.loginfo("Took Off!")
	
	def take_off_built_in(self):
		self.disarm()
		self.box_arm()
		self.cmd.commandType = 1
		self.command_pub.publish(self.cmd)

	def land(self):
		self.cmd.commandType = 2
		self.command_pub.publish(self.cmd)
		rospy.loginfo("Landed!")

	def waypoint_navigation_without_yaw(self):
		try:
			# arming and takeoff
			self.arm()
			rospy.sleep(1)
			self.take_off()
			rospy.sleep(2)

			# forward flight
			self.forward()
			rospy.sleep(2)
			# to nullify inertia due to forward flight
			self.backward()
			rospy.sleep(1)

			# take a right
			self.right()
			rospy.sleep(2)
			# inertia nullification
			self.left()
			rospy.sleep(1)

			# backward flight and inertia
			self.backward()
			rospy.sleep(2)
			self.forward()
			rospy.sleep(1)

			# take a left
			self.left()
			rospy.sleep(3)
			self.right()
			rospy.sleep(1)

			# land and disarm
			self.land()
			# rospy.sleep(1)
		except Exception as e:
			rospy.loginfo(e)
		rospy.sleep(3)
		self.disarm()
		rospy.loginfo("Mission Accomplished!")
		sys.exit()

	def waypoint_navigation_with_yaw(self):
		try:
			# arming and takeoff
			self.arm()
			rospy.sleep(1)
			self.take_off()
			rospy.sleep(2)

			# forward flight
			self.forward()
			rospy.sleep(2)
			# to nullify inertia due to forward flight
			self.backward()
			rospy.sleep(1)

			# rotate right
			self.right_yaw()
			rospy.sleep(1.5)
			# inertia nullification
			self.left_yaw()
			rospy.sleep(1)

			# forward flight
			self.forward()
			rospy.sleep(2)
			# to nullify inertia due to forward flight
			self.backward()
			rospy.sleep(1)

			# rotate right
			self.right_yaw()
			rospy.sleep(1.5)
			# inertia nullification
			self.left_yaw()
			rospy.sleep(1)

			# forward flight
			self.forward()
			rospy.sleep(2)
			# to nullify inertia due to forward flight
			self.backward()
			rospy.sleep(1)

			# rotate right
			self.right_yaw()
			rospy.sleep(1.5)
			# inertia nullification
			self.left_yaw()
			rospy.sleep(1)

			# forward flight
			self.forward()
			rospy.sleep(2)
			# to nullify inertia due to forward flight
			self.backward()
			rospy.sleep(1)

			# land and disarm
			self.land()
			# rospy.sleep(1)
		except Exception as e:
			rospy.loginfo(e)
		rospy.sleep(3)
		self.disarm()
		rospy.loginfo("Mission Accomplished!")
		sys.exit()


if __name__ == '__main__':
	test = send_data()
	# while not rospy.is_shutdown():
	# 	rospy.spin()
	# 	sys.exit(1)
