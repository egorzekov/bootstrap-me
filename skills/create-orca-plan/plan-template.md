# Plan template

Copy this structure into `tmp/<dd-mm-yyyy>-<task-name>.md` and fill every section. Delete a section only if it is truly not applicable, and say why in one line. Replace every `<...>`; no placeholder may remain.

````markdown
# <Task name> Implementation Plan

> **For the implementer (agent or engineer):** Execute the tasks in order. Each step is a checkbox (`- [ ]`); tick it when done. Do not skip a verification step. If something is unclear or the plan does not match reality, stop and ask, do not guess.

**Date:** <dd-mm-yyyy>
**Goal:** <one sentence: what exists when this is done>
**Architecture:** <2-4 sentences: the approach and why>
**Tech stack:** <languages, frameworks, libraries, versions that matter>

## 1. Affected files

| Action | Path | Responsibility |
|--------|------|----------------|
| Create | `exact/path/new_module.ts` | <one responsibility> |
| Modify | `exact/path/existing.ts:120-160` | <what changes and why> |
| Create | `tests/exact/path/new_module.test.ts` | <what it covers> |
| Delete | `exact/path/old.ts` | <why it goes> |

Do not touch: <files or areas out of bounds>

## 2. Context

- **Why:** <the problem and the user-visible outcome>
- **Existing code to read first:** `path/a.ts` (<what to learn from it>), `path/b.ts`
- **Patterns to follow:** <naming, error handling, module layout, with a file to imitate>
- **Project rules that apply:** <rules copied from AGENTS.md/CLAUDE.md>

### Assumptions
- <decision taken in place of asking, and why>

### Non-goals
- <what this plan deliberately does not do>

## 3. Pre-flight

Run from `<directory>`. Do not start if the baseline is red; report it instead.

```bash
<install/setup command>      # expected: <result>
<test command>               # expected: <N passing, 0 failing>
<lint/typecheck command>     # expected: clean
```

## 4. Core design

Show the key types, interfaces, schemas, config and function signatures in full, in the real language. Later tasks must use these names exactly.

```<lang>
// path/to/module.ext
<real signatures and the non-obvious logic>
```

<Short notes on data flow, error cases, and invariants.>

## 5. Tasks

### Task 1: <component or behavior>

**Files:**
- Create: `exact/path/file.ext`
- Modify: `exact/path/existing.ext:123-145`
- Test: `tests/exact/path/file.test.ext`

- [ ] **Step 1: Write the failing test** (TDD; use this form when the change is testable logic or a bug fix)

```<lang>
<complete test code>
```

- [ ] **Step 2: Run it and confirm it fails for the right reason**

Run: `<exact command>`
Expected: FAIL with `<exact message or reason>`

- [ ] **Step 3: Implement the minimum**

```<lang>
<complete implementation>
```

- [ ] **Step 4: Run it and confirm it passes**

Run: `<exact command>`
Expected: PASS, `<N>` tests

- [ ] **Step 5: Refactor if needed, rerun the suite**

Run: `<full test command>`
Expected: all green

- [ ] **Step 6: Commit**

```bash
git add <exact paths>
git commit -m "<type>: <message>"
```

### Task 2: <config, scaffolding or docs change> (no TDD: <reason>)

**Files:** <...>

- [ ] **Step 1: <change>**

```<lang>
<complete content>
```

- [ ] **Step 2: Verify**

Run: `<concrete command that proves it works>`
Expected: `<exact output or exit code>`

- [ ] **Step 3: Commit**

```bash
git add <paths>
git commit -m "<message>"
```

<Repeat for every task. Each task leaves the repo building with tests green.>

## 6. Risks and rollback

| Risk | Likelihood | Mitigation or check |
|------|------------|---------------------|
| <risk> | low/med/high | <how to avoid or detect> |

Rollback: <how to undo, e.g. `git revert <range>`, feature flag name, migration down step>

## 7. Acceptance criteria

- [ ] <observable, testable criterion mapped to a requirement>
- [ ] <...>

## 8. Final verification

```bash
<full test command>          # expected: <...>
<lint/typecheck/build>       # expected: <...>
<manual or e2e smoke check>  # expected: <...>
```

## 9. Report back

When finished, report: outcome (done / partial / blocked), each verification command with its result, the list of files changed, deviations from this plan with the reason, and open questions.

## 10. Open questions

- <anything still unresolved; if none, write "None">
````

## Notes for the author

- Task size: 15-30 minutes of work. If a task needs more than about six steps, split it.
- Step size: one action, 2-5 minutes.
- Code blocks must be complete enough to paste. Show real signatures, real types and the tricky logic. Mechanical boilerplate may be abbreviated only when the pattern is shown in full once and the plan names the file to copy it from.
- Commit messages follow the repo's convention. Check `git log --oneline -10`.
- Prefer many small commits over one large one.
- Order tasks so that dependencies come first and the repo stays green after each one.
