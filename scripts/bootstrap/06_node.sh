#!/bin/bash

# =============================================================================
# NODE.JS — installed and managed via fnm (brew formula, see 04_brew_tools.sh)
# =============================================================================

set -e

source "$(dirname "$0")/../utils.sh"

print_box "[06] NODE.JS"

if ! command -v fnm &>/dev/null; then
  warn "fnm not found — run scripts/bootstrap/04_brew_tools.sh first"
  exit 1
fi

# fnm is not yet on PATH for this non-interactive shell; ~/.zshrc only wires it
# up for interactive ones. Evaluate it here so fnm's shims resolve.
eval "$(fnm env --shell bash)"

if fnm list | grep -q 'default'; then
  ok "Node $(fnm current) already installed (default alias set)"
else
  log "Installing latest Node.js LTS via fnm..."
  fnm install --lts
  fnm default lts-latest
  ok "Node $(fnm current) installed and set as default"
fi
