# Manual — project-mentor

Manual de uso. Escrito em português porque é lido por você, pela mesma razão do `progress.md`. Todo o resto da skill está em inglês.

## O que essa skill faz

Ela impede o Claude de desenvolver o seu código e, no lugar disso, te ajuda a aprender o que é necessário para você mesmo desenvolver — registrando, de forma auditável, o que você já domina, o que está frágil e o que precisa voltar.

O problema que ela existe para resolver não é "o Claude escolhe mal os tópicos". É **falta de visibilidade**: na V1 você respondia, era corrigido, e não sobrava nada que dissesse o que tinha evoluído. Por isso o entregável central aqui é o painel, não a avaliação.

Ela é agnóstica de tecnologia. O que você precisa aprender é derivado das suas specs e do seu código, nunca do conhecimento genérico do Claude sobre uma ferramenta.

## O ciclo

```
skill de spec-driven gera plan → design → tasks
        ↓
/mentor-map          antes de escrever código        ~5 min
        ↓
você desenvolve      (predições, dúvidas, dicas)     custo ~zero
        ↓
/mentor-review       depois do primeiro código       ~5 min
        ↓
/mentor-eval         opcional, quando quiser         5 / 15 / 30 min
        ↓
/mentor-close        quando a atividade termina      ~10-15 min
        ↓
próxima feature
```

## Quando usar cada comando

### `/mentor-map`
**Quando**: assim que a skill de spec-driven gerar as tasks, antes de escrever qualquer código.
**Para**: descobrir o que essa atividade exige que você saiba e onde você já está.
**O que acontece**: o Claude lê suas specs, deriva os objetivos de aprendizado, faz o questionário de triagem só para tags novas, e te mostra o painel.
**O que você recebe**: a lista do que essa feature exige, o que já está no alvo, o que voltou frágil de features anteriores e o que está atrasado para revisão.

Na primeira execução no repositório ele vai te pedir o caminho dos artefatos da spec-driven. Ele guarda isso e não pergunta de novo.

### `/mentor-review`
**Quando**: depois de escrever uma parte significativa do código. Uma ou duas vezes por feature.
**Para**: transformar o código que você já escreveu na evidência mais forte que existe.
**O que acontece**: o Claude lê o diff e pergunta *por que* você decidiu daquele jeito. Não é code review de estilo.
**Importante**: é o único caminho barato para o nível `decide`. Uma decisão justificada no seu próprio código vale mais que qualquer prova.

Ele vai perguntar de onde veio um trecho quando o código parecer mais seguro que a sua explicação. Responder "copiei do doc" não é problema — é informação, e evita que o painel te credite algo que você não tem.

### `/mentor-eval`
**Quando**: quando quiser uma rodada avulsa. Não é obrigatório todo ciclo.
**Para**: cobrir lacunas e puxar revisões vencidas.
**Como**: `/mentor-eval --time 5`, `--time 15` ou `--time 30`. Sem argumento, usa o padrão do `profile.md`.

Múltipla escolha aqui é instrumento barato de revisão, não o eixo principal — ela nunca promove nada para `decide`.

### `/mentor-close`
**Quando**: quando você considerar a atividade concluída, antes de gerar a próxima spec.
**Para**: consolidar e fechar a feature.
**O que acontece**: você explica o que construiu no formato Feynman (sem interrupção), responde 2-3 cenários de decisão, e o Claude fecha o ciclo escrevendo o relatório.
**O que você recebe**: a resposta para "o que eu aprendi aqui" — o que subiu de nível e com base em qual evidência, o que continua frágil, quais equívocos foram fechados, e o que está perto de virar fluente.

É o comando mais importante do ciclo. Se faltar tempo, corte os cenários, nunca o fechamento.

### `/mentor-progress`
**Quando**: a qualquer momento.
**Para**: ver onde você está. Não faz nenhuma pergunta.
**Variações**: `--all` mostra tudo sem colapsar, `--tag <tag>` filtra por assunto.

## Fora dos comandos

Enquanto você trabalha:

- **Dúvida sobre um conceito** → o Claude responde. Não devolve pergunta, não transforma em quiz. Ele registra que você perguntou, porque perguntar duas vezes sobre a mesma coisa é sinal.
- **Você trava** → a ajuda escala com o número de tentativas que você relatar. Primeira vez: uma pergunta que te reorienta. Depois de tentar bastante: explicação completa. Diga quantas vezes já tentou — ele não adivinha.
- **Você anuncia que vai rodar/subir algo** → ele pergunta uma vez o que você espera que aconteça, e depois te deixa rodar. Se você ignorar, ele não insiste. É a avaliação mais barata que existe e a que melhor mede modelo mental.
- **Você pede o código pronto** → ele não entrega, mas te dá a estrutura e a dica que destrava. Se você disser explicitamente que quer aquilo delegado (é boilerplate, está fora do escopo de aprendizado, é prazo), ele faz — a ideia é que delegar seja uma escolha consciente, não o caminho mais fácil.

