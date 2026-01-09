#!/bin/bash

set -e

echo ">> Running init.sh script [Arch Linux version] <<"

# Installing packages.conf packages
cd $HOME/dotfiles
if [ -f "packages.conf" ]; then
  source packages.conf
  echo "Installing all packages..."
  sudo pacman -Sy ${packages[@]}
  echo "✓ All packages installed successfully."
fi

# Stowing dotfiles
echo "Stowing dotfiles..."
cd $HOME/dotfiles
stow hyprland waybar ghostty nvim zellij backgrounds
echo "✓ Dotfiles stowed successfully."


echo ">> init.sh script run successfully! <<"
