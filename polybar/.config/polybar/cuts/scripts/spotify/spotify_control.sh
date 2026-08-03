#!/usr/bin/env bash

# Polybar module for Spotify with prev/play-pause/next buttons and track display

case "$1" in
    --playpause)
        playerctl --player=spotify play-pause
        ;;
    --next)
        playerctl --player=spotify next
        ;;
    --previous)
        playerctl --player=spotify previous
        ;;
    *)
        status=$(playerctl --player=spotify status 2>/dev/null)
        title=$(playerctl --player=spotify metadata --format "{{ title }} - {{ artist }}" 2>/dev/null)

        if [ -z "$title" ]; then
            title="No song playing"
        else
            title=$(echo "$title" | cut -c1-40)
        fi

        if [ "$status" = "Playing" ]; then
            play_icon=""
        else
            play_icon=""
        fi

        prev="%{A1:playerctl --player=spotify previous:}%{F#42A5F5}%{F-}%{A}"
        play="%{A1:playerctl --player=spotify play-pause:}%{F#fdd835}$play_icon%{F-}%{A}"
        next="%{A1:playerctl --player=spotify next:}%{F#43a047}%{F-}%{A}"
        search="%{A1:$HOME/.config/polybar/cuts/scripts/spotify/spotify_search.sh:}%{F#1DB954}  %{F-}%{A}"

        echo "$prev    $play    $next    $title    $search"
        ;;
esac
