#!/bin/bash
# Auto-scale monitors based on resolution
# Applies 2x scaling to any 3840x2160 monitor

hyprctl monitors -j | jq -c '.[]' | while read -r monitor; do
    name=$(echo "$monitor" | jq -r '.name')
    width=$(echo "$monitor" | jq -r '.width')
    height=$(echo "$monitor" | jq -r '.height')

    if [[ "$width" -eq 3840 && "$height" -eq 2160 ]]; then
        hyprctl keyword monitor "$name,3840x2160@60,auto,2"
        echo "Applied 2x scaling to $name ($width x $height)"
    fi
done

# Wait for Hyprland to finish reacting to monitor reconfiguration
sleep 5
