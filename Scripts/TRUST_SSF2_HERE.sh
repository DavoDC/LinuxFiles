
### SCRIPT THAT LETS SSF2 RUN ON LINUX
### Sets the SSF2 data folder as a Trusted Location for Flash Player
### USAGE:
### 1. In your file explorer, open the folder where you have extracted the Linux version of SSF2 
### 2. In this folder you should see the SSF2 executable and the 'data' folder
### 3. Put this script in that folder, next to the executable
### 4. Right click and do "Open Terminal Here", to open your terminal to the folder
### 5. Run the script using the command: "./TRUST_SSF2_HERE.sh", and close the terminal
### 6. Restart SSF2 and it will load beyond 5%!!!
###
### Author: davo#1776
### First Created: 07/08/21

# Set the Adobe Flash setting file directory 
SETTINGS_DIR=~/.macromedia/Flash_Player/#Security/FlashPlayerTrust

# Make settings file directory folders (or do nothing if it exists already)
mkdir -p $SETTINGS_DIR

# Retrieve the directory in which this script is running
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Determine the SSF2 Data folder path (assuming the script is being ran next to it)
DATA_DIR=$SCRIPT_DIR/data

# Create settings file (or append to it)
echo $DATA_DIR >> $SETTINGS_DIR/SSF2.cfg

# Notify
echo "This directory has been added as a Trusted Location for Adobe Flash Player:"
echo "'$DATA_DIR'"
echo "This copy of SSF2 has been fixed successfully!"

