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

if [[ -f "$GITCONFIG" ]]; then
  ok "~/.gitconfig already exists — skipping"
else
  if [[ ! -f "$PROFILE" ]]; then
    warn "~/.bootstrap_profile not found — run 00_ssh.sh first, then re-run"
  else
    source "$PROFILE"
    sed -e "s/{{NAME}}/$GIT_NAME/" -e "s/{{EMAIL}}/$GIT_EMAIL/" "$TEMPLATE" > "$GITCONFIG"
    ok "~/.gitconfig written"
  fi
fi

# Clean up shared profile — no longer needed after this point
if [[ -f "$PROFILE" ]]; then
  rm -f "$PROFILE"
  ok "~/.bootstrap_profile cleaned up"
fi
