#!/bin/bash
WALLPAPER_DIR="$HOME/Pictures"  # Change this to your wallpaper directory

# Select a random wallpaper from the directory
WALLPAPERS=("$WALLPAPER_DIR"/*)
RANDOM_WALLPAPER="${WALLPAPERS[RANDOM % ${#WALLPAPERS[@]}]}"

# Set the wallpaper
feh --bg-fill "$RANDOM_WALLPAPER"
