#!/bin/bash

if ! grep -q 'exec tmux' $HOME/.bashrc; then
  cat << 'EOF' >> $HOME/.bashrc

# Auto-start tmux
if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
  exec tmux
fi
EOF
fi
