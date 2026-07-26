#!/bin/bash

# =============================================================================
# macOS Egor Zekov Bootstrap
# Stack: Node.js · Rust · AWS
#
# Usage: bash run.sh
# =============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

source "$SCRIPT_DIR/scripts/utils.sh"

print_banner

for script in "$SCRIPT_DIR/scripts/bootstrap"/*.sh; do
  bash "$script" || exit 1
done
