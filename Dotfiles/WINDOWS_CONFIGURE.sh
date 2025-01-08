#!/bin/bash

# Keep this for nice output
clear

# Set source and destination folders
src="/c/Users/David/GitHubRepos/LinuxFiles/Dotfiles/Actual/.bashrc"
dest="/c/Users/$USERNAME/"

# Start message
echo
echo "::::::::: Setting up .bashrc for Git Bash mintty terminal :::::::::"
echo

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
echo

# Copy .bashrc
echo "Copying bashrc from LinuxFiles repo to User folder..."
cp "$src" "$dest"
echo

# Rename to .bash_profile
echo "Renaming..."
mv "$brc" "$bprof"
echo

# Edit step
echo "You can add this to the top of the file:"
echo "  # COPY OF .BASHRC FOR GIT MINTTY BASH"
echo "Opening the file for editing..."
nano "$bprof"
echo

# Finish message
echo "Finished!"
echo

# Pause for user input before exiting
read -p "Press Enter to exit..."