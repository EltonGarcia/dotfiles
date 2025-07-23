#!/usr/bin/env bash

INCREASE="10%+"
DECREASE="10%-"

ACTION="$INCREASE"

while getopts "di" arg; do
  case $arg in
    d)
      ACTION="$DECREASE"
      ;;
    i)
      ACTION="$INCREASE"
      ;;
  esac
done

brightnessctl -l -c backlight -m | cut -d , -f1 | while IFS= read -r dev; do brightnessctl -d $dev s $ACTION; done
