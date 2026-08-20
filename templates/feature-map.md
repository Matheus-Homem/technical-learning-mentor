# Feature: <slug>

<!-- Written by /mentor-map. Rewritten on every remap.
     The Task x Knowledge crossing for this feature, and the verdict for each task.
     See references/task-matrix.md. -->

- Opened: <YYYY-MM-DD>
- Closed: <YYYY-MM-DD or empty>
- Spec source: <path the tasks were read from>
- Snapshot: <fetched_at of the snapshot used> <!-- flag here if it was stale -->
- Task key used: <explicit id | heading text | checkbox line>

<!-- "Task key used" records how tasks were identified, so a later remap can
     reconcile. Identify each task by the first of these the task file actually
     offers: an explicit id (T14, TASK-3); else the heading its checkbox sits
     under; else the checkbox line, truncated. Never require the task file to
     carry a field of ours — this skill does not own that file. -->

## Tasks

<!-- verdict: own | paired | delegated
     deciding node: the node that produced the verdict, per the aggregation rule
     active nodes: how many survived the `waived` filter, out of how many required
     flags: contested | unverified | class-first | manual-override | empty -->

| task | verdict | deciding node | active nodes | flags |
|---|---|---|---|---|

## Knowledge

<!-- Every node this feature requires, with its resolved triple.
     Each resolution names its origin — a declaration, a date, a derivation.
     A value without its origin is not written. -->

| node | domain (origin) | comprehension (date) | application (source) | tasks |
|---|---|---|---|---|

## Gaps

<!-- Required nodes absent from the Gemini Notebook snapshot, or present with
     comprehension `no`. This is the study list — what to take to Gemini Notebook. -->

| node | why it is required | tasks affected |
|---|---|---|

## Trace

<!-- The full resolution behind every verdict. Required — a verdict without its
     trace is not written. One block per task:

T7  own
    <- SistemasDistribuidos.ApacheKafka.Retencao.TombstoneDelay
        domain        = developing  (default - no declaration on any prefix)
        comprehension = no          (Gemini Notebook, 2026-08-19)
        application   = practical   (derived: becomes delete.retention.ms in the topic config)
    other nodes: 1 waived (inherited from ...ApacheKafka), 1 paired
-->

## Notes

<!-- Dated lines. Required for: lowering a task's verdict by hand
     (own -> paired -> delegated), and what moved on each remap.
     Raising a verdict is free but note it so the recompute does not undo it. -->
