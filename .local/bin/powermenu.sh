#!/usr/bin/env bash

function powermenu {
    options="Cancel\nShutdown\nReboot\nSuspend\nLock\nLogout"
    selected=$(echo -e $options | dmenu -i -p "Select: ") 
    if [[ $selected = "Shutdown" ]]; then
        systemctl poweroff -i
    elif [[ $selected = "Reboot" ]]; then
        systemctl reboot
    elif [[ $selected = "Suspend" ]]; then
       systemctl suspend 
    elif [[ $selected = "Lock" ]]; then
        dm-tool lock
    elif [[ $selected = "Logout" ]]; then
        i3-msg exit
    elif [[ $selected = "Cancel" ]]; then
        return
    fi
}

powermenu
