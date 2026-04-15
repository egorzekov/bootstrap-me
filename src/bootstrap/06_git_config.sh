#!/bin/bash

# =============================================================================
# GIT CONFIG
# =============================================================================

set -e

source "$(dirname "$0")/../utils.sh"

print_box "[06] GIT CONFIG"

GITCONFIG="$HOME/.gitconfig"
PROFILE="$HOME/.bootstrap_profile"
TEMPLATE="$(dirname "$0")/../../templates/.gitconfig.template"
STOW_DIR="$(cd "$(dirname "$0")/../.." && pwd)/stow"
STOW_GITCONFIG="$STOW_DIR/git/.gitconfig"

if [[ -f "$GITCONFIG" && ! -L "$GITCONFIG" ]]; then
  warn "~/.gitconfig is a plain file (not managed by stow) — skipping"
else
  if [[ ! -f "$PROFILE" ]]; then
    warn "~/.bootstrap_profile not found — run 00_ssh.sh first, then re-run"
  else
    source "$PROFILE"
    sed -e "s/{{NAME}}/$GIT_NAME/" -e "s/{{EMAIL}}/$GIT_EMAIL/" "$TEMPLATE" > "$STOW_GITCONFIG"
    stow --dir="$STOW_DIR" --target="$HOME" -R git
    ok "~/.gitconfig linked via stow"
  fi
fi

# Clean up shared profile — no longer needed after this point
if [[ -f "$PROFILE" ]]; then
  rm -f "$PROFILE"
  ok "~/.bootstrap_profile cleaned up"
fi
