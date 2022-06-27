#!/bin/bash

### SCRIPT FOR INSTALLING SSF2 ON LINUX ###
###
### Brief Description: Install a Linux SSF2 version of the user's choosing
###
### Author: davo#1776
###
### First Created: 27/06/22
###
### Tested On: Ubuntu 22.04 LTS (Jammy Jellyfish)
###
### Usage:
### 1. Download this script
### - a) Open this link: https://github.com/DavoDC/LinuxFiles/blob/main/Scripts/SSF2/INSTALL_SSF2.sh
### - b) Save the file as a '.sh' (right click and select 'Save as' or use Ctrl+S)
### 2. Find the folder where you saved the script
### 3. Right click and select "Open in Terminal", to open your terminal to the right folder
### 5. Enable the script using: "chmod u+x INSTALL_SSF2.sh"
### 6. Run the script using: "./INSTALL_SSF2.sh"
### 7. Follow the prompts
###
### This is a 'scriptified' version of the steps from the Player Guide.
### https://docs.google.com/document/d/1l5VrAaWmLozu9qnwdjz6MGA9GyurlkgNF8t72eZ4-54/edit#heading=h.cmlrz1iib8bd
###




########## HELPER FUNCTIONS

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

### Helper Function: download()
# Downloads a given Linux SSF2 version
# Argument 1: "native", "wine_inst" or "wine_port"
function download() {

	# Notify
	echo "This may take some time, please keep the terminal open..."
	
	# Install wget if needed
	install "wget"

	# TEST
	echo "Download function"

	# Get 
	#wget https://www.supersmashflash.com/play/ssf2/downloads/
	#cat dwl.html | grep -Eo "(http|https)://[a-zA-Z0-9./?=_%:-]*" | sort -u | grep "https://cdn.supersmashflash.com/ssf2/downloads"
	#grep by chosen version? 
	# Make games folder and let user know
	# put in variable.  hardcode for now
	#cd ~/Games/SSF2
	## download URL/file to folder
}







########## ACTUAL SCRIPT


### Starting message
echo "#### INSTALL SSF2 ON LINUX #### - by davo#1776"
echo ""


### Get desired version
echo "# Which version would you like to install?"
echo " A) Native"
echo " B) Wine Installer"
echo " C) Wine Portable"
echo "To help you decide, check the guide: https://docs.google.com/document/d/1l5VrAaWmLozu9qnwdjz6MGA9GyurlkgNF8t72eZ4-54/edit#heading=h.cmlrz1iib8bd ."
echo "If you are not sure, choose B (Wine Installer)."
echo "Type the letter of your desired version and press enter."
echo "Choice (A or B or C):"
read chosen_version


### Check choice

# Version booleans
native=false
wine_inst=false
wine_port=false

# Process user input
if [ "$chosen_version" = "A" ]; then
	native=true
	
elif [ "$chosen_version" = "B" ]; then
	wine_inst=true
	
elif [ "$chosen_version" = "C" ]; then
	wine_port=true
else
	echo "Invalid choice!"
	echo "Please run the script again"
	exit
fi




# Space
echo ""


# Set install path
installPath="~/Games/SSF2"

# Make folder (or do nothing if it exists already)
mkdir -p $installPath




##### Install Native Version
if [ "$native" = true ]; then

	# Notify
	echo "Installing Native Version..."
	read -p "Press any key to continue..."

	# Download
	echo "Downloading native version..."
	download $installPath "native"

	# Extract
	echo "Extracting..."
	install "tar"
	# cd LOCATION
	#tar -xf SSF2BetaLinux.*.tar --one-top-level

	# Run fix script
	#cd SSF2BetaLinux.*/
	#chmod u+x trust-ssf2.sh && ./trust-ssf2.sh

	# you can add this to your bashrc so you can start ssf2 from anywhere
	# function ssf2 {
        # cd ~/Downloads/SSF2_Folder
        # ./SSF2
	# }

	# Notify
	#For the Native Linux version, there is no replay autosave option in the Data menu.
fi






##### Wine 
if [ "$wine_inst" = true  ] || [ "$wine_port" = true  ]; then
    echo "Getting wine pre-reqs"
	echo ""
fi

# 1. pre reqs
## Enable 32-bit packages with the command: 
#sudo dpkg --add-architecture i386
## Update package lists with new 32 bit packages with: 
#sudo apt update
## Install wine and wine32 with: 
#sudo apt install wine wine32 winbind -y
## Install SSF2 packages
# Enable 32 bit packages and update package list
# sudo dpkg --add-architecture i386
# echo ""
# sudo apt update -y
# echo ""

#Install wine
# install "wine"
# echo ""
# install "wine32"
# echo ""
# install "winbind"
# echo ""




##### Install Wine Installer Version
if [ "$wine_inst" = true ]; then

	echo "Installing wine installer version"

fi
# Notify: An installer window will appear. Follow the prompts.
# 2. open with wine
# wine SSF2BetaSetup.32bit.*.exe

# Print
#To run the game on Ubuntu:
#Press your Windows key to search then type “Super”. SSF2 should come up as it is now in your list of applications. Just click on it to start the game.
#You can also right-click on the app after finding it in search and add it to favourites for easier future access.





##### Wine Portable
if [ "$wine_port" = true ]; then

	echo "Installing wine portable version"

fi

## Extract
#sudo apt-get install unzip -y
# unzip -d WINE_SSF2_PORTABLE SSF2BetaWindows.32bit.*.portable.zip

#cd WINE_SSF2_PORTABLE/*
#wine SSF2.exe

## 4. you can add this to your bashrc so you can start ssf2 from anywhere
# function wine_ssf2 {
        # cd ~/Downloads/SSF2_Folder
        # wine SSF2.exe
# }

#For the Wine Linux version (Installer and Portable), the replay folder path will be something like:
#/home/david/.wine/drive_c/users/david/SSF2Replays




# Finish up
echo ""
echo "FINISHED!"
echo ""
echo "Enjoy playing SSF2 on Linux!"
exit




