import subprocess
import time

tempo_pre = 1
tempo_pos = 3

temas = ["tokyo_night", "gruvbox", "kanagawa"]
temas_id = {
    "tokyo_night": 1,
    "gruvbox": 2,
    "kanagawa": 3,
}

icon_path = {
    1: "/home/porpetenha/dotfiles/themes/tokyo-night-storm/icon.svg",
    2: "/home/porpetenha/dotfiles/themes/gruvbox-dark/icon.svg",
    3: "/home/porpetenha/dotfiles/themes/kanagawa/icon.svg"
}

script_path = "/home/porpetenha/dotfiles/theme-switcher.sh"

def screenshot(nome, tema):
    time.sleep(0.5)
    subprocess.run(["grim", f"/home/porpetenha/Imagens/rice/{tema}_{nome}.png"])

def abrir_app(comando, tempo_espera):
    subprocess.Popen(comando)
    time.sleep(tempo_espera)

def mover_foco(direcao):
    subprocess.run(["hyprctl", "dispatch", f'hl.dsp.focus({{ direction = "{direcao}" }})'])

for tema in temas:
    id_atual = temas_id[tema]
    subprocess.run([script_path, str(id_atual)])
    time.sleep(4)
#----------------------------
    screenshot("demo", tema)

    time.sleep(tempo_pre)

    subprocess.Popen(["rofi", "-show", "drun"])
    subprocess.Popen(["eww", "o", "menu"])
    subprocess.Popen(["eww", "o", "calendar"])

    screenshot("eww_rofi", tema)

    time.sleep(tempo_pos)

    subprocess.run(["eww", "close-all"])
    subprocess.run(["killall", "rofi"])

    #----------------------------
    time.sleep(tempo_pre)

    subprocess.Popen("~/.config/rofi/scripts/wallpaper.sh", shell=True)
    
    nome_tema = tema.replace("_", " ").title()

    subprocess.Popen([
        "notify-send",
        "-i", icon_path[id_atual],
        f"Tema {nome_tema}",
        "Hello <3"
    ])

    screenshot("wallpaper_notify", tema)

    time.sleep(tempo_pos)

    subprocess.run(["killall", "rofi"])

    #----------------------------
    time.sleep(tempo_pre)
 
    subprocess.Popen("~/.config/rofi/scripts/powermenu.sh", shell=True)
    subprocess.Popen(["swaync-client", "-t", "-sw"])

    screenshot("powermenu_swaync", tema)

    time.sleep(tempo_pos)

    subprocess.Popen(["swaync-client", "-t", "-sw"])
    subprocess.run(["killall", "rofi"])

    #----------------------------
    gtk_themes = {
        "tokyo_night": "Tokyonight-Dark-Storm",
        "gruvbox": "Gruvbox-Dark-Medium",
        "kanagawa": "Kanagawa"
    }

    time.sleep(tempo_pre)
    
    tema_gtk_atual = gtk_themes[tema]
    
    abrir_app(["env", f"GTK_THEME={tema_gtk_atual}", "thunar"], 1.5)
    abrir_app(["code", "dotfiles"], 3.0) 
    mover_foco("left")
    abrir_app(["obsidian"], 3.0)
    mover_foco("right")
    subprocess.Popen(["kitty", "sh", "-c", "fastfetch; exec bash"])

    screenshot("overview", tema)
    
    time.sleep(tempo_pos)
    
    subprocess.run(["hyprctl", "dispatch", 'hl.dsp.window.close({ window = "class:code" })'])
    subprocess.run(["hyprctl", "dispatch", 'hl.dsp.window.close({ window = "class:kitty" })'])
    subprocess.run(["hyprctl", "dispatch", 'hl.dsp.window.close({ window = "class:obsidian" })'])
    subprocess.run(["killall", "-9", "thunar"])
    