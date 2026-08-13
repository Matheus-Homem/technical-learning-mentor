# /mentor-eval

**Run whenever an assessment round is wanted outside the fixed checkpoints** — typically mid-development, once there is a first working attempt.

Accepts a time budget: `/mentor-eval --time 5|15|30` (minutes). Default is the `default_eval_budget` in `profile.md`.

## Item counts by budget

| Budget | Items | Typical mix |
|---|---|---|
| 5 min | 3–4 | mostly due reviews and one gap item |
| 15 min | 6–8 | 1 scenario, 2–3 short answers, the rest reviews/MCQ |
| 30 min | 10–14 | 2–3 scenarios, several short answers, all due reviews |

MCQ is the cheap instrument — use it for reviews and triage, never as the backbone. Remember it cannot support `decides`.

## Steps

**1. Load context.** `profile.md`, `knowledge.md`, the active feature's `map.md` and full `evidence.jsonl`. Do not read closed features' logs.

**2. Build the queue** using the priority order in `references/retention.md`. Interleave due reviews with new material rather than blocking them together.

**3. Ask one item at a time.** Wait for the answer before showing the next. Before revealing any verdict, ask for confidence (high/medium/low).

Rephrase returning objectives. Never repeat a previous wording verbatim — check the evidence log.

**4. Judge** per `references/judging.md`. Judge the reasoning, not just the conclusion. If an answer is right but thin, ask once for the reason before recording.

**5. Append evidence** — one line per objective touched, with `note` filled. Update `knowledge.md` rows and `next_review` dates in the same step.

**6. Regenerate `progress.md`** and show the delta section.

## Closing message

End with what changed, not with a score:

- state transitions produced by this round, in both directions
- misconceptions opened or closed
- calibration note if any high-confidence answers were wrong
- the one thing to work on before the next round, and why

Never report a percentage or a grade. "You got 4 of 5" tells the user nothing they can act on, which is precisely the failure this version exists to fix.
