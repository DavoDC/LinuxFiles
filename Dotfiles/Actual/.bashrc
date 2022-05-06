# ~/.bashrc: executed by bash(1) for non-login shells.
# Loaded on startup of shell


# DAVID .BASHRC

# From system:

# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
#alias ll='ls -l'
#alias la='ls -A'
#alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
	if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
	elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
	fi
fi






# My personal additions start here





# Stop "System Error detected" popups (silent if nothing)
# sudo rm /var/crash/* 2> /dev/null


# Welcome message
echo ""
echo -e "#### Welcome $USER, my wonderful user \U0001F642 ####"
custdate=$(date +"%A %-d %b %Y")
echo "#### Today's date is: "$custdate "####"

# Make space 
echo ""

# Change left part of shell commands
export PS1='\[\033[01;32m\]\u\[\033[00m\] ../\W: '



# Helper function to get confirmation
# Takes one argument, a string describing some action
# e.g. "remove this file"
confirm () {
    # Note: Make sure there is some space after question string
	read -p "Are you sure you want to $1 (This may be permanent) (y/n)?  " choice
	case "$choice" in 
		y|Y ) return 0;; # true
		n|N ) return 1;;
	  * ) return 1;;
	esac
}


#### I have centralized my Linux knowledge in this file.
## So there are aliases of commands that are the same.

## When the terminal is hanging, you can sometimes use Ctrl+C to break out.

### Output direction operators
# | to pipe command input in another.
# “>“: Overwrites the existing file, 
# or creates a file if the file of the mentioned name is not present in the directory.
# “>>“: Appends the existing file, 
# or creates a file if the file of the mentioned name is not present in the directory.
#### Wild cards

## Star WildCard
# The star wildcard (*) has the broadest meaning of any of the wildcards, 
# as it can represent zero characters, all single characters or any string.

## Question Mark Wildcard
# The question mark wildcard (?) is used as a wildcard character 
# in shell commands to represent exactly one character, 
# which can be any single character. 
# Thus, two question marks in succession would represent any two characters in succession

## Square Brackets Wildcard
# The third type of wildcard in shell commands is a pair of square brackets, 
# which can represent any of the characters enclosed in the brackets. 
# Thus, for example, the following would provide information about 
# all objects in the current directory that have an x, y and/or z in them:
# >>> file *[xyz]*
#
# And the following would list all files that had an extension that begins with x, y or z:
# >>> ls *.[xyz]*

# The same results can be achieved by merely using the star and question mark wildcards. 
# However, it is clearly more efficient to use the bracket wildcard.

# When a hyphen is used between two characters in the square brackets wildcard, 
# it indicates a range inclusive of those two characters. 
# For example, the following would provide information about all of the objects 
# in the current directory that begin with any letter from a through f:
# >>> file [a-f]*

# And the following would provide information about every object in the 
# current directory whose name includes at least one numeral:
# >>> file *[0-9]*





############################################################
######## My commands, functions and aliases #########
############################################################


### The most important commands

# Reveal all possible commands by printing out part of this file
alias showbrc="tail --lines=+144 ~/.bashrc"

# Open up bashrc in a text editor for viewing/editing
alias openbrc="xdg-open ~/.bashrc"

# Search these commands
# Usage: searchbrc <substring>
alias searchbrc="showbrc | grep"





### Directory commands

# Change directory to home directory
alias home="cd ~"


# Change to a given directory 
# Usage: cd <folder_name>
alias goto="cd"


# Show present working directory (PWD)
alias here="pwd"
alias whereami="pwd"


# List files, simplified (i.e. hide special files)
#alias dir="dir"


# Listing all files with details
# Can put folders as arguments to show their contents
# Ensure colours are on
alias ls="ls --color=auto -al"





### File/Folder commands

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
alias open="xdg-open"


# Print out a file's contents to the terminal
# Usage: show info.txt
alias show="cat"	
alias printfile="cat"


# Display text one screenful at a time
#alias more="more"
#alias less="less"


