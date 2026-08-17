# /mentor-class

**Produces teaching material for one topic, in the format that fits the difficulty.** Read `references/classes.md` before running this — it is the source of truth for the format choice, the protocol, and the boundary with `references/code-policy.md`.

`/mentor-class <topic>` — `<topic>` is what the user is stuck on (e.g. `kafka partitioning`, `how the normalization job starts up`, `docker-compose service for Flink`).

Target time: about 15 minutes. Output goes to `.mentor/features/<slug>/classes/<topic-slug>/`, always nested inside the active feature.

## When it runs

Three triggers, and only three:

1. **The user asks** — `/mentor-class <topic>`, or a request for something they bucketed as 📦 delegate at `/mentor-map`.
2. **`/mentor-map` suggests it** — for an item sorted into delegate, or an objective that looks weak on arrival. A suggestion, never automatic.
3. **A task transition** — the user is starting a new task or topic, and `knowledge.md` shows the objectives that task needs sitting at `unassessed`, carrying an open misconception, or well below their target level. Offer a class on it **once**, before they start. See `SKILL.md` rule 6: this is an offer of material, not a probe, so it does not interrupt with a question — but it follows the same discipline. Offer once, drop it if ignored, never block the work on it.

## Steps

**1. Diagnose before generating anything.**

Check the objective's row in `knowledge.md` for state and for an open `misconception`, and check what the user actually said. "Explain X" is not a diagnosis. One question is cheap and decides the whole rest of the command:

> What part is unclear — what it *is*, the order things happen in, how the pieces fit together, or getting the first line of code to run?

Two outcomes end the command here:

- **The gap is "knows it but slowly / with lookup"** (`references/teaching.md`). That is a retention problem. Say so, do not generate an artifact, and let `/mentor-review` resurface it.
- **The request is really the user's task deliverable**, not adjacent material. Say so and redirect to the hint ladder in `references/judging.md`. A class is not a way to get a task implemented.

**2. Confirm the bucket, if this came from delegate.**

If `<topic>` maps to an item in the feature's `map.md` delegate list, proceed under the delegate protocol — which means the completion problem in step 5 is mandatory.

**3. Choose the format(s).** Per the table in `references/classes.md`:

| Difficulty | Format | Files |
|---|---|---|
| the concept/theory has not landed | written + narrated | `<slug>.md` + `<slug>.mp3` |
| a flow or sequence of steps is confusing | diagrammed walkthrough (Mermaid in prose) | `<slug>.md` |
| stuck starting to code against a new lib/tool | scratch notebook | `<slug>.ipynb` |
| several components, unclear how they relate | component map | `<slug>.html` |

**One format by default.** Two when the difficulty genuinely has two faces. Never all four — generating everything is overengineering and buries the artifact that would have helped. If a topic seems to need all four, split the topic.

Tell the user which format you picked and why, in one line, before generating. It makes the diagnosis visible and lets them redirect it cheaply.

**4. Generate, annotated.** Every non-obvious block, cell, step or edge carries a one-line explanation of *why*, not just what. That annotation is what makes it teaching material rather than a delivery, and it is required in every format.

Format-specific requirements:

- **written + narrated** — write `<slug>.md` first, then produce the narration through the three-step pipeline in `references/audio.md` (`prepare_narration.py` → manual review of the narration text, edited in place → `generate_audio.py`). Do not skip the manual review, and do not treat a backgrounded run as finished just because the file exists.
- **diagrammed walkthrough** — Mermaid fenced blocks inside the `.md`, each with prose around it saying what to look at. Prefer several small diagrams over one that shows everything.
- **scratch notebook** — small exploratory cells: instantiate the thing, call the method, print what comes back. Scratch, not a solution. The boundary in `references/classes.md` applies.
- **component map** — a single self-contained `.html` per `references/class-diagrams.md`. No CDN, no build step, inline SVG, light/dark tokens, opens from disk offline.

**5. Question, then complete.**

Ask 3–5 questions, one at a time, each about a single decision or relationship and its consequence — never "explain this file":

> Why does `<X>` wait on `<Y>`, and not the other way round?
> If this arrow pointed the other way, what would break?
> Is `<this>` required or just convenient? What would actually differ in behaviour without it?
> If this line were removed, what breaks, and when would you notice?

Then, **for code-bearing artifacts only** — the scratch notebook, and any delegate-bucket artifact in any format — the completion problem: return a near-identical version with 2–3 values or blocks removed for the user to fill in. Check their answers and explain any miss.

This step is what bounds the code-policy exception. Handing over a code-bearing artifact without it is ordinary code delivery. For the purely conceptual formats there is nothing standing in for work the user owes, so annotate and question are the whole protocol.

**6. Log and store.**

- Append one `kind: "example"` evidence entry to the feature's `evidence.jsonl`, `study_hours_total` set, referencing any adjacent tags or objectives. This does not promote anything and does not create a `knowledge.md` row. (The kind name is historical; it covers every `/mentor-class` interaction.)
- A wrong answer during step 5 is ordinary `incorrect` evidence on whatever objective it touched, and opens a misconception like any other.
- Save everything to `.mentor/features/<slug>/classes/<topic-slug>/`. Mention once that this folder is not version-controlled — session-derived output, regenerable; they can move or commit a copy manually if they want to keep it.

**7. Mis-sort check.** If step 5 reveals a real gap — the user could not fill in a blank or answer a question that reflects a genuine trade-off, not just syntax — say so directly: this item was likely sorted into the wrong bucket. Offer to add it to `knowledge.md` as a proper objective, and do so if the user agrees.
