# Manual de uso

Como usar a skill no dia a dia. O `README.md` explica o desenho; este arquivo explica a rotina.

---

## O ciclo

```
1. estudar no NotebookLM        (fora da skill)
2. /mentor-sync                 traz o que ficou comprovado
3. spec-driven produz as tasks
4. /mentor-map                  cruza e decide quem escreve o quê
5. /mentor-tasks                trabalha os vereditos
6. /mentor-class                quando travar
   └─► volta pro NotebookLM, e o ciclo recomeça
```

A skill **não te avalia**. Quem avalia é o NotebookLM. Ela lê esse estado e decide o que fazer com ele.

---

## As três dimensões

Três perguntas diferentes, três donos diferentes. É o ponto central do desenho.

### Domínio — você declara

`Waived` · `Mastered` · `Developing`. Existe nos 4 níveis.

- **`Waived`** — não é pra desenvolver agora. Pode delegar pra IA.
- **`Mastered`** — você já tem isso.
- **`Developing`** — está construindo.

**Herda.** Declarar `SistemasDistribuidos.ApacheKafka = Waived` faz tudo abaixo seguir junto. Sem enumerar nada.

**Sobrescreve.** Declarar `SistemasDistribuidos.ApacheKafka.ExactlyOnceSemantics = Developing` abre só esse ramo. O prefixo mais longo declarado é o que vale.

Sem declaração em prefixo nenhum, o padrão é `Developing` — o erro seguro é pro lado de aprender.

### Compreensão — o NotebookLM comprova

`Sim` · `Não` · `Desconhecido`. Existe nos níveis 2, 3 e 4.

Responde: **você domina a teoria básica disso**, mesmo sem nunca ter aplicado num cenário real?

A skill **nunca escreve isso**. Nem quando a aula foi bem, nem quando você acertou a pergunta, nem quando você escreveu o código. Vem do NotebookLM pelo `/mentor-sync`, e só.

`Desconhecido` ≠ `Não`. `Não` foi testado e não passou — estude. `Desconhecido` nunca foi testado — leve pro notebook. Ações diferentes, e por isso aparecem separados.

### Aplicação — derivada

`Teórico` · `Prático`. Só no nível 4.

É propriedade **do conceito**, não sua. A pergunta é: *existe uma classe de artefato — código, comando, config, query, diagrama, análise de cenário — cuja produção demonstraria isso diretamente?*

```
…ReplicacaoDeParticoes.InSyncReplicasMinimas   → Prático     vira min.insync.replicas=2
…TradeoffLatenciaConsistencia.LimiteTeorico    → Teórico     nenhum artefato "é" isso
```

Derivada uma vez, na criação, e **fixada**. Não muda sozinha entre execuções — se mudasse, o veredito de uma task mudaria sem nada ter mudado, e aí você para de confiar em todos eles. Pra mudar: `--rederive`, ou você sobrescreve (e aí é permanente).

---

## Os vereditos

| Domínio | Compreensão | Aplicação | Veredito |
|---|---|---|---|
| `Waived` | * | * | *sai da conta* |
| `Mastered` | `Sim` | * | `paired` |
| `Mastered` | `Não` | * | `paired` + **contested** |
| `Mastered` | `Desconhecido` | * | `paired` + *unverified* |
| `Developing` | * | `Prático` | `own` |
| `Developing` | * | `Teórico` | `paired` |

Por task: os `Waived` saem, e vence o mais exigente dos que sobraram (`own > paired > delegated`). Nada sobrou → `delegated`.

**Um nó `Waived` não delega a task sozinho.** Ele se remove, e o resto continua decidindo — senão um "eu já sei Kafka" periférico apagaria o aprendizado de tudo que estivesse ao lado.

### O que cada um significa na prática

- **`own`** — você escreve. Código e testes. A IA dá estrutura, pseudocódigo e a próxima dica; não entrega implementação.
- **`paired`** — você decide, a IA escreve. A decisão vem primeiro: ela apresenta o requisito e as restrições, você propõe e justifica, e só então ela escreve o corpo mecânico em volta.
- **`delegated`** — a IA escreve, você revisa.

### `contested`

Você declarou `Mastered`, o NotebookLM disse `Não`. O veredito segue a **sua** declaração — você conhece seu nível melhor que um teste. Mas a contradição aparece num bloco próprio, e resolver (rebaixar o Domínio, ou refazer o teste) é escolha sua. A skill nunca reconcilia sozinha.

### Mudar um veredito na mão

**Subir** (`delegated → paired → own`) é livre. Curiosidade não leva atrito.

**Descer** (`own → paired → delegated`) custa uma linha datada em `map.md` `## Notes`, dizendo qual task e por quê. A assimetria é o ponto: delegação decidida antes é estratégia; delegação decidida às 22h numa task que ficou chata é o caminho de menor resistência fantasiado de estratégia.

---

## Os comandos

