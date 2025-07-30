#!/usr/bin/env bash

# --- Load Secrets ---
# Decrypt and source secrets if the encrypted file exists.
# This will prompt for your GPG passphrase.
SECRETS_FILE="$(dirname "$0")/secrets.sh.gpg"
if [ -f "$SECRETS_FILE" ]; then
  echo "Loading encrypted secrets..."
  source <(gpg --quiet --batch --decrypt "$SECRETS_FILE")
else
  echo "Warning: Secrets file not found at '$SECRETS_FILE'."
  echo "Please run './configure-secrets.sh' to create it."
fi
# --------------------

# enable bluetooth
sudo systemctl enable bluetooth
sudo systemctl start bluetooth

# enable nvidia daemons
sudo systemctl enable nvidia-suspend.service
sudo systemctl enable nvidia-hibernate.service
sudo systemctl enable nvidia-resume.service

# enable waybar through uwsm: https://wiki.hypr.land/Useful-Utilities/Status-Bars/#how-to-launch
systemctl --user enable --now waybar.service


