#!/usr/bin/env bash

#echo -en "\0prompt\x1fChange prompt\n"
##echo -en "aap\0icon\x1ffolder\x1finfo\x1ftest\n"
#
#DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
#
#if [ $# -gt 0 ]; then
#  #trap "sleep 3 && rofi -show new -modi new:$DIR/$@" 0
#  trap "sleep 3 && rofi -show $@ -modi $@:./$DIR/$@" 0
#  exit 0
#else
#  options=$(ls "$DIR/plugins")
#  echo "$options"
#fi

show_menu() {
  printf "%s\n" "$@"
}

#case "$1" in
#  "")
#    show_menu "Opt 1" "Opt 2" "Opt 3"
#    ;;
#  "Opt 1")
#    show_menu "A" "B" "C"
#    ;;
#  "Opt 2")
#    show_menu "D" "E"
#    ;;
#  "Opt 3")
#    show_menu "F"
#    ;;
#esac

set -eo pipefail

SCRIPT="$0"

main_menu() {
  echo -e "Opt 1\0info\x1fopt1"
  echo -e "Opt 2\0info\x1fopt2"
  echo -e "Opt 3\0info\x1fopt3"
}

opt1_menu() {
  echo -e "A\0info\x1fopt1:A"
  echo -e "B\0info\x1fopt1:B"
  echo -e "C\0info\x1fopt1:C"
  echo -e "⬅ Back\0info\x1fback"
}

opt2_menu() {
  echo -e "D\0info\x1fopt2:D"
  echo -e "E\0info\x1fopt2:E"
  echo -e "⬅ Back\0info\x1fback"
}

opt3_menu() {
  echo -e "F\0info\x1fopt3:F"
  echo -e "⬅ Back\0info\x1fback"
}

echo "INFO=$ROFI_INFO RETV=$ROFI_RETV 1=$1 2=$2" >&2

if [[ $ROFI_RETV -eq 0 ]]; then
  main_menu 
  exit 0
fi

case "$ROFI_INFO" in
  opt1) opt1_menu  ;;
  opt2) opt2_menu ;;
  opt3) opt3_menu ;;
  opt1:A) notify-send "Opt 1 → A" ;;
  opt1:B) notify-send "Opt 1 → B" ;;
  opt1:C) notify-send "Opt 1 → C" ;;
  back) rofi -show test -modi "test:$SCRIPT" ;;
esac
