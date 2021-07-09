
# General setup for all distros
# Should be quite fast

# Show all commands
set -x

# Make sure packages are good
sudo apt update 
echo ""
sudo apt upgrade
echo ""
sudo apt full-upgrade
echo ""
sudo apt-get update 
echo ""
sudo apt-get upgrade
echo ""
sudo apt-get dist-upgrade
echo ""
sudo apt-get check
echo ""

# Install C and C++ compilers, and other tools like 'make'
sudo apt-get install gcc g++ build-essential -y
echo ""

# Install manual pages for C and other commands
sudo apt install man-db coreutils -y
echo ""
sudo apt-get install manpages-dev manpages-posix-dev -y
echo ""

