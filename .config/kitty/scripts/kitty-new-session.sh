#!/usr/bin/env bash
# kitty-new-session.sh - Cria sessão dinamicamente (find + SSH)
# Adaptado de: linkarzu/dotfiles-latest/kitty/scripts/kitty-zoxide-session.sh

set -euo pipefail

kitty_bin="kitty"
script_path="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/$(basename -- "${BASH_SOURCE[0]}")"
session_dir="/tmp/kitty-sessions"
project_dirs=("$HOME/Desktop" "$HOME/.config")

# Colors (Solarized Osaka Dark)
# Source: https://github.com/craftzdog/solarized-osaka.nvim
base_color="\033[38;2;131;147;149m"      # color7/15: #839395 (foreground)
current_color="\033[38;2;41;162;152m"    # color6/14: #29a298 (cyan)
green_color="\033[38;2;132;153;0m"       # color2/10: #849900 (yellow-green)
active_color="\033[38;2;38;139;211m"     # color4/12: #268bd3 (blue)
warning_color="\033[38;2;178;133;0m"     # color3/11: #b28500 (yellow)
error_color="\033[38;2;219;48;45m"       # color1/9: #db302d (red)
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

require_cmd() {
  local cmd="$1"
  local hint="$2"
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "$cmd is not installed. $hint"
    exit 1
  fi
}

require_cmd fzf "Install: sudo apt install fzf"
require_cmd jq "Install: sudo apt install jq"

# Find kitty socket dynamically (kitty appends PID to socket name)
find_kitty_socket() {
  local sock=""
  # Try KITTY_LISTEN_ON first
  if [[ -n "${KITTY_LISTEN_ON:-}" ]]; then
    sock="${KITTY_LISTEN_ON#unix:}"
    [[ -S "$sock" ]] && echo "$sock" && return 0
  fi
  # Find socket in /tmp
  sock="$(ls /tmp/kitty-* 2>/dev/null | head -1)"
  if [[ -n "$sock" && -S "$sock" ]]; then
    echo "$sock"
    return 0
  fi
  return 1
}

sock="$(find_kitty_socket || true)"
if [[ -z "$sock" ]]; then
  echo "Kitty socket not found in /tmp. Is kitty running with remote control?"
  exit 1
fi

normalize_path() {
  local p="$1"
  if command -v realpath >/dev/null 2>&1; then
    realpath "$p"
  else
    printf "%s" "$p"
  fi
}

hash_path() {
  local p="$1"
  if command -v sha256sum >/dev/null 2>&1; then
    printf "%s" "$p" | sha256sum | awk '{print $1}'
  elif command -v md5sum >/dev/null 2>&1; then
    printf "%s" "$p" | md5sum | awk '{print $1}'
  else
    printf "%s" "$p" | python3 -c "import hashlib,sys; print(hashlib.sha256(sys.stdin.read().encode()).hexdigest())"
  fi
}

session_exists() {
  local name="$1"
  kitty @ --to "unix:${sock}" ls 2>/dev/null | jq -e --arg name "$name" \
    'any(.[]?.tabs[]?.windows[]?; .session_name == $name)' >/dev/null
}

