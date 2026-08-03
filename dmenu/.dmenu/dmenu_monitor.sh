#!/bin/bash
#changelog
# dual mod monitor

TIME=3000 #Miliseconds notification should remain visible

prog="
---Monitor Setting---
1.Laptop_Screen_Only
2.Duplicate_Screen
3.Extent_Screen
4.Second_Screen_Only
"

cmd=$(dmenu  -l 20  -nf '#999' -nb '#292d3e' -sf '#eee' -sb '#0077bb' -p 'Choose Screen Setting'   <<< "$prog")

cd $IMG_PATH
case ${cmd%% *} in

	1.Laptop_Screen_Only) xrandr --output eDP-1 --primary --mode 1920x1080 --rotate normal --output HDMI-1 --off && bspc monitor eDP-1 -d 1 2 3 4 5  && ~/.config/bspwm/bspwm_reorder_screen.sh &&  notify-send -u low -t $TIME 'Change to Laptop Screen Only'  ;;
	2.Duplicate_Screen)	 xrandr --output eDP-1 --primary --mode 1920x1080 --rotate normal --output HDMI-1 --mode 1920x1080 --rotate normal --same-as eDP-1 && bspc monitor eDP-1 -d 1 2 3 4 5 && ~/.config/bspwm/bspwm_reorder_screen.sh && notify-send -u low -t $TIME 'Change to Duplicate Screen'   ;;
	3.Extent_Screen) xrandr --output eDP-1 --primary --mode 1920x1080 --rotate normal --output HDMI-1 --mode 1920x1080 --rotate normal --right-of eDP-1 && bspc monitor eDP-1 -d 1 2 3 4 5 && bspc monitor HDMI-1 -d 6 7 8 9 0 &&  notify-send -u low -t $TIME 'Extent Screen'    ;;
	4.Second_Screen_Only) xrandr --output HDMI-1 --primary --mode 1920x1080 --rotate normal --output eDP-1 --off && bspc monitor HDMI-1 -d 1 2 3 4 5 6 7 8 9 0 && ~/.config/bspwm/bspwm_reorder_screen.sh &&  notify-send -u low -t $TIME 'Change to Second Screen Only'  ;;

  	*)		exec "'${cmd}'"  ;;
esac
