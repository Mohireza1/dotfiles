#!/bin/bash

CONFIG_FILE="$HOME/.config/niri/config.kdl"

# Check if current config has 165Hz
if grep -q "165.008" "$CONFIG_FILE"; then
    # Switch to 60Hz and disable VRR
    sed -i 's/165\.008/60.000/g' "$CONFIG_FILE"
    sed -i 's/.*variable-refresh-rate.*/    \/\/ variable-refresh-rate/g' "$CONFIG_FILE"
    niri msg action load-config-file
    notify-send -u normal "Display" "Switched to 60 Hz mode (VRR Off)"
elif grep -q "60.000" "$CONFIG_FILE"; then
    # Switch to 165Hz and enable VRR
    sed -i 's/60\.000/165.008/g' "$CONFIG_FILE"
    sed -i 's/.*variable-refresh-rate.*/    variable-refresh-rate/g' "$CONFIG_FILE"
    niri msg action load-config-file
    notify-send -u normal "Display" "Switched to 165 Hz mode (VRR On)"
else
    notify-send -u critical "Display Error" "Could not detect current refresh rate in Niri config"
    exit 1
fi
