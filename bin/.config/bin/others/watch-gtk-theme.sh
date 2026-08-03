#!/bin/bash
while inotifywait -e close_write ~/.config/gtk-3.0/settings.ini; do
    ~/.config/bin/others/sync-gtk-theme.sh
done
