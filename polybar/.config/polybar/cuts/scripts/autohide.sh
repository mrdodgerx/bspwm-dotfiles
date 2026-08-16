#!/usr/bin/env bash

# Auto-hide all polybar bars while any window is fullscreen.
# Keeps the bars out of the way during fullscreen (video/games/etc).
# Requires: bspc, polybar (with enable-ipc = true)

has_fullscreen() {
  bspc query -N -d focused -n .fullscreen 2>/dev/null | grep -q .
}

# polybar-msg can block if the mqueue socket is backed up; never wait forever
bar() {
  timeout 3 polybar-msg cmd "$1" >/dev/null 2>&1
}

hidden=
bspc subscribe report | while read -r _report; do
  if has_fullscreen; then
    if [[ "$hidden" != 1 ]]; then
      bar hide
      hidden=1
    fi
  else
    if [[ "$hidden" != 0 ]]; then
      bar show
      hidden=0
    fi
  fi
done