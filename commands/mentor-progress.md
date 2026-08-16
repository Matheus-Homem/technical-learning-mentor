# /mentor-progress

**Run any time.** Cheap, read-only apart from rewriting the panel. No questions asked — it does not touch `study_hours_total`.

Regenerates `.mentor/progress.html` from `knowledge.md` plus the active feature's `map.md`, and tells the user to open it.

`progress.html` is a rendering, never a source of truth, and is not version-controlled (see `.mentor/.gitignore`). If it is missing or stale, overwrite it without asking.

## Computing the delta without a stored previous render

There is no `progress.md` to diff against anymore. Instead:

1. Read the `<mentor-meta rendered_at="..." study_hours_total="..." feature="..." />` comment at the top of the existing `progress.html`, if the file exists.
2. Treat everything in `knowledge.md` with `last_seen` after that timestamp as "changed since last time" — state transitions, new evidence, new misconceptions opened or closed.
3. If `progress.html` does not exist (first run, or the user deleted it), render the panel without a delta section and say so plainly: "sem render anterior para comparar — mostrando o estado atual". This is a safe, expected situation, not an error.
4. Always overwrite the whole file. Always emit a fresh `<mentor-meta>` line with the current timestamp, current `study_hours_total`, and active feature.

## Rules

- **Panel content in Portuguese**; the file's HTML/CSS scaffolding and the `<mentor-meta>` comment stay in English, matching the rest of `.mentor/`.
- Never show percentages or grades. States and named evidence only.
- The "Mudou desde a última interação" section is the most important part of the file.
- Group by tag where it helps (`<details>` per tag), but an objective with several tags appears under each.
- Show overdue reviews with how overdue they are, on whichever clock (calendar or exposure) triggered it. Never hide the backlog.
- Always render the "⏳ Aguardando confirmação de fluência" section when anything qualifies — it's what keeps a study sprint from ending with the same invisibility problem the previous version had.
- Show the calibration section only when a real pattern exists.
- Keep it scannable. If the project has grown large, show fragile + due + recently changed in full, and collapse the rest into per-tag counts inside `<details>`.

## Optional arguments

- `/mentor-progress --all` — full listing, no collapsing
- `/mentor-progress --tag <tag>` — only objectives carrying that tag, including archived ones

See `templates/progress.html` for the exact shape.
