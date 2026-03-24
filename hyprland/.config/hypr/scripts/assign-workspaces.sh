#!/bin/bash
# Dynamic workspace assignment based on monitor type
# Assigns workspace 1 to built-in monitor, workspaces 2-10 to external monitors (round-robin)

# Wait a moment for monitors to be fully detected
sleep 1

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

while IFS= read -r name; do
    if is_builtin "$name"; then
        builtin_monitor="$name"
    else
        external_monitors+=("$name")
    fi
done < <(echo "$monitors" | jq -r '.[].name')

# First, clear any existing workspace assignments to avoid conflicts
for i in {1..10}; do
    hyprctl keyword workspace "$i, monitor:0xFFFFFFFF, default:false" 2>/dev/null || true
done

# Wait for the changes to take effect
sleep 0.5

# Assign workspace 1 to built-in monitor
if [ -n "$builtin_monitor" ]; then
    hyprctl keyword workspace "1, monitor:$builtin_monitor, default:true"
    echo "Assigned workspace 1 to built-in monitor: $builtin_monitor"
fi

  # Assign workspaces 2-10 to external monitors using round-robin
   if [ ${#external_monitors[@]} -gt 0 ]; then
       # Calculate how many workspaces per monitor
       total_workspaces=9  # workspaces 2-10
       num_external=${#external_monitors[@]}
       
       # Distribute workspaces across external monitors
       workspace_counter=2
       while [ $workspace_counter -le 10 ]; do
           for external_monitor in "${external_monitors[@]}"; do
               if [ $workspace_counter -gt 10 ]; then
                   break
               fi
               hyprctl keyword workspace "$workspace_counter, monitor:$external_monitor, default:true"
               echo "Assigned workspace $workspace_counter to external monitor: $external_monitor"
               ((workspace_counter++))
           done
       done
        
        # Move existing workspaces to correct monitors
        hyprctl dispatch moveworkspacetomonitor "1 $builtin_monitor"
        for external_monitor in "${external_monitors[@]}"; do
            for i in {2..10}; do
                hyprctl dispatch moveworkspacetomonitor "$i $external_monitor"
            done
        done
   else
       # No external monitors, assign all workspaces to built-in
       if [ -n "$builtin_monitor" ]; then
           for i in {2..10}; do
               hyprctl keyword workspace "$i, monitor:$builtin_monitor, default:true"
               echo "Assigned workspace $i to built-in monitor: $builtin_monitor (no external monitors)"
           done
       fi
   fi

# Wait for all assignments to complete
sleep 0.5

# Verify assignments
echo "Current workspace assignments:"
hyprctl workspaces -j | jq -r '.[] | "Workspace \(.id) on monitor \(.monitor)"'