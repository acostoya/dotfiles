#!/bin/bash

set -e

echo ">> Running init.sh script for Ubuntu 24! <<"

# Updating APT packages
echo "Updating APT packages..."
sudo apt-get update > /dev/null

# Upgrading APT packages
echo "Upgrading APT packages..."
sudo apt-get upgrade -y > /dev/null

# Installing packages.conf packages
cd $HOME/dotfiles
if [ -f "packages.conf" ]; then
  source packages.conf
  for package in ${packages[@]}; do
    echo "Installing ${package}..."
    sudo apt-get install ${package} -y > /dev/null
  done
fi

# Installing python venv package
PYTHON_VERSION=$(python3 -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}")')
VENV_PACKAGE="python${PYTHON_VERSION}-venv"
echo "Installing ${VENV_PACKAGE}..."
sudo apt-get install -y "$VENV_PACKAGE" > /dev/null

# Downloading nerd-font
echo "Installing nerdfont..."
cd $HOME/dotfiles
source init/nerdfont.sh > /dev/null

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
stow alacritty tmux nvim > /dev/null

# Addint tmux auto-start to .bashrc
echo "Configuring TMUX auto-start..."
source init/tmux.sh > /dev/null

echo "Installing uv python package manager..."
curl -LsSf https://astral.sh/uv/install.sh | sh > /dev/null

echo ">> init.sh script for Ubuntu 24 completed! Please restart your terminal. <<"
