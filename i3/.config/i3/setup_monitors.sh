#!/bin/bash
# Dynamic monitor setup script - works with any number of monitors

# Wait for hardware to stabilize after login
sleep 3

# Try to configure monitors with fallback options
if xrandr --query | grep -q "eDP-1"; then
    # Laptop/hybrid setup with eDP-1
    if xrandr --query | grep -q "HDMI-1-0 connected"; then
        # Dual monitor: laptop + HDMI
        xrandr --output eDP-1 --primary --mode 1920x1080 --pos 0x0 --output HDMI-1-0 --mode 1920x1080 --pos 1920x0 --right-of eDP-1
        sleep 1
    else
        # Laptop screen only
        xrandr --output eDP-1 --primary --auto
    fi
else
    # Desktop setup - find first connected output and set as primary
    PRIMARY=$(xrandr --query | grep " connected" | head -1 | awk '{print $1}')
    if [ -n "$PRIMARY" ]; then
        xrandr --output "$PRIMARY" --primary --auto
    fi
fi
