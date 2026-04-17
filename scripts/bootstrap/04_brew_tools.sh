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
  stow

  # terminal
  zellij
  fzf
  zoxide
  bat
  eza
  ripgrep
  fd
  tlrc
  htop

  # dev
  jq
  nvim
  docker
)

for pkg in "${BREWS[@]}"; do
  if brew list "$pkg" &>/dev/null; then
    ok "$pkg already installed"
  else
    brew install "$pkg" && ok "$pkg installed"
  fi
done
