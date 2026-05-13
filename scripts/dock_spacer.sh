#!/bin/bash

# =============================================================================
# DOCK SPACER
# =============================================================================

set -e

source "$(dirname "$0")/utils.sh"

print_box "Dock Spacer"

echo ""
PS3="  Choose an action: "
COLUMNS=1
select choice in "Add small spacer" "Add big spacer" "Remove all spacers" "Cancel"; do
  case $choice in
    "Add small spacer")
      defaults write com.apple.dock persistent-apps -array-add '{"tile-type"="small-spacer-tile";}'
      ok "Small spacer added"
      killall Dock
      break
      ;;
    "Add big spacer")
      defaults write com.apple.dock persistent-apps -array-add '{"tile-type"="spacer-tile";}'
      ok "Big spacer added"
      killall Dock
      break
      ;;
    "Remove all spacers")
      python3 - <<'EOF'
import subprocess, plistlib, os

plist_path = os.path.expanduser("~/Library/Preferences/com.apple.dock.plist")
result = subprocess.run(["plutil", "-convert", "xml1", "-o", "-", plist_path], capture_output=True)
plist = plistlib.loads(result.stdout)

original = plist.get("persistent-apps", [])
filtered = [app for app in original if app.get("tile-type") not in ("spacer-tile", "small-spacer-tile")]
removed = len(original) - len(filtered)

plist["persistent-apps"] = filtered
with open(plist_path, "wb") as f:
    plistlib.dump(plist, f)

print(f"Removed {removed} spacer(s)")
EOF
      ok "All spacers removed"
      killall Dock
      break
      ;;
    "Cancel")
      log "No changes made"
      break
      ;;
    *)
      warn "Invalid selection, try again"
      ;;
  esac
done
