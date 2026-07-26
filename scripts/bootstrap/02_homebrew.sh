#!/bin/bash

# =============================================================================
# HOMEBREW
# =============================================================================

set -e

source "$(dirname "$0")/../utils.sh"

print_box "[02] HOMEBREW"

if ! command -v brew &>/dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # Apple Silicon path
  if [[ $(uname -m) == "arm64" ]]; then
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zprofile"
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
  ok "Homebrew installed"
else
  ok "Homebrew already installed — updating..."
  brew update --quiet 2>/dev/null || warn "brew update skipped — already running"
fi