### `/mentor-sync [--full] [--dry-run]`
**Quando**: antes de mapear, e depois de qualquer sessão de estudo. 2–5 min.

Traz a Compreensão do NotebookLM pro snapshot local. **É o único comando que fala com o NotebookLM.**

Mostra o diff antes de escrever — o que entrou, o que mudou, o que saiu, o que foi rejeitado. Nó que **saiu** do ledger deixa de estar comprovado, e qualquer veredito que dependia dele se move; por isso remoções aparecem em destaque.

Depois pergunta o Domínio dos nós de **nível 2** novos. Nível 2 porque é onde a herança rende mais: uma resposta resolve uma tecnologia inteira. `--full` pergunta também no nível 3 — use depois de um sync grande, não toda vez.

Id inválido é **reportado e descartado**, nunca consertado. Chute de qual nó era o certo é como o nó errado acaba marcado como entendido.

**O ledger não é você digitando de memória.** O NotebookLM guarda o resultado de cada quiz/flashcard por pergunta — o que você marcou, o que era certo, a explicação — e isso sobrevive fechar e reabrir o notebook. O jeito certo de trazer isso pro `/mentor-sync` é pedir pro **chat do próprio notebook** ler esses resultados salvos no Studio e montar a tabela, em vez de você julgar de cabeça se entendeu ou não. O comando te dá o texto pronto pra colar no notebook quando há nós pra checar; ver `references/notebooklm-contract.md` pro prompt exato. Autodeclaração direta ainda existe, mas é o plano B — pra um nó que nenhum quiz ainda cobriu.

### `/mentor-map [feature-slug] [--rederive <node>]`
**Quando**: logo depois que a skill de spec-driven produz as tasks, antes de escrever código. 5–10 min.

O comando central. Deriva os nós que cada task exige, resolve as três dimensões, aplica a matriz, escreve o `map.md` com o rastro completo.

O que sai:
- a distribuição (`4 own, 3 paired, 2 delegated`)
- **os gaps** — nós exigidos que estão ausentes do snapshot ou em `Não`. É a lista de estudo, e é a coisa mais acionável que o comando produz: é o que levar pro NotebookLM.
- `contested`, num bloco só deles
- `class-first` — tasks `own` cuja teoria ainda não está comprovada
- quais nós resolveram `Waived` por herança e de onde (o mecanismo pagando)
- quantos resolveram por `default` em vez de declaração — muito alto significa `/mentor-sync --full` atrasado

Snapshot velho não bloqueia: avisa, registra a idade no `map.md`, e continua. Mapa com dado velho é melhor que mapa nenhum.

**Remapear é esperado.** Nós e declarações são preservados; vereditos são recalculados; overrides manuais sobrevivem e ficam marcados. É aqui que um `Waived` declarado depois derruba as tasks pra `delegated`, e que uma Compreensão nova limpa um `contested`.

### `/mentor-tasks [feature-slug] [--all]`
**Quando**: a qualquer momento em que quiser o panorama do que falta.

Duas coisas. Primeiro **verifica os checkboxes contra o código de verdade** — roda o check nomeado, ou lê o source/teste; a prosa do arquivo não é prova. Marca o que estiver realmente pronto.

Depois mostra o que resta agrupado por veredito, `own → paired → delegated`. `own` primeiro: só você pode começar essas, então você vê o que está com você antes do que a IA poderia tirar do seu prato.

Cada item leva uma linha de rastro com o nó que decidiu. Item sem linha no `map.md` é sinalizado como remap devido — e o veredito **não** é derivado aqui.

Nunca escreve conhecimento. Checkbox marcado não é evidência de nada.

### `/mentor-class <topic>`
**Quando**: travou, ou antes de começar uma task `class-first`. ~15 min.

Três categorias, uma pra cada tipo de não-saber:

| Categoria | Soa como | Você recebe |
|---|---|---|
| **conceitual** | "o que é isso?" | explicação escrita, opcionalmente narrada em `.mp3` |
| **aplicação prática** | "como eu uso?" | notebook, código incompleto ou exercício — **sempre incompleto** |
| **arquitetural** | "onde isso se encaixa?" | Mermaid, diagrama, `.html` autocontido |

A analogia:

> Se não sei o que é uma **engrenagem**, quero ler e escutar o que ela é.
> Se sei o que é mas não sei encaixar, quero um exercício de montagem antes da máquina real.
> Se sei usar mas não sei onde ela entra, quero o mapa da máquina.

**A categoria prática é sempre incompleta.** O andaime vem pronto; a parte que responde a sua pergunta, não. Ler uma solução pronta produz a *sensação* de entender sem o fato — e essa sensação é exatamente o que a skill existe pra evitar.

Um formato por padrão. Dois só quando a dificuldade tem mesmo duas faces. Nunca três.

