#!/usr/bin/env bash
# Source: https://clinta.github.io/external-monitor-brightness/

set -e

if [ "$EUID" -ne 0 ]; then
  echo "Please run as root" >&2
  exit 1
fi

install_if_missing() {
  local src="$1"
  local dest="$2"

  if [ ! -f "$src" ]; then
      echo "Error: Source file '$src' not found" >&2
      exit 1
  fi

  if [ ! -f "$dest" ]; then
    echo "Creating: $dest"
    install -m 644 "$src" "$dest"
  else
    echo "$dest already exists"
  fi
}

# Install files
SVC_NAME="ddcci@.service"
SVC_DEST="/etc/systemd/system/$SVC_NAME"
install_if_missing "./$SVC_NAME" "$SVC_DEST"

RULE_NAME="99-ddcci.rules"
RULE_DEST="/etc/udev/rules.d/$RULE_NAME"
install_if_missing "./$RULE_NAME" "$RULE_DEST"

# Reload daemons and rules
systemctl daemon-reexec
systemctl daemon-reload
udevadm control --reload-rules
udevadm trigger

# Load i2c-dev kernel module
modprobe i2c-dev

echo "Successfully set up ddcci service and udev rule." >&2
exit 0
