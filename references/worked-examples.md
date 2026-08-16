# Worked examples and the delegate bucket

## Why delegation is sometimes correct

The default posture of this skill is that the user is the author (`references/code-policy.md`). But for dense, mostly non-conceptual configuration — a multi-service compose file, a dashboard JSON, an index mapping — producing it unaided costs hours and teaches mostly syntax, not understanding. For material like this, studying a worked example produces more learning, faster, than generating the solution from scratch: search for the right shape of the answer consumes the attention that would otherwise go toward learning the pattern.

This is why the `delegate` bucket exists in `references/knowledge-model.md`. It is not a loophole in the code policy — it is a distinct, deliberate teaching move with its own protocol, triggered by `/mentor-example`, never by silently handing over a finished file.

Receiving a delegated artifact passively teaches close to nothing. The value depends entirely on the three-step protocol below being followed in full.

## When something belongs here

An item belongs in `delegate` (not `explain` or `decide`) when it is mechanical coupling or lookup-able configuration: it does not encode a trade-off the user needs to be able to navigate later. Contrast:

- Flink job parallelism → encodes a real trade-off (throughput vs. resource use vs. latency) → **objective**, target `decide`.
- The order in which two containers in a compose file wait on each other → almost always plumbing → **delegate**.
- An OpenSearch index mapping's field types → mostly lookup, sometimes a real decision if it affects query semantics → judgement call; if in doubt, ask "would getting this wrong teach the user something they need again, or just cost them a debugging session?" — the former is an objective, the latter is delegate.

## The `/mentor-example` protocol

Three steps, none optional. Skipping (2) or (3) turns this into ordinary code delivery, which the skill exists to prevent.

**1. Produce, annotated.**
Generate the artifact, but every non-obvious block carries a one-line comment explaining the *why* — the reasoning that is normally invisible in a finished artifact. This is what makes it a worked example rather than a delivery: the expert's usually-hidden decision process is made visible.

**2. Question, on isolated decisions.**
Ask 4–5 questions, each about one decision in the artifact and its consequence — never "explain this file" as a whole:

> Why does this service wait on that one, and not the reverse?
> Is this volume required or just convenient? What actually differs in behaviour without it?
> If this line were removed, what breaks, and when would you notice?

This is the step that turns passive reading into something with retrieval value.

**3. Completion problem.**
Return a near-identical version of the same artifact with 2–3 values or blocks removed. The user fills them in. This is the bridge between studying the example and producing one unaided, and it is usually where an illusion of understanding gets caught — the user thought they understood the compose file until asked to reproduce one piece of it.

## What gets logged

Delegated items do **not** become rows in `knowledge.md` — they are not learning objectives. But the interaction is still evidence-worthy:

- Log one `kind: "example"` entry per artifact in the feature's `evidence.jsonl`, referencing the objective(s) it is adjacent to if any (e.g. an annotated compose file might touch the `docker-networking` tag without itself being an objective).
- Store the annotated artifact and the completion version under `.mentor/features/<slug>/examples/`. This directory is **not** version-controlled (see the feature's `.gitignore`); it is a convenience for the current session, not a permanent record. If the user wants to keep one, they can move or commit it manually.
- If the completion step reveals a real gap (the user could not fill in a blank that reflects a genuine trade-off, not just syntax), that is a signal the item was mis-sorted — it likely belongs in `explain` or `decide`, not `delegate`. Say so, and offer to add it to `knowledge.md`.

## Boundary with the code policy

`references/code-policy.md` still governs anything the user owns as part of their actual task deliverable. `/mentor-example` is reserved for adjacent, non-task-deliverable configuration and boilerplate that the user has explicitly bucketed as `delegate` at `/mentor-map` — it is not a way to get a task implemented by asking for an "example" of it. If a request for an example looks like it is actually the task, route back to the hint ladder in `references/judging.md` instead.
