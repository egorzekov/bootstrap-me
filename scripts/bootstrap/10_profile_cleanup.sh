#!/bin/bash

# =============================================================================
# PROFILE CLEANUP — Remove temporary bootstrap profile file
# =============================================================================

set -e

source "$(dirname "$0")/../utils.sh"

print_box "[10] PROFILE CLEANUP"

PROFILE="$HOME/.bootstrap_profile"

if [[ -f "$PROFILE" ]]; then
  rm -f "$PROFILE"
  ok "~/.bootstrap_profile cleaned up"
else
  ok "~/.bootstrap_profile already clean"
fi
