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

# Downloading nerd-font
echo "<<<<<<< INSTALLING NERD-FONT >>>>>>>"
if [ -d "$HOME/Downloads/JetBrainsMono" ]; then
  rm -r $HOME/Downloads/JetBrainsMono
fi
mkdir -p $HOME/Downloads/JetBrainsMono
curl -sLO https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.tar.xz --output-dir $HOME/Downloads/JetBrainsMono
tar xf $HOME/Downloads/JetBrainsMono/JetBrainsMono.tar.xz -C $HOME/Downloads/JetBrainsMono
rm $HOME/Downloads/JetBrainsMono/JetBrainsMono.tar.xz
mkdir -p $HOME/.local/share/fonts
mv $HOME/Downloads/JetBrainsMono/* ~/.local/share/fonts
rm -r $HOME/Downloads/JetBrainsMono
fc-cache -f
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
curl -sLO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
rm nvim-linux-x86_64.tar.gz
if ! grep -q 'nvim' $HOME/.bashrc; then
  cat << 'EOF' >> $HOME/.bashrc

# Adding neovim location to PATH
export PATH="$PATH:/opt/nvim-linux-x86_64/bin"
EOF
fi
echo "Neovim installed!"
echo

# Stowing dotfiles
echo "<<<<<<< STOWING DOTFILES >>>>>>>"
cd $HOME/dotfiles
stow alacritty tmux nvim
echo "Dotfiles stowed!"
echo

# Setting alacritty as default terminal
echo "<<<<<<< SETTING ALACRITTY AS DEFAULT TERMINAL >>>>>>>"
sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator /usr/bin/alacritty 50
echo "Alacritty configured as default terminal!"
echo

# Addint tmux auto-start to .bashrc
echo "<<<<<<< ADDING TMUX AUTO-START COMMAND TO .bashrc >>>>>>>"
if ! grep -q 'exec tmux' $HOME/.bashrc; then
  cat << 'EOF' >> $HOME/.bashrc

# Auto-start tmux
if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
  exec tmux
fi
EOF
fi
echo "TMUX auto-start configured!"
echo

echo "<<<<<<< INSTALLING UV BY ASTRAL >>>>>>>"
curl -LsSf https://astral.sh/uv/install.sh | sh
echo

echo "<<<<<<< EVERYTHING RUN SUCCESSFULLY >>>>>>>"
