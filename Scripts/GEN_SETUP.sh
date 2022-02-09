#!/bin/bash

# General setup for all distros
# Should be quite fast

# Show all commands
set -x

# Make sure packages are good
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


###### General Tools

# Install curl
sudo apt install curl -y

# Install neofetch
sudo apt install neofetch -y

# Install net tools, needed for 'ifconfig'
sudo apt install net-tools -y

# Install tree
sudo apt install tree -y

# Install trash CLI
sudo apt install trash-cli -y




##### Programming 

### Java
# Newest must be done manually
# See this guide: https://www.javahelps.com/2019/04/install-latest-oracle-jdk-on-linux.html
# But get defaults for now
sudo apt install default-jdk -y
sudo apt install default-jre -y


### Python
# Ubuntu 20 or newer comes with python3 pre-installed
sudo apt install python -y
# Get python package manager
sudo apt install python3-pip -y



### C/C++
# Install C and C++ compilers, and other tools like 'make'
sudo apt-get install gcc g++ build-essential -y
echo ""

# Install manual pages for C and other commands
sudo apt install man-db coreutils -y
echo ""
sudo apt-get install manpages-dev manpages-posix-dev -y
echo ""




### Get Darcula theme for Text Editor
wget https://raw.githubusercontent.com/dracula/gedit/master/dracula.xml
mkdir -p $HOME/.local/share/gedit/styles/
mv dracula.xml $HOME/.local/share/gedit/styles/
rm dracula.xml


### Install Consolas font
wget -O /tmp/YaHei.Consolas.1.12.zip https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/uigroupcode/YaHei.Consolas.1.12.zip
unzip /tmp/YaHei.Consolas.1.12.zip
sudo mkdir -p /usr/share/fonts/consolas
sudo mv YaHei.Consolas.1.12.ttf /usr/share/fonts/consolas/
sudo chmod 644 /usr/share/fonts/consolas/YaHei.Consolas.1.12.ttf
cd /usr/share/fonts/consolas
sudo mkfontscale && sudo mkfontdir && sudo fc-cache -fv


# Message
echo ""
echo "################### Finished! ###################"
echo ""










