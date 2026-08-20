# /mentor-class

**Produces teaching material for one topic, in the format that fits the kind of not-knowing.** Read `references/classes.md` before running this — it is the source of truth for the categories, the incompleteness rule, and the boundary with `references/code-policy.md`.

`/mentor-class <topic>` — `<topic>` is what the user is stuck on.

Target time: about 15 minutes. Output goes to `.mentor/features/<slug>/classes/<topic-slug>/`.

## When it runs

1. **The user asks.**
2. **`/mentor-map` suggests it** — for a `class-first` task, or a gap blocking work. A suggestion, never automatic.
3. **A task transition** — the user is starting a task whose nodes sit at Comprehension `no`/`unknown`. Offer once, before they start. An offer of material, not a probe: it asks nothing and tests nothing. If they decline or carry on, drop it for the session.

## Steps

**1. Identify the category.**

Conceptual / practical application / architectural, per `references/classes.md`. From the shape of the question first; one disambiguating question only if genuinely ambiguous.

One early exit: **the request is really the user's task deliverable**. Say so and help with structure and the next hint instead. A class is not a way to get a task implemented.

**2. Name the node(s).**

The depth-4 node(s) this class serves. Reuse from `nodes.md` where one fits; create it (confirming the canonical id, deriving Application) where none does.

Check the node's state before generating: its Domain, its Comprehension, and whether `map.md` flagged it. A `contested` node needs a different class from an `unknown` one.

If the category and the node's Application disagree — practical requested, node is `theoretical` — say so and offer `--rederive`.

**3. Choose the format and say which.** One line, before generating: which format, and why. One format by default, two at most.

**4. Generate, annotated.** Every non-obvious block, cell, step or edge carries a one-line *why*.

Per category:

- **conceptual** — write `<slug>.md` first. If narrating, run the three-step pipeline in `references/audio.md` (`prepare_narration.py` → manual review of the narration text, edited in place → `generate_audio.py`). Do not skip the review, and do not treat a backgrounded run as finished just because the file exists.
- **practical application** — **always incomplete.** Scaffolding complete, the answer removed. State plainly what they need to fill in and how they will know it is right.
- **architectural** — Mermaid inside the `.md` with prose saying what to look at, or a self-contained `.html` per `references/class-diagrams.md`. Prefer several small diagrams over one that shows everything.

**5. Question.**

3–5 questions, one at a time, each about a single decision or relationship and its consequence — never "explain this file":

> Why does `<X>` wait on `<Y>`, and not the other way round?
> If this arrow pointed the other way, what would break?
> Is `<this>` required or just convenient? What would actually differ without it?
> If this line were removed, what breaks, and when would you notice?

For the practical category, this is where they hand back the completed piece and you check it.

**6. Log.**

- One line in `.mentor/features/<slug>/classes/index.md`: `date | topic | node | category | format`.
- Save artifacts under `classes/<topic-slug>/`. Mention once that the folder is not version-controlled.
- **Write nothing to Comprehension.** Not on a good answer, not on a completed exercise, not at all.

**7. Close the loop.**

End by pointing at NotebookLM: this topic is now ready to be tested there, and the result comes back on the next `/mentor-sync`. That is the only path by which anything the user did here becomes proven.

If step 5 revealed the node was misclassified — the Application derivation looks wrong, or the topic was really three topics — say so and offer the fix.
