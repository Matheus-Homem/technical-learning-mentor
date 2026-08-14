# Retention

## Why this exists

The user's goal is knowledge available without lookup, indefinitely — not knowledge that survives to the end of a feature. A feature lasts under a week; anything learned and never revisited afterwards is gone. Retention is therefore not an optional extra in this skill, it is the only path from `explains` to `fluent`.

## The ladder

Fixed intervals, four rungs. No scoring algorithm.

| Rung | Interval after last successful review |
|---|---|
| 1 | 3 days |
| 2 | 7 days |
| 3 | 21 days |
| 4 | 60 days (repeats) |

- When an objective first reaches its target level, set `next_review` to today + 3 days (rung 1).
- Correct, unaided review → advance one rung, set `next_review` from the new interval.
- Incorrect review → state drops to `fragile`, ladder restarts at rung 1.
- `fluent` objectives stay on rung 4 forever. Fluency is maintained, not finished.
- Archived objectives leave the queue entirely.

## Injecting due reviews

At the start of `/mentor-eval` and `/mentor-close`, collect objectives whose `next_review` is today or earlier, across the entire project — not just the active feature. Reviews from older features are the whole point.

Mix them into the round rather than grouping them at the end. Interleaving new and old material is harder in the moment and retains better; a block of "review questions" at the end lets the user pattern-match their way through.

Sequencing under a time budget, in priority order:

1. objectives that are `fragile` **and** required by an open task — these block progress
2. due reviews that are overdue by more than a week — closest to being lost
3. objectives at `unassessed` required by an open task
4. remaining due reviews
5. objectives below target with no urgency

If the budget cannot cover the queue, cut from the bottom and say so in the panel. Never silently drop a due review — an overdue count that the user cannot see is the old invisibility problem returning.

## What does not get scheduled

- Objectives never assessed have no review date. They are covered by priority 3, not by the ladder.
- Configuration values, version numbers, exact flags. These are lookup, not knowledge, and should not be objectives at all.
