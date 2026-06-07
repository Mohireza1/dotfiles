#!/bin/bash

# Seekbar script for Waybar
# Uses playerctl to get position and length and formats a progress bar.
# Outputs JSON for Waybar.

BAR_WIDTH=15

while true; do
    status=$(playerctl status 2>/dev/null)
    if [ -z "$status" ]; then
        echo "{\"text\": \"\", \"class\": \"stopped\"}"
    else
        # Get position and length in microseconds
        data=$(playerctl metadata --format "{{position}} {{mpris:length}}" 2>/dev/null)
        pos=$(echo $data | cut -d' ' -f1)
        len=$(echo $data | cut -d' ' -f2)

        if [ -n "$len" ] && [ "$len" -gt 0 ]; then
            # Calculate how many segments are "filled"
            # We use 0 to BAR_WIDTH
            if [ "$len" -gt 0 ]; then
                perc=$(( pos * BAR_WIDTH / len ))
            else
                perc=0
            fi
            
            # Clamp perc
            [ "$perc" -gt "$BAR_WIDTH" ] && perc=$BAR_WIDTH
            
            bar=""
            for ((i=0; i<=BAR_WIDTH; i++)); do
                if [ $i -lt $perc ]; then
                    bar="${bar}▬"
                elif [ $i -eq $perc ]; then
                    bar="${bar}●"
                else
                    bar="${bar}─"
                fi
            done
            
            pos_fmt=$(playerctl metadata --format "{{duration(position)}}" 2>/dev/null)
            len_fmt=$(playerctl metadata --format "{{duration(mpris:length)}}" 2>/dev/null)
            text="$pos_fmt $bar $len_fmt"
        else
            pos_fmt=$(playerctl metadata --format "{{duration(position)}}" 2>/dev/null)
            text="$pos_fmt [LIVE]"
        fi
        
        # Output as JSON
        echo "{\"text\": \"$text\", \"class\": \"$status\", \"tooltip\": \"$status: $text\"}"
    fi
    sleep 1
done
