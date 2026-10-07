#!/usr/bin/env bash
#
# @file kitty_list_sessions.sh
# @brief List active Kitty sessions and switch to or close a session.
# @description
# Adapted from linkarzu/dotfiles-latest's kitty-list-sessions.sh.

set -euo pipefail

readonly DEFAULT_MODE='insert'
# Solarized Osaka Dark: https://github.com/craftzdog/solarized-osaka.nvim
readonly BASE_COLOR='\033[38;2;131;147;149m'
readonly CURRENT_COLOR='\033[38;2;41;162;152m'
readonly RESET_COLOR='\033[0m'
readonly FZF_COLORS='bg:#001419,fg:#839395,hl:#29a298,hl+:#29a298,'\
'info:#576d74,header:#576d74,prompt:#849900,pointer:#b28500,'\
'marker:#268bd3,spinner:#d23681,fg+:#839395,bg+:#002c38,gutter:#001014'

# @description Set a block cursor by writing an escape sequence to /dev/tty.
# @noargs
set_cursor_block() { printf '\e[2 q' >/dev/tty; }

# @description Set a bar cursor by writing an escape sequence to /dev/tty.
# @noargs
set_cursor_bar() { printf '\e[6 q' >/dev/tty; }

# @description Find Kitty's socket, preferring the launching instance.
# Reads KITTY_LISTEN_ON when set, then searches the fallback socket paths.
# @noargs
# @stdout Kitty socket path without the unix: prefix.
# @exitcode 0 A socket was found.
# @exitcode 1 No socket was found.
find_kitty_socket() {
  local sock
  if [[ -n "${KITTY_LISTEN_ON:-}" ]]; then
    sock="${KITTY_LISTEN_ON#unix:}"
    if [[ -S "${sock}" ]]; then
      printf '%s\n' "${sock}"
      return 0
    fi
  fi
  for sock in /tmp/kitty-*; do
    if [[ -S "${sock}" ]]; then
      printf '%s\n' "${sock}"
      return 0
    fi
  done
  return 1
}

