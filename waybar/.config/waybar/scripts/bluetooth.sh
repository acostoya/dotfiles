#!/bin/bash

# Check if Bluetooth is powered on
if ! bluetoothctl show | grep -q 'Powered: yes'; then
    echo "󰂲"
    exit 0
fi

# Get connected devices
devices=$(bluetoothctl devices Connected)

if [ -z "$devices" ]; then
    echo "󰂯"
else
    # Count connected devices
    device_count=$(echo "$devices" | wc -l)
    
    if [ "$device_count" -gt 1 ]; then
        echo "󰂯 $device_count"
    else
        # Show single device name
        device_name=$(echo "$devices" | cut -d' ' -f3-)
        echo "󰂯 $device_name"
    fi
fi
