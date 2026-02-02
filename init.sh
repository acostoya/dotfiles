#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo ">> Running init.sh script [Arch Linux version] <<"
cd $HOME/dotfiles

# Installing packages.conf packages
if [ -f "packages.conf" ]; then
  source packages.conf
  echo "Installing all packages..."
  sudo pacman -Sy ${packages[@]} --noconfirm
  echo "✓ All packages installed successfully."
fi

# Stowing dotfiles
echo "Stowing dotfiles..."
stow hyprland waybar ghostty starship nvim zellij backgrounds
echo "✓ Dotfiles stowed successfully."

# Creating symlinks for application files
echo "Creating symlinks for application files..."
mkdir -p "$HOME/.local/share/applications"
ln -sf "$HOME/dotfiles/applications/freeview.desktop" "$HOME/.local/share/applications/freeview.desktop"
echo "✓ Application files symlinked successfully."

# Configuring starship
echo "Initializing starship in bashrc..."
if ! grep -q "eval \"\$(starship init bash)\"" ~/.bashrc; then
  echo 'eval "$(starship init bash)"' >> ~/.bashrc
fi
echo "✓ Starship initialized in bashrc."

# Enabling gdm
echo "Enabling gdm service..."
sudo systemctl enable gdm
echo "✓ gdm service enabled successfully."

# Setting up NVIDIA drivers
echo "Do you want to set up NVIDIA drivers? (y/n)"
read -r answer
if [[ $answer == "y" || $answer == "Y" ]]; then
  bash $HOME/dotfiles/nvidia-setup.sh
  echo "✓ NVIDIA drivers set up successfully."
else
  echo "NVIDIA driver setup skipped."
fi

# Final message and prompt for reboot
echo ">> init.sh script run successfully! Do you want to reboot now? (y/n) <<"
read -r answer
if [[ $answer == "y" || $answer == "Y" ]]; then
  echo "Rebooting system..."
  sudo reboot
else
  echo "Reboot canceled. Please reboot manually later."
fi
