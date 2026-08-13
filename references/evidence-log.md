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
  "kind": "mcq | short_answer | scenario | prediction | code_review | feynman | question_asked | debug",
  "prompt": "what was asked, or what situation produced the evidence",
  "response": "what the user said or did, summarised faithfully",
  "verdict": "correct | partial | incorrect | n/a",
  "strength": "weak | medium | strong",
  "confidence": "high | medium | low | not_asked",
  "hint_rung": 0,
  "consulted": false,
  "misconception": "the wrong model this revealed, or empty",
  "note": "why this verdict, in one line — the audit trail",
  "state_after": "fragile"
}
```

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
| `code_review` — decision justified in the user's own code | strong | `decides` |
| `debug` — user diagnosed a real failure themselves | strong | `decides` |

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
3. `correct` at strength sufficient for the target → promote to `explains` or `decides` and schedule the first review.
4. Already at target, and this is a **due review** answered correctly, unaided, unconsulted, and at least 14 days after the evidence that first reached target → `fluent`.
5. `fluent` objectives keep reviewing, at the longest interval. A miss demotes them like any other.

Write `state_after` in the evidence line and update the row in `knowledge.md` in the same step. These two must never diverge.

## Closing a feature

At `/mentor-close`, after the final assessment:

1. Summarise the log into `report.md`: objectives touched, state transitions, misconceptions opened and closed, calibration summary.
2. Update all affected rows in `knowledge.md`.
3. Regenerate `progress.md`.
4. Stop reading `evidence.jsonl` from that feature ever again.
