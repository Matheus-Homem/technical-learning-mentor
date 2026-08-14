# /mentor-close

**Run when the user considers the activity finished, before moving to the next spec cycle.**

This is the consolidation ritual and the pedagogical centre of the skill. Target time: 10–15 minutes. If the budget is tight, cut the scenario count — never cut the write-back.

## Steps

**1. Load context.** `profile.md`, `knowledge.md`, the feature's `map.md` and full `evidence.jsonl`.

**2. Feynman explanation.**
Follow the protocol in `references/teaching.md`. Ask the user to explain what they built and why, as if teaching someone who knows the language but not the tools. **Do not interrupt.** Note gaps while listening, then report them one at a time, asking the follow-up rather than closing the gap yourself.

Cover-check afterwards: which objectives from `map.md` never came up? Raise them explicitly — forgetting an objective while explaining your own feature is evidence.

**3. Decision scenarios.**
Two or three, for objectives whose target is `decide`. Change a condition and ask what they would do and what breaks if they don't:

> If `<load / volume / failure mode / requirement>` changed, what would you change here, and what breaks if you leave it as is?

Ask for confidence before responding to each. This is the only part of the round that can promote an objective to `decides`.

**4. Due reviews.**
Inject anything due from `references/retention.md`, interleaved. These are what turn earlier features' knowledge into `fluent`.

**5. Judge and record.** Evidence lines for everything, per `references/evidence-log.md`.

**6. Close the feature.**
- Write `report.md` from the template: objectives touched, transitions, misconceptions opened and closed, calibration summary, what carries into the next feature.
- Update every affected row in `knowledge.md`, including `next_review`.
- Regenerate `progress.md`.
- Mark the feature closed in `map.md`. From here, its `evidence.jsonl` is never read again.

**7. Handle a pivot.** If the project direction changed and objectives are no longer required, archive them (`archived:` prefix). Keep evidence and history. Never delete a row.

## Closing message

Show the user:

- what moved to or past target this feature, and on what evidence
- what is still `fragile` and will follow them into the next feature
- misconceptions that are now closed — this is progress and is otherwise invisible
- anything approaching `fluent`, with the date it becomes eligible
- the calibration line if high-confidence errors clustered anywhere

This message is the answer to the question that broke the previous version: *what did I actually learn here?*
