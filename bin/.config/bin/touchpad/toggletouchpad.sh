#!/bin/bash
deviceNum=$(xinput | grep "Touchpad" | awk -F"=" '{ print $2 }' | awk '{print substr ($0, 0, 2)}')
devicestr=$(xinput list-props $deviceNum | grep "Device Enabled (181):.*1")  
echo $deviceNum
echo $devicestr
#echo [ $devicestr !="" ]
if [ "$devicestr" != "" ]; then
    xinput disable $deviceNum
    notify-send -u low -i mouse "Trackpad disabled"
else
    xinput enable $deviceNum
    notify-send -u low -i mouse "Trackpad enabled"
fi
