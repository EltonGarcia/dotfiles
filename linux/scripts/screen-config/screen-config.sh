#!/bin/bash

set_default(){
     xrandr --output DP-0 --off --output DP-1 --off --output DP-2 --off \
         --output DP-3 --off --output HDMI-0 --mode 1920x1080 --pos 1920x0 \
         --rotate normal --output eDP-1-1 \
         --mode 1920x1080 --pos 0x77 --rotate normal
}

set_mirror(){
    xrandr --output DP-0 --off --output DP-1 --off --output DP-2 --off \
        --output DP-3 --off --output HDMI-0 --mode 1920x1080 --pos 0x0 \
        --rotate normal --output eDP-1-1 \
        --mode 1920x1080 --pos 0x0 --rotate normal
}

# Function to display script usage
display_usage() {
    echo "Usage: sudo $0 [OPTIONS]"
    echo "OPTIONS:"
    echo "  -m, --mirror   Set screens in mirror mode"          
    echo "  -d, --default  Apply screen defaut config"
    echo "  --help         Display this help message."
}

SET_DEFAULT_CONFIG=1

if [[ $# -eq 0 ]]; then
    display_usage
    set_default
    exit 0
fi

# Parse command-line options
while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        -m|--mirror)
            SET_DEFAULT_CONFIG=0
            shift # past argument
            ;;
        -d|--default)
            shift # past argument
            ;;
        --help)
            display_usage
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            display_usage
            exit 1
            ;;
    esac
done

if [ "$SET_DEFAULT_CONFIG" == 1 ]; then
    set_default
else
    set_mirror
fi
