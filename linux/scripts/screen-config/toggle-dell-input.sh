#!/usr/bin/env bash
# To get display input names and codes:
#   ddcutil capabilities --display 1 | grep -A5 "Input Source"

set -eo pipefail

DISPLAY="$1"

if [[ -z "$1" ]]; then
  DISPLAY=1
fi

switch_to_hdmi() {
  ddcutil --display $DISPLAY setvcp 60 0x11 
}

switch_to_dp() {
  ddcutil --display $DISPLAY setvcp 60 0x0f
}

read name code < <(_get-display-input $DISPLAY)

case "$name" in
  0x0f) switch_to_hdmi;; # DP → HDMI
  0x11) switch_to_dp ;; # HDMI → DP
  DisplayPort*) switch_to_hdmi ;;
  HDMI*) switch_to_dp ;;
  *) echo "Unknown input source: $name" ;;
esac
