#!/bin/bash

# =============================================================================
# AGENT SKILLS — Symlink each repo-owned skill into ~/.agents/skills and
# ~/.claude/skills. The target dirs stay real directories so tool-managed
# skills (Claude sync, Orca, ...) never get written into this repo.
# =============================================================================

set -e

source "$(dirname "$0")/../utils.sh"

print_box "[10] AGENT SKILLS"

SKILLS_DIR="$(cd "$(dirname "$0")/../.." && pwd)/skills"

link_skills() {
  local parent_dir="$1"
  local label="$2"
  local target_dir="$parent_dir/skills"

  mkdir -p "$target_dir"

  local skill name dest
  for skill in "$SKILLS_DIR"/*/; do
    [[ -f "$skill/SKILL.md" ]] || continue
    skill="${skill%/}"
    name="$(basename "$skill")"
    dest="$target_dir/$name"

    if [[ -L "$dest" && "$(readlink "$dest")" == "$skill" ]]; then
      ok "$label/$name already linked"
    elif [[ -e "$dest" || -L "$dest" ]]; then
      warn "$label/$name exists and is not our link — skipped"
    else
      ln -s "$skill" "$dest"
      ok "$label/$name linked"
    fi
  done
}

link_skills "$HOME/.agents" "~/.agents/skills"
link_skills "$HOME/.claude" "~/.claude/skills"
