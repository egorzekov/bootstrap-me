#!/bin/bash

# =============================================================================
# GITCONFIG LOCAL — Write Git identity from bootstrap profile
# =============================================================================

set -e

source "$(dirname "$0")/../utils.sh"

print_box "[12] GITCONFIG LOCAL"

PROFILE="$HOME/.bootstrap_profile"
GITCONFIG_LOCAL="$HOME/.gitconfig.local"

if [[ ! -f "$PROFILE" ]]; then
  warn "~/.bootstrap_profile not found — run 00_ssh.sh first, then re-run"
  exit 1
fi

source "$PROFILE"
cat > "$GITCONFIG_LOCAL" <<EOF
[user]
	name  = $GIT_NAME
	email = $GIT_EMAIL
EOF
ok "~/.gitconfig.local written (name + email)"
