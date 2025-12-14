#!/bin/bash
# Dynamic monitor setup script - works with any number of monitors

# Wait for hardware to stabilize after login
sleep 3

# Disable all disconnected outputs first
xrandr --query | grep " disconnected" | awk '{print $1}' | while read -r output; do
    xrandr --output "$output" --off
done

# Get all connected outputs
OUTPUTS=$(xrandr --query | grep " connected" | awk '{print $1}')
OUTPUT_ARRAY=($OUTPUTS)

if [ ${#OUTPUT_ARRAY[@]} -ge 2 ]; then
    # Dual monitor setup: extend displays
    xrandr --output "${OUTPUT_ARRAY[0]}" --primary --auto --output "${OUTPUT_ARRAY[1]}" --auto --right-of "${OUTPUT_ARRAY[0]}"
    
    # Generate i3 config with dynamic workspace assignments
    SECONDARY="${OUTPUT_ARRAY[1]}"
    PRIMARY="${OUTPUT_ARRAY[0]}"
    
    # Create workspace assignment commands in dotfiles
    {
        echo "# Auto-generated workspace assignments"
        echo "workspace 1 output $PRIMARY"
        for i in {2..10}; do
            echo "workspace $i output $SECONDARY $PRIMARY"
        done
    } > ~/dotfiles/i3/.config/i3/workspace_assignments.conf
    
    # Reload i3 to apply new workspace assignments
    i3-msg reload
elif [ ${#OUTPUT_ARRAY[@]} -eq 1 ]; then
    # Single monitor - assign all workspaces to it
    xrandr --output "${OUTPUT_ARRAY[0]}" --primary --auto
    
    # Create workspace assignment for single monitor in dotfiles
    {
        echo "# Auto-generated workspace assignments"
        for i in {1..10}; do
            echo "workspace $i output ${OUTPUT_ARRAY[0]}"
        done
    } > ~/dotfiles/i3/.config/i3/workspace_assignments.conf
    
    # Reload i3 to apply new workspace assignments
    i3-msg reload
fi
