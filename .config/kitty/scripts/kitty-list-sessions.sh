#!/usr/bin/env bash
# kitty-list-sessions.sh - Lista sessões abertas e permite alternar
# Adaptado de: linkarzu/dotfiles-latest/kitty/scripts/kitty-list-sessions.sh

set -euo pipefail

default_mode="insert"

set_cursor_block() { printf '\e[2 q' >/dev/tty; }
set_cursor_bar() { printf '\e[6 q' >/dev/tty; }
trap 'set_cursor_bar' EXIT

kitty_bin="kitty"

# Colors (Solarized Osaka Dark)
# Source: https://github.com/craftzdog/solarized-osaka.nvim
base_color="\033[38;2;131;147;149m"      # color7/15: #839395 (foreground)
current_color="\033[38;2;41;162;152m"    # color6/14: #29a298 (cyan)
active_color="\033[38;2;38;139;211m"     # color4/12: #268bd3 (blue)
warning_color="\033[38;2;178;133;0m"     # color3/11: #b28500 (yellow)
error_color="\033[38;2;219;48;45m"       # color1/9: #db302d (red)
success_color="\033[38;2;132;153;0m"     # color2/10: #849900 (green)
reset_color="\033[0m"

fzf_colors="bg:#001419,fg:#839395"
fzf_colors+=",hl:#29a298,hl+:#29a298"
fzf_colors+=",info:#576d74,header:#576d74"
fzf_colors+=",prompt:#849900"
fzf_colors+=",pointer:#b28500"
fzf_colors+=",marker:#268bd3"
fzf_colors+=",spinner:#d23681"
fzf_colors+=",fg+:#839395"
fzf_colors+=",bg+:#002c38"
fzf_colors+=",gutter:#001014"

if ! command -v fzf >/dev/null 2>&1; then
  echo "fzf is not installed."
  exit 1
fi

if ! command -v jq >/dev/null 2>&1; then
  echo "jq is not installed."
  exit 1
fi

# Find kitty socket dynamically (kitty appends PID to socket name)
find_kitty_socket() {
  local sock=""
  # Try KITTY_LISTEN_ON first
  if [[ -n "${KITTY_LISTEN_ON:-}" ]]; then
    sock="${KITTY_LISTEN_ON#unix:}"
    [[ -S "$sock" ]] && echo "$sock" && return 0
  fi
  # Find socket in /tmp
  for sock in /tmp/kitty-*; do
    [[ -S "$sock" ]] && echo "$sock" && return 0
  done
  return 1
}

sock="$(find_kitty_socket || true)"
if [[ -z "$sock" ]]; then
  echo "Kitty socket not found in /tmp. Is kitty running with remote control?"
  exit 1
fi

build_menu_lines() {
  local sessions_tsv=""
  sessions_tsv="$(
    kitty @ --to "unix:${sock}" ls 2>/dev/null | jq -r '
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
            (.session_name|tostring),
            (.os_focused|tostring),
            (.tab_focused|tostring),
            (.pwd | ltrimstr(env.HOME) | if . != "" then "~" + . else . end)
          ]
        | @tsv
    '
  )"

  [[ -z "${sessions_tsv:-}" ]] && return 1

  printf "%s\n" "$sessions_tsv" | awk -F'\t' -v base_color="${base_color}" -v current_color="${current_color}" -v reset_color="${reset_color}" '{
    session_name=$1
    os_focused=$2
    tab_focused=$3
    path=$4
    display_name=session_name
    if (os_focused == "true" && tab_focused == "true") {
      name_color=current_color
    } else {
      name_color=base_color
    }
    printf "%d\t%s\t%s%s%s  %s\n", NR, session_name, name_color, display_name, reset_color, path
  }'
}

mode="$default_mode"
fzf_start_pos=""

