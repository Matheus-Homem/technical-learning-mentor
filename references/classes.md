# Classes and the delegate bucket

`/mentor-class <topic>` is the skill's teaching-material instrument. It produces support material — an explanation, a diagram, a scratch notebook — for something that is blocking the user right now. It is not an assessment round, and its output is never the user's task deliverable.

## Why delegation is sometimes correct

The default posture of this skill is that the user is the author (`references/code-policy.md`). But for dense, mostly non-conceptual configuration — a multi-service compose file, a dashboard JSON, an index mapping — producing it unaided costs hours and teaches mostly syntax, not understanding. For material like this, studying a worked example produces more learning, faster, than generating the solution from scratch: search for the right shape of the answer consumes the attention that would otherwise go toward learning the pattern.

This is why the `delegate` bucket exists in `references/knowledge-model.md`. It is not a loophole in the code policy — it is a distinct, deliberate teaching move with its own protocol, triggered by `/mentor-class`, never by silently handing over a finished file.

Receiving a delegated artifact passively teaches close to nothing. Where the artifact carries code or configuration, the value depends entirely on the toll in "the protocol" below being paid in full.

## When something belongs in the delegate bucket

An item belongs in `delegate` (not `explain` or `decide`) when it is mechanical coupling or lookup-able configuration: it does not encode a trade-off the user needs to be able to navigate later. Contrast:

- Flink job parallelism → encodes a real trade-off (throughput vs. resource use vs. latency) → **objective**, target `decide`.
- The order in which two containers in a compose file wait on each other → almost always plumbing → **delegate**.
- An OpenSearch index mapping's field types → mostly lookup, sometimes a real decision if it affects query semantics → judgement call; if in doubt, ask "would getting this wrong teach the user something they need again, or just cost them a debugging session?" — the former is an objective, the latter is delegate.

Delegate-bucket items are one of the three things that trigger `/mentor-class`. The other two are genuinely new material and a topic the user is about to start work on — see `commands/mentor-class.md` for the triggers.

## Choosing the format from the diagnosed difficulty

**This is the decision that makes `/mentor-class` adaptive, and it is the one place where getting lazy costs the most.** Producing all four formats by default is overengineering: it buries the one artifact that would have helped under three that will not be opened. Generate **one** format. Generate two only when the difficulty genuinely has two faces.

The choice extends the same reasoning as the gap table in `references/teaching.md` — diagnose first, then pick. The gap decides *what to say*; the shape of the difficulty decides *what medium says it*.

| Diagnosed difficulty | Format | Files |
|---|---|---|
| the concept or the theory has not landed | **written + narrated** — prose explanation, plus a narration of it for review away from a screen | `<slug>.md` + `<slug>.mp3` |
| a flow or a sequence of steps is confusing — what happens in what order | **diagrammed walkthrough** — prose carrying one or more Mermaid diagrams | `<slug>.md` |
| stuck at the point of starting to code against an unfamiliar library or tool | **scratch notebook** — small exploratory cells, run and inspect, not a solution | `<slug>.ipynb` |
| there are several components and how they relate is unclear | **component map** — a single self-contained page, per `references/class-diagrams.md` | `<slug>.html` |

Rules for the choice:

- **Default to one format.** Two are allowed when the difficulty is genuinely mixed — e.g. the user does not have the vocabulary *and* cannot see how the pieces connect, which is written + narrated plus a component map. Never produce all four by default; if a topic seems to need all four, the topic is too big and should be split.
- **Diagnose before choosing.** Check the objective's row in `knowledge.md` for an open `misconception`, and check what the user actually said they were stuck on. "Explain X to me" is not a diagnosis — one question ("what part of it is unclear — what it is, the order things happen in, how the pieces fit, or getting the first line of code to run?") is cheap and picks the format for you.
- **One row of the gap table means no class at all.** If the diagnosis is "knows it but slowly / with lookup", that is a retention problem, not an explanation problem. Do not generate an artifact — say so, and let `/mentor-review` resurface it. See `references/teaching.md`.
- **Narration follows the written format, not the others.** The `.mp3` exists so a prose explanation can be reviewed away from a screen. A diagram, a notebook, or a component map has nothing useful to narrate — do not generate audio for them. The pipeline is in `references/audio.md`.
- **`.ipynb` is scratch, not a deliverable.** It exists so the user can poke at an unfamiliar API and see what it returns, not so they receive their task in cells. See the boundary section below.

