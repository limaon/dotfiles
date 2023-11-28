# The  personal initialization file, executed for login shells.
# ~/.bashrc: executed by bash(1) for non-login shells.

# If not running interactively, don't do anything
[ -z "$PS1" ] && return


# Reset path (or else it gets longer each time this is sourced)
export PATH=$(getconf PATH)


# FZF default options
export FZF_DEFAULT_OPTS="--layout=reverse --height 40%"


# Default options for less (see: man less)
export LESS="-F -i -J -M -R -W -x4 -X -z-4"


# Fix adding quotes around names with spaces
# https://unix.stackexchange.com/questions/258679/why-is-ls-suddenly-wrapping-items-with-spaces-in-single-quotes
export QUOTING_STYLE=literal


# Don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace:erasedups


# For setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000
HISTTIMEFORMAT="%Y-%m-%d %H:%M.%S | "


# Shell options
shopt -s nocaseglob checkwinsize autocd cdspell \
  globstar histappend extglob dotglob direxpand \
  histverify lithist cmdhist

complete -cf doas
set -o noclobber


# Set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
  xterm-color|*-256color) color_prompt=yes;;
esac


# Function to view jobs in background in prompt
prompt_command() {
  local job_count=$(jobs | wc -l | tr -d ' ')
  local job_indicator="+"
  if [ $job_count -gt 0 ]; then
    prompt_job="[$job_count]$job_indicator "
  else
    prompt_job=""
  fi
}
PROMPT_COMMAND=prompt_command

# Color definitions
term_colors() {
  local green='\[\e[0;32m\]'
  local white='\[\e[0;37m\]'
  local blue='\[\e[0;34m\]'
  local MAGENTA='\[\e[1;35m\]'
  local yellow='\[\e[0;33m\]'
  local RED="\[\033[1;31m\]"
  local CLEAR="\[\033[0m\]"

  local GIT_PS1="(__git_ps1 ' ${MAGENTA}git:(${yellow}%s${CLEAR}${MAGENTA})')"
  local USER="${CLEAR}${green}\u"
  local HOST="\h${white}"
  local DIR="${blue}\W"

  PS1="${RED}\${prompt_job}${USER}@${HOST}:${DIR}\$${GIT_PS1}${white}\$${CLEAR} "
}

# Check for color support
force_color_prompt=yes
[[ -x /usr/bin/tput ]] && color_prompt=yes

if [ "$color_prompt" = yes ]; then
  term_colors
else
  PS1="\${prompt_job}\u@\h:\w\$ "
fi

# Clear color support
unset color_prompt force_color_prompt


# Get man pages colors
export LESS_TERMCAP_mb=$(printf '\e[1;31m')
export LESS_TERMCAP_md=$(printf '\e[1;31m')
export LESS_TERMCAP_me=$(printf '\e[0m')
export LESS_TERMCAP_me=$(printf '\e[0m')
export LESS_TERMCAP_so=$(printf '\e[01;33;40m')
export LESS_TERMCAP_se=$(printf '\e[0m')
export LESS_TERMCAP_us=$(printf '\e[1;32m')


# Set LS_COLORS envvar for use with `ls --color`
for dircolor_path in /usr/bin/dircolors /usr/local/opt/coreutils/libexec/gnubin/dircolors; do
  if [ -x $dircolor_path ]; then
    test -r ~/.dircolors && eval "$($dircolor_path -b ~/.dircolors)" || eval "$($dircolor_path -b)"
  fi
done


# limits recursive functions, see 'man bash'
[[ -z "$FUNCNEST" ]] && export FUNCNEST=100


# Alias definitions.
[[ -f "${HOME}/.bash_aliases" ]] && source "${HOME}/.bash_aliases"

# ASDF Setup
[[ -f "/opt/asdf-vm/asdf.sh" ]] && source /opt/asdf-vm/asdf.sh

# Java Setup for asdf
if [[ -f "${HOME}/.local/share/asdf/plugins/java/set-java-home.bash" ]]; then
  source "${HOME}/.local/share/asdf/plugins/java/set-java-home.bash"
  export _JAVA_OPTIONS="-Dawt.useSystemAAFontSettings=gasp -Djava.util.prefs.userRoot=${XDG_CONFIG_HOME}/java"
fi

# Completions
[[ -f "/usr/share/git/completion/git-prompt.sh" ]] && source /usr/share/git/completion/git-prompt.sh
[[ -f "/usr/share/git/completion/git-completion.bash" ]] && source /usr/share/git/completion/git-completion.bash
[[ -f "/usr/share/bash-completion/completions/git" ]] && source /usr/share/bash-completion/completions/git


# Uninstall all packages no longer required as dependencies (orphans)
remorphans() {
  local packages=()

  for package in $(pacman -Qdtq); do
    packages+=("$package")
  done

  echo "Found ${#packages[*]} orphans."
  if ! [[ ${#packages[*]} -eq 0 ]]; then
    sudo pacman -Rns "${packages[@]}"
  fi
}

lf() {
  \umask 077
  tmp="$(command mktemp)"
  command lf -last-dir-path="$tmp" "$@"
  if [ -f "$tmp" ]; then
    dir="$(command cat "$tmp")"
    command rm -f "$tmp"
  else
    \return 1
  fi
  if [ -d "$dir" ] && [ "$dir" != "$(pwd)" ]; then
    \cd "$dir" || \return 1
  fi
}
