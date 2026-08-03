#!/usr/bin/env bash

# Clamp mic volume to 0–100% on the default source.

step="${2:-5}"
source="@DEFAULT_SOURCE@"

get_vol() {
  pactl get-source-volume "$source" 2>/dev/null | awk 'NR==1{for(i=1;i<=NF;i++) if ($i ~ /%$/){gsub("%","",$i); print $i; exit}}'
}

clamp_0_100() {
  local v=$1
  (( v < 0 )) && v=0
  (( v > 100 )) && v=100
  echo "$v"
}

notify() {
  local vol mute
  mute=$(pactl get-source-mute "$source" 2>/dev/null | awk '{print $2}')
  if [[ "$mute" == "yes" ]]; then
    dunstify -h string:x-dunst-stack-tag:mic "Mic: Muted"
    return
  fi
  vol="$(get_vol)"; vol="${vol:-0}"
  dunstify -h string:x-dunst-stack-tag:mic \
           -h int:value:"$vol" \
           "Mic: ${vol}%"
}

case "${1:-}" in
  up)
    cur="$(get_vol)"; cur="${cur:-0}"
    new=$(( cur + step ))
    new="$(clamp_0_100 "$new")"
    pactl set-source-volume "$source" "${new}%" && notify
    ;;
  down)
    cur="$(get_vol)"; cur="${cur:-0}"
    new=$(( cur - step ))
    new="$(clamp_0_100 "$new")"
    pactl set-source-volume "$source" "${new}%" && notify
    ;;
  toggle)
    pactl set-source-mute "$source" toggle && notify
    ;;
  *)
    exit 1
    ;;
esac
