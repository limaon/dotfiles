#!/usr/bin/env bash

function powermenu {
    options="Cancel\nShutdown\nReboot\nSuspend\nLock"
    selected=$(echo -e $options | dmenu) 
    if [[ $selected = "Shutdown" ]]; then
        poweroff
    elif [[ $selected = "Reboot" ]]; then
        reboot
    elif [[ $selected = "Suspend" ]]; then
       systemctl suspend 
    elif [[ $selected = "Lock" ]]; then
        betterlockscreen --lock dimblur
    elif [[ $selected = "Cancel" ]]; then
        return
    fi
}
