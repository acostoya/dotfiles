#!/bin/bash

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
