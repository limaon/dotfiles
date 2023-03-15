#!/usr/bin/env bash

DEF_EDITOR="nvim"
FONT="TerminessTTF Nerd Font:size=12"

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
  "x11_Files - $HOME/.config/x11"
  "neovim - $HOME/.config/nvim/init.lua"
)

choice=$(printf '%s\n' "${options[@]}" | sort -u | dmenu -l 5 -fn "$FONT"  -p "Edit Config:")

if [ "$choice" ]; then
    cfg=$(printf '%s\n' "${choice}" | awk '{print $NF}')

    kitty -e $DEF_EDITOR "$cfg"
else
    echo "Exiting..."; exit 1
fi
