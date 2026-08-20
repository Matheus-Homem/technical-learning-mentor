# technical-learning-mentor

A skill that **stops the AI from writing your code** and instead helps you learn what you need in order to build it yourself — while keeping an auditable record of what you've mastered, what's shaky, and what needs to come back.

Technology-agnostic. The curriculum is derived from your own specs and your own code, never from generic knowledge of a tool. Works with Claude Code, Cursor, and Codex CLI.

---

## The problem

Using AI to build produces finished projects and no learning. The obvious fix — "don't write my code, teach me" — only solves half of it: you learn during the conversation and nothing survives it. You answer, you get corrected, and a week later you can't say what stuck, what's still missing, or what you should revisit.

This skill treats **visibility of progress as the primary deliverable**. Assessments exist to feed the record. If a session produces judgement but doesn't update the state on disk, the session failed.

## The loop

Built to sit alongside a spec-driven development skill, but tied to none in particular — the path to your planning artifacts is configurable.

```
spec-driven produces plan → design → tasks
        ↓
/mentor-map          before writing any code — sorts knowledge into
                      decide / explain / delegate, then assigns each task
                      own / paired / deliver, ~5-10 min
        ↓
you develop           /mentor-class when something is blocking you, ~15 min each
                       /mentor-review after each block of code, and at session
                       start — your diff, then whatever is due, ~5-15 min
                       /mentor-next any time you want the full remaining
                       picture instead of chasing it turn by turn
        ↓
/mentor-close          when the activity is done, ~10-20 min
        ↓
next feature
```

The pace this runs at adapts on its own — see "the dual clock" below. A dense study block and a routine of an hour a day produce very different rhythms of these commands without any configuration change.

## Commands

| Command | When | What for |
|---|---|---|
| `/mentor-map` | as soon as the tasks are generated | sort required knowledge into decide/explain/delegate, name the limiting concept, assign each task its authorship level |
| `/mentor-class <topic>` | when something is blocking you: a delegated item, new material, a topic you're about to start | teaching material in the format that fits the difficulty — explanation, audio, diagram, notebook |
| `/mentor-review [path] [--time 5\|15\|30]` | after writing code — the default checkpoint — and at session start | your own code as the strongest evidence available, then spaced retrieval of whatever is due |
| `/mentor-next [feature-slug] [--all]` | any time — especially right after finishing something | syncs the task file's checkboxes against the real code, then shows the full remaining scope, not just the next item |
| `/mentor-close` | when the activity is finished | Feynman + rejected-alternative + decision scenarios (incl. one outside the project) + close the cycle |
| `/mentor-progress [--all\|--tag X]` | any time | see where you stand |

Day-to-day usage details are in [`MANUAL.md`](MANUAL.md) (written in Portuguese, like the progress panel — both are read by the user).

## Install

```bash
cd /path/to/your/project
curl -fsSL https://raw.githubusercontent.com/Matheus-Homem/technical-learning-mentor/main/install.sh | bash -s -- claude   # or: cursor
```

What the installer does, and why it differs by tool:

- **Claude Code** auto-discovers a skill placed at `.claude/skills/technical-learning-mentor/SKILL.md` from its frontmatter — no extra step. The installer clones the skill there and copies the five `/mentor-*` commands into `.claude/commands/`.
- **Cursor** has no native skill-folder auto-discovery. The installer clones the same skill content into `.cursor/skills/technical-learning-mentor/`, copies the five commands into `.cursor/commands/`, and adds an `alwaysApply` rule at `.cursor/rules/technical-learning-mentor.md` that points the model at the skill — that rule is what makes Cursor aware it exists.

The skill content itself — `SKILL.md`, `commands/`, `references/`, `templates/`, `scripts/` — is identical across both. Only where it's placed, and how much the host tool notices it without being told, differs. Re-running the installer updates an existing install in place (`git pull --ff-only`).

On the first `/mentor-map` in a repo, the skill asks for the path to your spec artifacts and stores it in `.mentor/profile.md`. It won't ask again.

State (`.mentor/`) lives at the project root, outside any tool-specific folder, and is versioned in git — with two narrow exceptions (see below).

