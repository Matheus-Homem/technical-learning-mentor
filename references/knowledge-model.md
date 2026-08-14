# Knowledge model

## The unit is a learning objective, not a topic

A topic ("partitioning", "dependency injection", "indexes") is a noun. Nouns cannot be assessed — there is no fact of the matter about whether someone "knows partitioning".

A **learning objective** is a claim or a decision rule that can be right or wrong. It is written as a full sentence.

Bad (topic): `consumer offsets`
Good (objective): `An offset commit records the next message to read, not the last one processed`

Bad (topic): `hexagonal architecture`
Good (objective): `A port is owned by the domain; an adapter depends on the port, never the reverse`
Good (objective): `Given a new external dependency, decide whether it needs a new port or reuses an existing one`

Two shapes are allowed:

- **Proposition** — a claim about how something works. Target level is usually `explain`.
- **Decision rule** — a judgement to make under stated conditions. Target level is always `decide`. Phrase it as `Given X, decide Y`.

If an objective cannot be phrased as one of these two, it is not an objective — it is a tag.

## Fields

Each objective is one row in `.mentor/knowledge.md`:

| Field | Meaning |
|---|---|
| `id` | stable, short, unique in the project (`K-07`). Never reused, never renumbered. |
| `statement` | the proposition or decision rule, in English, one sentence |
| `tags` | free-form, lowercase, hyphenated. Multiple allowed and encouraged. |
| `target` | `explain` or `decide` |
| `origin` | where the requirement came from: a task id, a design section, a file path, or `emergent` |
| `state` | ladder position (below) |
| `evidence` | comma-separated evidence ids, most recent last |
| `misconception` | one line describing the currently open wrong model, or empty |
| `next_review` | date, or empty if not yet at target |

## Tags, not a tree

Do not organise objectives into a subject → topic tree. The most valuable objectives in a real project sit on the seams between areas, and a tree forces them into one branch and hides them from the others.

Tag freely: an objective about a container reaching a broker gets the tags of both. The panel groups by tag, so the same objective legitimately appears under several headings.

Tags are also the unit of the triage questionnaire and of target levels — the user declares experience and an ambition per tag, not per objective.

## Target level

Only two targets exist:

- **`explain`** — the user can say what it is, why it exists, what problem it solves, and how it works, without looking it up.
- **`decide`** — the user can choose correctly between options under stated conditions and justify the choice, and can say what breaks under the wrong choice.

`decide` implies `explain`. Recall-only ("can name it") is never a target — it is below the bar. Diagnosis is out of scope as a target, though a diagnosis the user performs spontaneously is excellent evidence and should be logged.

Default assignment: an objective gets `decide` if the project actually forces the user to make that choice; otherwise `explain`. Most objectives are `explain`. Being generous with `decide` inflates the work and slows the loop.

## The mastery ladder

```
unassessed → declared → fragile → explains → decides → fluent
                ↑                     ↓         ↓
                └──── (demotion on failed review) ──┘
```

| State | Meaning | Minimum to enter |
|---|---|---|
| `unassessed` | in the map, no evidence at all | — |
| `declared` | the user claimed experience in the triage questionnaire | self-report only; explicitly weak |
| `fragile` | there is evidence of a gap or an open misconception | one failed or partial response |
| `explains` | met the `explain` bar | one strong-enough evidence (see evidence ordering) |
| `decides` | met the `decide` bar | a justified decision, not a recognised answer |
| `fluent` | reliable without consulting anything | **two independent evidences at target level, at least 14 days apart, with no lookup** |

`fluent` is the only state that requires elapsed time. This is deliberate: the user's stated goal is to use this knowledge without consulting anything, the way they use their programming language's basic syntax. That is automaticity, and automaticity cannot be demonstrated inside one week of one feature. Any design that can award "mastered" at the end of a single feature is measuring the wrong thing.

Demotion is normal and not a punishment: a failed due review sends an objective back to `fragile` and restarts its review ladder.

## Archiving

When the project pivots and an objective is no longer required, set its state prefix to `archived:` (`archived:explains`). Archived objectives keep their evidence and their history, disappear from the panel and from the review queue, and are restored with their history intact if a later feature requires them again. Never delete a row.

## How objectives are derived

At `/mentor-map`, read the spec artifacts and the current repo state, and ask: *what would someone have to be able to explain or decide in order to write this themselves?*

Rules:

- Every objective must trace to something in the artifacts or in the existing code. Record it in `origin`.
- Do not enumerate a technology. If the task list touches three features of a tool, three areas appear — not the tool's full surface.
- Prefer fewer, sharper objectives. A feature that produces more than roughly 15 new objectives is over-decomposed; merge them.
- Reuse ids: check `knowledge.md` first. An objective that returns in a later feature keeps its id, its history, and its state.
- Configuration trivia is not knowledge. "The exact value of a setting" is lookup; "why this setting exists and what breaks without it" is an objective. Do not create objectives for values.
