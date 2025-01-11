# ~/.bashrc: executed by bash(1) for non-login shells.
# Loaded on startup of shell

################ DAVID'S .BASHRC ################
# I have centralised my Linux knowledge in this file.
# Some aliases are just reminders of commands (e.g. alias pstree="pstree")

# When the terminal is hanging, you can usually use Ctrl+C or Ctrl+Shift+C to 'break out' of it.

### Output direction operators
# |: Pipes command input into another command.
# ">": Overwrites the existing file, or creates a file if the file of the given name is not present.
# ">>"": Appends the existing file, or creates a file if the file of the given name is not present.

#### Wildcards
#
## Star Wildcard
# The star wildcard (*) has the broadest meaning of any of the wildcards, 
# as it can represent zero characters, all single characters or any string.
#
## Question Mark Wildcard
# The question mark wildcard (?) is used as a wildcard character 
# in shell commands to represent exactly one character, which can be any single character. 
# Thus, two question marks in succession would represent any two characters in succession.

## Square Brackets Wildcard
# The third type of wildcard in shell commands is a pair of square brackets, 
# which can represent any of the characters enclosed in the brackets. 
# Thus, for example, the following would provide information about 
# all objects in the current directory that have an x, y and/or z in them:
# >>> file *[xyz]*
#
# And the following would list all files that had an extension that begins with x, y or z:
# >>> ls *.[xyz]*
#
# The same results can be achieved by merely using the star and question mark wildcards. 
# However, it is clearly more efficient to use the bracket wildcard.
#
# When a hyphen is used between two characters in the square brackets wildcard, 
# it indicates a range inclusive of those two characters. 
# For example, the following would provide information about all of the objects 
# in the current directory that begin with any letter from a through f:
# >>> file [a-f]*
#
# And the following would provide information about every object in the 
# current directory whose name includes at least one numeral:
# >>> file *[0-9]*



######## SETTINGS ########
# See /usr/share/doc/bash/examples/startup-files (in the package bash-doc) for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# Don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# For setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# Append to the history file, don't overwrite it
shopt -s histappend

# Check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# Make 'less' more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Enable programmable completion features
if ! shopt -oq posix; then
	if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
	elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
	fi
fi

# Change left part of shell commands
export PS1='\[\033[01;32m\]\u@\h\[\033[00m\] ../\W: '

# Detect current operating system and set variables accordingly
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
	# Linux settings
	IS_LINUX=true
	IS_WINDOWS=false

	# Bashrc location
	BASH_FILE="$HOME/.bashrc"

	# Open with default program
	DEFAULT_OPENER="xdg-open"

elif [[ "$OSTYPE" == "msys" ]]; then

	# Windows settings
	IS_LINUX=false
	IS_WINDOWS=true

	# Bashrc location
	BASH_FILE="$HOME/.bash_profile"

	# Open with default program
	DEFAULT_OPENER="start ''"

else
    echo -e "Operating System Detection Error!"
    exit 1
fi



######## WELCOME MESSAGE ########
echo ""
echo -e "#### Welcome David! \U0001F642 ####"
custdate=$(date +"%A %-d %b %Y")
echo "#### Today's date is: "$custdate "####"
echo ""



##########################################
######## MY ALIASES AND FUNCTIONS ########
##########################################



### Bashrc file

## Helper Variables
# The number below should roughly match the line number of the heading above.
SHOWBRC_LINE=$(($(grep -n 'MY ALIASES AND FUNCTIONS' "$BASH_FILE" | head -n 1 | cut -d: -f1)-1))

# Get this part of the file
TAIL_BRC="tail -n+$SHOWBRC_LINE $BASH_FILE"

## Aliases
# Print out this part of the file onwards
alias showbrc="$TAIL_BRC; echo"

# Search this part of the file
# Usage: searchbrc <substring>
alias searchbrc="$TAIL_BRC | grep"

# Open up installed bashrc file with default program
alias openbrc="$DEFAULT_OPENER $BASH_FILE"



### Directories

# Change directory to home directory
alias home="cd ~"

