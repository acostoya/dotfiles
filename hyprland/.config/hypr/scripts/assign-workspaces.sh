#!/bin/bash
# Dynamic workspace assignment based on monitor type
# Assigns workspace 1 to built-in monitor, workspaces 2-10 to external monitors (round-robin)

# Get monitor info
monitors=$(hyprctl monitors -j)

# Function to detect if a monitor is built-in
is_builtin() {
    local name="$1"
    # Common built-in monitor names
    if [[ "$name" =~ ^eDP|^LVDS|^DSI ]]; then
        return 0
    fi
    return 1
}

# Extract monitor names and sort them
builtin_monitor=""
external_monitors=()

while IFS= read -r line; do
    if [[ $line =~ \"name\":\"([^\"]+)\" ]]; then
        name="${BASH_REMATCH[1]}"
        if is_builtin "$name"; then
            builtin_monitor="$name"
        else
            external_monitors+=("$name")
        fi
    fi
done < <(echo "$monitors" | grep -o '"name":"[^"]*"')

# Assign workspace 1 to built-in monitor
if [ -n "$builtin_monitor" ]; then
    hyprctl keyword workspace "1, monitor:$builtin_monitor, default:true"
fi

# Assign workspaces 2-10 to external monitors (round-robin if multiple)
if [ ${#external_monitors[@]} -gt 0 ]; then
    external_count=${#external_monitors[@]}
    workspace=2
    
    while [ $workspace -le 10 ]; do
        # Calculate which external monitor to use (round-robin)
        monitor_index=$(( (workspace - 2) % external_count ))
        external_monitor="${external_monitors[$monitor_index]}"
        
        hyprctl keyword workspace "$workspace, monitor:$external_monitor, default:true"
        ((workspace++))
    done
else
    # No external monitors, assign all workspaces to built-in
    if [ -n "$builtin_monitor" ]; then
        for i in {2..10}; do
            hyprctl keyword workspace "$i, monitor:$builtin_monitor, default:true"
        done
    fi
fi
