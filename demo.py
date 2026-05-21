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

script_path = "/home/porpetenha/dotfiles/theme-switcher.sh"

def screenshot(nome, tema):
    time.sleep(0.5)
    subprocess.run(["grim", f"{tema}_{nome}.png"])

def abrir_app(comando, tempo_espera):
    subprocess.Popen(comando)
    time.sleep(tempo_espera)

def mover_foco(direcao):
    subprocess.run(["hyprctl", "dispatch", "movefocus", direcao])

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
    subprocess.Popen(["notify-send", "Hello", "<3"])

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
    mover_foco("l")
    abrir_app(["obsidian"], 3.0)
    mover_foco("r")
    subprocess.Popen(["kitty", "sh", "-c", "fastfetch; exec bash"])

    screenshot("overview", tema)
    
    time.sleep(tempo_pos)
    
    subprocess.run(["hyprctl", "dispatch", "closewindow", "class:code"])
    subprocess.run(["hyprctl", "dispatch", "closewindow", "class:kitty"])
    subprocess.run(["hyprctl", "dispatch", "closewindow", "class:obsidian"])
    subprocess.run(["killall", "-9", "thunar"])
    