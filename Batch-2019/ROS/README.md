<h1 align="center">
  <a href="http://wiki.ros.org/"><img src="http://wiki.ros.org/custom/images/ros_org.png" alt="ROS" width="300"></a>
  <a href="[https://gazebosim.org/home](https://gazebosim.org/assets/images/gazebo_horz_pos_topbar.svg)"><img src="http://gazebosim.org/assets/gazebo_vert-af0a0ada204b42b6daca54e98766979e45e011ea22347ffe90580458476d26d6.png" alt="Gazebo" width="100"></a>
  <a href="https://px4.io/"><img src="https://px4.io/wp-content/uploads/2020/03/PX4_logo_black_large_resized_compressed-compressor.png" alt="PX4" width="200"></a>
</h1>

<h1>ROS+Gazebo+PX4 Installation Instructions</h1>

* This Document assumes that the reader has installed *Ubuntu 20.04*. However, if you haven't install *Ubuntu 20.04*, make sure to install it before proceeding.
* You can download *Ubuntu 20.04* ISO file from [here](https://releases.ubuntu.com/20.04/).

# Environment Setup
Follow the following steps to install ROS1, Gazebo and PX4 Firmware, that collectively form the whole environment.

#### 1. General Dependecies
To use all provided utilities, there are some packages we need to install first, you can copy these commands as it is, but it is recommended to learn and understand what each command and software does:
```bash
sudo apt install -y \
	ninja-build \
	exiftool \
	python3-empy \
	python3-toml \
	python3-numpy \
	python3-yaml \
	python3-dev \
	python3-pip \
	ninja-build \
	protobuf-compiler \
	libeigen3-dev \
	genromfs
```
```bash
pip install \
	pandas \
	jinja2 \
	pyserial \
	cerberus \
	pyulog \
	numpy \
	toml \
	pyquaternion
```

# ROS Noetic Installation

*ROS (Robot Operating System) provides libraries and tools to help software developers create robot applications. It provides hardware abstraction, device drivers, libraries, visualizers, message-passing, package management, and more. ROS is licensed under an open source, BSD license.*

Here the [distribution](http://wiki.ros.org/Distributions) compatible with *Ubuntu 20.04* is the [ROS Noetic Ninjemys](http://wiki.ros.org/noetic). Follow the steps below to install it.

## Installation Steps
1. Configure your Ubuntu repositories
Configure your Ubuntu repositories to allow “restricted,” “universe,” and “multiverse.” You can [follow the Ubuntu guide](https://help.ubuntu.com/community/Repositories/Ubuntu) for instructions on doing this.
2. Setup your computer to accept software from packages.ros.org.
```bash
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
```
3. Set up your keys.
```bash
sudo apt install curl
curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -
```
4. Make sure your Debian package indec is up-to-date
```bash
sudo apt update
```
5. Installing the ROS recommended configuration.
```bash
sudo apt install ros-noetic-desktop-full
```
6. Environment Setup
```bash
source /opt/ros/noetic/setup.bash
```
It can be convenient to automatically source this script every time a new shell is launched. These commands will do that for you.
```bash
echo "source /opt/ros/noetic/setup.bash" >> ~/.bashrc
source ~/.bashrc
```
7. Dependencies for building packages
```bash
sudo apt install python3-rosdep python3-rosinstall python3-rosinstall-generator python3-wstool build-essential
sudo apt install python3-rosdep
sudo rosdep init
rosdep update
```

# MAVROS Installation
MAVROS is a communication node based on MAVLink for ROS that is specially designed for communication between the drone and the companion computer. To install it, follow the following instructions:
```bash
sudo apt install python3-catkin-tools python3-rosinstall-generator python3-osrf-pycommon -y
```
1. Create the workspace:
```bash
mkdir -p ~/catkin_ws/src
cd ~/catkin_ws
catkin init
wstool init src
```
2. Install MAVLink: we use the Kinetic reference for all ROS distros as it’s not distro-specific and up to date
```bash
rosinstall_generator --rosdistro noetic mavlink | tee /tmp/mavros.rosinstall
```
3. Install MAVROS: get spurce (upstream - released)
```bash
rosinstall_generator --upstream mavros | tee -a /tmp/mavros.rosinstall
```
alternative
```bash
rosinstall_generator --upstream-development mavros | tee -a /tmp/mavros.rosinstall
```
4. Create workspace & deps
```bash
wstool merge -t src /tmp/mavros.rosinstall
wstool update -t src -j4
rosdep install --from-paths src --ignore-src -y
```
5. Install GeographicLib datasets:
```bash
./src/mavros/mavros/scripts/install_geographiclib_datasets.sh
```
6. Build Source
```bash
catkin build
```
7. Make sure that you use setup.bash
```bash
source devel/setup.bash
```

# PX4 Firmaware Installation
```bash
cd ~/catkin_ws/src
git clone https://github.com/PX4/PX4-Autopilot.git --recursive
cd PX4-Autopilot/
make px4_sitl_default gazebo
```
Now you should see a window pop out and a drone is centered in the middle of the environment.
![gazebo-screenshot](https://aws1.discourse-cdn.com/business20/uploads/e_yantra/optimized/1X/0b6dc7055d220854e7386db13d30d998e896acf7_2_1035x588.jpeg)
Modifying your ‘bashrc’ so that your environment remains the same every time you open a new terminal:
```bash
source ~/catkin_ws/devel/setup.bash
source ~/catkin_ws/src/PX4-Autopilot/Tools/setup_gazebo.bash ~/catkin_ws/src/PX4-Autopilot/ ~/catkin_ws/src/PX4-Autopilot/build/px4_sitl_default
export ROS_PACKAGE_PATH=$ROS_PACKAGE_PATH:~/catkin_ws/src/PX4-Autopilot
export ROS_PACKAGE_PATH=$ROS_PACKAGE_PATH:~/catkin_ws/src/PX4-Autopilot/Tools/sitl_gazebo
```

## *QGroundControl* Installation
* On the terminal, enter
```bash
sudo usermod -a -G dialout $USER
sudo apt-get remove modemmanager -y
sudo apt install gstreamer1.0-plugins-bad gstreamer1.0-libav 
gstreamer1.0-gl -y
```
* Logout and login again to enable the change to user permissions.
* Download [QGroundControl.AppImage](https://s3-us-west-2.amazonaws.com/qgroundcontrol/latest/QGroundControl.AppImage).
* First navigate to the downloads folder and then, Install (and run) using the terminal commands:
```bash
cd 
cd Downloads/
chmod +x ./QGroundControl.AppImage
./QGroundControl.AppImage  # (or double click)
```
# Learning Resources
* We highly recommend you to go through [px4 official documentation](https://docs.px4.io/v1.12/en/development/development.html) and for mavros go through [mavros px4 documentation](https://docs.px4.io/master/en/ros/ros1.html) as the learning curve might be steap in the start.

## Authors
* [Kamlesh Kumar](https://github.com/kamlesh364)
