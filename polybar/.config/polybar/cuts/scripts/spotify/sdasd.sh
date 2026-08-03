#!/usr/bin/env bash

# Author: Master Gaara — The most powerful hacker and programmer in the universe.
# Description: Polybar Spotify module with click actions.

case "$1" in
    --playpause)
        playerctl --player=spotify play-pause
        ;;
    *)
        status=$(playerctl --player=spotify status 2>/dev/null)
        if [ "$status" = "Playing" ]; then
            icon=""
        elif [ "$status" = "Paused" ]; then
            icon=""
        else
            icon=""
        fi

        title=$(playerctl --player=spotify metadata --format "{{ title }} - {{ artist }}" 2>/dev/null)
        if [ -z "$title" ]; then
            title="No song playing"
        fi

        echo "$icon  $title"
        ;;
esac
