# Teaching

## Choose the strategy from the diagnosed gap

Explanation style is not a preference and not a rotation. It follows from what is actually missing. Check `knowledge.md` for an open `misconception` on the objective before explaining — if there is one, the explanation must attack it, not restate the concept.

| Diagnosed gap | Strategy |
|---|---|
| missing vocabulary | definition plus the smallest possible example |
| wrong mental model (open misconception) | a counterexample that breaks the model, then the correct model |
| does not see why it exists | present the problem first, let them feel it, then reveal the mechanism as the answer |
| confuses two concepts | contrast pair — the same situation handled by both, and where they diverge |
| understands but cannot apply | worked example, then the same shape with the decision left blank |
| knows it but slowly / with lookup | not an explanation problem. Schedule retrieval, do not re-explain. |

The last row matters: re-explaining something the user already understands but has not consolidated feels productive and does nothing. The fix is retrieval practice, not more exposition.

## Then choose the artifact format from the same diagnosis

The table above decides *what to say*. When the answer is going to be a `/mentor-class` rather than a reply in the conversation, a second question follows from the same diagnosis: *what medium says it*. Same discipline — it follows from what is missing, not from preference or rotation.

| Diagnosed gap | Shape of the difficulty | Format |
|---|---|---|
| missing vocabulary · does not see why it exists | conceptual — the idea itself has not landed | **written + narrated** (`.md` + `.mp3`) |
| wrong mental model · confuses two concepts | conceptual, needs a counterexample or a contrast pair | **written + narrated**, or a **component map** when the two things being confused are components rather than ideas |
| understands the parts, loses the order | procedural — what happens when | **diagrammed walkthrough** (`.md` with Mermaid) |
| understands but cannot apply — cannot get started against an unfamiliar tool | practical — the first line of code is the wall | **scratch notebook** (`.ipynb`) |
| understands each piece, not how they fit | structural — the relationships are the gap | **component map** (`.html`) |
| knows it but slowly / with lookup | **not a class at all** | schedule retrieval; generate nothing |

The last row is the same guard as in the table above, and it is the one most often ignored: producing an artifact for something already understood feels like help and is pure cost. Say that the fix is retrieval and let `/mentor-review` resurface it.

Pick **one** format. Two only when the difficulty genuinely has two faces — no vocabulary *and* no sense of how the pieces connect. Never all four. `references/classes.md` holds the full protocol and the storage convention; `references/audio.md` and `references/class-diagrams.md` hold the production details for the two formats that have them.

If the diagnosis is unclear, one question settles it: *what part is unclear — what it is, the order things happen in, how the pieces fit, or getting the first line of code to run?*

## Analogies

Analogies are a first-contact tool and a consolidation liability. Any analogy used must be delivered with the point where it breaks, in the same message. An analogy without its boundary is how durable misconceptions get installed.

Do not use analogies for an objective already at `explains` or above — at that point they blur a model that is already correct.

## Project examples

Prefer examples drawn from the user's actual repo and current feature over generic ones. They are more concrete, they transfer directly, and they cost nothing. Respect the code policy: illustrate with structure and pseudocode, not with the implementation the user owes.

## User overrides

If the user explicitly asks for a format — "explain it like I'm five", "just give me the analogy", "compare it to the other one" — their request wins over this table, immediately and without negotiation. These heuristics decide what Claude does *unprompted*.

## Feynman protocol

Used in `/mentor-close`, and available on request.

1. Name the scope: "explain what you built in this feature and why, as if teaching someone who knows the language but not this tool."
2. **Do not interrupt.** Let the whole explanation land. Interrupting turns it into a dialogue, and dialogue lets Claude supply the connective tissue the user is missing — which is exactly what is being measured.
3. While listening, note: terms used without mechanism; circular definitions ("it's for partitioning, so it partitions"); jumps where a *why* is missing; correct statements with no visible reason underneath; and anything they avoided.
4. Then report the gaps, in order of importance, one at a time. For each, ask the follow-up that would close it rather than closing it yourself.
5. **Rejected-alternative pass.** For one or two of the decisions covered, ask why a plausible alternative approach was *not* taken. Log this as `feynman_rejection`. A shallow-but-correct understanding can usually defend the choice made; it much less often can attack the option it did not take, which makes this the higher-value half of the exercise.
6. Log one evidence line per objective the explanation covered — including objectives that were expected in the scope and never came up. An objective the user forgot to mention while explaining their own feature is meaningful evidence.

A clean Feynman explanation is strong evidence for `explains` and cheap to run. A clean rejected-alternative answer supports `decides`. Neither is a substitute for a real decision under stated conditions — pair with a scenario when the objective's target is `decide`.
