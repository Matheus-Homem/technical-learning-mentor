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
| 📦 **delegar** | acoplamento mecânico, valores consultáveis | vai para `/mentor-class`, não vira objetivo |

O critério: **se o parâmetro codifica um trade-off que você precisa saber navegar, é aprendizado. Se é encanamento entre serviços, é consulta.**

O paralelismo de um job não é boilerplate — é uma decisão. A ordem em que os containers sobem geralmente é. Delegar o segundo é o que compra tempo para o primeiro.

## Os comandos

### `/mentor-map`
**Quando**: assim que a skill de spec-driven gerar as tasks, antes de escrever código.
**Duração**: ~5-10 min.

Lê suas specs, deriva os conhecimentos exigidos, classifica cada um nos três baldes e marca **o objetivo limitante** — o conceito transversal que trava mais coisas nessa feature.

Na primeira execução no repositório, cria `.mentor/` (incluindo o `.gitignore` interno), pede o caminho dos artefatos da spec-driven e guarda. Também faz o questionário de triagem, só para tags novas.

Você sai daqui sabendo o que essa atividade exige, onde já está, e o que vai delegar.

### `/mentor-class <tópico>`
**Quando**: quando alguma coisa está te travando — algo que caiu no balde delegar, conteúdo genuinamente novo, ou um tópico que você está prestes a começar.
**Duração**: ~15 min.

Ele **não** produz sempre a mesma coisa. Primeiro diagnostica que tipo de dificuldade é a sua, e só então escolhe o formato:

| Sua dificuldade | O que ele gera |
|---|---|
| o conceito/a teoria não assentou | `<slug>.md` (explicação) + `<slug>.mp3` (narração, para ouvir longe da tela) |
| o fluxo/a ordem dos passos está confusa | `<slug>.md` com diagrama(s) Mermaid |
| travado para começar a codar com uma lib/ferramenta nova | `<slug>.ipynb` — notebook de rascunho, exploratório |
| são vários componentes e não está claro como se relacionam | `<slug>.html` autocontido, abre em qualquer navegador, offline |

**Um formato por padrão.** Dois quando a dificuldade tem de fato duas caras (não tem o vocabulário *e* não vê como as peças se ligam). Nunca os quatro — gerar tudo enterra justamente o artefato que ia te ajudar. Ele te diz qual escolheu e por quê antes de gerar, então é barato redirecionar.

Um diagnóstico não gera artefato nenhum: se você **já entende mas está lento / consultando**, isso é problema de retenção, não de explicação. Ele diz isso e deixa o `/mentor-review` trazer de volta, em vez de reexplicar.

Depois de entregar, ele te faz 3-5 perguntas sobre decisões isoladas ("se essa linha sumisse, o que quebraria e quando?"). E quando o artefato tem código — o notebook, ou qualquer coisa do balde delegar — ele ainda te devolve a mesma coisa com 2-3 valores apagados para você preencher. Esse último passo é o que fecha o ciclo, e é onde você descobre que só *achou* que tinha entendido.

Os artefatos ficam em `.mentor/features/<slug>/classes/<tópico>/` — sempre dentro da feature ativa, não versionados, conveniência de sessão.

**Sobre o `.mp3`**: a narração usa `edge-tts` (`pip install edge-tts`) — de graça, sem chave de API, mas **precisa de internet**. Sem internet ele cai para um motor local (`piper-tts`), que soa bem pior — e te avisa que caiu, em vez de entregar como se fosse igual. Ele também te pergunta a preferência de voz em vez de escolher sozinho. Só o formato de explicação escrita ganha áudio; diagrama, notebook e mapa de componentes não têm o que narrar.

### `/mentor-review [path] [--time 5|15|30]`
**Quando**: depois de cada bloco de trabalho, e no início de uma sessão. Várias vezes por dia num sprint.
**Duração**: ~5-15 min.

O comando mais importante da skill. Faz **duas coisas numa chamada só**:

**Parte A — o seu diff.** A parte mais direta que existe: prática que se parece com o uso real. Lê o que você escreveu desde a última revisão e pergunta **por que** você decidiu daquilo. Não é code review de estilo. Essa parte **não tem limite de tempo e sempre roda inteira** — o código já existe, avaliar custa quase nada.