## The protocol

What is mandatory depends on whether the artifact carries code.

**Every format, always:** annotate. Every non-obvious block, cell, step, or edge carries a one-line explanation of *why*, not just what — the reasoning that is normally invisible in a finished artifact. This is what makes it teaching material rather than a delivery.

**Every format, always:** question. Ask 3–5 questions, one at a time, each about a single decision or relationship in the artifact and its consequence — never "explain this file" as a whole:

> Why does this service wait on that one, and not the reverse?
> If this arrow pointed the other way, what would break?
> Is this required or just convenient? What actually differs in behaviour without it?
> If this line were removed, what breaks, and when would you notice?

This is the step that turns passive reading into something with retrieval value.

**Code-bearing formats only — the scratch notebook, and any delegate-bucket artifact in any format:** the completion problem. Return a near-identical version of the artifact with 2–3 values or blocks removed. The user fills them in. This is the bridge between studying the example and producing one unaided, and it is usually where an illusion of understanding gets caught — the user thought they understood the compose file until asked to reproduce one piece of it.

The completion problem is what bounds the code-policy exception (`references/code-policy.md`). Handing over a code-bearing artifact without it is ordinary code delivery, and is not covered by the exception. For the purely conceptual formats — written + narrated, diagrammed walkthrough, component map — there is no artifact standing in for work the user owes, so there is nothing to bound; annotate and question are the whole protocol.

## Where the output goes

```
.mentor/features/<slug>/classes/<topic-slug>/
```

Always nested inside the active feature — there is no such thing as a class floating outside a feature. If no feature is active, that is the thing to fix before generating anything.

This directory is **not** version-controlled (see `.mentor/.gitignore`). It is session-derived output, regenerable, not a permanent record. Say so once when handing the artifact over: if the user wants to keep one, they can move or commit it manually.

## What gets logged

Delegated items do **not** become rows in `knowledge.md` — they are not learning objectives. But the interaction is still evidence-worthy:

- Log one `kind: "example"` entry per class in the feature's `evidence.jsonl`, referencing the objective(s) it is adjacent to if any (e.g. an annotated compose file might touch the `docker-networking` tag without itself being an objective). The kind name is historical; it covers every `/mentor-class` interaction. It never promotes an objective.
- If the class was generated for an existing objective (new material, or a topic the user is about to start), the class itself is still not promoting evidence — but a wrong answer during the questioning step is ordinary `incorrect` evidence and opens a misconception like any other.
- If the completion step reveals a real gap (the user could not fill in a blank that reflects a genuine trade-off, not just syntax), that is a signal the item was mis-sorted — it likely belongs in `explain` or `decide`, not `delegate`. Say so, and offer to add it to `knowledge.md`.

## Boundary with the code policy

`references/code-policy.md` still governs anything the user owns as part of their actual task deliverable. `/mentor-class` is reserved for adjacent, non-task-deliverable material: configuration and boilerplate the user explicitly bucketed as `delegate` at `/mentor-map`, and support material for concepts they are learning. It is not a way to get a task implemented by asking for a "class" about it.

The scratch notebook is the format most likely to be pushed at this boundary, and the test is the same one as everywhere else: it may contain exploratory calls against an unfamiliar library — instantiate the client, call the method, print the shape that comes back — so the user can see what they are working with. It may not contain the user's task, assembled and working, in cells. If a request for a notebook is really a request for the deliverable, route back to the hint ladder in `references/judging.md` instead.
