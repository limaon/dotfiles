#!/usr/bin/env bash
#
# Script name: dmsearch
# Description: Search various search engines (inspired by surfraw).
# Dependencies: dmenu and a web browser
# GitLab: https://www.gitlab.com/dwt1/dmscripts
# Contributors: Derek Taylor

# Defining our web browser.
# DMBROWSER="firefox"
DMBROWSER="xdg-open"

# An array of search engines.  You can edit this list to add/remove
# search engines. The format must be: "engine_name - url".
# The url format must allow for the search keywords at the end of the url.
# For example: https://www.amazon.com/s?k=XXXX searches Amazon for 'XXXX'.
declare -a options=(
" google - https://www.google.com/search?q="
" map - https://www.google.com/maps/search/"
" (yt)youtube - https://www.youtube.com/results?search_query="
" twitter - https://twitter.com/search?q="
" googleimages - https://www.google.com/search?hl=en&tbm=isch&q="
" (dg)duckduckgo - https://duckduckgo.com/?q="
" github - https://github.com/search?q="
" gitlab - https://gitlab.com/search?search="
" letterboxd - https://letterboxd.com/search/"
" translate - https://www.reverso.net/tradução-texto#sl=en&tl=por&text="
" context - https://context.reverso.net/traducao/ingles-portugues/"
" wikipedia - https://en.wikipedia.org/wiki/"
" aur - https://aur.archlinux.org/packages?O=0&SeB=nd&K="
" oxford - https://www.oxfordlearnersdictionaries.com/us/spellcheck/english/?q="
" (yg)youglish - https://youglish.com/pronounce/"
" tatoeba - https://tatoeba.org/pt-br/sentences/search?from=eng&to=por&query="
" cm - https://codemadness.org/idiotbox/?q="
" yy - https://yewtu.be/search?q="
" udemy - https://www.udemy.com/courses/search/?src=ukw&q="
"quit"
)
# 'oxford'  => Browser.new('https://www.oxfordlearnersdictionaries.com/us/spellcheck/english/?q=%s', profile: ''),
# 'ttb'  => Browser.new('https://tatoeba.org/pt-br/sentences/search?from=eng&query=%s&to=por', profile: ''),

# Picking a search engine.
while [ -z "$engine" ]; do
enginelist=$(printf '%s\n' "${options[@]}" | rofi -dmenu -i 20 -p ' WebSearch ') || exit
engineurl=$(echo "$enginelist" | awk '{print $NF}')
engine=$(echo "$enginelist" | awk '{print $1}')
done

# Searching the chosen engine.
while [ -z "$query" ]; do
query=$(rofi -dmenu -i 20 -p "Searching $engine ") || exit
done

# Display search results in web browser
$DMBROWSER "$engineurl""$query"

