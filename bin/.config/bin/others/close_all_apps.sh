#!/bin/bash

# Get the list of all window IDs
windows=$(bspc query -N)

# Close each window
for window in $windows; do
  bspc node "$window" -c
done