while true; do
  menu_lines="$(build_menu_lines || true)"
  if [[ -z "${menu_lines:-}" ]]; then
    echo "No sessions found."
    exit 1
  fi

  fzf_out=""
  fzf_rc=0

  if [[ "$mode" == "normal" ]]; then
    set_cursor_block
    set +e
    fzf_start_pos_opt=()
    if [[ -n "${fzf_start_pos:-}" && "$fzf_start_pos" -gt 1 ]]; then
      fzf_start_action="down"
      for ((i = 3; i <= fzf_start_pos; i++)); do
        fzf_start_action+="+down"
      done
      fzf_start_pos_opt=(--bind "result:${fzf_start_action}")
    fi
    fzf_out="$(
      printf "%s\n" "$menu_lines" |
        fzf --ansi --height=100% --reverse \
          --header="Normal: j/k move, d close, enter open, i insert, esc quit" \
          --prompt="List Open Kitty Sessions > " \
          --no-multi --disabled \
          --with-nth=3.. \
          --expect=enter,d,i,esc \
          --bind 'j:down,k:up' \
          --bind 'enter:accept,d:accept,i:accept' \
          --bind 'esc:abort' \
          --no-clear \
          --color="$fzf_colors" \
          ${fzf_start_pos_opt[@]+"${fzf_start_pos_opt[@]}"}
    )"
    fzf_rc=$?
    fzf_start_pos=""
    set -e
  else
    set_cursor_bar
    set +e
    fzf_out="$(
      printf "%s\n" "$menu_lines" |
        fzf --ansi --height=100% --reverse \
          --header="Insert: type to filter, enter open, esc normal" \
          --prompt="List Open Kitty Sessions > " \
          --no-multi \
          --with-nth=3.. \
          --expect=enter,esc \
          --bind 'enter:accept' \
          --bind 'esc:abort' \
          --no-clear \
          --color="$fzf_colors"
    )"
    fzf_rc=$?
    set -e
  fi

  if [[ $fzf_rc -ne 0 && -z "${fzf_out:-}" ]]; then
    key="esc"
    sel=""
  else
    key=""
    sel=""
    while IFS= read -r line; do
      if [[ -z "$key" ]]; then
        key="$line"
      else
        sel="$line"
        break
      fi
    done <<< "$fzf_out"
  fi

  selected_title=""
  selected_index=""
  if [[ -n "${sel:-}" ]]; then
    selected_index="$(printf "%s" "$sel" | cut -f1)"
    selected_title="$(printf "%s" "$sel" | cut -f2)"
  fi

  if [[ "$mode" == "insert" && "$key" == "esc" ]]; then
    mode="normal"
    continue
  fi

  if [[ "$mode" == "normal" && "$key" == "esc" ]]; then
    exit 0
  fi

  if [[ "$mode" == "normal" && "$key" == "i" ]]; then
    mode="insert"
    continue
  fi

  if [[ -z "${selected_title:-}" ]]; then
    [[ "$mode" == "normal" ]] && exit 0
    mode="normal"
    continue
  fi

  if [[ "$mode" == "normal" && "$key" == "d" ]]; then
    if [[ "${selected_index:-}" =~ ^[0-9]+$ ]]; then
      total_lines="$(printf "%s\n" "$menu_lines" | wc -l)"
      if [[ -n "${total_lines:-}" && "$selected_index" -ge "$total_lines" ]]; then
        fzf_start_pos=$((selected_index - 1))
      else
        fzf_start_pos=$selected_index
      fi
      [[ "$fzf_start_pos" -lt 1 ]] && fzf_start_pos=1
    fi
    kitty @ --to "unix:${sock}" action close_session "$selected_title" >/dev/null 2>&1 || true
    continue
  fi

  if [[ "$key" == "enter" ]]; then
    kitty @ --to "unix:${sock}" action goto_session "$selected_title"
    exit 0
  fi

  [[ "$mode" == "insert" ]] && { mode="normal"; continue; }
  exit 0
done
