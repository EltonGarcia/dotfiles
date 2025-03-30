#!/bin/bash -x

setxkbmap -model pc105 -layout us -variant intl
setxkbmap -model abnt -layout us -variant intl
setxkbmap -option caps:super

xset r rate 200 50

echo "keyboard has been set"
