#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo ">> Running init.sh script [Arch Linux version] <<"

# Installing packages.conf packages
cd $HOME/dotfiles
if [ -f "packages.conf" ]; then
  source packages.conf
  echo "Installing all packages..."
  sudo pacman -Sy ${packages[@]} --noconfirm
  echo "✓ All packages installed successfully."
fi

# Stowing dotfiles
echo "Stowing dotfiles..."
cd $HOME/dotfiles
stow hyprland waybar ghostty starship nvim zellij backgrounds
echo "✓ Dotfiles stowed successfully."

# Configuring starship
echo "Initializing starship in bashrc..."
if ! grep -q "eval \"\$(starship init bash)\"" ~/.bashrc; then
  echo 'eval "$(starship init bash)"' >> ~/.bashrc
fi
echo "✓ Starship initialized in bashrc."

# Setting up SDDM theme
bash $HOME/dotfiles/sddm-setup.sh catppuccin-mocha-lavender

# Enabling sddm
echo "Enabling sddm service..."
sudo systemctl enable sddm
echo "✓ sddm service enabled successfully."

# Final message and prompt for reboot
echo ">> init.sh script run successfully! Do you want to reboot now? (y/n) <<"
read -r answer
if [[ $answer == "y" || $answer == "Y" ]]; then
  echo "Rebooting system..."
  sudo reboot
else
  echo "Reboot canceled. Please reboot manually later."
fi
