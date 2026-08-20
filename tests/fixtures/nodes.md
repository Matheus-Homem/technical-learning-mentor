# Knowledge nodes

| node | application | source | why | origin | first_seen | aliases | related |
|---|---|---|---|---|---|---|---|
| SistemasDistribuidos.ApacheKafka.ReplicacaoDeParticoes.InSyncReplicasMinimas | practical | derived | becomes min.insync.replicas in the broker config | T1 | 2026-08-20 | isr minimo | |
| SistemasDistribuidos.ApacheKafka.ExactlyOnceSemantics.IdempotentProducer | practical | derived | becomes enable.idempotence=true in the producer config | T2 | 2026-08-20 | | |
| SistemasDistribuidos.ApacheKafka.ExactlyOnceSemantics.TransactionalId | practical | derived | becomes transactional.id in the producer config | T2 | 2026-08-20 | | |
| ArquiteturaDeSoftware.DomainDrivenDesign.AgregadosEInvariantes.ConsistenciaTransacional | practical | derived | materialises as the transaction boundary in repository code | T3 | 2026-08-20 | | |
| ArquiteturaDeSoftware.DomainDrivenDesign.AgregadosEInvariantes.RaizDeAgregado | practical | derived | materialises as the aggregate root class and its public surface | T3 | 2026-08-20 | | |
| ArquiteturaDeSoftware.DomainDrivenDesign.ContextoDelimitado.MapaDeContextos | theoretical | derived | a context map is an organisational artifact, not a code one | T4 | 2026-08-20 | | |
| SistemasDistribuidos.TeoremaCAP.TradeoffLatenciaConsistencia.LimiteTeorico | theoretical | derived | no artifact "is" the theoretical limit | T5 | 2026-08-20 | | |
| SistemasDistribuidos.TeoremaCAP.TradeoffLatenciaConsistencia.ParticaoDeRede | practical | derived | materialises as the partition-handling branch and its tests | T5 | 2026-08-20 | | |
| Observabilidade.OpenTelemetry.Tracing.SpanContext | practical | derived | becomes context propagation code across service boundaries | T6 | 2026-08-20 | | |
| Observabilidade.OpenTelemetry.Metricas.Histograma | practical | derived | becomes histogram instrument declarations in code | T6 | 2026-08-20 | | |
| ArquiteturaDeSoftware.DomainDrivenDesign.ContextoDelimitado.LinguagemUbiqua | theoretical | derived | shared vocabulary is a team practice, not an artifact | T4 | 2026-08-20 | | |
| ArquiteturaDeSoftware.DomainDrivenDesign.ContextoDelimitado.AntiCorruptionLayer | practical | derived | materialises as the translating adapter class between contexts | T4 | 2026-08-20 | | |
