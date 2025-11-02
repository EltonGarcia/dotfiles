#!/usr/bin/env bash

# Get the directory of the currently running script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Define the options for the Rofi menu
# Each option is separated by a newline character (\n)
options="$DIR\nOption 1\nOption 2\nWeb Search"

# Show the Rofi menu and capture the user's choice
# The -p flag sets the prompt text
chosen=$(echo -e "$options" | rofi -dmenu -p "Custom Scripts")

# Act based on the user's choice
case "$chosen" in
    "Option 1")
        # Example command: send a desktop notification
        notify-send "Hello!" "You selected Option 1"
        ;; 
    "Option 2")
        # Example command: open a terminal (replace with your preferred terminal)
        kitty
        ;; 
    "Web Search")
        # Execute another script from the plugins directory
        "$DIR/web-search.sh"
        ;; 
esac
