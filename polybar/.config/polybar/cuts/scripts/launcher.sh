#!/usr/bin/env bash
# Ensure the full environment is present for Rofi
export XDG_CURRENT_DESKTOP=bspwm
export DESKTOP_SESSION=bspwm
export PATH="$HOME/.local/bin:$PATH"
export XDG_DATA_DIRS="$HOME/.local/share/flatpak/exports/share:$HOME/.local/share:/var/lib/flatpak/exports/share:/usr/local/share:/usr/share"

# Optional: ensure Rofi sees D-Bus from your session, not a new one
if [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
  eval "$(dbus-launch --sh-syntax)"
fi

exec rofi -no-config -no-lazy-grab -show drun -modi drun -theme ~/.config/polybar/cuts/scripts/rofi/launcher.rasi
