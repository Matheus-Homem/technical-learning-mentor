# technical-learning-mentor

A Claude Code / Cursor skill for **learning through a real project** instead of receiving one.

It answers a single question, per task, before any code is written:

> **Do I write this, do I steer while the AI writes it, or do I hand it over?**

The answer comes from what you actually know — not from how hard the task looks, and not from how tired you are at 22:00.

## The problem

Working with an AI agent on a project you took on in order to *learn something* has a failure mode that is invisible while it is happening: the project finishes, and you didn't. The code is right, the tests pass, and six weeks later you cannot explain why any of it is shaped the way it is.

The fix is not "never let the AI write code" — hand-writing boilerplate you've written a hundred times buys nothing and costs hours that the things you *are* learning needed. The fix is deciding, deliberately and in advance, which is which.

## How it works

```
   Gemini Notebook                          your repo
  ┌──────────┐
  │ sources  │
  │ quizzes  │──/mentor-sync──►  .mentor/gemini-notebook/snapshot.json
  │ ledger   │                            │
  └──────────┘                            │       .mentor/domain.md   (you)
        ▲                                 │       .mentor/nodes.md    (derived)
        │                                 ▼
        │      spec skill ──tasks──►  /mentor-map
        │                                 │
        │                                 ▼
        │                   Task → Knowledge → own | paired | delegated
        │                                 │
        │                   ┌─────────────┴─────────────┐
        │                   ▼                           ▼
        │             /mentor-tasks               /mentor-class
        │           (work the verdicts)        (material for the gaps)
        │                                             │
        └─────────────── you study, you test ─────────┘
```

**Gemini Notebook is the source of truth for knowledge.** It holds your sources and it owns whether you understand something. This skill does not test you, grade you, or track your retention — it reads that state and decides what to do with it.

## Three dimensions, three owners

The thing this skill gets right is refusing to answer three different questions with one field.

| | Question | Levels | Owner |
|---|---|---|---|
| **Domain** | do I want to develop this? | 1–4 | **you** — self-declared |
| **Comprehension** | is the basic theory proven? | 2–4 | **Gemini Notebook** — proven |
| **Application** | does this materialise into an artifact? | 4 | **derived** — a property of the concept |

Each has exactly one owner and one file, and no field is ever written by two parties. That is what makes divergence between the skill and your notebook structurally impossible rather than merely discouraged.

## The taxonomy

Every piece of knowledge is a node in a four-level hierarchy:

```
{Subject}.{Technology}.{Component}.{Property}

SistemasDistribuidos.ApacheKafka.ReplicacaoDeParticoes.InSyncReplicasMinimas
ArquiteturaDeSoftware.DomainDrivenDesign.AgregadosEInvariantes.ConsistenciaTransacional
```

The hierarchy exists so that **Domain inherits**. Declare it once at the top:

```
SistemasDistribuidos.ApacheKafka = waived
```

and every node beneath it follows — no enumeration, no per-node bookkeeping. Override surgically where the sweep is wrong:

```
SistemasDistribuidos.ApacheKafka.ExactlyOnceSemantics = developing
```

The longest declared prefix wins. Declarations are sparse and inheritance is resolved at read time, never written to disk — so there is no second copy of a fact to go stale.

## The verdict

Per required node:

| Domain | Comprehension | Application | → |
|---|---|---|---|
| `waived` | * | * | *drops out of the calculation* |
| `mastered` | `yes` | * | `paired` |
| `mastered` | `no` | * | `paired` + **contested** |
| `developing` | * | `practical` | `own` |
| `developing` | * | `theoretical` | `paired` |

Then per task: waived nodes drop out, and the most demanding survivor wins (`own > paired > delegated`). Nothing left → `delegated`.

**A waived node does not delegate a task on its own.** It removes itself, and whatever else the task requires still decides — otherwise one peripheral "I already know Kafka" would erase the learning in everything next to it.

Every verdict ships with its trace:

```
T7  own
    ← SistemasDistribuidos.ApacheKafka.Retencao.TombstoneDelay
        domain        = developing  (default — no declaration on any prefix)
        comprehension = no          (Gemini Notebook, 2026-08-19)
        application   = practical   (derived: becomes delete.retention.ms in the topic config)
    other nodes: 1 waived (inherited from …ApacheKafka), 1 paired
```

A verdict you can't audit is one you'll stop trusting — including the ones that were right.

## Commands

| Command | When | What it does |
|---|---|---|
| `/mentor-sync` | before mapping, after study | pulls Comprehension from Gemini Notebook; asks for Domain on new level-2 nodes. The only command that talks to Gemini Notebook. |
| `/mentor-map` | right after the spec skill produces tasks | derives required nodes, resolves all three dimensions, applies the matrix, writes the map |
| `/mentor-tasks` | any time | verifies open checkboxes against real code, then shows what's left grouped by verdict |
| `/mentor-class <topic>` | stuck, or before a `class-first` task | teaching material in the format that fits the kind of not-knowing |

## Classes: three kinds of not-knowing

