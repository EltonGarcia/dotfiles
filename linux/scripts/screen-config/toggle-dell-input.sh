#!/usr/bin/env bash

CURRENT=$(ddcutil --display 1 getvcp 60 | awk '{print $NF}' | grep -o '0x[0-9a-fA-F]\+')

# Get display input codes
# ddcutil capabilities --display 1 | grep -A5 "Input Source"
case "$CURRENT" in
  0x0f) ddcutil --display 1 setvcp 60 0x11 ;; # DP → HDMI
  0x11) ddcutil --display 1 setvcp 60 0x0f ;; # HDMI → DP
  *) echo "Unknown input source: $CURRENT" ;;
esac
