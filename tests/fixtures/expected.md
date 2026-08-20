# Expected results

Written BY HAND from references/knowledge-model.md and references/task-matrix.md,
before the resolver existed. This is the oracle; the resolver is what gets checked
against it, never the other way round.

## Node resolution

| node | domain | domain origin | comprehension | application | verdict | flags |
|---|---|---|---|---|---|---|
| SistemasDistribuidos.ApacheKafka.ReplicacaoDeParticoes.InSyncReplicasMinimas | waived | inherited:SistemasDistribuidos.ApacheKafka | yes | practical | excluded | |
| SistemasDistribuidos.ApacheKafka.ExactlyOnceSemantics.IdempotentProducer | developing | inherited:SistemasDistribuidos.ApacheKafka.ExactlyOnceSemantics | no | practical | own | class-first |
| SistemasDistribuidos.ApacheKafka.ExactlyOnceSemantics.TransactionalId | developing | inherited:SistemasDistribuidos.ApacheKafka.ExactlyOnceSemantics | yes | practical | own | |
| ArquiteturaDeSoftware.DomainDrivenDesign.AgregadosEInvariantes.ConsistenciaTransacional | developing | inherited:ArquiteturaDeSoftware.DomainDrivenDesign.AgregadosEInvariantes | yes | practical | own | |
| ArquiteturaDeSoftware.DomainDrivenDesign.AgregadosEInvariantes.RaizDeAgregado | developing | inherited:ArquiteturaDeSoftware.DomainDrivenDesign.AgregadosEInvariantes | no | practical | own | class-first |
| ArquiteturaDeSoftware.DomainDrivenDesign.ContextoDelimitado.MapaDeContextos | mastered | inherited:ArquiteturaDeSoftware.DomainDrivenDesign | yes | theoretical | paired | |
| ArquiteturaDeSoftware.DomainDrivenDesign.ContextoDelimitado.LinguagemUbiqua | mastered | inherited:ArquiteturaDeSoftware.DomainDrivenDesign | no | theoretical | paired | contested |
| ArquiteturaDeSoftware.DomainDrivenDesign.ContextoDelimitado.AntiCorruptionLayer | mastered | inherited:ArquiteturaDeSoftware.DomainDrivenDesign | unknown | practical | paired | unverified |
| SistemasDistribuidos.TeoremaCAP.TradeoffLatenciaConsistencia.LimiteTeorico | developing | inherited:SistemasDistribuidos.TeoremaCAP | yes | theoretical | paired | |
| SistemasDistribuidos.TeoremaCAP.TradeoffLatenciaConsistencia.ParticaoDeRede | developing | inherited:SistemasDistribuidos.TeoremaCAP | no | practical | own | class-first |
| Observabilidade.OpenTelemetry.Tracing.SpanContext | developing | default | yes | practical | own | |
| Observabilidade.OpenTelemetry.Metricas.Histograma | developing | default | unknown | practical | own | class-first |

## Task aggregation

| task | verdict | deciding node | why |
|---|---|---|---|
| T1 | delegated | | only node is waived -> active set empty |
| T2 | own | SistemasDistribuidos.ApacheKafka.ExactlyOnceSemantics.IdempotentProducer | override beats inherited waive; both own |
| T3 | own | ArquiteturaDeSoftware.DomainDrivenDesign.AgregadosEInvariantes.ConsistenciaTransacional | override beats inherited mastered; both own |
| T4 | paired | ArquiteturaDeSoftware.DomainDrivenDesign.ContextoDelimitado.MapaDeContextos | all three mastered -> paired |
| T5 | own | SistemasDistribuidos.TeoremaCAP.TradeoffLatenciaConsistencia.ParticaoDeRede | own beats paired |
| T6 | own | Observabilidade.OpenTelemetry.Tracing.SpanContext | no declarations anywhere -> default developing |
| T7 | paired | ArquiteturaDeSoftware.DomainDrivenDesign.ContextoDelimitado.MapaDeContextos | waived node drops out, paired survives |
| T8 | delegated | | requires nothing |
| T9 | own | SistemasDistribuidos.TeoremaCAP.TradeoffLatenciaConsistencia.ParticaoDeRede | a waived node does NOT delegate a task that still carries own work |
