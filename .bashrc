#
# My bashrc setup
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return
[[ "$(whoami)" = "root" ]] && return

# Defautl programs
export WM="i3"
export OPENER="${OPENER:-/usr/bin/xdg-open}"
export EDITOR="${EDITOR:-/usr/bin/nvim}"
export READER="${READER:-/usr/bin/zathura}"
export AUDIO_PLAYER="${AUDIO_PLAYER:-/usr/bin/mpv}"
export VIDEO_PLAYER="${VIDEO_PLAYER:-/usr/bin/mpv}"
export TERMINAL="${TERMINAL:-/usr/bin/kitty}"
export TERMINAL_PROG=$TERMINAL

# XDG Paths
export \
  XDG_DATA_HOME="${XDG_DATA_HOME:-"${HOME}/.local/share"}" \
  XDG_CACHE_HOME="${XDG_CACHE_HOME:-"${HOME}/.cache"}" \
  XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-"${HOME}/.config"}" \
  XDG_STATE_HOME="${XDG_STATE_HOME:-"${HOME}/.local/state"}" \

if [ -f "$XDG_CONFIG_HOME/user-dirs.dirs" ]; then
  source "$XDG_CONFIG_HOME/user-dirs.dirs"
  export XDG_DESKTOP_DIR XDG_DOWNLOAD_DIR \
    XDG_DOCUMENTS_DIR XDG_MUSIC_DIR XDG_PICTURES_DIR \
    XDG_VIDEOS_DIR XDG_TEMPLATES_DIR XDG_PUBLICSHARE_DIR
fi

# Xorg Paths
export \
  USERXSESSION="${XDG_CACHE_HOME:-$HOME/.cache}/X11/xsession" \
  USERXSESSIONRC="${XDG_CACHE_HOME:-$HOME/.cache}/X11/xsessionrc" \
  ERRFILE="$XDG_CACHE_HOME/X11/xsession-errors" \
  XINITRC="${XDG_CONFIG_HOME}/x11/xinitrc"  \
  XSERVERRC="${XDG_CONFIG_HOME}/x11/xserverrc" \
  XMODMAP="${XDG_CONFIG_HOME}/x11/xmodmap" \
  XCOMPOSEFILE="${XDG_CONFIG_HOME}/x11/xcompose" \
  XCOMPOSECACHE="${XDG_CACHE_HOME}/x11/xcomposecache/" \
  XENVIRONMENT="${XDG_CONFIG_HOME}/x11/Xresources" \

# ASDF Paths
export \
  ASDF_CONFIG_FILE="${XDG_CONFIG_HOME}/asdf/asdfrc" \
  ASDF_DATA_DIR="${XDG_DATA_HOME}/asdf" \
  ASDF_PYTHON_DEFAULT_PACKAGES_FILE="${XDG_CONFIG_HOME}/pip/default-python-packages" \
  ASDF_NPM_DEFAULT_PACKAGES_FILE="${XDG_CONFIG_HOME}/npm/default-npm-packages" \
  ASDF_GEM_DEFAULT_PACKAGES_FILE="${XDG_CONFIG_HOME}/gem/default-gems" \

