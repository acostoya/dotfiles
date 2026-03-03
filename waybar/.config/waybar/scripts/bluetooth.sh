#!/bin/bash

# Get connected devices using interactive mode for reliability
devices=$(bluetoothctl << EOF
devices Connected
quit
EOF
)

# Filter out non-device lines and count
device_count=$(echo "$devices" | grep -c '^Device')

if [ "$device_count" -eq 0 ]; then
    echo "󰂯"
else
    if [ "$device_count" -gt 1 ]; then
        echo "󰂯 $device_count"
    else
        # Show single device name
        device_name=$(echo "$devices" | grep '^Device' | cut -d' ' -f3-)
        echo "󰂯 $device_name"
    fi
fi
