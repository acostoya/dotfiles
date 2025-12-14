#!/bin/bash
# Switch to workspace and ensure correct monitor focus
# Usage: switch_workspace.sh <workspace_number>

WORKSPACE=$1

if [ -z "$WORKSPACE" ]; then
    echo "Usage: switch_workspace.sh <workspace_number>"
    exit 1
fi

# For workspaces 2-10, focus on the external monitor if available
if [ "$WORKSPACE" -ge 2 ] && [ "$WORKSPACE" -le 10 ]; then
    # Get all connected outputs and try to focus on non-primary monitor
    OUTPUTS=$(xrandr --query | grep " connected" | awk '{print $1}')
    COUNT=0
    for OUTPUT in $OUTPUTS; do
        COUNT=$((COUNT + 1))
        if [ $COUNT -gt 1 ]; then
            # Found secondary monitor, focus on it
            i3-msg "focus output $OUTPUT"
            break
        fi
    done
    # Small delay to ensure monitor is focused before workspace switch
    sleep 0.02
fi

# Switch to workspace
i3-msg "workspace number $WORKSPACE"




