#!/bin/bash

# Use $XINITRC variable if file exists.
[ -f "$XINITRC" ] && alias startx="startx $XINITRC"

# Confirm before overwriting something
alias \
  cp="cp -iv" \
  mv="mv -iv" \
  rm="rm -vI" \
  rsync="rsync -vrPlu" \
  pstree="pstree -npTC age"

# Colors commands
alias \
  ls="ls -hN --group-directories-first --time-style=+'%d.%m.%Y %H:%M' --color=auto" \
  ll="ls -lvh" \
  la="ls -lavh --ignore=.. --ignore=." \
  dir='dir --color=auto' \
  vdir='vdir --color=auto' \
  diff="diff --color=auto" \
  grep='grep --color=tty -d skip' \
  ggrep="grep --exclude-dir=.git" \
  egrep='egrep --color=auto' \
  fgrep='fgrep --color=auto' \
  rmpyc='find . -name "*.pyc" -exec rm -f {} \;' \
  ping='ping -c 5' \
  ip="ip -color=auto" \

# Youtube
alias \
  yt="yt-dlp --embed-metadata --embed-thumbnail -i -o '~/Videos/%(title)s.%(ext)s' -f mp4 --sponsorblock-remove all " \
  ytautosub="yt --write-sub --sub-lang en --convert-subs vtt " \
  ytaudio="yt-dlp -x -f bestaudio/best -i -o '~/Music/%(title)s.%(ext)s' --audio-format opus" \
  mp3dl="yta --audio-quality 1 --audio-format mp3" \
  ytt="yt-dlp --skip-download --write-thumbnail -o '~/Pictures/%(title)s.%(ext)s'" \

#Display ISO version and distribution information in short
alias version="sed -n 1p /etc/os-release && sed -n 11p /etc/os-release && sed -n 12p /etc/os-release"

# Journal
alias \
  journal="journalctl --since '3 day ago'" \
  errors="journalctl -p err..alert -b -e" \

# Other alias
alias \
  lf="lfcd" \
  update-grub="sudo grub-mkconfig -o /boot/grub/grub.cfg" \
  genpasswd="openssl rand -base64 21" \
  trim="sudo fstrim -v / && sudo fstrim -v /home" \

# Applications
alias \
  clock="ncmpcpp -s clock" \
  visualizer="ncmpcpp -s visualizer" \
  nf="clear && neofetch" \

# dotfiles in git
# https://wiki.archlinux.org/index.php/Dotfiles
alias dot='git --git-dir=${XDG_CONFIG_HOME:-$HOME/.config}/dotfiles/ --work-tree=$HOME'

# Pacman / System
alias \
  lsp="pacman -Qett --color=always | less" \
  trimlogs='sudo journalctl --vacuum-size=150M' \
  pacclean="remorphans && sudo pacman -Sc && trimlogs" \
  whathaveidone="tail -500 /var/log/pacman.log | grep -i 'installed\|removed\|graded' --color=never" \
  unlock="sudo rm /var/lib/pacman/db.lck" \
  autoremove="sudo pacman -Rns" \
  parsua="paru -Sua" \
  aurlist="pacman -Qm" \
  refl="sudo reflector --verbose --country Brazil --latest 10 --sort rate --save /etc/pacman.d/mirrorlist" \
  # refl="sudo reflector --protocol https --download-timeout 60 --verbose --age 6 --latest 100 --fastest 10 --sort rate --country "$(curl -Ls "ifconfig.co/country"),DE,FR,GB,NL,PL,RU,BY,CZ,FI,SE,CH,HU,NO,BR" --save /etc/pacman.d/mirrorlist" \
