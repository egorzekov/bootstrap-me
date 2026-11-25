---
name: create-orca-plan
description: Write a detailed, self-contained implementation plan to ./tmp/dd-mm-yyyy-task-name.md, then ask which Orca worker agent should implement it and spawn that worker through the `orca orchestration` API. Use when the user says "create-orca-plan", "plan this and hand it to an agent", "write a plan and send it to Cursor/Claude/OMP", or wants a plan that a junior engineer or another agent can implement without further context.
---

# Create Orca plan

Two phases: (1) write a plan that anyone can execute cold, (2) ask who implements it, then spawn that worker with Orca orchestration. Do not implement the plan yourself.

This skill works from any agent (Claude, Cursor, OMP, Kimi, Devin, ...). Where it says "ask the user", use your harness's question tool if it has one, otherwise ask in chat and wait for the answer.

## Phase 1: write the plan

### 1. Understand before writing

- Restate the goal in one or two sentences. If the request is ambiguous in a way that changes the design, ask the user (one question at a time) before writing. Otherwise pick the conventional default and record it under Assumptions.
- Explore the codebase instead of asking about things the code can answer: entry points, existing patterns, test framework and commands, lint/type-check commands, naming and file layout conventions, nearby code to imitate.
- Read `AGENTS.md`/`CLAUDE.md` and respect their rules. Copy the rules that matter for this task into the plan, because the implementer may not read them.

### 2. Create the file

```bash
date +%d-%m-%Y          # e.g. 25-11-2026
mkdir -p tmp
```

Path: `<repo-root>/tmp/<dd-mm-yyyy>-<task-name>.md`. The task name is lowercase kebab-case, 2-5 words (`tmp/25-11-2026-add-retry-to-uploader.md`). If the file exists, add `-2`; never overwrite.

Run `git check-ignore -q tmp || echo "tmp/ is not ignored"`. If it is not ignored, tell the user and do not commit the plan.

Write the plan with your file tool, following [plan-template.md](plan-template.md) exactly. Use absolute paths when you later reference the plan file; the implementer may run in a different worktree.

### 3. Plan quality bar

The plan is a contract for an agent or junior engineer with zero context. Apply these rules:

- **Start with affected files.** A table of every file to create, modify or delete, with its responsibility, before any task.
- **Bite-sized tasks.** Each task is one coherent change an implementer finishes in about 15-30 minutes, split into steps of 2-5 minutes (write test, run it, implement, run it, commit).
- **Exact paths, exact commands, expected output.** Every run step names the command and what success looks like.
- **Real code, not descriptions.** Include code blocks for the core functions, modules, types, schemas and config. Write the signatures and the non-obvious logic in full. Boilerplate may be summarized, but never write "add validation" without showing the rule.
- **TDD where it makes sense:** pure logic, parsers, data transforms, API handlers, bug fixes (reproduce first). Show the failing test, the command, the expected failure, the minimal implementation, the passing run. Skip TDD for config, scaffolding, docs and glue code; give a concrete verification command instead and say why TDD is skipped.
- **No placeholders.** Forbidden: "TBD", "TODO", "handle edge cases", "similar to Task N" (repeat the code), "write tests for the above", references to types or functions that no task defines.
- **Consistency.** Names, signatures and file paths must match across all tasks. Check this in the self-review.
- **Small increments.** Every task leaves the repo building and tests green, and ends with a commit. DRY, YAGNI, no speculative abstractions.
- **Boundaries.** List non-goals and files that must not be touched.
- **Evidence.** End with acceptance criteria and a final verification checklist (commands plus expected results), and the report format the implementer owes back.

### 4. Self-review before handing off

Re-read the finished file with fresh eyes and fix problems inline:

1. Spec coverage: every requirement maps to a task.
2. Placeholder scan: search the file for `TBD`, `TODO`, `...`, `similar to`.
3. Type and name consistency across tasks.
4. Every command is runnable as written from the stated directory.
5. Affected-files table matches the files the tasks actually touch.

## Phase 2: choose the worker and spawn it

### 5. Ask which agent implements the plan

Present exactly these options and wait for the answer. Do not choose for the user, and do not spawn anything before they answer.

| # | Option | `--agent` | `--model` | `--effort` |
|---|--------|-----------|-----------|------------|
| 1 | Cursor, Grok 4.7, medium, fast | `cursor` | `grok-4.7-fast` | `medium` |
| 2 | Claude Sonnet 5.5, medium | `claude` | `claude-sonnet-5-5` | `medium` |
| 3 | OMP, GPT Sol 6.2, medium | `omp` | `gpt-sol-6.2` | `medium` |