Toda aula nomeia um nó de nível 4. E **nenhuma aula marca nada como entendido** — ela termina te mandando testar no NotebookLM, que é o único caminho pra algo virar comprovado.

---

## Fora dos comandos

- **Pergunta conceitual** → ele responde. Não vira quiz, não vira registro.
- **"escreve isso pra mim"** → ele resolve o veredito no `map.md` **antes** de decidir como responder — nunca pela impressão de quão difícil ou chato parece. Sem linha no `map.md`, ele avisa que o remap está devido em vez de chutar.
- **Você começa uma task `class-first`** → oferece uma aula **uma vez**, dizendo qual formato e por quê. Oferta de material, não sondagem. Se você ignorar, some.
- **Skill de spec-driven vai gerar a lista de tasks** → ele intercepta antes de escrever, pra cada task sair com veredito. Se a lista inteira sair `delegated`, ele diz isso na cara: a mudança é de entrega, não de aprendizado, e você decide sabendo.

---

## Os arquivos

Tudo em `.mentor/`, na raiz do seu repo.

| Arquivo | O que é | Dono | Versionado? | Você lê? |
|---|---|---|---|---|
| `profile.md` | config: spec artifacts, notebook, feature ativa | skill | sim | raramente |
| `domain.md` | suas declarações de Domínio | **você** | sim | sim |
| `nodes.md` | registro de nós + Aplicação | skill | sim | ao auditar |
| `notebooklm/snapshot.json` | Compreensão | **NotebookLM** | sim | nunca |
| `notebooklm/sync-log.md` | o que cada sync mudou | skill | sim | ao investigar |
| `features/<slug>/map.md` | Task × Knowledge × veredito + rastro | skill | sim | sempre |
| `features/<slug>/classes/` | artefatos das aulas | skill | **não** | sim |
| `features/<slug>/classes/index.md` | registro de quais aulas houve | skill | sim | raramente |

Regras que importam:

- **`domain.md` é esparso.** Linha só pro que foi declarado explicitamente. Nunca adicione linha pra descendente que herdaria o mesmo valor — isso é duplicata, e duplicata envelhece.
- **`snapshot.json` nunca é editado à mão.** Editar ele é colocar na boca da skill uma afirmação sobre o seu conhecimento.
- **`sync-log.md` só cresce.** É a trilha de auditoria de todo veredito que mudou porque a Compreensão mudou.
- **A herança nunca é gravada em disco.** É resolvida na leitura, sempre. Por isso não há segunda cópia pra sair de sincronia.

---

## A regra de DESIGN (opcional)

Na instalação, o instalador **pergunta** se você quer a regra de pareamento de DESIGN. É a única parte que escreve fora do diretório da skill e a única que muda o comportamento de **outras** skills — por isso pergunta, e o padrão é não instalar.

Instalada, ela impede que qualquer skill de spec-driven gere o design e as tasks de forma totalmente automática:

1. analisa → 2. propõe a estrutura → 3. propõe as tasks →
4. **você revisa** → 5. **você aprova/altera a estrutura** → 6. **você aprova as tasks** →
7. só então o arquivo de design é escrito

Silêncio não é aprovação. "Parece bom" inferido do contexto não é aprovação. Aprovar a estrutura não aprova as tasks.

Passa direto sem gate: escolha de biblioteca, formato de config, layout já convencionado no projeto, contrato de integração que outros componentes já consomem.

Pra remover: apague o trecho entre os marcadores no `CLAUDE.md`.

---

## O que essa skill não faz

- **Não te avalia.** Sem teste, sem nota, sem escada de maestria.
- **Não lembra de revisar.** Não existe relógio de retenção. Saiu junto com a avaliação, de propósito — retenção é de quem faz o teste, e isso é o NotebookLM. Se você espera que a skill traga de volta um conceito que você não toca há seis semanas, ela não vai.
- **Não escreve Compreensão.** Por caminho nenhum, por motivo nenhum.

---

## Problemas comuns

- **"Tudo está `own`"** → provavelmente falta declarar Domínio. Rode `/mentor-sync --full`, ou declare `Waived`/`Mastered` nos níveis 2 que você já domina. Olhe quantos nós resolveram por `default` no output do `/mentor-map`.
- **"Tudo está `delegated`"** → ou a feature é mesmo de entrega (e é bom saber disso), ou você declarou `Waived` alto demais. Confira de onde veio a herança no `map.md`.
- **"O veredito mudou e eu não mexi em nada"** → olhe o `sync-log.md`. Um nó que saiu do ledger ou regrediu pra `Não` move os vereditos que dependiam dele. Se não houver nada lá, é bug — Aplicação não deveria mudar sozinha.
- **"Ele quer que eu escreva algo que eu já sei"** → declare `Mastered` no nó (ou num prefixo dele) e remapeie. Se já estava `Mastered`, veja se saiu `contested`.
- **Snapshot velho** → `/mentor-sync`. Nunca bloqueia nada, só avisa.
