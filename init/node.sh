#!/bin/bash

curl -s https://api.github.com/repos/nvm-sh/nvm/releases/latest \
  | grep "tag_name" \
  | awk -F '"' '{print $4}' \
  | xargs -I {} curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/{}/install.sh | bash

\. "$HOME/.nvm/nvm.sh"

nvm install --lts