The `--model` ids above are the best known provider ids and have **not been verified** on this machine. Before spawning, verify the id for the chosen option:

- OMP: run `omp models` and pick the matching id. OMP also accepts fuzzy selectors such as `gpt-sol-6.2` or `provider/id:medium`.
- Cursor: use the id from Cursor's model list for Grok 4.7 Fast.
- Claude: `claude-sonnet-5-5`.

If you cannot find a matching id, say so, show the user what is available and ask which to use. Never silently substitute another model. If the user picks "Other", map it to an agent id from `orca agent installed --json` and ask for the model id.

### 6. Resolve the Orca CLI and check the runtime

Pick the executable once. `ORCA` below stands for it; substitute it before running anything.

- If `ORCA_CLI_COMMAND` is set, use its value.
- Otherwise, if `ORCA_DEV_REPO_ROOT` is set, use `orca-dev`.
- Otherwise, on Linux outside an Orca terminal, use `orca-ide` (bare `orca` there is the GNOME screen reader).
- Otherwise, use `orca`.

```text
ORCA status --json
ORCA agent installed --json
ORCA skills get orchestration
```

- `status` must report `result.app.running: true` and a ready runtime. Otherwise report the exact error and stop. Do not run `ORCA open` to retry.
- The chosen `--agent` id must appear in `agent installed`. If not, tell the user and offer the installed ones.
- Read the orchestration guide once. It is version-matched; if it disagrees with this skill, the guide wins. Use `ORCA orchestration worker-start --help` for flags.

### 7. Write the dispatch spec

Write a spec file with your file tool, next to the plan: `tmp/<dd-mm-yyyy>-<task-name>.spec.md`. Never use heredocs or here-strings. The spec must be self-contained:

```markdown
Implement the plan at <ABSOLUTE PATH TO PLAN>.

Read the whole plan first, then execute it task by task, in order. Follow the steps literally, including the test-first steps, and run every verification command.

Constraints:
- Edit only the files listed in the plan's "Affected files" table.
- Do not change the plan file.
- Commit after each task using the commit messages in the plan.
- If a step cannot be done as written, or you must decide something the plan does not cover, run `orca orchestration ask` with one specific question and wait for the answer. Do not guess.

Done means: every acceptance criterion in the plan is met and the final verification checklist passes.

When finished, report with worker_done: outcome, the commands you ran with their results, files changed, and any deviation from the plan. A non-zero exit from a verification command means the task failed; report it, do not hide it.
```

### 8. Spawn the worker

```text
ORCA orchestration worker-start --environment local --spec-file <spec path> --worktree current --agent <agent> --model <model> --effort <effort> --json
```

- Use `--worktree current` by default, because the plan lives in untracked `tmp/`. Use `--worktree new-child --name <short-name>` only if the user asked for isolation; the worker still reads the plan by its absolute path.
- Pass `--model` and `--effort` together (`--effort` requires `--model`). For Claude, Cursor and OMP both apply.
- Add `--task-title "<task name>"` for a readable Run.
- If `worker-start` fails, do not rerun it. Read `failedStage` and the printed recovery steps, and load `ORCA skills get orchestration --reference references/recovery-and-cleanup.md`. If the outcome is unknown, check `ORCA orchestration worker-list --environment local` before anything else. A missing CLI for the agent shows up as an `agent_readiness` timeout.
- If the receipt has `next`, follow it.

### 9. After spawning

- Tell the user: plan path, spec path, agent and model, worktree, Run and dispatch ids from the receipt.
- **End your turn.** Orca wakes you when the worker reports. Never poll, sleep-loop, or watch the terminal.
- When woken: read `worker_done` (use `ORCA orchestration worker-read --dispatch <dispatch_id>` if you need more output). Answer a `question` with `ORCA orchestration reply --id <message_id> --body "<answer>"` only if the plan or the user's instructions settle it; otherwise ask the user first. For an `escalation`, follow the stop-reason guidance in the orchestration guide.
- Report per task: outcome, evidence, open blockers. Summarize the worker's evidence; rerun checks only if something is missing or contradictory.

## Never

- Implement the plan yourself, or start the worker before the user picks one.
- Leave placeholders in the plan, or point to files the plan does not list.
- Use a different model than the user chose.
- Poll, or steer a worker through its terminal; use `orchestration send`.
- Commit the plan or spec files from `tmp/`.
