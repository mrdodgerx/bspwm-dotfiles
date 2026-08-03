#!/bin/bash

export DISPLAY=:0
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$(id -u)/bus"

WALLPAPER_DIR="$HOME/Pictures/wallpapers"

# Infinite loop to change wallpapers every 1 minute
while true; do
    # Pick random wallpapers for each display
    WALLPAPER_EDP=$(find "$WALLPAPER_DIR" -type f | shuf -n 1)
    WALLPAPER_HDMI=$(find "$WALLPAPER_DIR" -type f | shuf -n 1)

    # Apply wallpaper to each connected display
    if xrandr | grep -q "^eDP-1 connected"; then
        nitrogen --head=0 --set-scaled "$WALLPAPER_EDP"
    fi

    if xrandr | grep -q "^HDMI-1 connected"; then
        nitrogen --head=1 --set-scaled "$WALLPAPER_HDMI"
    fi

    # Wait 60 seconds before changing again
    sleep 60
done

