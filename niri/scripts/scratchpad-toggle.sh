#!/bin/sh
# scratchpad-toggle.sh <workspace-name> [launch-command...]
#
# If already on <workspace-name>  → go back to previous workspace
# If NOT on <workspace-name>      → jump to it (app must already be running)
#
# Usage examples:
#   scratchpad-toggle.sh term
#   scratchpad-toggle.sh v2rayn

WORKSPACE="$1"
[ -z "$WORKSPACE" ] && exit 1

# Get the name of the currently focused workspace
CURRENT=$(niri msg --json workspaces 2>/dev/null | python3 -c "
import sys, json
try:
    ws = json.load(sys.stdin)
    focused = next((w for w in ws if w.get('is_focused')), None)
    print(focused.get('name') or '' if focused else '')
except Exception:
    print('')
" 2>/dev/null)

if [ "$CURRENT" = "$WORKSPACE" ]; then
    niri msg action focus-workspace-previous
else
    niri msg action focus-workspace "$WORKSPACE"
fi
