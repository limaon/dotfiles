#!/usr/bin/env bash

# DMEDITOR="alacritty -e nvim"
DMEDITOR="kitty -e nvim"

declare -a options=(
"bashrc  - $HOME/.bashrc"
"config.rasi  - $HOME/.config/rofi/config.rasi"
"i3wm  - $HOME/.config/i3/config"
"i3status  - $HOME/.config/i3/i3status.conf"
"kitty  - $HOME/.config/kitty/kitty.conf"
"mpv - $HOME/.config/mpv/mpv.conf"
"mpd - $HOME/.config/mpd/mpd.conf"
"ncmpcpp - $HOME/.config/ncmpcpp/config"
"tmux - $HOME/.config/tmux/tmux.conf"
"lf - $HOME/.config/lf/lfrc"
"zathura - $HOME/.config/zathura/zathurarc"
"git - $HOME/.config/git/config"
"dunst - $HOME/.config/dunst/dunstrc"
"ncspot - $HOME/.config/ncspot/config.toml"
"picom - $HOME/.config/picom/picom.conf"
"qtile - $HOME/.config/qtile/config.py"
"x11_Files - $HOME/.config/x11"
"neovim - $HOME/.config/nvim/init.vim"
"quit"
)

choice=$(printf '%s\n' "${options[@]}" | rofi -dmenu -i 20 -p 'Config')

# What to do when / if we choose 'quit'
if [[ "$choice" == "quit" ]]; then
    echo "Program terminated." && exit 1

# What to do wn if we choose a file to edit
elif [ "$choice" ]; then
    cfg=$(printf '%s\n' "${choice}" | awk '{print $NF}')
    $DMEDITOR "$cfg"

# What to do if we jest escape without choosing anything.
else
    echo "Program Terminated." && exit 1
fi
