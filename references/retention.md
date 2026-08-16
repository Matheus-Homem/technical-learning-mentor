# Retention

## Why this exists

The user's goal is knowledge available without lookup, indefinitely — not knowledge that survives to the end of a feature. Retention is the only path from `explains` to `fluent`. But the *pace* at which a project is worked varies enormously: a two-week study sprint at 8+ hours a day looks nothing like a routine of one hour a day afterwards. A model built around a single interval schedule gets one of these regimes wrong.

## No scheduled review date

There is no `next_review` field anywhere in this skill. A predicted date is derived state computed from an assumed cadence; the moment the cadence changes — sprint ends, routine begins, a week gets skipped — the stored date is silently wrong and nothing corrects it.

Instead, `knowledge.md` stores two **observed** facts per objective, updated every time evidence is logged:

- `last_seen` — the calendar date of the most recent evidence
- `last_seen_hours` — the cumulative study-hours count (from `profile.md`) at that moment

Nothing is predicted. Everything is measured after the fact, and the decision of what to review is made fresh, every time a command runs, from these two numbers plus the current values.

## The dual clock

At the start of any command that might review something (`/mentor-eval`, `/mentor-close`), ask the user how much they have studied since the last session, and add it to `study_hours_total` in `profile.md`. One question, a few seconds.

Then, for each objective, compute two deltas:

- **calendar delta**: today minus `last_seen`
- **exposure delta**: `study_hours_total` now minus `last_seen_hours` at last evidence

An objective is due when **either** delta crosses its threshold — whichever comes first.

| Position on ladder | Exposure threshold | Calendar threshold |
|---|---|---|
| 1st review | ~3h | ~3 days |
| 2nd review | ~10h | ~7 days |
| 3rd review | ~30h | ~21 days |
| 4th+ review | ~80h | ~60 days |

Position on the ladder is derived by counting successful reviews already logged for that objective — not stored as a separate counter that can drift.

Why two clocks: in a dense sprint, 3 calendar days is 24 working hours — far too coarse, so the exposure clock fires first and correctly resurfaces this morning's material this afternoon. In a 1h/day routine, 3 days is 3 hours of total exposure — far too tight, so the calendar clock fires first, correctly treating forgetting (not dilution) as the risk. The same table produces the right behaviour in both regimes, and in the transition between them, without any mode switch or configuration.

These numbers are a **default for judgement, not a rule to execute mechanically**. Treat them as "objective becomes a candidate for review around here" — then prioritise using the queue order below, and let evidence adjust it: an objective with a high-confidence wrong answer in its history should come back sooner than the table suggests; one with a clean, unaided correct answer can wait longer than the table suggests.

## Injecting due reviews

At the start of `/mentor-eval` and `/mentor-close`, compute both deltas for every active (non-archived) objective in the project — not just the active feature. Reviews from older, closed features are the whole point of this mechanism; that is why `knowledge.md`, unlike the per-feature evidence logs, is read across the whole project.

Mix due reviews into the round rather than grouping them at the end. Interleaving new and old material is harder in the moment and retains better; a block of "review questions" tacked onto the end lets the user pattern-match their way through instead of actually retrieving.

Sequencing under a time budget, in priority order:

1. objectives that are `fragile` **and** required by an open task — these block progress right now
2. the limiting objective for the current feature, if one is marked and not yet at target
3. due reviews overdue by a wide margin on either clock — closest to being lost
4. objectives at `unassessed` required by an open task
5. remaining due reviews
6. objectives below target with no urgency

If the budget cannot cover the queue, cut from the bottom and say so explicitly in the panel. Never silently drop a due review — an overdue count the user cannot see is the exact invisibility problem this skill exists to fix.

## What does not get scheduled

- Objects with no evidence yet have no review to compute — they are covered by priority 4, not by this mechanism.
- Delegate-bucket items (see `worked-examples.md`) are not objectives and are never scheduled for review.
