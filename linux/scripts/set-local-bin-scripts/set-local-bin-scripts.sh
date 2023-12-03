#!/bin/bash

# TO REMEMBER: Leverage on ChatGPT to modify it.

# Get right HOME folder for user, otherwise, /root will be assumed because of the sudo
HOME=$(getent passwd $SUDO_USER | cut -d: -f6)

# Default values
DEFAULT_SOURCE_FOLDER="$HOME/Workspace/Scripts/Linux"
DEFAULT_DESTINATION_FOLDER="/usr/local/bin"

# Function to display script usage
display_usage() {
    echo "Usage: sudo $0 [OPTIONS]"
    echo "OPTIONS:"
    echo "  -s, --source <source_scripts_folder>        Specify the source scripts folder. (Default: $DEFAULT_SOURCE_FOLDER)"
    echo "  -d, --destination <destination_folder>      Specify the destination folder for symbolic links. (Default: $DEFAULT_DESTINATION_FOLDER)"
    echo "  -r, --remove-links                         Remove specified symbolic links from the destination folder."
    echo "  --help                                      Display this help message."
}

# Variables to manage deletion of symbolic links
REMOVE_LINKS=false
LINKS_TO_REMOVE=()

# Parse command-line options
while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        -s|--source)
            SOURCE_SCRIPTS_FOLDER="$2"
            shift # past argument
            shift # past value
            ;;
        -d|--destination)
            DESTINATION_LINKS_FOLDER="$2"
            shift # past argument
            shift # past value
            ;;
        -r|--remove-links)
            REMOVE_LINKS=true
            shift # past argument
            ;;
        --help)
            display_usage
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            display_usage
            exit 1
            ;;
    esac
done

# Check and set default values if not provided
if [[ -z $SOURCE_SCRIPTS_FOLDER ]]; then
    SOURCE_SCRIPTS_FOLDER="$DEFAULT_SOURCE_FOLDER"
fi

if [[ -z $DESTINATION_LINKS_FOLDER ]]; then
    DESTINATION_LINKS_FOLDER="$DEFAULT_DESTINATION_FOLDER"
fi

# Check if the specified source scripts folder exists
if [ ! -d "$SOURCE_SCRIPTS_FOLDER" ]; then
    echo "Error: The specified source scripts folder does not exist or is not a directory."
    exit 1
fi

# Check if the specified destination folder exists
if [ ! -d "$DESTINATION_LINKS_FOLDER" ]; then
    echo "Error: The specified destination folder does not exist or is not a directory."
    exit 1
fi

# Define the array of script names from the source scripts folder
SCRIPTS=(
    "$SOURCE_SCRIPTS_FOLDER/magic-mouse/magic-mouse-connect.sh"
    "$SOURCE_SCRIPTS_FOLDER/screen-config/screen-config.sh"
    "$SOURCE_SCRIPTS_FOLDER/keyboard-set/keyboard-set.sh"
)

# Function to remove symbolic links
remove_links() {
    for script in "${SCRIPTS[@]}"; do
        script_name=$(basename "$script")
        LINKS_TO_REMOVE+=("$DESTINATION_LINKS_FOLDER/$script_name")
    done

    for link in "${LINKS_TO_REMOVE[@]}"; do
        if [ -L "$link" ]; then
            sudo rm "$link"
            echo "Removed link: $link"
        fi
    done
}

# Check if the remove-links option is set
if [ "$REMOVE_LINKS" = true ]; then
    remove_links
    exit 0
fi

echo "Setting custom scripts..."

# Function to create symbolic links
create_links() {
    for script in "${SCRIPTS[@]}"; do
        script_name=$(basename "$script")

        # Check if the script file exists
        if [ ! -f "$script" ]; then
            echo "Warning: Script file '$script_name' not found. Skipping..."
        else
            # Ensure script has execution permission
            if ! [ -x "$script" ]; then
                sudo chmod +x "$script"
                echo "Added execution permission for '$script_name'"
            fi

            sudo ln -sf "$script" "$DESTINATION_LINKS_FOLDER/$script_name"
            echo "Created or replaced link for '$script_name' in $DESTINATION_LINKS_FOLDER"
        fi 
    done
}

create_links

echo "Custom scripts set in $DESTINATION_LINKS_FOLDER"

