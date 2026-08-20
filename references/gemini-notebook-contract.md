# The Gemini Notebook contract

Gemini Notebook is the **source of truth for knowledge**. It holds the sources, it runs the testing, and it owns the Comprehension dimension. This skill consumes that state; it never produces it.

## The transport is a snapshot, not a live query

Every command in this skill reads Comprehension from **one local file**:

```
.mentor/gemini-notebook/snapshot.json
```

Only `/mentor-sync` writes it, and only `/mentor-sync` talks to Gemini Notebook. No other command may.

This indirection is deliberate and load-bearing:

- **There is no public consumer API for Gemini Notebook.** Google documents preview APIs for the Enterprise product only; everything else available is unofficial and works by driving a browser. Depending on that directly, from four commands, would make the whole skill as fragile as the least stable of them.
- **Snapshot reads are deterministic.** A live query returns whatever a model says this time. `/mentor-map` run twice on an unchanged repo must produce identical verdicts, and it cannot if its inputs are generated fresh on each read.
- **The skill keeps working offline**, and keeps working when the transport breaks. A stale snapshot degrades gracefully; a broken live call does not degrade at all.
- **One failure point instead of four.** When Gemini Notebook changes, exactly one command needs fixing.

## Schema

```json
{
  "schema": 1,
  "fetched_at": "2026-08-20T09:00:00Z",
  "source": "manual",
  "notebook_id": "…",
  "nodes": [
    {
      "node": "SistemasDistribuidos.ApacheKafka.ReplicacaoDeParticoes.InSyncReplicasMinimas",
      "comprehension": "yes",
      "asserted_at": "2026-08-19",
      "basis": "quiz",
      "excerpt": "min.insync.replicas defines how many replicas must acknowledge…"
    }
  ]
}
```

| Field | Meaning |
|---|---|
| `schema` | integer, currently `1`. Bump on any breaking change to this shape. |
| `fetched_at` | ISO 8601 UTC, when the sync ran. Drives the staleness warning. |
| `source` | `manual` or `mcp:<server>` — how this snapshot was obtained. |
| `notebook_id` | the notebook this came from, so a second notebook cannot silently overwrite the first. |
| `nodes[].node` | canonical taxonomy id, depth 2–4. Must match the regex in `references/knowledge-model.md`. |
| `nodes[].comprehension` | `yes` or `no`. Never `unknown` — absence *is* `unknown`. |
| `nodes[].asserted_at` | ISO date the assertion was made inside Gemini Notebook. |
| `nodes[].basis` | `quiz` or `flashcard` (from real Studio results — preferred), `note`, or `self-report-in-nlm` (the fallback for a node no quiz has touched yet). What backs the assertion. |
| `nodes[].excerpt` | optional, one or two lines. Feeds Application derivation and is shown when explaining a verdict. |

Rules:

- The file is **derived**. It is replaced whole on every sync and is never hand-edited. Editing it directly puts a claim about the user's knowledge into the skill's mouth, which is the one thing this design exists to prevent.
- It **is** version-controlled. It is small, it is the audit trail for every verdict the skill produced, and a diff of it is the most legible record of learning the project has.
- An id failing validation is **canonicalized with the user's confirmation first, then dropped if that fails**. Never silently repaired. `/mentor-sync` step 3 owns this — it is common on a first sync, before `/mentor-map` has ever run and there is no `nodes.md` to copy ids from.
- A node present with `comprehension` missing or unrecognised is treated as absent, and reported.

## Where the state comes from

`/mentor-sync` resolves its transport from `profile.md`'s `gemini_notebook_transport`.

### What the Phase 0 spike found

Confirmed live, not just from documentation: **Gemini Notebook does persist quiz and flashcard results natively**, at per-question granularity — which option was picked, the correct one, the explanation, the score — and it survives closing and reopening the notebook. This is richer than the contract originally assumed, and it means Comprehension does not have to rest on the user's unaided self-report.

What does **not** exist is any native aggregation across quizzes. Each quiz result is a separate entry in Studio; there is no built-in view that sums or compares them, and none that maps a quiz to a taxonomy node — Gemini Notebook has no idea this skill's taxonomy exists.

