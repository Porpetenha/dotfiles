-- This is an example Hyprland Lua config file.
-- Refer to the wiki for more information.
-- https://wiki.hypr.land/Configuring/Start/

-- Please note not all available settings / options are set here.
-- For a full list, see the wiki

-- You can (and should!!) split this configuration into multiple files
-- Create your files separately and then require them like this:
-- require("myColors")


------------------
---- MONITORS ----
------------------

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
hl.monitor({
    output   = "HDMI-A-1",
    mode     = "1920x1080@74.97",
    position = "0x0",
    scale    = "1",
})


---------------------
---- MY PROGRAMS ----
---------------------

-- Set programs that you use
local terminal    = "kitty"
local fileManager = "thunar"
local menu        = "rofi -show drun"
local browser     = "firefox"


-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

-- Autostart necessary processes (like notifications daemons, status bars, etc.)
-- Or execute your favorite apps at launch like this:
--
hl.on("hyprland.start", function () 
  hl.exec_cmd("/usr/lib/polkit-kde-authentication-agent-1")
  --hl.exec_cmd("nm-applet")
  hl.exec_cmd("waybar & hyprpaper & eww daemon &")
  hl.exec_cmd("wl-paste --type text --watch cliphist store")
  hl.exec_cmd("wl-paste --type image --watch cliphist store")
  --hl.exec_cmd("gsettings set org.gnome.desktop.interface color-scheme "prefer-dark")
  hl.exec_cmd("dbus-update-activation-environment --all")
  hl.exec_cmd("gnome-keyring-daemon --start --components=secrets")
end)


-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")

hl.env("GDK_BACKEND", "wayland,x11,*")

hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
hl.env("QT_QPA_PLATFORM" , "wayland;xcb")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")

hl.env("XDG_MENU_PREFIX", "arch- ")

-----------------------
----- PERMISSIONS -----
-----------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Permissions/
-- Please note permission changes here require a Hyprland restart and are not applied on-the-fly
-- for security reasons

-- hl.config({
--   ecosystem = {
--     enforce_permissions = true,
--   },
-- })

-- hl.permission("/usr/(bin|local/bin)/grim", "screencopy", "allow")
-- hl.permission("/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", "screencopy", "allow")
-- hl.permission("/usr/(bin|local/bin)/hyprpm", "plugin", "allow")


-----------------------
---- LOOK AND FEEL ----
-----------------------

local look_and_fell = require("look-and-feel")
local look_and_fell = require("themes")
---------------
---- INPUT ----
---------------

hl.config({
    input = {
        kb_layout  = "us",
        kb_variant = "intl",
        kb_model   = "",
        kb_options = "",
        kb_rules   = "",

        follow_mouse = 1,

        sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.

        touchpad = {
            natural_scroll = false,
        },
    },
})

hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace"
})

-- Example per-device config
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Devices/ for more
hl.device({
    name        = "razer-razer-deathadder-essential",
    sensitivity = -0.7,
})

---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER" -- Sets "Windows" key as main modifier

-- Example binds, see https://wiki.hypr.land/Configuring/Basics/Binds/ for more
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(terminal))
local closeWindowBind = hl.bind(mainMod .. " + Q", hl.dsp.window.close())
-- closeWindowBind:set_enabled(false)
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser))

-- Widgets
hl.bind("ALT + F4", hl.dsp.exec_cmd("~/.config/rofi/scripts/powermenu.sh"))
hl.bind(mainMod .. " + O", hl.dsp.exec_cmd("~/.config/rofi/scripts/wallpaper.sh"))
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("~/.config/rofi/scripts/theme-switch-rofi.sh"))
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd("swaync-client -t -sw"))
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd("cliphist list | rofi -dmenu | cliphist decode | wl-copy"))

-- Tools
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd("killall -SIGUSR2 waybar"))
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd("hyprpicker -a"))
hl.bind(mainMod .. "+ SHIFT + R", hl.dsp.exec_cmd("hyprpicker -af rgb"))
hl.bind("Print", hl.dsp.exec_cmd("hyprshot -m region --clipboard-only --freeze"))
hl.bind("SHIFT + Print", hl.dsp.exec_cmd("hyprshot -m region -o ~/Imagens/screenshots"))
hl.bind(mainMod .. " + I", hl.dsp.exec_cmd("python ~/Documentos/demo.py"))

