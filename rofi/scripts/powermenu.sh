#!/usr/bin/env bash

lock="󰈽 Lock"
logout="󰍃 Logout"
suspend="󰒲 Suspend"
reboot="󰜉 Reboot"
shutdown="󰐥 Shutdown"

options="$lock\n$logout\n$suspend\n$reboot\n$shutdown"

chosen=$(echo -e "$options" | rofi -dmenu -i -p "Power" -theme-str 'window {width: 20%;}')

case "$chosen" in
    "$lock")
        i3lock -c 1e1e2e
        ;;
    "$logout")
        i3-msg exit
        ;;
    "$suspend")
        systemctl suspend
        ;;
    "$reboot")
        systemctl reboot
        ;;
    "$shutdown")
        systemctl poweroff
        ;;
esac
