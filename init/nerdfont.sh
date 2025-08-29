#!/bin/bash

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
