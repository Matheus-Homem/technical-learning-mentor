# Teaching

## Choose the strategy from the diagnosed gap

Explanation style is not a preference and not a rotation. It follows from what is actually missing.

| Diagnosed gap | Strategy |
|---|---|
| missing vocabulary | definition plus the smallest possible example |
| wrong mental model | a counterexample that breaks the model, then the correct model |
| does not see why it exists | present the problem first, let them feel it, then reveal the mechanism as the answer |
| confuses two concepts | contrast pair — the same situation handled by both, and where they diverge |
| understands but cannot apply | worked example, then the same shape with the decision left blank |
| knows it but slowly / with lookup | not an explanation problem. This is retrieval, and it belongs in NotebookLM. |

The last row matters: re-explaining something the user already understands but has not consolidated feels productive and does nothing. The fix is retrieval practice, not more exposition — and retrieval is not this skill's job. Say so and point at the notebook.

## Then choose the format from the same diagnosis

The table above decides *what to say*. When the answer is going to be a `/mentor-class` rather than a reply in conversation, the same diagnosis decides *what medium says it*.

The three categories are in `references/classes.md`. This table maps the gap onto them:

| Diagnosed gap | Category | Format |
|---|---|---|
| missing vocabulary · does not see why it exists | **conceptual** | written, optionally narrated (`.md` + `.mp3`) |
| wrong mental model · confuses two concepts | **conceptual** — needs a counterexample or a contrast pair; **architectural** instead when the two things being confused are components rather than ideas | `.md`, or a component map |
| understands the parts, loses the order | **architectural** — sequence is a relationship | `.md` with Mermaid |
| understands each piece, not how they fit | **architectural** | component map (`.html`/`.svg`) |
| understands but cannot apply — cannot get started against an unfamiliar tool | **practical application** | notebook or incomplete code — **always incomplete** |
| knows it but slowly / with lookup | **no class at all** | generate nothing; it is retrieval |

Pick **one** format. Two only when the difficulty genuinely has two faces — no vocabulary *and* no sense of how the pieces connect. Never three.

If the diagnosis is unclear, one question settles it, and only one: *what part is unclear — what it is, how to use it, or where it fits?*

`references/classes.md` holds the full protocol; `references/audio.md` and `references/class-diagrams.md` hold the production details for the two formats that have them.

## Analogies

Analogies are a first-contact tool and a consolidation liability. Any analogy used must be delivered with the point where it breaks, **in the same message**. An analogy without its boundary is how durable misconceptions get installed.

Do not reach for one when the node's Comprehension is already `yes` — at that point an analogy blurs a model that is already correct.

## Project examples

Prefer examples drawn from the user's actual repo and current feature over generic ones. They are more concrete, they transfer directly, and they cost nothing.

Respect the code policy: illustrate with structure and pseudocode, not with the implementation the user owes. For a `practical application` class, the example is the thing they complete — see the incompleteness rule in `references/classes.md`.

## Explaining back

Asking the user to explain a mechanism in their own words is the cheapest high-value thing available in conversation, and it remains useful — a fluent explanation with no hedging is a good signal, and a stall reveals exactly where the model is thin.

**It produces no record.** It is not logged, it does not move Comprehension, and it never marks anything as understood. This skill has no assessment instrument any more; what it has is a way to notice, in the moment, that a topic is worth taking to NotebookLM. Say that, and move on.
