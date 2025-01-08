#!/usr/bin/env bash

# Detect the operating system
detected_os=""
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    detected_os="Linux"
elif [[ "$OSTYPE" == "msys" ]]; then
    detected_os="Windows"
else
    echo -e "\nOperating System Detection Error!"
    exit 1
fi

# Notify the user about the detected OS
echo "Detected Operating System: $detected_os"
echo

# Define Linux configuration details
linux_brc=".bashrc"
linux_prof=".profile"
linux_repopath="/home/$USER/LinuxFiles/Dotfiles/Actual"

# Define Windows configuration details
windows_src="/c/Users/David/GitHubRepos/LinuxFiles/Dotfiles/Actual/.bashrc"
windows_dest="/c/Users/$USERNAME/"

# Helper Function for Continue Prompt
function ask_continue () {
    read -p "Would you like to continue (y/n)? " choice
    case "$choice" in
        y|Y ) echo "Continuing...";;
        n|N ) echo "Exiting! " && exit;;
        * ) exit;;
    esac
}

# Linux Helper Functions
function move_file_and_check () {
    sig="${FUNCNAME[0]}'('$1', '$2')"
    filename=$1
    destname=$2
    finalpath=$destname/$filename
    
    if mv $filename $finalpath; then
        if [ -f "$finalpath" ]; then
            echo "$sig definitely successful!"
        fi
    else
        echo "'$sig issue!!!"
        ask_continue
    fi
}

function remove_if_symlink () {
    echo ""
    if [ -L "$1" ]; then
        if rm "$1"; then
            echo "'$1' symlink successfully removed!"
        fi
    else
        echo "'$1' is not a symlink!!!"
        if [ -f "$1" ]; then
            echo "'$1' is a regular file, likely the original"
            echo "Danger!!! Exiting!!!"
            exit
        fi
        if [ ! -e "$1" ]; then
            echo "'$1' does not exist as any type of file"
            echo "Strange..."
            ask_continue
        fi
    fi
}

function configure_linux () {
    # Go to home
    echo "### Going to home directory..."
    cd ~

    # Notify
    echo "### Backing up original configuration files ($linux_brc and $linux_prof) into a folder..."
    origname="originals"
    
    echo "# Attempting to create backup folder"
    if [ ! -d $origname ]; then
        echo "'$origname' hasn't been made, that's good"
        echo "Making folder called '$origname'..."
        mkdir $origname
    else
        echo "'$origname' has been made already!"
        echo "Your system is probably already configured!"
        echo "You may want to continue anyway... or not"
        ask_continue
    fi

    echo "# Moving original '$linux_brc' and '$linux_prof' files into the folder..."
    move_file_and_check "$linux_brc" "$origname"
    move_file_and_check "$linux_prof" "$origname"

    # Notify
    echo "### Creating links to repo configuration files..."
    reponame="LinuxFiles"
    if [ ! -d $reponame ]; then
        echo "'$reponame' repo doesn't exist in home directory!"
        echo "Go to home and git clone it! Exiting..."
        exit
    else
        echo "'$reponame' repo found! Continuing..."
    fi

    echo "# Making symlinks to repo config files!"
    ln --symbolic "$linux_repopath/$linux_brc" "$linux_brc"
    ln --symbolic "$linux_repopath/$linux_prof" "$linux_prof"

    echo "### Configuration finished!"
    ls -al --color=auto ~
    echo "Close and reopen the terminal and it should look different"
    echo "Use 'showbrc' to see what commands are available"
}

function unconfigure_linux () {
    # Go to home
    echo "### Going to home directory..."
    cd ~

    # Remove symlinks
    echo "### Removing symlinks to repo config files"
    remove_if_symlink "$linux_brc"
    remove_if_symlink "$linux_prof"

    # Move back originals
    echo "### Moving original configuration files back"
    origname="originals"
    mv "$origname/$linux_brc" "$linux_brc"
    mv "$origname/$linux_prof" "$linux_prof"

    # Delete empty originals folder
    echo "# Deleting empty originals folder"
    rmdir "$origname"

    echo "### UN-configuration finished!"
    ls -al --color=auto ~
}

# Windows Configuration Functions
function configure_windows () {
    # Set source and destination folders
    src="$windows_src"
    dest="$windows_dest"

    # Start message
    echo "::::::::: Setting up .bashrc for Git Bash mintty terminal :::::::::"

    # Check paths
    echo "Checking paths..."

    # Check source
    if [ ! -f "$src" ]; then
        echo "Source invalid"
        exit 1
    fi

    # Check destination
    if [ ! -d "$dest" ]; then
        echo "Dest invalid"
        exit 1
    fi

    # Special file paths in User folder
    brc="${dest}.bashrc"
    bprof="${dest}.bash_profile"

    # Remove previous files (if they exist)
    echo "Removing previous files..."
    [ -f "$brc" ] && rm -f "$brc"
    [ -f "$bprof" ] && rm -f "$bprof"

    # Copy .bashrc
    echo "Copying bashrc from LinuxFiles repo to User folder..."
    cp "$src" "$dest"

    # Rename to .bash_profile
    echo "Renaming..."
    mv "$brc" "$bprof"

    # Edit step
    echo "You can add this to the top of the file:"
    echo "  # COPY OF .BASHRC FOR GIT MINTTY BASH"
    echo "Opening the file for editing..."
    nano "$bprof"

    # Finish message
    echo "Finished!"
}

function unconfigure_windows () {
    # Set source and destination folders
    dest="$windows_dest"
    bprof="${dest}.bash_profile"

    # Check if .bash_profile exists
    if [ -f "$bprof" ]; then
        # Remove the .bash_profile
        rm -f "$bprof"
        echo "Removed .bash_profile"
    fi

    echo "Unconfiguration for Windows complete!"
}

# Main script flow
echo "### Welcome to the Configuration/Unconfiguration Script"
echo "Do you want to configure or unconfigure your system?"
echo "1) Configure"
echo "2) Unconfigure"
read -p "Choose an option (1/2): " action

case "$detected_os" in
    "Linux")
        echo "You are on a Linux system."
        ;;
    "Windows")
        echo "You are on a Windows system."
        ;;
    *)
        echo "Operating System Error"
        exit 1
        ;;
esac

case "$action" in
    1)
        echo "You chose to configure your system."
        if [ "$detected_os" == "Linux" ]; then
            configure_linux
        elif [ "$detected_os" == "Windows" ]; then
            configure_windows
        fi
        ;;
    2)
        echo "You chose to unconfigure your system."
        if [ "$detected_os" == "Linux" ]; then
            unconfigure_linux
        elif [ "$detected_os" == "Windows" ]; then
            unconfigure_windows
        fi
        ;;
    *)
        echo "Invalid choice. Exiting..."
        exit 1
        ;;
esac