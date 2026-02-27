#!/bin/sh

# Get the item name to determine which display this is for
ITEM_NAME="$NAME"
FOCUSED_WORKSPACE=$(aerospace list-workspaces --focused)

if [[ "$ITEM_NAME" == "front_app_external" ]]; then
    # For external monitor (workspaces 4-6)
    if [[ "$FOCUSED_WORKSPACE" -ge 4 && "$FOCUSED_WORKSPACE" -le 6 ]]; then
        # If focused workspace is on external monitor, show the focused app
        FRONT_APP=$(aerospace list-windows --focused --format "%{app-name}")
        if [[ -z "$FRONT_APP" ]]; then
            FRONT_APP="Desktop"
        fi
    else
        # If focused workspace is NOT on external monitor, show the most recent app from the current external workspace
        # Get the visible workspace on external monitor
        EXTERNAL_WORKSPACE=$(aerospace list-workspaces --monitor 2 --visible)
        if [[ -n "$EXTERNAL_WORKSPACE" ]]; then
            FRONT_APP=$(aerospace list-windows --workspace "$EXTERNAL_WORKSPACE" --format "%{app-name}" | head -1)
        fi
        if [[ -z "$FRONT_APP" ]]; then
            FRONT_APP="Desktop"
        fi
    fi
else
    # For main monitor (workspaces 1-3)
    if [[ "$FOCUSED_WORKSPACE" -ge 1 && "$FOCUSED_WORKSPACE" -le 3 ]]; then
        # If focused workspace is on main monitor, show the focused app
        FRONT_APP=$(aerospace list-windows --focused --format "%{app-name}")
        if [[ -z "$FRONT_APP" ]]; then
            FRONT_APP="Desktop"
        fi
    else
        # If focused workspace is NOT on main monitor, show the most recent app from the current main workspace
        # Get the visible workspace on main monitor
        MAIN_WORKSPACE=$(aerospace list-workspaces --monitor 1 --visible)
        if [[ -n "$MAIN_WORKSPACE" ]]; then
            FRONT_APP=$(aerospace list-windows --workspace "$MAIN_WORKSPACE" --format "%{app-name}" | head -1)
        fi
        if [[ -z "$FRONT_APP" ]]; then
            FRONT_APP="Desktop"
        fi
    fi
fi

sketchybar --set "$NAME" label="$FRONT_APP"
