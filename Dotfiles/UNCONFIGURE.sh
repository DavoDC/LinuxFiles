#!/bin/bash

# Undoes the actions of the configuration script
# Restores original configuration files (bashrc and profile)
# Very fast


# Variables
brc=".bashrc"
prof=".profile"


# Helper Function
function ask_continue () {

	read -p "Would you like to continue (y/n)? " choice
	case "$choice" in 
	  y|Y ) echo "Continuing...";; # true
	  n|N ) echo "Exiting! " && exit;;
	  * ) exit;;
	esac
}


# Go to home
echo "### Going to home directory..."
cd ~


# Helper Function for Removing Symlinks
# Arg 1: Path to symlink
function remove_if_symlink () {

	# Space
	echo ""
	
	# Check if file 
	# Note: '-L' returns true if the "file" exists and is a symbolic link 
	# (the linked file may or may not exist!). 
	if [ -L "$1" ]; then 

		# If file is an existing symlink, delete it 
		if rm "$1"; then
			echo "'$1' symlink successfully removed!"
		fi
	else
	    
		# If file is NOT a symlink
		# Notify
		echo "'$1' is not a symlink!!!"
		echo "The system wasn't configured properly in the first place!"
		
		# If file is a regular file
		if [ -f "$1" ]; then 
			echo "'$1' is a regular file, likely the original"
			echo "Danger!!!"
			echo "Exiting!!!"
			exit
		fi
		
		# If file does not exist 
		if [ ! -e "$1" ]; then 
			echo "'$1' does not exist as any type of file"
			echo "Strange..."
			ask_continue
		fi

	fi
}



# Remove symlinks
echo ""
echo "### Removing symlinks to repo config files"
remove_if_symlink "$brc"
remove_if_symlink "$prof"






# Move back originals
echo ""
echo "### Moving original configuration files back"


# Moving from originals to home
echo ""
echo "# Moving original files back to their initial location"
origname="originals"
mv "$origname/$brc" "$brc"
mv "$origname/$prof" "$prof"


# Delete empty originals folder
echo ""
echo "# Deleting empty originals folder"
rmdir "$origname"


# Finalize
echo ""
echo "### UN-configuration finished!"
echo "You should see no symlinks or backup folder '$origname', just original files outside"
ls -al --color=auto ~
echo ""




