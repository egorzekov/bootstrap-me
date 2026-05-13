#!/bin/bash

# =============================================================================
# BUN — JavaScript runtime & toolkit (official installer)
# =============================================================================

set -e

source "$(dirname "$0")/../utils.sh"

print_box "[08] BUN"

if command -v bun &>/dev/null || [ -x "$HOME/.bun/bin/bun" ]; then
  ok "bun already installed"
else
  log "Installing bun via official installer..."

  # Hide ~/.zshrc so the installer can't append PATH/completion lines to our
  # stow-managed dotfile (those live in dotfiles/zsh/.zshrc instead).
  ZSHRC_BACKUP=""
  if [ -e "$HOME/.zshrc" ] || [ -L "$HOME/.zshrc" ]; then
    ZSHRC_BACKUP="$(mktemp -u "$HOME/.zshrc.pre-bun.XXXXXX")"
    mv "$HOME/.zshrc" "$ZSHRC_BACKUP"
  fi

  curl -fsSL https://bun.sh/install | bash

  if [ -n "$ZSHRC_BACKUP" ]; then
    rm -f "$HOME/.zshrc"
    mv "$ZSHRC_BACKUP" "$HOME/.zshrc"
  fi

  ok "bun installed"
fi
