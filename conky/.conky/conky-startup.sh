#!/bin/bash
LOG="$HOME/.conky/conky-startup.log"
echo "[$(date)] Starting conky..." >> "$LOG"
if [ -x "$HOME/.conky/Conky-BSPWM/scripts/conky-startup.sh" ]; then
    "$HOME/.conky/Conky-BSPWM/scripts/conky-startup.sh" >> "$LOG" 2>&1
else
    echo "[$(date)] ERROR: $HOME/.conky/Conky-BSPWM/scripts/conky-startup.sh not found or not executable" >> "$LOG"
fi