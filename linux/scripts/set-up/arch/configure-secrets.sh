#!/bin/bash
#
# This script interactively creates an encrypted GPG file ('secrets.sh.gpg')
# with secrets defined in 'private.sh.template'.
#

set -e

# --- Configuration ---
SCRIPT_DIR="$(dirname "$0")"
TEMPLATE_FILE="$SCRIPT_DIR/private.sh.template"
ENCRYPTED_FILE="$SCRIPT_DIR/secrets.sh.gpg"
PLAINTEXT_SECRETS=$(mktemp)

# --- Cleanup ---
# Ensure the temporary plaintext file is deleted on exit
trap 'rm -f "$PLAINTEXT_SECRETS"' EXIT

# --- Sanity Checks ---
if ! command -v gpg &> /dev/null; then
    echo "Error: gpg is not installed. Please install GnuPG."
    exit 1
fi

if [ ! -f "$TEMPLATE_FILE" ]; then
  echo "Error: Template file not found at $TEMPLATE_FILE"
  exit 1
fi

if [ -f "$ENCRYPTED_FILE" ]; then
  read -p "Warning: '$ENCRYPTED_FILE' already exists. Overwrite? (y/N) " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Aborting."
    exit 1
  fi
fi

# --- Process Template ---
echo "Reading secrets from template..."
cp "$TEMPLATE_FILE" "$PLAINTEXT_SECRETS"

# Use file descriptor 3 to read the template, leaving stdin for user input
while IFS= read -r line <&3; do
  if [[ $line == "# HELP:"* ]]; then
    read -r export_line <&3
    VAR_NAME=$(echo "$export_line" | sed -n 's/export \([^=]*\)=.*/\1/p')
    HELP_TEXT=$(echo "$line" | sed 's/# HELP: //')

    if [ -z "$VAR_NAME" ]; then continue; fi

    echo "$HELP_TEXT"
    read -s -p "Enter value for $VAR_NAME: " USER_INPUT
    echo; echo

    # Replace placeholder in the temp file
    sed -i "s|export $VAR_NAME=.*|export $VAR_NAME=\"$USER_INPUT\"|" "$PLAINTEXT_SECRETS"
  fi
done 3< "$TEMPLATE_FILE"

set -x
# --- Encrypt File ---
echo "Encrypting secrets to '$ENCRYPTED_FILE'..."
gpg --symmetric --cipher-algo AES256 --output "$ENCRYPTED_FILE" "$PLAINTEXT_SECRETS"

# Securely shred the temporary file
shred -u "$PLAINTEXT_SECRETS"
set +x

echo
echo "Success! Encrypted secrets stored in '$ENCRYPTED_FILE'."
echo "You can safely commit this file to your repository."
