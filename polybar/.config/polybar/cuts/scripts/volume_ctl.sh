#!/usr/bin/env bash

# Clamp volume to 0–100% on the default sink.

step="${2:-5}"
sink="@DEFAULT_SINK@"

get_vol() {
  pactl get-sink-volume "$sink" 2>/dev/null | awk 'NR==1{for(i=1;i<=NF;i++) if ($i ~ /%$/){gsub("%","",$i); print $i; exit}}'
}

clamp_0_100() {
  local v=$1
  (( v < 0 )) && v=0
  (( v > 100 )) && v=100
  echo "$v"
}

notify() {
  local vol
  vol="$(get_vol)"; vol="${vol:-0}"
  dunstify -h string:x-dunst-stack-tag:volume \
           -h int:value:"$vol" \
           "Volume: ${vol}%"
}

case "${1:-}" in
  up)
    cur="$(get_vol)"; cur="${cur:-0}"
    new=$(( cur + step ))
    new="$(clamp_0_100 "$new")"
    pactl set-sink-volume "$sink" "${new}%" && notify
    ;;
  down)
    cur="$(get_vol)"; cur="${cur:-0}"
    new=$(( cur - step ))
    new="$(clamp_0_100 "$new")"
    pactl set-sink-volume "$sink" "${new}%" && notify
    ;;
  set)
    val="${2:-0}"
    val="$(clamp_0_100 "$val")"
    pactl set-sink-volume "$sink" "${val}%" && notify
    ;;
  *)
    exit 1
    ;;
esac

