# /mentor-next

`/mentor-next [feature-slug] [--all]` — read-only status util. sync checkboxes to reality, then show full remaining scope. Never: assessment, `study_hours_total` write, `evidence.jsonl`/`knowledge.md` write.

## Resolve file(s)
- source: `spec_artifacts` in `.mentor/profile.md` (SKILL.md → "Locating the spec artifacts"). never hardcode filename/skill shape.
- match: any file with checkbox syntax (`- [ ]`/`- [x]` + local variants). not assumed = `tasks.md`.
- none found: ask user, don't fabricate.
- `feature-slug` arg → that feature's artifacts; else `profile.md.active_feature`.

## Step 1: sync
per unchecked line:
1. read full item: title, description, acceptance criteria, verification method (gate cmd / test / file ref) — whatever format the file uses.
2. verify independently (file's own prose = not proof):
   - named runnable check → run it
   - else → read referenced source/test files; behavioral + untested → throwaway read-only repro
   - never edit prod/test code as a side effect
3. classify → `done`: check + inline note in file's existing style | `open/partial`: leave unchecked, note new findings | `deferred`: use file's own marker, never mark done
4. never write code to force a pass (diagnose only; `references/code-policy.md` "Never" list applies)
5. write: touch only checkbox state + inline notes. no prose/renumber/unverified edits.

## Step 2: show
1. re-read post-sync.
2. extract dependency info the source file already states (explicit "depends on"/"blocked by" notes, phase headers, task numbering/ordering). never fabricate a dependency the file doesn't evidence — no info = mark `independent`.
3. group primary axis = authorship level, order `own → paired → deliver` (own first: only the user can start those, so they see what's on them before what the agent could take off their plate).
4. within each level group: per item — what | status (not-started / in-progress: gap / blocked) | dependency tag (`blocked by: Tn` / `blocks: Tn, Tm` / `independent`). flag anything broken/found in step 1.
5. close with **independent tracks**: cluster remaining tasks (across levels) into chains with no cross-dependency, so the user can see what's parallelizable (e.g. separate chats per track).
6. append: accepted deferred debt.
7. append: authorship split (`3 own, 1 paired, 4 deliver`); mostly-deliver → flag in 1 line.
8. open item w/o `map.md` level → list + flag remap due (`mentor-map.md`). don't assign levels here.
9. no "do this next" pick beyond dependency/order the source file already encodes.

## Output & context budget
- Step 2 items: 1 line each, no exceptions. Never restate the source file's own prose in the status text — point at it (`Tn`), don't quote it.
- Only narrate a verification in Step 1 when it changes state or surfaces a new finding. A check that just confirms "still open, nothing new" produces no standalone output — its result only shows up as the Step 2 line.
- `spec_artifacts`/`active_feature` resolution: reuse the result already resolved earlier in this session instead of re-reading `.mentor/profile.md`.
- Don't re-`Read` a task/source/test file already read earlier in this session unless it may have changed since.
- Runnable checks: scope to the item being verified (e.g. `pytest -k <name>`), not the full suite; if a command's output is long, extract only the pass/fail signal needed to classify — don't carry the full log into the response.

## Boundary: /mentor-review
this = project state, never mastery state. checkbox flip ≠ evidence. new code confirmed done + no review since map.md's "Last review point" → 1-line non-blocking suggestion, end of output.

## Args
- `--all`: include closed tasks too (mirrors `/mentor-progress --all`)
- `<feature-slug>`: target non-active feature
