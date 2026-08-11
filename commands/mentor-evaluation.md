---
description: Evaluate the user's understanding of a topic through scenario-based questions and trade-off discussion, not memorization checks.
argument-hint: <topic to evaluate>
---

Apply the `technical-learning-mentor` skill's interaction style (operating principles, adaptive assistance levels, feedback style) - invoke it now if it is not already active this session.

Evaluate understanding of: $ARGUMENTS

- Ask scenario-based questions rather than definition-recall questions.
- Discuss trade-offs and probe for knowledge gaps.
- Finish with a summary: mastered topics, developing topics, and topics that still need reinforcement.

## Before generating the evaluation

Read `.claude/skills/technical-learning-mentor/knowledge-profile.md`. If it has rows with `Proficiency` = `Needs Reinforcement` or `Developing`, ask the user whether they also want to revisit those previously identified weak points in this evaluation, in addition to the topic requested in `$ARGUMENTS`. Proceed based on their answer:

- **If yes**: pull topics primarily from `Needs Reinforcement` rows, and secondarily from `Developing` rows when directly related to those gaps. Prioritize topics with the lowest `Question Count` or the most recent/severe `Misconception Log` entries. Weave these into the evaluation alongside - never in place of - the explicitly requested topic.
- **If no**: evaluate only the requested topic. Still update `knowledge-profile.md` afterward with this evaluation's results.
- If `knowledge-profile.md` has no `Needs Reinforcement`/`Developing` rows yet, skip the question and evaluate only the requested topic.

## Question count and type

If the user does not specify how many questions or what type, default to:

- **5 multiple-choice questions**.
- **1 discursive question per major topic** requested (the explicit topic, plus - if opted in - the revisited weak-point topics count as additional major topics).

When there are multiple major topics, distribute discursive questions across them, but never exceed **3 discursive questions total** in one evaluation. Example distribution for two major topics: Q1-Q3 multiple-choice on the first topic, Q4 multiple-choice on the second topic, Q5 multiple-choice + 2 discursive (one per topic).

If the user does specify a count/type, honor that instead.

## After the user answers

1. Grade and discuss the answers per the skill's feedback style (direct, specific, strengths before gaps, why it matters, next action).
2. Give the closing summary (strengths, weaknesses, recommended study topics) as already required above.
3. Update `.claude/skills/technical-learning-mentor/knowledge-profile.md` based only on evidence observed in this evaluation:
   - Preserve existing topics that are still relevant.
   - Add new topics the evaluation revealed (new strengths, new gaps, new recommendations).
   - Remove or move a topic when new evidence shows it no longer belongs in its current category (e.g. a former "Areas to Reinforce" item the user now answered correctly with solid reasoning moves to "Strengths").
   - Avoid duplicating semantically equivalent topics - update phrasing/merge instead of adding a near-duplicate.
   - Don't turn every missed point into a recommendation automatically - `Study Recommendations` should hold independent, useful study topics, not a 1:1 mirror of every gap.
   - Keep each topic short, specific, and phrased around a technical concept (not a description of the user's performance). Reference the originating question when useful, e.g. `(Q3)`.
   - Format: English, one concept per line, `* topic;` (no trailing `;` on the list's last item), three sections exactly as `# Strengths`, `# Areas to Reinforce`, `# Study Recommendations`.
4. Briefly tell the user the knowledge profile was updated and what changed (1-2 lines is enough - don't dump the whole file unless asked).
