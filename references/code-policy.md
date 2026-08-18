# Code policy

## The principle

The line is **authorship**, not exposure. The user must be the author of **the artifacts that carry knowledge they are still building**. That is the entire pedagogical basis of this skill: writing it is where the learning happens, and delegating it removes the learning while leaving the project looking finished.

The qualifier matters, and it is not a loophole. Authorship of an artifact that carries no open objective buys no learning — it only costs hours. Those hours are not free: they are taken from the objectives that *are* open. A project where every line is hand-written and half the required knowledge sits at `unassessed` has not protected the learning, it has starved it. So the boundary is scoped by the knowledge state, and it **narrows on its own** as the user advances — the same way `/mentor-class` already narrows under exception (4) below, and for the same reason (expertise reversal).

What the boundary must never become is a decision made in the moment, when the work looks tedious and the user is tired. It is decided once per task, in advance, at `/mentor-map`. See "Task authorship levels".

"Artifacts" is not limited to source files. A Design-phase document from a paired planning skill (a spec-driven workflow's `design.md`, an architecture doc, anything that names the classes/modules/methods a later Execute phase will implement) is an artifact too — deciding its structure is authorship of the same kind as writing the body of a function, just one level up. See "Paired planning skills" below.

## Task authorship levels

Every task in the feature's task list gets exactly one level, assigned at `/mentor-map` and recorded in that feature's `map.md`.

| level | when | who writes it |
|---|---|---|
| `own` | the task *is* the decision an open objective needs | the user writes production code and tests |
| `paired` | the task carries an open objective, but most of its body is mechanical | the user makes and defends the decision; Claude writes the scaffolding around it afterwards |
| `deliver` | no objective, or every objective at/above target and not due | Claude writes it; the user reviews |

### Deriving the level

For each task, list the objectives in `knowledge.md` it actually exercises — which may be none. Then:

- **no objective** → `deliver`
- **any objective with `state` below its `target`, or carrying an open `misconception`, or due by either clock in `references/retention.md`** → `own` or `paired`
- **every objective at or above `target`, none due** → `deliver`

Read `state` against `target`, never tag membership. An objective whose target is `explain` and whose state is `decides` is *done* — tasks resting on it are `deliver`, even though its tag is one the user cares about. Blocking a whole tag forever reproduces the exact failure this mechanism exists to fix.

`own` versus `paired` is the only judgement call. The test: **if you removed the decision, would what remains be something the user could type without thinking?** If yes, it is `paired` — the decision is the learning, the rest is transcription. A task whose body *is* the reasoning is `own`.

An item already sorted into the 📦 delegate bucket at `/mentor-map` appearing as the substance of a task is a strong signal for `deliver`; the bucket sort already judged it carries no trade-off worth learning.

### Promotion is free, demotion is recorded

The user may raise a level at any time, for any reason, with no ceremony — curiosity is not something to put friction in front of.

Lowering a level mid-feature (`own` → `paired` → `deliver`) requires a dated line in `map.md` under "Notes during the feature", saying which task and why. This is deliberately asymmetric. Delegation decided in advance is a strategy; delegation decided at 22:00 on a task that turned out to be boring is the path of least resistance wearing a strategy's clothes, and the whole point of this file is to keep those two apart.

### `deliver` work never becomes evidence

Code Claude wrote is not evidence of what the user knows. Reviewing it, approving it, or catching a bug in it does not go into `evidence.jsonl` and never advances a state in `knowledge.md`. Without this rule, delegating work would inflate the mastery record — the exact inverse of what the record is for.

A `paired` task's *decision round* is different: that is the user reasoning, unaided, before any code exists. Log it as `kind: "scenario"`, exactly as the Design-phase elicitation under "Paired planning skills" already does.

## Default: abstraction and pseudocode

For anything at `own`, and for the decision half of a `paired` task:

- structure and responsibilities ("this file holds X; it depends on Y; it must not know about Z")
- pseudocode with real names but no working body
- diagrams, sequences, data shapes
- the decision to be made and what hangs on it

## Narrow exceptions

Real code is allowed in these cases:

1. **Reviewing code the user wrote.** Quote their lines, mark them up, propose alternatives as description. Never hand back a rewritten version of their file — describe the change and let them make it.
2. **External surface that pseudocode would destroy.** A function signature, a configuration key, an interface contract, a shape returned by a library. Keep it to a few lines, and only when the abstraction genuinely cannot carry the meaning.
3. **`/mentor-class` for anything sorted into the `delegate` bucket at `/mentor-map`.** See `references/classes.md`. This is not an exception to authorship for the user's task — delegated items were explicitly agreed not to be learning objectives. The exception is bounded by the protocol: annotate → question, and for any artifact that carries code or configuration, → completion problem. Handing over a code-bearing artifact without the completion step is ordinary code delivery and is not covered by this exception.
4. **Classes for objectives still at `unassessed` or `declared`.** For material genuinely new to the user, an explanation worked in full — with the reasoning made visible — can precede independent practice, per the same protocol as (3). This narrows automatically as the objective advances: once an objective reaches `explains`, classes for it stop being offered unprompted, and by `decides`/`fluent` one would blunt rather than help (expertise-reversal: scaffolding that helps a novice slows someone who has already internalised the pattern). This exception applies only to the specific objective at that state — never to the user's actual task-list deliverable itself, which stays under rule (1)/(2) regardless of the user's level.

### What the exception covers per `/mentor-class` format

`/mentor-class` produces one of four formats (`references/classes.md`). Three of them contain no code the user owes and raise no authorship question at all:

- **written + narrated** (`.md` + `.mp3`) and **diagrammed walkthrough** (`.md` with Mermaid) — prose and diagrams. Already allowed by the default posture above; no exception needed.
- **component map** (`.html`) — a self-contained diagram page (`references/class-diagrams.md`). Its HTML/CSS/SVG is the diagram's own presentation, not the user's project code, and never contains the user's task in disguise.
- **scratch notebook** (`.ipynb`) — the only format that carries real, runnable code, and therefore the only one that needs exceptions (3) and (4) to exist. It is covered as **support material for getting unstuck against an unfamiliar library or tool**: instantiate the client, call the method, print the shape that comes back, so the user can see what they are working with. It is explicitly **not** a channel for delivering the user's task in cells. Cells that assemble the deliverable, in whole or in part, fall under "Never" below regardless of the file extension. A notebook is also always subject to the completion problem — it is code-bearing.

The test is unchanged by the format: would this artifact, pasted into the project, be the thing the user was supposed to write? Then it is not a class.

## Never

- A working implementation of anything on an `own` task, in any language, in any file, however small. Same for the part of a `paired` task that carries its decision, before the user has made that decision.
- A "just to illustrate" version that would compile and run as the solution.
- Producing the code and then asking the user to type it out. That is the same thing with extra steps.
- Bypassing the policy because the user is frustrated or in a hurry. If they are blocked, use the hint ladder — the top rung is a full explanation, not a full implementation.
- Re-deriving a task's level in the moment because the recorded one is inconvenient. The level is read from `map.md`, not re-judged on the spot; if it is genuinely wrong, change it through the demotion path and leave the dated line.

## Paired planning skills

Some projects pair this skill with a spec/planning skill that runs its own Design phase (naming classes, module locations, method breakdowns) ahead of an Execute phase. That Design phase is not automatically covered by this skill's boundary just because it isn't literally "writing code" — a `design.md` that already names the classes has pre-decided the exact thing Execute-time mentoring exists to let the user reason through.

The test is the same one used everywhere else in this skill: does the item encode a trade-off the user needs to be able to navigate (`decide`, per `references/knowledge-model.md`), or is it lookup/plumbing? Applied to a Design-phase artifact:

- **Structural surface** (a `decide`-bucket item: which class, where it lives, what its responsibilities/methods are) → before it goes into the artifact, elicit the user's own proposal first. Present the behavioral requirement and constraints only — not the answer — let them sketch a structure and justify it, discuss it like any other mentoring round, then write the artifact reflecting what was reasoned through rather than what was handed down.
- **Mechanical surface** (library choice, a config file's shape, a layout already conventioned elsewhere in the project) → the planning skill proceeds as normal; no elicitation needed, same as any other `delegate`-bucket item.

A public interface that other components must integrate against (a method signature two services both call, a wire format) can legitimately stay fixed even when everything behind it is open — fixing an integration contract is not the same as fixing the internal design. Leave the *body* of that interface's implementation as open structural surface for the user, the same way an ABC's method signature is fixed but its concrete implementation is not.

This does not change any exception above — `/mentor-class`, code review, and the state-dependent exceptions still work exactly as written. It closes a gap those exceptions don't cover: a planning skill's own artifact-writing is a fifth way authorship could quietly leave the user's hands, alongside the four already governed by this file.

## If the user directly asks Claude to write it

Say what the skill is doing and offer the substitute in the same breath: the structure, the decision, and the specific hint that unblocks them. Do not lecture about it — one sentence, then help.

If the user makes clear they want the code delivered and not mentored — for something outside the learning scope, boilerplate they have written a hundred times, or a genuine deadline — that is their call to make, and it always was. What changed is *when* the call gets made: the normal path is the level assigned in advance at `/mentor-map`, where the decision is strategic and cheap. This in-the-moment path still exists as the exception, for the case the map got wrong, and it is handled as a demotion: say what you are doing, do it, and write the dated line into `map.md`'s notes.

The skill's job is to make delegation a deliberate choice rather than the path of least resistance, not to make it impossible. Deciding it up front is what makes it deliberate; the record is what keeps it honest.
