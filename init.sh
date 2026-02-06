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

# Configuring FreeView
echo "Setting up FreeView wrapper function..."
if ! grep -q "^freeview()" ~/.bashrc; then
  cat >> ~/.bashrc << 'EOF'

# FreeView wrapper function
freeview() {
  export QT_QPA_PLATFORM=xcb
  export QT_QPA_PLATFORM_PLUGIN_PATH=/usr/lib/qt/plugins
  export FREESURFER_HOME=/opt/freesurfer
  source $FREESURFER_HOME/SetUpFreeSurfer.sh
  command freeview "$@"
}
EOF
fi
echo "✓ FreeView wrapper function added to bashrc."

# Configuring Docker
echo "Configuring Docker post-installation steps..."
sudo groupadd docker 2>/dev/null || true
sudo usermod -aG docker $USER
sudo systemctl enable docker.service
sudo systemctl enable containerd.service
if [ -d "$HOME/.docker" ]; then
  sudo chown "$USER":"$USER" "$HOME/.docker" -R
  sudo chmod g+rwx "$HOME/.docker" -R
fi
echo "✓ Docker configured successfully."
echo "  Note: Run 'newgrp docker' or restart your session to apply group changes."

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
