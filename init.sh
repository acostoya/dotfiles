#!/bin/bash

set -e

echo
cat << "EOF"
 _____                                                                               _____ 
( ___ )                                                                             ( ___ )
 |   |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|   | 
 |   |      ____                    _                  _       _ _         _         |   | 
 |   |     |  _ \ _   _ _ __  _ __ (_)_ __   __ _     (_)_ __ (_) |_   ___| |__      |   | 
 |   |     | |_) | | | | '_ \| '_ \| | '_ \ / _` |    | | '_ \| | __| / __| '_ \     |   | 
 |   |     |  _ <| |_| | | | | | | | | | | | (_| |    | | | | | | |_ _\__ \ | | |    |   | 
 |   |     |_| \_\\__,_|_| |_|_| |_|_|_| |_|\__, |    |_|_| |_|_|\__(_)___/_| |_|    |   | 
 |   |                                      |___/                                    |   | 
 |___|~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|___| 
(_____)                                                                             (_____)

EOF

# Updating pakages
echo "<<<<<<< UPDATING APT PACKAGES >>>>>>>"
sudo apt-get update 
echo

# Upgrading pakages
echo "<<<<<<< UPGRADING APT PACKAGES >>>>>>>"
sudo apt-get upgrade -y
echo

# Installing packages
echo "<<<<<<< INSTALLING PACKAGES >>>>>>>"
cd $HOME/dotfiles
if [ ! -f "packages.conf" ]; then
  echo "Error: packages.conf not found!"
  exit 1
fi
source packages.conf
for package in ${packages[@]}; do
  echo "INSTALLING PACKAGE: ${package}"
  sudo apt-get install ${package} -y
  echo
done

PYTHON_VERSION=$(python3 -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}")')
VENV_PACKAGE="python${PYTHON_VERSION}-venv"
echo "INSTALLING PACKAGE: ${VENV_PACKAGE}"
sudo apt-get install -y "$VENV_PACKAGE"
echo

echo "INSTALLING PACKAGE: alacritty"
if apt-cache showpkg alacritty | grep -qv "purely virtual"; then
  sudo apt-get install alacritty -y
  sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator /usr/bin/alacritty 50
else
  echo "Alacritty is NOT available in the repositories! Proceeding with manual installation..."
  source init/alacritty.sh
  sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator /usr/local/bin/alacritty 50
  echo "Alacritty installed!"
fi
echo

# Downloading nerd-font
echo "<<<<<<< INSTALLING NERD-FONT >>>>>>>"
cd $HOME/dotfiles
source init/nerdfont.sh
echo "Nerd-font installed!"
echo

# Installing node.js
echo "<<<<<<< INSTALLING NODE.JS >>>>>>>"
curl -so- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
\. "$HOME/.nvm/nvm.sh"
nvm install 22
echo

# Installing tmux plugin manager
echo "<<<<<<< INSTALLING TPM >>>>>>>"
if [ -d "$HOME/.tmux/plugins/tpm" ]; then
  echo "Repository '$HOME/.tmux/plugins/tpm' already exists. Skipping clone."
else
  git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm
  echo "TPM installed!"
fi
echo

# Installing neovim
echo "<<<<<<< INSTALLING NEOVIM >>>>>>>"
source init/neovim.sh
echo "Neovim installed!"
echo

# Stowing dotfiles
echo "<<<<<<< STOWING DOTFILES >>>>>>>"
cd $HOME/dotfiles
stow alacritty tmux nvim
echo "Dotfiles stowed!"
echo

# Addint tmux auto-start to .bashrc
echo "<<<<<<< ADDING TMUX AUTO-START COMMAND TO .bashrc >>>>>>>"
source init/tmux.sh
echo "TMUX auto-start configured!"
echo

echo "<<<<<<< INSTALLING UV BY ASTRAL >>>>>>>"
curl -LsSf https://astral.sh/uv/install.sh | sh
echo

echo "<<<<<<< EVERYTHING RUN SUCCESSFULLY >>>>>>>"
