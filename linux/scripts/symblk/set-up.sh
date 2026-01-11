#!/usr/bin/env bash

TARGET_DIR="/usr/local/bin"

# List symlinks that point to executable files in the current dir
mapfile -t links < <(find . -maxdepth 1 -type l -exec test -x {} \; -print)

for link in "${links[@]}"; do
  echo "$link"
done

stow .