## How knowledge is modelled

The unit is not a topic. A topic is a noun and can't be assessed — there's no fact of the matter about whether someone "knows partitioning". The unit is an **assessable claim** or a **decision rule**:

```
bad   → consumer offsets
good  → an offset commit records the next message to read, not the last one processed
good  → given a new external dependency, decide whether it needs a new port
```

Objectives carry free-form **tags**, not a tree. The most valuable knowledge in a real project lives on the seams between areas, and a hierarchy forces every objective into a single branch, hiding it from the others.

### Not everything becomes an objective

At `/mentor-map`, every candidate is sorted once, deliberately, into one of three buckets:

- 🎯 **decide** — a transferable trade-off you'll meet again in your career. Becomes an objective, gets scenarios.
- 📖 **explain** — needs to be understood and justified, not optimised. Becomes an objective, lighter assessment.
- 📦 **delegate** — mechanical coupling, lookup-able configuration. Never becomes an objective — handled by `/mentor-class` instead, which delegates the artifact but still extracts learning from it (annotated → questioned → a completion problem to fill in), rather than just handing it over.

The test: if the parameter encodes a trade-off you need to be able to navigate, it's learning. If it's plumbing between services, it's lookup. Learning everything a real project touches at decision-level depth isn't achievable under any real time budget — this makes that trade-off explicit and chosen once, instead of accidental.

### The mastery ladder

```
unassessed → declared → fragile → explains → decides → fluent
```

- **declared** — self-reported in the triage questionnaire. Weak evidence, and the ladder says so.
- **explains** — can say what it is, why it exists, and how it works, without looking it up.
- **decides** — can choose under stated conditions, justify the choice, and say what breaks under the wrong one.
- **fluent** — two independent evidences at target level, without lookup, **at least 14 days apart**.

`fluent` is the only state that requires elapsed time, and that's deliberate — including during a dense study block. Massed practice produces fast apparent gains and fast decay; nothing learned inside a short intensive stretch can be marked `fluent` within it. The panel says this plainly rather than leaving it looking like a gap.

Nothing is ever reported as a percentage. State plus named evidence, always.

### No scheduled review date — the dual clock

There's no predicted "next review" date stored anywhere. Predicting a date bakes in an assumed pace, and the moment that pace changes — an intensive week, then a routine of an hour a day — the stored date is silently wrong.

Instead, each objective stores two observed facts: when it was last touched (`last_seen`) and how many cumulative study hours had passed at that point (`last_seen_hours`). Every command that can trigger a review asks how long you've studied since last time, and computes due-ness fresh from both a calendar delta and a study-hours delta — whichever threshold is crossed first wins. In a dense session the hours clock fires first, correctly resurfacing this morning's material this afternoon. In a routine of an hour a day, the calendar clock fires first, because there forgetting — not dilution — is the risk. Same table, both regimes, no configuration.

### Evidence strength

Not every correct answer is worth the same:

```
self-report  <  multiple choice  <  short answer
             <  prediction before running  <  Feynman explanation
             <  a decision justified in your own code, or why the rejected
                alternative would have been worse, or a real bug diagnosed
```

Multiple choice has a ~25% floor from guessing and **never** promotes anything to `decides`. It lives in `/mentor-review`'s due-review pass as a cheap way to check material already learned through a stronger format — never the backbone.

## Design decisions

**Directness first.** Practice should resemble how the knowledge will actually be used. A prepared quiz is the most indirect format available; a decision justified in your own code, or a prediction made right before you run something, is the most direct. `/mentor-review` puts both in one call and orders them accordingly: the diff pass always runs in full, because the code already exists and evaluating it is nearly free; the spaced-retrieval pass takes whatever time is left. An objective your diff already exercised doesn't get re-asked as a quiz item — it was just answered in the strongest format there is.

**Delegation with a toll, not a ban.** For dense, mostly non-conceptual configuration, studying a worked example beats producing one from scratch — search for the right shape of the answer consumes the attention that would otherwise form the pattern. `/mentor-class` delivers the artifact, but only alongside annotation and targeted questions — and, whenever the artifact carries code, a completion problem you have to fill in. Passive delivery without those steps isn't covered by this exception.

