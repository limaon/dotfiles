#!/usr/bin/env bash

readonly BROWSER=${BROWSER:-xdg-open}
FONT="TerminessTTF Nerd Font:size=12"

# Definindo opções
declare -a options=(
  "Google"
  "Map"
  "DuckDuckGo"
  "Youtube"
  "Translate"
  "Twitter" 
  "Googleimages"
  "Github"
  "Gitlab"
  "Letterboxd"
  "Context"
  "Wikipedia"
  "Aur"
  "Cm"
  "Yy"
  "Udemy"
)

# Obtendo seleção do usuário
choice=$(printf '%s\n' "${options[@]}" | sort -u | dmenu -i -fn "$FONT" -p " WebSearch:")

# Definindo a URL de pesquisa para cada opção
case "$choice" in
  "Google") search_url="https://www.whoogle.click/search?q=";;
  "DuckDuckGo") search_url="https://duckduckgo.com/?q=";;
  "Map") search_url="https://www.google.com/maps/search/";;
  "Youtube") search_url="https://www.youtube.com/results?search_query=";;
  "Translate") search_url="https://www.reverso.net/tradu%C3%A7%C3%A3o-texto#sl=eng&tl=por&text=";;
  "Twitter") search_url="- https://twitter.com/search?q=";;
  "Googleimages") search_url="https://www.google.com/search?hl=en&tbm=isch&q=";;
  "Github") search_url="https://github.com/search?q=";;
  "Gitlab") search_url="https://gitlab.com/search?search=";;
  "Letterboxd") search_url="https://letterboxd.com/search/";;
  "Context") search_url="https://context.reverso.net/traducao/ingles-portugues/";;
  "Wikipedia") search_url="https://en.wikipedia.org/wiki/";;
  "Aur") search_url="https://aur.archlinux.org/packages?O=0&SeB=nd&K=";;
  "Cm") search_url="https://codemadness.org/idiotbox/?q=";;
  "Yy") search_url="https://yewtu.be/search?q=";;
  "Udemy") search_url="https://www.udemy.com/courses/search/?src=ukw&q=";;
  *) exit 1;;
esac

# Obtendo a pesquisa do usuário
search=$(echo "<= Type here" | dmenu -i -fn "$FONT" -p "Searching in $choice:")

# Verificando se o usuário entrou com um valor para a pesquisa
if [ -n "$search" ]; then
  # Abrindo o navegador padrão com a URL de pesquisa e o termo de pesquisa
  $BROWSER "$search_url$search"
fi
