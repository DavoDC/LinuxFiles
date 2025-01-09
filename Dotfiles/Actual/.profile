
################ DAVID'S .PROFILE ################

######## PERSONAL ADDITIONS ########
# Fix permissions of bashrc
chmod 600 ~/.bashrc

######## DEFAULT ENTRIES ########
# If running bash
if [ -n "$BASH_VERSION" ]; then
    # Include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# Set PATH so it includes user's private bin folder if they exist
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

################ END ################