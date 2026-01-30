#!/usr/bin/bash
tmp_dir="/tmp/worm/spotify"
tmp_cover_path=$tmp_dir/cover.png
placeholder="$HOME/.config/eww/assets/note.png"  # Ajuste o caminho/nome do seu asset

if [ ! -d $tmp_dir ]; then
    mkdir -p $tmp_dir
fi

# Verifica se o Spotify está rodando e tem música
if playerctl -p spotify status 2>/dev/null | grep -q "Playing\|Paused"; then
    artlink="$(playerctl metadata -p spotify mpris:artUrl 2>/dev/null | sed -e 's/open.spotify.com/i.scdn.co/g')"
    if [ -n "$artlink" ]; then
        curl -s "$artlink" --output $tmp_cover_path
    else
        cp "$placeholder" $tmp_cover_path
    fi
else
    # Nada tocando, usa o placeholder
    cp "$placeholder" $tmp_cover_path
fi