#!/bin/bash

# General setup for all distros
# Should be quite fast

# Show all commands
# set -x


############### Update Packages
echo ""
echo ""
echo "################### UPDATES"

sudo apt update 
echo ""
sudo apt upgrade
echo ""
sudo apt full-upgrade
echo ""
sudo apt-get update 
echo ""
sudo apt-get upgrade
echo ""
sudo apt-get dist-upgrade
echo ""
sudo apt-get check
echo ""




############## Install Packages

echo ""
echo ""
echo "################### PACKAGES"

###### General Tools

# Install curl
sudo apt install curl -y
echo ""

# Install neofetch
sudo apt install neofetch -y
echo ""

# Install net tools, needed for 'ifconfig'
sudo apt install net-tools -y
echo ""

# Install tree
sudo apt install tree -y
echo ""

# Install trash CLI
sudo apt install trash-cli -y
echo ""






###### Programming

### Java
# Newest must be done manually
# See this guide: https://www.javahelps.com/2019/04/install-latest-oracle-jdk-on-linux.html
# But get defaults for now
sudo apt install default-jdk default-jre -y
echo ""


### Python
# Note: Ubuntu 20 or newer comes with python3 pre-installed
# Get python and python package manager
sudo apt install python python3-pip -y
echo ""



### C/C++
# Install C and C++ compilers, and other tools like 'make'
sudo apt-get install gcc g++ build-essential -y
echo ""

# Install manual pages for C and other commands
sudo apt install man-db coreutils manpages-dev manpages-posix-dev -y
echo ""

# Install OpenGL libraries
sudo apt install freeglut3-dev libxmu-dev -y
echo ""





############## Manual Installs/Downloads
echo ""
echo ""
echo "################### MANUAL INSTALLS/DOWNLOADS"




### Get Dracula theme for (Ubuntu) Text Editor
# Paths
draculaFolder="$HOME/.local/share/gedit/styles"
draculaLoc="$draculaFolder/dracula.xml"

# Always download because: 1) super small/fast 2) may update
#if ! [[ -e $draculaLoc ]]; then

# Make folder 
mkdir -p $draculaFolder

# Download to folder
wget -O $draculaLoc https://raw.githubusercontent.com/dracula/gedit/master/dracula.xml
#fi






### Install Consolas font (if not installed already)
# Paths
consolasURL="https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/uigroupcode/YaHei.Consolas.1.12.zip"
consolasFile="/tmp/YaHei.Consolas.1.12.zip"
# If font is not installed
if ! [[ -e "/usr/share/fonts/consolas/YaHei.Consolas.1.12.ttf" ]]; then

	# Download file to path
	wget -O $consolasFile $consolasURL
	
	# Install file
	unzip /tmp/YaHei.Consolas.1.12.zip
	sudo mkdir -p /usr/share/fonts/consolas
	sudo mv YaHei.Consolas.1.12.ttf /usr/share/fonts/consolas/
	sudo chmod 644 /usr/share/fonts/consolas/YaHei.Consolas.1.12.ttf
	cd /usr/share/fonts/consolas
	sudo mkfontscale && sudo mkfontdir && sudo fc-cache -fv

	# Remove installer file
	rm $consolasFile
fi





############## Removals
echo ""
echo ""
echo "################### Removals"

# Remove Firefox
sudo apt-get purge firefox -y

# Remove Thunderbird (quietly coz massive output)
sudo apt-get -qq purge thunderbird* -y





# Message
echo ""
echo "################### Finished! ###################"
echo ""










