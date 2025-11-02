#!/usr/bin/env bash
#
# Use https://github.com/zquestz/s to execute a web search in the selected provider
s -p $(s --list-providers | rofi -dmenu -mesg ">>> Tab = Autocomplete" -i -p "websearch: ")