## Os arquivos

Tudo em `.mentor/`, versionado no git. O histórico do git vira, de graça, o registro de quando cada coisa evoluiu.

| Arquivo | O que é | Quem escreve | Você lê? |
|---|---|---|---|
| `profile.md` | seu perfil: experiência e alvo por tag, configuração | `/mentor-map` | raramente |
| `knowledge.md` | registro de todos os objetivos do projeto e seus estados | todos os comandos | quando quiser auditar |
| `progress.md` | **o painel** — em português, derivado, descartável | `/mentor-progress` | **sempre** |
| `features/<slug>/map.md` | o que esta feature exige e de onde veio | `/mentor-map` | no início da feature |
| `features/<slug>/evidence.jsonl` | log append-only de tudo que foi avaliado | todos os comandos | quase nunca |
| `features/<slug>/report.md` | o que aconteceu nesta feature | `/mentor-close` | ao fechar |

Regras que valem a pena conhecer:

- **`evidence.jsonl` só cresce.** Nunca é reescrito. Correção é linha nova, não edição.
- **Log de feature fechada nunca mais é lido.** O `report.md` e as linhas do `knowledge.md` carregam tudo adiante. É isso que impede o contexto de explodir no mês 3.
- **`progress.md` nunca é fonte de verdade.** Pode apagar; `/mentor-progress` regenera.
- **Nada é deletado.** Objetivo que deixou de ser necessário vira `archived:` e mantém histórico. Se voltar numa feature futura, volta com o histórico.
- Você pode editar qualquer arquivo à mão. Se discordar de um estado, mude — mas o caminho recomendado é contestar na conversa: aí o Claude agenda uma nova sondagem em vez de simplesmente reescrever o estado.

## Como ler os estados

```
não avaliado → declarado → frágil → explica → decide → fluente
```

- **declarado** — você disse que tem experiência no questionário. É evidência fraca de propósito.
- **frágil** — há evidência de lacuna ou um equívoco em aberto.
- **explica** — sabe dizer o que é, por que existe e como funciona, sem consultar.
- **decide** — sabe escolher sob condições e justificar, e sabe o que quebra na escolha errada.
- **fluente** — **duas evidências no alvo, sem consulta, separadas por pelo menos 14 dias.**

`fluente` é o único estado que exige tempo passado, e é de propósito. Seu objetivo é usar o conhecimento sem consultar, como você usa `class` e `self` — isso é automatismo, e automatismo não se demonstra dentro de uma feature de uma semana. Qualquer sistema que te dá "dominado" no fim de um ciclo está medindo outra coisa.

Cair de nível é normal e não é punição: revisão errada volta para `frágil` e reinicia a escada.

## Revisão espaçada

Objetivo que chega no alvo entra numa escada fixa: **3 dias → 7 dias → 21 dias → 60 dias**. No vencimento ele aparece em "Volta para revisão" e entra na próxima rodada, misturado com o conteúdo novo.

Isso puxa objetivos de features antigas para dentro das novas. É o único mecanismo que leva de `decide` para `fluente`, e a razão pela qual conhecimento de dois meses atrás não evapora.

Não existe "não repetir". Voltar ao mesmo objetivo é o mecanismo; o que a skill evita é repetir a *mesma pergunta com as mesmas palavras* em intervalo curto.

## Calibração

Antes de te mostrar qualquer correção, o Claude pergunta sua confiança (alta/média/baixa).

O que interessa é **confiança alta + erro**. É o sinal mais valioso do sistema, porque marca conhecimento que você não sabe que não tem — e é invisível sem esse passo. Aparece no painel quando se concentra em alguma tag.

## Orçamento de tempo

Por feature, contando tudo: cerca de **20 minutos**, concentrados no `/mentor-map` e no `/mentor-close`. O meio do desenvolvimento é quase de graça — predições e review acontecem dentro do trabalho que você já faria.

Se precisar cortar, corte nesta ordem: `/mentor-eval` avulso → cenários do close → `/mentor-review`. **Nunca corte o fechamento** — sem ele a feature não deixa registro, que é exatamente o problema da V1.

## Se algo der errado

- **O painel está estranho ou desatualizado** → `/mentor-progress` regenera do zero.
- **Um objetivo está com estado que você acha errado** → conteste na conversa. O Claude agenda uma nova sondagem em vez de reescrever.
- **O caminho das specs mudou** → rode `/mentor-map`; ele pergunta de novo e atualiza o `profile.md`.
- **Você quer parar de ser testado numa tag** → responda `skip` na triagem, ou anote em `profile.md` → Notes.
- **Está avaliando demais / de menos** → ajuste `default_eval_budget` no `profile.md` e pule o `/mentor-eval` avulso.
