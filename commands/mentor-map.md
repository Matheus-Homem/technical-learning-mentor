# /mentor-map

**Run right after the spec skill produces the plan/design/tasks for a new activity, before writing any code.**

Purpose: make the required knowledge visible before the work starts, and decide up front what will actually be learned versus delegated. This command is mostly not an assessment — it answers "what do I need to know for this, and where do I already stand?".

Target time: about 5–10 minutes.

## Steps

**1. Bootstrap the repo if needed.**
If `.mentor/` does not exist, create it from `templates/`, copying `templates/mentor-gitignore` to `.mentor/.gitignore` (see `SKILL.md`), and ask for the path to the spec artifacts (the plan/design/task files produced by the user's planning skill). Store it in `profile.md` as `spec_artifacts`. Never hardcode a filename — accept whatever path or glob the user gives. On later runs, resolve from `profile.md`; if nothing matches, ask again and update it.

**2. Ask for study hours since last session** and add to `study_hours_total` in `profile.md`. Needed for the retention clock even this early, since due reviews may surface in step 6.

**3. Read the inputs.**
The spec artifacts, `knowledge.md`, and enough of the repo to know what already exists. Do not read closed features' evidence logs.

**4. Derive candidates, then sort into the three buckets.**
Apply `references/knowledge-model.md`. For each candidate, ask what someone would have to be able to explain or decide to write it themselves — then classify:

- 🎯 **decide** — a transferable trade-off
- 📖 **explain** — needs understanding, not optimisation
- 📦 **delegate** — mechanical coupling / lookup configuration, no trade-off worth learning

Only 🎯 and 📖 become rows in `knowledge.md`. 📦 items go straight into `map.md`'s delegate list, to be handled later via `/mentor-example` — do not create objectives for them.

Trace every objective to its origin. Check `knowledge.md` first and reuse ids for anything that returns — a returning objective keeps its state and history. Aim for sharpness: if the 🎯+📖 total exceeds roughly 15 new objectives, merge some or reconsider whether more belongs in delegate.

**5. Name the limiting objective, if one is visible.**
The transversal concept most of this feature's `decide` objectives depend on — usually not a tool-specific item. Not every feature has a clear one; leave it empty rather than forcing it.

**6. Run triage for new tags only.**
For every tag that has no entry in `profile.md`, ask two questions. Skip tags already answered — the questionnaire must not grow every feature.

> `<tag>` — how much have you worked with this? (never used / used a little / use it regularly)
> `<tag>` — for this project, do you want to be able to **decide** with it, just **explain** it, or **skip** it for now?

Write the answers to `profile.md`. Experience sets the initial state of that tag's objectives: *never used* → `unassessed`, *used a little* / *use it regularly* → `declared`. *Skip* archives the tag's objectives for this feature.

**7. Write `map.md`** for the feature, using the template — bucket sort, limiting objective, carried-in items. Create `evidence.jsonl` empty and an `examples/` folder.

**8. Update `knowledge.md`** with new rows for 🎯/📖 objectives only; leave existing rows untouched except `origin` if the objective returned.

**9. Regenerate `progress.html`** and show it.

## Output to the user

A short message, then the panel:

- the bucket sort: how many objectives to decide, how many to explain, how many delegated
- the limiting objective, if any, and why it matters
- what's already at or above target from earlier features
- anything `fragile` or carrying an open misconception that this feature needs again
- any due reviews (per `references/retention.md`) that have piled up

Do not lecture the content here. The point is orientation and a deliberate, one-time trade-off decision — not teaching.
