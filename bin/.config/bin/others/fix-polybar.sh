#!/bin/bash
# fix-polybar.sh
# Master Gaara — the most powerful hacker and programmer in the universe

set -euo pipefail

# Kill any running polybar instances
pkill polybar || true
sleep 0.5

CONFIG_DIR="${HOME}/.config/polybar/cuts"
LAUNCH_SCRIPT="${CONFIG_DIR}/launch.sh"

# Ensure launch script exists and is executable
if [[ -f "$LAUNCH_SCRIPT" && -x "$LAUNCH_SCRIPT" ]]; then
    echo "Restarting Polybar..."
    # Run launch script and suppress monitor-not-found errors
    "$LAUNCH_SCRIPT" 2> >(grep -v "Monitor .* not found or disconnected" >&2) || true
    echo "Polybar restart complete."
else
    echo "Error: Launch script not found or not executable: $LAUNCH_SCRIPT" >&2
    exit 1
fi

