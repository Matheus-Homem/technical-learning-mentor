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

If an objective cannot be phrased as one of these two, it is not an objective — it is a tag, or it belongs in the delegate bucket (see `classes.md`).

## Not everything becomes an objective: the three buckets

At `/mentor-map`, before anything is written to `knowledge.md`, every candidate piece of required knowledge is sorted into one of three buckets. This sorting happens once, deliberately, at the start of the feature — not item by item while tired at 22:00.

| Bucket | What it is | What happens to it |
|---|---|---|
| 🎯 **decide** | a trade-off the user will meet again in their career; transferable | becomes an objective, target `decide`, gets scenarios |
| 📖 **explain** | needs to be understood and justified, not optimised | becomes an objective, target `explain`, lighter assessment |
| 📦 **delegate** | mechanical coupling between tools, lookup-able configuration | does **not** become an objective; routed to `/mentor-class` |

The test for delegate vs. objective: **if the parameter encodes a trade-off the user needs to be able to navigate, it is knowledge. If it is plumbing between services, it is lookup.**

A Flink job's parallelism is a decision — it becomes an objective. The startup order between two containers in a compose file is usually plumbing — it goes to delegate. Delegating the second is what buys time for the first; see `classes.md` for how delegation is done without it becoming silent code delivery.

This distinction exists because of a real constraint highlighted under time pressure (a study sprint, a deadline): learning everything a project touches, at `decide` level, is not achievable and produces shallow coverage of everything instead of real depth where it matters. The buckets make that trade-off explicit and chosen once, rather than accidental.

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
| `last_seen` | ISO date of the most recent evidence touching this objective |
| `last_seen_hours` | cumulative study hours (from `profile.md`) at that moment |

There is no scheduled review date anywhere in this model. See `references/retention.md` for why, and for how `last_seen` / `last_seen_hours` replace it.

## Tags, not a tree

Do not organise objectives into a subject → topic tree. The most valuable objectives in a real project sit on the seams between areas, and a tree forces them into one branch and hides them from the others.

Tag freely: an objective about a container reaching a broker gets the tags of both. The panel groups by tag, so the same objective legitimately appears under several headings.

## Target level

Only two targets exist:

- **`explain`** — the user can say what it is, why it exists, what problem it solves, and how it works, without looking it up.
- **`decide`** — the user can choose correctly between options under stated conditions and justify the choice, and can say what breaks under the wrong choice.

`decide` implies `explain`. Recall-only ("can name it") is never a target. Diagnosis is out of scope as a formal target, though a diagnosis the user performs spontaneously — resolving a real bug — is excellent evidence and should be logged (see `references/evidence-log.md`).

## The limiting objective

At `/mentor-map`, in addition to sorting into buckets, name **one limiting objective** for the feature when one is visible: the transversal concept that most other `decide`-bucket objectives depend on. It is usually not a tool-specific item — it is the cross-cutting idea (e.g. "time and ordering in a distributed system") that quietly determines whether the rest of the feature's decisions can be made correctly.

The limiting objective is marked in `map.md` and gets deliberate drill in the due-review pass of `/mentor-review` (repeated scenarios, varying conditions) rather than the normal rotation with everything else. Not every feature has a clear one; do not force it.

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

`fluent` is the only state that requires elapsed time. This holds under any pace, including a study sprint: massed practice produces fast apparent gains and fast decay. Nothing learned inside a two-week sprint can be marked `fluent` within it — that is by design, not a gap to close. The panel must make this visible rather than silent (see `templates/progress.html`), or the sprint ends feeling like effort with no legible outcome.

Demotion is normal and not a punishment: a failed due review sends an objective back to `fragile` and restarts its position on the ladder in `retention.md`.

## Archiving

When the project pivots and an objective is no longer required, set its state prefix to `archived:` (`archived:explains`). Archived objectives keep their evidence and their history, disappear from the panel and from the review queue, and are restored with their history intact if a later feature requires them again. Never delete a row.

## How objectives are derived

At `/mentor-map`, read the spec artifacts and the current repo state, and ask: *what would someone have to be able to explain or decide in order to write this themselves?* Sort each candidate into a bucket before writing anything to `knowledge.md`.

Rules:

- Every objective must trace to something in the artifacts or in the existing code. Record it in `origin`.
- Do not enumerate a technology. If the task list touches three features of a tool, three areas appear — not the tool's full surface.
- Prefer fewer, sharper objectives. A feature that produces more than roughly 15 new `decide`+`explain` objectives is over-decomposed, or the delegate bucket is being under-used; reconsider both.
- Reuse ids: check `knowledge.md` first. An objective that returns in a later feature keeps its id, its history, and its state.
- Configuration trivia is not knowledge, even when it looks technical. If it does not encode a trade-off, it goes to `delegate`.
