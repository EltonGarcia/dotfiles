#!/bin/bash
# jq - https://github.com/jqlang/jq/releases/download/jq-1.7.1/jq-1.7.1.tar.gz

# Check if an URL was provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <URL>"
    echo "Example: $0 https://github.com/jqlang/jq/releases/download/jq-1.7.1/jq-1.7.1.tar.gz"
    exit 1
fi

URL=$1

# Validate the URL format (basic validation)
if ! [[ $URL =~ ^https?:// ]]; then
    echo "Invalid URL provided. Please include http:// or https://"
    exit 1
fi

#sudo apt purge jq

FILE=$(basename $URL)
NAME=$(basename $(dirname $URL))
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
