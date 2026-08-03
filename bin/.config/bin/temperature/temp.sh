#!/usr/bin/env bash

# core temperature
for i in /sys/class/hwmon/hwmon*/temp*_input; do 
    if [ "$(<$(dirname $i)/name): $(cat ${i%_*}_label 2>/dev/null || echo $(basename ${i%_*}))" = "coretemp: Core 0" ]; then
        export HWMON_PATH="$i"
    fi
done;
#echo $(cat "$HWMON_PATH")
#rm -rf ~/.config/coretem && ln -s /sys/class/hwmon/hwmon4/temp2_input ~/.config/coretem
rm -rf $HOME/.config/coretem && ln -s "$HWMON_PATH" $HOME/.config/coretem
