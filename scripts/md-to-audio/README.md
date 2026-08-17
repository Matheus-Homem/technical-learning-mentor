# md-to-audio

Turns a Markdown class into an MP3 narration. Used by `/mentor-class` when the
chosen format is **written + narrated**.

```
<slug>.md  →  [1] prepare_narration.py  →  [2] MANUAL REVIEW  →  [3] generate_audio.py  →  <slug>.mp3
```

Do not skip step 2, and do not treat a backgrounded step 3 as finished just
because the output file exists.

**The full procedure, prerequisites, per-step guidance and both warnings live in
`references/audio.md`.** Read that, not this file. This note exists so anyone
who lands in this directory first knows where to go.

- `prepare_narration.py` — strips markdown, expands abbreviations, applies the
  glossary, splits em-dash asides.
- `generate_audio.py` — synthesizes with `edge-tts` (needs internet).
- `narration_glossary.json` — ships **empty**. Do not add project-specific
  terms here: this file is versioned as part of the skill and is copied into
  every project that installs it. Real glossary entries go in
  `.mentor/narration_glossary.json` inside the project being mentored — not
  version-controlled there either, but scoped to that project instead of
  leaking into every install. See `references/audio.md`.