# Show wordcount and other text stats
# alias wc="wc"


# Rename/move files/folders
# Usage: rename/move <current_name> <new_name>
alias rename="mv"
alias move="mv"


# Show directory structure as a tree
# Note: must be installed first
#alias tree="tree"



# Remove files/folders (permanently!)
# Usage: remove <name of file/folder in PWD>
remove () {
	
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
copy () {
	
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



# Trash files/folders (send to 'Trash' folder in home)
# trash = make trash folder if needed + copy ($1, ~/home) + remove















### Permissions commands

# Apply magic 777 permissions
alias permfix="chmod 777 *"


# Append a program file name to make it a 'clickable' exe
alias make_exe="chmod 755"


# Append a file name to get its permission number
alias get_perm="stat --format '%a' "

# Elevate permissions by switching to superuser temporarily (only for rest of session)
alias elevate="sudo su"






### Terminal commands 

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
# TEST
alias printPath="sed 's/:/\n/g' <<< "$PATH""


# Get top ten commands used
alias topTen="history | awk '{cmd[$2]++} END {for(elem in cmd) {print cmd[elem] " " elem}}' | sort -n -r | head -10"





### Process commands

# Show list of processes
alias listproc="ps"
alias pslist="ps"


# Show process tree
alias pstree="pstree"


# Enter detailed process table
alias pstable="top"





##### Package Management


alias update="sudo apt-get update"


# Install a package
# Usage example: install_pkg firefox
function install_pkg()
{
	echo ""
    echo "Updating package list before install..."
	sudo apt update 
	echo ""
	
	echo "Attempting install..."
	sudo apt install $1
	echo ""
}






### Other commands/functions

# Show docs/manual for Linux commands and C99 functions
alias manual="man"

# Describe Linux commands and C99 functions
# TEST
function describe()
{
	type $1
	whatis $1
}

# Enter calculation mode
alias calculate="bc" 


# Download a file from a given URL
# Usage example: download http://www.orimi.com/pdf-test.pdf
alias download="wget"


# Find a string a text file
# Usage: searchfile "bmw" cars.txt
alias searchfile="grep -n"


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
alias open-sw="gnome-software"



# Print IP address 
function printIP()
{
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
}


# Print system information
# TEST
function sysInfo()
{
	echo ""
	neofetch

	echo ""
	lsb_release -a

	echo ""
	hostnamectl

	echo ""
	cat /etc/*-release | uniq -u
}







######### Programming
# TEST ALL


### Copy Template
# Argument 1: Template name
function copyTemplate()
{
	copy "~/LinuxFiles/Coding_Templates/$1" "."
}


### C Programming
## Get template
alias tempC=copyTemplate "ctemp.c"
## Compile
# Usage: compC ctemp ctemp.c 
alias compC="cc -std=c99 -Wall -pedantic -Werror -o"
## Run = Use dot slash notation (./ctemp)


### CPP Programming
## Get template
alias tempCPP=copyTemplate "cpptemp.cpp"
## Compile
# Usage: compCpp cpptemp cpptemp.cpp
alias compCpp="g++ -o"
## Run = Use dot slash notation (./cpptemp)


### Java Programming
# Get template
alias tempJava=copyTemplate "JavaTemp.java"
## Compile
# Usage: compJava JavaTemp.java
alias compJava="javac"
## Run
# Usage: runJava JavaTemp
alias runJava="java"


### Python Programming
## Get template
alias tempPy=copyTemplate "pytemp.py"
## Compile and Run
# Usage: compPy pytemp.py
alias compPy="python3"



### SSF2

# Native shortcut
function ssf2 {
	cd /home/david/Documents/LINUX_SSF2/1_NATIVE/SSF2BetaLinux.v1.3.1.2
	./SSF2
}

# Wine shortcut
function ssf2_wine {
	cd /home/david/Documents/LINUX_SSF2/2_WINE_PORTABLE/SSF2BetaWindows.32bit.v.1.3.1.2.portable
	wine SSF2.exe
}



