#!/usr/bin/env bash



########## VARIABLES

# The directory in which this script is running
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Dotfile names
bashrc=".bashrc"
prof=".profile" # Linux only

# The folder in which the script will look for dotfiles
dotfiles_path="$script_dir/Actual"

# Dotfile paths
bashrc_path="$dotfiles_path/$bashrc"
prof_path="$dotfiles_path/$prof" # Linux only

### Windows Git Bash mintty variables
# What needs '.bashrc' to be renamed to
bashprof=".bash_profile"

# Where it expects the file to be
win_bashrc_dest="/c/Users/$USERNAME/$bashprof"



########## HELPER FUNCTIONS
# Helper Function for Continue Prompt
function ask_continue () {
    read -p "Would you like to continue (y/n)? " choice
    case "$choice" in
        y|Y ) echo "Continuing...";;
        n|N ) echo "Exiting..." && echo "" && exit;;
        * ) exit;;
    esac
}

##### Linux Functions
# function move_file_and_check () {
#     sig="${FUNCNAME[0]}'('$1', '$2')"
#     filename=$1
#     destname=$2
#     finalpath=$destname/$filename

#     if mv $filename $finalpath; then
#         if [ -f "$finalpath" ]; then
#             echo "$sig definitely successful!"
#         fi
#     else
#         echo "'$sig issue!!!"
#         ask_continue
#     fi
# }

# function remove_if_symlink () {
#     echo ""
#     if [ -L "$1" ]; then
#         if rm "$1"; then
#             echo "'$1' symlink successfully removed!"
#         fi
#     else
#         echo "'$1' is not a symlink!!!"
#         if [ -f "$1" ]; then
#             echo "'$1' is a regular file, likely the original"
#             echo "Danger!!! Exiting!!!"
#             exit
#         fi
#         if [ ! -e "$1" ]; then
#             echo "'$1' does not exist as any type of file"
#             echo "Strange..."
#             ask_continue
#         fi
#     fi
# }

# function configure_linux () {
#     # Go to home
#     echo "### Going to home directory..."
#     cd ~

#     # Notify
#     echo "### Backing up original configuration files ($linux_brc and $linux_prof) into a folder..."
#     origname="originals"

#     echo "# Attempting to create backup folder"
#     if [ ! -d $origname ]; then
#         echo "'$origname' hasn't been made, that's good"
#         echo "Making folder called '$origname'..."
#         mkdir $origname
#     else
#         echo "'$origname' has been made already!"
#         echo "Your system is probably already configured!"
#         echo "You may want to continue anyway... or not"
#         ask_continue
#     fi

#     echo "# Moving original '$linux_brc' and '$linux_prof' files into the folder..."
#     move_file_and_check "$linux_brc" "$origname"
#     move_file_and_check "$linux_prof" "$origname"

#     # Notify
#     echo "### Creating links to repo configuration files..."
#     reponame="LinuxFiles"
#     if [ ! -d $reponame ]; then
#         echo "'$reponame' repo doesn't exist in home directory!"
#         echo "Go to home and git clone it! Exiting..."
#         exit
#     else
#         echo "'$reponame' repo found! Continuing..."
#     fi

#     echo "# Making symlinks to repo config files!"
#     ln --symbolic "$linux_repopath/$linux_brc" "$linux_brc"
#     ln --symbolic "$linux_repopath/$linux_prof" "$linux_prof"

#     echo "### Configuration finished!"
#     ls -al --color=auto ~
#     echo "Close and reopen the terminal and it should look different"
#     echo "Use 'showbrc' to see what commands are available"
# }

# function unconfigure_linux () {
#     # Go to home
#     echo "### Going to home directory..."
#     cd ~

#     # Remove symlinks
#     echo "### Removing symlinks to repo config files"
#     remove_if_symlink "$linux_brc"
#     remove_if_symlink "$linux_prof"

#     # Move back originals
#     echo "### Moving original configuration files back"
#     origname="originals"
#     mv "$origname/$linux_brc" "$linux_brc"
#     mv "$origname/$linux_prof" "$linux_prof"

#     # Delete empty originals folder
#     echo "# Deleting empty originals folder"
#     rmdir "$origname"

#     echo "### UN-configuration finished!"
#     ls -al --color=auto ~
# }


##### Windows Functions
function configure_windows () {

    # Notify user of plans and ask to continue
    echo "The script will copy '$bashrc' to '$win_bashrc_dest'."
    echo ""
    if [ -f "$win_bashrc_dest" ]; then
        echo "A '$bashprof' file already exists there - it will be overwritten."
    else
        echo "No '$bashprof' file currently exists there, so this file will be created."
    fi
    echo ""
    ask_continue

    # Copy file over and rename at same time
    echo ""
    echo "Copying '$bashrc' to '$win_bashrc_dest'..."
    cp "$bashrc_path" "$win_bashrc_dest"

    # Add note to copied file 
    echo "" 
    echo "Adding message to top of copied file..."
    echo "### THIS IS A COPY OF .BASHRC FOR GIT MINTTY BASH, DO NOT EDIT ###" | cat - "$win_bashrc_dest" > temp_file && mv temp_file "$win_bashrc_dest"
}

# function unconfigure_windows () {
#     # Set source and destination folders
#     dest="$windows_dest"
#     bprof="${dest}.bash_profile"

#     # Check if .bash_profile exists
#     if [ -f "$bprof" ]; then
#         # Remove the .bash_profile
#         rm -f "$bprof"
#         echo "Removed .bash_profile"
#     fi

#     echo "Unconfiguration for Windows complete!"
# }



############### ACTUAL SCRIPT STARTS HERE

# Clear and show start message
clear
echo ""
echo "###### DOTFILES CONFIGURATION SCRIPT ######"

# Detect current operating system
detected_os=""
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    detected_os="Linux"
elif [[ "$OSTYPE" == "msys" ]]; then
    detected_os="Windows"
else
    echo -e "Operating System Detection Error!"
    exit 1
fi

# Determine desired action
echo ""
echo "Do you want to configure or unconfigure your dotfiles on this $detected_os system?"
echo "1) Configure"
echo "2) Unconfigure"
read -p "Choose an option (1/2): " action

# Execute desired action
echo ""
action_msg="dotfiles on your $detected_os system..."
case "$action" in
    1)
        echo "Configuring $action_msg"
        echo ""

        # If configuring dotfiles, check they can be found
        if [[ ! -f "$bashrc_path" || ! -f "$prof_path" ]]; then
            echo "Could not find dotfiles ('$bashrc', '$prof') in '$dotfiles_path'!"
            echo "Exiting..."
            echo ""
            exit 1
        fi

        if [ "$detected_os" == "Linux" ]; then
            # configure_linux
            echo "Untested..."
        elif [ "$detected_os" == "Windows" ]; then
            configure_windows
        fi
        ;;
    2)
        echo "Unconfiguring $action_msg"
        echo ""
        if [ "$detected_os" == "Linux" ]; then
            # unconfigure_linux
            echo "Untested..."
        elif [ "$detected_os" == "Windows" ]; then
            # unconfigure_windows
            echo "Untested..."
        fi
        ;;
    *)
        echo "Invalid choice. Exiting..."
        exit 1
        ;;
esac

# Finished
echo ""
echo "###### FINISHED ######"