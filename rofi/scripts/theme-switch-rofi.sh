#!/usr/bin/env bash

# Caminho para o seu script original
THEMER_SCRIPT="$HOME/dotfiles/theme-switcher.sh"

# Captura apenas as linhas de opções (as que começam com números)
opcoes=$(bash "$THEMER_SCRIPT" <<< "" 2>/dev/null | grep -E "^  [0-9]")

# Remove os números e espaços extras para deixar só os nomes
opcoes_limpas=$(echo "$opcoes" | sed 's/^  [0-9]*\. //')

# Mostra no Rofi
escolha=$(echo "$opcoes_limpas" | rofi -dmenu -i -p "Selecione o tema" -theme "dotfiles/rofi/scripts/theme-switch-rofi.rasi")

# Se cancelou, sai
[ -z "$escolha" ] && exit 0

# Descobre qual número corresponde à escolha
numero=$(echo "$opcoes" | grep -F "$escolha" | sed 's/^  \([0-9]*\).*/\1/')

# Executa o script original com o número escolhido
echo "$numero" | bash "$THEMER_SCRIPT"

# Notificação
notify-send "Tema Aplicado" "O tema $escolha foi aplicado!" 