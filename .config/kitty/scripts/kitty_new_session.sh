#!/usr/bin/env bash
#
# @file kitty_new_session.sh
# @brief Select a local directory or SSH host and open its Kitty session.
# @description
# Adapted from linkarzu/dotfiles-latest's kitty-zoxide-session.sh.

set -euo pipefail

readonly SESSION_DIR='/tmp/kitty-sessions'
readonly PROJECT_DIRS=("${HOME}/Desktop" "${HOME}/Projects" "${HOME}/.config")
SCRIPT_PATH="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
readonly SCRIPT_PATH="${SCRIPT_PATH}/${BASH_SOURCE[0]##*/}"

# Solarized Osaka Dark: https://github.com/craftzdog/solarized-osaka.nvim
readonly BASE_COLOR='\033[38;2;131;147;149m'
readonly GREEN_COLOR='\033[38;2;132;153;0m'
readonly RESET_COLOR='\033[0m'
readonly FZF_COLORS='bg:#001419,fg:#839395,hl:#29a298,hl+:#29a298,'\
'info:#576d74,header:#576d74,prompt:#849900,pointer:#b28500,'\
'marker:#268bd3,spinner:#d23681,fg+:#839395,bg+:#002c38,gutter:#001014'

# @description Require an executable on PATH.
# @arg $1 string Command name.
# @arg $2 string Installation hint.
# @stderr Missing-command error and installation hint.
# @exitcode 0 Command is available.
# @exitcode 1 Exits because the command is missing.
require_cmd() {
  local cmd="$1"
  local hint="$2"
  if ! command -v "${cmd}" >/dev/null 2>&1; then
    printf '%s is not installed. %s\n' "${cmd}" "${hint}" >&2
    exit 1
  fi
}

# @description Find Kitty's socket, preferring the launching instance.
# Reads KITTY_LISTEN_ON when set, then searches the fallback socket paths.
# @noargs
# @stdout Kitty socket path without the unix: prefix.
# @exitcode 0 A socket was found.
# @exitcode 1 No socket was found.
find_kitty_socket() {
  local sock="${KITTY_LISTEN_ON:-}"
  sock="${sock#unix:}"
  if [[ -S "${sock}" ]]; then
    printf '%s\n' "${sock}"
    return 0
  fi
  for sock in /tmp/kitty-*; do
    if [[ -S "${sock}" ]]; then
      printf '%s\n' "${sock}"
      return 0
    fi
  done
  return 1
}

# @description Resolve a path, falling back to the original value on failure.
# @arg $1 string Path to normalize.
# @stdout Resolved path, or the original path if realpath fails.
normalize_path() {
  realpath "$1" 2>/dev/null || printf '%s' "$1"
}

# @description Compute a suffix for directories with the same basename.
# Tries sha256sum, md5sum, then Python; propagates failure if all methods fail.
# @arg $1 string Directory path.
# @stdout SHA-256 hash, or MD5 when the md5sum fallback is used.
# @stderr Errors from the Python fallback, if it fails.
# @exitcode 0 Hash generated.
hash_path() {
  sha256sum <<<"$1" 2>/dev/null | awk '{print $1}' \
    || md5sum <<<"$1" 2>/dev/null | awk '{print $1}' \
    || python3 -c \
      'import hashlib, sys
print(hashlib.sha256(sys.argv[1].encode()).hexdigest())' \
      "$1"
}

# @description Check whether a named session is running.
# Query or parsing failures may return other non-zero statuses.
# @arg $1 string Kitty socket path.
# @arg $2 string Session name.
# @stderr JSON parsing errors, if any.
# @exitcode 0 Session found.
# @exitcode 1 Session not found.
session_exists() {
  local sock="$1"
  local name="$2"
  kitty @ --to "unix:${sock}" ls 2>/dev/null \
    | jq -e --arg name "${name}" \
      'any(.[]?.tabs[]?.windows[]?; .session_name == $name)' >/dev/null
}

