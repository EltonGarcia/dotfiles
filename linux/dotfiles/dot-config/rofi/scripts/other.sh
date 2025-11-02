#!/usr/bin/env bash

echo -en "\0prompt\x1fChange prompt\n"
#echo -en "aap\0icon\x1ffolder\x1finfo\x1ftest\n"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

if [ $# -gt 0 ]; then
  #trap "sleep 3 && rofi -show new -modi new:$DIR/$@" 0
  trap "sleep 3 && rofi -show $@ -modi $@:./$DIR/$@" 0
  exit 0
else
  options=$(ls "$DIR/plugins")
  echo "$options"
fi
