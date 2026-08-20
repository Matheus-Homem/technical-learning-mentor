# Sync log

<!-- Append-only. One block per /mentor-sync run, most recent LAST.
     This is the audit trail for every change in Comprehension, and therefore
     for every verdict that changed because of one. Never rewrite an entry. -->

<!-- Format:

## 2026-08-20T09:00:00Z — manual

- added:   Kafka.Replicacao.InSyncReplicasMinimas = yes (quiz, 2026-08-19)
- changed: Kafka.Retencao.TombstoneDelay          no -> yes (quiz, 2026-08-20)
- removed: DDD.Agregados.Invariante              (no longer in the ledger)
- rejected: kafka.replicacao.isr                 (invalid id — not PascalCase)

3 nodes added, 1 changed, 1 removed, 1 rejected. 14 nodes total.
-->