# Change to a given directory 
# Usage: cd <folder_name>
alias goto="cd"

# Show present working directory (PWD)
alias here="pwd"
alias whereami="pwd"

# List normal file names only, each on a new line
alias ls="ls --color=auto -1"

# List all file names, each on a new line
alias la="ls --color=auto -Aa"

# List detailed file information, each on a new line
alias ll="ls --color=auto -lAh --time-style='+%Y-%m-%d %H:%M'"



### Files

# Make new text file in PWD
alias newfile="touch newfile.txt"

# Make new script in PWD
alias newscript="touch newscript.sh && chmod 777 newscript.sh"

# Make new folder in PWD
alias newfolder="mkdir newfolder"

# Show detailed file information
alias fileinfo="stat"

# Show full path of a file
# Usage: getpath file.txt
alias getpath="readlink -f"

# Edit text file with shell editor
# Usage: nano newfile.txt
alias edit="nano"

# Open a given file with the default program
# Usage: open <filepath>
alias open="$DEFAULT_OPENER"

# Find a string in a text file
# Usage: searchfile "bmw" cars.txt
alias searchfile="grep -n"

# Print out a file's contents to the terminal
# Usage: show info.txt
alias show="cat"	
alias printfile="cat"

# Display text one screenful at a time
alias more="more"
alias less="less"

# Show wordcount and other text stats
alias wc="wc"

# Show directory structure as a tree
# Note: Must be installed first on Ubuntu!
function tree() {
    if [[ "$IS_LINUX" == true ]]; then
        command tree "$@"
    else
        cmd //c "tree /f /a $(cygpath -w $(pwd))" | sed 's/\\/\//g' \
            | sed 's/\/$//' \
            | sed 's/|/│/g' \
            | sed 's/---/├───/g' \
            | sed 's/\/\\/\//g' \
            | sed 's/└───/└───/g' \
            | sed 's/├───/├───/g' \
            | sed 's/^\+//g' \
            | sed 's/\\$//' \
            | sed 's/\/├/├/g'
    fi
}

# Download a file from a given URL
# Usage example: download http://www.orimi.com/pdf-test.pdf
alias download='wget || curl -L -O'



### File/Folder Operations

# Rename/move files/folders
# Usage: rename/move <current_name> <new_name>
alias rename="mv"
alias move="mv"

# Helper function to get confirmation
# Takes one argument, a string describing some action
# e.g. "remove this file"
function confirm () {
    # Note: Make sure there is some space after question string
	read -p "Are you sure you want to $1 (This may be permanent) (y/n)?  " choice
	case "$choice" in 
		y|Y ) return 0;; # true
		n|N ) return 1;;
	  * ) return 1;;
	esac
}

# Remove files/folders (permanently!)
# Usage: remove <name of file/folder in PWD>
function remove () {
	
    # If path is invalid
	if ! [[ -e $1 ]]; then
	
		# Notify
		echo "'$1' is not a valid file/folder"
		echo ""
	else
		# Else if path is valid
		
		# If action not confirmed 
		if ! confirm "remove '$1'"; then
		
			# Notify and stop
			echo "Cancelled"
			echo ""
			return 0
		fi
		
		# If path is a file
		if [[ -f $1 ]]; then
	
			# Remove file
			rm $1		
		elif [[ -d $1 ]]; then
	
			# Else if path is a directory
			# Remove directory, even if not empty, and show
			rm -vrf $1	
		fi
	fi	
}

# Copy files/folders 
# Argument #1 = Source file/folder
# Argument #2 = Destination location
function copy () {
	
    # If source path is invalid 
	if ! [[ -e $1 ]]; then
	
		# Notify
		echo "'$1' is not a valid file/folder"
		echo ""
	else
		# Else if path is valid
		
		# If path is a file
		if [[ -f $1 ]]; then
	
			# Copy file
			cp -i $1 $2		
		elif [[ -d $1 ]]; then
	
			# Else if path is a directory, 
			# copy whole directory
			cp -ir $1 $2
		fi
	fi	
}



### Permissions

# Apply magic 777 permissions
alias permfix="chmod 777 *"

