#!/bin/bash

# =============================================================================
# XCODE COMMAND LINE TOOLS
# =============================================================================

set -e

source "$(dirname "$0")/../utils.sh"

print_box "[01] XCODE CLI"

if ! xcode-select -p &>/dev/null; then
  xcode-select --install
  echo "  → Install dialog opened. Re-run this script once complete."
  exit 1
else
  ok "Xcode CLI tools already installed"
fi
