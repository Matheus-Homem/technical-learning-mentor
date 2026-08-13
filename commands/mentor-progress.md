# /mentor-progress

**Run any time.** Cheap, read-only apart from rewriting the panel. No questions asked.

Regenerates `.mentor/progress.md` from `knowledge.md` plus the active feature, and shows it.

`progress.md` is a rendering, never a source of truth. If it is missing, stale, or was hand-edited, overwrite it without asking.

## Rules

- **Written in Portuguese.** It is the only file in `.mentor/` that is, because it is the one the user reads.
- Never show percentages or grades. States and named evidence only.
- The **"Mudou desde a última interação"** section is the most important part of the file. It is computed against the previous rendering — keep the previous panel's timestamp in the file so the delta can be recomputed. If nothing changed, say so plainly rather than padding.
- Group by tag where it helps, but an objective with several tags appears under each. Do not force a single hierarchy.
- Show overdue reviews with how overdue they are. Never hide the backlog.
- Show the calibration line whenever high-confidence errors have clustered on a tag.
- Keep it scannable. If the project has grown large, show fragile + due + recently changed in full, and collapse the rest to counts per tag.

## Optional arguments

- `/mentor-progress --all` — full listing, no collapsing
- `/mentor-progress --tag <tag>` — only objectives carrying that tag, including archived ones

See `templates/progress.md` for the exact shape.
