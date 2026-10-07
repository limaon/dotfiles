#!/usr/bin/env bash
#
# @file cycle_session.sh
# @brief Cycle through active Kitty sessions in alphabetical order.

set -euo pipefail

# @description Find Kitty's socket, preferring the launching instance.
# Reads KITTY_LISTEN_ON when set, then searches the fallback socket paths.
# @noargs
# @stdout Kitty socket address with the unix: prefix.
# @exitcode 0 A socket was found.
# @exitcode 1 No socket was found.
find_kitty_socket() {
  local candidate

  if [[ -n "${KITTY_LISTEN_ON:-}" ]]; then
    candidate="${KITTY_LISTEN_ON#unix:}"
    if [[ -S "${candidate}" ]]; then
      printf 'unix:%s' "${candidate}"
      return 0
    fi
  fi

  for candidate in /tmp/kitty-* /tmp/kitty; do
    if [[ -S "${candidate}" ]]; then
      printf 'unix:%s' "${candidate}"
      return 0
    fi
  done
  return 1
}

# @description Focus the next or previous session, wrapping at list boundaries.
# Command failures propagate their exit status.
# @arg $1 string Optional direction: previous or next (default).
# @stdout Kitty focus command output.
# @stderr Kitty focus command errors.
# @exitcode 0 Session focused, or no socket/sessions were available.
main() {
  local direction="${1:-next}"
  local socket session_data name focused next_index
  local current_index=0
  local sessions=()

  socket="$(find_kitty_socket)" || return 0
  session_data="$(
    {
      kitty @ --to "${socket}" ls \
        | jq -r '
          [
            .[] as $os
            | $os.tabs[] as $tab
            | $tab.windows[]?
            | select(.session_name != null and .session_name != "")
            | {
                name: .session_name,
                focused: (($os.is_focused // false)
                  and ($tab.is_focused // false)
                  and (.is_focused // false))
              }
          ]
          | group_by(.name)
          | map({
              name: .[0].name,
              focused: (map(select(.focused)) | length > 0)
            })
          | sort_by(.name)
          | .[]
          | [.name, (.focused | tostring)]
          | @tsv
        '
    } 2>/dev/null
  )"
  [[ -n "${session_data}" ]] || return 0

  while IFS=$'\t' read -r name focused; do
    [[ -n "${name}" ]] || continue
    sessions+=("${name}")
    if [[ "${focused}" == 'true' ]]; then
      current_index=$((${#sessions[@]} - 1))
    fi
  done <<<"${session_data}"
  (( ${#sessions[@]} > 0 )) || return 0

  if [[ "${direction}" == 'previous' ]]; then
    next_index=$(( (current_index - 1 + ${#sessions[@]}) % ${#sessions[@]} ))
  else
    next_index=$(( (current_index + 1) % ${#sessions[@]} ))
  fi

  kitty @ --to "${socket}" action goto_session "${sessions[next_index]}"
}

main "$@"