# Directories no-XDG: {{{
export \
  ATOM_HOME="${XDG_DATA_HOME}/atom" \
  AZURE_CONFIG_DIR="${XDG_DATA_HOME}/azure" \
  CARGO_HOME="${XDG_DATA_HOME}/cargo" \
  CONDARC="${XDG_CONFIG_HOME}/conda/condarc" \
  LYNX_CFG="${XDG_CONFIG_HOME}/lynx/lynxrc" \
  LYNX_LSS="${XDG_CONFIG_HOME}/lynx/lynx.lss" \
  DOCKER_CONFIG="${XDG_CONFIG_HOME}/docker" \
  DOT_SAGE="${XDG_CONFIG_HOME}/sage" \
  ELECTRUMDIR="${XDG_DATA_HOME}/electrum" \
  EM_CONFIG="${XDG_CONFIG_HOME}/emscripten/config" \
  EM_CACHE="${XDG_CACHE_HOME}/emscripten/cache" \
  EM_PORTS="${XDG_DATA_HOME}/emscripten/cache" \
  GEM_HOME="${XDG_DATA_HOME}/gem" \
  GEM_SPEC_CACHE="${XDG_CACHE_HOME}/gem" \
  GRADLE_USER_HOME="${XDG_DATA_HOME}/gradle" \
  GRIPHOME="${XDG_CONFIG_HOME}/grip" \
  GTK_RC_FILES="${XDG_CONFIG_HOME}/gtk-1.0/gtkrc" \
  GTK2_RC_FILES="${XDG_CONFIG_HOME}/gtk-2.0/gtkrc" \
  XCURSOR_PATH="/usr/share/icons:$XDG_DATA_HOME/icons" \
  ICEAUTHORITY="${XDG_CACHE_HOME}/ICEauthority" \
  IMAPFILTER_HOME="${XDG_CONFIG_HOME}/imapfilter" \
  IPYTHONDIR="${XDG_CONFIG_HOME}/jupyter" \
  IRBRC="${XDG_CONFIG_HOME}/irb/irbrc" \
  _JAVA_OPTIONS=-Djava.util.prefs.userRoot="${XDG_CONFIG_HOME}/java" \
  JUPYTER_CONFIG_DIR="${XDG_CONFIG_HOME}/jupyter" \
  KDEHOME="${XDG_CONFIG_HOME}/kde4" \
  KODI_DATA="${XDG_DATA_HOME}/kodi" \
  LEIN_HOME="${XDG_DATA_HOME}/lein" \
  MACHINE_STORAGE_PATH="${XDG_DATA_HOME}/docker-machine" \
  MATHEMATICA_USERBASE="${XDG_CONFIG_HOME}/mathematica" \
  MAXIMA_USERDIR="${XDG_CONFIG_HOME}/maxima" \
  MEDNAFEN_HOME="${XDG_CONFIG_HOME}/mednafen" \
  MOST_INITFILE="${XDG_CONFIG_HOME}/mostrc" \
  MPLAYER_HOME="${XDG_CONFIG_HOME}/mplayer" \
  NODE_REPL_HISTORY="${XDG_DATA_HOME}/node_repl_history" \
  NOTMUCH_CONFIG="${XDG_CONFIG_HOME}/notmuch/notmuchrc" \
  INPUTRC="${XDG_CONFIG_HOME}/readline/inputrc"
  NMBGIT="${XDG_DATA_HOME}/notmuch/nmbug" \
  NPM_CONFIG_USERCONFIG="${XDG_CONFIG_HOME}/npm/npmrc" \
  NUGET_PACKAGES="${XDG_CACHE_HOME}/NuGetPackages" \
  PARALLEL_HOME="${XDG_CONFIG_HOME}/parallel" \
  PSQLRC="${XDG_CONFIG_HOME}/pg/psqlrc" \
  PSQL_HISTORY="${XDG_CACHE_HOME}/pg/psql_history" \
  PGPASSFILE="${XDG_CONFIG_HOME}/pg/pgpass" \
  PGSERVICEFILE="${XDG_CONFIG_HOME}/pg/pg_service.conf" \
  PYTHON_EGG_CACHE="${XDG_CACHE_HOME}/python-eggs" \
  PYLINTHOME="${XDG_CACHE_HOME}/pylint" \
  PLTUSERHOME="${XDG_DATA_HOME}/racket" \
  RLWRAP_HOME="${XDG_DATA_HOME}/rlwrap" \
  RUSTUP_HOME="${XDG_DATA_HOME}/rustup" \
  RXVT_SOCKET="${XDG_RUNTIME_DIR}/urxvtd" \
  SCREENRC="${XDG_CONFIG_HOME}/screen/screenrc" \
  SPACEMACSDIR="${XDG_CONFIG_HOME}/spacemacs" \
  STACK_ROOT="${XDG_DATA_HOME}/stack" \
  TASKDATA="${XDG_DATA_HOME}/task" \
  TASKRC="${XDG_CONFIG_HOME}/task/taskrc" \
  TERMINFO="${XDG_DATA_HOME}/terminfo" \
  TERMINFO_DIRS="${XDG_DATA_HOME}/terminfo":/usr/share/terminfo \
  TEXMFHOME="${XDG_DATA_HOME}/texmf" \
  TEXMFVAR="${XDG_CACHE_HOME}/texlive/texmf-var" \
  TEXMFCONFIG="${XDG_CONFIG_HOME}/texlive/texmf-config" \
  UNCRUSTIFY_CONFIG="${XDG_CONFIG_HOME}/uncrustify/uncrustify.cfg" \
  UNISON="${XDG_DATA_HOME}/unison" \
  VAGRANT_HOME="${XDG_DATA_HOME}/vagrant" \
  VAGRANT_ALIAS_FILE="${XDG_DATA_HOME}/vagrant/aliases" \
  VSCODE_PORTABLE="${XDG_DATA_HOME}/vscode" \
  WEECHAT_HOME="${XDG_CONFIG_HOME}/weechat" \
  WORKON_HOME="${XDG_DATA_HOME}/virtualenvs" \
  WGETRC="${XDG_CONFIG_HOME}/wgetrc" \
  WINEPREFIX="${XDG_DATA_HOME}/wineprefixes/default" \
  _Z_DATA="${XDG_DATA_HOME}/z" \
  MYSQL_HISTFILE="${XDG_DATA_HOME}/mysql_history" \
  ZDOTDIR="${XDG_CONFIG_HOME}/zsh" \
  PASSWORD_STORE_DIR="${XDG_DATA_HOME}/password-store" \
  TMUX_TMPDIR="${XDG_RUNTIME_DIR}" \
  ANDROID_SDK_HOME="${XDG_CONFIG_HOME}/android" \
  GOPATH="${XDG_DATA_HOME}/go" \
  GOMODCACHE="${XDG_CACHE_HOME}/go/mod" \
  ANSIBLE_CONFIG="${XDG_CONFIG_HOME}/ansible/ansible.cfg" \
  HISTFILE="${XDG_STATE_HOME}"/bash/history \
  MBSYNCRC="${XDG_CONFIG_HOME}/mbsync/config" \
  PYTHONSTARTUP="${XDG_CONFIG_HOME}/python/pythonrc" \
  PYTHONHISTORY="${XDG_CACHE_HOME}/python/history" \
  SQLITE_HISTORY="${XDG_DATA_HOME}/sqlite_history" \
  SSH_AUTH_SOCK="${XDG_RUNTIME_DIR}/ssh-agent.socket" \


