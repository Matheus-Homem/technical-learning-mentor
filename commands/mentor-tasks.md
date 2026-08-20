# /mentor-tasks

`/mentor-tasks [feature-slug] [--all]` — read-only status util. Sync checkboxes to reality, then show the full remaining scope grouped by who writes it. Never: writes to `.mentor/`, classifies nodes, contacts NotebookLM.

Renamed from `/mentor-next`. Step 1 is unchanged; step 2 groups by the matrix verdict.

## Resolve file(s)
- source: `spec_artifacts` in `.mentor/profile.md`. Never hardcode a filename or a skill's shape.
- match: any file with checkbox syntax (`- [ ]`/`- [x]` + local variants). **not assumed = `tasks.md`**.
- none found: ask the user, don't fabricate.
- `feature-slug` arg → that feature's artifacts; else `profile.md.active_feature`.

## Step 1: sync
per unchecked line:
1. read the full item: title, description, acceptance criteria, verification method (gate cmd / test / file ref) — whatever format the file uses.
2. verify independently (the file's own prose = not proof):
   - named runnable check → run it
   - else → read the referenced source/test files; behavioral + untested → throwaway read-only repro
   - never edit prod/test code as a side effect
3. classify → `done`: check + inline note in the file's existing style | `open/partial`: leave unchecked, note new findings | `deferred`: use the file's own marker, never mark done
4. never write code to force a pass (diagnose only; `references/code-policy.md` "Never" list applies)
5. write: touch only checkbox state + inline notes. no prose/renumber/unverified edits.

## Step 2: show
1. re-read post-sync.
2. extract dependency info the source file already states (explicit "depends on"/"blocked by" notes, phase headers, task numbering/ordering). never fabricate a dependency the file doesn't evidence — no info = mark `independent`.
3. group primary axis = verdict from `map.md`, order `own → paired → delegated`. own first: only the user can start those, so they see what's on them before what the agent could take off their plate.
4. within each group: per item — what | status (not-started / in-progress: gap / blocked) | dependency tag (`blocked by: Tn` / `blocks: Tn, Tm` / `independent`). flag anything broken found in step 1.
5. **one trace line per item**, naming the deciding node from `map.md` — not the full resolution, just the node and its Domain:
   `← Kafka.Retencao.TombstoneDelay (developing, practical)`
   A verdict the user cannot connect back to a node is a verdict they will stop trusting.
6. surface `map.md` flags inline: `contested`, `class-first`, `manual-override`.
7. close with **independent tracks**: cluster remaining tasks (across groups) into chains with no cross-dependency, so the user can see what's parallelizable.
8. append: accepted deferred debt.
9. append: the split (`3 own, 1 paired, 4 delegated`); mostly-delegated → flag in 1 line.
10. open item w/o a `map.md` row → list + flag remap due (`mentor-map.md`). **don't assign a verdict here** — that is `/mentor-map`'s job, and deriving one in the moment is the AI deciding whether the AI may write the code.

## Lowering a verdict
The user may lower a task in the moment (`own → paired → delegated`). Allowed, and it stays deliberate: say what you're doing, and write the dated line into `map.md` `## Notes`. Raising is free. See `references/task-matrix.md`.

This is the one write to `.mentor/` this command may make, and only on the user's explicit word.

## Output & context budget
- Step 2 items: 1 line each + 1 trace line, no exceptions. Never restate the source file's own prose — point at it (`Tn`), don't quote it.
- Only narrate a verification in Step 1 when it changes state or surfaces a new finding. A check that just confirms "still open, nothing new" produces no standalone output.
- `spec_artifacts`/`active_feature`: reuse what was already resolved this session instead of re-reading `profile.md`.
- Don't re-`Read` a task/source/test file already read this session unless it may have changed.
- Runnable checks: scope to the item (`pytest -k <name>`), not the full suite; extract only the pass/fail signal, don't carry the full log into the response.

## Boundary
This = project state, never knowledge state. A checkbox flip is not evidence of anything, and it never moves Comprehension — that lives in NotebookLM and arrives through `/mentor-sync`.
