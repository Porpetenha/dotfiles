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
    ["hypr"]="look-and-feel.conf hyprlock.conf themes.conf"
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

#
# (NOVO) ADICIONE SEUS COMANDOS ESPECÍFICOS AQUI
#
# Esta função é chamada após a criação dos links.
#
run_theme_commands() {
    local theme_folder_name=$1
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
            sed -i 's/"workbench.colorTheme":.*/"workbench.colorTheme": "Tokyo Night Storm",/' "$HOME/.config/Code/User/settings.json"

            echo "  > Aplicando wallpaper do $selected_display_name..."
            local img_tokyo="$HOME/dotfiles/themes/tokyo-night-storm/tokyo-kanagawa.jpg"
            sed -i "s|^preload = .*|preload = $img_tokyo|" "$hypr_conf"
            sed -i "s|path = .*|path = $img_tokyo|" "$hypr_conf"

            echo "  > Executando 'sed' para o Obsidian ($selected_display_name)..."
            find "$HOME" -type f -path "*/.obsidian/appearance.json" 2>/dev/null | while read -r obsidian_config; do
                sed -i 's/\("cssTheme": "\)[^"]*/\1Tokyo Night/' "$obsidian_config"
                echo "    - Atualizado: $obsidian_config"
            done 

            echo " > Alterando o tema do sistema..."
            gsettings set org.gnome.desktop.interface gtk-theme "Tokyonight-Dark-Storm"
            gsettings set org.gnome.desktop.interface cursor-theme "Moga-Neon-Blue"
            gsettings set org.gnome.desktop.interface icon-theme "Papirus-Dark"
            nohup papirus-folders -C red --theme Papirus-Dark >/dev/null 2>&1 &
            hyprctl setcursor Moga-Neon-Blue 20
            ;;
        
        "gruvbox-dark")
            echo "  > Executando 'sed' para VS Code ($selected_display_name)..."
            sed -i 's/"workbench.colorTheme":.*/"workbench.colorTheme": "Gruvbox Dark Medium",/' "$HOME/.config/Code/User/settings.json"
            
            echo "  > Aplicando wallpaper do $selected_display_name..."
            local img_gruv="$HOME/dotfiles/themes/gruvbox-dark/gruvbox-astro.jpg"
            sed -i "s|^preload = .*|preload = $img_gruv|" "$hypr_conf"
            sed -i "s|path = .*|path = $img_gruv|" "$hypr_conf"

            echo "  > Executando 'sed' para o Obsidian ($selected_display_name)..."
            find "$HOME" -type f -path "*/.obsidian/appearance.json" 2>/dev/null | while read -r obsidian_config; do
                sed -i 's/\("cssTheme": "\)[^"]*/\1Obsidian gruvbox/' "$obsidian_config"
                echo "    - Atualizado: $obsidian_config"
            done
            
            echo " > Alterando o tema do sistema..."
            gsettings set org.gnome.desktop.interface gtk-theme "Gruvbox-Dark-Medium"
            gsettings set org.gnome.desktop.interface cursor-theme "Future-cursors"
            gsettings set org.gnome.desktop.interface icon-theme "Papirus-Dark"
            nohup papirus-folders -C brown --theme Papirus-Dark >/dev/null 2>&1 &
            hyprctl setcursor Future-cursors 24

            echo "  > Aplicando tema ($selected_display_name) ao Firefox..."
            local ff_css="$HOME/.mozilla/firefox/dneohqj6.default-release/chrome/userContent.css"
            local ff_bg="#282828" 
            
            if [ -f "$ff_css" ]; then
                sed -i "s/--bg: #[0-9A-Fa-f]\{6\};/--bg: $ff_bg;/g" "$ff_css"
                echo "    - Atualizado: $ff_css"
            else
                echo "    - [!] Erro: Arquivo userContent.css não encontrado."
            fi
            ;;

        "kanagawa")
            echo "  > Executando 'sed' para VS Code ($selected_display_name)..."
            sed -i 's/"workbench.colorTheme":.*/"workbench.colorTheme": "Kanagawa",/' "$HOME/.config/Code/User/settings.json"
            
            echo "  > Aplicando wallpaper do $selected_display_name..."
            local img_gruv="$HOME/dotfiles/themes/kanagawa/kanagawa.jpg"
            sed -i "s|^preload = .*|preload = $img_gruv|" "$hypr_conf"
            sed -i "s|path = .*|path = $img_gruv|" "$hypr_conf"

            echo "  > Executando 'sed' para o Obsidian ($selected_display_name)..."
            find "$HOME" -type f -path "*/.obsidian/appearance.json" 2>/dev/null | while read -r obsidian_config; do
                sed -i 's/\("cssTheme": "\)[^"]*/\1Kanagawa/' "$obsidian_config"
                echo "    - Atualizado: $obsidian_config"
            done
            
            echo " > Alterando o tema do sistema..."
            gsettings set org.gnome.desktop.interface gtk-theme "Kanagawa"
            gsettings set org.gnome.desktop.interface cursor-theme "Moga-Sandy"
            gsettings set org.gnome.desktop.interface icon-theme "Papirus-Dark"
            nohup papirus-folders -C paleorange --theme Papirus-Dark >/dev/null 2>&1 &
            hyprctl setcursor Moga-Sandy 20

            echo "  > Aplicando tema ($selected_display_name) ao Firefox..."
            local ff_css="$HOME/.mozilla/firefox/dneohqj6.default-release/chrome/userContent.css"
            local ff_bg="#1C1C22" 
            
            if [ -f "$ff_css" ]; then
                sed -i "s/--bg: #[0-9A-Fa-f]\{6\};/--bg: $ff_bg;/g" "$ff_css"
                echo "    - Atualizado: $ff_css"
            else
                echo "    - [!] Erro: Arquivo userContent.css não encontrado."
            fi
            ;;
        *)

            echo "  [Info] Nenhum comando específico para este tema."
            ;;
    esac
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
    run_theme_commands "$theme_folder_name"
}

