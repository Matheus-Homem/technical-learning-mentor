# Component maps: the self-contained HTML class

One of the two output shapes of the **architectural** category in `references/classes.md` — the self-contained-HTML one, chosen when there are several components and how they relate is unclear. Output is a single `<topic-slug>.html` inside the class folder.

Use it when the difficulty is *structural*: which piece owns what, what talks to what, what is one-to-many, where a boundary sits. Prose describes those relationships one at a time and forces the reader to hold the whole graph in their head; a drawing shows them at once. If the difficulty is a *sequence* rather than a structure, use the other architectural shape instead — Mermaid inside the `.md` — it is cheaper and reads fine for ordered steps.

## Hard requirement: one self-contained local file

The file must open correctly by double-clicking it, from disk, in any browser, offline, on a machine that has never run this skill.

This is not a preference. This skill runs under Claude Code, Cursor, and Codex CLI, and the user reads these files outside all three. Anything that depends on one client's infrastructure — a hosted-artifact publish step, a preview pane, a viewer sandbox, a dev server — produces a class that exists only while that client is open. The deliverable is a file in `.mentor/`, and it has to work as a file.

Therefore:

- **No external requests of any kind.** No CDN scripts, no external stylesheets, no web fonts, no remote images, no `fetch`/XHR. A CDN link means the diagram is blank on a plane.
- **No build step and no local dependencies.** Not a React component, not a `.tsx`, not something that needs `npm`. One `.html` file, opened directly.
- **Inline everything.** CSS in a `<style>` block, any script in a `<script>` block, images as `data:` URIs if genuinely needed (usually they are not — draw with SVG).
- **Draw with inline SVG.** Hand-written `<svg>` in the document gives full control over layout, labelling and theming, and adds no dependency. Mermaid is not available here: rendering it needs a library, and the whole point of this format is a relationship graph laid out deliberately rather than by an auto-layout engine.
- **Do not assume any host feature.** No Artifact publishing, no client-provided runtime API, no viewer-injected theme, no CSS reset supplied by a wrapper. The file supplies its own everything.

## Theming: light and dark, three states

The user's browser is in one of three states: an explicit light choice, an explicit dark choice, or the OS default with no explicit choice at all. A file that only handles one of them is unreadable in the others — white text on white.

Define colours **once, as custom properties**, and redefine only those properties per theme. Never hardcode a colour on an element; if a colour's only definition lives inside a media query, the other state has no value for it.

```html
<style>
  :root {
    --bg: #f5f6f4;
    --surface: #ffffff;
    --surface-alt: #eceeec;
    --border: #dde1de;
    --text: #1a231f;
    --muted: #5c6a63;
    --accent: #0e766c;
  }
  @media (prefers-color-scheme: dark) {
    :root:not([data-theme="light"]) { /* dark values for the same tokens */ }
  }
  :root[data-theme="dark"] { /* the same dark values again */ }
</style>
```

Three blocks, in this order, and the reason for each:

1. **Bare `:root`** — the complete light palette. This is the fallback that always has a value.
2. **`@media (prefers-color-scheme: dark)` guarded by `:root:not([data-theme="light"])`** — covers the OS-default state, while letting an explicit light choice win.
3. **`:root[data-theme="dark"]`** — covers an explicit dark choice on a light-preferring OS.

Give `body` an explicit `background: var(--bg)` and `color: var(--text)`. A transparent body borrows whatever is behind it and stops being predictable.

Inside the SVG, use the same tokens: `fill: var(--surface)`, `stroke: currentColor`, `fill: var(--muted)`. Setting `fill: currentColor` on text and `stroke: currentColor` on lines makes most of the drawing follow `--text` for free, which is what keeps it legible in both themes without a second set of rules.

One trap: SVG `<marker>` contents do not inherit `currentColor` from the referencing element. An arrowhead defined once with `fill="currentColor"` picks up the colour at the `<defs>` site, not at the arrow. Define one marker per colour you actually use — a default one and an accent one is usually enough.

## Structure of the page

Beyond the drawing itself, the page should carry the reading of it. A diagram alone is a picture; a diagram with its reading is a class.

```
header        eyebrow (mentor · <feature> · <node ids>), title, one-sentence subtitle
figure        the SVG, inside a container with overflow-x: auto
figcaption    what the whole diagram says, in one paragraph
section       "how to read it" — one bullet per relationship, naming both ends
```

- The **eyebrow** ties the file back to the state on disk: which feature it came from, and which taxonomy nodes it serves. It is what makes a stray HTML file in `.mentor/` identifiable weeks later.
- The **relationship bullets** are the teaching content. One per edge or containment that was unclear, each naming both ends explicitly — `Controller → Broker: the controller holds no partitions, it only elects which broker leads each one`. This is the annotation requirement from `references/classes.md` applied to this format: every non-obvious relationship carries its *why*.
- Keep the page to one screen-width of content — `max-width` around 900px, centred. Wide SVGs scroll inside their own `overflow-x: auto` container; the page body itself must never scroll sideways.
- Give the `<svg>` a `role="img"` and an `aria-label` describing the whole diagram in prose. It costs one line, and it is also the best check on whether the diagram actually says something — if the label is hard to write, the drawing is unclear.
- `svg { max-width: 100%; height: auto; }` with a `viewBox`, so it scales instead of clipping.

## What makes one of these good

- **Draw the mechanism, not the vocabulary.** Boxes with the terms written in them teach nothing that a glossary would not. The value is in what connects them and what the connection constrains: this replica is the leader and that is why writes go here; these two are unordered relative to each other and that is why the key matters.
- **Show the constraint visually.** An idle fourth consumer drawn greyed out next to three partitions explains the parallelism ceiling faster than a sentence about it.
- **Include a legend** when more than one visual encoding is in play (filled vs. outlined, solid vs. dashed).
- **One diagram per file.** If a topic needs a second unrelated drawing, it is a second class.

The target: every term in the topic appears exactly once, positioned so that its relationship to the others is the thing the drawing shows.
