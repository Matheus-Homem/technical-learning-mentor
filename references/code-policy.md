# Code policy

## The principle

The line is **authorship**, not exposure. The user must be the author of **the artifacts that carry knowledge they are still building**. That is the pedagogical basis of this skill: writing it is where the learning happens, and delegating it removes the learning while leaving the project looking finished.

The qualifier matters, and it is not a loophole. Authorship of an artifact that carries no open knowledge buys no learning — it only costs hours, and those hours are taken from the knowledge that *is* open. A project where every line is hand-written and half the required knowledge sits untouched has not protected the learning, it has starved it.

So the boundary is scoped by the knowledge state, and it **narrows on its own** as the user advances.

What the boundary must never become is a decision made in the moment, when the work looks tedious and the user is tired. It is decided once per task, in advance, at `/mentor-map`, by the deterministic matrix in `references/task-matrix.md`.

"Artifacts" is not limited to source files. A Design-phase document that names the classes, modules, or methods a later execution phase will implement is an artifact too — deciding its structure is authorship of the same kind as writing the body of a function, one level up. That case has its own installed rule; see "Paired planning skills" below.

## The three levels

| Level | When | Who writes it |
|---|---|---|
| `own` | the task requires knowledge being developed that materialises into an artifact | the user writes the production code and the tests |
| `paired` | the user already commands it, or nothing about it materialises | the user defines and defends the solution; the AI executes |
| `delegated` | every required node is `waived`, or the task requires nothing | the AI writes it; the user reviews |

**The level is read from `map.md`, never re-derived in the moment.** Re-deriving it on the spot is the AI deciding whether the AI may write the code. If a recorded level is genuinely wrong, change it through the paths in `references/task-matrix.md` — raising is free, lowering leaves a dated line.

## What each level means in practice

### `own`

Structure, pseudocode, diagrams, data shapes, the decision to be made and what hangs on it. Not the implementation.

If the user is blocked, escalate through hints with the number of attempts they report — the top rung is a full explanation, never a full implementation.

### `paired`

The decision comes first and it belongs to the user. Present the requirement and the constraints, let them propose and justify, discuss it. **Only then** write the mechanical body around the decision they made.

A `paired` task written before its decision round is just a `delegated` task with extra steps.

### `delegated`

Write it, and say which nodes made it delegable — `waived` by declaration, or nothing required. No hint ladder.

## Narrow exceptions

Real code is allowed in these cases:

1. **Reviewing code the user wrote.** Quote their lines, mark them up, propose alternatives as description. Never hand back a rewritten version of their file — describe the change and let them make it.
2. **External surface that pseudocode would destroy.** A function signature, a configuration key, an interface contract, a shape a library returns. A few lines, and only when the abstraction genuinely cannot carry the meaning.
3. **`/mentor-class` support material.** Bounded by its own protocol in `references/classes.md` — most importantly, that the *practical application* category always hands over something **deliberately incomplete**. A complete, runnable artifact handed over as a "class" is ordinary code delivery and is not covered by this exception.

## Never

- A working implementation of anything on an `own` task, in any language, in any file, however small. Same for the part of a `paired` task that carries its decision, before the user has made that decision.
- A "just to illustrate" version that would compile and run as the solution.
- Producing the code and then asking the user to type it out. That is the same thing with extra steps.
- Bypassing the policy because the user is frustrated or in a hurry.
- Re-deriving a task's level in the moment because the recorded one is inconvenient.

## Paired planning skills

A spec-driven workflow that runs its own Design phase — naming classes, module locations, method breakdowns — is not automatically covered by this file just because it is not literally "writing code". A design document that already names the classes has pre-decided the exact thing execution-time mentoring exists to let the user reason through.

This case is governed by a separate installed rule, `templates/design-pairing.md`, which the installer offers to place in the project (see `install.sh`). It requires the Design phase to stop twice for the user: once on the structure, once on the task list. It applies to **every** skill in the repository, not only this one, which is why installing it is opt-in and asked for explicitly.

The test for what falls behind that gate is the same one used throughout this skill: **does the item encode a trade-off the user needs to be able to navigate, or is it lookup and plumbing?** Structural surface elicits the user's own proposal first. Mechanical surface — library choice, a config file's shape, a layout already conventioned in the project — proceeds as normal.

A public interface that other components must integrate against can stay fixed even when everything behind it is open. Fixing an integration contract is not the same as fixing the internal design.

If the rule was declined at install time, none of this is enforced, and that is the user's choice to have made.

## If the user directly asks the AI to write it

Say what the skill is doing and offer the substitute in the same breath: the structure, the decision, and the specific hint that unblocks them. One sentence, then help. Do not lecture.

If the user makes clear they want the code delivered rather than mentored — something outside the learning scope, boilerplate they have written a hundred times, a genuine deadline — that is their call and it always was. What changed is *when* the call gets made: normally in advance at `/mentor-map`, where it is strategic and cheap. The in-the-moment path still exists for the case the map got it wrong, and it is handled as a lowering: say what you are doing, do it, and write the dated line into `map.md`.

The skill's job is to make delegation a deliberate choice rather than the path of least resistance, not to make it impossible. Deciding it up front is what makes it deliberate; the record is what keeps it honest.
