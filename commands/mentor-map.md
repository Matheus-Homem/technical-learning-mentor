# /mentor-map

**Run right after the spec skill produces the plan/design/tasks for a new activity, before writing any code.**

Purpose: make the required knowledge visible before the work starts. This command is mostly not an assessment — it answers "what do I need to know for this, and where do I already stand?".

Target time: about 5 minutes.

## Steps

**1. Bootstrap the repo if needed.**
If `.mentor/` does not exist, create it from `templates/`, and ask for the path to the spec artifacts (the plan/design/task files produced by the user's planning skill). Store it in `profile.md` as `spec_artifacts`. Never hardcode a filename — accept whatever path or glob the user gives. On later runs, resolve from `profile.md`; if nothing matches, ask again and update it.

**2. Read the inputs.**
The spec artifacts, `knowledge.md`, and enough of the repo to know what already exists. Do not read closed features' evidence logs.

**3. Derive the objectives.**
Apply `references/knowledge-model.md`. For each task, ask what someone would have to be able to explain or decide to write it themselves. Trace every objective to its origin. Check `knowledge.md` first and reuse ids for anything that returns — a returning objective keeps its state and history.

Aim for sharpness over coverage. If a feature yields more than ~15 new objectives, merge.

**4. Run triage for new tags only.**
For every tag that has no entry in `profile.md`, ask two questions. Skip tags already answered — the questionnaire must not grow every feature.

> `<tag>` — how much have you worked with this? (never used / used a little / use it regularly)
> `<tag>` — for this project, do you want to be able to **decide** with it, just **explain** it, or **skip** it for now?

Write the answers to `profile.md`. Experience sets the initial state of that tag's objectives: *never used* → `unassessed`, *used a little* / *use it regularly* → `declared` (self-report is weak evidence and the ladder says so). *Skip* archives the tag's objectives for this feature.

**5. Write `map.md`** for the feature, using the template. Create `evidence.jsonl` empty.

**6. Update `knowledge.md`** with new rows; leave existing rows untouched except for `origin` if the objective returned.

**7. Regenerate `progress.md`** and show it.

## Output to the user

A short message, then the panel:

- how many objectives this feature requires, and how many are already at or above target
- the ones that are `fragile` or carry an open misconception from earlier features and are needed again now
- any due reviews that have piled up
- one line naming what looks like the hardest thing in this feature and why

Do not lecture the content here. The point is orientation, not teaching.
