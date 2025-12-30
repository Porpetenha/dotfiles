#!/bin/bash

theme="$HOME/.config/rofi/scripts/powermenu.rasi"

# CMDs
uptime="`uptime -p | sed -e 's/up //g'`"
host=`uname -n`

lock=" Lock"
logout="󰍃 Logout"
poweroff="⏻ Poweroff"
reboot=" Reboot"
sleep=" Suspend"

# Rofi CMD
rofi_cmd() {
  rofi -dmenu \
    -p "$host" \
    -mesg "Uptime: $uptime" \
    -theme ${theme}
}

selected_option=$(echo "$poweroff
$lock
$reboot
$sleep
$logout" | rofi_cmd)

if [ "$selected_option" == "$lock" ]
then
  # AQUI: Espera o Rofi fechar antes de travar
  sleep 0.5; hyprlock
elif [ "$selected_option" == "$logout" ]
then
  hyprctl dispatch exit
elif [ "$selected_option" == "$poweroff" ]
then
  systemctl poweroff
elif [ "$selected_option" == "$reboot" ]
then
  systemctl reboot
elif [ "$selected_option" == "$sleep" ]
then
  # AQUI TAMBÉM: Espera o Rofi fechar -> trava -> espera travar -> suspende
  sleep 0.5; hyprlock & sleep 1 && systemctl suspend
else
  echo "No match"
fi