-- Windows
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))    -- dwindle only
hl.bind(mainMod .. " + F", hl.dsp.window.float({ action = "toggle" }))
--hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
--wwhl.bind(mainMod .. " + SPACE", hl.dsp.window.fullscreen({mode = "maximize", action = "toggle"}))
hl.bind(mainMod .. " + SHIFT + SPACE", hl.dsp.window.fullscreen({mode = "fullscreen", action = "toggle"}))

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key,             hl.dsp.focus({ workspace = i}))
    hl.bind(mainMod .. " + SHIFT + " .. key,     hl.dsp.window.move({ workspace = i }))
end

-- Example special workspace (scratchpad)
hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                  { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })


--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

-- Example window rules that are useful

local suppressMaximizeRule = hl.window_rule({
    -- Ignore maximize requests from all apps. You'll probably like this.
    name  = "suppress-maximize-events",
    match = { class = ".*" },

    suppress_event = "maximize",
})
-- suppressMaximizeRule:set_enabled(false)

hl.window_rule({
    -- Fix some dragging issues with XWayland
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true,
})

-- Layer rules also return a handle.
-- local overlayLayerRule = hl.layer_rule({
--     name  = "no-anim-overlay",
--     match = { namespace = "^my-overlay$" },
--     no_anim = true,
-- })
-- overlayLayerRule:set_enabled(false)

-- Hyprland-run windowrule
hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },

    move  = "20 monitor_h-120",
    float = true,
})

-- Pavucontrol (Comentado)
-- hl.window_rule({
--     name  = "pavucontrol",
--     match = { class = "org.pulseaudio.pavucontrol" },
-- 
--     float = true,
--     move  = {1288, 70},
--     size  = {610, 307},
-- })

-- Steam (Comentado)
-- hl.window_rule({
--     name  = "steam",
--     match = { class = "steam" },
-- 
--     float  = true,
--     center = true,
-- })

-- Diálogos do Sistema
hl.window_rule({
    name  = "dialog-renomear",
    match = { title = "^(Renomear.*)" },

    float        = true,
    center       = true,
    stay_focused = true,
})

hl.window_rule({
    name  = "dialog-quer-salvar",
    match = { title = "(.*)(quer salvar)(.*)" },

    float  = true,
    center = true,
})

hl.window_rule({
    name  = "dialog-todos-arquivos",
    match = { title = "Todos os arquivos" },

    float  = true,
    center = true,
})

hl.window_rule({
    name  = "dialog-salve-arquivo",
    match = { title = "Salve um arquivo" },

    float  = true,
    center = true,
})

hl.window_rule({
    name  = "dialog-salvar-arquivo",
    match = { title = "(Salvar Arquivo) (.*)" },

    float  = true,
    center = true,
})

hl.window_rule({
    name  = "dialog-novo-vazio",
    match = { title = "Novo arquivo vazio..." },

    stay_focused = true,
})

-- File Roller
hl.window_rule({
    name  = "file-roller-adicionar",
    match = { 
        class = "org.gnome.FileRoller",
        title = "Adicionar"
    },

    center       = true,
    stay_focused = true,
})

hl.window_rule({
    name  = "file-roller-extrair",
    match = { 
        class = "org.gnome.FileRoller",
        title = "Extrair" 
    },

    center       = true,
    stay_focused = true,
})

-- Godot Engine
hl.window_rule({
    name  = "godot-principal",
    match = { 
        initial_class = "^(Godot)$",
        initial_title = "^(Godot)$"
    },

    tile = true,
})

hl.window_rule({
    name  = "godot-debug",
    match = { 
        class         = "^(Godot)$",
        initial_class = "^(Godot)$",
        title         = "^((.*)(DEBUG))",
        initial_title = "^(.*)(DEBUG)(.*)$"
    },

    float = true,
})

-- Opacidade (YouTube)
hl.window_rule({
    name  = "youtube-opacity",
    match = { title = "(.*)(- YouTube)(.*)" },

    opacity = "1 override 1 override",
})

-- Minecraft
hl.window_rule({
    name  = "minecraft-rules",
    match = { class = "(Minecraft)(.*)" },

    tile    = true,
    opacity = "1 override 1 override",
})

-- Blur (Desativar em tudo exceto Kitty)
hl.window_rule({
    name  = "desativar-blur-geral",
    match = { class = "negative:kitty" },

    no_blur = true,
})

-- Outros Aplicativos
hl.window_rule({
    name  = "nwg-look-float",
    match = { class = "nwg-look" },

    float = true,
})

hl.window_rule({
    name  = "idleon-float",
    match = { title = "Legends Of Idleon" },

    float = true,
})

hl.window_rule({
    name  = "desktop-editors-float",
    match = { class = "DesktopEditors" },

    float = true,
})