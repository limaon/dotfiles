#
# My bashrc setup
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Defautl programs
export EDITOR="/usr/bin/nvim"
export TERMINAL="/usr/bin/kitty"
# export BROWSER="/usr/bin/firefox"
export READER="/usr/bin/zathura"

# Set language
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export LANGUAGE="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"

# XDG Paths
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XINITRC="${XDG_CONFIG_HOME:-$HOME/.config}/x11/xinitrc"

# Others Paths
export WGETRC="${XDG_CONFIG_HOME:-$HOME/.config}/wget/wgetrc"
# export XAUTHORITY="$XDG_RUNTIME_DIR/Xauthority" # This line will break some DMs
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

export GTK2_RC_FILES="${XDG_CONFIG_HOME:-$HOME/.config}/gtk-2.0/gtkrc-2.0"
export GNUPGHOME="$XDG_DATA_HOME/gnupg"
export CARGO_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/cargo"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"
export SCREENRC="$XDG_CONFIG_HOME/screen/screenrc"
export HISTCONTROL=ignoredups:erasedups           # No duplicate entries
export TMUX_TMPDIR="$XDG_RUNTIME_DIR"
export ANDROID_SDK_HOME="${XDG_CONFIG_HOME:-$HOME/.config}/android"
export ELECTRUMDIR="${XDG_DATA_HOME:-$HOME/.local/share}/electrum"

# Xorg Paths
export USERXSESSION="${XDG_CACHE_HOME:-$HOME/.cache}/X11/xsession"
export USERXSESSIONRC="${XDG_CACHE_HOME:-$HOME/.cache}/X11/xsessionrc"
export ALTUSERXSESSION="${XDG_CACHE_HOME:-$HOME/.cache}/X11/Xsession"
export ERRFILE="${XDG_CACHE_HOME:-$HOME/.cache}/X11/xsession-errors"

# PostgreSQL Paths
export PSQLRC="$XDG_CONFIG_HOME/pg/psqlrc"
export PSQL_HISTORY="$XDG_STATE_HOME/psql_history"
export PGPASSFILE="$XDG_CONFIG_HOME/pg/pgpass"
export PGSERVICEFILE="$XDG_CONFIG_HOME/pg/pg_service.conf"

# ASDF Paths
export ASDF_CONFIG_FILE="${XDG_CONFIG_HOME}/asdf/asdfrc"
export ASDF_DATA_DIR="${XDG_DATA_HOME}/asdf"
export ASDF_PYTHON_DEFAULT_PACKAGES_FILE="${XDG_CONFIG_HOME}/pip/default-python-packages"
export ASDF_NPM_DEFAULT_PACKAGES_FILE="${XDG_CONFIG_HOME}/npm/default-npm-packages"
export ASDF_GEM_DEFAULT_PACKAGES_FILE="${XDG_CONFIG_HOME}/gem/default-gems"

# Other program settings:
export _JAVA_AWT_WM_NONREPARENTING=1	# Fix for Java applications in dwm
export LESS='-F -i -J -M -R -W -x4 -X -z-4' # https://www.topbug.net/blog/2016/09/27/make-gnu-less-more-powerful/
export MOZ_USE_XINPUT2="1"		# Mozilla smooth scrolling/touchpads.


# Fix QT themes on GTK Desktops
# https://tatsumoto.neocities.org/blog/setting-up-anki.html#gtk-theme
export QT_QPA_PLATFORMTHEME=qt5ct
#export QT_QPA_PLATFORMTHEME=gtk2

# Fix QT plugin path for pyqt packages installed with pip.
# export QT_PLUGIN_PATH=/usr/lib/qt/plugins:$(find ~/.local/lib/ -type d -wholename '*/python3*/site-packages/PyQt*/plugins' | paste -s -d :)
export QT_PLUGIN_PATH=/usr/lib/qt/plugins

# Fix Java programs
# https://wiki.archlinux.org/index.php/Java_Runtime_Environment_fonts
# export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=gasp'

# Start graphical server on tty1 if not already running.
# https://wiki.archlinux.org/index.php/Xinit#Autostart_X_at_login
if [[ -z "${DISPLAY}" ]] && [[ "${XDG_VTNR}" -eq 1 ]]; then
	exec startx "$XINITRC"
fi

# Use $XINITRC variable if file exists.
[ -f "$XINITRC" ] && alias startx="startx $XINITRC"

