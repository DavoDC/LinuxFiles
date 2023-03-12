#!/usr/bin/env bash

### SCRIPT THAT LETS SSF2 RUN ON LINUX ###
###
### Brief Description: Sets the SSF2 data folder as a Trusted Location for Adobe Flash Player
###
### Author: davo#1776
###
### First Created: 07/08/21
###
### Tested On: Ubuntu 20.04.2.0 LTS (Focal Fossa), Manjaro 
###
### Usage:
### 1. Open the folder where your Native Linux SSF2 has been installed.
### 2. Right click in it and select "Open in Terminal".
### 3. Paste in this command to get the script: "wget https://raw.githubusercontent.com/DavoDC/LinuxFiles/main/Scripts/SSF2/TRUST_SSF2_HERE.sh"
### 4. Enable the script using: "chmod u+x TRUST_SSF2_HERE.sh"
### 5. Run the script using the command: "./TRUST_SSF2_HERE.sh", and close the terminal
### 6. Restart SSF2 and it will load beyond 5%!!!
###
###
### Usage Notes:
### - If you move your SSF2 installation to a new directory, you will need to re-run the script there
### - The script supports having multiple installations of SSF2 in different folders that are trusted
### - If the game updates and your SSF2 directory path changes, you will need to re-run the script
###
### Detailed Description (The Purpose/Background of this Script):
### - When you download, extract and execute the native Linux version of SSF2, it doesn't load.
### - The game gets stuck at 5% in the loading screen, because it cannot access the game's data files.
### - These data files (e.g. DAT0.ssf, DAT1.ssf etc.) are in the 'data' folder next to the executable
### - Linux Adobe Flash Player (AFP) will only load from folders that are "Trusted Locations"
### - Since the 'data' folder hasn't been set as "Trusted", the game cannot load the required files
### - To make a folder "Trusted", Adobe advises you to right click on the AFP window and select Global Settings
### - Clicking this sends you to webpage with an online settings manager that runs on Flash
### - This settings manager can set folders as "Trusted", but since its runs on Flash you can't really run it
### - You cannot run it as Flash has been removed from everywhere as it has reached its end of life
### - Thus you cannot access the settings manager, which leads to SSF2 not loading
### - What this script does is create the same setting file that the settings manager would've created
### - It sets the data folder next to where it is ran as "Trusted", letting SSF2 load
### - So this script is a workaround/alternative to using Adobe's Global Settings Manager

# Store the Adobe Flash Player setting file directory path
SETTINGS_DIR=~/.macromedia/Flash_Player/'#Security'/FlashPlayerTrust

# Make settings file directory folders (or do nothing if it exists already)
mkdir -p $SETTINGS_DIR

# Retrieve the directory in which this script is running
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Determine the SSF2 Data folder path (assuming the script is being ran next to it)
DATA_DIR=$SCRIPT_DIR/data

# Create settings file (or append to it)
echo $DATA_DIR >> $SETTINGS_DIR/SSF2.cfg

# Notify user
echo "RUNNING LINUX SSF2 FIX - by davo#1776"
echo ""
echo "Settings file created/updated:"
echo "'$SETTINGS_DIR/SSF2.cfg'"
echo ""
echo "This directory has been added as a Trusted Location for Adobe Flash Player:"
echo "'$DATA_DIR'"
echo ""
echo "This copy of SSF2 has been fixed successfully! Enjoy playing SSF2 on Linux!"
echo ""

