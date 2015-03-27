# !/bin/bash

# create and compile a hydro workspace for Dumbo with all the core ROS packages
# for reading sensors, controlling manipulators, etc
# to run: ./install_dumbo_hydro_ws.sh
# while compiling it will get stuck waiting for sudo password!
echo "installing CAN cards"
cd ~/
wget http://www.kvaser.com/software/7330130980754/V5_3_0/linuxcan.tar.gz

tar -xzf linuxcan.tar.gz
cd linuxcan
sudo make install

cd ~/

echo "INSTALLING DUMBO ROS WORKSPACE IN ~/catkin_ws"

# first check if the directory exists
if [-d "${HOME}/catkin_ws" ]; then
  echo "-----> ERROR: directory ~/catkin_ws already exists, exiting install script!!! <-----"
  exit
fi


# create the ws
mkdir -p ~/catkin_ws/src

# install wstool
sudo apt-get install python-wstool

# initialize the workspace
cd ~/catkin_ws/src
catkin_init_workspace
wstool init
cd ~/catkin_ws
catkin_make
source ~/catkin_ws/devel/setup.bash
printf "\nsource ~/catkin_ws/devel/setup.bash\n" >> ~/.bashrc

cd ~/catkin_ws/src/


# install dependencies
sudo apt-get install ros-hydro-cob-driver -y
sudo apt-get install ros-hydro-cob-common -y
sudo apt-get install ros-hydro-moveit* -y
sudo apt-get install ros-hydro-rqt* -y
sudo apt-get install ros-hydro-ros-control* -y
sudo apt-get install ros-hydro-joint-limits-interface -y


###################################

# get the rosinstall file
cd ~/catkin_ws/src
wget https://raw.githubusercontent.com/kth-ros-pkg/dumbo_install/master/hydro/dumbo_hydro.rosinstall

# merge the rosinstall file
wstool merge dumbo_hydro.rosinstall
wstool update

# compile the workspace
cd ..
catkin_make