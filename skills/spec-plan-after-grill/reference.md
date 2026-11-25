# Spec plan template (effect-system spine)

Mirror [`effect-system.md`](../../../docs/technical/effect-system.md). Section numbers
are stable anchors for "see §N" cross-references inside the doc.

## Opening block (before §0)

```markdown
# <Feature> system

Contract for <one sentence scope>. **Status: <planned | partially landed | landed>.**
<One sentence: decided in design session / updated when>. Implement it as written;
if a rule here conflicts with code you find, stop and ask.

Related: [<other>.md](<other>.md) (<why linked>), ...

<Optional: one-line design direction or north star (game feel, WoW vs PoE, etc.).>
```

## Section map

| § | Title | Purpose |
|---|---|---|
| 0 | Renames and reversals | Table: old docs/comments → new names; "do not follow old names". For file paths, note **`git mv`** source → destination |
| 1 | Module layout | `text` tree, one type per file; wiring snippets (`DefCatalogs`, etc.); dependency direction + accepted mutual edges |
| 2–N−3 | Domain topics | Ordered by dependency (classify → defs → instances → clock → triggers → tasks → nodes → mutations/events → edge cases). Each topic: rules, tables, **agreed rust** |
| … | Playback and UI | Only if combat/campaign emits recorded events; frame fields, batch boundaries |
| 16 | Landing order | Vertical slices; behaviour-neutral first; per-slice bullets + **Tests:** list with observable assertions |
| 17 | Deferred (do not build with this) | Table: item → why waiting |
| 18 | Rejected alternatives | Table: option → why not (include options discussed in grill, not only loser's list) |

Renumber §2–N freely for the feature; keep **16 / 17 / 18** as landing,
deferred, and rejected unless the doc is tiny (then merge 17–18 but keep the
tables).

## What each topic section should contain

Follow effect-system's rhythm:

1. **Invariant in plain language** (one short paragraph).
2. **Types and signatures** — full agreed structs/enums from the grill; file path
   comment on the fence (`// features/effect/effect_polarity.rs`).
3. **Tables** for classification, content rows, event fields, or pool rules when
   many columns compare.
4. **Cross-refs** — `§6`, `see combat-core`, not vague "elsewhere".
5. **Walkthrough** (optional) — one end-to-end sequence (expand → mutate → event)
   when ordering matters; use numbered substeps like effect-system §10.

### Code example rules (juicing)

- **Source of truth is the grill thread.** Paste agreed blocks; do not silently
  "clean up" APIs the user accepted.
- **Every new public type** introduced in the spec should appear in at least one
  rust fence before implementation slices reference it.
- **Module trees** use ` ```text ` fences; wiring uses ` ```rust `.
- **Tests in slice 16** may include small `test_support` helpers if those were
  agreed in grilling (see effect-system slice 4 snippet).
- Label **sketches** that were exploratory: `// agreed sketch — refine at impl`.
- Do not cite `startLine:endLine:path` for planned code; those citations are for
  `explain-in-details` on landed code. This doc owns the planned API.

### Tables to prefer

| Use case | Columns |
|---|---|
| Rename / reversal | Old \| Now |
| Classification | Effect-like rows × polarity / category / flags |
| Content catalog | Id \| targeting \| action summary \| notes |
| Events / mutations | Variant \| when emitted \| state written |
| Deferred | Item \| Note |
| Rejected | Option \| Why not |

## §16 Landing order

Structure each slice as effect-system does:

```markdown
### Slice k: <name>

- Bullet deliverables (files, arms, catalog rows). File renames as **`git mv`**
  `old` → `new` before content edits.
- **Tests:** observable outcomes; name behaviours, not `is_ok` trivia.
- **Not behaviour-neutral:** (only when true) what changes in the event stream / depth / trace.
```

Rules:

- Slice 1 should be refactor-safe when possible (`cargo test` meaning unchanged).
- Name real test files or patterns (`__tests__/effect_remove.test.rs`).
- Last slice often UI + `godot --headless` smoke when the feature surfaces in combat.
- Call out compile-order deps ("does not compile without X arm").

## §17 Deferred vs §18 Rejected

- **Deferred** — might ship later; not in this implementation pass.
- **Rejected** — considered in grill and explicitly closed; prevents re-litigation.

Both are tables only; no narrative essays.

## Voice and constraints (rust-godot)

- **effect** = buff/debuff content; queued writes = `CombatMutation` (say so if
  the feature touches combat).
- One struct per file; companion enums may share per AGENTS.md.
- Non-kinded vs `kinds/` — state which and why (effect-system §1 pattern).
- Combat: `SeededRng`, no serde on combat types, only `apply_mutation` writes.
- Point implementers at `AGENTS.md` Check list; do not paste the whole checklist.
- **Renames / moves:** always `git mv` (see [SKILL.md](SKILL.md#renames-and-moves-git-mv)).

## Verification

Before handing off the file:

- [ ] Opening status matches repo (`grep` / read modules).
- [ ] Every grill-agreed code block is in the doc (scan chat for ` ``` `).
- [ ] §0 lists reversals against old docs/comments you found in repo.
- [ ] Related links exist and are reciprocal where siblings already link back.
- [ ] No section is prose-only when effect-system would use code for the same idea.
- [ ] §16 slices are ordered; each has test bullets; neutrality called out.
- [ ] §17 and §18 are populated from the grill (empty tables = skill not done).
- [ ] Terminology matches AGENTS.md lifecycle suffixes (`*Def`, `*Data`, `*Instance`).
- [ ] File is self-contained for an implementer who did not attend the grill.
- [ ] Every path rename in §0 / §16 is written as `git mv` (not "rename" in prose only).

## Anti-patterns

- Marketing tone, roadmap dates, or "we might" without landing in §17.
- Duplicating [`combat-core.md`](../../../docs/technical/combat-core.md) queue semantics.
- Slices that say "add tests" without naming what they prove.
- Inventing §18 rows that were never discussed (add only if grill covered them).
- Replacing agreed code with "similar to `Foo`" without the snippet.
- Renaming tracked files with `mv`, copy-delete, or new file + `rm` (use `git mv`).
