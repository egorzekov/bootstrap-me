#!/bin/bash

# =============================================================================
# AGENT SKILLS — Symlink repo-owned skills into ~/.agents and ~/.claude
# =============================================================================

set -e

source "$(dirname "$0")/../utils.sh"

print_box "[10] AGENT SKILLS"

SKILLS_DIR="$(cd "$(dirname "$0")/../.." && pwd)/skills"

link_skills_dir() {
  local parent_dir="$1"
  local label="$2"
  local target="$parent_dir/skills"

  mkdir -p "$parent_dir"

  if [[ -L "$target" ]]; then
    local current
    current="$(readlink "$target")"
    if [[ "$current" == "$SKILLS_DIR" ]]; then
      ok "$label already linked"
      return
    fi
    rm "$target"
    warn "$label had wrong symlink — replaced"
  elif [[ -e "$target" ]]; then
    local backup="${target}.bak.$(date +%Y%m%d%H%M%S)"
    mv "$target" "$backup"
    warn "$label was a plain path — backed up to $backup"
  fi

  ln -s "$SKILLS_DIR" "$target"
  ok "$label linked to repo skills"
}

link_skills_dir "$HOME/.agents" "~/.agents/skills"
link_skills_dir "$HOME/.claude" "~/.claude/skills"
