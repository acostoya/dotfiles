#!/bin/bash

# Get max CPU temperature with moving average to reduce noise
# Works across different Linux systems

CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/polybar"
TEMP_HISTORY_FILE="$CACHE_DIR/cputemp_history"
INTERVAL=1
HISTORY_SIZE=$((20 / INTERVAL))

# Get max CPU temperature across all cores
get_temp() {
    local max_temp=0
    
    # Method 1: coretemp hwmon sensors (CPU cores only, skip package temp)
    if [ -d /sys/class/hwmon ]; then
        for hwmon_dir in /sys/class/hwmon/hwmon*/; do
            if [ -f "$hwmon_dir/name" ] && grep -q "coretemp" "$hwmon_dir/name"; then
                # Read all core temps (skip temp1_input which is package id 0)
                for temp_file in "$hwmon_dir"/temp[2-9]_input; do
                    if [ -f "$temp_file" ]; then
                        temp=$(($(cat "$temp_file") / 1000))
                        [ "$temp" -gt "$max_temp" ] && max_temp=$temp
                    fi
                done
                [ "$max_temp" -gt 0 ] && echo "$max_temp" && return 0
            fi
        done
    fi
    
    # Method 2: sensors command (if available)
    if command -v sensors &> /dev/null; then
        sensors -A 2>/dev/null | grep -oP 'Core \d+:\s+\+\K[0-9.]+' | sort -n | tail -1 | xargs printf "%.0f"
        return 0
    fi
    
    echo "N/A"
}

# Create cache directory if needed
mkdir -p "$CACHE_DIR"

current_temp=$(get_temp)

# If we can't get temperature, output as-is
if [ "$current_temp" = "N/A" ]; then
    echo "$current_temp"
    exit 0
fi

# Add current temp to history and keep only last N readings
TEMP_HISTORY_NEW="${TEMP_HISTORY_FILE}.new.$$"
{
    [ -f "$TEMP_HISTORY_FILE" ] && cat "$TEMP_HISTORY_FILE"
    echo "$current_temp"
} | tail -n $HISTORY_SIZE > "$TEMP_HISTORY_NEW"

if [ -f "$TEMP_HISTORY_NEW" ]; then
    mv -f "$TEMP_HISTORY_NEW" "$TEMP_HISTORY_FILE" 2>/dev/null || cat "$TEMP_HISTORY_NEW" > "$TEMP_HISTORY_FILE"
fi

# Calculate moving average from history
average=$(awk '{sum+=$1; count++} END {printf "%.0f", sum/count}' "$TEMP_HISTORY_FILE" 2>/dev/null)

echo "$average"
