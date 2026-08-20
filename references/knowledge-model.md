# Knowledge model

## The unit is a taxonomy node

Every piece of knowledge in this skill is a node in a four-level hierarchy:

```
{Subject}.{Technology/CoreConcept}.{Component/Mechanism}.{BusinessRule/Property}
```

```
SistemasDistribuidos.ApacheKafka.ReplicacaoDeParticoes.InSyncReplicasMinimas
ArquiteturaDeSoftware.DomainDrivenDesign.AgregadosEInvariantes.ConsistenciaTransacional
```

The four levels are a progression of granularity, and each one answers a different question:

| Level | Name | What it holds |
|---|---|---|
| 1 | Subject | the field — `SistemasDistribuidos`, `ArquiteturaDeSoftware` |
| 2 | Technology / Core concept | the thing being studied — `ApacheKafka`, `DomainDrivenDesign` |
| 3 | Component / Mechanism | the part of it — `ReplicacaoDeParticoes`, `AgregadosEInvariantes` |
| 4 | Business rule / Property | the specific claim or property — `InSyncReplicasMinimas` |

Level 4 is where the skill does its real work. It is the only level granular enough to correspond to something a person actually produces: a line of configuration, a command, a query, a diagram, a decision in a concrete scenario.

## Form rules

- Segments are `PascalCase`, ASCII only. No accents, no spaces, no hyphens, no underscores. `Replicação` → `Replicacao`.
- Validation: `^[A-Z][A-Za-z0-9]*(\.[A-Z][A-Za-z0-9]*){0,3}$`
- **Depth 4 is required** for: anything a task requires, anything carrying an Application classification, and any node a `/mentor-class` names.
- **Depth 1–3 is allowed only** for Domain declarations (that is what makes inheritance work) and for Comprehension coming from NotebookLM.
- A node at depth *n* is a strict prefix of its descendants. **The tree is implicit in the set of ids** — there is no tree file, and there is nothing to keep in sync.

Human input is normalised, never rejected. The user types `kafka replicação ISR`; the skill proposes the canonical id and **confirms before writing it**. A wrong id contaminates everything beneath it, so this confirmation is not optional. Accepted spellings go in the `aliases` column of `nodes.md`.

### What the tree costs, and what pays for it

A hierarchy forces each node into exactly one branch, and the most valuable knowledge in a real project often sits on the seam between two areas. That cost is real and it is accepted deliberately, because the hierarchy is what makes inheritance possible — declaring `SistemasDistribuidos.ApacheKafka` as `waived` and having every descendant follow is worth more than the seams it hides.

Two things limit the damage:

- a task may require any number of nodes, from any number of subtrees;
- `nodes.md` carries a `related` column for cross-tree links, used by `/mentor-class` and shown in `/mentor-map` output.

`related` is presentation and navigation only. **The task matrix never reads it.** A cross-link that could change a verdict would reintroduce, through the back door, exactly the ambiguity the hierarchy exists to remove.

## Three independent dimensions

The three questions this skill used to answer with one field are now three separate dimensions, with three separate owners and three separate files. **No field is ever written by two parties.** That is the whole mechanism preventing divergence between the skill and NotebookLM.

| Dimension | Question | Levels | Owner | File |
|---|---|---|---|---|
| **Domain** | do I want to develop this? | 1–4 | the user, self-declared | `.mentor/domain.md` |
| **Comprehension** | is the basic theory proven? | 2–4 | NotebookLM, proven | `.mentor/notebooklm/snapshot.json` |
| **Application** | does this materialise into an artifact? | 4 | the AI, derived | `.mentor/nodes.md` |

The skill **never** writes Comprehension. NotebookLM **never** sees Domain or Application.

---

## Domain — self-declared, inherited

Values: `waived`, `mastered`, `developing`.

| Value | Meaning |
|---|---|
| `waived` | not to be developed now — may be delegated to the AI |
| `mastered` | the user declares they already have this |
| `developing` | actively being built |

Declarations live in `.mentor/domain.md` and are **sparse**: there is a row only for what was declared explicitly. Most nodes have no row at all, and that is the normal state.

### Resolution

The **effective Domain** of node `N` is the declaration on the **longest prefix of `N` that has one**.

With no declaration on any prefix, the effective Domain is **`developing`** — the default errs toward learning, which is the safe direction for a skill whose purpose is learning.

There is never a tie: the prefixes of a single id are totally ordered, so "longest prefix with a declaration" always identifies exactly one row.

### Inheritance and override

Inheritance is just the resolution rule seen from above. Declaring:

```
SistemasDistribuidos.ApacheKafka = waived
```

makes every node beneath it resolve to `waived` — no per-descendant declaration needed, and no descendant rows are created.

Override is just the resolution rule seen from below. Adding:

```
SistemasDistribuidos.ApacheKafka.ExactlyOnceSemantics = developing
```

