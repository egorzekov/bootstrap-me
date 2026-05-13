#!/bin/bash

# =============================================================================
# DOTFILES — Write ~/.gitconfig.local and stow-link all dotfile packages
# =============================================================================

set -e

source "$(dirname "$0")/../utils.sh"

print_box "[09] DOTFILES"

DOTFILES_DIR="$(cd "$(dirname "$0")/../.." && pwd)/dotfiles"
PROFILE="$HOME/.bootstrap_profile"

# ---------------------------------------------------------------------------
# 1. Write ~/.gitconfig.local from bootstrap profile (name + email)
# ---------------------------------------------------------------------------
GITCONFIG_LOCAL="$HOME/.gitconfig.local"

if [[ ! -f "$PROFILE" ]]; then
  warn "~/.bootstrap_profile not found — run 00_ssh.sh first, then re-run"
  exit 1
else
  source "$PROFILE"
  cat > "$GITCONFIG_LOCAL" <<EOF
[user]
	name  = $GIT_NAME
	email = $GIT_EMAIL
EOF
  ok "~/.gitconfig.local written (name + email)"
fi

# ---------------------------------------------------------------------------
# 2. Stow-link dotfile packages
# ---------------------------------------------------------------------------
stow_package() {
  local pkg="$1"
  local check_path="$2"

  if [[ -f "$check_path" && ! -L "$check_path" ]]; then
    warn "$pkg: $check_path is a plain file (not stow-managed) — skipping"
  else
    stow --no-folding --dir="$DOTFILES_DIR" --target="$HOME" -R "$pkg"
    ok "$pkg linked via stow"
  fi
}

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

stow_package git      "$HOME/.gitconfig"
stow_package ghostty  "$HOME/Library/Application Support/com.mitchellh.ghostty/config.ghostty"
stow_package lazygit  "$HOME/Library/Application Support/lazygit/config.yml"
stow_package zsh      "$HOME/.zshrc"
