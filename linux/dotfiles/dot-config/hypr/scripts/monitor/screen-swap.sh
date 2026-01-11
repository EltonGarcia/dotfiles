#!/usr/bin/env bash

read name code < <(_get-display-input)

_monitor-toggle-dell-input

echo "##### result: $?"
if [[ "$name" =~ (DisplayPort[\-0-9]*) ]]; then
  hyprctl keyword monitor DP-1, disable
  echo "##### WIll disable DP"
else
  hyprctl reload
  echo "##### WIll enable DP"
fi
