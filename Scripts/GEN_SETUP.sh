#!/usr/bin/env bash

# General setup for all distros
# Should be quite fast


########################## HELPER FUNCTIONS


### Helper Function: isNotInstalled()
# Given a package name, return true if NOT installed and false otherwise.
# Argument 1: Package Name
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


### Helper Function: isInstalled()
# Given a package name, return true if IT IS installed and false otherwise.
# Argument 1: Package Name
function isInstalled() {

	# Return opposite of previous function
	if isNotInstalled $1; then

		# Return false
		return 1;
	else

		# Return true
		return 0;
	fi
}


### Helper Function: install()
# Given a package name, install if it isn't installed
# Argument 1: Package Name
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
# Argument 1: Snap Package Name
# Argument 2: Extra Argument
function installSnap() {

	# Notify
	echo "Snap Package: $1"
	
	# Install unattended
	sudo snap install $1 $2
}



### Helper Function: installDeb()
# Given a Deb package name and URL, install it
# Argument 1: Snap Package Name
function installSnap() {

	# Notify
	echo "Snap Package: $1"
	
	# Install unattended
	sudo snap install $1 $2
}


### Helper Function: installDeb()
# Given a Deb package name and URL, install it
# Argument 1: Deb Package Name
# Argument 2: URL
function installDeb() {

	# Notify
	echo "Deb Package: $1"

	# If not installed
	if isNotInstalled "$1"; then
		
		# Notify
		echo "$1 has not been installed. Installing $1."
		
		# Download from URL
		wget $2

		# Install package
		sudo dpkg -i $1*.deb

		# Remove file
		rm $1*.deb
	else

		# Notify
		echo "$1 already installed"
	fi

	# Space
	echo ""
}





############### ACTUAL SCRIPT STARTS HERE


############### Configuration Changes

### Set Ubuntu Text Editor as default Git Editor
git config --global core.editor "gedit -s"

### Disable Ubuntu Pro messages when this script is running
sudo dpkg-divert --divert /etc/apt/apt.conf.d/20apt-esm-hook.conf.bak --rename --local /etc/apt/apt.conf.d/20apt-esm-hook.conf > /dev/null 2>&1


############### Update Packages
echo ""
echo ""
echo "################### UPDATES"

sudo apt update -y
echo ""
sudo apt upgrade -y
echo ""
sudo apt full-upgrade -y
echo ""
sudo apt-get update -y 
echo ""
sudo apt-get upgrade -y
echo ""
sudo apt-get dist-upgrade -y
echo ""
sudo apt-get check -y
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
# install "trash-cli"
# echo ""

# Install Ookla Speedtest CLI
install "speedtest-cli"
echo ""

# Install GNOME Tweaks
install "gnome-tweaks"
echo ""

# Install Stacer (Like CCleaner for Linux)
# (Use to disable AnyDesk autostart!)
# install "stacer"
# echo ""

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
# install "default-jdk"
# install "default-jre"
# echo ""


### Python
# Get python and python package manager
install "python3"
install "python3-pip"
echo ""



### C/C++
# Install C and C++ compilers, and other tools like 'make'
# install "build-essential"
# install "gcc" 
# install "g++"
# echo ""

# Install manual pages for C and other commands
# install "man-db"
# install "coreutils"
# install "manpages-dev"
# install "manpages-posix-dev"
# echo ""

## Install OpenGL libraries
# # Labs
# install "freeglut3-dev"
# install "libxmu-dev"
# echo ""
# # Project
# install "cmake"
# install "xorg-dev"
# install "libxi-dev"
# install "libxmu-dev"
# install "libx11-dev"
# install "libgl1-mesa-dev"
# install "libglu1-mesa-dev"
# echo ""

# # Install NetBeans C/C++ info servers
# install "ccls clangd"
# echo ""






############## Install Snaps
echo ""
echo ""
echo "################### SNAPS"

# If snap pre-installed
if isInstalled "snapd"; then

	# Notify
	echo "Snap is pre-installed..."
	echo ""

	## Install snaps

	# Install NetBeans
	# installSnap "netbeans" "--classic"
	# echo ""

	# Install VS Code
	# installSnap "code" "--classic"
	# echo ""

	# # Install Pinta (its like paint)
	# installSnap "pinta"
	# echo ""

	# Install Discord
	installSnap "discord"
	echo ""

else
	echo "Snap was not pre-installed...skipping snap installs..."
fi
echo ""


############## Manual Installs/Downloads
echo ""
echo ""
echo "################### MANUAL INSTALLS/DOWNLOADS"


### Install Google Chrome
installDeb "google-chrome-stable" "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"


### Install libpango
# Solves AnyDesk error =
# error while loading shared libraries: libpangox-1.0.so.0: 
# cannot open shared object file: No such file or directory
installDeb "libpangox-1.0-0" "http://ftp.us.debian.org/debian/pool/main/p/pangox-compat/libpangox-1.0-0_0.0.2-5.1_amd64.deb"


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
else
	echo "GitHub Desktop already installed"
fi
echo ""





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
else
	echo "YaHei Consolas font already installed"
fi
echo ""


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
else
	echo "Dracula Theme already installed"
fi
echo ""



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
echo ""











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



### Disable Bluetooth on Startup
# Source: 
# https://askubuntu.com/questions/67758/how-can-i-deactivate-bluetooth-on-system-startup
sudo install -b -m 755 /dev/stdin /etc/rc.local << EOF
!/bin/sh
rfkill block bluetooth
echo disable > /proc/acpi/ibm/bluetooth
exit 0
EOF


# Message
echo ""
echo "################### Finished! ###################"
echo ""
