# Classes

`/mentor-class` is the skill's teaching-material instrument. It produces support material for something blocking the user right now. It is not an assessment, and its output is never the user's task deliverable.

## Three kinds of not-knowing

Learning questions fall into three categories, and each one needs a different medium. Getting this wrong is the most expensive mistake this command can make: the right content in the wrong form does not land.

The analogy that fixes the distinction:

> If I don't know what a **gear** is, I want to read and hear an explanation of what it is and what it's for.
>
> If I know what a gear is but not how to fit one, I want a small assembly exercise before trying it on a real machine.
>
> If I know how to use a gear but not where it sits in the machine, I want a map of the machine showing how the components relate.

| Category | The question sounds like | Format | Files |
|---|---|---|---|
| **Conceptual** | "what is this?", "what is it for?", "why does it exist?" | written explanation, optionally narrated | `<slug>.md` (+ `<slug>.mp3`) |
| **Practical application** | "how do I use this?", "how do I start?" | something to complete — never a solution | `<slug>.ipynb`, or incomplete code, or an exercise |
| **Architectural** | "how does this fit with the rest?", "where does this sit?" | a visual representation | `.md` with Mermaid, or `<slug>.html` / `<slug>.svg` |

## Identifying the category

First from the shape of the question — most are unambiguous. "What is a consumer group" is conceptual; "how do I commit an offset" is practical; "how does the consumer talk to the coordinator" is architectural.

When it is genuinely ambiguous, **one** disambiguating question, and only one:

> Você não sabe *o que isso é*, não sabe *como usar*, ou não sabe *onde isso se encaixa*?

"Explain X to me" is not a diagnosis. But interrogating someone who is stuck is its own cost — ask once, take the answer, move.

**One format by default.** Two only when the difficulty genuinely has two faces — the user lacks the vocabulary *and* cannot see how the pieces connect. Never three. Producing everything buries the one artifact that would have helped under two that will not be opened. If a topic seems to need all three, the topic is too big; split it.

Say which format you picked and why, in one line, before generating. It makes the diagnosis visible and lets the user redirect it cheaply.

## The practical category is always incomplete

**This is the rule the whole code policy rests on now.**

The output of a practical-application class is *always* missing pieces the user must supply. A notebook with cells to fill in, code with the decisive lines removed, an exercise with a stated goal and a blank body.

Handing over something complete and runnable in this category is ordinary code delivery wearing a class's clothes. The point of the category is to force application — reading a worked solution produces the feeling of understanding without the fact of it, and that feeling is the exact failure this skill exists to prevent.

What may be complete: the scaffolding around the gap. Imports, setup, the client instantiation, the assertion that tells them whether they got it right. What may not: the part that answers the question they asked.

This bounds the exception in `references/code-policy.md`. It applies whatever the file extension is.

## Every class names a node

A class serves one or more **depth-4 taxonomy nodes**. If the node does not exist yet, create it in `nodes.md` with `origin: class`, deriving Application at the same moment — confirming the canonical id with the user first, like anywhere else.

A class that cannot name a node is a signal, not an error: either the topic needs decomposing to depth 4, or it is not really project knowledge.

**Category and Application should agree.** A request for practical application on a node classified `theoretical` means one of the two is wrong — most often the Application derivation. Say so and offer `/mentor-map --rederive <node>`.

## What a class may and may not change

| Dimension | May a class touch it? |
|---|---|
| **Application** | Yes — it may create a node and derive it, or surface that an existing derivation is wrong. |
| **Domain** | It may *propose* a declaration, by asking. Never write one silently. |
| **Comprehension** | **Never, by any path.** |

The last row is absolute. A class going well is not proof of anything — the user has just been shown the answer, which is the worst possible moment to measure whether they knew it. Comprehension is proven in Gemini Notebook and arrives through `/mentor-sync`.

So a class ends by pointing at the loop rather than closing it: *take this to your notebook, test it there, and it will come back on the next sync.*

## Annotation

Every format, always: **annotate**. Every non-obvious block, cell, step, or edge carries a one-line explanation of *why*, not just what — the reasoning that is normally invisible in a finished artifact. That annotation is what makes it teaching material rather than a delivery, and it is required in all three categories.

## Where the output goes

```
.mentor/features/<slug>/classes/<topic-slug>/
```

Always nested inside a feature. The artifacts are **not** version-controlled — session-derived output, regenerable. The `index.md` beside them **is**: one line per class (`date | topic | node | category | format`), so the record that a class happened survives even though the artifact does not.

Say once, when handing an artifact over, that the folder is not tracked and they can move or commit a copy if they want to keep it.

## Boundary

`references/code-policy.md` governs anything the user owns as part of their actual deliverable. A class is adjacent material, never the deliverable in disguise.

The test, in every category: **would this artifact, pasted into the project, be the thing the user was supposed to write?** Then it is not a class. If a request for a class is really a request for the task, say so and help them with the structure and the next hint instead.
