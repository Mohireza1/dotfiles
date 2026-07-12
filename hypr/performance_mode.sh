#!/usr/bin/env bash

# If "toggle" is passed, cycle the profile and notify
if [[ "$1" == "toggle" ]]; then
    CURRENT=$(rog-profile --get 2>/dev/null | awk '{print $NF}')
    
    if [[ "$CURRENT" == "Quiet" ]]; then
        NEXT="Balanced"
    elif [[ "$CURRENT" == "Balanced" ]]; then
        NEXT="Performance"
    else
        NEXT="Quiet"
    fi
    
    rog-profile --set "$NEXT" >/dev/null 2>&1
    notify-send -t 2000 -h string:x-canonical-private-synchronous:power_profile "Power Profile" "Switched to $NEXT"
    
    exit 0
fi

# Otherwise, just output JSON for Waybar
STATUS=$(rog-profile --get 2>/dev/null)
# STATUS looks like: "Current profile is Performance"
PROFILE=$(echo "$STATUS" | awk '{print $NF}')

if [[ "$PROFILE" == "Performance" ]]; then
    ICON="󰓅"
    CLASS="performance"
elif [[ "$PROFILE" == "Balanced" ]]; then
    ICON=""
    CLASS="balanced"
elif [[ "$PROFILE" == "Quiet" ]]; then
    ICON=""
    CLASS="quiet"
else
    ICON=""
    CLASS="default"
fi

echo "{\"text\": \"$ICON\", \"tooltip\": \"Power Profile: $PROFILE\", \"class\": \"$CLASS\"}"
