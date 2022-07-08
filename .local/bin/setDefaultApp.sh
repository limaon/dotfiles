#!/usr/bin/env bash

FILETYPE=$(xdg-mime query filetype $1)
APP=$( find /usr/share -type f -name "*.desktop" -printf "%p\n" | rofi -threads 0 -dmenu -i -p "select default app")
APP=$(basename -- $APP)
xdg-mime default "$APP" "$FILETYPE"
echo "$APP set as default application to open $FILETYPE"
