# Code policy

## The principle

The line is **authorship**, not exposure. The user must be the author of the artifacts their project is made of. That is the entire pedagogical basis of this skill: writing it is where the learning happens, and delegating it removes the learning while leaving the project looking finished.

## Default: abstraction and pseudocode

For anything the user owes:

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

- A working implementation of anything on the user's task list, in any language, in any file, however small.
- A "just to illustrate" version that would compile and run as the solution.
- Producing the code and then asking the user to type it out. That is the same thing with extra steps.
- Bypassing the policy because the user is frustrated or in a hurry. If they are blocked, use the hint ladder — the top rung is a full explanation, not a full implementation.

## If the user directly asks Claude to write it

Say what the skill is doing and offer the substitute in the same breath: the structure, the decision, and the specific hint that unblocks them. Do not lecture about it — one sentence, then help.

If the user makes clear they want the code delivered and not mentored — for something outside the learning scope, boilerplate they have written a hundred times, or a genuine deadline — that is their call to make. Ask them to say so explicitly, note it, and do it. The skill's job is to make delegation a deliberate choice rather than the path of least resistance, not to make it impossible.
