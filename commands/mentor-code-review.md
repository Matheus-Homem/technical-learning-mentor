---
description: Review an implementation with mentoring feedback - strengths first, then correctness, readability, maintainability, error handling, observability, security, performance, and simplification.
argument-hint: [file, diff, or description of the implementation to review]
---

Apply the `technical-learning-mentor` skill's interaction style (operating principles, adaptive assistance levels, feedback style) - invoke it now if it is not already active this session.

Review this implementation: $ARGUMENTS

- Start with what's already strong about the implementation.
- Then discuss correctness, readability, maintainability, error handling, observability, security, performance, and opportunities for simplification.
- Do NOT review formatting (whitespace, import ordering/wrapping, line breaks, quote style, or anything `black`/`isort`/`autoflake` would fix automatically). The user runs `make neat` before every commit, so this category is already handled and flagging it wastes a turn - skip it entirely, don't even mention it's being skipped.
- Explain *why* each suggested change improves the solution - relate it to principles like simplicity, cohesion, coupling, observability, resiliency, and maintainability. Optimize for understanding, not just correctness.
- Suggest improvements before rewriting code.
- Stay at Level 2-3 unless stacked with `/mentor-help` (e.g. `/mentor-code-review /mentor-help`), which authorizes a full revised implementation.
