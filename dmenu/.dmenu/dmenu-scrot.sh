#!/bin/bash
#changelog
#v0.3
#added 1. Notifications 2.unique names for each type (for quick launch) 3.better photo editor (pinta) 4.dmenu title
#v0.4
#1.Added variable for notification timeouts. 2. Show link in notification

IMG_PATH="$HOME/Pictures/Screenshots/"
UL="fb"
EDIT="gimp"
TIME=3000 #Milliseconds notification should remain visible

prog="
---Local screenshots (saved at IMG_PATH)---
1.quick_fullscreen
2.delayed_fullscreen
3.section
4.edit_fullscreen
"

cmd=$(echo "$prog" | dmenu -l 20 -nf '#999' -nb '#292d3e' -sf '#eee' -sb '#0077bb' -p 'Choose Screenshot Type')

cd "$IMG_PATH"
case ${cmd%% *} in
    1.quick_fullscreen) scrot -d 1 '%Y-%m-%d-@%H-%M-%S-scrot.png' && notify-send -u low -t "$TIME" 'Scrot' 'Fullscreen taken and saved' ;;
    2.delayed_fullscreen) scrot -d 4 '%Y-%m-%d-@%H-%M-%S-scrot.png' && notify-send -u low -t "$TIME" 'Scrot' 'Fullscreen Screenshot saved' ;;
    3.section) sleep 0.5 && filename="$(date +'%Y-%m-%d-@%H-%M-%S-scrot.png')" && scrot -s "$filename" --freeze && xclip -selection clipboard -t image/png < "$filename" && notify-send -u low -t "$TIME" 'Scrot' 'Screenshot of section saved' ;;
	4.edit_fullscreen) scrot -d 1 '%Y-%m-%d-@%H-%M-%S-scrot.png' -e "$EDIT \$f" && notify-send -u low -t "$TIME" 'Scrot' 'Screenshot edited and saved' ;;

    *) exec "${cmd}" ;;
esac
