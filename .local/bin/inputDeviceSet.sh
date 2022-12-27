#!/usr/bin/env bash

# Speedy keys
xset r rate 300 40 &

# Remap caps to escape set a keyboard layout
setxkbmap -option grp:alt_shift_toggle -option caps:swapescape -layout us,br -variant qwerty &

xinput set-prop "DELUX Mouse" "libinput Accel Speed" -1.0 &
xinput set-prop "06CB0301:00 06CB:CD41 Touchpad" "libinput Natural Scrolling Enabled" 1 &
xinput set-prop "06CB0301:00 06CB:CD41 Touchpad" "libinput Tapping Enabled" 1 &
