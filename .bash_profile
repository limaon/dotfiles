# ~/.bash_profile

# If running Bash
if [ -n "$BASH_VERSION" ]; then
  # Include .bashrc if it exists
  if [ -f "$HOME/.bashrc" ]; then
    source "$HOME/.bashrc"
  fi
fi

# Load environment variables
# https://wiki.archlinux.org/title/Environment_variables#Per_Wayland_session
export $(run-parts /usr/lib/systemd/user-environment-generators | sed '/:$/d; /^$/d' | xargs)


# Start graphical server on tty1 if not already running.
# https://wiki.archlinux.org/index.php/Xinit#Autostart_X_at_login
if [[ -z "${DISPLAY}" ]] && [[ "${XDG_VTNR}" -eq 1 ]]; then
  startx "$XINITRC"
fi
