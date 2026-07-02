---
name: pr-create-description
description: Generate a pull request description from current branch changes. Checks committed and uncommitted changes, respects an existing PR template if present, and outputs the description as a markdown code block.
---

# PR Create Description

**Announce at start:** "I'm using the pr-create-description skill to generate a PR description."

## Steps

### 1. Gather branch context

Run the following in sequence:

```bash
git rev-parse --abbrev-ref HEAD          # current branch name
git log main...HEAD --oneline            # commits ahead of main (try master if main fails)
git diff --stat HEAD                     # uncommitted file changes
git diff HEAD                            # full uncommitted diff
git diff main...HEAD                     # full committed diff vs base
```

If `main` doesn't exist as a base, try `master`, then `origin/HEAD`. Use whichever resolves.

### 2. Check for a PR template

Look for a pull request template in the repo:

```bash
cat .github/pull_request_template.md 2>/dev/null \
  || cat .github/PULL_REQUEST_TEMPLATE.md 2>/dev/null \
  || cat docs/pull_request_template.md 2>/dev/null
```

- If a template is found: use its exact section headings and structure. Fill in each section based on the diff.
- If no template is found: use the default structure below.

### 3. Default structure (no template)

```markdown
## Summary

<!-- 2-4 bullet points describing what changed and why -->

## Changes

<!-- Grouped list of what was modified, added, or removed -->

## Test plan

<!-- How to verify this works — steps, commands, or "N/A — no logic changed" -->
```

### 4. Write the description

Using the diff context and the template (or default structure):

- **Summary**: describe the purpose of the change, not a list of files. Answer "what problem does this solve?"
- **Changes**: group related file changes into coherent bullets. Skip generated files unless meaningful.
- **Test plan**: list concrete steps a reviewer can take to verify the change. If the change is a refactor with tests, name the test command.
- Keep it concise. No filler phrases like "This PR introduces..." or "In this change...".
- Do not invent behavior that isn't visible in the diff.

### 5. Extract task ID from branch name

Parse the branch name for a `[A-Z]+-[0-9]+` pattern. It may appear:

- At the start: `ABC-123/description` or `ABC-123-description`
- After a slash: `feature/ABC-123-description`

If found, compose a commit message: `<TASK-ID> <imperative summary>` (e.g. `REHDTOOL-2105 Implement local seeding`). The summary should be a short imperative phrase (≤60 chars total with the ID) derived from the diff, not copied from the branch name.

If no task ID is found, compose the commit message as just the imperative summary, without a task ID prefix (e.g. `Implement local seeding`).

### 6. Output

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
