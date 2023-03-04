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
" Google - https://www.google.com/search?q="
" Map - https://www.google.com/maps/search/"
" Youtube - https://www.youtube.com/results?search_query="
" Twitter - https://twitter.com/search?q="
" Googleimages - https://www.google.com/search?hl=en&tbm=isch&q="
" Duckduckgo - https://duckduckgo.com/?q="
" Github - https://github.com/search?q="
" Gitlab - https://gitlab.com/search?search="
" Letterboxd - https://letterboxd.com/search/"
" Trans https://www.reverso.net/tradu%C3%A7%C3%A3o-texto#sl=eng&tl=por&text="
" Context - https://context.reverso.net/traducao/ingles-portugues/"
" Wikipedia - https://en.wikipedia.org/wiki/"
" Aur - https://aur.archlinux.org/packages?O=0&SeB=nd&K="
" Dic https://www.collinsdictionary.com/dictionary/english/"
" Youglish - https://youglish.com/pronounce/"
" Tatoeba - https://tatoeba.org/pt-br/sentences/search?from=eng&to=por&query="
" Cm - https://codemadness.org/idiotbox/?q="
" Yy - https://yewtu.be/search?q="
" Udemy - https://www.udemy.com/courses/search/?src=ukw&q="
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
query=$(rofi -dmenu -i 20 -p "Searching in $engine ") || exit
done

# Display search results in web browser
$DMBROWSER "$engineurl""$query"
