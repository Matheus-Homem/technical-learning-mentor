# Knowledge registry

<!-- Written in English. One row per learning objective in this project.
     This is the only file that grows for the whole project life.
     Ids are never reused and never renumbered. Rows are never deleted —
     objectives that stop being required get the `archived:` state prefix.
     See references/knowledge-model.md before adding rows.

     Items sorted into the `delegate` bucket at /mentor-map do NOT get a row
     here — they are not learning objectives. See references/worked-examples.md. -->

| id | statement | tags | target | state | evidence | misconception | last_seen | last_seen_hours |
|---|---|---|---|---|---|---|---|---|
| K-01 | <a proposition or a "Given X, decide Y" rule, one sentence> | tag-a, tag-b | explain | unassessed | | | | |

<!-- state: unassessed | declared | fragile | explains | decides | fluent
            prefix with `archived:` when no longer required (archived:explains)

     evidence: comma-separated evidence ids from the feature logs, oldest first.
               Keep them even after the feature is closed — they are the audit
               trail back to report.md.

     misconception: one line, the wrong model currently believed to be open.
                    Cleared only by evidence that contradicts it, not by silence.

     last_seen / last_seen_hours: set from the most recent evidence line's
                    `ts` and `study_hours_total`. There is no stored review
                    date — due-ness is computed fresh every time from these
                    two facts plus the current date and study_hours_total.
                    See references/retention.md. -->

## Limiting objectives by feature

<!-- One line per feature that had a clear limiting objective marked at
     /mentor-map. Optional — not every feature has one. -->

| feature | id | why it's limiting |
|---|---|---|

## Origins

<!-- Optional index mapping objectives back to where the requirement came from,
     when the table row gets too wide to carry it. -->

| id | origin |
|---|---|
| K-01 | <task id / design section / file path / `emergent`> |
