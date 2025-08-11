#!/usr/bin/env bash

DEV_UUID=$(cat bose-qc-35-se-device-uuid | sed 's/:/_/g')

BATTERY=$(dbus-send --print-reply=literal --system \
  --dest=org.bluez \
  /org/bluez/hci0/dev_"$DEV_UUID" \
  org.freedesktop.DBus.Properties.Get \
  string:"org.bluez.Battery1" string:"Percentage")

#echo "$BATTERY" | column --table-columns=variant,byte,percentage -J | jq '.table.[].percentage' -r

echo "$BATTERY" | column -t -N variant,byte,percentage -H variant,byte -d
