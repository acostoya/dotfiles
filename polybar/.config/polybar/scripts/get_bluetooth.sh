#!/bin/bash

# Get bluetooth status and connected device info/count
# Works across multiple Linux systems

if ! command -v bluetoothctl &> /dev/null; then
    echo "N/A"
    exit 0
fi

powered=$(bluetoothctl show | grep "Powered:" | awk '{print $2}')

if [ "$powered" != "yes" ]; then
    echo "off"
    exit 0
fi

# Count connected devices and get first one's name
count=0
device_name=""
for device in $(bluetoothctl paired-devices | awk '{print $2}'); do
    connected=$(bluetoothctl info "$device" | grep "Connected:" | awk '{print $2}')
    if [ "$connected" = "yes" ]; then
        count=$((count + 1))
        if [ $count -eq 1 ]; then
            device_name=$(bluetoothctl info "$device" | grep "Name:" | cut -d' ' -f2-)
        fi
    fi
done

if [ $count -eq 0 ]; then
    echo "on"
elif [ $count -eq 1 ]; then
    echo "$device_name"
else
    echo "$count"
fi
