#!/usr/bin/env bash

set -euo pipefail

direction="${1:-next}"

find_kitty_socket() {
  local candidate

  if [[ -n "${KITTY_LISTEN_ON:-}" ]]; then
    candidate="${KITTY_LISTEN_ON#unix:}"
    [[ -S "$candidate" ]] && printf 'unix:%s' "$candidate" && return 0
  fi

  for candidate in /tmp/kitty-* /tmp/kitty; do
    [[ -S "$candidate" ]] && printf 'unix:%s' "$candidate" && return 0
  done

  return 1
}

socket="$(find_kitty_socket)" || exit 0

session_data="$({
  kitty @ --to "$socket" ls |
    jq -r '
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
} 2>/dev/null)"

[[ -z "$session_data" ]] && exit 0

sessions=()
current_index=0
while IFS=$'\t' read -r name focused; do
  [[ -z "$name" ]] && continue
  sessions+=("$name")
  [[ "$focused" == true ]] && current_index=$((${#sessions[@]} - 1))
done <<< "$session_data"

((${#sessions[@]} == 0)) && exit 0

if [[ "$direction" == previous ]]; then
  next_index=$(( (current_index - 1 + ${#sessions[@]}) % ${#sessions[@]} ))
else
  next_index=$(( (current_index + 1) % ${#sessions[@]} ))
fi

kitty @ --to "$socket" action goto_session "${sessions[$next_index]}"
