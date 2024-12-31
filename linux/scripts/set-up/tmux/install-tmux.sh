#!/bin/bash

sudo apt install libevent-dev -y
if [[ $? -ne 0 ]]; then
    echo "Failed to install libevent."
    exit 1
fi

sudo apt-get install bison -y
if [[ $? -ne 0 ]]; then
    echo "Failed to install ncurses."
    exit 1
fi

# check installation dependencies
#[ -z "$(ldconfig -p | grep libevent)" ] && echo "libevent is required for installation"
#[ -z "$(ldconfig -p | grep ncurses)" ] && echo "ncurses is required for installation"

URL=https://github.com/tmux/tmux/releases/download/3.5a/tmux-3.5a.tar.gz

# Validate the URL format (basic validation)
if ! [[ $URL =~ ^https?:// ]]; then
    echo "Invalid URL provided. Please include http:// or https://"
    exit 1
fi

#sudo apt purge jq

FILE=$(basename $URL)
#NAME=$(basename $(dirname $URL))
NAME=$(echo $FILE | sed 's/\.tar\.gz$//')
DIR="/tmp/$NAME"
DEST="/tmp/$FILE"

# Download the file to /tmp directory
echo "Downloading the tar.gz file from $URL..."
curl -L -o "$DEST" "$URL"
if [[ $? -ne 0 ]]; then
    echo "Failed to download the file."
    exit 1
fi

# Extract the tar.gz file
echo "Extracting the file..."
if ! tar -xzvf "$DEST" -C /tmp; then
    echo "Failed to extract the file."
    exit 1
fi

# Change to the directory
echo "Navigating to dir $DIR"
cd "$DIR" || exit

# Configuration and Installation
echo "Configuring and installing the software..."
if ! ./configure; then
    echo "Configuration failed."
    exit 1
fi

if ! make; then
    echo "Make failed."
    exit 1
fi

if ! sudo make install; then
    echo "Installation failed."
    exit 1
fi

echo "Installation completed successfully."