# Other program settings:
export _JAVA_AWT_WM_NONREPARENTING=1
export TERM="xterm-256color"
export LANG="en_US.UTF-8"
export LESS='-F -i -J -M -R -W -x4 -X -z-4'
export LESS_TERMCAP_mb=$(printf '\e[1;31m')
export LESS_TERMCAP_md=$(printf '\e[1;31m')
export LESS_TERMCAP_me=$(printf '\e[0m')
export LESS_TERMCAP_me=$(printf '\e[0m')
export LESS_TERMCAP_so=$(printf '\e[01;33;40m')
export LESS_TERMCAP_se=$(printf '\e[0m')
export LESS_TERMCAP_us=$(printf '\e[1;32m')
export DICS="/usr/share/stardict/dic/"
export MOZ_USE_XINPUT2="1"
export HISTCONTROL=ignoredups:ignorespace:erasedups
export FZF_DEFAULT_OPTS="--layout=reverse --height 40%"
export LESSOPEN="| /usr/bin/highlight -O ansi %s 2>/dev/null"
export TDESKTOP_USE_GTK_FILE_DIALOG=1

# Fix Java programs
# https://wiki.archlinux.org/index.php/Java_Runtime_Environment_fonts
export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=gasp'

# Fix QT themes on GTK Desktops
# https://tatsumoto.neocities.org/blog/setting-up-anki.html#gtk-theme
export QT_QPA_PLATFORMTHEME=qt6ct

# Fix QT plugin path for pyqt packages installed with pip.
#export QT_PLUGIN_PATH=/usr/lib/qt/plugins

# All vars for fcitx5: {{{
export \
  GTK_IM_MODULE='fcitx' \
  QT_IM_MODULE='fcitx' \
  SDL_IM_MODULE='fcitx' \
  XMODIFIERS='@im=fcitx' \

