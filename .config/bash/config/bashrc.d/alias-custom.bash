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

lf() {
  \umask 077
  tmp="$(command mktemp)"
  command lf -last-dir-path="$tmp" "$@"
  if [ -f "$tmp" ]; then
    dir="$(command cat "$tmp")"
    command rm -f "$tmp"
  else
    \return 1
  fi
  if [ -d "$dir" ] && [ "$dir" != "$(pwd)" ]; then
    \cd "$dir" || \return 1
  fi
}
