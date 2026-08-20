# Mentor profile

<!-- Written in English. Created on first /mentor-map. Edited only by /mentor-map,
     the commands that log time, or by the user directly. Delete a tag row to be
     re-asked about it. -->

## Config

- `spec_artifacts`: <path or glob to the plan/design/tasks produced by the planning skill>
- `default_review_budget`: 15
- `active_feature`: <slug>
- `study_hours_total`: 0
- `authorship_levels`: true
- `prune_closed_features_on_close`: false

<!-- default_review_budget is the time budget, in minutes, for the due-review
     pass of /mentor-review (its diff pass is never timeboxed). Overridden per
     call with --time 5|15|30.

     study_hours_total is a running counter, never reset. Every command that can
     surface a review (mentor-map, mentor-review, mentor-close) asks "how long
     have you studied since last time?" and adds it here before computing
     anything. This is what drives the exposure clock in
     references/retention.md — it is read, not estimated.

     authorship_levels: true by default — this is the skill's purpose, so a new
     project gets it switched on. When true, /mentor-map assigns own/paired/deliver
     to every task and that level decides who writes it (references/code-policy.md).
     Set to false to fall back to the older behaviour where the user authors
     everything regardless of what they already know.

     prune_closed_features_on_close: false by default. When true, /mentor-close
     untracks a closed feature's scratch files from git. Requires a workflow
     that merges feature branches into main with a real merge commit, never a
     squash — read commands/mentor-close.md before turning it on. -->

## Tags

| tag | experience | target | declared_on |
|---|---|---|---|
| <tag> | never / a-little / regular | decide / explain / skip | 2026-08-12 |

<!-- experience seeds the initial state of that tag's objectives:
       never   -> unassessed
       a-little / regular -> declared  (self-report is weak evidence)
       skip    -> objectives archived for now
     target is the ceiling the user is aiming for in this tag; individual
     objectives may sit below it, never above it.
     Only tags absent from this table are asked about at /mentor-map. -->

## Notes

<!-- Anything durable about how this user wants to be mentored:
     formats they dislike, areas they explicitly do not want assessed,
     agreements about delegating specific work outright. -->
