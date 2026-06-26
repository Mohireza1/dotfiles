#!/bin/bash

# Get the internal monitor name (assuming it starts with eDP)
monitor_name=$(hyprctl monitors -j | jq -r '.[] | select(.name | startswith("eDP")) | .name')
current_rate=$(hyprctl monitors -j | jq -r '.[] | select(.name | startswith("eDP")) | .refreshRate' | cut -d'.' -f1)

if [ -z "$monitor_name" ]; then
    notify-send "Error" "Could not detect internal monitor (eDP)"
    exit 1
fi

if [ "$current_rate" -eq 165 ]; then
    hyprctl keyword monitor "$monitor_name,2560x1440@60.00Hz,0x0,1"
    notify-send "Switched to 60 Hz mode"
else
    hyprctl keyword monitor "$monitor_name,2560x1440@165.00Hz,0x0,1"
    notify-send "Switched to 165 Hz mode"
fi
