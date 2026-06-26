#!/bin/sh

before=$(hyprctl clients -j | jq -r '.[] | select(.class == "com.mitchellh.ghostty") | .address')
hyprctl dispatch exec "ghostty -e agy" >/dev/null 2>&1

addr=""
i=0
while [ "$i" -lt 30 ]; do
    addr=$(hyprctl clients -j | jq -r --arg before "$before" '
        (.[] | select(.class == "com.mitchellh.ghostty") | .address) as $addr
        | select(("\n" + $before + "\n") | contains("\n" + $addr + "\n") | not)
        | $addr
    ' | tail -n 1)
    [ -n "$addr" ] && break
    sleep 0.05
    i=$((i + 1))
done

[ -z "$addr" ] && exit 1

hyprctl dispatch focuswindow "address:$addr" >/dev/null 2>&1
hyprctl dispatch setfloating "address:$addr" >/dev/null 2>&1
hyprctl dispatch resizewindowpixel exact 50% 50%,"address:$addr" >/dev/null 2>&1 || hyprctl dispatch resizeactive exact 50% 50% >/dev/null 2>&1
hyprctl dispatch centerwindow >/dev/null 2>&1
