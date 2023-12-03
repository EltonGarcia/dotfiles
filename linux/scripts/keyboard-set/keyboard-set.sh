#!/bin/bash -x

setxkbmap -model pc105 -layout us -variant intl
setxkbmap -option caps:super

echo "keyboard has been set"
