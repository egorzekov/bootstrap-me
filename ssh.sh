#!/bin/bash

# =============================================================================
# SSH — Generate and register an SSH key for GitHub
# Usage: bash ./ssh.sh
# =============================================================================

set -e

source "$(dirname "$0")/utils.sh"

print_box "[SSH] GITHUB SSH KEY SETUP"

# =============================================================================
# 1. PROMPT FOR EMAIL
# =============================================================================
read -rp "  Enter your GitHub email: " EMAIL
if [[ -z "$EMAIL" ]]; then
  warn "No email provided. Aborting."
  exit 1
fi

# =============================================================================
# 2. GENERATE SSH KEY
# =============================================================================
KEY="$HOME/.ssh/id_ed25519"

if [[ -f "$KEY" ]]; then
  ok "SSH key already exists at $KEY — skipping generation"
else
  log "Generating ed25519 SSH key..."
  ssh-keygen -t ed25519 -C "$EMAIL" -f "$KEY"
  ok "SSH key generated"
fi

# =============================================================================
# 3. CONFIGURE ~/.ssh/config FOR GITHUB
# =============================================================================
SSH_CONFIG="$HOME/.ssh/config"
mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"

if ! grep -q "Host github.com" "$SSH_CONFIG" 2>/dev/null; then
  log "Adding GitHub entry to ~/.ssh/config..."
  cat >> "$SSH_CONFIG" <<EOF

Host github.com
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/id_ed25519
EOF
  chmod 600 "$SSH_CONFIG"
  ok "~/.ssh/config updated"
else
  ok "~/.ssh/config already has a GitHub entry"
fi

# =============================================================================
# 4. ADD KEY TO SSH AGENT & MACOS KEYCHAIN
# =============================================================================
log "Adding SSH key to agent and macOS Keychain..."
eval "$(ssh-agent -s)" > /dev/null
ssh-add --apple-use-keychain "$KEY"
ok "SSH key added to agent and Keychain"

# =============================================================================
# 5. COPY PUBLIC KEY & INSTRUCT USER
# =============================================================================
pbcopy < "${KEY}.pub"
ok "Public key copied to clipboard"

echo ""
log "Your public key:"
cat "${KEY}.pub"
echo ""
log "Next: add this key to GitHub → Settings → SSH and GPG keys"
open "https://github.com/settings/ssh/new"
