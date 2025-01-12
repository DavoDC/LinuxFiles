#!/usr/bin/env bash



########## VARIABLES

# Name of the repo (folder) in which this script and the dotfiles are held
linux_repo="LinuxFiles"

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

# Name of the dotfiles backup folder on Linux
backup_dir="originalDotFiles"

### Windows Git Bash mintty variables
# What needs '.bashrc' to be renamed to
bashprof=".bash_profile"

# Where Git Bash expects the file to be
win_bashrc_dest="/c/Users/$USERNAME/$bashprof"



########## HELPER FUNCTIONS
# Ask user whether they want to continue
function ask_continue () {
    read -p "Would you like to continue (y/n)? " choice
    case "$choice" in
        y|Y ) echo "Continuing...";;
        n|N ) echo "Exiting..." && echo "" && exit;;
        * ) exit;;
    esac
}

# Run command and check exit code
function run_and_check() {
    local command="$1" # The comamnd
    local action_desc="$2" # A description of action in present tense (e.g. 'move file')
    local quiet_success="$3" # Set to "quiet_success" for no output upon success

    if eval "$command"; then
        if [ "$quiet_success" != "quiet_success" ]; then
            echo "Action successful! ($action_desc)"
        fi
    else
        if [ -n "$action_desc" ]; then
            echo "Error: '$command' failed (couldn't $action_desc)."
        else
            echo "Error: '$command' failed."
        fi
        exit 1
    fi
}

# Remove the symbolic link at the given path
# Arg 1: Path to symbolic link
function remove_if_symlink () {
    echo ""
    if [ -L "$1" ]; then
        run_and_check "rm \"$1\"" "remove symlink"
    elif [ -f "$1" ]; then
        echo "Error: '$1' is a regular file. Exiting..."
        exit 1
    elif [ ! -e "$1" ]; then
        echo "Error: '$1' does not exist. Exiting..."
        exit 1
    fi
}



##### Linux Functions
function configure_linux () {
    # Go to home
    echo "Going to home directory..."
    cd ~

    ### Backup original files

    # Create folder for backups
    echo "Backing up original configuration files ($bashrc and $prof) into a folder ('$backup_dir')..."
    if [ ! -d $backup_dir ]; then
        echo "'$backup_dir' does not exist yet. Making folder called '$backup_dir'..."
        run_and_check "mkdir \"$backup_dir\"" "create '$backup_dir'"
    else
        echo "'$backup_dir' already exists, which means your system is probably already configured!"
        ask_continue
    fi

    # Move dotfiles into backup folder
    echo "Moving original '$bashrc' and '$prof' files into the folder..."
    run_and_check "mv \"$bashrc\" \"$backup_dir/$bashrc\"" "move file '$bashrc' to '$backup_dir'."
    run_and_check "mv \"$prof\" \"$backup_dir/$prof\"" "move file '$prof' to '$backup_dir'."

    ### Create symlinks to dotfiles in repo
    echo "Creating links to repo configuration files..."

    # Check repo
    if [ ! -d $linux_repo ]; then
        echo "'$linux_repo' repo doesn't exist in home directory!"
        echo "Go to home and git clone it! Exiting..."
        exit
    else
        echo "'$linux_repo' repo found in home directory! Continuing..."
    fi

    # Make symlinks
    echo "Making symlinks to repo config files!"
    run_and_check "ln --symbolic \"$linux_repopath/$bashrc\" \"$bashrc\"" "create symlink"
    run_and_check "ln --symbolic \"$linux_repopath/$prof\" \"$prof\"" "create symlink" "quiet_success"
}

function unconfigure_linux () {
    # Go to home
    echo "Going to home directory..."
    cd ~

    # Remove symlinks
    echo "Removing symlinks to repo config files"
    remove_if_symlink "$bashrc"
    remove_if_symlink "$prof"

    # Move back originals
    echo "Moving original dotfiles back"
    backup_dir="originals"
    run_and_check "mv \"$backup_dir/$bashrc\" \"$bashrc\"" "move '$backup_dir/$bashrc' to '$bashrc'"
    run_and_check "mv \"$backup_dir/$prof\" \"$prof\"" "move '$backup_dir/$prof' to '$prof'"

    # Delete empty originals folder
    echo "Deleting empty originals folder"
    run_and_check "rmdir \"$backup_dir\"" "remove '$backup_dir' folder"
}



##### Windows Functions
function configure_windows () {

    # Notify user of plans
    echo "The script will copy '$bashrc' to '$win_bashrc_dest'."
    echo ""
    if [ -f "$win_bashrc_dest" ]; then
        echo "A '$bashprof' file already exists there - it will be overwritten."
    else
        echo "No '$bashprof' file currently exists there, so this file will be created."
    fi

    # Copy file over and rename at same time
    echo ""
    echo "Copying '$bashrc' to '$win_bashrc_dest'..."
    run_and_check "cp \"$bashrc_path\" \"$win_bashrc_dest\"" "copy file"

    # Add note to copied file
    echo "" 
    echo "Adding message to top of copied file..."
    echo "### THIS IS A COPY OF .BASHRC FOR GIT MINTTY BASH, DO NOT EDIT ###" | cat - "$win_bashrc_dest" > temp_file && mv temp_file "$win_bashrc_dest"
}

function unconfigure_windows () {

    # If the file exists
    if [ -f "$win_bashrc_dest" ]; then
        echo "Removing '$win_bashrc_dest'..."
        run_and_check "rm $win_bashrc_dest" "remove file"
    else
        # Otherwise if doesn't
        echo "The system is already unconfigured (No '$bashprof' file exists)."
    fi
}



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

        # Check dotfiles are present
        run_and_check "test -f \"$bashrc_path\" && test -f \"$prof_path\"" "find dotfiles ('$bashrc_path', '$prof_path') in '$dotfiles_path" "quiet_success"

        if [ "$detected_os" == "Linux" ]; then
            configure_linux
        elif [ "$detected_os" == "Windows" ]; then
            configure_windows
        fi
        ;;
    2)
        echo "Unconfiguring $action_msg"
        echo ""
        if [ "$detected_os" == "Linux" ]; then
            unconfigure_linux
            echo "Untested..."
        elif [ "$detected_os" == "Windows" ]; then
            unconfigure_windows
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