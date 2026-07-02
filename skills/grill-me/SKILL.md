---
name: grill-me
description: Interview the user relentlessly about a plan or design until reaching shared understanding, resolving each branch of the decision tree. Use when user wants to stress-test a plan, get grilled on their design, or mentions "grill me".
---

Interview me relentlessly about every aspect of this plan until we reach a shared understanding. Walk down each branch of the design tree, resolving dependencies between decisions one-by-one. For each question, provide your recommended answer.

Ask the questions one at a time.

If a question can be answered by exploring the codebase, explore the codebase instead.

In the start of grilling session ask a user, which format of grilling do they want:
 - **Short**: use `AskQuestion` or any similar tool that available in harness
 - **Detailed**: don't use `AskQuestion` tool, instead output each grilling questions in chat including problem overview, for each suggested solution: [description, code examples, pros, cons] and your final recommendation.
