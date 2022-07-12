#
# My bashrc setup
#

# Environment variables set everywhere
export EDITOR="/usr/bin/nvim"
export TERMINAL="/usr/bin/alacritty"
export BROWSER="/usr/bin/firefox"
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export LANGUAGE="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"

# XDG Paths
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# Others Paths
export WGETRC="$XDG_CONFIG_HOME/wget/wgetrc"
# export XAUTHORITY="$XDG_RUNTIME_DIR/Xauthority" # This line will break some DMs
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc-2.0"
export GNUPGHOME="$XDG_DATA_HOME/gnupg"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"
export SCREENRC="$XDG_CONFIG_HOME/screen/screenrc"
export HISTCONTROL=ignoredups:erasedups           # No duplicate entries

# Xorg Paths
export USERXSESSION="$XDG_CACHE_HOME/X11/xsession"
export USERXSESSIONRC="$XDG_CACHE_HOME/X11/xsessionrc"
export ALTUSERXSESSION="$XDG_CACHE_HOME/X11/Xsession"
export ERRFILE="$XDG_CACHE_HOME/X11/xsession-errors"

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

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

shopt -s nocaseglob

alias gitdf='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias ls='ls -F --color=auto --group-directories-first'
alias grep='grep --color=always'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias rmpyc='find . -name "*.pyc" -exec rm -f {} \;'
alias ping='ping -c 5'

# confirm before overwriting something 
alias cp="cp -i" 
alias mv='mv -i' 
alias rm='rm -i'

#PS1='[\u@\h \W]\$ '

#Display ISO version and distribution information in short
alias version="sed -n 1p /etc/os-release && sed -n 11p /etc/os-release && sed -n 12p /etc/os-release"

#Pacman Shortcuts
alias sync="sudo pacman -Syyy"
alias install="sudo pacman -S"
alias update="sudo pacman -Syyu"
alias search="pacman -Ss"
alias search-local="pacman -Qs"
alias pkg-info="pacman -Qi"
alias local-install="sudo pacman -U"
alias clr-cache="sudo pacman -Scc"
alias unlock="sudo rm /var/lib/pacman/db.lck"
alias autoremove="sudo pacman -Rns"
alias cleanup='sudo pacman -Rns $(pacman -Qtdq)'    # remove orphaned packages
alias parsua='paru -Sua --noconfirm'                # update only AUR pkgs (paru)

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

[ -r /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion
source /usr/share/git/completion/git-prompt.sh

PS1="[$BLUE\u$CLEAR@$WHITE\h $white\W$CLEAR]$MAGENTA\$(__git_ps1 ' (%s)') $BLUE\$$CLEAR "
PS2='> '
PS3='> '
PS4='+ '
 

# asdf config
 . /opt/asdf-vm/asdf.sh
