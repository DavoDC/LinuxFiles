
# Sets up config files
# Very fast

# Show all commands
set -x

# Go to home
cd ~

# Make originals folder
mkdir originals

# Move original .bashrc and .profile in there
mv ~/.bashrc ~/originals/.bashrc
mv ~/.profile ~/originals/.profile

# Check operations
ls -a ~/originals
read -p "Does the above look correct (have 2 files) (y/n)? " choice
	case "$choice" in 
	  y|Y ) echo "Continuing...";; # true
	  n|N ) echo "Stopped! " && exit;;
	  * ) exit;;
	esac

# Check repo
# If repo does not exist
if [ ! -d "LinuxFiles" ] 
then
	# Notify
	echo "Linux repo doesn't exist in home directory!"
	echo ""
	exit
fi

# Make symlinks to repo versions
echo "Making symlinks!"
ln --symbolic "/home/david/LinuxFiles/Config/.bashrc" ".bashrc"
ln --symbolic "/home/david/LinuxFiles/Config/.profile" ".profile"



