#!/bin/bash
set -e

INTERNAL="eDP-1"
EXTERNAL="$(xrandr | grep -E '^HDMI-[0-9] connected' | awk '{print $1}')"

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

else
    echo "No external monitor detected. Laptop only."

    xrandr \
        --output "$INTERNAL" --primary --mode 1920x1080 --rate 144

    bspc monitor "$INTERNAL" -d 1 2 3 4 5 6 7 8 9 0
fi

echo "✔ Monitor configuration complete: Internal 144Hz"
