#!/usr/bin/env bash
#
# performance_mode.sh — Waybar module + toggle for ASUS power profiles
#
#   Usage:  performance_mode.sh          → JSON for Waybar
#           performance_mode.sh toggle   → cycle to next profile & notify
#           performance_mode.sh notify   → just read current profile & notify
#                                          (use with XF86Launch4 since rog-daemon
#                                           already handles the hardware key)

set -euo pipefail

get_profile() {
    rog-profile --get 2>/dev/null | awk '{print $NF}'
}

icon_for() {
    case "$1" in
        Performance) echo "󰓅" ;;
        Balanced)    echo "󰾅" ;;
        Quiet)       echo "󰌪" ;;
        *)           echo "" ;;
    esac
}

class_for() {
    case "$1" in
        Performance) echo "performance" ;;
        Balanced)    echo "balanced"    ;;
        Quiet)       echo "quiet"       ;;
        *)           echo "unknown"     ;;
    esac
}

# Map rog-profile names → D-Bus names used by noctalia/tuned-ppd
dbus_name() {
    case "$1" in
        quiet)       echo "power-saver"  ;;
        balanced)    echo "balanced"     ;;
        performance) echo "performance"  ;;
        *)           echo "$1"           ;;
    esac
}

# --- Toggle mode: cycle profile via noctalia (emits D-Bus signal) ----------
if [[ "${1:-}" == "toggle" ]]; then
    current=$(get_profile)
    case "$current" in
        Quiet)       next="balanced"    ;;
        Balanced)    next="performance" ;;
        *)           next="quiet"       ;;
    esac
    noctalia msg power-set "$(dbus_name "$next")" >/dev/null 2>&1
    sleep 0.1
    profile=$(get_profile)
    # notify-send -t 2000 \
    #     -h string:x-canonical-private-synchronous:power_profile \
    #     "$(icon_for "$profile")  Power Profile" "$profile"
    pkill -RTMIN+8 waybar || true
    exit 0
fi

# --- Notify mode: rog-daemon already switched, re-sync via D-Bus ----------
if [[ "${1:-}" == "notify" ]]; then
    sleep 0.2
    profile=$(get_profile)
    # Re-set through D-Bus so noctalia picks up the change
    noctalia msg power-set "$(dbus_name "$(echo "$profile" | tr '[:upper:]' '[:lower:]')")" >/dev/null 2>&1
    # notify-send -t 2000 \
    #     -h string:x-canonical-private-synchronous:power_profile \
    #     "$(icon_for "$profile")  Power Profile" "$profile"
    pkill -RTMIN+8 waybar || true
    exit 0
fi

# --- Waybar JSON output ----------------------------------------------------
profile=$(get_profile)
icon=$(icon_for "$profile")
class=$(class_for "$profile")

printf '{"text": "%s", "tooltip": "Power Profile: %s", "class": "%s"}\n' \
    "$icon" "$profile" "$class"
