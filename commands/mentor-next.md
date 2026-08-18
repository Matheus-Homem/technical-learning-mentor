# /mentor-next

**Run any time you want the full remaining picture, or right after finishing something, before picking up the next piece.** Read-only about the codebase; the only write is syncing the task file's checkbox state to reality. No questions asked — it does not touch `study_hours_total`, and it never touches `knowledge.md`/`evidence.jsonl` (that boundary belongs to `/mentor-review`, not this command — see below).

`/mentor-next [feature-slug] [--all]`

Answers "what's left to finish this feature," without assuming which spec-driven skill produced the task list. Two things in one call:

1. **Sync** — for every task/checkbox currently open in the resolved task file(s), independently verify against the real code/tests whether it's actually still open, and flip it closed if it isn't. Never trust the file's own prose as proof.
2. **Show** — display everything still open, grouped the way the source file already groups it, in full — not just the single next item.

This is a project-status utility, not an assessment instrument. It makes no judgement about the user's understanding and writes no evidence.

## Locating the task file(s)

1. Resolve `spec_artifacts` from `.mentor/profile.md`, same as every other command (`SKILL.md` "Locating the spec artifacts" — never hardcode a filename or a specific spec-driven skill's structure).
2. Within the resolved paths, find the file(s) carrying a real task checklist: markdown checkbox syntax (`- [ ]` / `- [x]`, plus any local variant already in use, e.g. a deliberately-deferred marker). Do not assume a filename like `tasks.md` — that's one project's convention, not a universal one.
3. Nothing matches → say so plainly and ask the user to point at the right file, same fallback as `/mentor-map` re-asking for `spec_artifacts`. Do not guess or fabricate a task list.
4. `[feature-slug]` given → resolve that feature's artifacts instead of the active one; otherwise use `profile.md`'s `active_feature`.

## Step 1 — Sync: verify every open item

For every unchecked line found:

1. Read the task/section it belongs to in full — title, description, acceptance criteria, and any stated verification method (a gate/test command, a "how to verify" note, a file path). Different spec-driven skills phrase this differently; use whatever the file actually provides.
2. Independently verify — never take the file's own prose as proof:
   - A runnable check is named → run it.
   - Otherwise, read the referenced source/test files directly. When the check is behavioral and nothing already tests it, write a small read-only repro (throwaway script or REPL snippet) to observe the actual behavior.
   - Never write or propose anything that edits the user's production or test code as a side effect of this command.
3. Classify:
   - **Confirmed done** → flip `- [ ]` to `- [x]`, with a short inline note in whatever annotation style the file already uses. Don't invent a new format for a project that has none.
   - **Still open or partially done** → leave unchecked; if verification surfaced something the file didn't already say, note it the same way.
   - **Deliberately deferred** (the user explicitly chose not to fix something now) → use the file's own "deferred" convention if one exists; never silently mark it as unconditionally done.
4. Never write implementation or test code to make an item pass — this command diagnoses, it does not deliver (`references/code-policy.md`'s "Never" list applies here too: a checkbox flipped to look better than reality is the same authorship violation in a different disguise).
5. Save the file touching only checkbox states and their inline notes — never rewrite surrounding prose, renumber tasks, or touch anything Step 1 didn't actually verify.

## Step 2 — Show: the remaining-scope list

1. Re-read the file after syncing.
2. Render every task/section not fully closed, preserving the source file's own grouping and ordering/dependency notes.
3. One line per open item: what it is, its real status (not started / in progress with what's missing / blocked), and its **authorship level** from `map.md` (`own` / `paired` / `deliver`). Call out anything found broken or newly discovered during Step 1.
4. Close with any accepted, deliberately-deferred debt still on the books, so it isn't forgotten.
5. Close with the authorship split across what's still open (`3 own, 1 paired, 4 deliver`). If the remaining work is overwhelmingly `deliver`, say it in one line — what's left is delivery, not learning, and the user should see that while they can still act on it.
6. If any open task has no level row in `map.md`, list them and say that a remap is due (`commands/mentor-map.md`, "Remapping an existing feature"). Do not invent levels here — this command reports state, it does not decide authorship.
7. Do not pick a "do this one next" recommendation beyond what the source file already encodes — the point is the full picture, so the user chooses.

## Boundary with /mentor-review

This command establishes **project state** (is the code objectively done), never **mastery state** (does the user understand it):

- A checkbox flipped here is not evidence of understanding and is never logged to `evidence.jsonl` or reflected in `knowledge.md`.
- If Step 1 verifies meaningful new code as done and it looks like it hasn't been through a review yet (checked against the feature's `map.md`-recorded "Last review point"), say so as a one-line suggestion at the end — offer once, never block on it, same discipline as `SKILL.md` Core rule 6.

## Optional arguments

- `/mentor-next --all` — also show already-closed tasks (full listing), not just what's open. Mirrors `/mentor-progress --all`.
- `/mentor-next <feature-slug>` — target a feature other than `active_feature`.
