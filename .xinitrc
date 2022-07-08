#!/bin/sh

# xinitrc
# xinitrc.d
if [ -d /etc/X11/xinit/xinitrc.d ]; then
    for f in /etc/X11/xinit/xinitrc.d/*; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

# Xresources
[[ -f ~/.config/X11/Xresources ]] && xrdb -load "${HOME}/.config/X11/Xresources"

# xprofile
[[ -f /etc/xprofile ]] && /etc/xprofile
[[ -f ~/.config/X11/xprofile ]] && "${HOME}/.xprofile"

# Start i3wm
exec i3
