#!/bin/bash

# =============================================================================
# BREW CLI TOOLS
# =============================================================================

set -e

source "$(dirname "$0")/../utils.sh"

print_box "[04] BREW CLI TOOLS"

BREWS=(
  # git and GitHub
  gh              # GitHub CLI
  git-delta       # Better git diff viewer
  git-lfs         # Git large file support
  lazygit         # Terminal UI for git

  # dotfiles
  stow            # Symlink manager for dotfiles

  # shell navigation and terminal workflow
  zellij          # Terminal workspace manager
  fzf             # Fuzzy finder
  zoxide          # Smarter cd command

  # file listing and search
  bat             # Better cat with syntax highlighting
  eza             # Modern ls replacement
  fd              # Fast find replacement
  ripgrep         # Fast text search

  # docs and inspection
  tlrc            # Community tldr client
  htop            # Interactive process viewer
  tokei           # Count lines of code
  jq              # JSON processor

  # editors
  neovim          # Modern Vim-based editor

  # cloud and containers
  awscli          # AWS command line tools
  docker          # Container runtime CLI
  docker-compose  # Docker Compose CLI

  # databases
  libpq           # PostgreSQL CLI client
  mongosh         # MongoDB CLI client

  # language and package tooling
  uv              # Python package and project manager

  # misc dev tools
  rtk             # RTK CLI tools
)

for pkg in "${BREWS[@]}"; do
  if brew list "$pkg" &>/dev/null; then
    ok "$pkg already installed"
  else
    brew install "$pkg" && ok "$pkg installed"
  fi
done
