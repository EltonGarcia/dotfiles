#!/usr/bin/env bash

set -eo pipefail

DISPLAY_NUMBER="$1"

if [[ -z "$1" ]]; then
  DISPLAY_NUMBER=1
fi

# Get input name and input code
#ddcutil --display 1 getvcp 60 | sed -nE 's/.*:\s(.*)\s\(sl=(.*)\)/\1\n\2/p'

INPUT_SOURCE=$(ddcutil --display $DISPLAY_NUMBER getvcp 60)

# Get input name
INPUT_NAME=$(echo "$INPUT_SOURCE" | sed -nE 's/.*:\s(.*)\s.*/\1/p')

# Get input code
INPUT_CODE=$(echo "$INPUT_SOURCE" | awk '{print $NF}' | grep -o '0x[0-9a-fA-F]\+')

echo "$INPUT_NAME $INPUT_CODE"
