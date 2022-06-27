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




##### HELPER FUNCTIONS

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








##### ACTUAL SCRIPT
# Notify user
echo "#### INSTALL SSF2 ON LINUX ### - by davo#1776"
echo ""


# Ask user which type is wanted
# If you are not sure, choose WIne Installer
# Can check guide to help you decide
# https://docs.google.com/document/d/1l5VrAaWmLozu9qnwdjz6MGA9GyurlkgNF8t72eZ4-54/edit#heading=h.cmlrz1iib8bd



# Make games folder and let user know
# put in variable.  hardcode for now
#cd ~/Games/SSF2


## DOWNLOAD FILE
#use gensetup function
#install "wget"
#echo ""
#wget https://www.supersmashflash.com/play/ssf2/downloads/
#cat dwl.html | grep -Eo "(http|https)://[a-zA-Z0-9./?=_%:-]*" | sort -u | grep "https://cdn.supersmashflash.com/ssf2/downloads"
#grep by chosen version? 
## download URL/file


##### Native 
## 1. extract
#install "tar"
#
#tar -xf SSF2BetaLinux.*.tar --one-top-level
## 2. enter folder created 
# cd SSF2BetaLinux.*/
## 3. run fix script
#chmod u+x trust-ssf2.sh && ./trust-ssf2.sh
## 4. you can add this to your bashrc so you can start ssf2 from anywhere
# function ssf2 {
        # cd ~/Downloads/SSF2_Folder
        # ./SSF2
# }
#For the Native Linux version, there is no replay autosave option in the Data menu.



##### Wine 
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




##### Wine Installer
# Notify: An installer window will appear. Follow the prompts.
# 2. open with wine
# wine SSF2BetaSetup.32bit.*.exe

# Print
#To run the game on Ubuntu:
#Press your Windows key to search then type “Super”. SSF2 should come up as it is now in your list of applications. Just click on it to start the game.
#You can also right-click on the app after finding it in search and add it to favourites for easier future access.





##### Wine Portable

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





