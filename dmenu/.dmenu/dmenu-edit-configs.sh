#!/bin/bash
#  ____ _____
# |  _ \_   _|  based on Derek Taylor's (DistroTube) config-editor script
# | | | || |     adapted to this dotfiles setup
# | |_| || |     only shows configs that actually exist on this machine
# |____/ |_|
#
# Dmenu script to edit frequently-used config files. Add more below.

declare -A configs=(
	[alacritty]="$HOME/.config/alacritty/alacritty.yml"
	[zshrc]="$HOME/.zshrc"
	[bspwm]="$HOME/.config/bspwm/bspwmrc"
	[dunst]="$HOME/.config/dunst/dunstrc"
	[picom]="$HOME/.config/picom/picom.conf"
	[polybar]="$HOME/.config/polybar/cuts/config.ini"
	[sxhkd]="$HOME/.config/sxhkd/sxhkdrc"
	[vim]="$HOME/.vimrc"
	[mopidy]="$HOME/.config/mopidy/mopidy.conf"
)

# Optional entries are shown only when the path exists
optional=(
	"$HOME/st-distrotube/config.h"
	"$HOME/surf-distrotube/config.h"
	"$HOME/.config/termite/config"
	"$HOME/.config/vifm/vifmrc"
	"$HOME/.Xresources"
)

order=(alacritty zshrc bspwm dunst picom polybar sxhkd vim mopidy)

options=()
for name in "${order[@]}"; do
	[ -f "${configs[$name]}" ] && options+=("$name")
done
for p in "${optional[@]}"; do
	[ -f "$p" ] && options+=("${p##*/}")
done
options+=(quit)

choice=$(printf '%s\n' "${options[@]}" | dmenu -p 'Edit config file: ')
[ -z "$choice" ] && exit 1
[ "$choice" = quit ] && exit 1

target="${configs[$choice]}"
if [ -z "$target" ]; then
	for p in "${optional[@]}"; do
		[ "${p##*/}" = "$choice" ] && target="$p" && break
	done
fi

[ -n "$target" ] || exit 1
alacritty -e vim "$target"