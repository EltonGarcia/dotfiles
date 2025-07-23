#!/usr/bin/env bash

set -euo pipefail

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
    \?)
      echo "Usage: $(basename "$0") [-d|-i]" >&2
      exit 1
      ;;
  esac
done

brightnessctl -l -c backlight -m | cut -d , -f1 | while IFS= read -r dev; do brightnessctl -d $dev s $ACTION; done
