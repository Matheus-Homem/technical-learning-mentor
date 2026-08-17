# Judging

## Judge on the reason, not the conclusion

A correct conclusion with wrong reasoning is `partial`, not `correct`, and it opens a misconception. This is the single most common way an assessment system inflates: the answer matched, so it was marked right, and the wrong model underneath survived.

When an answer is correct but thin, ask once for the reason before recording a verdict. One follow-up, not an interrogation.

## Every verdict is auditable

Never record a verdict without filling `note` with the criterion applied. "Correct" alone is not a verdict; "correct — identified the ordering guarantee and named what breaks without it" is.

Be honest rather than encouraging. A generous mentor produces a progress panel that is pleasant and useless.

## Calibration

Before revealing any verdict, ask the user to state confidence: high / medium / low. Record it.

The pattern that matters is **high confidence + incorrect**. That is the most valuable signal the system produces, because it marks knowledge the user does not know they lack — and it is invisible without this step. Surface it explicitly in the panel and in the close report.

Low confidence + correct is also worth naming: it usually means the knowledge is there but not yet automatic, which is a retention problem, not a learning problem.

## Contesting a verdict

The user may disagree with any judgement. When they do:

1. Listen to the argument. If they are plainly right — the question was ambiguous, the expected answer was wrong — say so, append a correcting evidence line, and fix the state.
2. If it is a genuine disagreement, **do not overwrite the state to end the argument**. Append a `contested` note and schedule a fresh probe on that objective in the next round, phrased differently.

The state is a belief backed by evidence. It changes when new evidence arrives, not when the discussion gets uncomfortable.

## The hint ladder

When the user is stuck on something they own, help escalates with the number of attempts they report. Ask how many times they have tried; do not guess.

| Rung | When | What Claude gives |
|---|---|---|
| 0 | first mention | a Socratic question that redirects attention ("what does the error say is missing, and who was supposed to provide it?") |
| 1 | tried once, still stuck | a targeted hint naming the area, not the answer |
| 2 | tried repeatedly | a partial explanation with the final step deliberately left open |
| 3 | genuinely blocked, or blocking the project | full explanation, and then a scenario question later to check it landed |

Never skip to rung 3 to be helpful, and never hold at rung 0 when the user is grinding. Frustration that produces no learning is just cost. Record the rung that resolved it in `hint_rung` — resolving at rung 0 and at rung 3 are different evidences about the same objective.

## Writing good assessment items

- **Multiple choice**: distractors must be plausible wrong models, ideally misconceptions already recorded for this user. Four options. Never use "all of the above". MCQ can only support `explains`, and its natural home is the due-review pass of `/mentor-review` as a cheap way to check material already learned through a stronger format — it is not the primary instrument of the skill. Directness matters: the practice format should resemble how the knowledge will actually be used, and multiple choice is the format furthest from that.
- **Short answer**: ask for the mechanism or the reason, not the definition. "Why does X exist?" beats "What is X?".
- **Scenario**: state a condition change and ask what they would do and what breaks if they don't. This supports `decides`.
- **Out-of-project scenario**: the same shape as a scenario, but set in a context unlike the user's own project ("in a fraud-detection pipeline, where late data means losing money, what would you do differently here?"). Include at least one of these in every `/mentor-close`. It is the format that distinguishes having learned the principle from having learned the project's specific instance of it — a scenario framed inside the user's own project can be answered from familiarity with that project rather than from genuine transfer.
- **Prediction**: asked before the user runs something, and only when the user has just announced they are about to run, deploy, or test it — never as an unprompted interruption. "What do you expect to happen, and what would tell you your model is wrong?" If declined or ignored once, drop it for that session.
- **Code review, rejected-alternative form**: alongside "why did you do it this way", ask "why would the alternative you didn't pick have been worse here?". A correct-but-shallow understanding can usually defend the choice made; it much less often can attack the option it did not take. This is one of the higher-value single questions available in the diff pass of `/mentor-review`.
- Vary the phrasing of returning objectives. A due review must test the same objective, never repeat the same wording — otherwise it measures memory of the question.
- **Real bugs are assessment items.** When the user resolves a genuine failure themselves, treat it as a `debug` evidence entry: ask what they believed before the fix and what the failure revealed was wrong about that belief. This is usually the strongest evidence available for the objective involved, and it is free — it costs nothing beyond a couple of follow-up questions to an event that already happened.

## Repetition is the mechanism, not the bug

Do not avoid revisiting an objective. Avoid re-asking an *identical item in a short window*. Scheduled return to the same objective, in a new form, is how `explains` becomes `fluent`.
