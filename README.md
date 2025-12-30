# 🌌 My Dotfiles | Hyprland + Wayland Configs

Bem-vindo ao meu repositório de dotfiles! Este setup foi construído para oferecer uma experiência visual minimalista, moderna e altamente produtiva, utilizando o Hyprland sobre o protocolo Wayland.

## 🎨 Temas Dinâmicos

O grande destaque deste sistema é a sua versatilidade. Através do script `theme-switcher.sh`, podes alternar globalmente entre diferentes estéticas que modificam o terminal, a barra e as janelas:

- **Catppuccin Mocha** 🌿: Tons pastel suaves para uma experiência relaxante.
- **Gruvbox Dark** 🪵: O equilíbrio perfeito entre o retro e o conforto visual.
- **Tokyo Night Storm** ⚡: Estética vibrante inspirada nas noites tecnológicas de Tóquio.

## 🛠️ Componentes do Sistema

| Componente        | Ferramenta                     |
|-------------------|--------------------------------|
| Window Manager    | Hyprland                       |
| Barra de Status   | Waybar (Personalizada por tema)|
| Terminal          | Kitty                          |
| Lançador de Apps  | Rofi-Wayland                   |
| Notificações      | SwayNC / Dunst                 |
| Widgets           | Eww (Volume, Brilho, Clima, Uptime) |
| Shell Prompt      | Starship                       |
| Gestão de Energia | Hypridle & Hyprlock            |

## 🚀 Instalação

Siga os passos abaixo para replicar este ambiente no seu sistema:

### 1. Clonar o Repositório

```bash
git clone https://github.com/seu-usuario/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

### 2. Executar o Script de Instalação

O repositório contém um script que automatiza a criação de links simbólicos (symlinks) e a organização das pastas de configuração:

```bash
chmod +x install_dotfiles.sh
./install_dotfiles.sh
```

### 3. Alternar entre Temas

Para trocar o visual do sistema a qualquer momento, basta rodar o alternador:

```bash
chmod +x theme-switcher.sh
./theme-switcher.sh
```

## ⌨️ Atalhos Principais (Keybinds)

Baseado no ficheiro `hyprland.conf`, aqui estão os comandos essenciais:

- `SUPER + Q`: Abrir o Terminal (Kitty)
- `SUPER + C`: Fechar a Janela Ativa
- `SUPER + R`: Abrir o Menu de Aplicações (Rofi)
- `SUPER + M`: Encerrar a sessão do Hyprland
- `SUPER + V`: Abrir o Gestor de Clipboard
- `SUPER + L`: Bloquear o Ecrã (Hyprlock)

## 📂 Estrutura do Repositório

- `hypr/`: Lógica principal do WM, animações e regras de janelas.
- `waybar/`: Estilos CSS e definições JSON adaptadas para cada tema.
- `eww/`: Dashboard e lógica de scripts para os widgets de sistema.
- `rofi/`: Temas e scripts para o menu de apps e menu de energia.
- `themes/`: Ficheiros de configuração específicos (Starship, Kitty, etc.) para cada esquema de cores.

## 📸 Screenshots

> Adicione aqui capturas de ecrã dos seus temas!

```
screenshots/
├── catppuccin-mocha.png
├── gruvbox-dark.png
└── tokyo-night-storm.png
```

## ⭐ Créditos

Criado com dedicação por **[Seu Nome/Username]**. Se este repositório te ajudou ou te deu ideias para o teu próprio setup, não te esqueças de deixar uma estrela! 🌟

---

**Arch Linux** | **Hyprland** | **Wayland** | **Rice**