# /mentor-sync

**Pulls the current knowledge state from Gemini Notebook into the local snapshot.** This is the only command that talks to Gemini Notebook. Read `references/gemini-notebook-contract.md` before running it.

`/mentor-sync [--full] [--dry-run] [--detect-mcp]`

Target time: 2–5 minutes.

## What it owns

| | |
|---|---|
| **Reads** | `profile.md` (`gemini_notebook_*`), the current `snapshot.json`, `nodes.md` |
| **Writes** | `snapshot.json` (replaced whole), `sync-log.md` (append), new declarations in `domain.md`, `gemini_notebook_transport` in `profile.md` (only after step 1c, only with confirmation) |
| **Never** | infers Comprehension; writes a Domain declaration without asking; sets `gemini_notebook_transport` without asking; is called by another command |

## Steps

**1. Bootstrap the repo if needed.**

If `.mentor/` does not exist, create it from `templates/` — `profile.md`, `domain.md`, `nodes.md`, `gemini-notebook/snapshot.json`, `gemini-notebook/sync-log.md`, and `templates/mentor-gitignore` → `.mentor/.gitignore`. Ask for:

- the path or glob to the spec artifacts → `spec_artifacts`
- which notebook holds the knowledge ledger → `gemini_notebook_id`

Never hardcode a filename for the spec artifacts. Accept whatever path or glob the user gives.

**1b. Check for a v2 install.**

If `.mentor/knowledge.md` or `.mentor/features/*/evidence.jsonl` exists, this repo is on the old model. **Stop and ask before writing anything.** On confirmation, rename `.mentor/` to `.mentor-v2-archive/`, add that path to the repo's `.gitignore`, and bootstrap fresh. Nothing is read from the archive and nothing is deleted — the old state is kept, just out of the way. Without confirmation, do nothing at all.

**1c. Detect an available MCP — once, or on request.**

Runs in exactly two situations: right after step 1's bootstrap, while `gemini_notebook_transport` still holds the value the template just seeded it with; or when `--detect-mcp` is passed explicitly. **Never on an ordinary run.** A transport already set to anything else — `manual` chosen deliberately, or a `mcp:<server>` already configured — is a decision, not a guess to re-make silently on every sync.

Check whether a known Gemini Notebook MCP server is available in this session (search the available tools; candidates are tracked in `references/gemini-notebook-contract.md`, alongside what's actually confirmed working — treat anything not marked confirmed as untested).

- **Nothing found** → proceed with `manual`. Do not ask again until `--detect-mcp` is passed.
- **Found** → say what was found and what it can do, then **ask before using it**. This is the same discipline as the installer's DESIGN-pairing prompt: a tool that drives a browser against the user's Google account is not something to turn on just because a process happened to be running.
  - Confirmed → write `gemini_notebook_transport: mcp:<server>` to `profile.md` and use it for step 2, this run and every run after, until the user changes it.
  - Declined → proceed with `manual` for this run. Do not ask again until `--detect-mcp` is passed.

**2. Resolve the transport.**

From `profile.md`'s `gemini_notebook_transport` (as it stands after step 1c, if that ran):

- **`manual`** — the ledger comes from the notebook's own chat reading its own Studio quiz/flashcard results, not from the user typing an assessment from memory. If there are nodes worth checking — anything in `nodes.md` with no entry in the current snapshot, or a feature's `## Gaps` — **hand the user the ready-to-paste prompt from `references/gemini-notebook-contract.md`, with those node ids already filled in.** They run it in the notebook's chat and bring back the table it produces. A node no quiz has touched yet, or one the user wants to assert without waiting on a quiz, uses the plain self-report table instead — same reference, the fallback variant.
- **`mcp:<server>`** — call that server's chat-send tool with the same extraction prompt `manual` would have handed the user, and read its reply exactly as a pasted table. If it fails for any reason, **fall back to `manual` for this run and say so** — never toggle `gemini_notebook_transport` back on a failure, that stays the user's call. Never let a broken transport end the command — the manual path always works, and that is the point of having it.

**3. Canonicalize loose entries, then validate.**

A row's `node` will not always be a proper id — most often on the **first sync of a project**, before any `/mentor-map` has run and `nodes.md` has nothing to copy from. The user, or the notebook's chat, will reasonably use plain words instead (`broker`, `kafka`) rather than invent a taxonomy id nobody told them.

Before rejecting anything, try to canonicalize:

- Check `nodes.md` and the current snapshot first — reuse an existing id (or its alias) if one plainly matches.
- Otherwise, propose a canonical id from the label plus its `excerpt`, exactly as `/mentor-map` does for a new node (`references/knowledge-model.md`). A quiz excerpt about "recommended broker technology" and "decoupling" is enough context to propose something like `SistemasDistribuidos.ApacheKafka.Broker.EscolhaDeTecnologia` — but propose it, never assume it silently.
- **Show the proposals together and confirm before writing anything.** One batch confirmation for a short list is fine; let the user edit any single one.
- A row whose excerpt is too thin to propose anything responsible, or that the user declines to canonicalize, is **reported and dropped** — same as an unrecoverable typo.

This step never writes to `nodes.md` — that stays `/mentor-map`'s and `/mentor-class`'s job. It only decides which id a Comprehension entry is filed under in `snapshot.json`. If that node doesn't exist in `nodes.md` yet, the entry simply waits there until a later `/mentor-map` derives the same node from a task and finds the Comprehension already sitting for it.

**4. Validate every id** against the regex in `references/knowledge-model.md`.

Anything still malformed after canonicalization is **reported and dropped**, never guessed. Same for an entry whose `comprehension` is missing or is not `yes`/`no` — treat it as absent and report it.

Report rejections as a group at the end, with the reason for each.

**5. Show the diff before writing.**

Against the current snapshot: added, changed (`no` → `yes` and the reverse), removed, rejected, and any canonicalized from step 3 (old label → proposed id). Removals matter — a node that left the ledger stops being proven, and any verdict resting on it moves.

With `--dry-run`, stop here. Write nothing.

**6. Write.**

Replace `snapshot.json` whole. Append one block to `sync-log.md` per the template's format.

**7. Ask for Domain on new level-2 nodes.**

For every level-2 node in the snapshot with no declaration on any prefix in `domain.md`, ask once:

> `SistemasDistribuidos.ApacheKafka` — do you want to develop this, do you already have it, or is it not for now? (Developing / Mastered / Waived)

Level 2 is the default depth because that is where inheritance pays most: one answer settles an entire technology. Deeper declarations are made on demand, when `/mentor-map` surfaces a node the inherited value gets wrong.

Write the answers to `domain.md` with today's date. **Ask, never assume** — this is the one dimension that is the user's by definition.

With `--full`, ask about level-3 nodes too. Use it after a large sync, not routinely — the questionnaire growing every run is what makes people stop answering it honestly.

## Output

- which transport ran (`manual`, or `mcp:<server>`), and whether step 1c changed `gemini_notebook_transport` this run
- counts: added / changed / removed / rejected, and the snapshot total
- any node that went `yes` → `no` (a regression is worth naming out loud)
- the new Domain declarations recorded
- if any node was removed or regressed, one line: which feature maps rest on it, and a suggestion to re-run `/mentor-map`

Do not classify anything here and do not teach anything here. This command moves state; the reasoning happens in `/mentor-map`.
