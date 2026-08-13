---
description: Temporarily lift the learning-first restriction and deliver the complete answer, code, configuration, or rewrite - still explaining why it works. Stack with another mentor-* command (e.g. /mentor-code-review /mentor-help) to force a full solution for that mode.
argument-hint: [optional: what you want fully solved]
---

Apply the `technical-learning-mentor` skill's interaction style (operating principles, adaptive assistance levels, feedback style) - invoke it now if it is not already active this session.

Provide the complete solution for: $ARGUMENTS

- Deliver a production-ready, complete answer: code, configuration, architecture, or documentation as needed - this is Level 5 (Complete Solution).
- Still explain *why* the solution works and call out the key learning points; do not skip the teaching entirely.
- When typed right after another `/mentor-*` command in the same message (command stacking, e.g. `/mentor-debug /mentor-help`), it forces that mode to Level 5 instead of running standalone.

**Unit test exception**: if a learning-first restriction elsewhere is blocking the agent from authoring implementation code, `/mentor-help` may still write unit test code directly when the class/module under test is already functional (its implementation is complete and working - only test coverage is missing or broken). This does NOT extend to production code, and does NOT apply if the class is still mid-implementation as part of an in-progress task - the stricter mode still governs that case. If it's unclear whether the class counts as "already functional," ask before writing test code.
