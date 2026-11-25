#!/bin/bash

# =============================================================================
# BACKFILL: UNLINK SKILLS DIR — one-time migration from the old layout, where
# ~/.claude/skills and ~/.agents/skills were symlinks to this repo's skills/
# dir, to real directories holding per-skill symlinks.
#
# Why: with a whole-dir symlink, tools that manage skills (Claude sync, Orca)
# write their files into the repo. See scripts/bootstrap/10_agent_skills.sh.
#
# What it does, only for targets that still are the old whole-dir symlink:
#   1. Moves tool-managed entries out of the repo's skills/ dir (staging dir).
#   2. Removes the old symlink and creates a real directory.
#   3. Puts the tool-managed entries back into the real directory.
# Then run: bash scripts/bootstrap/10_agent_skills.sh
#
# Usage: bash scripts/backfills/unlink_skills_dir.sh
# Safe to re-run: targets that are not the old symlink are skipped.
# =============================================================================

set -e

source "$(dirname "$0")/../utils.sh"

print_box "[BACKFILL] UNLINK SKILLS DIR"

SKILLS_DIR="$(cd "$(dirname "$0")/../.." && pwd)/skills"

# Entries that tools wrote into the repo's skills/ dir; they must not stay in git.
# Installed into both targets:
MANAGED_SHARED=(orca-cli orchestration)
# Claude-only (Claude's account skill sync and its trash):
MANAGED_CLAUDE_ONLY=(synced .trash)

TARGETS=("$HOME/.claude/skills" "$HOME/.agents/skills")

is_legacy_link() {
  [[ -L "$1" && "$(readlink "$1")" == "$SKILLS_DIR" ]]
}

in_list() {
  local needle="$1"
  shift
  local x
  for x in "$@"; do [[ "$x" == "$needle" ]] && return 0; done
  return 1
}

legacy=()
for target in "${TARGETS[@]}"; do
  if is_legacy_link "$target"; then
    legacy+=("$target")
  else
    ok "$target is not the old symlink — nothing to do"
  fi
done

if [[ ${#legacy[@]} -eq 0 ]]; then
  ok "Done"
  exit 0
fi

STAGE="$(mktemp -d "${TMPDIR:-/tmp}/skills-backfill.XXXXXX")"
log "Staging tool-managed skills in $STAGE"

for name in "${MANAGED_SHARED[@]}" "${MANAGED_CLAUDE_ONLY[@]}"; do
  if [[ -e "$SKILLS_DIR/$name" || -L "$SKILLS_DIR/$name" ]]; then
    mv "$SKILLS_DIR/$name" "$STAGE/$name"
    ok "staged $name"
  fi
done

for target in "${legacy[@]}"; do
  rm "$target"
  mkdir -p "$target"
  ok "$target is now a real directory"

  for entry in "$STAGE"/* "$STAGE"/.[!.]*; do
    [[ -e "$entry" || -L "$entry" ]] || continue
    name="$(basename "$entry")"
    # Claude-only entries go to ~/.claude/skills alone.
    if [[ "$target" != "$HOME/.claude/skills" ]] && in_list "$name" "${MANAGED_CLAUDE_ONLY[@]}"; then
      continue
    fi
    cp -R "$entry" "$target/$name"
    ok "restored $name into $target"
  done
done

rm -rf "$STAGE"

# Leftovers that are not ours to move: tell the user instead of guessing.
if git -C "$SKILLS_DIR" rev-parse --is-inside-work-tree &>/dev/null; then
  untracked="$(git -C "$SKILLS_DIR" ls-files --others --exclude-standard --directory . 2>/dev/null || true)"
  if [[ -n "$untracked" ]]; then
    warn "Untracked entries remain in skills/ (commit them if they are yours):"
    printf '     %s\n' $untracked
  fi
fi

ok "Done — now run: bash scripts/bootstrap/10_agent_skills.sh"
