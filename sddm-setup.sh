#!/bin/bash

set -e

THEME_NAME="${1:-catppuccin-mocha-lavender}"
THEME_URL="https://github.com/catppuccin/sddm/releases/download/v1.1.2/${THEME_NAME}-sddm.zip"
THEMES_DIR="/usr/share/sddm/themes"
SDDM_CONF="/etc/sddm.conf"

install_theme() {
  echo "Installing $THEME_NAME SDDM theme..."
  local temp_dir=$(mktemp -d)
  trap "rm -rf $temp_dir" EXIT
  
  curl -sL "$THEME_URL" -o "$temp_dir/theme.zip"
  unzip -q -d "$temp_dir" "$temp_dir/theme.zip"
  sudo mv -v "$temp_dir/$THEME_NAME" "$THEMES_DIR/"
  echo "✓ SDDM theme installed successfully."
}

configure_theme() {
  echo "Configuring SDDM theme..."
  if [ -f "$SDDM_CONF" ]; then
    sudo sed -i "s/^Current=.*/Current=$THEME_NAME/" "$SDDM_CONF"
  else
    printf "[Theme]\nCurrent=%s\n" "$THEME_NAME" | sudo tee "$SDDM_CONF" > /dev/null
  fi
  echo "✓ SDDM theme configured successfully."
}

install_theme
configure_theme
