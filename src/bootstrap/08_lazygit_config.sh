#!/bin/bash

# =============================================================================
# LAZYGIT CONFIG
# =============================================================================

set -e

source "$(dirname "$0")/../utils.sh"

print_box "[08] LAZYGIT CONFIG"

LAZYGIT_CONFIG="$HOME/Library/Application Support/lazygit/config.yml"
LAZYGIT_TEMPLATE="$(dirname "$0")/../../templates/lazygit.config.yml.template"

if [[ -f "$LAZYGIT_CONFIG" ]]; then
  ok "Lazygit config already exists — skipping"
else
  mkdir -p "$HOME/Library/Application Support/lazygit"
  cp "$LAZYGIT_TEMPLATE" "$LAZYGIT_CONFIG"
  ok "Lazygit config written"
fi
