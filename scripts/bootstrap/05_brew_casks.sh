#!/bin/bash

# =============================================================================
# BREW CASKS
# =============================================================================

set -e

source "$(dirname "$0")/../utils.sh"

print_box "[05] BREW CASKS"

CASKS=(
  visual-studio-code
 # rectangle
  ghostty
 # copilot-cli
 # google-chrome
  spotify
  telegram
  docker-desktop
)

for cask in "${CASKS[@]}"; do
  if brew list --cask "$cask" &>/dev/null; then
    ok "$cask already installed"
  else
    brew install --cask "$cask" --quiet && ok "$cask installed"
  fi
done
