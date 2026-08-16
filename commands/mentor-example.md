# /mentor-example

**Run for anything sorted into the 📦 delegate bucket at `/mentor-map`**, or on request for material genuinely new to the user (`unassessed`/`declared` objectives) where a worked example should precede independent practice. See `references/worked-examples.md` before running this — it is the source of truth for the protocol and the boundary with `references/code-policy.md`.

`/mentor-example <what>` — `<what>` is a short description of the artifact (e.g. `docker-compose service for Flink`, `OpenSearch index mapping for the events index`).

Target time: about 15 minutes. Never skip a step — receiving the artifact without steps 2 and 3 is ordinary code delivery, not a worked example, and defeats the reason this command exists separately from just asking Claude for the file.

## Steps

**1. Confirm the bucket.** If `<what>` maps to an item already in the feature's `map.md` delegate list, proceed. If it looks like it's actually part of the user's owed task deliverable rather than adjacent configuration, say so and redirect to the hint ladder in `references/judging.md` instead — this command is not a way to get the task itself implemented.

**2. Produce, annotated.** Generate the artifact. Every non-obvious block gets a one-line comment on *why*, not just what — the reasoning that's normally invisible in a finished artifact.

**3. Question, on isolated decisions.** Ask 4–5 questions, one at a time, each about a single decision and its consequence:

> Why does `<X>` wait on `<Y>`, and not the other way round?
> Is `<this>` required or just convenient? What would actually differ in behaviour without it?
> If this line were removed, what breaks, and when would you notice?

**4. Completion problem.** Return a near-identical version of the artifact with 2–3 values or blocks removed. The user fills them in. Check their answers and explain any miss.

**5. Log and store.**
- Append one `kind: "example"` evidence entry to the feature's `evidence.jsonl`, `study_hours_total` set, referencing any adjacent tags. This does not promote or create a `knowledge.md` row.
- Save the annotated artifact and the completion version to `.mentor/features/<slug>/examples/`. Mention to the user that this folder is not version-controlled — it's a session convenience, not a permanent record; they can move or commit a copy manually if they want to keep it.

**6. Mis-sort check.** If the completion step reveals a real gap — the user couldn't fill in a blank that reflects a genuine trade-off, not just syntax — say so directly: this item was likely sorted into the wrong bucket. Offer to add it to `knowledge.md` as a proper objective instead, and do so if the user agrees.
