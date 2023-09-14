#!/usr/bin/env bash

# Verifica se foi passado algum parâmetro
if [ $# -eq 0 ]
then
  echo "Este script configura o monitor e define o papel de parede usando o Nitrogen."
  echo "Parâmetros:"
  echo "  -h, --help: mostra o menu de ajuda"
  echo "  -m, --monitor: configura o monitor (valores possíveis: laptop, hdmi, ambos)"
  echo "  -p, --paper: define o papel de parede (caminho para a imagem)"
  exit 1
fi

# Define as variáveis de acordo com os parâmetros
monitor=""
paper=""

while [ $# -gt 0 ]
do
  case "$1" in
    -h|--help)
      echo "Este script configura o monitor e define o papel de parede usando o Nitrogen."
      echo "Parâmetros:"
      echo "  -h, --help: mostra o menu de ajuda"
      echo "  -m, --monitor: configura o monitor (valores possíveis: laptop, hdmi, ambos)"
      echo "  -p, --paper: define o papel de parede (caminho para a imagem)"
      exit 0
      ;;
    -m|--monitor)
      monitor="$2"
      shift
      ;;
    -p|--paper)
      paper="$2"
      shift
      ;;
    *)
      echo "Parâmetro inválido: $1"
      exit 1
      ;;
  esac
  shift
done

# Configura o monitor
if [ "$monitor" == "laptop" ]
then
  xrandr --output HDMI-1 --off --output eDP-1 --mode 1366x768 --pos 0x0 --rotate normal
elif [ "$monitor" == "hdmi" ]
then
  xrandr --output eDP-1 --off --output HDMI-1 --primary --mode 1920x1080 --pos 0x0 --rotate normal
elif [ "$monitor" == "ambos" ]
then
  xrandr --output eDP-1 --mode 1366x768 --pos 0x0 --rotate normal --output HDMI-1 --primary --mode 1920x1080 --pos 1366x0 --rotate normal
else
  echo "Monitor inválido: $monitor"
  exit 1
fi

# Define o papel de parede
if [ -n "$paper" ]
then
  nitrogen --set-scaled "$paper"
fi

# Restaura o último papel de parede definido
sleep 2
nitrogen --restore
