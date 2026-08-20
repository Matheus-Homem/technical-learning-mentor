# Design pairing

Installed by the `technical-learning-mentor` skill. This file governs the **DESIGN phase of any spec-driven workflow in this repository**, not just that skill's own commands.

## The invariant

**The DESIGN phase is never fully automated.** It is paired with the user.

Analysing the feature, proposing a structure, and proposing a task list are all things to do on your own. Deciding them is not. Between the proposal and the artifact there are two stop points, and both belong to the user.

This is not a style preference. A design document that already names the classes has pre-decided the exact thing the user was going to reason through, and it does it silently — the file simply exists, and by the time anyone reads it the decision looks settled. The cost is invisible at the moment it is paid, which is why it needs a rule rather than good intentions.

## The handshake

1. **Analyse** the feature — requirements, constraints, what already exists in the repo.
2. **Propose** the structure: the components, where they live, what each is responsible for, what depends on what. As a proposal, in the conversation.
3. **Propose** the task list. Also in the conversation.
4. **The user reviews** the structure.
5. **STOP POINT 1 — the user approves or changes the structure.**
6. **STOP POINT 2 — the user approves the task list.**
7. Only now write the design artifact and proceed to execution.

Steps 1–3 are yours. Steps 4–6 are the user's. Step 7 is unlocked by step 6, never by step 3.

## What the stop points require

An **affirmative response from the user**, in the conversation, after the proposal was shown.

These are not approvals:

- silence, or the user saying nothing and the turn continuing;
- "looks good" inferred from context, from an earlier message, or from the user having approved something else;
- the user approving the structure (step 5) — that does not approve the task list (step 6);
- your own assessment that the proposal is obviously correct;
- the user being in a hurry, or the feature being small.

If you are unsure whether something was an approval, it was not one. Ask.

Present each stop point as a question and end your turn there. Do not present the proposal and continue writing in the same turn — a stop point that does not stop is not a stop point.

## What counts as a design artifact

Any file a planning or spec-driven workflow writes during a design/plan phase that fixes **structure**:

- names of classes, modules, services, or components;
- where they live in the tree;
- their responsibilities, methods, or public surface;
- the task list a later execution phase will work through.

Defined by what the file *does*, not by its name. No filename is assumed here — `design.md`, `plan.md`, `architecture.md`, `tasks.md`, or anything else a given workflow happens to use. If a file being written fixes any of the above, it is a design artifact and it is behind the gate.

Writing notes, scratch, or analysis to a file is not affected. The gate is on **fixing structure**, not on writing.

## What is not behind the gate

Mechanical surface passes through with no elicitation:

- library or dependency choice;
- the shape of a configuration file;
- a layout already conventioned elsewhere in this project;
- an integration contract other components must already conform to.

The test is the same one used throughout the mentor skill: **does this encode a trade-off the user needs to be able to navigate, or is it lookup and plumbing?** Trade-off → gate. Plumbing → proceed.

A public interface that other components must integrate against can legitimately stay fixed even when everything behind it is open. Fixing an integration contract is not the same as fixing the internal design.

## Skipping the gate

The user may skip it. It is their project.

But it happens **out loud, and only on their word**:

- say plainly that the gate is being skipped and what that means for this feature;
- record it in the design artifact itself — one line, dated;
- never skip it because the feature looks small, because the design looks obvious, because the user seems to be in a hurry, or because they skipped it last time.

Skipping is a decision the user makes once, for one artifact. It is never a mode you enter.

## Coexistence

This file only adds a gate. It defines no command, overrides no other skill's instructions, and names no specific workflow. Any spec-driven skill installed in this repository keeps its own procedure — it just cannot complete its DESIGN phase without the two approvals above.