# Shell options
shopt -s nocaseglob
shopt -s checkwinsize
[ -r /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion
source /usr/share/git/completion/git-prompt.sh

# dotfiles in git
# https://wiki.archlinux.org/index.php/Dotfiles
alias dot='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# Colors commands
alias \
        ls='ls --group-directories-first --time-style=+"%d.%m.%Y %H:%M" --color=auto -F' \
        ll="ls -lh" \
        la="ls -lah" \
        dir='dir --color=auto' \
        vdir='vdir --color=auto' \
        diff="diff --color=auto" \
        grep='grep --color=tty -d skip' \
        egrep='egrep --color=auto' \
        fgrep='fgrep --color=auto' \
        rmpyc='find . -name "*.pyc" -exec rm -f {} \;' \
        ping='ping -c 5' \

# Youtube
alias \
	yt="yt-dlp --embed-metadata --embed-thumbnail -i -o '~/Videos/%(title)s.%(ext)s' -f mp4 --sponsorblock-remove all " \
	ytautosub="yt --write-sub --sub-lang en --convert-subs vtt " \
	yta="yt-dlp -x -f bestaudio/best -i -o '~/Music/%(title)s.%(ext)s' " \
	mp3dl="yta --audio-quality 1 --audio-format mp3" \

# Confirm before overwriting something 
alias \
        cp="cp -iv" \
        mv="mv -iv" \
        rm="rm -vI" \

#Display ISO version and distribution information in short
alias version="sed -n 1p /etc/os-release && sed -n 11p /etc/os-release && sed -n 12p /etc/os-release"

#Pacman Shortcuts
alias \
        sync="sudo pacman -Sy" \
        install="sudo pacman -S" \
        update="sudo pacman -Syu" \
        search="pacman -Ss" \
        search-local="pacman -Qs" \
        pkg-info="pacman -Qi" \
        local-install="sudo pacman -U" \
        clr-cache="sudo pacman -Scc" \
        unlock="sudo rm /var/lib/pacman/db.lck" \
        autoremove="sudo pacman -Rns" \
        cleanup='sudo pacman -Rns $(pacman -Qtdq)' \
        parsua='paru -Sua' \
        aurlist='paru -Qm' \

# Journal
alias \
	journal="journalctl --since '3 day ago'" \
	errors="journalctl -p err..alert -b -e" \

# Other alias
alias \
        update-grub="sudo grub-mkconfig -o /boot/grub/grub.cfg" \
        genpasswd="openssl rand -base64 21" \

# Applications
alias \
	ncclock="ncmpcpp -s clock" \
	ncvisualizer="ncmpcpp -s visualizer" \
	nf="clear && neofetch" \

# Fancy prompting colors
red='\[\e[0;31m\]'
RED='\[\e[1;31m\]'
blue='\[\e[0;34m\]'
BLUE='\[\e[1;34m\]'
cyan='\[\e[0;36m\]'
CYAN='\[\e[1;36m\]'
NC='\[\033[0m\]'      # no color
black='\[\e[0;30m\]'
BLACK='\[\e[1;30m\]'
green='\[\e[0;32m\]'
GREEN='\[\e[1;32m\]'
yellow='\[\e[0;33m\]'
YELLOW='\[\e[1;33m\]'
magenta='\[\e[0;35m\]'
MAGENTA='\[\e[1;35m\]'
white='\[\e[0;37m\]'
WHITE='\[\e[1;37m\]'
CLEAR="\[\033[0m\]"



force_color_prompt=yes
if [ -n "$force_color_prompt" ]; then
  if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    color_prompt=yes
  else
    color_prompt=
  fi
fi

if [ "$color_prompt" = yes ]; then
  PS1="${RED}\342\224\214\342\224\200\$([[ \$? != 0 ]] && echo \"[${white}\342\234\227${RED}]\342\224\200\")[$(if [[ ${EUID} == 0 ]]; then echo "${RED}root${NC}${YELLOW}@${NC}${BLUE}\h${NC}"; else echo "${white}\u${NC}${YELLOW}@${NC}${BLUE}\h${NC}"; fi)${WHITE}:${NC}${green}\w${NC}${RED}]\$(__git_ps1 '\342\224\200[${CYAN}%s${NC}${RED}]${NC}')\n${RED}\342\224\224\342\225\274${NC}${YELLOW}\$${NC} "
  #PS1="[${white}\u${NC}@${BLUE}\h ${white}\W${NC}]${cyan}\$(__git_ps1 '|%s|')${BLUE}\$${CLEAR} "
else
  PS1='┌──[\u@\h]─[\w]\n└──╼\$ '
fi

PS2='> '
PS3='> '
PS4='+ '

# Set 'man' colors
if [ "$color_prompt" = yes ]; then
    man() {
    env \
    LESS_TERMCAP_mb=$'\e[01;31m' \
    LESS_TERMCAP_md=$'\e[01;31m' \
    LESS_TERMCAP_me=$'\e[0m' \
    LESS_TERMCAP_se=$'\e[0m' \
    LESS_TERMCAP_so=$'\e[01;44;33m' \
    LESS_TERMCAP_ue=$'\e[0m' \
    LESS_TERMCAP_us=$'\e[01;32m' \
    man "$@"
    }
fi

unset color_prompt force_color_prompt

# asdf config
. /opt/asdf-vm/asdf.sh
. ~/.local/share/asdf/plugins/java/set-java-home.bash
