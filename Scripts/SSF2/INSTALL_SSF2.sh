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
### 1. Open the folder where you want SSF2 to be installed with your File Manager GUI.
### 2. Right click in it and select "Open in Terminal".
### 3. Paste in this command to get the script: "wget  https://github.com/DavoDC/LinuxFiles/raw/main/Scripts/SSF2/INSTALL_SSF2.sh"
### 4. Enable the script using: "chmod u+x INSTALL_SSF2.sh"
### 5. Run the script using: "./INSTALL_SSF2.sh" and follow the prompts
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

	# If not installed
	if isNotInstalled $1; then

		# Install it unattended
		sudo apt install $1 -y
	fi
}

### Helper Function: download()
# Downloads a given Linux SSF2 version
function download() {

	# Notify
	echo "Downloading $version_desc Version..."
	echo "This may take some time, please keep the terminal open..."
	echo ""
	
	# Install wget if needed
	install "wget"

	# Go into folder
	cd $installPath

	## Extract download URLs
	echo "Extracting download URLs from official site.."
	echo ""

	# Download official download page as HTML
	wget -q https://www.supersmashflash.com/play/ssf2/downloads/ -O dwl.html 

	# Holder
	dwlURL=""

	# Extract from HTML
	if [ "$native" = true ]; then
		dwlURL="$( cat 'dwl.html' | grep -Eo "(http|https)://[a-zA-Z0-9./?=_%:-]*" | sort -u | grep "https://cdn.supersmashflash.com/ssf2/downloads" | grep "SSF2BetaLinux" )"
	
	elif [ "$wine_inst" = true ]; then
		dwlURL="$( cat 'dwl.html' | grep -Eo "(http|https)://[a-zA-Z0-9./?=_%:-]*" | sort -u | grep "https://cdn.supersmashflash.com/ssf2/downloads" | grep "SSF2BetaSetup.32bit.*.exe"  )"

	elif [ "$wine_port" = true ]; then
		dwlURL="$( cat 'dwl.html' | grep -Eo "(http|https)://[a-zA-Z0-9./?=_%:-]*" | sort -u | grep "https://cdn.supersmashflash.com/ssf2/downloads" | grep "SSF2BetaWindows.32bit.*.portable.zip" )"

	fi

	# Remove HTML download
	rm 'dwl.html'

	# Download file
	wget $dwlURL

	# Space
	echo ""
}


### Helper Function: printYellow()
# Prints a string in yellow
# Argument 1: String
yellow='\033[0;33m'
nc='\033[0m'
function printYellow() {
	printf "${yellow}$1${nc}"
}




########## ACTUAL SCRIPT


### Starting message
clear
echo "#### INSTALL SSF2 ON LINUX #### - by davo#1776"
echo ""


### Get desired version
echo "Which version would you like to install?"
echo " A) Native"
echo " B) Wine Installer"
echo " C) Wine Portable"
echo ""
echo "To help you decide, check the guide:"
guide="https://docs.google.com/document/d/1l5VrAaWmLozu9qnwdjz6MGA9GyurlkgNF8t72eZ4-54/edit#heading=h.cmlrz1iib8bd"
printYellow $guide
echo ""
echo ""
echo "If you are not sure, choose B (Wine Installer)."
echo ""
echo "Type the letter of your desired version and press enter."
echo "Choice (A or B or C):"
read chosen_version


### Check choice

# Version booleans
native=false
wine_inst=false
wine_port=false

# Version string/description
version_desc=""

# Process user input
if [ "$chosen_version" = "A" ]; then
	native=true
	version_desc="Native"
	
elif [ "$chosen_version" = "B" ]; then
	wine_inst=true
	version_desc="Wine Installer"
	
elif [ "$chosen_version" = "C" ]; then
	wine_port=true
	version_desc="Wine Portable"

else
	echo "Invalid choice!"
	echo "Please run the script again"
	exit
fi



# Space
echo ""
echo ""
echo ""




####### COMMON TASKS


# Notify/confirm
echo "Installing $version_desc Version..."
read -p "Press any key to continue......"
echo ""


### Setup install folder

# Retrieve the directory in which this script is running
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Determine the install path
installPath=$script_dir/SSF2

# Make folder (or do nothing if it exists already)
mkdir -p $installPath


### Download version file
download


### Install canberra library
install "libcanberra-gtk-module"






##### Install Native Version
if [ "$native" = true ]; then

	# Extract
	echo "Extracting downloaded archive..."
	echo ""
	install "tar"
	tar -xf SSF2BetaLinux.*.tar --one-top-level

	# Go into created folder
	cd SSF2BetaLinux.*/

	# Run fix script
	echo "Running fix script..."
	echo ""
	chmod u+x trust-ssf2.sh && ./trust-ssf2.sh
	echo ""

	# Give bashrc function tip
	nativePath="$(pwd)"
	echo "Tip 1:"
	echo "If you add this to your bashrc file,"
	echo "you can start ssf2 from anywhere."
	printYellow " function ssf2 {"
    printYellow "\n    cd $nativePath"
    printYellow "\n    ./SSF2"
	printYellow "\n }"
	echo ""
	echo ""

	# Give replay folder tip
	echo "Tip 2:"
	echo "For the Native Linux version,"
	echo "there is no replay autosave option in the Data menu."
	echo "Thus there is no autosaved replay folder for this version."
fi






##### Wine
if [ "$wine_inst" = true  ] || [ "$wine_port" = true  ]; then
    echo "Installing Wine..."
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
echo ""
echo ""
echo "FINISHED!"
echo ""
echo "Enjoy playing SSF2 on Linux!"
echo ""
exit




