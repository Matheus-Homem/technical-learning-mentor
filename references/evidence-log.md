# Evidence log

## File

`.mentor/features/<slug>/evidence.jsonl` — one JSON object per line, **append only**.

Never rewrite the file, never reformat it, never delete lines. A rewritten log is a corrupted log: the whole point is that the record of what happened cannot be silently edited later. Corrections are new lines, not edits.

Read the active feature's log in full at the start of any command. Never read a closed feature's log.

## Schema

```json
{
  "id": "E-014",
  "ts": "2026-08-12T14:30:00Z",
  "objective": "K-07",
  "kind": "mcq | short_answer | scenario | out_of_project_scenario | prediction | code_review | feynman | feynman_rejection | question_asked | debug | example",
  "prompt": "what was asked, or what situation produced the evidence",
  "response": "what the user said or did, summarised faithfully",
  "verdict": "correct | partial | incorrect | n/a",
  "strength": "weak | medium | strong",
  "confidence": "high | medium | low | not_asked",
  "hint_rung": 0,
  "consulted": false,
  "misconception": "the wrong model this revealed, or empty",
  "note": "why this verdict, in one line — the audit trail",
  "state_after": "fragile",
  "study_hours_total": 34.5
}
```

`study_hours_total` is the value of `profile.md`'s cumulative counter at the moment this evidence was logged. It is what lets `knowledge.md`'s `last_seen_hours` field be set correctly, and it is what the dual-clock retention model in `references/retention.md` runs on. Always populate it — asking the user "how long have you studied since last time?" at the start of a command and adding it to the running total is a required step, not optional bookkeeping.

Field notes:

- `hint_rung` — how much help was needed before the user got there (see the hint ladder in `judging.md`). `0` means unaided. High rungs cap strength.
- `consulted` — whether the user looked something up. Required for the `fluent` decision; `true` disqualifies the evidence from counting toward `fluent`.
- `confidence` — what the user declared *before* seeing the verdict. `not_asked` when it wasn't collected.
- `note` — always fill it. This is what makes a verdict contestable and reviewable months later.
- One line per objective touched. If one answer spans three objectives, write three lines.

## Evidence strength ordering

From weakest to strongest:

| Kind | Strength | Can support up to |
|---|---|---|
| self-report in triage | — | `declared` only |
| `question_asked` (user asked about it) | weak | evidence of a gap; never promotes |
| `mcq` correct | weak | `explains` |
| `short_answer` correct | medium | `explains` |
| `prediction` correct before running | medium | `explains` |
| `feynman` explanation with no gaps | strong | `explains` |
| `scenario` decision correctly justified | strong | `decides` |
| `out_of_project_scenario` — decision correctly justified under conditions unlike the user's own project | strong | `decides`, and is the strongest available signal of transfer rather than familiarity with the project's specific instance |
| `code_review` — decision justified in the user's own code | strong | `decides` |
| `code_review`, rejected-alternative form — user explains why the option *not* chosen would have been worse | strong | `decides` |
| `debug` — user diagnosed a real failure themselves, and can state what mental model was wrong beforehand | strong | `decides` |
| `feynman_rejection` — user explains, unaided, why a plausible alternative approach would have been worse | strong | `decides` |
| `example` — a `/mentor-class` interaction | n/a for mastery | never promotes an objective; see `classes.md`. The kind name is historical and kept unchanged so existing logs stay valid. |

Rules that follow from this:

- Multiple choice has a floor of ~25% correct by guessing. It never supports `decides`, no matter how many are answered.
- Weak evidence does not accumulate into strong evidence. Two correct MCQs is not one justified decision.
- `hint_rung >= 2` downgrades strength by one level. `hint_rung >= 3` caps the evidence at `weak`.
- `consulted: true` downgrades strength by one level and blocks any contribution to `fluent`.
- An `incorrect` verdict at any strength sets the objective to `fragile` and, if a wrong model was visible, opens a `misconception`.

## Promotion decision

After appending evidence, recompute the objective's state:

1. Any `incorrect` in this evidence → `fragile`, open the misconception, restart the review ladder.
2. `partial` → keep the current state, but open or keep the misconception, and shorten the next review.
3. `correct` at strength sufficient for the target → promote to `explains` or `decides`.
4. Already at target, and this is a **due review** (per `references/retention.md`) answered correctly, unaided, unconsulted, and at least 14 days after the evidence that first reached target → `fluent`.
5. `fluent` objectives keep reviewing, at the longest interval. A miss demotes them like any other.

Write `state_after` and `study_hours_total` in the evidence line, and update `state`, `evidence`, `last_seen`, and `last_seen_hours` on the row in `knowledge.md` in the same step. These must never diverge — `knowledge.md`'s `last_seen`/`last_seen_hours` should always equal the timestamp and `study_hours_total` of the most recent evidence line referenced in its `evidence` column.

There is no review date to schedule here — see `references/retention.md`. Promotion writes state and last-seen facts only; due-ness is always computed fresh, never stored.

## Closing a feature

At `/mentor-close`, after the final assessment:

1. Summarise the log into `report.md`: objectives touched, state transitions, misconceptions opened and closed, calibration summary.
2. Update all affected rows in `knowledge.md`.
3. Regenerate `progress.html`.
4. Stop reading `evidence.jsonl` from that feature ever again.