find_session_by_path() {
  local target="$1"
  local name="" pwd="" real=""

  while IFS=$'\t' read -r name pwd; do
    [[ -z "$name" || -z "$pwd" ]] && continue
    [[ ! -d "$pwd" ]] && continue
    real="$(normalize_path "$pwd")"
    if [[ "$real" == "$target" ]]; then
      printf "%s" "$name"
      return 0
    fi
  done < <(
    kitty @ --to "unix:${sock}" ls 2>/dev/null | jq -r '
      .[]?.tabs[]?.windows[]?
      | select(.session_name != null and .session_name != "")
      | [(.session_name|tostring), (.env.PWD // .cwd // "")]
      | @tsv
    '
  )
  return 1
}

collect_ssh_config_files() {
  local root_config="$HOME/.ssh/config"
  [[ -f "$root_config" ]] || return 0

  local file="" line="" includes="" pattern="" match=""
  local queue=("$root_config") files=() processed="|"

  while ((${#queue[@]})); do
    file="${queue[0]}"
    queue=("${queue[@]:1}")
    [[ "$processed" == *"|${file}|"* ]] && continue
    processed+="${file}|"
    [[ ! -f "$file" ]] && continue
    files+=("$file")

    while IFS= read -r line || [[ -n "$line" ]]; do
      line="${line%%#*}"
      if [[ "$line" =~ ^[[:space:]]*Include[[:space:]]+(.+) ]]; then
        includes="${BASH_REMATCH[1]}"
        for pattern in $includes; do
          pattern="${pattern/#~/$HOME}"
          for match in $pattern; do
            [[ -f "$match" ]] && queue+=("$match")
          done
        done
      fi
    done <"$file"
  done

  printf '%s\n' "${files[@]}"
}

print_ssh_menu_lines() {
  local config_files=()
  local host="" label=""

  while IFS= read -r f; do
    config_files+=("$f")
  done < <(collect_ssh_config_files)

  ((${#config_files[@]} == 0)) && return 0

  while IFS= read -r host; do
    [[ -z "$host" ]] && continue
    label="ssh-${host}"
    printf "%s\t%b%s%b\n" "ssh:${host}" "${green_color}" "$label" "${reset_color}"
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

print_menu_lines() {
  for dir in "${project_dirs[@]}"; do
    [[ -d "$dir" ]] || continue
    find "$dir" -maxdepth 1 -type d \
      -not -path "*/.git" \
      -not -path "*/.github" \
      -not -path "*/node_modules" \
      -not -path "*/.cache" \
      -not -path "*/__pycache__" \
      -not -path "*/.venv" \
      -not -path "*/venv" \
      2>/dev/null
  done | sort -u | awk -v OFS='\t' -v color="${base_color}" -v reset="${reset_color}" '{
    path=$0
    n=split(path, parts, "/")
    base=parts[n]
    if (base == "") base=path
    printf "%s\t%s%s%s  %s\n", path, color, base, reset, path
  }'

  print_ssh_menu_lines
}

# Handle --reload argument for fzf live filtering
if [[ "${1:-}" == "--reload" ]]; then
  print_menu_lines
  exit 0
fi

focus_or_launch_dir() {
  local selected_path="$1"
  local selected_real="" base="" safe_base="" hash=""
  local session_name="" existing_session="" session_file=""

  [[ ! -d "$selected_path" ]] && { echo "Directory not found: $selected_path"; exit 1; }

  selected_real="$(normalize_path "$selected_path")"

  existing_session="$(find_session_by_path "$selected_real" || true)"
  if [[ -n "$existing_session" ]]; then
    kitty @ --to "unix:${sock}" action goto_session "$existing_session"
    return 0
  fi

  base="$(basename "$selected_path")"
  safe_base="$(printf "%s" "$base" | tr -cs 'A-Za-z0-9._-' '_')"
  hash="$(hash_path "$selected_real")"
  hash="${hash:0:4}"
  session_name="z-${safe_base}"

  if session_exists "$session_name"; then
    session_name="${session_name}-${hash}"
  fi

  mkdir -p "$session_dir"
  session_file="${session_dir}/${session_name}.kitty-session"

  cat >"$session_file" <<EOF
layout tall
cd ${selected_real}
launch --title "${base}"
focus
focus_os_window
EOF

  kitty @ --to "unix:${sock}" action goto_session "$session_file"
}

focus_or_launch_ssh() {
  local host="$1"
  local safe_host="" session_file=""

  safe_host="$(printf "%s" "$host" | tr -cs 'A-Za-z0-9._-' '_')"

  mkdir -p "$session_dir"
  session_file="${session_dir}/ssh-${safe_host}.kitty-session"

  cat >"$session_file" <<EOF
layout tall
launch --title "ssh-${host}" ssh ${host}
focus
focus_os_window
EOF

  kitty @ --to "unix:${sock}" action goto_session "$session_file"
}

set +e
printf '\033[2J\033[H'
fzf_out="$(
  fzf --exact --ansi --height=20 --reverse \
    --header="Type to filter, enter open, esc quit" \
    --prompt="Create New Kitty Session > " \
    --no-multi \
    --with-nth=2.. \
    --no-sort \
    --tiebreak=index \
    --expect=enter,esc \
    --bind 'enter:accept' \
    --bind 'esc:abort' \
    --bind "start:reload:${script_path} --reload \"{q}\"" \
    --bind "change:reload:${script_path} --reload \"{q}\"" \
    --color="$fzf_colors"
)"
fzf_rc=$?
set -e

if [[ $fzf_rc -ne 0 && -z "${fzf_out:-}" ]]; then
  exit 0
fi

key="$(printf "%s\n" "$fzf_out" | head -n1)"
[[ "$key" == "esc" ]] && exit 0

sel="$(printf "%s\n" "$fzf_out" | sed -n '2p' || true)"
selected_path=""
[[ -n "${sel:-}" ]] && selected_path="$(printf "%s" "$sel" | awk -F'\t' '{print $1}')"

[[ -z "${selected_path:-}" ]] && exit 0

if [[ "$selected_path" == ssh:* ]]; then
  focus_or_launch_ssh "${selected_path#ssh:}"
else
  focus_or_launch_dir "$selected_path"
fi
