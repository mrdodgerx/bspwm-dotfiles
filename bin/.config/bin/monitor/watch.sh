#!/bin/bash

# Monitor hotplug watcher for bspwm.
# Applies the monitor layout at startup and re-applies it whenever the set of
# connected outputs changes (e.g. HDMI plugged in / unplugged).
# Requires: xrandr, bspc, and bin/.config/bin/monitor/script.sh

SCRIPT="$HOME/.config/bin/monitor/script.sh"
POLL_INTERVAL=3

connected_state() {
    xrandr | grep ' connected' | awk '{print $1}' | sort | tr '\n' ' '
}

# apply layout once at startup (silent — no popup on every boot)
"$SCRIPT" --silent >/dev/null 2>&1

prev=""
while true; do
    cur="$(connected_state)"
    if [[ "$cur" != "$prev" ]]; then
        "$SCRIPT" >/dev/null 2>&1
        prev="$cur"
    fi
    sleep "$POLL_INTERVAL"
done