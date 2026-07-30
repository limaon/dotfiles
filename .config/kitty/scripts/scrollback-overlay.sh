#!/usr/bin/env bash

LOCK=/tmp/kitty-scrollback.lock

if ! mkdir "$LOCK" 2>/dev/null; then
    exit 0
fi
trap "rmdir '$LOCK'" EXIT

sed 's/[[:space:]]*$//' | nvim \
    +"nnoremap q ZQ" \
    +"tnoremap <Esc> <C-\><C-n>" \
    +"call nvim_open_term(0, {})" \
    +"stopinsert" \
    +"set number relativenumber" \
    +"$" \
    -
