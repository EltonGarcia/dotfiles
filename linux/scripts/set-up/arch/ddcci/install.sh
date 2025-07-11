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

DDCCI_SVC_RULE="99-ddcci.rules"
DDCCI_SVC_RULE_DEST="/etc/udev/rules.d/$DDCCI_SVC_RULE"
install_if_missing "./$DDCCI_SVC_RULE" "$DDCCI_SVC_RULE_DEST"

# Evaluate if required
#DDCCI_I2C_RULE="60-ddcutil-i2c.rules"
#DDCCI_I2C_RULE_DEST="/etc/udev/rules.d/$DDCCI_I2C_RULE"
#install_if_missing "./$DDCCI_I2C_RULE" "$DDCCI_I2C_RULE_DEST"

# Reload daemons and rules
systemctl daemon-reexec
systemctl daemon-reload
udevadm control --reload-rules
udevadm trigger

# Load i2c-dev kernel module
modprobe i2c-dev

echo "Successfully set up ddcci service and udev rule." >&2
exit 0