# @description Find a running session with the requested working directory.
# @arg $1 string Kitty socket path.
# @arg $2 string Normalized directory path.
# @stdout First matching session name.
# @stderr JSON parsing errors, if any.
# @exitcode 0 Matching session found.
# @exitcode 1 No matching session found.
find_session_by_path() {
  local sock="$1"
  local target="$2"
  local name dir real

  while IFS=$'\t' read -r name dir; do
    [[ -z "${name}" || -z "${dir}" ]] && continue
    [[ -d "${dir}" ]] || continue
    real="$(normalize_path "${dir}")"
    if [[ "${real}" == "${target}" ]]; then
      printf '%s' "${name}"
      return 0
    fi
  done < <(
    kitty @ --to "unix:${sock}" ls 2>/dev/null \
      | jq -r '
        .[]?.tabs[]?.windows[]?
        | select(.session_name != null and .session_name != "")
        | [(.session_name | tostring), (.env.PWD // .cwd // "")]
        | @tsv
      '
  )
  return 1
}

# @description Collect SSH config files without revisiting included files.
# Starts at HOME/.ssh/config and follows Include patterns.
# @noargs
# @stdout One existing config path per line; empty if the root config is absent.
collect_ssh_config_files() {
  local root_config="${HOME}/.ssh/config"
  [[ -f "${root_config}" ]] || return 0

  local file line pattern match
  local processed='|'
  local queue=("${root_config}")
  local files=() patterns=()

  while (( ${#queue[@]} > 0 )); do
    file="${queue[0]}"
    queue=("${queue[@]:1}")
    [[ "${processed}" == *"|${file}|"* ]] && continue
    processed+="${file}|"
    [[ -f "${file}" ]] || continue
    files+=("${file}")

    while IFS= read -r line || [[ -n "${line}" ]]; do
      line="${line%%#*}"
      if [[ "${line}" =~ ^[[:space:]]*Include[[:space:]]+(.+) ]]; then
        read -r -a patterns <<<"${BASH_REMATCH[1]}"
        for pattern in "${patterns[@]}"; do
          pattern="${pattern/#\~/${HOME}}"
          # Expand Include globs explicitly without splitting matched paths.
          while IFS= read -r match; do
            [[ -f "${match}" ]] && queue+=("${match}")
          done < <(compgen -G "${pattern}" || true)
        done
      fi
    done <"${file}"
  done

  printf '%s\n' "${files[@]}"
}

# @description Print menu entries for SSH hosts, excluding wildcard patterns.
# Reads GREEN_COLOR and RESET_COLOR for labels.
# @noargs
# @stdout Tab-separated colored label and ssh:host, one host per line.
print_ssh_menu_lines() {
  local config_files=()
  local host file
  while IFS= read -r file; do
    config_files+=("${file}")
  done < <(collect_ssh_config_files)
  (( ${#config_files[@]} > 0 )) || return 0

  while IFS= read -r host; do
    [[ -n "${host}" ]] || continue
    printf '%b%s%b\t%s\n' \
      "${GREEN_COLOR}" "ssh-${host}" "${RESET_COLOR}" "ssh:${host}"
  done < <(
    awk '{
      sub(/[ \t]*#.*/, "")
      if (tolower($1) == "host") {
        for (i = 2; i <= NF; i++) {
          h = $i
          if (h ~ /^[!]/) continue
          if (h ~ /[\\*?]/) continue
          print h
        }
      }
    }' "${config_files[@]}" | sort -u
  )
}

# @description Print local directories followed by SSH hosts for the picker.
# Reads PROJECT_DIRS, BASE_COLOR, RESET_COLOR and HOME.
# @noargs
# @stdout Tab-separated colored labels and destinations, one entry per line.
print_menu_lines() {
  local dir
  for dir in "${PROJECT_DIRS[@]}"; do
    [[ -d "${dir}" ]] || continue
    find "${dir}" -mindepth 1 -maxdepth 1 -type d \
      \( -name '.git' -o -name '.github' -o -name 'node_modules' \
        -o -name '.cache' -o -name '__pycache__' \
        -o -name '.venv' -o -name 'venv' \) -prune \
      -o -type d -printf '%p\t%f\n' 2>/dev/null
  done \
    | sort -u -t$'\t' -k1,1 \
    | awk -F'\t' -v color="${BASE_COLOR}" -v reset="${RESET_COLOR}" \
      -v home="${HOME}" '{
        path = $1
        if (index(path, home "/") == 1) {
          path = "~" substr(path, length(home) + 1)
        }
        printf "%s%s%s\t%s\n", color, $2, reset, path
      }'
  print_ssh_menu_lines
}

# @description Focus an existing directory session or create and launch one.
# Writes new session files under SESSION_DIR; command failures propagate.
# @arg $1 string Kitty socket path.
# @arg $2 string Selected directory.
# @stdout Kitty command output.
# @stderr Missing-directory message or command errors.
# @exitcode 0 Session focused or launched.
# @exitcode 1 Directory missing, or a command failed with status 1.
focus_or_launch_dir() {
  local sock="$1"
  local selected_path="$2"
  local selected_real base safe_base hash
  local session_name existing_session session_file

  if [[ ! -d "${selected_path}" ]]; then
    printf 'Directory not found: %s\n' "${selected_path}" >&2
    return 1
  fi
  selected_real="$(normalize_path "${selected_path}")"
  existing_session="$(find_session_by_path "${sock}" "${selected_real}" \
    || true)"
  if [[ -n "${existing_session}" ]]; then
    kitty @ --to "unix:${sock}" action goto_session "${existing_session}"
    return 0
  fi

  base="${selected_real##*/}"
  safe_base="$(printf '%s' "${base}" | tr -cs 'A-Za-z0-9._-' '_')"
  hash="$(hash_path "${selected_real}")"
  hash="${hash:0:4}"
  session_name="z-${safe_base}"
  if session_exists "${sock}" "${session_name}"; then
    session_name="${session_name}-${hash}"
  fi

  mkdir -p "${SESSION_DIR}"
  session_file="${SESSION_DIR}/${session_name}.kitty-session"
  cat >"${session_file}" <<EOF
layout tall
cd ${selected_real}
launch --title "${base}"
focus
focus_os_window
EOF

  kitty @ --to "unix:${sock}" action goto_session "${session_file}"
}

# @description Create and launch a session using Kitty's SSH kitten.
# Writes the session file under SESSION_DIR; command failures propagate.
# @arg $1 string Kitty socket path.
# @arg $2 string SSH host alias.
# @stdout Kitty command output.
# @stderr Command errors.
# @exitcode 0 Session launched.
focus_or_launch_ssh() {
  local sock="$1"
  local host="$2"
  local safe_host session_file kitten_bin

  # Kitty executes commands directly, so resolve the kitten executable here.
  kitten_bin="$(command -v kitten || command -v kitty || printf 'kitten')"
  safe_host="$(printf '%s' "${host}" | tr -cs 'A-Za-z0-9._-' '_')"
  mkdir -p "${SESSION_DIR}"
  session_file="${SESSION_DIR}/ssh-${safe_host}.kitty-session"
  cat >"${session_file}" <<EOF
layout splits
launch --title "ssh-${host}" ${kitten_bin} ssh ${host}
focus
focus_os_window
EOF

  kitty @ --to "unix:${sock}" action goto_session "${session_file}"
}

# @description Run the directory/SSH picker or print its reload entries.
# Reads SCRIPT_PATH, FZF_COLORS and HOME; session launch failures propagate.
# @option --reload Print menu rows and exit instead of opening the picker.
# @stdout Menu rows in reload mode; otherwise screen-clear and Kitty output.
# @stderr Dependency, socket, directory or command errors.
# @exitcode 0 Session opened, entries printed or picker canceled.
# @exitcode 1 Missing dependency, socket or directory.
main() {
  local sock fzf_out key sel selected_path reload_command
  local fzf_rc=0
  require_cmd fzf 'Please install fzf'
  require_cmd jq 'Please install jq'

  if [[ "${1:-}" == '--reload' ]]; then
    print_menu_lines
    return 0
  fi
  if ! sock="$(find_kitty_socket)"; then
    printf 'Kitty socket not found. Is remote control enabled?\n' >&2
    return 1
  fi

  printf -v reload_command '%q --reload' "${SCRIPT_PATH}"
  printf '\033[2J\033[H'
  fzf_out="$(
    fzf --exact --ansi --height=20 --reverse \
      --delimiter='\t' --with-nth=1,2 --nth=1 --tabstop=22 \
      --header='Type to filter, enter open, esc quit' \
      --prompt='Create New Kitty Session > ' \
      --no-multi --no-sort --tiebreak=index --expect=enter,esc \
      --bind='enter:accept' --bind='esc:abort' \
      --bind "start:reload:${reload_command}" \
      --bind "change:reload:${reload_command}" \
      --color="${FZF_COLORS}"
  )" || fzf_rc=$?

  if (( fzf_rc != 0 )) && [[ -z "${fzf_out}" ]]; then
    return 0
  fi
  {
    IFS= read -r key || true
    IFS= read -r sel || true
  } <<<"${fzf_out}"
  [[ "${key}" == 'esc' ]] && return 0
  [[ "${sel}" == *$'\t'* ]] || return 0
  selected_path="${sel#*$'\t'}"
  selected_path="${selected_path/#\~/${HOME}}"
  [[ -n "${selected_path}" ]] || return 0

  if [[ "${selected_path}" == ssh:* ]]; then
    focus_or_launch_ssh "${sock}" "${selected_path#ssh:}"
  else
    focus_or_launch_dir "${sock}" "${selected_path}"
  fi
}

main "$@"
