#!/bin/bash

# =============================================================================
# BREW CASKS
# =============================================================================

set -e

source "$(dirname "$0")/../utils.sh"

print_box "[05] BREW CASKS"

CASKS=(
  # editors
  cursor
  zed
  ghostty

  # tools
  rectangle
  docker-desktop

  # communication and media
  telegram
  spotify

  # fonts
  font-lilex
  font-lilex-nerd-font
  font-jetbrains-mono-nerd-font
)

for cask in "${CASKS[@]}"; do
  if brew list --cask "$cask" &>/dev/null; then
    ok "$cask already installed"
  else
    brew install --cask "$cask" --quiet && ok "$cask installed"
  fi
done
