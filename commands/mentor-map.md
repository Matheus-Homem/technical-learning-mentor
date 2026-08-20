# /mentor-map

**Crosses what the user knows against what the feature requires, and decides who writes each task.** This is the core command of the skill. Read `references/task-matrix.md` and `references/knowledge-model.md` before running it.

`/mentor-map [feature-slug] [--rederive <node>]`

Run right after the spec skill produces its task list, before any code. Target time: 5–10 minutes.

## What it owns

| | |
|---|---|
| **Reads** | spec artifacts (via `profile.spec_artifacts`), `snapshot.json`, `domain.md`, `nodes.md`, the repo |
| **Writes** | `.mentor/features/<slug>/map.md`, new rows in `nodes.md`, `profile.active_feature` |
| **Never** | writes to the planning skill's own files; contacts Gemini Notebook; writes Comprehension; re-derives Application without `--rederive` |

## Steps

**1. Resolve inputs.**

Spec artifacts from `profile.md`; if the path no longer matches anything, ask and update it rather than guessing. If `.mentor/` does not exist, run `/mentor-sync` first — there is nothing to cross against until the snapshot has content.

Check the snapshot's `fetched_at` against `snapshot_max_age_days`. If it is stale, **say so and continue**. Note it in `map.md`'s header. A stale snapshot still produces a mostly-correct map; no map produces nothing.

**2. Identify the tasks.**

Identify each task by the first of these the task file actually offers, and record which one you used in `map.md` so a later remap can reconcile: an explicit id (`T14`, `TASK-3`); else the text of the heading its checkbox sits under; else the checkbox's own line, truncated.

**Never require the task file to carry a field of ours.** This skill does not own that file, and assuming a format is how it stops being portable.

**3. Derive the required nodes, per task.**

For each task ask: *what would someone have to command in order to write this themselves?* Express each answer as a **depth-4 taxonomy id**.

- **Check `nodes.md` first and reuse existing ids.** A node that returns keeps its Application and its history. Check the `aliases` column too.
- **Confirm every new id with the user before writing it.** Propose the canonical form; a wrong id contaminates every descendant and every verdict that rests on it.
- A task may require nodes from any number of subtrees. A task may require nothing — that is a normal outcome.
- Do not enumerate a technology. If the tasks touch three mechanisms of a tool, three nodes appear, not the tool's full surface.
- Prefer fewer, sharper nodes. More than roughly 15 new nodes in one feature means the decomposition went too fine.

If a task resolves only to nodes shallower than depth 4, refine them to depth 4 before classifying. Do not guess a verdict from a shallow node — it has no Application, so the matrix has no row for it.

**4. Derive Application for new nodes only.**

Per `references/knowledge-model.md`: is there a class of artifact whose production would directly demonstrate this node? Write the value, the `source` (`derived`), and the one-line `why`, at the same moment.

**Existing nodes are not re-derived.** Only `--rederive <node>` changes an existing value, and a `source: user` value is never re-derived at all. This is what makes two consecutive runs produce identical verdicts.

**5. Resolve and classify.**

For each required node resolve Domain (longest declared prefix, else `developing`), Comprehension (snapshot, absence is `unknown`), and Application (`nodes.md`). Apply the matrix, then aggregate per task. Both are in `references/task-matrix.md`.

**6. Write `map.md`** from the template: the task table, the knowledge table, the gaps, the full trace, and the notes.

**A verdict without its trace is not written.** Every resolved value names its origin — which declaration, which date, which derivation.

**7. Update `nodes.md`** with the new rows only. Leave existing rows untouched.

## Output to the user

- the split — `4 own, 3 paired, 2 delegated`
- **the gaps**: required nodes absent from the snapshot or sitting at `no`. This is the study list, and it is the most actionable thing the command produces — it is what to take to Gemini Notebook.
- `contested` nodes, in their own block: declared `mastered`, proven `no`. Naming the contradiction is the whole job; resolving it is the user's call.
- `class-first` tasks: `own` work whose theory is not proven yet. One-line offer of `/mentor-class` before they start.
- which nodes resolved `waived` by inheritance, and from which declaration — the mechanism paying out should be visible
- how many nodes resolved by `default` rather than by a declaration. A high count means `/mentor-sync --full` is overdue.
- if the snapshot was stale, its age

Do not teach the content here. This is orientation.

## Remapping

Re-running on a feature that already has a `map.md` is expected, not an error. A regenerated task list leaves old verdicts stale, and stale verdicts are worse than none because they look authoritative.

- **Nodes and declarations are preserved.** Ids, Application values, and Domain rows carry over untouched. A remap never resets anything.
- **Verdicts are recomputed** — new tasks get rows, dead tasks lose theirs, and any verdict whose inputs moved is re-derived. This is the step where a Domain declared `waived` since the last map drops its tasks to `delegated`, and where Comprehension arriving from a sync clears a `contested` flag.
- **Manual overrides survive** and are marked `manual-override`, so the recompute never silently reverses a choice the user made.
- **Write a dated line** in `## Notes` saying what moved and why.

When `/mentor-tasks` finds tasks with no row in `map.md`, that is the signal to run this.
