#!/bin/bash

# Script de volume para Waybar
# Mostra volume com barra visual e ícone dinâmico

# Pega o volume atual e status de mute
volume=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\d+%' | head -1 | tr -d '%')
muted=$(pactl get-sink-mute @DEFAULT_SINK@ | grep -oP 'yes|no')

# Determina o ícone baseado no volume e mute
if [ "$muted" = "yes" ]; then
    icon=""
    volume=0
elif [ "$volume" -le 30 ]; then
    icon=""
elif [ "$volume" -le 70 ]; then
    icon=""
else
    icon=""
fi

# Calcula quantos blocos devem estar preenchidos (0-10)
filled=$((volume / 10))
empty=$((10 - filled))

# Constrói a barra visual
bar=""
for ((i=0; i<filled; i++)); do
    bar+="▮"
done
for ((i=0; i<empty; i++)); do
    bar+="▯"
done

# Output no formato JSON para o Waybar
echo "{\"text\": \"$icon [$bar]\", \"tooltip\": \"Volume: $volume%\", \"percentage\": $volume}"