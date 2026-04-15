#!/bin/bash

# =============================================================================
# STOW UNLINK — Remove all stow-managed dotfile symlinks from $HOME
# Usage: bash scripts/stow_unlink.sh
# =============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

source "$SCRIPT_DIR/utils.sh"

print_box "STOW UNLINK"

DOTFILES_DIR="$(cd "$SCRIPT_DIR/../dotfiles" && pwd)"

log "Unlinking all stow packages from $DOTFILES_DIR"

for pkg_dir in "$DOTFILES_DIR"/*/; do
  pkg="$(basename "$pkg_dir")"
  if stow --dir="$DOTFILES_DIR" --target="$HOME" -D "$pkg" 2>/dev/null; then
    ok "$pkg unlinked"
  else
    warn "$pkg — nothing to unlink (skipping)"
  fi
done

ok "Done"
