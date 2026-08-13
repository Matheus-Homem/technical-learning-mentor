# project-mentor

A Claude Code skill that **stops Claude from writing your code** and instead helps you learn what you need in order to build it yourself — while keeping an auditable record of what you've mastered, what's shaky, and what needs to come back.

Technology-agnostic. The curriculum is derived from your own specs and your own code, never from Claude's generic knowledge of a tool.

---

## The problem

Using AI to build produces finished projects and no learning. The obvious fix — "don't write my code, teach me" — only solves half of it: you learn during the conversation and nothing survives it. You answer, you get corrected, and a week later you can't say what stuck, what's still missing, or what you should revisit.

This skill treats **visibility of progress as the primary deliverable**. Assessments exist to feed the record. If a session produces judgement but doesn't update the state on disk, the session failed.

## The loop

Built to sit alongside a spec-driven development skill, but tied to none in particular — the path to your planning artifacts is configurable.

```
spec-driven produces plan → design → tasks
        ↓
/mentor-map          before writing any code          ~5 min
        ↓
you develop          (predictions, questions, hints)  ~free
        ↓
/mentor-review       after the first code lands       ~5 min
        ↓
/mentor-eval         optional, whenever               5 / 15 / 30 min
        ↓
/mentor-close        when the activity is done        ~10-15 min
        ↓
next feature
```

Roughly **20 minutes per feature**, concentrated in the map and the close. The middle of development is nearly free: predictions and code review happen inside work you were doing anyway.

## Commands

| Command | When | What for |
|---|---|---|
| `/mentor-map` | as soon as the tasks are generated | find out what this activity requires you to know |
| `/mentor-review [path]` | after writing code | turn your own code into the strongest evidence available |
| `/mentor-eval [--time 5\|15\|30]` | whenever you want | cover gaps and pull in due reviews |
| `/mentor-close` | when the activity is finished | Feynman explanation + decision scenarios + close the cycle |
| `/mentor-progress [--all\|--tag X]` | any time | see where you stand |

Day-to-day usage details are in [`MANUAL.md`](MANUAL.md) (written in Portuguese, like the progress panel — both are read by the user).

## Install

```bash
# from your project root
mkdir -p .claude/skills .claude/commands

git clone https://github.com/<you>/project-mentor .claude/skills/project-mentor
cp .claude/skills/project-mentor/install/commands/*.md .claude/commands/
```

On the first `/mentor-map`, the skill asks for the path to your spec artifacts and stores it in `.mentor/profile.md`. It won't ask again.

State (`.mentor/`) lives at the project root, versioned in git, **outside** `.claude/`. That way updating the skill never touches your learning history, and `git log` on `.mentor/knowledge.md` gives you a timeline of your progress for free.

## How knowledge is modelled

The unit is not a topic. A topic is a noun and can't be assessed — there's no fact of the matter about whether someone "knows partitioning". The unit is an **assessable claim** or a **decision rule**:

```
bad   → consumer offsets
good  → an offset commit records the next message to read, not the last one processed
good  → given a new external dependency, decide whether it needs a new port
```

Objectives carry free-form **tags**, not a tree. The most valuable knowledge in a real project lives on the seams between areas, and a hierarchy forces every objective into a single branch, hiding it from the others.

### The mastery ladder

```
unassessed → declared → fragile → explains → decides → fluent
```

- **declared** — self-reported in the triage questionnaire. Weak evidence, and the ladder says so.
- **explains** — can say what it is, why it exists, and how it works, without looking it up.
- **decides** — can choose under stated conditions, justify the choice, and say what breaks under the wrong one.
- **fluent** — two independent evidences at target level, without lookup, **at least 14 days apart**.

`fluent` is the only state that requires elapsed time, and that's deliberate. The real goal is using the knowledge without searching, the way you use your language's basic syntax — that's automaticity, and automaticity can't be demonstrated inside a one-week feature. Any system that hands out "mastered" at the end of a cycle is measuring something else.

Nothing is ever reported as a percentage. State plus named evidence, always.

### Evidence strength

Not every correct answer is worth the same:

```
self-report  <  multiple choice  <  short answer
             <  prediction before running  <  Feynman explanation
             <  a decision justified in your own code
```

Multiple choice has a ~25% floor from guessing and **never** promotes anything to `decides`. Weak evidence doesn't accumulate into strong evidence: two correct MCQs are not one justified decision.

## Design decisions

**Spaced repetition instead of "don't repeat".** Returning to the same objective *is* the consolidation mechanism. A fixed 3 → 7 → 21 → 60 day ladder, interleaved with new material. What's avoided is re-asking an identical item in a short window.

**Calibration.** Before any correction is revealed, you state your confidence. **High confidence + wrong** is the most valuable signal the system produces: it marks knowledge you don't know you lack, and it's invisible without this step.

**Contesting doesn't overwrite state.** Disagreeing with a verdict schedules a fresh probe rather than rewriting the record. State is a belief backed by evidence; it changes when new evidence arrives, not when the argument gets uncomfortable.

**Judgement is auditable.** Every verdict records the criterion applied. A right conclusion with wrong reasoning is `partial`, not `correct` — that's how tracking systems silently inflate.

**Append-only log, bounded context.** A feature's evidence log is never rewritten, only appended to. At close it becomes `report.md` and is never read again. Only `knowledge.md` grows across the project, one row per objective — that's what keeps context from blowing up in month three.

**Authorship, not exposure.** Claude doesn't write what you owe. It can read and critique your code, and it can show minimal external surface where pseudocode would destroy the meaning. If you genuinely want something delegated, just say so — the point is to make delegation a deliberate choice, not the path of least resistance.

## Layout

```
project-mentor/
├── SKILL.md              core: rules and routing
├── MANUAL.md             usage manual (pt-BR)
├── README.md
├── commands/             procedure for each command
├── references/           knowledge-model · evidence-log · judging
│                         teaching · retention · code-policy
├── templates/            profile · knowledge · feature-map
│                         progress · report
└── install/commands/     thin slash commands for .claude/commands/
```

State generated in your project:

```
.mentor/
├── profile.md            experience and target level per tag, config
├── knowledge.md          every objective in the project and its state
├── progress.md           the panel — pt-BR, derived, disposable
└── features/<slug>/
    ├── map.md            what the feature requires and where it came from
    ├── evidence.jsonl    append-only log
    └── report.md         written at close
```

## Status

V2. V1 worked but left no trace — this version exists to fix that.

Two things still being calibrated, adjustable in `references/` without touching the architecture:

- whether `/mentor-map` produces well-formed objectives or slides back into topic lists;
- whether the ~20 min per feature budget holds up in real use.

## License

MIT
