
# Sets up config files (bashrc and profile)
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


# Notify
echo ""
echo "### Backing up original configuration files ($brc and $prof) into a folder..."


# Check if originals folder exists
origname="originals"
echo ""
echo "# Attempting to create backup folder"
echo "Checking if '$origname' folder exists..."
if [ ! -d  $origname ]; then 

	# If originals folder does not exist 
	echo "'$origname' hasn't been made, thats good"
	echo "Making folder called '$origname'..."
	
	# Make originals folder
	mkdir $origname
else

    # If originals folder does exist
	echo "'$origname' has been made already!"
	echo "Your system is probably already configured!"
	echo "You may want to continue anyway... or not"
	
	# Ask if would like to continue
	ask_continue
fi


# Helper function to move file and check
# Arg 1: File name (e.g. log.txt)
# Arg 1: File path (e.g. ~/log.txt)
# Arg 2: Destination folder path (e.g. ~/things)
# So new filepath will be ~/things/log.txt
function move_file_and_check() {

	# Get signature
	sig="${FUNCNAME[0]}'('$1', '$2', '$3')"
	
	# Get parameters
	filename=$1
	filepath=$2
	destpath=$3
	
	# Final path
	finalpath=$destpath/$filename
	
	# Move file into destination folder
	if mv $filepath $finalpath; then
	
		# If commanded succeeded 
	
		# Do extra check:
		# If file exists in new directory
		if [ -f "$finalpath" ]; then
			
			# Notify
			echo "$sig definitely successful!"
		fi
	else
	
		# Else if command failed,
		# notify
		echo "'$sig issue!!!"
		
		# Ask
		ask_continue
	fi
}


# Move original .bashrc and .profile in there
echo ""
echo "# Moving original '$brc' and '$prof' files into the folder..."
move_file_and_check "$brc"  "~/.bashrc" "~/$origname"
move_file_and_check "$prof" "~/.profile"  "~/$origname"






# Notify
echo ""
echo ""
echo "### Creating links to repo configuration files.."

# Check if repo exists
reponame="LinuxFiles"
echo ""
echo "# Checking if '$reponame' repo exists... (it should as you should be running this from it!)"
if [ ! -d $reponame ]; then 

	# If repo does not exist
	echo "'$reponame' repo doesn't exist in home directory!"
	echo "Go to home and git clone it!"
	echo "Exiting..."
	echo ""
	exit
else

	# If repo does exist
	echo "'$reponame' repo found! Continuing.."
fi


# Make symlinks to repo versions
echo ""
echo "# Making symlinks to repo config files!"
ln --symbolic "/home/david/LinuxFiles/Config/$brc" "$brc"
ln --symbolic "/home/david/LinuxFiles/Config/$prof" "$prof"


# Finalize
echo ""
echo "### Configuration finished!"
echo "You should see the symlinks and backup folder '$origname'"
ls -al --color=auto ~
echo ""