Perguntas que ele tenta sempre incluir:
- por que aqui e não ali?
- **por que a alternativa que você descartou é pior?**
- se `<condição>` mudasse, o que mudaria aqui?

A segunda é a que mais separa entender de reconhecer. Compreensão rasa justifica a escolha feita; raramente ataca a rejeitada.

Também é aqui que **bug resolvido vira evidência**: quando você conserta algo, o modelo registra qual era seu modelo mental antes do conserto e o que ele revelou de errado. É a evidência mais forte que a skill produz.

**Parte B — o que está vencido.** Depois do diff, ele traz de volta o que você não vê há tempo — em dias e em horas de estudo — do projeto inteiro, não só da feature atual. Essa parte **respeita o orçamento** do `--time` (padrão: `default_review_budget` no `profile.md`).

| Orçamento | Itens | Mistura típica |
|---|---|---|
| 5 min | 3-4 | quase só revisões vencidas |
| 15 min | 6-8 | revisões, 1 cenário, algumas respostas curtas |
| 30 min | 10-14 | revisões, 2-3 cenários, drill do objetivo limitante se houver |

Múltipla escolha vive aqui, e só aqui. Barata, serve para checar o que já foi aprendido em outro formato. Nunca promove nada para "decide".

Objetivo que a Parte A já exercitou **não é perguntado de novo** na Parte B — a revisão já foi feita, no formato mais forte que existe.

Se não houver diff pendente, ele pula direto para a Parte B. Se não houver diff **nem** nada vencido, ele diz isso e para — não inventa pergunta para ter o que perguntar.

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
- **Você começa uma task nova** → ele olha no `knowledge.md` se os objetivos que essa task exige estão em aberto (não avaliados, com equívoco, ou bem abaixo do alvo). Se estiverem, oferece **uma vez** uma aula sobre o tópico antes de você começar. É oferta de material, não sondagem — não te testa, não te bloqueia, e some se você ignorar.
- **Você pede algo do balde delegar** → é encaminhado para `/mentor-class`, não entregue direto.
- **Você pede o código pronto de algo que é sua task** → ele não entrega, dá a estrutura e a dica.

## Os arquivos

Tudo em `.mentor/`, na raiz do projeto — fora de qualquer pasta específica de ferramenta (`.claude/`, `.cursor/`, `.codex/`), para funcionar igual em qualquer cliente.

| Arquivo | O que é | Versionado? | Você lê? |
|---|---|---|---|
| `.gitignore` | ignora `progress.html` e `features/*/classes/` | — | nunca |
| `profile.md` | experiência, alvo por tag, horas acumuladas, config | sim | raramente |
| `knowledge.md` | todos os objetivos, estados, quando cada um foi visto | sim | ao auditar |
| `progress.html` | **o painel** — conteúdo em português, derivado | não | sempre |
| `features/<slug>/map.md` | o que a feature exige, os três baldes, o limitante | sim | no início |
| `features/<slug>/evidence.jsonl` | log append-only | sim | quase nunca |
| `features/<slug>/classes/<tópico>/` | artefatos do `/mentor-class` | não | ao consultar depois |
| `features/<slug>/report.md` | o que aconteceu na feature | sim | ao fechar |

Regras que valem conhecer:

- **`evidence.jsonl` só cresce.** Correção é linha nova, nunca edição.
- **Log de feature fechada nunca mais é lido.** O relatório carrega adiante.
- **`progress.html` nunca é fonte de verdade** e nunca é versionado. Apagar é seguro.
- **`classes/` também não é versionado.** É saída de sessão, regenerável — se quiser guardar alguma aula, copie ou commite manualmente.
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

Se precisar cortar: o orçamento da Parte B do `/mentor-review` (`--time 5`) → cenários do close → frequência do review. **Nunca corte a Parte A enquanto houver diff** (o código já está escrito, avaliar é quase de graça) **e nunca corte o fechamento.**

## Se algo der errado

- **Painel estranho** → `/mentor-progress` regenera do zero.
- **Estado que você acha errado** → conteste na conversa; ele agenda nova sondagem.
- **Caminho das specs mudou** → rode `/mentor-map`, ele pergunta de novo.
- **Não quer ser testado numa tag** → responda `skip` na triagem ou anote em `profile.md` → Notes.
- **Está avaliando demais** → diga. O orçamento é ajustável a qualquer momento.
