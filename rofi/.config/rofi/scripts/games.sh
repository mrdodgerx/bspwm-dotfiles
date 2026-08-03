#!/bin/bash

options="Red Alert 2
Yuri's Revenge"

chosen=$(echo -e "$options" | rofi -dmenu -i -p "Games")

case "$chosen" in
    "Red Alert 2")
        wine ~/.game/Command.\&.Conquer.Red.Alert.II/game/Ra2.exe
        ;;
    "Yuri's Revenge")
        wine ~/.game/Command.\&.Conquer.Red.Alert.II/game/RA2MD.exe
        ;;
esac
