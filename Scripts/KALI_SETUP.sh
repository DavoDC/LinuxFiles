#!/usr/bin/env bash

# Setup for Kali Linux
# Will take a while!

# OS CHECK
if [[ ! "$OSTYPE" == "linux-gnu"* ]]; then
    echo -e "\nThis script is for Linux only!"
    exit 1
fi

# Show all commands
set -x

# Update first
sudo apt update
echo ""

# Install main packages
# Prompt window will come up with options!
# See more at: https://www.kali.org/docs/troubleshooting/common-minimum-setup/
sudo apt install -y kali-linux-core
echo ""
sudo apt install -y kali-linux-headless
echo ""

# Fix python message
# See info here: https://www.kali.org/docs/general-use/python3-transition/
sudo apt install -y python-is-python3
echo ""


# Message
echo "Now run general setup script!"
echo ""
