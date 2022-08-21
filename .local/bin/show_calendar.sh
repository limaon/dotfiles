#!/usr/bin/env bash

dunstify -u low "$(cal -S) " -i "view-pim-calendar" -t 10000

# dunstify -a "volume" -u low -r "9993" -h int:value:"$volume" -i "audio-volume-$1" "Volume: ${volume}%" -t 2000
