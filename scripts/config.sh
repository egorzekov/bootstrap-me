#!/bin/bash
 
# =============================================================================
# CONFIGURATION — source this file or add to ~/.zshrc
# Usage: source ./config.sh
# =============================================================================

# [1] nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# [2] zoxide
eval "$(zoxide init zsh --no-cmd)"
