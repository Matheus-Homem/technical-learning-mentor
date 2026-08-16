# Manual — technical-learning-mentor v2.1

Manual de uso. Escrito em português porque é lido por você, pela mesma razão do painel. Todo o resto da skill está em inglês.

## O que essa skill faz

Ela impede a IA de desenvolver o seu código e, no lugar disso, te ajuda a aprender o que é necessário para você mesmo desenvolver — registrando, de forma auditável, o que você domina, o que está frágil e o que precisa voltar.

O problema que ela resolve não é "a IA escolhe mal os tópicos". É **falta de visibilidade**: você responde, é corrigido, e não sobra nada que diga o que evoluiu.

É agnóstica de tecnologia e funciona em Claude Code, Cursor e Codex CLI. O que você precisa aprender é derivado das suas specs e do seu código, nunca do conhecimento genérico do modelo sobre uma ferramenta.

## Os três baldes

A decisão mais importante da skill, e acontece uma vez, no início de cada feature, no `/mentor-map`.

| Balde | O que é | O que acontece |
|---|---|---|
| 🎯 **decidir** | trade-offs que você vai reencontrar na carreira | vira objetivo, recebe cenários, é onde suas horas devem ir |
| 📖 **explicar** | precisa entender e justificar, não otimizar | vira objetivo, avaliação mais leve |
| 📦 **delegar** | acoplamento mecânico, valores consultáveis | vai para `/mentor-example`, não vira objetivo |

O critério: **se o parâmetro codifica um trade-off que você precisa saber navegar, é aprendizado. Se é encanamento entre serviços, é consulta.**

O paralelismo de um job não é boilerplate — é uma decisão. A ordem em que os containers sobem geralmente é. Delegar o segundo é o que compra tempo para o primeiro.

## Os comandos

### `/mentor-map`
**Quando**: assim que a skill de spec-driven gerar as tasks, antes de escrever código.
**Duração**: ~5-10 min.

Lê suas specs, deriva os conhecimentos exigidos, classifica cada um nos três baldes e marca **o objetivo limitante** — o conceito transversal que trava mais coisas nessa feature.

Na primeira execução no repositório, cria `.mentor/` (incluindo o `.gitignore` interno), pede o caminho dos artefatos da spec-driven e guarda. Também faz o questionário de triagem, só para tags novas.

Você sai daqui sabendo o que essa atividade exige, onde já está, e o que vai delegar.

### `/mentor-example <o que>`
**Quando**: para qualquer coisa que caiu no balde delegar, ou para conteúdo genuinamente novo antes de você praticar sozinho.
**Duração**: ~15 min.

Três passos, nessa ordem:
1. O modelo entrega o artefato **anotado** — cada decisão não-óbvia com uma linha de porquê.
2. Ele te faz 4-5 perguntas sobre decisões isoladas: "se essa linha sumisse, o que quebraria e quando?"
3. Ele te devolve a mesma coisa com 2-3 valores apagados. Você preenche.

O passo 3 é o que fecha o ciclo — é onde você descobre que achou que tinha entendido. Receber só o passo 1 não ensina nada; por isso o comando existe separado de simplesmente pedir o arquivo.

Os artefatos gerados ficam em `.mentor/features/<slug>/examples/` — não versionados, é conveniência de sessão.

### `/mentor-review [path]`
**Quando**: depois de cada bloco de trabalho. Várias vezes por dia num sprint.
**Duração**: ~5-10 min.

O comando mais importante da skill, porque é o mais direto: prática que se parece com o uso real. Lê seu diff e pergunta **por que** você decidiu daquilo. Não é code review de estilo.

Perguntas que ele tenta sempre incluir:
- por que aqui e não ali?
- **por que a alternativa que você descartou é pior?**
- se `<condição>` mudasse, o que mudaria aqui?

A segunda é a que mais separa entender de reconhecer. Compreensão rasa justifica a escolha feita; raramente ataca a rejeitada.