**One artifact, chosen — not four, generated.** A class picks its format from the shape of the difficulty: prose plus audio when a concept hasn't landed, a Mermaid walkthrough when it's the order of steps, a scratch notebook when you can't get the first line of code to run, a self-contained HTML diagram when it's how several components relate. Producing all of them "to be safe" buries the one that would have helped. And one diagnosis produces no artifact at all: if you already understand it and are just slow, that's a retention problem, and generating an explanation is pure cost.

**Transfer is checked explicitly.** A project teaches the project, not always the underlying domain. Every close includes at least one decision scenario set outside the user's own project — the only reliable way to tell whether a principle was learned or just its one instance here.

**Calibration.** Before any correction is revealed, you state your confidence. **High confidence + wrong** is the most valuable signal the system produces: it marks knowledge you don't know you lack.

**Contesting doesn't overwrite state.** Disagreeing with a verdict schedules a fresh probe rather than rewriting the record.

**Judgement is auditable.** Every verdict records the criterion applied. A right conclusion with wrong reasoning is `partial`, not `correct`.

**Append-only log, bounded context.** A feature's evidence log is never rewritten, only appended to. At close it becomes `report.md` and is never read again. Only `knowledge.md` grows across the project, one row per objective.

**Authorship, not exposure — scoped to what you're still learning.** Every task gets one of three levels at `/mentor-map`, derived from where its objectives sit on the ladder: `own` (you write it), `paired` (you make and defend the decision, the model writes the mechanical body around it), `deliver` (the model writes it, you review). A task whose objectives are all at target is `deliver` — the gate closes on its own as you advance, instead of charging you full manual price forever for things you've already proved you know. Hand-writing work that carries no open objective doesn't protect the learning; it just spends the hours the open objectives needed.

Levels are decided once, up front, when the work still looks abstract — not in the moment it starts looking tedious. Raising one is free; lowering one mid-feature costs a dated line in `map.md`. And code the model wrote never enters the evidence log, so delegating can't inflate your record.

Within an `own` or `paired` task the old boundary is unchanged: the model reads and critiques your code, and — narrowly, dependent on where an objective sits on the ladder — produces a class for genuinely new material or delegate-bucket configuration. Of the four class formats only the scratch notebook contains runnable code at all: it exists so you can poke at an unfamiliar library and see what comes back, never so your task arrives in cells.

## Layout

```
technical-learning-mentor/
├── SKILL.md              core: rules and routing
├── MANUAL.md              usage manual (pt-BR)
├── README.md
├── commands/              procedure for each command
├── references/            knowledge-model · evidence-log · judging · teaching
│                          retention · classes · audio · class-diagrams
│                          code-policy
├── templates/             profile · knowledge · feature-map · report
│                          progress.html · mentor-gitignore
├── scripts/
│   └── md-to-audio/        the /mentor-class narration pipeline —
│                            prepare_narration.py · generate_audio.py
│                            narration_glossary.json (ships empty)
└── install.sh             copies the skill + commands for claude/cursor
```

State generated in your project:

```
.mentor/
├── .gitignore             ignores progress.html, narration_glossary.json,
│                          and features/*/classes/
├── profile.md              experience/target per tag, study_hours_total, config — versioned
├── knowledge.md             every objective, its state, and last_seen / last_seen_hours — versioned
├── progress.html            the panel — Portuguese content, derived — NOT versioned
├── narration_glossary.json  TTS pronunciation fixes, per project — NOT versioned
└── features/<slug>/
    ├── map.md                bucket sort, limiting objective, requirements — versioned
    ├── evidence.jsonl          append-only log — versioned
    ├── classes/<topic-slug>/     /mentor-class output — NOT versioned
    └── report.md                 written at close — versioned
```

Almost everything is versioned deliberately: `.mentor/` is meant to be a durable, auditable record, and `git log` on `knowledge.md` gives you a timeline of your own progress for free. The exceptions are purely derived or session-scoped output, plus the narration glossary — production trivia for TTS pronunciation, not evidence of learning.
