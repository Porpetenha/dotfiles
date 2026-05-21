#!/bin/bash

# 1. Tenta descobrir automaticamente o nome do seu arquivo de configuração
if [ -f "$HOME/.config/waybar/config" ]; then
    CONFIG="$HOME/.config/waybar/config"
elif [ -f "$HOME/.config/waybar/config.jsonc" ]; then
    CONFIG="$HOME/.config/waybar/config.jsonc"
else
    CONFIG="$HOME/.config/waybar/config.json"
fi

# 2. Recebe o nome do módulo
MODULO=$1

# 3. Trava de segurança: Verifica se você passou o módulo
if [ -z "$MODULO" ]; then
    echo "Erro: Você esqueceu de informar o módulo!"
    echo "Uso correto: $0 memory"
    exit 1
fi

# 4. O interruptor usando o layout exato do seu arquivo
if grep -q "//\"$MODULO\"," "$CONFIG"; then
    # Remove as barras
    sed -i "s|//\"$MODULO\",|\"$MODULO\",|g" "$CONFIG"
    echo "[OK] Módulo $MODULO ATIVADO no arquivo $(basename "$CONFIG")!"
    
elif grep -q "\"$MODULO\"," "$CONFIG"; then
    # Adiciona as barras
    sed -i "s|\"$MODULO\",|//\"$MODULO\",|g" "$CONFIG"
    echo "[OK] Módulo $MODULO DESATIVADO no arquivo $(basename "$CONFIG")!"
    
else
    # Se digitar errado ou não achar no arquivo
    echo "Erro: Não encontrei '\"$MODULO\",' e nem '//\"$MODULO\",' no arquivo."
    exit 1
fi

# 5. Manda o sinal pro Waybar recarregar
killall -SIGUSR2 waybar