Também é aqui que **bug resolvido vira evidência**: quando você conserta algo, o modelo registra qual era seu modelo mental antes do conserto e o que ele revelou de errado. É a evidência mais forte que a skill produz.

### `/mentor-eval [--time 5|15|30]`
**Quando**: no início de uma sessão, ou quando quiser revisar.
**Duração**: o que você pedir.

Não é prova de conteúdo novo. É **revisão espaçada**: traz de volta o que você não vê há tempo — em dias e em horas de estudo — misturado com o que for necessário.

Múltipla escolha vive aqui, e só aqui. Barata, serve para checar o que já foi aprendido em outro formato. Nunca promove nada para "decide".

Quando houver um objetivo limitante em aberto, ele vira **drill**: cenários repetidos sobre o mesmo conceito, variando as condições.

### `/mentor-close`
**Quando**: ao concluir a atividade, antes da próxima spec.
**Duração**: ~10-20 min.

1. **Feynman** — você explica o que construiu, sem interrupção.
2. **Por que não do outro jeito** — para uma ou duas decisões, por que a alternativa plausível seria pior.
3. **Cenários de decisão**, incluindo **pelo menos um fora do seu projeto** — "num sistema com requisito oposto, o que você faria diferente?". É o único teste real de transferência: mostra se você aprendeu o princípio ou só a sua instância aqui.
4. Fecha a feature, escreve o relatório, atualiza o painel.

Se faltar tempo, corte cenários. **Nunca corte o fechamento.**

### `/mentor-progress [--all|--tag X]`
**Quando**: a qualquer momento. Não faz perguntas.

Gera `.mentor/progress.html` e te avisa para abrir. Não é versionado — pode apagar a qualquer momento, ele regenera. Se apagar, você só perde a comparação "o que mudou" na próxima vez que rodar (o Claude avisa e mostra o estado atual mesmo assim).

## Como ler os estados

```
não avaliado → declarado → frágil → explica → decide → fluente
```

- **declarado** — você disse que tem experiência. Evidência fraca de propósito.
- **frágil** — há lacuna ou um equívoco em aberto.
- **explica** — sabe o que é, por que existe, como funciona. Sem consultar.
- **decide** — escolhe sob condições, justifica, sabe o que quebra na escolha errada.
- **fluente** — duas evidências no alvo, sem consulta, **separadas por pelo menos 14 dias**.

`fluente` é o único estado que exige tempo passado, e isso não muda nem num sprint intenso. Prática concentrada produz ganho aparente rápido e decaimento rápido: você vai terminar duas semanas de estudo *sentindo* que domina, e não vai — só o reencontro depois de um intervalo prova o contrário. O painel tem uma seção **⏳ aguardando confirmação de fluência**, com a data em que cada coisa fica elegível, exatamente para isso não parecer um buraco.

Cair de nível é normal. Revisão errada volta para frágil.

## Como a revisão funciona

Não existe data agendada em lugar nenhum. Cada objetivo guarda dois fatos observados: quando foi visto pela última vez (`last_seen`) e quantas horas de estudo acumuladas você tinha naquele momento (`last_seen_hours`).

No início de qualquer comando que possa revisar algo, ele pergunta quanto tempo você estudou desde a última vez. Uma pergunta, dois segundos. Com isso ele calcula dois deltas — em dias e em horas — e o que vencer primeiro dispara a revisão.

Por que dois relógios:

- **Num sprint intenso**, 3 dias são 24 horas de trabalho. O relógio de horas dispara primeiro, e você revisa de manhã o que viu na véspera.
- **Numa rotina de 1h/dia**, 3 dias são 3 horas. O relógio de calendário dispara primeiro, porque aí o risco é esquecer, não diluir.

A mesma tabela se comporta certo nos dois regimes, e na transição entre eles, sem você configurar nada.

Referência aproximada (julgamento, não regra fixa — confiança alta com erro encurta; acerto tranquilo alonga):

