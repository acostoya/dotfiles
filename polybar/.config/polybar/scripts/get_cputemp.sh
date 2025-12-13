#!/bin/bash

# Get max CPU temperature across all cores
# Works across different Linux systems

# Try multiple methods to find temperature
get_temp() {
    # Method 1: hwmon sensors (most reliable)
    if [ -d /sys/class/hwmon ]; then
        for hwmon in /sys/class/hwmon/hwmon*/temp*_input; do
            if [ -f "$hwmon" ]; then
                temp=$(($(cat "$hwmon") / 1000))
                echo "$temp"
            fi
        done | sort -n | tail -1
        return 0
    fi
    
    # Method 2: thermal zones
    if [ -d /sys/class/thermal ]; then
        for zone in /sys/class/thermal/thermal_zone*/temp; do
            if [ -f "$zone" ]; then
                temp=$(($(cat "$zone") / 1000))
                echo "$temp"
            fi
        done | sort -n | tail -1
        return 0
    fi
    
    # Method 3: sensors command (if available)
    if command -v sensors &> /dev/null; then
        sensors -A 2>/dev/null | grep -oP 'Core \d+:\s+\+\K[0-9.]+' | sort -n | tail -1 | xargs printf "%.0f"
        return 0
    fi
    
    echo "N/A"
}

result=$(get_temp)
echo "$result"