# Colors
export SYSTEMD_COLORS=true
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
export LS_COLORS="\
ln=01;36:\
or=31;01:\
tw=38;5;47:\
ow=38;5;47:\
st=01;34:\
di=01;34:\
pi=33:\
so=01;35:\
bd=33;01:\
cd=33;01:\
su=01;32:\
sg=01;32:\
ex=01;32:\
fi=00:\
*.tar=01;31:\
*.tgz=01;31:\
*.arc=01;31:\
*.arj=01;31:\
*.taz=01;31:\
*.lha=01;31:\
*.lz4=01;31:\
*.lzh=01;31:\
*.lzma=01;31:\
*.tlz=01;31:\
*.txz=01;31:\
*.tzo=01;31:\
*.t7z=01;31:\
*.zip=01;31:\
*.z=01;31:\
*.dz=01;31:\
*.gz=01;31:\
*.lrz=01;31:\
*.lz=01;31:\
*.lzo=01;31:\
*.xz=01;31:\
*.zst=01;31:\
*.tzst=01;31:\
*.bz2=01;31:\
*.bz=01;31:\
*.tbz=01;31:\
*.tbz2=01;31:\
*.tz=01;31:\
*.deb=01;31:\
*.rpm=01;31:\
*.jar=01;31:\
*.war=01;31:\
*.ear=01;31:\
*.sar=01;31:\
*.rar=01;31:\
*.alz=01;31:\
*.ace=01;31:\
*.zoo=01;31:\
*.cpio=01;31:\
*.7z=01;31:\
*.rz=01;31:\
*.cab=01;31:\
*.wim=01;31:\
*.swm=01;31:\
*.dwm=01;31:\
*.esd=01;31:\
*.jpg=38;5;202:\
*.JPG=38;5;202:\
*.jpeg=38;5;202:\
*.mjpg=38;5;202:\
*.mjpeg=38;5;202:\
*.webp=38;5;202:\
*.gif=38;5;202:\
*.bmp=38;5;202:\
*.pbm=38;5;202:\
*.pgm=38;5;202:\
*.ppm=38;5;202:\
*.tga=38;5;202:\
*.xbm=38;5;202:\
*.xpm=38;5;202:\
*.tif=38;5;202:\
*.tiff=38;5;202:\
*.png=38;5;202:\
*.svg=38;5;202:\
*.svgz=38;5;202:\
*.mng=38;5;202:\
*.odg=38;5;202:\
*.pcx=38;2;218;8;255:\
*.mov=38;2;218;8;255:\
*.mpg=38;2;218;8;255:\
*.mpeg=38;2;218;8;255:\
*.m2v=38;2;218;8;255:\
*.mkv=38;2;218;8;255:\
*.webm=38;2;218;8;255:\
*.ogm=38;2;218;8;255:\
*.mp4=38;2;218;8;255:\
*.m4v=38;2;218;8;255:\
*.mp4v=38;2;218;8;255:\
*.vob=38;2;218;8;255:\
*.qt=38;2;218;8;255:\
*.nuv=38;2;218;8;255:\
*.wmv=38;2;218;8;255:\
*.asf=38;2;218;8;255:\
*.rm=38;2;218;8;255:\
*.rmvb=38;2;218;8;255:\
*.flc=38;2;218;8;255:\
*.avi=38;2;218;8;255:\
*.fli=38;2;218;8;255:\
*.flv=38;2;218;8;255:\
*.gl=38;2;218;8;255:\
*.dl=38;2;218;8;255:\
*.xcf=38;2;218;8;255:\
*.xwd=38;2;218;8;255:\
*.yuv=38;2;218;8;255:\
*.cgm=38;2;218;8;255:\
*.emf=38;2;218;8;255:\
*.ogv=38;2;218;8;255:\
*.ogx=38;2;218;8;255:\
*.aac=00;36:\
*.au=00;36:\
*.flac=00;36:\
*.m4a=00;36:\
*.mid=00;36:\
*.midi=00;36:\
*.mka=00;36:\
*.mp3=00;36:\
*.mpc=00;36:\
*.ogg=00;36:\
*.ra=00;36:\
*.wav=00;36:\
*.oga=00;36:\
*.opus=00;36:\
*.spx=00;36:\
*.xspf=00;36:\
*.pdf=38;2;249;46;73:\
*.PDF=38;2;249;46;73:\
*.ps=38;2;249;46;73:\
*.epub=38;2;249;46;73:\
*.mobi=38;2;249;46;73:\
*.ods=92:\
*.xls=92:\
*.XLS=92:\
*.xlsx=92:\
*.XLSX=92:\
*.odt=94:\
*.doc=94:\
*.DOC=94:\
*.docx=94:\
*.DOCX=94:\
*.odp=38;2;249;62;0:\
*.ppt=38;2;249;62;0:\
*.PPT=38;2;249;62;0:\
*.pptx=38;2;249;62;0:\
*.PPTX=38;2;249;62;0:\
*.iso=38;5;221:\
*.img=38;5;221:\
*.py=38;5;220:\
*.lua=38;5;39:\
*.js=38;5;226:\
*.htm=38;5;202:\
*.html=38;5;202:\
*.shtml=38;5;202:\
*.xhtml=38;5;202:\
*.css=38;5;39:\
*.go=38;5;39:\
*.php=38;5;75:\
*.tex=38;5;36:\
*.c=38;2;121;168;244:\
*.cpp=38;2;141;116;244:\
*.cs=38;2;203;121;244:\
*.r=38;5;39:\
*.R=38;5;39:\
*.rs=38;2;225;105;0:\
*.pl=38;2;0;115;255:\
*.raku=38;2;225;0;221:\
*.m=38;2;225;43;7:\
*.java=38;2;225;136;0:\
*.scala=38;5;196:\
*.vim=32:\
*.rb=38;5;39:\
*.sql=38;5;249:\
*.sqlite=38;5;249:\
*.db=38;5;249:\
*.odb=38;5;249:\
*.apk=38;5;82:\
*.apk=38;5;82:\
*.jl=38;5;147:\
*.hs=38;5;133:\
*.lhs=38;5;133:\
*.blend=38;5;208:\
"

