#!/bin/sh

if [ -n "$HYPRLAND_INSTANCE_SIGNATURE" ]; then
    # Hyprland
    CURRENT_WS=$(hyprctl activeworkspace -j | jq -r '.id')
    CURRENT_MON=$(hyprctl activeworkspace -j | jq -r '.monitor')
    MONITORS=$(hyprctl monitors -j | jq -r '.[].name')

    NEXT_MON=""
    FOUND=false
    for MON in $MONITORS; do
        if [ "$FOUND" = "true" ]; then
            NEXT_MON=$MON
            break
        fi
        if [ "$MON" = "$CURRENT_MON" ]; then
            FOUND=true
        fi
    done

    if [ -z "$NEXT_MON" ]; then
        NEXT_MON=$(echo "$MONITORS" | head -n 1)
    fi

    hyprctl dispatch moveworkspacetomonitor "$CURRENT_WS" "$NEXT_MON"
    hyprctl dispatch focusmonitor "$NEXT_MON"

else
    # i3wm
    CURRENT_WS=$(i3-msg -t get_workspaces | jq -r '.[] | select(.focused).name')
    CURRENT_OUTPUT=$(i3-msg -t get_workspaces | jq -r '.[] | select(.focused).output')
    I3_OUTPUTS=$(i3-msg -t get_outputs | jq -r '.[] | select(.active) | .name')

    if [ -z "$I3_OUTPUTS" ]; then exit 1; fi

    NEXT_OUTPUT=""
    FOUND=false
    for OUTPUT in $I3_OUTPUTS; do
        if [ "$FOUND" = "true" ]; then
            NEXT_OUTPUT=$OUTPUT
            break
        fi
        if [ "$OUTPUT" = "$CURRENT_OUTPUT" ]; then
            FOUND=true
        fi
    done

    if [ -z "$NEXT_OUTPUT" ]; then
        NEXT_OUTPUT=$(echo "$I3_OUTPUTS" | head -n 1)
    fi

    i3-msg "move workspace to output $NEXT_OUTPUT"
fi
