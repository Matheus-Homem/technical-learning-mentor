# /mentor-review

**Run after writing a meaningful chunk of code, and at the start of a study session.** In a dense session this happens several times a day; treat it as the default checkpoint between blocks of work, not a once-per-feature event.

`/mentor-review [path] [--time 5|15|30]`

This is the skill's main assessment instrument, and it does two things in one call:

**Part A — the diff pass.** Reviews the code written since the last review point. A decision the user made and can justify **in their own code** is the strongest evidence available for `decides`, and it costs almost nothing because the code already exists.

**Part B — the due-review pass.** Resurfaces what is due across the whole project, per `references/retention.md`. This is the skill's spaced-retrieval mechanism; its job is to bring back what has not been seen in a while, not to introduce large amounts of new material.

Part A has **no time budget** — always run it in full when there is a diff. Part B respects `--time`. Default is `default_review_budget` in `profile.md`.

If there is no pending diff, skip straight to Part B. If nothing is due **and** there is no diff, say so plainly and stop — do not manufacture an item to have something to ask.

This is a review of understanding, not a code review. Style, naming and micro-optimisations are not the point and mostly should not be mentioned.

## Part B item counts by budget

The budget covers Part B only.

| Budget | Items | Typical mix |
|---|---|---|
| 5 min | 3–4 | almost entirely due reviews |
| 15 min | 6–8 | due reviews, 1 scenario, a couple of short answers |
| 30 min | 10–14 | due reviews, 2–3 scenarios, limiting-objective drill if one is marked |

MCQ is the cheap instrument for checking material already learned through a stronger format. It never supports `decides` and should never be the backbone of a round.

## Steps

**1. Ask for study hours since last session** and add to `study_hours_total` in `profile.md`. This drives the exposure clock and stamps every evidence line written below — do it before computing anything else.

**2. Load context.** `profile.md`, `knowledge.md` (the whole project, not just the active feature — due reviews from closed features matter here), the active feature's `map.md` and `evidence.jsonl`.

---

### Part A — the diff

**3. Read the diff.** `git diff` against the last review point recorded in the feature's `map.md`, or the paths given. Record the new reference point in `map.md` so the next review picks up from there.

If there is nothing new, say so in one line and go to step 8.

**4. Map it to objectives.** Which 🎯/📖 objectives from `map.md` does this code exercise? Note also objectives the code *should* have exercised and does not — that gap is worth raising.

**5. Ask, do not tell.** Pick 2–4 decisions visible in the code and ask why. Good shapes:

> Why is this in `<file>` and not `<other file>`?
> What made you choose `<approach>` over `<alternative>`?
> **Why would `<alternative>` have been worse here?**
> If `<condition>` changed, what in here would have to change?

The rejected-alternative question is usually the most informative single item in the review — a shallow-but-correct understanding can defend the choice made far more often than it can attack the option it did not take. Try to include it at least once per review.

Ask one at a time. Wait for each answer. Ask for confidence before responding.

**6. Distinguish three cases**, because they look identical in the code and are completely different as evidence:

| What happened | Verdict | Evidence |
|---|---|---|
| decided deliberately and can justify it | `correct`, strong | supports `decides` |
| it works but the reason given is wrong or absent | `partial` | open a misconception; do not promote |
| copied from a doc, tutorial or example without a model | `n/a` for mastery | log with `consulted: true`; treat as `unassessed`, not as evidence |

The third case is the one that silently inflates every tracking system. Ask directly where something came from when the code looks more confident than the user's understanding of it.

**7. If the diff fixes a real bug**, treat it as `kind: "debug"` evidence: ask what the user believed before the fix and what the failure revealed was wrong about that belief. This is typically the strongest evidence the skill produces — log it even if the rest of the review is brief.

Then give the review feedback — problems that actually matter: correctness, structure, decisions that will hurt later. Under `references/code-policy.md`, describe the change; do not hand back rewritten code.

---

### Part B — due reviews

**8. Compute due reviews.** For every active objective in the whole project, per `references/retention.md`: calendar delta from `last_seen`, exposure delta from `last_seen_hours` vs. the new `study_hours_total`. Due if either crosses its threshold.

Objectives already covered by Part A count as seen — do not ask about them again in the same call.

**9. Build the queue** using the priority order in `references/retention.md`, and cut it to the budget. If the active feature has a marked, not-yet-at-target limiting objective, and the budget allows, dedicate a block to drilling it specifically — repeated scenarios, varying conditions — rather than folding it into the normal rotation.

If the budget cannot cover the queue, cut from the bottom and say what was cut. Never silently drop a due review.

**10. Ask one item at a time.** Wait for the answer before showing the next. Before revealing any verdict, ask for confidence (high/medium/low).

Rephrase returning objectives — never repeat a previous wording verbatim; check the evidence log.

**11. Judge** per `references/judging.md`, in both parts. Judge the reasoning, not just the conclusion. If an answer is right but thin, ask once for the reason before recording.

---

**12. Append evidence, update `knowledge.md`, regenerate `progress.html`.** One evidence line per objective touched, `note` filled, `study_hours_total` set. Update `state`, `evidence`, `last_seen` and `last_seen_hours` in the same step.

## Closing message

End with what changed, not with a score:

- state transitions produced by this call, in both directions
- misconceptions opened or closed
- calibration note if any high-confidence answers were wrong
- if the limiting objective was drilled, whether it moved
- what is still due and was cut for budget, if anything
- the one thing to work on before the next review, and why

Never report a percentage or a grade.
