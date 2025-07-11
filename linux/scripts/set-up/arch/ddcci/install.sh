#!/usr/bin/env bash
#source: https://clinta.github.io/external-monitor-brightness/

set -e

#Add a ddcci service
SVC_NAME='ddcci@.service'
SVC_DEST="/etc/systemd/system/$SVC_NAME" # /etc/systemd/system/'ddcci@.service'
if [ ! -f "$SVC_DEST" ]; then 
  echo "Creating ddcci service at: $SVC_DEST"
  cat ./$SVC_NAME > "$SVC_DEST"
else
  echo "$SVC_DEST already exists"
fi

# Add a udev rule to load this service on attachment of the Nvidida i2c adapter
RULE_NAME="99-ddcci.rules"
RULE_DEST="/etc/udev/rules.d/$RULE_NAME" # /etc/udev/rules.d/99-ddcci.rules
if [ ! -f "$RULE_DEST" ]; then 
  echo "Creating ddcci rule at: $RULE_DEST"
  cat ./$RULE_NAME > "$RULE_DEST"
else
  echo "$RULE_DEST already exists"
fi

#Reload udev rules
udevadm control --reload-rules
udevadm trigger

#Load the i2c-dev module:
modprobe i2c-dev

echo "success" >&2
exit 0
