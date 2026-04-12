#!/bin/bash
 
# =============================================================================
# CONFIGURATION — source this file or add to ~/.zshrc
# Usage: source ./config.sh
# =============================================================================

# [1] nvm
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

# [2] zoxide
eval "$(zoxide init zsh --no-cmd)"
