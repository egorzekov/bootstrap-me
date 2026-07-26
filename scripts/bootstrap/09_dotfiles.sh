#!/bin/bash

# =============================================================================
# DOTFILES — Stow-link all dotfile packages
# =============================================================================

set -e

source "$(dirname "$0")/../utils.sh"

print_box "[09] DOTFILES"

DOTFILES_DIR="$(cd "$(dirname "$0")/../.." && pwd)/dotfiles"

# ---------------------------------------------------------------------------
# Stow-link dotfile packages
# ---------------------------------------------------------------------------
# ~/.zshrc may be written by the Oh My Zsh installer; back it up so stow can manage it
if [[ -f "$HOME/.zshrc" && ! -L "$HOME/.zshrc" ]]; then
  mv "$HOME/.zshrc" "$HOME/.zshrc.bak"
  warn ".zshrc was a plain file — backed up to ~/.zshrc.bak"
fi

# ~/.gitconfig may be a plain file on a fresh Mac; back it up so stow can manage it
if [[ -f "$HOME/.gitconfig" && ! -L "$HOME/.gitconfig" ]]; then
  mv "$HOME/.gitconfig" "$HOME/.gitconfig.bak"
  warn ".gitconfig was a plain file — backed up to ~/.gitconfig.bak"
fi

for package_dir in "$DOTFILES_DIR"/*/; do
  package="$(basename "$package_dir")"
  stow --no-folding --dir="$DOTFILES_DIR" --target="$HOME" -R "$package"
  ok "$package linked via stow"
done