# @description Format one menu row per session, ordered by most recent focus.
# Reads BASE_COLOR, CURRENT_COLOR, RESET_COLOR and HOME (via jq).
# @arg $1 string Kitty socket path.
# @stdout Tab-separated index, session name and colored label.
# @stderr Formatting or JSON parsing errors.
# @exitcode 0 Menu rows generated.
# @exitcode 1 No sessions found or session query failed.
build_menu_lines() {
  local sock="$1"
  local sessions_tsv
  sessions_tsv="$(
    kitty @ --to "unix:${sock}" ls 2>/dev/null \
      | jq -r '
        [
          .[] as $os
          | $os.tabs[] as $tab
          | $tab.windows[]?
          | select(.session_name != null and .session_name != "")
          | {
              session_name: .session_name,
              pwd: (.env.PWD // .cwd),
              os_focused: ($os.is_focused // false),
              tab_focused: ($tab.is_focused // false),
              last_focused_at: (.last_focused_at // 0)
            }
        ]
        | sort_by(.session_name)
        | group_by(.session_name)
        | map({
            session_last_focused_at: (map(.last_focused_at) | max),
            pick: (
              if (map(.os_focused and .tab_focused) | any) then
                (map(select(.os_focused and .tab_focused)) | .[0])
              else
                .[0]
              end
            )
          })
        | map(.pick + {session_last_focused_at: .session_last_focused_at})
        | sort_by(-.session_last_focused_at, .session_name)
        | .[]
        | [
            (.session_name | tostring),
            (.os_focused | tostring),
            (.tab_focused | tostring),
            (.pwd | ltrimstr(env.HOME) | if . != "" then "~" + . else . end)
          ]
        | @tsv
      '
  )" || return 1
  [[ -n "${sessions_tsv}" ]] || return 1

  printf '%s\n' "${sessions_tsv}" \
    | awk -F'\t' -v base_color="${BASE_COLOR}" \
      -v current_color="${CURRENT_COLOR}" -v reset_color="${RESET_COLOR}" '{
        session_name=$1
        os_focused=$2
        tab_focused=$3
        path=$4
        if (os_focused == "true" && tab_focused == "true") {
          name_color=current_color
        } else {
          name_color=base_color
        }
        printf "%d\t%s\t%s%s%s  %s\n", NR, session_name, name_color,
          session_name, reset_color, path
      }'
}

# @description Run the session picker in insert or normal mode.
# Reads FZF_COLORS, renders fzf on the terminal and propagates its exit status.
# @arg $1 string Picker mode: insert or normal.
# @arg $2 string Menu rows separated by newlines.
# @arg $3 integer Optional initial row in normal mode.
# @stdout Selected key and menu row, on separate lines.
# @stderr Picker errors.
# @exitcode 0 Selection accepted.
# @exitcode 130 Picker aborted with Esc or Ctrl+C.
pick_session() {
  local mode="$1"
  local menu_lines="$2"
  local start_pos="${3:-}"
  local start_action i
  local flags=(
    --ansi --height=100% --reverse
    --prompt='List Open Kitty Sessions > '
    --no-multi --with-nth=3.. --bind='esc:abort'
    --no-clear --color="${FZF_COLORS}"
  )

  if [[ "${mode}" == 'normal' ]]; then
    set_cursor_block
    flags+=(
      --header='Normal: j/k move, d close, enter open, i insert, esc quit'
      --disabled --expect='enter,d,i,esc'
      --bind='j:down,k:up' --bind='enter:accept,d:accept,i:accept'
    )
    if [[ -n "${start_pos}" ]] && (( start_pos > 1 )); then
      start_action='down'
      for (( i = 3; i <= start_pos; i++ )); do
        start_action+='+down'
      done
      flags+=(--bind "result:${start_action}")
    fi
  else
    set_cursor_bar
    flags+=(
      --header='Insert: type to filter, enter open, esc normal'
      --expect='enter,esc' --bind='enter:accept'
    )
  fi

  printf '%s\n' "${menu_lines}" | fzf "${flags[@]}"
}

# @description Manage picker modes and apply the selected session action.
# Starts in DEFAULT_MODE and restores the terminal cursor on exit.
# Kitty focus command failures propagate their exit status.
# @noargs
# @stdout Kitty focus command output.
# @stderr Dependency, socket, empty-session or Kitty focus errors.
# @exitcode 0 Session selected or picker canceled.
# @exitcode 1 Missing dependency, socket or sessions.
main() {
  local cmd sock menu_lines fzf_out fzf_rc key sel
  local selected_title selected_index _unused total_lines
  local mode="${DEFAULT_MODE}"
  local fzf_start_pos=''
  trap set_cursor_bar EXIT

  for cmd in fzf jq; do
    if ! command -v "${cmd}" >/dev/null 2>&1; then
      printf '%s is not installed.\n' "${cmd}" >&2
      return 1
    fi
  done
  if ! sock="$(find_kitty_socket)"; then
    printf 'Kitty socket not found. Is remote control enabled?\n' >&2
    return 1
  fi

  while true; do
    menu_lines="$(build_menu_lines "${sock}" || true)"
    if [[ -z "${menu_lines}" ]]; then
      printf 'No sessions found.\n' >&2
      return 1
    fi

    fzf_rc=0
    fzf_out="$(pick_session "${mode}" "${menu_lines}" "${fzf_start_pos}")" \
      || fzf_rc=$?
    fzf_start_pos=''

    if (( fzf_rc != 0 )) && [[ -z "${fzf_out}" ]]; then
      key='esc'
      sel=''
    else
      {
        IFS= read -r key || true
        IFS= read -r sel || true
      } <<<"${fzf_out}"
    fi

    selected_title=''
    selected_index=''
    if [[ -n "${sel}" ]]; then
      IFS=$'\t' read -r selected_index selected_title _unused <<<"${sel}"
    fi

    if [[ "${mode}" == 'insert' && "${key}" == 'esc' ]]; then
      mode='normal'
      continue
    fi
    if [[ "${mode}" == 'normal' && "${key}" == 'esc' ]]; then
      return 0
    fi
    if [[ "${mode}" == 'normal' && "${key}" == 'i' ]]; then
      mode='insert'
      continue
    fi
    if [[ -z "${selected_title}" ]]; then
      [[ "${mode}" == 'normal' ]] && return 0
      mode='normal'
      continue
    fi

    if [[ "${mode}" == 'normal' && "${key}" == 'd' ]]; then
      if [[ "${selected_index}" =~ ^[0-9]+$ ]]; then
        total_lines="$(printf '%s\n' "${menu_lines}" | wc -l)"
        if (( selected_index >= total_lines )); then
          fzf_start_pos=$((selected_index - 1))
        else
          fzf_start_pos="${selected_index}"
        fi
        if (( fzf_start_pos < 1 )); then
          fzf_start_pos=1
        fi
      fi
      kitty @ --to "unix:${sock}" close-window \
        --match "session:^${selected_title}$" >/dev/null 2>&1 || true
      continue
    fi

    if [[ "${key}" == 'enter' ]]; then
      kitty @ --to "unix:${sock}" action goto_session "${selected_title}"
      return 0
    fi
    if [[ "${mode}" == 'insert' ]]; then
      mode='normal'
      continue
    fi
    return 0
  done
}

main "$@"
