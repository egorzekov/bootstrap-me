---
name: pr-create-description
description: Generate a pull request description from current branch changes. Resolves the PR base branch (supports stacked branches), checks committed and uncommitted changes, respects an existing PR template if present, and outputs the description as a markdown code block.
disable-model-invocation: true
---

# PR Create Description

**Announce at start:** "I'm using the pr-create-description skill to generate a PR description."

## Steps

### 1. Resolve the PR base branch

Before gathering diffs, determine which ref this PR targets. The base is **not** always `main` — for stacked branches (`main` → `BranchA` → `BranchB`), a PR for `BranchB` should diff against `BranchA`.

Resolve in this priority order; stop at the first match:

1. **User override** — if the user names a base branch in the prompt (e.g. "base BranchA", "against feature/foo", "target BranchA"), use it.
2. **Open PR on GitHub** — if a PR already exists for the current branch:
   ```bash
   gh pr view --json baseRefName -q .baseRefName 2>/dev/null
   ```
3. **Per-branch git config** — explicit local setting:
   ```bash
   git config branch.$(git rev-parse --abbrev-ref HEAD).prbase
   ```
   Set with: `git config branch.<name>.prbase <base-branch>`
4. **Auto-detect stacked parent** — among local branches whose tip is a direct ancestor of `HEAD`, pick the newest one (immediate parent, not `main` when `BranchA` exists):
   ```bash
   current=$(git rev-parse --abbrev-ref HEAD)
   best_base=""
   best_date=0

   for branch in $(git for-each-ref --format='%(refname:short)' refs/heads/); do
     [[ "$branch" == "$current" ]] && continue
     tip=$(git rev-parse "$branch")
     mb=$(git merge-base "$branch" HEAD)
     [[ "$mb" == "$tip" ]] || continue
     date=$(git log -1 --format=%ct "$branch")
     if (( date > best_date )); then
       best_date=$date
       best_base=$branch
     fi
   done
   echo "$best_base"
   ```
5. **Default trunk** — `main`, then `master`, then `origin/HEAD` (whichever resolves).

Store the resolved ref as `BASE`. If step 4 returns empty, use step 5.

### 2. Gather branch context

Run the following in sequence, substituting `$BASE` everywhere:

```bash
git rev-parse --abbrev-ref HEAD          # current branch name
echo "Base branch: $BASE"
git rev-list --count "$BASE"..HEAD         # commits ahead of base
git log "$BASE"..HEAD --oneline           # commits ahead of base
git diff --stat HEAD                     # uncommitted file changes
git diff HEAD                            # full uncommitted diff
git diff "$BASE"...HEAD                  # full committed diff vs base
```

Use `$BASE..HEAD` for commit lists (commits reachable from HEAD but not from base).
Use `$BASE...HEAD` for the diff (changes since the fork point — correct for stacked/rebased branches).

### 3. Check for a PR template

Look for a pull request template in the repo:

```bash
cat .github/pull_request_template.md 2>/dev/null \
  || cat .github/PULL_REQUEST_TEMPLATE.md 2>/dev/null \
  || cat docs/pull_request_template.md 2>/dev/null
```

- If a template is found: use its exact section headings and structure. Fill in each section based on the diff.
- If no template is found: use the default structure below.

### 4. Default structure (no template)

```markdown
## Summary

<!-- 2-4 bullet points describing what changed and why -->

## Changes

<!-- Grouped list of what was modified, added, or removed -->

## Test plan

<!-- How to verify this works — steps, commands, or "N/A — no logic changed" -->
```

### 5. Write the description

Using the diff context and the template (or default structure):

- **Summary**: describe the purpose of the change, not a list of files. Answer "what problem does this solve?"
- **Changes**: group related file changes into coherent bullets. Skip generated files unless meaningful.
- **Test plan**: list concrete steps a reviewer can take to verify the change. If the change is a refactor with tests, name the test command.
- Scope the description to `$BASE..HEAD` only — do not describe commits or changes that already exist on the base branch.
- Keep it concise. No filler phrases like "This PR introduces..." or "In this change...".
- Do not invent behavior that isn't visible in the diff.

### 6. Extract task ID from branch name

Parse the branch name for a `[A-Z]+-[0-9]+` pattern. It may appear:

- At the start: `ABC-123/description` or `ABC-123-description`
- After a slash: `feature/ABC-123-description`

If found, compose a commit message: `<TASK-ID> <imperative summary>` (e.g. `REHDTOOL-2105 Implement local seeding`). The summary should be a short imperative phrase (≤60 chars total with the ID) derived from the diff, not copied from the branch name.

If no task ID is found, compose the commit message as just the imperative summary, without a task ID prefix (e.g. `Implement local seeding`).

### 7. Output

Print two blocks, separated by a blank line.

**Block 1 — PR description** (always present):

````
```markdown
## Summary
...

## Changes
...

## Test plan
...
```
````

**Block 2 — Commit message** (always present):

````
```
TASK-ID Imperative summary here
```
````

If no task ID was found, omit the ID prefix and print just the imperative summary.

No prose between or after the blocks.
