---
name: writing-short-plans
description: Use when you have a spec or requirements for a multi-step task and want a compressed plan: all tests written first (red), then all implementations (green), then commit.
---

# Writing Short Plans

## Overview

Write compressed implementation plans where all tests are written first (red phase), then all implementations are written (green phase), then a single commit. Assumes the engineer has zero context for our codebase and questionable taste. Document everything they need to know: which files to touch for each task, code, testing, docs they might need to check, how to test it. DRY. YAGNI. TDD.

Assume they are a skilled developer, but know almost nothing about our toolset or problem domain. Assume they don't know good test design very well.

**Announce at start:** "I'm using the writing-short-plans skill to create the implementation plan."

**Context:** If working in an isolated worktree, it should have been created via the `superpowers:using-git-worktrees` skill at execution time.

## Pre-flight Questions

Before writing the plan, ask the user two questions (can be asked together in one message):

1. **Commit cadence:** "Should I include a commit step at the end, or do you prefer to commit manually?"
2. **Plan location:** "Where would you like the plan saved? (default: `docs/superpowers/plans/YYYY-MM-DD-<feature-name>.md`)"

Wait for answers before proceeding. Apply the answers:
- If commit: include `git add` + `git commit` steps at the end of Step 3
- If no commits: omit commit steps
- Use the user-specified path; fall back to the default only if they confirm it

## Scope Check

If the spec covers multiple independent subsystems, it should have been broken into sub-project specs during brainstorming. If it wasn't, suggest breaking this into separate plans — one per subsystem. Each plan should produce working, testable software on its own.

## File Structure

Before defining tasks, map out which files will be created or modified and what each one is responsible for. This is where decomposition decisions get locked in.

- Design units with clear boundaries and well-defined interfaces. Each file should have one clear responsibility.
- You reason best about code you can hold in context at once, and your edits are more reliable when files are focused. Prefer smaller, focused files over large ones that do too much.
- Files that change together should live together. Split by responsibility, not by technical layer.
- In existing codebases, follow established patterns. If the codebase uses large files, don't unilaterally restructure - but if a file you're modifying has grown unwieldy, including a split in the plan is reasonable.

This structure informs the task decomposition.

## Plan Structure: 3 Steps

The plan always has exactly **3 steps**:

1. **Write all tests (red)** — write every failing test for every feature in the spec
2. **Write all implementations (green)** — write every implementation to make all tests pass
3. **Commit** — commit everything

Each step lists *all* files and changes for that phase, not per-feature slices.

## Plan Document Header

**Every plan MUST start with this header:**

```markdown
# [Feature Name] Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** [One sentence describing what this builds]

**Architecture:** [2-3 sentences about approach]

**Tech Stack:** [Key technologies/libraries]

---
```

## Step Structure

````markdown
### Step 1: Write All Tests (Red)

**Test files:**
- Create: `tests/exact/path/to/test_feature_a.py`
- Create: `tests/exact/path/to/test_feature_b.py`
- Modify: `tests/exact/path/to/test_existing.py`

- [ ] **1.1: Write tests for [Feature A]**

```python
def test_feature_a_behavior():
    result = function_a(input)
    assert result == expected

def test_feature_a_edge_case():
    result = function_a(edge_input)
    assert result == edge_expected
```

- [ ] **1.2: Write tests for [Feature B]**

```python
def test_feature_b_behavior():
    result = function_b(input)
    assert result == expected
```

- [ ] **1.3: Run all tests to verify they fail**

Run: `pytest tests/ -v`
Expected: ALL FAIL — "function not defined" or similar

---

### Step 2: Write All Implementations (Green)

**Implementation files:**
- Create: `src/exact/path/to/feature_a.py`
- Create: `src/exact/path/to/feature_b.py`
- Modify: `src/exact/path/to/existing.py:123-145`

- [ ] **2.1: Implement [Feature A]**

```python
def function_a(input):
    return expected
```

- [ ] **2.2: Implement [Feature B]**

```python
def function_b(input):
    return expected
```

- [ ] **2.3: Run all tests to verify they pass**

Run: `pytest tests/ -v`
Expected: ALL PASS

---

### Step 3: Commit

- [ ] **3.1: Stage and commit**

```bash
git add tests/path/test_feature_a.py tests/path/test_feature_b.py \
        src/path/feature_a.py src/path/feature_b.py
git commit -m "feat: add [feature name]"
```
````

## No Placeholders

Every step must contain the actual content an engineer needs. These are **plan failures** — never write them:
- "TBD", "TODO", "implement later", "fill in details"
- "Add appropriate error handling" / "add validation" / "handle edge cases"
- "Write tests for the above" (without actual test code)
- "Similar to Step N" (repeat the code — the engineer may be reading steps out of order)
- Steps that describe what to do without showing how (code blocks required for code steps)
- References to types, functions, or methods not defined in any step

## Remember
- Exact file paths always
- Complete code in every step — if a step changes code, show the code
- Exact commands with expected output
- DRY, YAGNI, TDD, one commit at the end

## Self-Review

After writing the complete plan, look at the spec with fresh eyes and check the plan against it. This is a checklist you run yourself — not a subagent dispatch.

**1. Spec coverage:** Skim each section/requirement in the spec. Can you point to a test and an implementation that covers it? List any gaps.

**2. Placeholder scan:** Search your plan for red flags — any of the patterns from the "No Placeholders" section above. Fix them.

**3. Type consistency:** Do the types, method signatures, and property names you used in Step 2 match what you tested in Step 1? A function called `clearLayers()` in Step 1 but `clearFullLayers()` in Step 2 is a bug.

If you find issues, fix them inline. No need to re-review — just fix and move on. If you find a spec requirement with no test, add the test.

## Execution Handoff

After saving the plan, offer execution choice:

**"Plan complete and saved to `<user-specified-path>`. Two execution options:**

**1. Subagent-Driven (recommended)** - I dispatch a fresh subagent per step, review between steps, fast iteration

**2. Inline Execution** - Execute steps in this session using executing-plans, batch execution with checkpoints

**Which approach?"**

**If Subagent-Driven chosen:**
- **REQUIRED SUB-SKILL:** Use superpowers:subagent-driven-development
- Fresh subagent per step + two-stage review

**If Inline Execution chosen:**
- **REQUIRED SUB-SKILL:** Use superpowers:executing-plans
- Batch execution with checkpoints for review