# Make a program executable
alias make_exe="chmod 755"

# Get a file's permission number
alias get_perm="stat --format '%a' "

# Elevate permissions by switching to superuser temporarily (only for rest of session)
alias elevate="sudo su"



### Terminal

# Exiting terminal 
alias q="exit"
alias qqq="exit"

# Clearing terminal
alias clear="clear && tput reset"
alias cls="clear && tput reset"

# Print string to terminal
alias printstr="echo"

# Print name of terminal
alias termname="tty"

# Show PATH dirs line by line
alias printpath="sed 's/:/\n/g' <<< '"$PATH"'"

# Get top ten commands used
function topTen() {
    echo "# Top ten commands used #"
    echo "-------------------------"
    history | awk '{cmd[$2]++} END {for(elem in cmd) {print cmd[elem], elem}}' | sort -n -r | head -10 | \
    awk '{printf "%-5s %s\n", $1, $2}'
}


### Processes

# Show list of processes
alias listproc="ps"
alias pslist="ps"

# Show process tree
alias pstree="pstree"

# Enter detailed process table
alias pstable="top"



### Package Management
alias update="sudo apt-get update"

# Install a package
# Usage example: install_pkg firefox
function install_pkg() {
	echo ""
    echo "Updating package list before install..."
	sudo apt update 
	echo ""
	
	echo "Attempting install..."
	sudo apt install $1
	echo ""
}



### Git

# Show git config
alias showgitcfg="git config --list | cat"

# Get repo status quickly
alias status="git status"

# Show branch info
alias branch="git branch"

# Show verbose branch info
alias branchv="git branch -vv"

# Amend last commit 
alias amend="git commit --amend"



### Programming
## Patterns
# Get template = temp<lang>
# Compile = comp<lang>

### Helper: Copy Template
# Argument 1: Template name
function copyTemplate() {
	copy "/home/david/LinuxFiles/Coding_Templates/$1" "."
}

### C Programming
## Get template
alias tempC="copyTemplate ctemp.c"
## Compile
# Usage: compC ctemp ctemp.c 
alias compC="cc -std=c99 -Wall -pedantic -Werror -o"
## Run = Use dot slash notation (./ctemp)

### CPP Programming
## Get template
alias tempCPP="copyTemplate cpptemp.cpp"
## Compile
# Usage: compCpp cpptemp cpptemp.cpp
alias compCpp="g++ -Wall -pedantic -Werror -o"
## Run = Use dot slash notation (./cpptemp)

### Java Programming
# Get template
alias tempJava="copyTemplate JavaTemp.java"
## Compile (generates *.class files)
# Usage: compJava JavaTemp.java
alias compJava="javac"
## Run (runs *.class files)
# Usage: runJava JavaTemp
alias runJava="java"

### Python Programming
## Get template
alias tempPy="copyTemplate pytemp.py"
## Compile and Run
# Usage: compPy pytemp.py
alias compPy="python3"



### SSF2 

# Open Australian ruleset quietly
function openRules {
	bash -c "$DEFAULT_OPENER https://docs.google.com/document/d/1EfO_iNvyvvjdU8TOsufR_q4O38E_yJHNG-Zer8toLaw" 2> /dev/null > /dev/null
}

# Print a copy of the Australian tournament ruleset
# DISABLED, NOT IN USE
# function printRules {
# 	cat "/home/david/LinuxFiles/Scripts/SSF2/Aussie_SSF2_Ruleset.txt"
# }

# Run native SSF2
# DISABLED, NOT IN USE
# function ssf2 {
# 	cd /home/david/Documents/LINUX_SSF2/1_NATIVE/SSF2BetaLinux.v1.3.1.2
# 	./SSF2
# }

# Run wine portable SSF2
# DISABLED, NOT IN USE
# function ssf2_wine {
# 	cd /home/david/Documents/LINUX_SSF2/2_WINE_PORTABLE/SSF2BetaWindows.32bit.v.1.3.1.2.portable
# 	wine SSF2.exe
# }



### Immersive

