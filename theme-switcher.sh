#!/usr/bin/env bash

# =============================================================================
#
#  THEMER.SH - Um script simples para trocar temas (dotfiles)
#
#  Este script usa a lógica de "symlink slot" (encaixe de link simbólico)
#  e executa comandos específicos por tema.
#
# =============================================================================

# --- INÍCIO DA CONFIGURAÇÃO ---
# Edite esta seção para corresponder à sua configuração.

# 1. DIRETÓRIOS PRINCIPAIS
DOTFILES_DIR="$HOME/dotfiles"
THEMES_DIR="$DOTFILES_DIR/themes"


# 2. DEFINIÇÃO DOS TEMAS
THEME_NAMES=(
    #"Catppuccin Mocha"
    "Tokyo Night Storm"
    "Gruvbox Dark"
    "Kanagawa"
    # Adicione novos nomes de exibição aqui.
)

declare -A THEMES=(
    #["Catppuccin Mocha"]="catppuccin-mocha"
    ["Tokyo Night Storm"]="tokyo-night-storm"
    ["Gruvbox Dark"]="gruvbox-dark"
    ["Kanagawa"]="kanagawa"
    #Adicione novos mapeamentos aqui.
)


# 3. DEFINIÇÃO DOS ALVOS (APLICATIVOS DENTRO DE DOTFILES)
declare -A APP_TARGETS=(
    ["kitty"]="colors.conf"
    ["hypr"]="look-and-feel.lua hyprlock.conf"
    ["waybar"]="style.css config.jsonc"
    ["rofi"]="colors.rasi"
    ["swaync"]="style.css config.json"
    ["dunst"]="dunstrc"
    ["eww"]="_variables.scss"
    ["gtk-3.0"]="settings.ini"
    ["gtk-4.0"]="settings.ini"
    
)

# 4. DEFINIÇÃO DE ALVOS "ROOT" (FORA DO DOTFILES_DIR)
declare -A ROOT_TARGETS=(
    ["$HOME/.config/starship.toml"]="starship.toml"
)


# --- FIM DA CONFIGURAÇÃO ---


# =============================================================================
#  FUNÇÕES DO SCRIPT
#  (Você só precisa editar a 'run_theme_commands' abaixo)
# =============================================================================
set_wallpaper() {
    local img_path=$1
    local hypr_conf="$HOME/dotfiles/hypr/hyprpaper.conf"
    sed -i "s|^preload = .*|preload = $img_path|" "$hypr_conf"
    sed -i "s|path = .*|path = $img_path|" "$hypr_conf"
}

set_obsidian_theme() {
    local theme_name=$1
    find "$HOME" -type f -path "*/.obsidian/appearance.json" 2>/dev/null \
        | while read -r f; do
            sed -i "s/\(\"cssTheme\": \"\)[^\"]*/\1$theme_name/" "$f"
            echo "    - Atualizado: $f"
        done
}

set_vscode_theme() {
    local theme_name=$1
    sed -i "s/\"workbench.colorTheme\":.*/\"workbench.colorTheme\": \"$theme_name\",/" \
        "$HOME/.config/Code/User/settings.json"
}

set_firefox_bg() {
    local ff_bg=$1
    local ff_css
    ff_css=$(find "$HOME/.mozilla/firefox" -name "userContent.css" 2>/dev/null | head -1)
    
    if [ -z "$ff_css" ]; then
        echo "    - [!] userContent.css não encontrado."
        return
    fi
    sed -i "s/--bg: #[0-9A-Fa-f]\{6\};/--bg: $ff_bg;/g" "$ff_css"
    echo "    - Atualizado: $ff_css"
}