> If I don't know what a **gear** is, I want to read and hear an explanation.
>
> If I know what a gear is but not how to fit one, I want a small assembly exercise before touching a real machine.
>
> If I know how to use a gear but not where it sits, I want a map of the machine.

| Category | Sounds like | You get |
|---|---|---|
| **conceptual** | "what is this?" | written explanation, optionally narrated to `.mp3` |
| **practical application** | "how do I use this?" | a notebook or exercise — **always incomplete** |
| **architectural** | "how does this fit?" | Mermaid, a diagram, a self-contained `.html` |

The incompleteness in the middle row is the rule the whole code policy now rests on. Reading a worked solution produces the *feeling* of understanding without the fact of it.

A class never marks anything as understood. It ends by pointing back at your notebook — which is the only path by which anything becomes proven.

## Install

Run from the root of the project you want it in:

```bash
curl -fsSL https://raw.githubusercontent.com/Matheus-Homem/technical-learning-mentor/main/install.sh | bash -s -- claude
# or: ... | bash -s -- cursor
```

Re-running updates in place.

### The optional DESIGN pairing rule

The installer offers one extra thing, and **asks before installing it**, because it is the only part that writes outside the skill's own directory and the only part that changes how *other* skills behave.

It stops any spec-driven skill from generating the design and the task list fully automatically — you review and approve the structure, then the tasks, before the design file is written.

- creates `.claude/mentor-design-pairing.md`
- adds three lines between markers at the end of your `CLAUDE.md`
- applies to **every** skill in the repo, not just this one

Default is no. `--with-design-pairing` / `--no-design-pairing` skip the prompt for non-interactive use. To remove it, delete the block between the markers.

## Design decisions

**A snapshot, not a live query.** There is no public consumer API for Gemini Notebook. Every command reads Comprehension from one local file, and only `/mentor-sync` writes it. Verdicts stay deterministic, the skill works offline, and when the transport breaks there is exactly one thing to fix.

**The ledger comes from real evidence, not memory.** Gemini Notebook persists full per-question quiz and flashcard results natively — confirmed live, not just from docs. There is no cross-quiz aggregation built in, so `/mentor-sync`'s default move is handing you a prompt for the notebook's own chat: point it at your node ids, it rereads its own Studio results, and returns the ledger grounded in what you actually got right or wrong. Plain self-report is still there as a fallback for a node no quiz has touched yet.

**Application is a property of the concept, not of you.** `practical` means *there exists an artifact whose production would demonstrate this* — config, a query, a command, a diagram. It is derived once, on creation, and pinned. Two runs on unchanged inputs must produce identical verdicts, and they can't if a classification is regenerated on each read.

**Self-declaration wins, contradiction stays visible.** You said `mastered`, your notebook says `no`? The verdict follows you — you know your own level better than one test does. But it is listed as **contested**, and reconciling it is never done on your behalf.

**Delegation with a toll, not a ban.** Raising a verdict is free. Lowering one costs a dated line saying which task and why. Delegation decided in advance is a strategy; delegation decided at 22:00 on a task that turned out to be boring is the path of least resistance wearing a strategy's clothes.

**No retention clock.** Deliberately removed with the assessment machinery. Retention belongs to whoever owns the testing, and that is Gemini Notebook. Stated here so it doesn't read as an oversight.

**The tree costs something.** A hierarchy forces each node into one branch, and the best concepts sit on seams. That is accepted in exchange for inheritance — a task can require nodes from any number of subtrees, and `nodes.md` carries cross-tree links for navigation, which the matrix deliberately never reads.

## Layout

```
technical-learning-mentor/
├── SKILL.md                 core rules, state layout, routing
├── install.sh               installer + the consent-gated DESIGN rule
├── commands/                one procedure per slash command
│   └── mentor-{sync,map,tasks,class}.md
├── references/              doctrine, read on demand
│   ├── knowledge-model.md     the taxonomy and the three dimensions
│   ├── task-matrix.md         the deterministic verdict rules
│   ├── gemini-notebook-contract.md the snapshot schema and transports
│   ├── classes.md             the three class categories
│   ├── code-policy.md         what may be written at each verdict
│   ├── teaching.md · audio.md · class-diagrams.md
├── templates/               seed files for .mentor/, + design-pairing.md
├── scripts/md-to-audio/     narration pipeline
└── tests/                   installer consent suite + resolution oracle
```

State lives in `.mentor/` in *your* repo, outside `.claude/`/`.cursor/` so it is client-agnostic. Almost all of it is versioned: it's small, it diffs well, and `git log` on it is a timeline of your own progress for free. The exception is `/mentor-class` artifacts — regenerable session output — though the index beside them is kept.

## Tests

```bash
bash tests/test-install-consent.sh    # 24 checks on the installer's consent flow
bash tests/test-resolution.sh         # resolution + matrix against a hand-written gabarito
```

The second one is an oracle, not an implementation: the prose in `references/` is normative. It exists so "deterministic" is a checkable claim rather than an aspiration.
