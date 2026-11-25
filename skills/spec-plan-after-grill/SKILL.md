---
name: spec-plan-after-grill
disable-model-invocation: true
description: >-
  Writes a docs/technical/*-system.md contract after a grill-me design session:
  same section spine and tone as effect-system.md, every agreed decision and code
  example from the conversation, landing slices, deferred, and rejected alternatives.
  Use when the user finishes grilling, asks for a spec plan, technical contract,
  or to capture agreed design like effect-system.md.
---

# Spec plan after grill

Turn a **finished** grill-me session (or an explicit list of agreed decisions) into
a single implementation contract under `docs/technical/`. The canonical shape and
density are [`effect-system.md`](../../../docs/technical/effect-system.md); read it
before writing. Do not start this skill mid-grill — unresolved branches stay in
grill-me until closed.

## Inputs

Harvest from the conversation (and only supplement from the repo when grilling
deferred to "explore the codebase"):

- Every decision the user **accepted** (including "yes, your recommendation").
- Every **code example** shown during Detailed grilling or pasted by the user.
- Explicit **renames**, **reversals**, and **out-of-scope** items.
- **Rejected** options and the one-line why-not (especially options you recommended
  but the user declined).

If anything material is still open, stop and ask one closing question (grill-me
style), then resume this skill.

## Output

- Path: `docs/technical/<topic>-system.md` (singular feature name, hyphenated:
  `effect-system`, `status-system`). Match sibling filenames in that folder.
- Status line in the opening paragraph: `planned, not in the crate` / `partially
  landed` / `landed` — whatever matches reality after a quick repo check.
- Imperative contract voice: "Implement it as written; if a rule here conflicts
  with code you find, stop and ask."

## Workflow

1. **Re-read the grill thread** — skim for "final recommendation" / "agreed" /
   user affirmations; copy code blocks verbatim (fix only obvious typos; note
   intentional pseudocode as `// sketch` if it was never meant to compile).
2. **Read the template** — [reference.md](reference.md) for section order, what
   each § must contain, and anti-patterns.
3. **Reconcile with the repo** — module paths, existing types, and related specs.
   §0 and cross-links must point at real files. Landing slices name real tests,
   commands, and `advance_frame` / `apply_mutation` arms when combat is involved.
4. **Draft the doc** — fill every applicable section; omit empty sections only
   when the feature truly has nothing there (say so in one line, do not delete
   the heading if effect-system has an analogue).
5. **Juice with code** — prefer agreed snippets over prose. One concept → one
   fenced block (rust / text tree). Follow with a short rule paragraph only when
   the code alone would be ambiguous.
6. **Close the loop** — § landing order must be executable by another agent:
   behaviour-neutral slices first, test bullets per slice, explicit "not
   behaviour-neutral" callouts where the event stream changes.
7. **Verify** — run the checklist in [reference.md](reference.md#verification).

Do not duplicate AGENTS.md or combat-core prose; link out. Do not implement the
feature in this skill unless the user asks separately.

## Renames and moves (`git mv`)

Any time this work **renames or relocates a tracked file** (spec under
`docs/technical/`, or code while landing §16), use **`git mv`** — never copy +
delete, never plain `mv` outside git, never recreate the file at a new path and
remove the old one.

- One rename: `git mv path/old.rs path/new.rs`
- Module directory move: `git mv features/effects features/effect` (then fix
  `mod.rs` / imports).
- Replacing an obsolete spec: `git mv docs/technical/old.md docs/technical/new.md`
  when the content is the successor, not a parallel doc.

In §0 and §16, call out renames as **`git mv`** paths so implementers preserve
history. If the user only asked for the markdown contract, still write slices
that way; when you also implement, run `git mv` yourself before editing content
at the new path.

## Relationship to other skills

| Skill | When |
|---|---|
| `grill-me` | Before this skill; resolves the decision tree |
| `handoff` | Short-lived continuation notes; **not** a substitute for this contract |
| `explain-in-details` | Walks **landed** code; this doc may describe **planned** APIs |

## Examples

**Trigger:** "We finished grilling statuses — write the spec like effect-system."

**Do:** `docs/technical/status-system.md` with §0–§18 analogues, all agreed
`StatusId` / mutation snippets from chat, slice list ending in UI + headless smoke.

**Don't:** A bullet PRD, a plan in chat only, or paraphrased structs that drift
from what was agreed in grilling.
