#!/bin/bash

PC="eDP-1"
DELL="DP-1-0"
ARZOPA="HDMI-1-0"

# re-enable monitors
set_auto(){
    xrandr --auto
}

set_uniq(){
    xrandr --output $PC --primary --mode 1920x1080 --pos 0x0 --rotate normal \
        --output $DELL --off \
        --output $ARZOPA --off
}

set_default(){
    xrandr --output $PC --mode 1920x1080 --pos 0x0 --rotate normal \
        --output $DELL --primary --mode 1920x1080 --pos 1920x0 --rotate normal \
        --output $ARZOPA --mode 1920x1080 --pos 1920x1080 --rotate normal
}

set_pair(){
    xrandr --output $PC --primary --mode 1920x1080 --pos 0x0 --rotate normal \
        --output $DELL --mode 1920x1080 --pos 0x0 --rotate normal \
        --output $ARZOPA --mode 1920x1080 --pos 1350x1080 --rotate normal
}

set_mirror(){
    xrandr --output $PC --primary --mode 1920x1080 --pos 0x0 --rotate normal \
        --output $DELL --mode 1920x1080 --pos 0x0 --rotate normal \
        --output $ARZOPA --mode 1920x1080 --pos 0x0 --rotate normal
}

# Function to display script usage
display_usage() {
    echo "Usage: sudo $0 [OPTIONS]"
    echo "OPTIONS:"
    echo "  -a, --auto     xrandr auto mode"
    echo "  -u, --uniq     Disable the extra screens and keep only the integrated"
    echo "  -m, --mirror   Set screens in mirror mode"
    echo "  -d, --default  Apply screen defaut config for 3 monitors"
    echo "  -p, --pair     Apply screen config for 2 monitors, mirror DP-2 and set HDMI position"
    echo "  --help         Display this help message."
}

AUTO="AUTO"
UNIQ="UNIQ"
DEFAULT="DEFAULT"
MIRROR="MIRROR"
PAIR="PAIR"
SET_CONFIG="$DEFAULT"

if [[ $# -eq 0 ]]; then
    display_usage
    set_default
    exit 0
fi

# Parse command-line options
while [[ $# -gt 0 ]]; do
    key="$1"
    case "$key" in
        -a|--auto)
            SET_CONFIG="$AUTO"
            shift
            ;;
        -u|--uniq)
            SET_CONFIG="$UNIQ"
            shift
            ;;
        -m|--mirror)
            SET_CONFIG="$MIRROR"
            shift # past argument
            ;;
        -d|--default)
            shift # past argument
            ;;
        -p|--pair)
            SET_CONFIG="$PAIR"
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

case "$SET_CONFIG" in
    "$AUTO")
        set_auto
        ;; 
    "$UNIQ")
        set_uniq
        ;; 
    "$DEFAULT")
        set_default
        ;;
    "$MIRROR")
        set_mirror
        ;;
    "$PAIR")
        set_pair
        ;;
esac
