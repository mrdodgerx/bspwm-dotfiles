#!/bin/bash

GTK_FILE="$HOME/.config/gtk-3.0/settings.ini"
XSETTINGS_FILE="$HOME/.config/xsettingsd/xsettingsd.conf"

mkdir -p ~/.config/xsettingsd

get_val() {
    grep "^$1=" "$GTK_FILE" | cut -d= -f2
}

cat > "$XSETTINGS_FILE" <<EOF
Net/ThemeName "$(get_val gtk-theme-name)"
Net/IconThemeName "$(get_val gtk-icon-theme-name)"
Gtk/FontName "$(get_val gtk-font-name)"
Gtk/CursorThemeName "$(get_val gtk-cursor-theme-name)"
Gtk/ApplicationPreferDarkTheme $( [ "$(get_val gtk-application-prefer-dark-theme)" = "true" ] && echo 1 || echo 0 )

Xft/Antialias $(get_val gtk-xft-antialias)
Xft/Hinting $(get_val gtk-xft-hinting)
Xft/HintStyle "$(get_val gtk-xft-hintstyle)"
Xft/RGBA "$(get_val gtk-xft-rgba)"
EOF

# Reload xsettingsd without restart
pkill -HUP xsettingsd 2>/dev/null || xsettingsd &
