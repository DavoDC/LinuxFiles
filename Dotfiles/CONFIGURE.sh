#!/usr/bin/env bash

# Handles installing and uninstalling dotfiles

# Variables
brc=".bashrc"
prof=".profile"
repopath="/home/$USER/LinuxFiles/Dotfiles/Actual"

# Helper Function for Continue Prompt
function ask_continue () {
    read -p "Would you like to continue (y/n)? " choice
    case "$choice" in 
        y|Y ) echo "Continuing...";; # true
        n|N ) echo "Exiting! " && exit;; 
        * ) exit;;
    esac
}

# Helper Function to Move File and Check
# Arg 1: File name (e.g. log.txt)
# Arg 2: Destination folder name (e.g. things)
function move_file_and_check() {
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

# Helper Function for Removing Symlinks
# Arg 1: Path to symlink
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

# Main Function
function configure_system () {
    # Go to home
    echo "### Going to home directory..."
    cd ~

    # Notify
    echo "### Backing up original configuration files ($brc and $prof) into a folder..."
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

    echo "# Moving original '$brc' and '$prof' files into the folder..."
    move_file_and_check "$brc" "$origname"
    move_file_and_check "$prof" "$origname"

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
    ln --symbolic "$repopath/$brc" "$brc"
    ln --symbolic "$repopath/$prof" "$prof"

    echo "### Configuration finished!"
    ls -al --color=auto ~
    echo "Close and reopen the terminal and it should look different"
    echo "Use 'showbrc' to see what commands are available"
}

function unconfigure_system () {
    # Go to home
    echo "### Going to home directory..."
    cd ~

    # Remove symlinks
    echo "### Removing symlinks to repo config files"
    remove_if_symlink "$brc"
    remove_if_symlink "$prof"

    # Move back originals
    echo "### Moving original configuration files back"
    origname="originals"
    mv "$origname/$brc" "$brc"
    mv "$origname/$prof" "$prof"

    # Delete empty originals folder
    echo "# Deleting empty originals folder"
    rmdir "$origname"

    echo "### UN-configuration finished!"
    ls -al --color=auto ~
}

# Main Script Flow
echo "### Welcome to the Configuration/Unconfiguration Script"
echo "Do you want to configure or unconfigure your system?"
echo "1) Configure"
echo "2) Unconfigure"
read -p "Choose an option (1/2): " action

case "$action" in
    1) 
        echo "You chose to configure your system."
        configure_system
        ;;
    2)
        echo "You chose to unconfigure your system."
        unconfigure_system
        ;;
    *)
        echo "Invalid choice. Exiting..."
        exit 1
        ;;
esac
