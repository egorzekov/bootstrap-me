#!/bin/bash

# =============================================================================
# macOS Egor Zekov Bootstrap
# Stack: Node.js · Rust · AWS
#
# Usage: bash run.sh
# =============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

source "$SCRIPT_DIR/src/utils.sh"

print_banner

for script in "$SCRIPT_DIR/src/bootstrap"/*.sh; do
  bash "$script" || exit 1
done
