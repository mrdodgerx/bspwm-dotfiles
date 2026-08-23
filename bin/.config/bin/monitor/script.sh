#!/bin/bash
set -e

# Optional --silent: suppress the popup notification (used by watch.sh at startup)
SILENT=0
for arg in "$@"; do
    if [[ "$arg" == "--silent" ]]; then
        SILENT=1
    fi
done

INTERNAL="eDP-1"
EXTERNAL="$(xrandr | grep -E '^HDMI-[0-9] connected' | awk '{print $1}')"

notify() {
    command -v dunstify >/dev/null 2>&1 || return 0
    dunstify -a "Monitor" -r 7768 -u normal "$1" "$2" 2>/dev/null || true
}

# Turn off unused outputs safely
for out in $(xrandr | grep ' connected' | awk '{print $1}'); do
    if [[ "$out" != "$INTERNAL" && "$out" != "$EXTERNAL" ]]; then
        xrandr --output "$out" --off
    fi
done

if [[ -n "$EXTERNAL" ]]; then
    echo "External monitor detected: $EXTERNAL"

    xrandr \
        --output "$INTERNAL" --primary --mode 1920x1080 --rate 144 --pos 0x0 \
        --output "$EXTERNAL" --mode 1920x1080 --rate 60 --pos 1920x0

    # bspwm desktops
    bspc monitor "$INTERNAL" -d 1 2 3 4 5
    bspc monitor "$EXTERNAL" -d 6 7 8 9 0

    # Dual monitor: Brave goes to workspace 6 (external monitor)
    bspc rule -a Brave-browser desktop='^6'

    if [[ "$SILENT" -eq 0 ]]; then
        notify "External Monitor Connected" \
            "<b>eDP-1</b>   1 2 3 4 5  [144Hz]"$'\n'"<b>${EXTERNAL}</b>   6 7 8 9 0  [60Hz]"
    fi

else
    echo "No external monitor detected. Laptop only."

    xrandr \
        --output "$INTERNAL" --primary --mode 1920x1080 --rate 144

    bspc monitor "$INTERNAL" -d 1 2 3 4 5 6 7 8 9 0

    # Single monitor: Brave goes to workspace 2
    bspc rule -a Brave-browser desktop='^2'

    if [[ "$SILENT" -eq 0 ]]; then
        notify "External Monitor Disconnected" \
            "<b>eDP-1</b>   1 2 3 4 5 6 7 8 9 0  [144Hz]"
    fi
fi

echo "✔ Monitor configuration complete: Internal 144Hz"