# The NotebookLM contract

NotebookLM is the **source of truth for knowledge**. It holds the sources, it runs the testing, and it owns the Comprehension dimension. This skill consumes that state; it never produces it.

## The transport is a snapshot, not a live query

Every command in this skill reads Comprehension from **one local file**:

```
.mentor/notebooklm/snapshot.json
```

Only `/mentor-sync` writes it, and only `/mentor-sync` talks to NotebookLM. No other command may.

This indirection is deliberate and load-bearing:

- **There is no public consumer API for NotebookLM.** Google documents preview APIs for the Enterprise product only; everything else available is unofficial and works by driving a browser. Depending on that directly, from four commands, would make the whole skill as fragile as the least stable of them.
- **Snapshot reads are deterministic.** A live query returns whatever a model says this time. `/mentor-map` run twice on an unchanged repo must produce identical verdicts, and it cannot if its inputs are generated fresh on each read.
- **The skill keeps working offline**, and keeps working when the transport breaks. A stale snapshot degrades gracefully; a broken live call does not degrade at all.
- **One failure point instead of four.** When NotebookLM changes, exactly one command needs fixing.

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
| `nodes[].asserted_at` | ISO date the assertion was made inside NotebookLM. |
| `nodes[].basis` | `quiz`, `flashcard`, `note`, or `self-report-in-nlm`. What backs the assertion. |
| `nodes[].excerpt` | optional, one or two lines. Feeds Application derivation and is shown when explaining a verdict. |

Rules:

- The file is **derived**. It is replaced whole on every sync and is never hand-edited. Editing it directly puts a claim about the user's knowledge into the skill's mouth, which is the one thing this design exists to prevent.
- It **is** version-controlled. It is small, it is the audit trail for every verdict the skill produced, and a diff of it is the most legible record of learning the project has.
- An id failing validation is **reported and dropped**, never silently repaired. A malformed id usually means a typo in the ledger, and guessing the intended node is how the wrong node gets marked as understood.
- A node present with `comprehension` missing or unrecognised is treated as absent, and reported.

## Where the state comes from

`/mentor-sync` resolves its transport from `profile.md`'s `notebooklm_transport`.

### `manual` — the default, and the one that always works

The user maintains a **ledger document as a source inside the notebook**:

```markdown
| node | comprehension | date | basis |
|---|---|---|---|
| SistemasDistribuidos.ApacheKafka.ReplicacaoDeParticoes.InSyncReplicasMinimas | yes | 2026-08-19 | quiz |
```

They keep it current as they study and test, and `/mentor-sync` reads it — pasted in, or exported to a file the command is pointed at.

This looks low-tech and it is the strongest option available. It is deterministic, it needs no API, it cannot break when a UI changes, and it keeps the assertion authored by the person who did the testing.

### `mcp:<server>` — optional

If an MCP server for NotebookLM is configured, `/mentor-sync` may query it for the ledger's content instead of asking for a paste. The result must be validated against the schema above exactly as a manual paste is.

This is an ergonomic improvement, **never a dependency**. Every unofficial NotebookLM MCP works by browser automation and breaks when Google changes the interface. The skill must remain fully usable with `manual` forever.

## Staleness

`profile.md` carries `snapshot_max_age_days` (default 14).

When `fetched_at` is older than that, `/mentor-map` **warns and continues**. It does not block: a stale snapshot still produces a mostly-correct map, and no map at all produces nothing. The snapshot's age is printed in the `/mentor-map` output and written into the header of `map.md`, so a map built on old data cannot be mistaken later for one built on fresh data.

## The invariant

**The skill never writes Comprehension, by any path, for any reason.**

Not from a class the user completed, not from code they wrote, not from a question they answered correctly in conversation, not because a node's Domain says `mastered`, not to fill a gap so a map looks complete.

If the skill could write Comprehension, there would be two authorities on the same fact and no way to tell which one is current. Everything else in this model is arranged around that single constraint.

The loop closes the other way round: the skill produces material (`/mentor-class`), the user studies and tests **in NotebookLM**, and the result comes back through `/mentor-sync`.
