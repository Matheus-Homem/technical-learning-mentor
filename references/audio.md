# Narrated classes: the md-to-audio pipeline

The scripts live at `scripts/md-to-audio/` in this skill. They are the narration half of the **written + narrated** format in `references/classes.md` — the one chosen when a concept or a piece of theory has not landed and the user wants to be able to review it away from a screen.

This pipeline does **not** write teaching content. It narrates content that already exists: `/mentor-class` writes the `<slug>.md`, and this turns that file into `<slug>.mp3`.

Run it only for the written format. A Mermaid walkthrough, a scratch notebook, and a component map have nothing useful to narrate.

## Prerequisites

- A Python environment with `edge-tts` installed (`pip install edge-tts`). Free, no API key, but **requires internet** — it calls Microsoft's neural TTS service. This is the default engine and the only one wired up in `generate_audio.py`.
- If there is no internet access, fall back to a local engine (`piper-tts`, `pip install piper-tts`, needs a downloaded `.onnx` voice model — see https://huggingface.co/rhasspy/piper-voices). Quality is noticeably worse and robotic. Use it only when edge-tts is unreachable, and **say so to the user** rather than presenting it as equivalent.

## The three steps

```
<slug>.md  →  [1] prepare_narration.py  →  [2] MANUAL REVIEW  →  [3] generate_audio.py  →  <slug>.mp3
```

Do not skip step 2. TTS reads text literally: markdown syntax, numbered-list markers, em dashes, abbreviations, and inline code identifiers all need adapting before synthesis or the audio comes out garbled or mispronounced. This was learned the hard way — the first raw attempt on unprepared text was reported as "barely understandable".

### Step 1 — `prepare_narration.py`

```bash
python3 scripts/md-to-audio/prepare_narration.py \
    .mentor/features/<slug>/classes/<topic-slug>/<topic-slug>.md \
    > .mentor/features/<slug>/classes/<topic-slug>/<topic-slug>-narration.txt
```

What it does automatically:

- Strips markdown syntax (headers, bold/italic, inline code, code fences, link-text extraction, `---` rules).
- Expands common abbreviations (`ex:`, `ex.:`, `p.ex.`, `etc.`, `i.e.`, `e.g.`, `vs.`, `obs.:`) via the `ABBREVIATIONS` dict — extend it in the script when a new one shows up misread, since TTS engines spell abbreviations letter-by-letter instead of expanding them.
- Applies a glossary — a substitution map for technical tokens that read badly out loud: hyphenated identifiers, `key=value` pairs, acronyms. See "The glossary lives per project" below for where to add entries.
- Splits em-dash asides (`— like this —`) into separate sentences, since a written em-dash does not map to a spoken pause the way a period does.

### The glossary lives per project, not in this skill

`prepare_narration.py` resolves the glossary in this order:

1. `--glossary <path>`, if given explicitly.
2. `.mentor/narration_glossary.json` under the current working directory, if it exists.
3. `scripts/md-to-audio/narration_glossary.json` next to the script — **ships empty, and must stay empty**.

Add terms to `.mentor/narration_glossary.json` in the project being mentored, not to the copy shipped with the skill. That file lives in `scripts/md-to-audio/` because it is versioned as part of the skill and gets copied into `.claude/skills/technical-learning-mentor/` (or the Cursor equivalent) on every install — anything written there ships to every project that installs or updates this skill next. A project's topic names, field names, and tool invocations belong to that project alone.

`.mentor/narration_glossary.json` is **not** version-controlled (see `.mentor/.gitignore`) — unlike `profile.md`/`knowledge.md`, it is not treated as part of the durable learning record, by deliberate choice: it is production trivia for making TTS sound right, not evidence of anything the user learned. This means it does not survive a fresh clone and has to be rebuilt (or copied over manually) if the user wants it on another machine — accepted cost of keeping it out of history.

If `.mentor/narration_glossary.json` does not exist yet, create it the first time a term needs an entry — an empty `{}` is fine to start from, same shape as the skill's own template:

```json
{
  "events-raw": "events raw",
  "RF3": "R F 3",
  "retention.ms=604800000": "retention ponto m s, igual a sete dias em milissegundos"
}
```

**Extend this per-project file** as new source documents surface bad-sounding terms — never hardcode one-off terms into `prepare_narration.py` itself, and never add project-specific entries to the skill's own copy.

### Step 2 — manual review, no script

Open the narration file, fix it **by direct edit, in place**. This is not an interactive exchange with the user and does not become one — it is a production step, not a mastery judgement, and it does not get logged.

What step 1 cannot do, and must be fixed by hand:

- **Numbered/bulleted list markers.** `1. Partições` reads oddly; rewrite as `Primeiro: partições.` (`Segundo:`, `Terceiro:`, or just drop the ordinal if the list is not emphasising order).
- **Leftover awkward joins from the em-dash split**, e.g. an aside that splits mid-clause and leaves a dangling `e.` — reread and rejoin or reword.
- **Symbolic shorthand not covered by the glossary**, e.g. `partições+chave` → "partições mais chave", inline `x = y` math.
- **Redundant restatements** that only made sense in writing, e.g. a value spelled out by the glossary immediately followed by `(7 dias)` repeating the same fact in parentheses — remove the redundant parenthetical.

Read the whole narration file top to bottom before moving on. This is a content-adaptation step, not a formatting nit — treat it with the same care as editing prose for a read-aloud script, because that is what it is. If the source is in Portuguese, keep the edits in Portuguese; do not translate.

### Step 3 — `generate_audio.py`

```bash
python3 scripts/md-to-audio/generate_audio.py \
    .mentor/features/<slug>/classes/<topic-slug>/<topic-slug>-narration.txt \
    .mentor/features/<slug>/classes/<topic-slug>/<topic-slug>.mp3 \
    --voice pt-BR-FranciscaNeural \
    --rate="-8%"
```

- `--voice`: pick from `edge-tts --list-voices | grep pt-BR` (or the target language's filter). Known-good pt-BR options: `pt-BR-AntonioNeural` (male), `pt-BR-FranciscaNeural` (female). Ask the user for a voice preference rather than assuming, and record it in `profile.md` → Notes if they state one.
- `--rate`: speed delta, e.g. `-8%`. Slightly slower than default reads more clearly for technical content; a reasonable starting default, not a hard rule.
- Output is MP3 directly, no post-processing needed for a single file. There is **no chunking/concatenation step**: a single `Communicate(...).save()` call handles the tested document sizes fine. If a source document is long enough that one edge-tts call becomes unreliable, chunk by paragraph and concatenate raw MP3 bytes (same-encoder CBR streams concatenate losslessly) rather than pulling in `pydub`/`ffmpeg` as a new dependency — this has not been needed yet, so do not add the complexity preemptively.

## Critical pitfall: do not check a backgrounded run too early

`generate_audio.py` can take over 120 seconds for a medium document, which auto-backgrounds the command in some harnesses. **Do not read the output file as "done" just because it exists and has bytes** — a partially written MP3 will play and cut off mid-sentence. This happened during development.

Wait for the actual completion signal: the task notification, or a foreground run with a long enough timeout. `generate_audio.py` prints `wrote <path> (<n> bytes)` and exits 0 only on real completion — use that, not file existence, as the done signal.

## Output location

Everything lands in the class folder, alongside the source:

```
.mentor/features/<slug>/classes/<topic-slug>/
  <topic-slug>.md               # the written class
  <topic-slug>-narration.txt     # step 1 output, after the manual review
  <topic-slug>.mp3                # the narration
```

Not version-controlled, like the rest of `classes/`. Only the scripts under `scripts/md-to-audio/` are versioned, as part of this skill.

## Non-Portuguese sources

The abbreviation set in `prepare_narration.py` is pt-BR-oriented. A source document in another language needs its own abbreviation entries and its own glossary terms (in `.mentor/narration_glossary.json`, per-project as above) before step 1 produces anything usable — check this before running rather than after listening.