| Posição na escada | Horas de estudo | Ou calendário |
|---|---|---|
| 1ª revisão | ~3h | ~3 dias |
| 2ª revisão | ~10h | ~7 dias |
| 3ª revisão | ~30h | ~21 dias |
| 4ª+ revisão | ~80h | ~60 dias |

## Fora dos comandos

- **Dúvida sobre um conceito** → o modelo responde. Não devolve pergunta, não vira quiz. Registra que você perguntou.
- **Você trava** → a ajuda escala com quantas vezes você já tentou. Diga o número; ele não adivinha.
- **Você anuncia que vai rodar algo** → pergunta uma vez o que você espera. Se ignorar, não insiste.
- **Você pede algo do balde delegar** → é encaminhado para `/mentor-example`, não entregue direto.
- **Você pede o código pronto de algo que é sua task** → ele não entrega, dá a estrutura e a dica.

## Os arquivos

Tudo em `.mentor/`, na raiz do projeto — fora de qualquer pasta específica de ferramenta (`.claude/`, `.cursor/`, `.codex/`), para funcionar igual em qualquer cliente.

| Arquivo | O que é | Versionado? | Você lê? |
|---|---|---|---|
| `.gitignore` | ignora `progress.html` e `features/*/examples/` | — | nunca |
| `profile.md` | experiência, alvo por tag, horas acumuladas, config | sim | raramente |
| `knowledge.md` | todos os objetivos, estados, quando cada um foi visto | sim | ao auditar |
| `progress.html` | **o painel** — conteúdo em português, derivado | não | sempre |
| `features/<slug>/map.md` | o que a feature exige, os três baldes, o limitante | sim | no início |
| `features/<slug>/evidence.jsonl` | log append-only | sim | quase nunca |
| `features/<slug>/examples/` | artefatos do `/mentor-example` | não | ao consultar depois |
| `features/<slug>/report.md` | o que aconteceu na feature | sim | ao fechar |

Regras que valem conhecer:

- **`evidence.jsonl` só cresce.** Correção é linha nova, nunca edição.
- **Log de feature fechada nunca mais é lido.** O relatório carrega adiante.
- **`progress.html` nunca é fonte de verdade** e nunca é versionado. Apagar é seguro.
- **`examples/` também não é versionado.** É conveniência de sessão — se quiser guardar algo dali, copie manualmente.
- **Nada em `knowledge.md`/`evidence.jsonl`/`report.md` é deletado.** Objetivo que deixou de ser necessário vira `archived:` e mantém histórico.
- Você pode editar tudo à mão. Se discordar de um estado, o caminho melhor é contestar na conversa — o modelo agenda uma nova sondagem em vez de reescrever.

## Instalação

```bash
git clone https://github.com/<voce>/technical-learning-mentor /tmp/technical-learning-mentor
cd /caminho/do/seu/projeto
/tmp/technical-learning-mentor/install/install.sh claude   # ou: cursor | codex
```

No Claude Code a skill é reconhecida automaticamente. No Cursor e no Codex CLI, o instalador acrescenta um apontador (`.cursor/rules/` ou `AGENTS.md`) porque essas ferramentas não têm descoberta automática de skill — sem isso, o modelo não saberia que ela existe.

## Orçamento de tempo

Proporcional, não fixo — cerca de **10-20% do tempo de estudo** em mentoria, mais alto num sprint denso (o `/mentor-review` acontece várias vezes ao dia) e mais baixo numa rotina de 1h/dia (predominam revisões curtas de 5 min).

Se precisar cortar: `/mentor-eval` avulso → cenários do close → frequência do review. **Nunca corte o fechamento.**

## Se algo der errado

- **Painel estranho** → `/mentor-progress` regenera do zero.
- **Estado que você acha errado** → conteste na conversa; ele agenda nova sondagem.
- **Caminho das specs mudou** → rode `/mentor-map`, ele pergunta de novo.
- **Não quer ser testado numa tag** → responda `skip` na triagem ou anote em `profile.md` → Notes.
- **Está avaliando demais** → diga. O orçamento é ajustável a qualquer momento.
