#!/usr/bin/env bash

hyprctl --batch "keyword monitor HDMI-A-1, disable; keyword monitor DP-1, disable"

# wait 2 seconds
sleep 2

hyprctl reload

#hyprctl keyword monitor HDMI-A-1, disable
#hyprctl keyword monitor DP-1, disable

#hyprctl keyword monitor HDMI-A-1, 1920x1080, 1920x1080, 1
#hyprctl keyword monitor DP-1, 1920x1080, 1920x20, 1
