#!/bin/bash

# =============================================================================
# RUSTUP — Rust toolchain installer (official installer)
# =============================================================================

set -e

source "$(dirname "$0")/../utils.sh"

print_box "[07] RUSTUP"

if command -v rustup &>/dev/null; then
  ok "rustup already installed"
else
  log "Installing rustup via official installer..."
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
  ok "rustup installed"
fi
