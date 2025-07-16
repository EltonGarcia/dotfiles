#!/usr/bin/env bash

DEVICE=$(upower -e | fzf)

# sample obj path: /org/bluez/hci0/dev_C3_41_A6_C8_93_42 
OBJ_PATH=$(upower -i $DEVICE | grep "native-path" | awk '{print $2}')

dbus-send --print-reply=literal --system --dest=org.bluez \
    $OBJ_PATH org.freedesktop.DBus.Properties.Get \
    string:"org.bluez.Battery1" string:"Percentage"
