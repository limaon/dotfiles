#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

shopt -s nocaseglob

alias dotconfig='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
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