# Função para recarregar serviços
reload_services() {
    echo "Recarregando serviços..."
    
    (killall -SIGUSR1 kitty &) >/dev/null 2>&1
    (hyprctl reload &) >/dev/null 2>&1
    (eww r &) >/dev/null 2>&1

    # --- EXEMPLOS PARA ADICIONAR DEPOIS ---
    
    # 1. Mata o waybar. O '|| true' garante que o script
    #    não pare se o waybar não estiver rodando.
    (killall waybar || true) &>/dev/null
    (killall hyprpaper || true) &>/dev/null
    (killall swaync || true) &>/dev/null
    # 2. Espera um instante para o processo morrer
    sleep 0.2
    
    # 3. Inicia o waybar em background, totalmente desanexado.
    #    'nohup' impede que ele morra com o terminal.
    #    '>/dev/null 2>&1' descarta toda a saída (logs).
    #    '&' coloca em background.
    (nohup waybar >/dev/null 2>&1 &)
    (nohup hyprpaper >/dev/null 2>&1 &)
    (nohup swaync >/dev/null 2>&1 &)
    
    echo "Serviços recarregados."
}

# Função principal (menu)
main() {
    echo "Qual tema você gostaria de aplicar?"
    
    for i in "${!THEME_NAMES[@]}"; do
        echo "  $((i+1)). ${THEME_NAMES[$i]}"
    done

    read -p "Sua escolha (1-${#THEME_NAMES[@]}): " choice_num

    if ! [[ "$choice_num" =~ ^[0-9]+$ ]] || \
       (( choice_num < 1 )) || \
       (( choice_num > ${#THEME_NAMES[@]} )); then
        echo "Erro: Escolha inválida."
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

# Executa a função principal
main

