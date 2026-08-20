# The task matrix

How a task gets its authorship verdict — `own`, `paired`, or `delegated` — from the knowledge it requires.

The matrix is **deterministic**. Same inputs, same verdict, every time. Nothing here is a judgement call made in the moment, and nothing here depends on how hard, how tedious, or how urgent the task looks.

## Step 1 — one verdict per Knowledge node

For each level-4 node a task requires, resolve the triple and read the row:

| Domain | Comprehension | Application | Verdict | Flag |
|---|---|---|---|---|
| `waived` | * | * | *excluded from the calculation* | |
| `mastered` | `yes` | * | `paired` | |
| `mastered` | `no` | * | `paired` | `contested` |
| `mastered` | `unknown` | * | `paired` | `unverified` |
| `developing` | * | `practical` | `own` | |
| `developing` | * | `theoretical` | `paired` | |

Reading it in words:

- **`waived`** — the user decided this competence is not to be developed now. The node drops out and contributes nothing.
- **`mastered`** — the user already has it, so they should not spend hours re-typing it, but they still steer: they define the solution and the AI executes. That is `paired`.
- **`developing` + `practical`** — the knowledge is being built and it materialises into an artifact. Writing that artifact *is* the learning. That is `own`.
- **`developing` + `theoretical`** — the knowledge is being built but nothing materialises it. There is no artifact whose authorship would teach anything, so the user directs and the AI writes. That is `paired`.

Nodes shallower than depth 4 never enter the matrix — they have no Application. If a task resolves only to shallow nodes, `/mentor-map` refines them to depth 4 before classifying rather than guessing.

### The two flags on `mastered`

`mastered` is self-declared; Comprehension is proven. When they disagree, the disagreement is surfaced and the verdict still follows the declaration:

- **`contested`** — the user declared `mastered`, NotebookLM says `no`. A real contradiction. The verdict stays `paired` because the user knows their own level better than one test does, but the contradiction is listed in its own block in the output, and resolving it — lowering the Domain, or retesting in NotebookLM — is the user's call. The skill never reconciles it on its own.
- **`unverified`** — the user declared `mastered` and NotebookLM has never seen the node. Not a contradiction, just an absence. Worth showing, not worth acting on.

### Optional refinement: `class-first`

`developing` + `practical` + Comprehension `no`/`unknown` is still `own` — but the user is about to write an artifact for something whose theory is not yet proven. Flag it `class-first` and offer a `/mentor-class` before they start.

This changes no verdict. It exists because without it Comprehension only has leverage on the `mastered` branch, which underuses the one dimension NotebookLM exists to feed.

## Step 2 — aggregate to the task

```
required = the depth-4 nodes the task requires
active   = [ k in required where effective Domain of k is not `waived` ]

if active is empty  →  task = delegated
else                →  task = max( verdict(k) for k in active )
                        order: own > paired > delegated
```

Two things this encodes:

- **A `waived` node cannot delegate a task on its own.** It removes itself, and whatever else the task requires still decides. A task that touches Kafka (waived) *and* an open Domain concept is not delivery work just because Kafka appeared in it.
- **The most demanding surviving node wins.** If any active node needs to be written by the user, the task is `own`. Learning is not averaged away by the presence of easier neighbours.

A task requiring nothing, or requiring only `waived` nodes, is `delegated`. That is a normal and healthy outcome, not a failure of the derivation.

## The trace is mandatory

Every verdict carries the node that decided it and the full resolution behind it:

```
T7  own
    ← SistemasDistribuidos.ApacheKafka.Retencao.TombstoneDelay
        domain        = developing  (default — no declaration on any prefix)
        comprehension = no          (NotebookLM, 2026-08-19)
        application   = practical   (derived: becomes delete.retention.ms in the topic config)
    other nodes: 1 waived (inherited from …ApacheKafka), 1 paired
```

**A verdict without its trace is not written.** An unexplainable verdict is indistinguishable from a guess, and the moment the user cannot audit one of them they stop trusting all of them — including the ones that were right.

Every line of the trace is checkable: the node exists in `nodes.md`, the Domain resolution names the declaration it came from, the Comprehension names its date, and the Application names its derivation.

## Changing a verdict by hand

**Raising** a verdict — `delegated` → `paired` → `own` — is free. The user wants to write more of it than the matrix suggested; there is no reason to put friction in front of that. Note it so the next `/mentor-map` does not quietly undo it.

**Lowering** a verdict — `own` → `paired` → `delegated` — requires a dated line in `map.md` under `## Notes`, saying which task and why.

The asymmetry is the point. Delegation decided in advance, from the knowledge state, is a strategy. Delegation decided at 22:00 on a task that turned out to be boring is the path of least resistance wearing a strategy's clothes, and the record is what keeps the two apart.

## Recomputation

Verdicts are recomputed on every `/mentor-map`, and they are *supposed* to move:

- a Domain declared `waived` since the last map drops its nodes out;
- Comprehension arriving from a sync can resolve a `contested` or `unverified` flag;
- new tasks get verdicts, deleted tasks lose their rows.

What does **not** move on its own is Application, which is derived once and pinned (`references/knowledge-model.md`). That is what makes "same inputs, same verdict" true in practice rather than only in principle.

Manual overrides survive a recomputation and are marked, so the recompute never silently reverses a choice the user made.
