#!/bin/bash

# =============================================================================
# LAZYGIT CONFIG
# =============================================================================

set -e

source "$(dirname "$0")/../utils.sh"

print_box "[08] LAZYGIT CONFIG"

LAZYGIT_CONFIG="$HOME/Library/Application Support/lazygit/config.yml"
STOW_DIR="$(cd "$(dirname "$0")/../.." && pwd)/stow"

if [[ -f "$LAZYGIT_CONFIG" && ! -L "$LAZYGIT_CONFIG" ]]; then
  warn "Lazygit config is a plain file (not managed by stow) — skipping"
else
  stow --dir="$STOW_DIR" --target="$HOME" -R lazygit
  ok "Lazygit config linked via stow"
fi
