#!/bin/bash

TMP_FOLDER=$(mktemp -d)
STOW_URL="https://ftp.gnu.org/gnu/stow/stow-latest.tar.gz"

# Download the latest version of GNU Stow
wget -qO- $STOW_URL | tar xvz -C $TMP_FOLDER

STOW_DIR=$(ls $TMP_FOLDER)
echo $STOW_DIR
cd $TMP_FOLDER/$STOW_DIR

# Compile and install GNU Stow
./configure
make
sudo make install

# Verify installation
stow --version