That gap is exactly what `/mentor-sync` is for. The mechanism that closes it turned out to be sitting inside Gemini Notebook already: **its own chat can read its own Studio artifacts.** Point it at the quiz/flashcard results and a list of node ids, and it produces the ledger directly from real per-question evidence — no export feature, no MCP, no API, and a stronger `basis` than self-report.

### `manual` — the default, and the one that always works

Two variants, in order of preference:

**(a) Chat-extracted ledger — the recommended pattern.** Give the notebook's own chat the node ids you need checked (from `nodes.md`, or the gaps listed by the last `/mentor-map`) and ask it to read the Studio quiz/test results and produce the ledger table. A working prompt:

```
Here is a list of topics. For each one, reread the quiz and test results
saved in this notebook's Studio and answer based on the questions actually
answered — not on what you think I know:

- yes, if the questions on that topic were answered correctly
- no, if any of them were answered wrong
- leave the topic out if no quiz/test has covered it yet

Topics:
<node ids if you have them; plain words are fine if you don't yet>

Reply as a markdown table:
| node | comprehension | date | basis | excerpt |
where date is the date of the most recent quiz that covered the topic, basis
is "quiz" or "flashcard", and excerpt is one line explaining why (you may
quote the explanation that already appeared in the quiz result).
```

**Have real ids on hand where you can** (from `nodes.md` or a `## Gaps` list) — the chat has no idea this skill's taxonomy exists, so it can't produce a canonical id on its own. On a first sync, before `/mentor-map` has run, there usually are no ids yet; plain topic words are the expected input then, and `/mentor-sync` canonicalizes what comes back — proposing an id from the label and the excerpt, and confirming it with you before writing anything.

This grounds every row in a real, dated, per-question result instead of a memory-based guess — a strictly stronger `basis` than plain self-report. It costs nothing extra: the evidence was already sitting in Studio, gathered as a side effect of studying, and this just reads it back.

One thing worth doing on the studying side to keep this clean: **scope each generated quiz to one node, or a small tight cluster**, rather than a broad multi-topic one. Per-question results only map cleanly onto a taxonomy node when the questions were already organised that way.

**(b) Direct self-report — the fallback**, for a node no quiz has touched yet, or when the user just wants to assert something without waiting on a quiz:

```markdown
| node | comprehension | date | basis |
|---|---|---|---|
| SistemasDistribuidos.ApacheKafka.ReplicacaoDeParticoes.InSyncReplicasMinimas | yes | 2026-08-19 | quiz |
```

Either way, the user brings the resulting table back — pasted in, or exported to a file the command is pointed at — and `/mentor-sync` validates it exactly the same. This is deterministic, needs no API, and cannot break when Gemini Notebook's UI changes, because the only interface it depends on is the chat panel every notebook already has.

### `mcp:<server>` — optional

If an MCP server for Gemini Notebook is configured, `/mentor-sync` may query it for the ledger's content instead of asking for a paste. The result must be validated against the schema above exactly as a manual paste is.

This is an ergonomic improvement, **never a dependency**. Every unofficial Gemini Notebook MCP works by browser automation and breaks when Google changes the interface. The skill must remain fully usable with `manual` forever — and the spike's finding means `manual` is no longer the compromise it looked like at design time.

## Staleness

`profile.md` carries `snapshot_max_age_days` (default 14).

When `fetched_at` is older than that, `/mentor-map` **warns and continues**. It does not block: a stale snapshot still produces a mostly-correct map, and no map at all produces nothing. The snapshot's age is printed in the `/mentor-map` output and written into the header of `map.md`, so a map built on old data cannot be mistaken later for one built on fresh data.

## The invariant

**The skill never writes Comprehension, by any path, for any reason.**

Not from a class the user completed, not from code they wrote, not from a question they answered correctly in conversation, not because a node's Domain says `mastered`, not to fill a gap so a map looks complete.

If the skill could write Comprehension, there would be two authorities on the same fact and no way to tell which one is current. Everything else in this model is arranged around that single constraint.

The loop closes the other way round: the skill produces material (`/mentor-class`), the user studies and tests **in Gemini Notebook**, and the result comes back through `/mentor-sync`.