# Start graphical server on tty1 if not already running.
# https://wiki.archlinux.org/index.php/Xinit#Autostart_X_at_login
if [[ -z "${DISPLAY}" ]] && [[ "${XDG_VTNR}" -eq 1 ]]; then
  exec startx "$XINITRC"
fi

# limits recursive functions, see 'man bash'
[[ -z "$FUNCNEST" ]] && export FUNCNEST=100

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
  xterm-color|*-256color) color_prompt=yes;;
esac

# Shell options
shopt -s \
  nocaseglob \
  checkwinsize \
  autocd \
  cdspell \
  globstar \
  histappend
complete -cf doas
set -o noclobber

# Define colors
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
  # Define git branch variable
  GIT_PS1="(__git_ps1 ' git:(${yellow}%s${NC}${MAGENTA})')"
  PS1="${green}\u@\h${white}:${blue}\W${NC}${MAGENTA}\$$GIT_PS1${white} \$${CLEAR} "
else
  PS1='┌──[\u@\h]─[\w]\n└──╼\$ '
fi
unset color_prompt force_color_prompt


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

lfcd () {
  tmp="$(mktemp)"
  command lf -last-dir-path="$tmp" "$@"
  if [ -f "$tmp" ]; then
    dir="$(cat "$tmp")"
    rm -f "$tmp"
    if [ -d "$dir" ]; then
      if [ "$dir" != "$(pwd)" ]; then
        cd "$dir"
      fi
    fi
  fi
}

# Bindings to make bash more interactive
bind 'set show-all-if-ambiguous on'
bind 'TAB:menu-complete'

bind '"\e[A":history-search-backward'
bind '"\e[B":history-search-forward'
bind '"\C-p":history-search-backward'
bind '"\C-n":history-search-forward'

# ASDF setup
[ -f "/opt/asdf-vm/asdf.sh" ] && . /opt/asdf-vm/asdf.sh

if [[ -f "${HOME}/.local/share/asdf/plugins/java/set-java-home.bash" ]]; then
  . "${HOME}/.local/share/asdf/plugins/java/set-java-home.bash"
fi

[ -f "/usr/share/git/completion/git-prompt.sh" ] && . /usr/share/git/completion/git-prompt.sh
[ -f "/usr/share/bash-completion/completions/git" ] && . /usr/share/bash-completion/completions/git
[ -f "/usr/share/git/completion/git-completion.bash" ] && . /usr/share/git/completion/git-completion.bash
[ -f "${HOME}/.bash_aliases" ] && . ~/.bash_aliases
