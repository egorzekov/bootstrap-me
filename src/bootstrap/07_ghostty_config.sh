#!/bin/bash

# =============================================================================
# GHOSTTY CONFIG
# =============================================================================

set -e

source "$(dirname "$0")/../utils.sh"

print_box "[07] GHOSTTY CONFIG"

GHOSTTY_CONFIG="$HOME/Library/Application Support/com.mitchellh.ghostty/config.ghostty"
STOW_DIR="$(cd "$(dirname "$0")/../.." && pwd)/stow"

if [[ -f "$GHOSTTY_CONFIG" && ! -L "$GHOSTTY_CONFIG" ]]; then
  warn "Ghostty config is a plain file (not managed by stow) — skipping"
else
  stow --dir="$STOW_DIR" --target="$HOME" -R ghostty
  ok "Ghostty config linked via stow"
fi
