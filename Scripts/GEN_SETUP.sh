#!/bin/bash

# General setup for all distros
# Should be quite fast


########################## HELPER FUNCTIONS

### Helper Function: isNotInstalled()
# Given a package name, return true if NOT installed and false otherwise.
# Argument: Package Name
function isNotInstalled() {

	# Check if installed
	check=$(dpkg-query -W --showformat='${Status}\n' $1|grep "install ok installed")

	## Convert check to numerical value
	# If check came back as not installed
	if [ "" = "$check" ]; then

		# Return true (not installed)
		return 0;
	else

		# Return false (installed)
		return 1;
	fi
}



### Helper Function: install()
# Given a package name, install if it isn't installed
# Argument: Package Name
function install() {

	# Notify
	echo "Package: $1"
	
	# If not installed
	if isNotInstalled $1; then

		# Notify
		echo "Not installed"

		# Install it unattended
		sudo apt install $1 -y
	else 
		# Else if it is installed, notify
		echo "Already installed"
	fi
}



### Helper Function: installSnap()
# Given a Snap package name, install it
# Argument: Snap Package Name
function installSnap() {

	# Notify
	echo "Snap Package: $1"
	
	# Install unattended
	sudo snap install $1 --classic
}






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

###### General

# Install wget
install "wget"
echo ""

# Install curl
install "curl"
echo ""

# Install neofetch
install "neofetch"
echo ""

# Install net tools, needed for 'ifconfig'
install "net-tools"
echo ""

# Install tree
install "tree"
echo ""

# Install trash CLI
install "trash-cli"
echo ""

# Install GNOME Tweaks
install "gnome-tweaks"
echo ""


# DISABLED AS NO LONGER AVAILABLE FOR UBUNTU 22
# Install GRUB Customizer
# install grub-customizer
# echo ""


## Install SSF2 packages
# Enable 32 bit packages and update package list
sudo dpkg --add-architecture i386
echo ""
sudo apt update -y
echo ""

# Install wine
install "wine"
echo ""
install "wine32"
echo ""
install "winbind"
echo ""

# Install canberra GTK module 
# Solves GTK error for various programs
install "libcanberra-gtk-module"
echo ""







###### Programming

### Java (Default versions)
install "default-jdk"
install "default-jre"
echo ""


### Python
# Get python and python package manager
install "python3"
install "python3-pip"
echo ""



### C/C++
# Install C and C++ compilers, and other tools like 'make'
install "gcc g++ build-essential"
echo ""

# Install manual pages for C and other commands
install "man-db coreutils manpages-dev manpages-posix-dev"
echo ""

## Install OpenGL libraries
# Labs
install "freeglut3-dev libxmu-dev"
echo ""
# Project
install "cmake xorg-dev"
install "libxmu-dev libx11-dev libgl1-mesa-dev libglu1-mesa-dev libxi-dev"
echo ""

# Install NetBeans C/C++ info servers
install "ccls clangd"
echo ""






############## Install Snaps
echo ""
echo ""
echo "################### SNAPS"

# Install NetBeans
installSnap "netbeans --classic"

# Install VS Code
installSnap "code --classic"
echo ""

# Install Pinta (its like paint)
installSnap "pinta"
echo ""

# Install Discord
sudo snap install discord



############## Manual Installs/Downloads
echo ""
echo ""
echo "################### MANUAL INSTALLS/DOWNLOADS"



### Install GitHub Desktop

# Save name
gdS="github-desktop"

# Notify
echo "Package: $gdS"

# If not installed
if isNotInstalled "$gdS"; then
	
	# Notify
	echo "$gdS has not been installed. Installing $gdS."
	  
	# Download latest release
	curl -s https://api.github.com/repos/shiftkey/desktop/releases/latest \
	| grep "browser_download_url.*deb" \
	| cut -d : -f 2,3 \
	| tr -d \" \
	| wget -i -

	# Install package
	sudo dpkg -i GitHubDesktop*.deb

	# Remove file
	rm GitHubDesktop*.deb
fi



### Install Google Chrome

# Save name
gChromeS="google-chrome-stable"

# Notify
echo "Package: $gChromeS"

# If not installed
if isNotInstalled "$gChromeS"; then
	
	# Notify
	echo "$gChromeS has not been installed. Installing $gChromeS."
	  
	# Download latest release
	wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb

	# Install package
	sudo dpkg -i google-chrome-stable*.deb

	# Remove file
	rm google-chrome-stable*.deb
fi





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


### Get Dracula theme for (Ubuntu) Text Editor
# Paths
draculaFolder="$HOME/.local/share/gedit/styles"
draculaLoc="$draculaFolder/dracula.xml"
# If doesn't exist
if ! [[ -e $draculaLoc ]]; then
	# Make folder 
	mkdir -p $draculaFolder
	# Download to folder
	wget -O $draculaLoc https://raw.githubusercontent.com/dracula/gedit/master/dracula.xml
fi





## Install Fallout 4 GRUB Theme

# If theme folder does not exist
if [ ! -d  "/boot/grub/themes/fallout-grub-theme/" ]; then 

	# Set name
	falloutName="fallout-grub-theme-install.sh"

	# Download with name
	wget https://github.com/shvchk/fallout-grub-theme/raw/master/install.sh \
	--output-document=$falloutName

	# Enable execution
	chmod u+x $falloutName

	# Execute with argument, quietly
	./$falloutName

	# Remove script
	rm $falloutName
else
	echo "Fallout Grub Theme already installed"
fi












############## Removals
echo ""
echo ""
echo "################### Removals"

## Remove Firefox
# Package version (Ubuntu 20)
sudo apt purge firefox -y
# Snap version (Ubuntu 22)
sudo snap remove --purge firefox

## Remove Thunderbird
# Do quietly coz massive output
# (MUST BE APT-GET otherwise noisy!)
sudo apt-get -qq purge thunderbird* -y
# Remove extra package it leaves behind
sudo apt autoremove -y






# Message
echo ""
echo "################### Finished! ###################"
echo ""










