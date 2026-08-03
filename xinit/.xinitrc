#!/bin/sh

# Start sxhkd (keybindings)
sxhkd &

# Optional: start picom
# picom &

# Start bspwm
exec bspwm
