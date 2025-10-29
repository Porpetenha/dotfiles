#!/bin/bash
# @requires: ddcutil

# Configurações
DISPLAY_NUM=1  # Número do display (ajuste se necessário)
VCP_CODE=10    # Código VCP para brilho (padrão é 10)

percentage () {
  local val=$(echo $1 | tr '%' ' ' | awk '{print $1}')
  local icon1=$2
  local icon2=$3
  local icon3=$4
  local icon4=$5
  if [ "$val" -le 15 ]; then
    echo $icon1
  elif [ "$val" -le 30 ]; then
    echo $icon2
  elif [ "$val" -le 60 ]; then
    echo $icon3
  else
    echo $icon4
  fi 
}

get_brightness () {
  # Pega o valor atual do brilho usando ddcutil
  local output=$(ddcutil getvcp $VCP_CODE --display $DISPLAY_NUM 2>/dev/null | grep -oP 'current value =\s+\K\d+')
  echo ${output:-0}
}

get_max_brightness () {
  # Pega o valor máximo do brilho
  local output=$(ddcutil getvcp $VCP_CODE --display $DISPLAY_NUM 2>/dev/null | grep -oP 'max value =\s+\K\d+')
  echo ${output:-100}
}

get_percent () {
  local br=$(get_brightness)
  local max=$(get_max_brightness)
  local percent=$((br * 100 / max))
  echo "${percent}%"
}

get_icon () {
  local br=$(get_percent)
  echo $(percentage "$br" "󰃞" "󰃟" "󰃝" "󰃠")
}

set_brightness () {
  # Define o brilho (valor de 0-100)
  local value=$1
  if [ "$value" -ge 0 ] && [ "$value" -le 100 ]; then
    ddcutil setvcp $VCP_CODE $value --display $DISPLAY_NUM 2>/dev/null
  fi
}

case $1 in
  "br")
    get_brightness
    ;;
  "percent")
    get_percent
    ;;
  "icon")
    get_icon
    ;;
  "set")
    set_brightness $2
    ;;
  *)
    echo "Uso: $0 {br|percent|icon|set <valor>}"
    exit 1
    ;;
esac