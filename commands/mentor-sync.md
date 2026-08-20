# /mentor-sync

**Pulls the current knowledge state from NotebookLM into the local snapshot.** This is the only command that talks to NotebookLM. Read `references/notebooklm-contract.md` before running it.

`/mentor-sync [--full] [--dry-run]`

Target time: 2–5 minutes.

## What it owns

| | |
|---|---|
| **Reads** | `profile.md` (`notebooklm_*`), the current `snapshot.json`, `nodes.md` |
| **Writes** | `snapshot.json` (replaced whole), `sync-log.md` (append), new declarations in `domain.md` |
| **Never** | infers Comprehension; writes a Domain declaration without asking; is called by another command |

## Steps

**1. Bootstrap the repo if needed.**

If `.mentor/` does not exist, create it from `templates/` — `profile.md`, `domain.md`, `nodes.md`, `notebooklm/snapshot.json`, `notebooklm/sync-log.md`, and `templates/mentor-gitignore` → `.mentor/.gitignore`. Ask for:

- the path or glob to the spec artifacts → `spec_artifacts`
- which notebook holds the knowledge ledger → `notebooklm_notebook`

Never hardcode a filename for the spec artifacts. Accept whatever path or glob the user gives.

**1b. Check for a v2 install.**

If `.mentor/knowledge.md` or `.mentor/features/*/evidence.jsonl` exists, this repo is on the old model. **Stop and ask before writing anything.** On confirmation, rename `.mentor/` to `.mentor-v2-archive/`, add that path to the repo's `.gitignore`, and bootstrap fresh. Nothing is read from the archive and nothing is deleted — the old state is kept, just out of the way. Without confirmation, do nothing at all.

**2. Resolve the transport.**

From `profile.md`'s `notebooklm_transport`:

- **`manual`** — the ledger comes from the notebook's own chat reading its own Studio quiz/flashcard results, not from the user typing an assessment from memory. If there are nodes worth checking — anything in `nodes.md` with no entry in the current snapshot, or a feature's `## Gaps` — **hand the user the ready-to-paste prompt from `references/notebooklm-contract.md`, with those node ids already filled in.** They run it in the notebook's chat and bring back the table it produces. A node no quiz has touched yet, or one the user wants to assert without waiting on a quiz, uses the plain self-report table instead — same reference, the fallback variant.
- **`mcp:<server>`** — query the configured MCP server for the ledger's content. If it fails for any reason, **fall back to `manual` and say so**. Never let a broken transport end the command — the manual path always works, and that is the point of having it.

**3. Validate every id** against the regex in `references/knowledge-model.md`.

An invalid id is **reported and dropped**, never repaired. A malformed id is usually a typo, and guessing the intended node is how the wrong node gets marked as understood. Same for an entry whose `comprehension` is missing or is not `yes`/`no` — treat it as absent and report it.

Report rejections as a group at the end, with the reason for each.

**4. Show the diff before writing.**

Against the current snapshot: added, changed (`no` → `yes` and the reverse), removed, rejected. Removals matter — a node that left the ledger stops being proven, and any verdict resting on it moves.

With `--dry-run`, stop here. Write nothing.

**5. Write.**

Replace `snapshot.json` whole. Append one block to `sync-log.md` per the template's format.

**6. Ask for Domain on new level-2 nodes.**

For every level-2 node in the snapshot with no declaration on any prefix in `domain.md`, ask once:

> `SistemasDistribuidos.ApacheKafka` — do you want to develop this, do you already have it, or is it not for now? (Developing / Mastered / Waived)

Level 2 is the default depth because that is where inheritance pays most: one answer settles an entire technology. Deeper declarations are made on demand, when `/mentor-map` surfaces a node the inherited value gets wrong.

Write the answers to `domain.md` with today's date. **Ask, never assume** — this is the one dimension that is the user's by definition.

With `--full`, ask about level-3 nodes too. Use it after a large sync, not routinely — the questionnaire growing every run is what makes people stop answering it honestly.

## Output

- counts: added / changed / removed / rejected, and the snapshot total
- any node that went `yes` → `no` (a regression is worth naming out loud)
- the new Domain declarations recorded
- if any node was removed or regressed, one line: which feature maps rest on it, and a suggestion to re-run `/mentor-map`

Do not classify anything here and do not teach anything here. This command moves state; the reasoning happens in `/mentor-map`.