set_gtk_theme() {
    local gtk_theme=$1
    local cursor_theme=$2
    local papirus_color=$3
    local cursor_size=$4
    local icon_theme="${5:-Papirus-Dark}"  # Papirus-Dark como padrão

    gsettings set org.gnome.desktop.interface gtk-theme "$gtk_theme"
    gsettings set org.gnome.desktop.interface cursor-theme "$cursor_theme"
    gsettings set org.gnome.desktop.interface icon-theme "$icon_theme"
    nohup papirus-folders -C "$papirus_color" --theme "$icon_theme" >/dev/null 2>&1 &
    hyprctl setcursor "$cursor_theme" "$cursor_size"
}
#
# (NOVO) ADICIONE SEUS COMANDOS ESPECÍFICOS AQUI
#
# Esta função é chamada após a criação dos links.
#
run_theme_commands() {
    local theme_folder_name=$1
    local selected_display_name=$2
    echo "Executando comandos específicos do tema..."

    # Define o caminho do arquivo de configuração do hyprpaper
    local hypr_conf="$HOME/dotfiles/hypr/hyprpaper.conf"

    case "$theme_folder_name" in
        "catppuccin-mocha")
            echo "  > Executando 'sed' para VS Code ($selected_display_name)..."
            sed -i 's/"workbench.colorTheme":.*/"workbench.colorTheme": "Catppuccin Mocha",/' "$HOME/.config/Code/User/settings.json"
            
            echo "  > Aplicando wallpaper do $selected_display_name..."
            local img_cat="$HOME/dotfiles/themes/catppuccin-mocha/catppuccin-tree.jpg"
            # Atualiza o preload (se existir)
            sed -i "s|^preload = .*|preload = $img_cat|" "$hypr_conf"
            # Atualiza o path dentro do bloco wallpaper { ... }
            sed -i "s|path = .*|path = $img_cat|" "$hypr_conf"

            echo "  > Executando 'sed' seguro para o Obsidian ($selected_display_name..."
            find "$HOME" -type f -path "*/.obsidian/appearance.json" 2>/dev/null | while read -r obsidian_config; do
                sed -i 's/\("cssTheme": "\)[^"]*/\1Catppuccin/' "$obsidian_config"
                echo "    - Atualizado: $obsidian_config"
            done
            ;;

        "tokyo-night-storm")
            echo "  > Executando 'sed' para VS Code ($selected_display_name)..."
            set_vscode_theme "Tokyo Night Storm"
            
            echo "  > Aplicando wallpaper do $selected_display_name..."
            set_wallpaper "$THEMES_DIR/tokyo-night-storm/tokyo-kanagawa.jpg"

            echo "  > Executando 'sed' para o Obsidian ($selected_display_name)..."
            set_obsidian_theme "Tokyo Night"

            echo "  > Aplicando tema ($selected_display_name) ao Firefox..."
            set_firefox_bg "#24283b"

            echo " > Alterando o tema do sistema..."
            set_gtk_theme "Tokyonight-Dark-Storm" "Moga-Candy-Macchiato" "red" 20
            ;;
        

        "gruvbox-dark")
            echo "  > Executando 'sed' para VS Code ($selected_display_name)..."
            set_vscode_theme "Gruvbox Dark Medium"
            
            echo "  > Aplicando wallpaper do $selected_display_name..."
            set_wallpaper "$THEMES_DIR/gruvbox-dark/gruvbox-astro.jpg"

            echo "  > Executando 'sed' para o Obsidian ($selected_display_name)..."
            set_obsidian_theme "Obsidian gruvbox"

            echo "  > Aplicando tema ($selected_display_name) ao Firefox..."
            set_firefox_bg "#282828"

            echo " > Alterando o tema do sistema..."
            set_gtk_theme "Gruvbox-Dark-Medium" "Moga-Candy-Grey" "brown" 24
            ;;

        "kanagawa")
            echo "  > Executando 'sed' para VS Code ($selected_display_name)..."
            set_vscode_theme "Kanagawa"

            echo "  > Aplicando wallpaper do $selected_display_name..."
            set_wallpaper "$THEMES_DIR/kanagawa/kanagawa.jpg"
            
            echo "  > Executando 'sed' para o Obsidian ($selected_display_name)..."
            set_obsidian_theme "Kanagawa"
            
            echo "  > Aplicando tema ($selected_display_name) ao Firefox..."
            set_firefox_bg "#1C1C22"
                        
            echo " > Alterando o tema do sistema..."
            set_gtk_theme "Kanagawa" "Moga-Sandy" "paleorange" 20
            ;;
        *)

            echo "  [Info] Nenhum comando específico para este tema."
            ;;
    esac
}

send_notification() {
    local theme_folder_name=$1
    local theme_display_name=$2
    local icon_path="$THEMES_DIR/$theme_folder_name/icon.svg"

    # Fallback caso o tema não tenha icon.svg
    if [ ! -f "$icon_path" ]; then
        icon_path="preferences-desktop-theme"  # ícone genérico do sistema
    fi

    notify-send \
        --icon="$icon_path" \
        --urgency=normal \
        "Tema Alterado" \
        "O tema foi alterado para: $theme_display_name"
}

