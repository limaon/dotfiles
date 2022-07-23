#!/usr/bin/env bash

# load Xresources
xrdb -merge "${HOME}/.config/x11/Xresources"

# set wallpaper
# feh --bg-fill --randomize ~/Pictures/backgrounds/* &
# nitrogen --set-scaled --random ~/Pictures/Wallpapers
nitrogen --restore &

# Network Manager Applet
# nm-applet --indicator &
nm-applet &

# Bluetooth systray icon
blueman-applet &

# Compositor
picom -b & disowm

# start redshift
redshift & disowm

# Gnome polkit
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 & disowm

# Hide mouse when typing
# xbanish &

# Speedy keys
xset r rate 300 40 &


# Remap caps to escape set a keyboard layout
# setxkbmap -option caps:escape
# setxkbmap -option grp:alt_shift_toggle -option caps:swapescape -layout us,br -variant qwerty
# setxkbmap -option caps:swapescape -layout us,br -variant qwerty
setxkbmap -option caps:swapescape -layout us,br &

# Mouse settings
xinput set-prop "2.4G Mouse" "libinput Accel Speed" -1.0 &
xinput set-prop "06CB0301:00 06CB:CD41 Touchpad" "libinput Natural Scrolling Enabled" 1 &
xinput set-prop "06CB0301:00 06CB:CD41 Touchpad" "libinput Tapping Enabled" 1 &

# Low battery notifier
# ~/.config/qtile/scripts/check_battery.sh & disown
