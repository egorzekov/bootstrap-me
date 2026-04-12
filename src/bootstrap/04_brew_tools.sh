#!/bin/bash

# =============================================================================
# BREW CLI TOOLS
# =============================================================================

set -e

source "$(dirname "$0")/../utils.sh"

print_box "[04] BREW CLI TOOLS"

BREWS=(
  # git
  gh
  git-delta
  lazygit

  # terminal
  fzf
  zoxide
  tmux

  # file & search
  bat
  eza
  ripgrep
  fd

  # dev
  jq
  nvim
  nvm
  rustup
  docker
)

for pkg in "${BREWS[@]}"; do
  if brew list "$pkg" &>/dev/null; then
    ok "$pkg already installed"
  else
    brew install "$pkg" && ok "$pkg installed"
  fi
done
