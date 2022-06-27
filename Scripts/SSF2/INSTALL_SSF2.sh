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
####  - Note: A folder named 'SSF2' will be created here
### 2. Right click in it and select "Open in Terminal".
### 3. Paste in this command to get the script: "wget https://github.com/DavoDC/LinuxFiles/raw/main/Scripts/SSF2/INSTALL_SSF2.sh"
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


### Helper Function: printYellow()
# Prints a string in yellow
# Argument 1: String
yellow='\033[0;33m'
nc='\033[0m'
function printYellow() {
	printf "${yellow}$1${nc}"
}


### Helper Function: giveBashrcAdvice()
# Print advice regarding bashrc functions
# Argument 1: Run Command
# Argument 2: Function Name
function giveBashrcAdvice() {
	echo ""
	echo "Advice on running the game ($version_desc Version):"
	echo "You have to open a terminal in the"
	echo "'$(pwd)' folder/directory,"
	echo "and type '$1'."
	echo ""
	echo "To make starting it easier, you can add a function to your '~/.bashrc' file."
	echo "If you add this to your '~/.bashrc' file, you can start SSF2 from anywhere."
	printYellow " function $2 {"
    printYellow "\n    cd "$(pwd)""
    printYellow "\n    $1"
	printYellow "\n }"
	echo ""
	echo "Once this is set up, type '$2' to start the game from any terminal."
	echo ""
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
echo "To help you decide, check the comparison table in the Player Guide:"
printYellow "https://docs.google.com/document/d/1l5VrAaWmLozu9qnwdjz6MGA9GyurlkgNF8t72eZ4-54/edit#heading=h.cmlrz1iib8bd"
echo ""
echo ""
echo "If you are not sure, choose/type 'C'."
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


### Install canberra library
install "libcanberra-gtk-module"


### Setup install folder

# Retrieve the directory in which this script is running
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Determine the install path
installPath=$script_dir/SSF2

# Make folder (or do nothing if it exists already)
mkdir -p $installPath



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

# Download chosen SSF2 version file
wget $dwlURL

# Space
echo ""







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

	# Print advice regarding bashrc functions
	# Argument 1: Run Command
	# Argument 2: Function Name
 	giveBashrcAdvice "./SSF2" "native_ssf2"

	# Give replay folder tip
	echo "For the Native Linux version,"
	echo "there is no replay autosave option in the Data menu."
	echo "Thus there is no autosaved replay folder for this version."
fi




##### Wine
if [ "$wine_inst" = true  ] || [ "$wine_port" = true  ]; then
    echo "Installing Wine..."
	echo ""

	# Enable 32-bit packages
	sudo dpkg --add-architecture i386

	# Update package lists with new 32 bit packages (quietly)
	sudo apt update > /dev/null 2>&1

	# Install wine libraries
    install "wine"
	install "wine32"
	install "winbind"

fi




##### Install Wine Installer Version
if [ "$wine_inst" = true ]; then

	# Notify
	echo "An installer window will soon appear."
	echo "You will need to follow the prompts."
	read -p "Press any key when you're ready....."

	# Open Windows installer with Wine
	wine SSF2BetaSetup.32bit.*.exe

	# Give advice
	echo ""
	echo ""
	echo "Advice on making the game easier to start on Ubuntu:"
	echo "Press your Windows key to search then type 'Super'."
	echo "SSF2 should come up as it is now in your list of applications."
	echo "Just click on it to start the game."
	echo ""
	echo "You can also right-click on the app after finding it in search,"
	echo "and add it to favourites for easier future access."
	echo ""
	echo "You can also copy the '.desktop' file to your desktop,"
	echo "right click on it, and enable/allow launching,"
	echo "to get a desktop shortcut."
	echo ""
fi



##### Install Wine Portable Version
if [ "$wine_port" = true ]; then

	# Extract
	echo "Extracting downloaded archive..."
	echo ""
	install "unzip"
	unzip -qq SSF2BetaWindows.32bit.*.portable.zip

	# Go into created folder
	cd SSF2BetaWindows.32bit.*.portable

	# Print advice regarding bashrc functions
	# Argument 1: Run Command
	# Argument 2: Function Name
 	giveBashrcAdvice "wine SSF2.exe" "wine_ssf2"

fi








##### Wine Autosaved Replay Path Tip
if [ "$wine_inst" = true  ] || [ "$wine_port" = true  ]; then
    echo ""
	echo "Note about Autosaved Replay Path:"
	echo "For both wine versions (Installer and Portable),"
	echo "the autosaved replay folder path will be something like:"
	echo "/home/$USER/.wine/drive_c/users/$USER/SSF2Replays"
fi






# Finish up
echo ""
echo ""
echo ""
echo "FINISHED!"
echo ""
echo "If you have any issues, check the Linux Troubleshooting section in the Player Guide:"
printYellow "https://docs.google.com/document/d/1l5VrAaWmLozu9qnwdjz6MGA9GyurlkgNF8t72eZ4-54/edit#heading=h.3i7wifh0e5nc"
echo ""
echo ""
echo "Enjoy playing SSF2 on Linux!"
echo ""
exit




