#!/bin/bash

# Get all user-owned processes with PID, command
PROCESSES=$(ps -u "$USER" -o pid=,comm= --sort=comm | awk '{printf "%s %s\n", $1, $2}')

# Show in rofi
CHOICE=$(echo "$PROCESSES" | rofi -dmenu -i -p "Kill process:")

# If nothing selected, exit
[[ -z "$CHOICE" ]] && exit 0

# Extract PID
PID=$(echo "$CHOICE" | awk '{print $1}')

kill -9 "$PID" && notify-send "☠️ Killed" "Process $PID"
notify-send "❌ Cancelled" "No process killed"
