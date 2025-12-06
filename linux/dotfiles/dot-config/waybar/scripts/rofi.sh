#!/usr/bin/env bash

# When executed from waybar systemd does not contains variables from common file
source ~/.config/shell_common

ROFI_PLUGINS=$ROFI_SCRIPTS/plugins
TARGET_PLUGIN="$ROFI_PLUGINS/$1.sh"

if [[ -f "$TARGET_PLUGIN" && -x "$TARGET_PLUGIN" ]]; then
    $ROFI_PLUGINS/$1.sh &
fi
