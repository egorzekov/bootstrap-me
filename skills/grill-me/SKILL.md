---
name: grill-me
description: Interview the user relentlessly about a plan or design until reaching shared understanding, resolving each branch of the decision tree. Use when user wants to stress-test a plan, get grilled on their design, or mentions "grill me".
---

Interview me relentlessly about every aspect of this plan until we reach a shared understanding. Walk down each branch of the design tree, resolving dependencies between decisions one-by-one. For each question, provide your recommended answer.

**IMPORTANT:** Ask the questions one at a time.

If a question can be answered by exploring the codebase, explore the codebase instead.

## Format

Always use the detailed format. Do NOT use `AskQuestion`, `AskUserQuestion` or any similar tool. Output each question directly in chat, following the template below, and wait for my answer before moving on.

### Progress line (required)

Every question starts with a progress line, before anything else. Estimate the remaining grilling honestly and update it each time:

`Grilling progress: Question N of ~M · Branch: <current branch of the decision tree> · Resolved: X · Open: Y`

- `~M` is your current best estimate of the total questions, and it may change as answers open or close branches. Say so briefly when it changes.
- `Resolved` and `Open` count decision branches, not questions.

### Question template

```markdown
**Grilling progress:** Question N of ~M · Branch: <branch> · Resolved: X · Open: Y

## Q<N>: <short question title>

### Problem overview
<What decision is needed, why it matters, and what depends on it. Reference what we already decided and any relevant findings from the codebase.>

### Option A: <name>
- **Description:** <what it is and how it works>
- **Example:**
  ```<lang>
  <code, config or pseudo-code showing the option>
  ```
- **Pros:** <bullets>
- **Cons:** <bullets>

### Option B: <name>
<same structure as above>

<more options if needed; at least two>

### Recommendation
<Which option you pick and why, including the trade-off you are accepting. State which assumptions would change your answer.>

**Your call:** <the specific thing you need me to answer, e.g. "A, B, or something else?">
```

### Rules

- Every option gets all four parts: description, code example, pros, cons. Skip the code example only when the option has no meaningful code, and say why.
- Always end with a clear recommendation, never a neutral list.
- One question per message. No batching.
- When no questions are left, show `Grilling progress: complete` and a short summary of every decision made.