# Helper function to handle common itbuild calls
function _std_build_common {
    local ib_flag=$1    # "ib" or empty string
    local cmd="itbuild $ib_flag parallel release nobuildnode nobuildtest" # Build base command

    # Append any additional arguments
    if [ $# -gt 1 ]; then
        cmd="$cmd ${@:2}" # Use ${@:2} to include all arguments starting from the second one
    fi

    # Print and execute the command
    echo ""
    echo "Running '$cmd'..."
    echo ""
    eval $cmd
}

# Do standard itbuild call without IncrediBuild (for when it isn't working)
function std_build_noIB {
    _std_build_common "" "$@"
}

# Do standard itbuild call
function std_build {
    _std_build_common "ib" "$@"
}

# Do standard itbuild call and notify
function std_build_notify {
    std_build "notify:dcharkey"
}



### Miscellaneous

# Show docs/manual for Linux commands and C99 functions
alias manual="man"

# Enter calculation mode
alias calculate="bc" 

# Print user ID of current user
alias whoami="whoami"
alias showuser="whoami"

# Change your password
alias changepw="passwd"

# Show where a binary/command is stored
alias which="which"
alias whereis="whereis"

# Show disk space free in partitions
alias diskfree="df"

# Open Ubuntu Software very fast
alias opensw="gnome-software"

# Describe Linux commands and C99 functions
function describe() {
	type $1
	whatis $1
}

# Print IP address 
function printIP() {
	if [[ "$IS_LINUX" == true ]]; then
		echo ""
		echo "Method 1: (usually first one is correct)"
		hostname -I 
		
		echo ""
		echo "Method 2:"
		ifconfig -a | grep -w "inet" | sed 's/^[[:space:]]\+//' 
		# Note: ifconfig needs to be installed, sed removes leading whitespace
		
		echo ""
		echo "Method 3:"
		ip a | grep inet | sed 's/^[[:space:]]\+//' | sed -n 3p
	else
		echo ""
		echo "Private IPs (local network):"
		ipconfig | grep -A 10 "Wireless LAN adapter" | grep "IPv4 Address" | awk -F: '{print $2}' | sed 's/^[[:space:]]*//'

		ipconfig | grep -A 10 "Ethernet adapter" | grep "IPv4 Address" | awk -F: '{print $2}' | sed 's/^[[:space:]]*//'

		echo ""
		echo "Public IP Address:"
		if command -v curl > /dev/null 2>&1; then
			curl -s https://ipinfo.io/ip
		elif command -v wget > /dev/null 2>&1; then
			wget -qO- https://ipinfo.io/ip
		else
			echo "Error: curl or wget is required to fetch public IP."
		fi
		echo ""
	fi
}

# Print system information
function sysInfo() {
	if [[ "$IS_LINUX" == true ]]; then
		echo ""
		neofetch

		echo ""
		lsb_release -a

		echo ""
		hostnamectl

		echo ""
		cat /etc/*-release | uniq -u
	else
		echo ""
		echo "### System Information ###"

		echo "OS Information:"
		powershell.exe -Command "Get-CimInstance -ClassName Win32_OperatingSystem | Select-Object -Property Caption, Version, OSArchitecture, InstallDate | Format-Table -AutoSize"
		
		echo "CPU Information:"
		powershell.exe -Command "Get-CimInstance -ClassName Win32_Processor | Select-Object -Property Name, Manufacturer, MaxClockSpeed | Format-Table -AutoSize"

		echo "RAM Information:"
		powershell.exe -Command "Get-CimInstance -ClassName Win32_PhysicalMemory | Select-Object -Property Manufacturer, Capacity, Speed | Format-Table -AutoSize"

		echo "Storage Information:"
		powershell.exe -Command "Get-CimInstance -ClassName Win32_LogicalDisk | Select-Object -Property DeviceID, VolumeName, Size, FreeSpace | Format-Table -AutoSize"

		echo "GPU Information:"
		powershell.exe -Command "Get-CimInstance -ClassName Win32_VideoController | Select-Object -Property Name, DriverVersion | Format-Table -AutoSize"
	fi
}



################ END ################