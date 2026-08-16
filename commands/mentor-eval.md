# /mentor-eval

**Run at the start of a study session, or any time an assessment round is wanted outside the fixed checkpoints.** This is the skill's spaced-retrieval instrument — its job is to resurface what is due, not to introduce large amounts of new material.

Accepts a time budget: `/mentor-eval --time 5|15|30` (minutes). Default is `default_eval_budget` in `profile.md`.

## Item counts by budget

| Budget | Items | Typical mix |
|---|---|---|
| 5 min | 3–4 | almost entirely due reviews |
| 15 min | 6–8 | due reviews, 1 scenario, a couple of short answers |
| 30 min | 10–14 | due reviews, 2–3 scenarios, limiting-objective drill if one is marked |

MCQ is the cheap instrument for checking material already learned through a stronger format. It never supports `decides` and should never be the backbone of a round.

## Steps

**1. Ask for study hours since last session** and add to `study_hours_total` in `profile.md`. This drives the exposure clock — do this before computing anything else.

**2. Load context.** `profile.md`, `knowledge.md` (whole project, not just the active feature — due reviews from closed features matter here), the active feature's `map.md`.

**3. Compute due reviews.** For every active objective, per `references/retention.md`: calendar delta from `last_seen`, exposure delta from `last_seen_hours` vs. the new `study_hours_total`. Due if either crosses its threshold.

**4. Build the queue** using the priority order in `references/retention.md`. If the active feature has a marked, not-yet-at-target limiting objective, and the budget allows, dedicate a block to drilling it specifically — repeated scenarios, varying conditions — rather than folding it into the normal rotation.

**5. Ask one item at a time.** Wait for the answer before showing the next. Before revealing any verdict, ask for confidence (high/medium/low).

Rephrase returning objectives — never repeat a previous wording verbatim; check the evidence log.

**6. Judge** per `references/judging.md`. Judge the reasoning, not just the conclusion. If an answer is right but thin, ask once for the reason before recording.

**7. Append evidence** — one line per objective touched, `note` filled, `study_hours_total` set. Update `knowledge.md`: `state`, `evidence`, `last_seen`, `last_seen_hours` in the same step.

**8. Regenerate `progress.html`** and show the delta section.

## Closing message

End with what changed, not with a score:

- state transitions produced by this round, in both directions
- misconceptions opened or closed
- calibration note if any high-confidence answers were wrong
- if the limiting objective was drilled, whether it moved
- the one thing to work on before the next round, and why

Never report a percentage or a grade.
