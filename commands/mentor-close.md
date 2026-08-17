# /mentor-close

**Run when the user considers the activity finished, before moving to the next spec cycle.**

This is the consolidation ritual and the pedagogical centre of the skill. Target time: 10–20 minutes. If the budget is tight, cut the scenario count — never cut the write-back.

## Steps

**1. Ask for study hours since last session** and add to `study_hours_total` in `profile.md`.

**2. Load context.** `profile.md`, `knowledge.md` (whole project), the feature's `map.md` and full `evidence.jsonl`.

**3. Feynman explanation.**
Follow the protocol in `references/teaching.md`. Ask the user to explain what they built and why, as if teaching someone who knows the language but not the tools. **Do not interrupt.** Note gaps while listening, then report them one at a time, asking the follow-up rather than closing the gap yourself.

Cover-check afterwards: which objectives from `map.md` never came up? Raise them explicitly.

**4. Rejected-alternative pass.**
For one or two of the decisions just explained, ask why a plausible alternative was *not* taken. Log as `feynman_rejection`.

**5. Decision scenarios, including one outside the project.**
Two or three, for objectives whose target is `decide`. **At least one must be set outside the user's own project** — a different domain, an opposite requirement:

> If `<load / volume / failure mode / requirement>` changed, what would you change here, and what breaks if you leave it as is?
> In `<a different kind of system>`, where `<a different constraint>` matters, what would you do differently, and why?

The out-of-project scenario is the transfer check: it is the only reliable way to tell whether the principle was learned or only the project's specific instance of it. Ask for confidence before each response. Log the out-of-project one as `out_of_project_scenario`.

**6. Due reviews.**
Inject anything due from `references/retention.md`, interleaved rather than blocked at the end. These are what turn earlier features' knowledge into `fluent`.

**7. Judge and record.** Evidence lines for everything, per `references/evidence-log.md`, `study_hours_total` set on each.

**8. Close the feature.**
- Write `report.md` from the template: objectives touched, transitions, misconceptions opened and closed, calibration summary, Feynman notes including the rejected-alternative pass, the out-of-project scenario result, what was delegated via `/mentor-class` this feature, what carries into the next feature.
- Update every affected row in `knowledge.md`, including `last_seen` / `last_seen_hours`.
- Regenerate `progress.html`.
- Mark the feature closed in `map.md`. From here, its `evidence.jsonl` is never read again.

**9. Handle a pivot.** If the project direction changed and objectives are no longer required, archive them (`archived:` prefix). Keep evidence and history. Never delete a row.

**10. If `prune_closed_features_on_close` is `true` in `profile.md`**, untrack this feature's scratch files from git. Off by default — it fits one specific workflow (feature branches merge into `main` only after `/mentor-close`, always via a real merge commit, never squash) and is not a general-purpose default. If enabled:

a. **Commit the feature's final state first.** `report.md` was just written and has never been committed before this point — it must be captured in git history at least once before being untracked, or its content never actually enters the object database.

   ```
   git add .mentor/features/<slug>/
   git commit -m "chore(mentor): close <slug>

   Co-Authored-By: Claude Opus 5 <noreply@anthropic.com>"
   ```

b. **Untrack the feature's scratch files.** Content stays on disk and stays recoverable via `git log -- <path>` from this commit backward — contingent on the eventual merge into `main` being a real merge, not a squash.

   ```
   git rm -r --cached .mentor/features/<slug>/map.md .mentor/features/<slug>/evidence.jsonl .mentor/features/<slug>/report.md
   ```

c. **Append `features/<slug>/` to `.mentor/.gitignore`**, scoped to this feature only — never a blanket `features/**`, which would block normal tracking during the *next* open feature.

d. **Commit the prune.**

   ```
   git add .mentor/.gitignore
   git commit -m "chore(mentor): stop tracking <slug> scratch files

   Co-Authored-By: Claude Opus 5 <noreply@anthropic.com>"
   ```

Tell the user both commits ran, and that only `profile.md` and `knowledge.md` will carry this feature's `.mentor/` content forward once the branch merges into `main`.

## Closing message

Show the user:

- what moved to or past target this feature, and on what evidence
- what is still `fragile` and will follow them into the next feature
- misconceptions that are now closed
- what's in "awaiting fluency confirmation" and when each becomes eligible — **if this feature is inside a dense study block (several sessions in close succession), say plainly that nothing can reach `fluent` yet, and that this is expected, not a shortfall**
- how the out-of-project scenario went, and what that implies about transfer vs. familiarity
- the calibration line if high-confidence errors clustered anywhere

This message is the answer to the question that broke the previous version: *what did I actually learn here?*
