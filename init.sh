#!/bin/bash

set -e

echo ">> Running init.sh script! [Ubuntu 22 version] <<"

# Updating APT packages
echo "Updating APT packages..."
sudo apt-get update > /dev/null

# Upgrading APT packages
echo "Upgrading APT packages..."
sudo apt-get upgrade -y > /dev/null

# Upgrading SNAP packages
sudo snap refresh

# Installing apt_packages.conf packages
cd $HOME/dotfiles
if [ -f "apt_packages.conf" ]; then
  source apt_packages.conf
  for apt_package in ${apt_packages[@]}; do
    echo "Installing ${apt_package}..."
    sudo apt-get install ${apt_package} -y > /dev/null
  done
fi

# Installing snap_packages.conf packages
cd $HOME/dotfiles
if [ -f "snap_packages.conf" ]; then
  source snap_packages.conf
  for snap_package in ${snap_packages[@]}; do
    echo "Installing ${snap_package}..."
    sudo snap install ${snap_package} > /dev/null
  done
fi

# Installing python venv package
PYTHON_VERSION=$(python3 -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}")')
VENV_PACKAGE="python${PYTHON_VERSION}-venv"
echo "Installing ${VENV_PACKAGE}..."
sudo apt-get install -y "$VENV_PACKAGE" > /dev/null

# Setting up Ghostty as default terminal emulator
sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator /snap/ghostty/current/bin/ghostty 50

# Downloading nerd-font
echo "Installing nerdfont..."
cd $HOME/dotfiles
# Commenting it out to check if it works with ghostty config
# source init/nerdfont.sh > /dev/null

# Installing node.js
echo "Installing node.js..."
source init/node.sh > /dev/null

# Installing tmux plugin manager
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
  echo "Installing tmux plugin manager..."
  git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm > /dev/null
fi

# Installing neovim
echo "Installing neovim..."
source init/neovim.sh > /dev/null

# Stowing dotfiles
echo "Stowing dotfiles..."
cd $HOME/dotfiles
stow ghostty tmux nvim backgrounds i3 picom polybar > /dev/null

# Addint tmux auto-start to .bashrc
echo "Configuring TMUX auto-start..."
source init/tmux.sh > /dev/null

echo "Installing uv python package manager..."
curl -LsSf https://astral.sh/uv/install.sh | sh > /dev/null

echo ">> init.sh script run successfull - please restart your terminal! <<"
