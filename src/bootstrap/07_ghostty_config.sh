#!/bin/bash

# =============================================================================
# GHOSTTY CONFIG
# =============================================================================

set -e

source "$(dirname "$0")/../utils.sh"

print_box "[07] GHOSTTY CONFIG"

GHOSTTY_CONFIG="$HOME/Library/Application Support/com.mitchellh.ghostty/config.ghostty"
GHOSTTY_TEMPLATE="$(dirname "$0")/../../templates/.ghostty.template"

if [[ -f "$GHOSTTY_CONFIG" ]]; then
  ok "Ghostty config already exists — skipping"
else
  mkdir -p "$HOME/Library/Application Support/com.mitchellh.ghostty"
  cp "$GHOSTTY_TEMPLATE" "$GHOSTTY_CONFIG"
  ok "Ghostty config written"
fi
