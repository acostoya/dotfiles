#!/bin/bash

set -e

echo ">> Running init.sh script [Arch Linux version] <<"

# Installing packages.conf packages
cd $HOME/dotfiles
if [ -f "packages.conf" ]; then
  source packages.conf
  for package in ${packages[@]}; do
    echo "Installing ${package}..."
    sudo pacman -Sy ${package} > /dev/null
    echo "✓ ${package} installed successfully."
  done
fi

# Installing tmux plugin manager
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
  echo "Installing tmux plugin manager..."
  git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm > /dev/null
fi

# Stowing dotfiles
echo "Stowing dotfiles..."
cd $HOME/dotfiles
stow hyprland waybar ghostty nvim zellij backgrounds desktop


echo ">> init.sh script run successfully! <<"
