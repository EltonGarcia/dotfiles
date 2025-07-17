#!/bin/bash
#
# This script interactively creates the 'private.sh' file by prompting the user
# for secrets based on the 'private.sh.template' file.

set -e

# Get the directory of the script
REPO_ROOT_DIR=$(git rev-parse --show-toplevel)
PRIVATE_DIR="$REPO_ROOT_DIR/linux/dotfiles/dot-config/private"
TEMPLATE_FILE="$PRIVATE_DIR/private.sh.template"
PRIVATE_FILE="$PRIVATE_DIR/private.sh"

# --- Sanity Checks ---
if [ ! -f "$TEMPLATE_FILE" ]; then
  echo "Error: Template file not found at $TEMPLATE_FILE"
  exit 1
fi

if [ -f "$PRIVATE_FILE" ]; then
  read -p "Warning: '$PRIVATE_FILE' already exists. Overwrite? (y/N) " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Aborting."
    exit 1
  fi
fi

# --- Create Private File ---
cp "$TEMPLATE_FILE" "$PRIVATE_FILE"
echo "Created '$PRIVATE_FILE'. Now prompting for secrets."
echo

# --- Process Template ---
# Use a while loop to read the template file line by line, using file descriptor 3
# to avoid consuming stdin, which is needed for the interactive user prompts.
while IFS= read -r line <&3 || [[ -n "$line" ]]; do
  # Check if the line is a HELP comment
  if [[ $line == "# HELP:"* ]]; then
    # The next line should be the export command
    read -r export_line <&3

    # Extract variable name from 'export VAR_NAME="..."'
    VAR_NAME=$(echo "$export_line" | sed -n 's/export \([^=]*\)=.*/\1/p')
    # Extract help text from '# HELP: ...'
    HELP_TEXT=$(echo "$line" | sed 's/# HELP: //')

    if [ -z "$VAR_NAME" ]; then
      continue
    fi

    # Prompt user for the secret value (reads from stdin)
    echo "$HELP_TEXT"
    read -s -p "Enter value for $VAR_NAME: " USER_INPUT
    echo
    echo

    # Replace the placeholder in the private file using a different sed delimiter
    # to handle special characters in the user input.
    sed -i "s|export $VAR_NAME=.*|export $VAR_NAME=\"$USER_INPUT\"|" "$PRIVATE_FILE"
  fi
done 3< "$TEMPLATE_FILE"

# --- Finalization ---
# Make the generated script executable only by the owner
chmod 600 "$PRIVATE_FILE"

echo "Secrets have been configured in '$PRIVATE_FILE'."
echo "IMPORTANT: This file is ignored by Git and should NOT be committed."
