#!/bin/bash
# Dynamically set ghostty background based on available wallpapers

CONFIG_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/ghostty/config"
ZRO_DIR="${HOME}/.config/zro-wallpapers/wallpapers"
FALLBACK="${HOME}/.config/backgrounds/background_blurred.png"

if [ -f "$ZRO_DIR/ZRO_Teams_4_blurred.jpg" ]; then
    BACKGROUND="$ZRO_DIR/ZRO_Teams_4_blurred.jpg"
else
    BACKGROUND="$FALLBACK"
fi

# Update config file
if grep -q "^background-image = " "$CONFIG_FILE"; then
    sed -i "s|^background-image = .*|background-image = $BACKGROUND|" "$CONFIG_FILE"
else
    sed -i "/^theme = /a background-image = $BACKGROUND" "$CONFIG_FILE"
fi
