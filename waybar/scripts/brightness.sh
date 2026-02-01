#!/bin/bash

# Script único de brilho para Waybar usando brightnessctl
# Uso: brightness.sh [up|down|status]

case "$1" in
    up)
        # Aumenta brilho em 10% do valor atual
        current=$(brightnessctl get)
        max=$(brightnessctl max)
        current_percent=$((current * 100 / max))
        new_percent=$((current_percent + 10))
        
        # Limita a 100%
        if [ "$new_percent" -gt 100 ]; then
            new_percent=100
        fi
        
        brightnessctl set "${new_percent}%" > /dev/null
        ;;
    down)
        # Diminui brilho em 10% do valor atual
        current=$(brightnessctl get)
        max=$(brightnessctl max)
        current_percent=$((current * 100 / max))
        new_percent=$((current_percent - 10))
        
        # Limita a 0%
        if [ "$new_percent" -lt 0 ]; then
            new_percent=0
        fi
        
        brightnessctl set "${new_percent}%" > /dev/null
        ;;
    status|*)
        # Mostra status atual (padrão)
        # Pega o brilho atual em porcentagem
        brightness=$(brightnessctl get)
        max_brightness=$(brightnessctl max)
        
        # Calcula porcentagem
        percentage=$((brightness * 100 / max_brightness))
        
        # Determina o ícone baseado no brilho
        if [ "$percentage" -le 20 ]; then
            icon="󰃞"
        elif [ "$percentage" -le 40 ]; then
            icon="󰃟"
        elif [ "$percentage" -le 60 ]; then
            icon="󰃝"
        elif [ "$percentage" -le 80 ]; then
            icon="󰃠"
        else
            icon="󰃠"
        fi
        
        # Calcula quantos blocos devem estar preenchidos (0-10)
        filled=$((percentage / 10))
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
        echo "{\"text\": \"$icon [$bar]\", \"tooltip\": \"Brilho: $percentage%\", \"percentage\": $percentage}"
        ;;
esac