###
### System configuration
###
########################


##
## /etc/fstab
##
cfg-fstab() {
    if [ "$(id -u)" == "0" ]; then
        ${EDITOR:-nvim} /etc/fstab
    else
        sudoedit /etc/fstab;
    fi
}


##
## /etc/hosts
##
cfg-hosts() {
    if [ "$(id -u)" == "0" ]; then
        ${EDITOR:-nvim} /etc/hosts
    else
        sudoedit /etc/hosts
    fi
}


cfg-xdg-dirs() {
    if [ -f ${XDG_CONFIG_HOME}/user-dirs.dirs ]; then
        ${EDITOR:-nvim} ${XDG_CONFIG_HOME}/user-dirs.dirs
    fi
}



###
### Bash configuration
###
########################


##
## ~/.bashrc
##
if [ -f "${HOME}/.bashrc" ]; then
    cfg-bashrc() { ${EDITOR:-nvim} ~/.bashrc; };
fi


##
## ~/.bash_profile
##
if [ -f "${HOME}/.bash_profile" ]; then
    cfg-bash-profile() { ${EDITOR:-nvim} ~/.bash_profile; };
fi


##
## ~/.config/bash/bashrc.d/*.bash
##
if [ -d "${XDG_CONFIG_HOME}/bash/config/bashrc.d/" ]; then
    for _f in ${XDG_CONFIG_HOME}/bash/config/bashrc.d/*.bash ; do
        _suffix="$( basename "${_f}" )"
        _suffix="${_suffix%.bash}"
        eval "cfg-bash-${_suffix}() { ${EDITOR:-vim} \"${_f}\"; }"
        unset _f
        unset _suffix
    done
fi


##
## ~/.config/bash/bash_profile/*.bash
##
if [ -d "${XDG_CONFIG_HOME}/bash/config/bash_profile.d/" ]; then
    for _f in ${XDG_CONFIG_HOME}/bash/config/bash_profile.d/*.bash ; do
        _suffix="$( basename "${_f}" )"
        _suffix="${_suffix%.bash}"
        eval "cfg-bash-${_suffix}() { ${EDITOR:-vim} \"${_f}\"; }"
        unset _f
        unset _suffix
    done
fi


###
### lf configuration
###
########################
if [ -f "${HOME}/.config/lf/lfrc" ]; then
    cfg-lf() { ${EDITOR:-nvim} ~/.config/lf/lfrc; }
fi
if [ -f "${HOME}/.config/lf/exec_previewer" ]; then
    cfg-lf-previewer() { ${EDITOR:-nvim} ~/.config/lf/exec_previewer; }
fi


###
### Misc configuration
###
########################


##
## Single dotfiles
##
if [ -f "${HOME}/.config/X11/xprofile" ]; then
    cfg-xprofile() { ${EDITOR:-nvim} ~/.config/X11/xprofile; }
fi
if [ -f "${HOME}/.config/X11/Xmodmap" ]; then
    cfg-xmodmap() { ${EDITOR:-nvim} ~/.config/X11/Xmodmap; }
fi
if [ -f "${HOME}/.config/X11/Xresources" ]; then
    cfg-xresources() { ${EDITOR:-nvim} ~/.config/X11/Xresources; }
fi
if [ -f "${HOME}/.config/nvim/init.lua" ]; then
    cfg-nvim() { ${EDITOR:-nvim} ~/.config/nvim/init.lua; }
fi
if [ -f "${HOME}/.config/git/config" ]; then
    cfg-git() { ${EDITOR:-nvim} ~/.config/git/config; }
fi
if [ -f "${HOME}/.config/tmux/tmux.conf" ]; then
    cfg-tmux() { ${EDITOR:-nvim} ~/.config/tmux/tmux.conf; }
fi
if [ -f "${HOME}/.config/i3/config" ]; then
    cfg-i3wm() { ${EDITOR:-nvim} ~/.config/i3/config; }
fi
