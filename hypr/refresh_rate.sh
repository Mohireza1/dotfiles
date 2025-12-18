#!/bin/bash

# Get the current monitor refresh rate
current_rate=$(hyprctl monitors -j | jq -r '.[0].refreshRate' | cut -d'.' -f1)

if [ "$current_rate" -eq 165 ]; then
    hyprctl keyword monitor ",2560x1440@60.00Hz,auto,1"
    notify-send "Switched to 60 Hz mode"
else
    hyprctl keyword monitor ",2560x1440@165.00Hz,auto,1"
    notify-send "Switched to 165 Hz mode"
fi