makes that subtree resolve to `developing` while its siblings stay `waived`. **Precedence is always specificity.** An explicit declaration on a node always beats anything it would inherit, because it is a longer prefix of itself.

### Inheritance is never written to disk

Resolution happens at read time, every time. Materialising inherited values into rows would create a second copy of a fact that already exists, and second copies go stale — which is the exact failure mode this model was restructured to eliminate.

Every resolved value carries its origin, and the origin is shown wherever the value is:

```
waived    (inherited from SistemasDistribuidos.ApacheKafka, declared 2026-07-02)
developing (default — no declaration on any prefix)
```

---

## Comprehension — proven, from NotebookLM

Values: `yes`, `no`. A node **absent from the snapshot** is `unknown`.

Comprehension answers one question: **does the user command the basic theory of this concept**, even with no practical experience of it in a real scenario? It is a *proven* classification, not a declared one — which is why the skill does not produce it. NotebookLM holds the sources, runs the testing, and owns this dimension end to end. The contract is in `references/notebooklm-contract.md`.

It exists at levels 2, 3 and 4. Not at level 1: "does the user understand SistemasDistribuidos" is not a question with an answer.

### Comprehension does not inherit, in either direction

Knowing level 2 does not prove level 4. Knowing one level-4 node proves nothing about its sibling. Unlike Domain — which is a *decision* and therefore propagates — Comprehension is an *observation*, and an observation about one node is not an observation about another.

Roll-ups exist for display only (`3/7 nodes proven under ApacheKafka`) and never feed the matrix.

### `unknown` is not `no`

For the matrix, `unknown` is treated as `no` — the conservative reading.

For everything the user sees, they are kept apart, because the action each one implies is different:

- `no` — it was tested and it did not hold. Study it.
- `unknown` — it was never tested. Take it to NotebookLM.

Collapsing the two would hide the second, which is the more common case and the more actionable one.

---

## Application — derived, level 4 only

Values: `practical`, `theoretical`.

Application classifies **the nature of the node**, not the user's history with it. The question is:

> Is there a class of artifact — code, a terminal command, a configuration file, a query, a technical diagram, the analysis of a specific scenario, the resolution of a concrete problem — whose production would directly demonstrate this node?

Yes → `practical`. No → `theoretical`.

```
SistemasDistribuidos.ApacheKafka.ReplicacaoDeParticoes.InSyncReplicasMinimas
  → practical    becomes min.insync.replicas=2 in the broker config

SistemasDistribuidos.TeoremaCAP.TradeoffLatenciaConsistencia.LimiteTeorico
  → theoretical  no artifact "is" this
```

This is why Application exists only at level 4. Levels 1–3 are categories; only level 4 is specific enough for the question to have an answer.

### It is derived once and does not drift

Application is derived when the node is first created — by `/mentor-map` from a task, or by `/mentor-class` from a topic — and then **it does not change on its own**.

- The user may override it. `source: user` is permanent and is never re-derived.
- A deliberate re-derivation is available as `/mentor-map --rederive <node>`.
- Nothing else touches it.

The reason is determinism. AI derivation is not stable across runs, and Application feeds the task matrix directly. A task whose verdict silently changes between two `/mentor-map` runs, with no input having changed, destroys the user's ability to trust any verdict — including the correct ones.

### What the derivation may look at

The node's own id, the `excerpt` from the NotebookLM snapshot if the node has one, and the text of the task that required the node. The justification is recorded in one line in the `why` column of `nodes.md`, and it is written at the same moment as the value.

---

## Files

```
.mentor/
  profile.md                   config: spec artifacts, active feature, notebook, staleness budget
  domain.md                    Domain declarations — sparse, user-owned
  nodes.md                     node registry + Application — skill-owned
  notebooklm/
    snapshot.json              Comprehension — NotebookLM-owned, replaced whole each sync
    sync-log.md                append-only record of what each sync changed
  features/<slug>/
    map.md                     Task → Knowledge → verdict, with the trace
    classes/                   /mentor-class output — NOT version-controlled
      index.md                 ledger of classes produced — version-controlled
```

Templates for each are in `templates/`. Read the template before creating a file for the first time.

Everything in `.mentor/` is written in English. The values stored on disk are the English ones (`waived`/`mastered`/`developing`, `yes`/`no`/`unknown`, `practical`/`theoretical`, `own`/`paired`/`delegated`); what the user is shown uses the Portuguese terms (`Waived`/`Mastered`/`Developing`, `Sim`/`Não`/`Desconhecido`, `Teórico`/`Prático`).

## What this model does not do

**Nothing in this skill tracks retention or reminds the user to review anything.** There is no review queue, no spacing clock, no decay model. Earlier versions had one; it was removed together with the assessment machinery, because retention belongs to whoever owns the testing, and that is now NotebookLM.

This is stated explicitly so it does not read as an oversight. If the user expects the skill to resurface a concept they have not touched in six weeks, it will not.
