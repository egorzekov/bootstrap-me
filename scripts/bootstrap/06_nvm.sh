#!/bin/bash

# =============================================================================
# NVM — Node Version Manager (official installer)
# =============================================================================

set -e

source "$(dirname "$0")/../utils.sh"

print_box "[06] NVM"

NVM_VERSION="v0.40.3"

if [ -s "$HOME/.nvm/nvm.sh" ]; then
  ok "nvm already installed"
else
  log "Installing nvm $NVM_VERSION via official installer..."
  curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/$NVM_VERSION/install.sh" | bash
  ok "nvm $NVM_VERSION installed"
fi
