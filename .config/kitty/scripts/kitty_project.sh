#!/usr/bin/env bash
#
# @file kitty_project.sh
# @brief Create and delete projects with persistent Kitty sessions.

set -eEuo pipefail

readonly PROJECTS_DIR="${HOME}/Projects"
readonly SESSIONS_DIR="${HOME}/.config/kitty/sessions/managed-projects"

# @description Keep an error visible before closing the script's tab.
# Captures $? on entry and exits with that status after reading Enter.
# @noargs
# @stdin Enter to dismiss the error.
# @stderr Operation failure message and prompt.
on_error() {
  local status=$?
  printf '\nOperation failed. Press Enter.' >&2
  read -r || true
  exit "${status}"
}

# @description Display an error and wait before closing the script's tab.
# @arg $1 string Error message.
# @stdin Enter to dismiss the error.
# @stderr Error message and prompt.
# @exitcode 1 Exits after displaying the error.
fail() {
  printf '%s\n' "$1" >&2
  read -r -p 'Press Enter.' || true
  exit 1
}

# @description Send a command to the current Kitty instance.
# Reads KITTY_LISTEN_ON when set and propagates Kitty's exit status.
# @arg $@ string[] Kitty remote-control command and arguments.
# @stdout Kitty command output.
# @stderr Kitty command errors.
# @exitcode 0 Kitty command succeeded.
rc() {
  if [[ -n "${KITTY_LISTEN_ON:-}" ]]; then
    kitty @ --to "${KITTY_LISTEN_ON}" "$@"
  else
    kitty @ "$@"
  fi
}

# @description Prompt for a project and create/reopen or permanently delete it.
# Creates/removes files under PROJECTS_DIR and SESSIONS_DIR.
# Command failures propagate their exit status through the error handler.
# @arg $1 string Action: new or delete.
# @stdin Project name; Enter to dismiss an error or cancel an empty name.
# @stdout Kitty command output.
# @stderr Interactive prompts and errors.
# @exitcode 0 Operation succeeded or input was canceled.
# @exitcode 1 Invalid action, project name, or project state.
main() {
  local name project session
  trap on_error ERR

  case "${1:-}" in
    new)
      read -r -p 'New project name: ' name || return 0
      ;;
    delete)
      read -r -p 'Project name to permanently delete: ' name || return 0
      ;;
    *)
      printf 'Usage: %s new|delete\n' "$0" >&2
      return 1
      ;;
  esac

  [[ -n "${name}" ]] || return 0
  if [[ ! "${name}" =~ ^[a-zA-Z0-9][a-zA-Z0-9_-]*$ ]]; then
    fail 'Use unaccented letters, numbers, hyphens or underscores.'
  fi

  project="${PROJECTS_DIR}/${name}"
  session="${SESSIONS_DIR}/project-${name}.kitty-session"
  if [[ -L "${project}" || -L "${session}" ]]; then
    fail 'The project or its session file is a symbolic link.'
  fi

  case "$1" in
    new)
      mkdir -p -- "${PROJECTS_DIR}" "${SESSIONS_DIR}"
      if [[ -f "${session}" && -d "${project}" ]]; then
        rc action goto_session "${session}"
        return 0
      fi

      # Do not adopt a preexisting folder or session.
      if [[ -e "${project}" || -e "${session}" ]]; then
        fail 'A folder or session with this name exists. Choose another name.'
      fi

      mkdir -- "${project}"
      cat >"${session}" <<EOF
layout split
cd ~/Projects/${name}
launch --title "${name}"
focus
focus_os_window
EOF

      rc action goto_session "${session}"
      ;;
    delete)
      if [[ ! -f "${session}" || ! -d "${project}" ]]; then
        fail 'Project not found among managed projects.'
      fi

      rm -r -- "${project}"
      rm -- "${session}"

      # Run last: this may also close the tab running this script.
      rc close-window --ignore-no-match --match "session:^project-${name}$"
      ;;
  esac
}

main "$@"
