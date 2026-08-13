# /mentor-review

**Run after writing a meaningful chunk of code**, typically once or twice per feature. Optionally scoped: `/mentor-review <path>`.

This is the highest-value assessment in the skill. A decision the user made and can justify **in their own code** is the strongest evidence available for `decides`, and it costs nothing extra because the code already exists.

It is a review of understanding, not a code review. Style, naming and micro-optimisations are not the point and mostly should not be mentioned.

## Steps

**1. Read the diff.** `git diff` against the last review point, or the paths given. Record the reference point in the feature's `map.md` so the next review picks up from there.

**2. Map it to objectives.** Which objectives from `map.md` does this code exercise? Note also objectives the code *should* have exercised and does not — that gap is worth raising.

**3. Ask, do not tell.** Pick 2–4 decisions visible in the code and ask why. Good shapes:

> Why is this in `<file>` and not `<other file>`?
> What made you choose `<approach>` over `<alternative>`?
> If `<condition>` changed, what in here would have to change?
> What does this line protect against? What happens if it isn't there?

One at a time. Wait for each answer. Ask for confidence before responding.

**4. Distinguish three cases**, because they look identical in the code and are completely different as evidence:

| What happened | Verdict | Evidence |
|---|---|---|
| decided deliberately and can justify it | `correct`, strong | supports `decides` |
| it works but the reason given is wrong or absent | `partial` | open a misconception; do not promote |
| copied from a doc, tutorial or example without a model | `n/a` for mastery | log with `consulted: true`; treat as `unassessed`, not as evidence |

The third case is the one that silently inflates every tracking system. Ask directly where something came from when the code looks more confident than the user's understanding of it.

**5. Then give the review feedback** — problems that actually matter: correctness, structure, decisions that will hurt later. Under `references/code-policy.md`, describe the change; do not hand back rewritten code.

**6. Append evidence, update `knowledge.md`, regenerate `progress.md`.**
