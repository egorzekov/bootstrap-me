---
name: cursor-review
description: Sends a review request to a Cursor AI agent and summarizes the feedback with validity ratings. Use when you want an independent model to review a plan, implementation, architecture, or security posture.
---

# Cursor Review

## Overview

The **parent agent** collects inputs (Steps 1–2), spawns a **review subagent** to run `cursor-agent (CLI)` and block until the output file exists (Step 3), then the **parent agent** reads that file and writes the summary (Steps 4–5).

**Announce at start:** Say "I'm using the cursor-review skill to get an independent review." once per review run, at the first message where you begin Step 1 or Step 2. If the user already specified model/type/target in the same turn, skip re-asking but still announce once before Step 3.

---

## Step 1: Choose Model

If the model is not specified in the latest user message, ask once using `AskQuestion` with exactly these three options:

1. **composer-2.5** (default)
2. **gpt-5.3-codex-high**
3. **gpt-5.5-high**

Default to `composer-2.5` when the user does not name a model in their message and does not select an option after a single prompt.

If `cursor-agent (CLI)` later fails with an unknown-model error, show the error, re-prompt once with the same three options, then stop if it fails again.

---

## Step 2: Choose Review Type

If the review type is explicit in the user message, map it to the nearest template (plan → `challenge-plan`, code → `implementation`, arch → `architecture`, security → `security`) without asking. Otherwise ask once using `AskQuestion`:

1. **Challenge plan** — stress-test an implementation plan for ordering, gaps, and bad assumptions
2. **Implementation** — review code for bugs, patterns, and simplification opportunities
3. **Architecture** — challenge architectural decisions for scalability, coupling, and trade-offs
4. **Security** — surface vulnerabilities, misconfigurations, and trust-boundary violations

Collect **review type first**, then **target**. If both are missing you may combine into one question. Target must be exactly one of:
- **(a)** workspace-relative or absolute file path
- **(b)** directory path
- **(c)** pasted text (label it `PASTED_CONTENT` in the prompt body)

If the user references content already visible in context (e.g. a skill or doc they pasted), use that as `PASTED_CONTENT` without re-asking.

If the user describes something other than the four types above, craft a custom prompt using the same structure as the templates below: open with `Return ONLY a bulleted list of findings — no praise, no summary paragraphs.`, list the same per-finding bullet fields, and end with a `Focus on:` line.

---

## Prompt Templates

**Target substitution rules:**
- File or directory path → `Review … at <absolute-path>` / `Review all code under <absolute-dir>/`
- Pasted content → `Review the following:\n\n<paste>` (do not use "at `<target>`")

### challenge-plan
```
Review the implementation plan at <target>.

Return ONLY a bulleted list of findings — no praise, no summary paragraphs. Group findings under three headings in this order: ### Blocker, ### Critical, ### Normal. For each finding include:
- The specific task or step number it applies to
- What the problem is (ordering issue, missing edge case, placeholder, type mismatch, untestable step, etc.)
- A concrete suggestion to fix it

Focus on: task ordering and dependencies, missing edge cases, vague/placeholder steps, type/method name consistency across tasks, and whether test steps are actually testable as written.
```

### implementation
```
Review the code at <target>.

Return ONLY a bulleted list of findings — no praise, no summary paragraphs. Group findings under three headings in this order: ### Blocker, ### Critical, ### Normal. For each finding include:
- File and line number (if applicable)
- Category: bug / simplification / pattern violation / performance / readability
- What the problem is and a concrete fix

Focus on: correctness bugs, unnecessary complexity, repeated logic that could be extracted, off-by-one errors, and misuse of language idioms.
```

### architecture
```
Review the architecture described in <target>.

Return ONLY a bulleted list of findings — no praise, no summary paragraphs. Group findings under three headings in this order: ### Blocker, ### Critical, ### Normal. For each finding include:
- The component or decision it applies to
- The risk: tight coupling / scalability ceiling / single point of failure / hidden dependency / etc.
- A concrete alternative or mitigation

Focus on: component boundaries, data flow, failure modes, coupling, and assumptions that may not hold under load or future requirements.
```

### security
```
Review <target> for security issues.

Return ONLY a bulleted list of findings — no praise, no summary paragraphs. Group findings under three headings in this order: ### Blocker, ### Critical, ### Normal. For each finding include:
- Location (file/component/boundary)
- Vulnerability class (injection / broken auth / insecure defaults / trust-boundary violation / etc.)
- Concrete remediation step

Focus on: input validation, authentication/authorization gaps, secrets in code or config, insecure defaults, and trust-boundary violations.
```

---

## Step 3: Spawn Review Subagent

Prepare paths (compute `DATE` once):

```bash
DATE=$(date +%Y-%m-%d)
SLUG="<slug>"   # up to 5 hyphenated tokens from target basename, lowercase [a-z0-9-] only
PROMPT_FILE="/tmp/cursor-review-$DATE-$SLUG.prompt.txt"
OUT_FILE="/tmp/cursor-review-$DATE-$SLUG.md"
```

Write the final prompt text to `$PROMPT_FILE`, then dispatch a **review subagent** (haiku model, to keep cost low) with the instruction to run:

```bash
cursor-agent --model <model> -p "$(cat $PROMPT_FILE)" > $OUT_FILE 2>&1
```

The **review subagent** runs the bash block and returns the output file path and exit code. The **parent agent** must `Read` that path and perform Steps 4–5.

**Success condition:** exit code 0 **and** file size > 200 bytes **and** content does not match `/command not found|not logged in|unknown model/i`.

**Step 3b — On failure:** If the success condition is not met, paste the last 30 lines of `$OUT_FILE` in a `### Cursor Agent Errors` block, report the exit code, and stop. Do not fabricate findings. Offer to retry with a different model or narrower target.

Once the command exits successfully, notify the user:

> "Cursor agent finished. Output saved to `/tmp/cursor-review-$DATE-$SLUG.md`"

Then read the file and proceed to Step 4.

---

## Step 4: Analyze and Output Summary

Before categorizing findings, `Read` every file path included in the review target (or use the pasted content directly). Each categorization must cite evidence — quote or line reference — from the target or agent output.

Treat each top-level `-` bullet (or numbered item) in the agent output as one finding; sub-bullets are continuations of the same finding.

Produce a structured summary under these headings:

### Cursor Agent Raw Feedback
> (paste the full verbatim output from the agent; if `$OUT_FILE` contains stderr errors, paste them under `### Cursor Agent Errors` instead and skip finding-by-finding analysis)

### Analysis

For each finding from the agent, categorize it as one of:

- **Valid — propose fix:** The finding is correct and actionable. Describe the change that will be made (no edits yet — edits happen only after Step 5 approval).
- **Valid — noted, no change:** The finding is correct but out of scope, already handled, or a deliberate trade-off. Explain why no change is needed.
- **Invalid:** The finding is factually wrong, based on a misread, or not applicable. Explain why clearly and briefly.

### Feedback Quality Score: N/10

Rate the overall quality of the cursor agent's feedback on a 0–10 scale:
- **8–10:** Mostly actionable, specific, correctly identifies real issues
- **5–7:** Mixed — some useful findings, some noise or vague suggestions
- **3–4:** Mostly noise, hallucinated issues, or missed the main problems
- **0–2:** Off-topic, wrong model of the codebase, or no useful signal

Justify the score in one sentence.

---

## Step 5: Confirm Fixes

Ask: **"Should I apply the 'propose fix' items now?"**

If yes, apply only changes that touch paths within the review target (or lines explicitly cited in findings). Do not modify unrelated files. Confirm each change made.
