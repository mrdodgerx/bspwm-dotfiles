#!/bin/sh
STATE_FILE="$HOME/.config/bspwm/audio_state"
{
  echo "SINK_VOL=$(pactl get-sink-volume @DEFAULT_SINK@   | grep -oP '\d+(?=%)' | head -1)"
  echo "SINK_MUTE=$(pactl get-sink-mute  @DEFAULT_SINK@   | awk '{print $NF}')"
  echo "SRC_VOL=$(pactl get-source-volume @DEFAULT_SOURCE@ | grep -oP '\d+(?=%)' | head -1)"
  echo "SRC_MUTE=$(pactl get-source-mute  @DEFAULT_SOURCE@ | awk '{print $NF}')"
} > "$STATE_FILE"
