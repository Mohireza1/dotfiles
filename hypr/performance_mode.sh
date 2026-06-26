#!/usr/bin/env bash

# If "toggle" is passed, cycle the profile and notify
if [[ "$1" == "toggle" ]]; then
    OUT=$(rog-profile --next 2>/dev/null)
    # OUT looks like: "Profile was set to Performance"
    PROFILE=$(echo "$OUT" | awk '{print $NF}')
    notify-send -t 2000 -h string:x-canonical-private-synchronous:power_profile "Power Profile" "Switched to $PROFILE"
    
    # Signal waybar to update the custom module (assuming signal 8)
    pkill -RTMIN+8 waybar
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