# Função para aplicar os links do tema
apply_theme_links() {
    local theme_folder_name=$1

    # Loop 1: Processar alvos DENTRO de DOTFILES_DIR
    for app_folder in "${!APP_TARGETS[@]}"; do
        local generic_files="${APP_TARGETS[$app_folder]}"
        for generic_file in $generic_files; do
            local app_dir="$DOTFILES_DIR/$app_folder"
            local theme_source_dir="$THEMES_DIR/$theme_folder_name/$app_folder"
            local source_path="$theme_source_dir/$generic_file"
            local dest_path="$app_dir/$generic_file"
            local relative_source_path="../themes/$theme_folder_name/$app_folder/$generic_file"

            if [ ! -f "$source_path" ]; then
                echo "  [Aviso] Arquivo de tema não encontrado: $source_path"
                continue
            fi
            rm -f "$dest_path"
            ln -s "$relative_source_path" "$dest_path"
            echo "  [OK] Link criado para $app_folder: $generic_file"
        done
    done

    # Loop 2: Processar alvos "ROOT"
    echo "Aplicando links 'root'..."
    for dest_path_abs in "${!ROOT_TARGETS[@]}"; do
        local generic_file="${ROOT_TARGETS[$dest_path_abs]}"
        local source_path_abs="$THEMES_DIR/$theme_folder_name/$generic_file"

        if [ ! -f "$source_path_abs" ]; then
            echo "  [Aviso] Arquivo de tema 'root' não encontrado: $source_path_abs"
            continue
        fi
        rm -f "$dest_path_abs"
        ln -s "$source_path_abs" "$dest_path_abs"
        echo "  [OK] Link 'root' criado: $dest_path_abs"
    done
}

# Função principal de aplicação (agora chama as outras)
apply_theme() {
    local theme_folder_name=$1
    local theme_display_name=$2

    echo "Aplicando $theme_display_name..."

    # 1. Cria os links
    apply_theme_links "$theme_folder_name"
    
    # 2. Executa os comandos específicos (NOVO)
    run_theme_commands "$theme_folder_name" "$selected_display_name"

    send_notification "$theme_folder_name" "$theme_display_name"
}

# Função para recarregar serviços
reload_services() {
    echo "Recarregando serviços de forma eficiente..."
    
    # 1. RECARREGAMENTO QUENTE (Sem matar processos)
    # ---------------------------------------------------------
    killall -SIGUSR1 kitty >/dev/null 2>&1    # Recarrega o terminal
    killall -SIGUSR2 waybar >/dev/null 2>&1   # Recarrega config/css do Waybar
    swaync-client -rs >/dev/null 2>&1         # Recarrega o CSS do swaync
    swaync-client -R >/dev/null 2>&1          # Recarrega o config do swaync
    hyprctl reload >/dev/null 2>&1            # Recarrega o Hyprland
    eww r >/dev/null 2>&1                     # Recarrega o Eww

    # 2. REINICIALIZAÇÃO FORÇADA (Para o que não aceita sinal)
    # ---------------------------------------------------------
    # Lista de aplicativos que realmente precisam fechar e abrir
    APPS_PARA_REINICIAR=("hyprpaper")

    for app in "${APPS_PARA_REINICIAR[@]}"; do
        # Tenta matar o processo de forma silenciosa
        killall "$app" >/dev/null 2>&1
    done

    # Espera um instante para garantir que todos morreram
    sleep 0.2

    for app in "${APPS_PARA_REINICIAR[@]}"; do
        # Inicia em background e desanexa do terminal
        "$app" >/dev/null 2>&1 & disown
    done
    
    echo "Serviços recarregados."
}

# Função principal
main() {
    # Pega o primeiro argumento passado para o script (ex: o "1" em "ts 1")
    local choice_num=$1

    # Se a variável choice_num estiver vazia, mostra o menu interativo
    if [ -z "$choice_num" ]; then
        echo "Qual tema você gostaria de aplicar?"
        
        for i in "${!THEME_NAMES[@]}"; do
            echo "  $((i+1)). ${THEME_NAMES[$i]}"
        done

        read -p "Sua escolha (1-${#THEME_NAMES[@]}): " choice_num
    fi

    # Validação (funciona tanto para o menu quanto para o argumento direto)
    if ! [[ "$choice_num" =~ ^[0-9]+$ ]] || \
       (( choice_num < 1 )) || \
       (( choice_num > ${#THEME_NAMES[@]} )); then
        echo "Erro: Escolha inválida. Por favor, escolha um número de 1 a ${#THEME_NAMES[@]}."
        exit 1
    fi

    local selected_display_name="${THEME_NAMES[$((choice_num-1))]}"
    local selected_folder_name="${THEMES[$selected_display_name]}"

    echo "" # Linha em branco

    # Chama as funções principais
    apply_theme "$selected_folder_name" "$selected_display_name"
    reload_services
    
    echo "" # Linha em branco
    echo "Tema $selected_display_name aplicado com sucesso!"
}

# Passa todos os argumentos recebidos no terminal para a função main
main "$@"
