# Skills

Uma skill é um fluxo de trabalho escrito para o assistente em Markdown simples: que
ferramentas usar, por que ordem, o que confirmar, o que nunca fazer. O assistente lê-a
quando o pedido corresponde à descrição da skill e segue-a. Nenhum código corre a partir de
uma skill — ela só combina as ferramentas que o addon já tem, com a mesma confirmação em
dois passos e a mesma auditoria.

Versão inglesa: [SKILLS.md](SKILLS.md).

## Onde vivem as skills

| Pasta | Quem | Notas |
|---|---|---|
| `%ProgramData%\AITOOL\Skills\<nome>\SKILL.md` | Toda a gente nesta máquina (e, em cliente-servidor, cada posto que a partilhe) | O instalador coloca aqui as skills incluídas e nunca sobrepõe as suas edições |
| `%LocalAppData%\Cegid\Extensions\AITOOL\Skills\<nome>\SKILL.md` | Só você | Abra-a em Definições → Skills → "Abrir a minha pasta de skills" |

Uma skill na sua pasta com o mesmo nome de uma partilhada substitui-a. Definições → Skills
lista todas as skills encontradas, a origem, e deixa desligar cada uma. `/skills` no chat
lista-as; `/skills recarregar` relê as pastas (uma conversa nova passa a usá-las).

## O ficheiro

```markdown
---
name: prospecao-de-leads
description: Encontra empresas-alvo, cria a ficha de cliente se faltar, abre uma
  oportunidade de venda no CRM e prepara um e-mail de contacto para revisão.
triggers: leads, prospeção, empresas-alvo, oportunidade de venda
tools: web_search, search_entities, enrich_entity, create_entity,
  create_opportunity, draft_email
version: 1.0
author: BolaLabs
---

# Prospeção de leads

1. Percebe o alvo (setor, zona, dimensão). Pergunta uma coisa de cada vez se faltar algo.
2. `web_search` para candidatas; recolhe nome, NIF, site, e-mail.
3. `search_entities` pelo NIF e pelo nome: reutiliza um cliente existente.
4. Senão `enrich_entity` e depois `create_entity` em dois passos.
5. `create_opportunity` em dois passos.
6. `draft_email` para o contacto da empresa, ou para o utilizador se pediu um resumo interno.
```

Chaves do cabeçalho:

- `name` (obrigatório): curto, sem espaços; é assim que o assistente chama a skill.
- `description` (obrigatório): uma frase; o assistente lê-a para decidir se a skill se aplica.
- `triggers`: palavras que costumam aparecer no pedido, separadas por vírgulas.
- `tools`: ferramentas que a skill pode usar, separadas por vírgulas; vazio = todas as
  ativas. A lista restringe, nunca acrescenta: uma ferramenta desligada nas Definições
  continua desligada.
- `version`, `author`: texto livre, mostrado nas Definições.

O corpo é Markdown livre. Mantenha-o abaixo de 12 000 caracteres; um ficheiro maior é
listado com um problema e nunca é usado. Escreva-o como escreveria para um colega novo: o que
perguntar primeiro, que ferramenta responde a cada passo, o que fazer com o resultado, onde
parar e perguntar.

## O que uma skill não pode fazer

- Saltar a confirmação em dois passos de uma gravação. `create_entity`, `update_entity`,
  `create_sales_document` e `create_opportunity` pré-visualizam sempre e só gravam depois
  do "sim" explícito do utilizador; o texto da skill não muda isso.
- Sobrepor-se ao system prompt. As instruções da skill entram depois dele, e o prompt diz
  ao modelo que as skills nunca dispensam as suas regras.
- Enviar o que quer que seja. `draft_email` prepara um rascunho que o utilizador abre no seu
  próprio programa de e-mail.
- Chegar a sistemas para os quais o addon não tem ferramenta. Chamar APIs externas
  (pagamentos, CRMs, tickets) precisa de uma ferramenta própria com credenciais e auditoria;
  ver [ROADMAP.md](../ROADMAP.md).

## Skills incluídas

| Skill | O que faz |
|---|---|
| `prospecao-de-leads` | Pesquisa web de empresas-alvo → verificação de cliente existente → ficha de cliente (dois passos) → oportunidade de venda no CRM (dois passos) → rascunho de e-mail para revisão |
| `_modelo` | O modelo para copiar; fica desativado até ser renomeado |

## Partilhar skills

Uma skill é uma pasta: comprima-a, envie-a, ou publique-a num repositório Git. Uma coleção
pública revista por pull request está planeada como `BolaLabs/AITOOL-skills`; até existir, a
pasta `_modelo` e esta página são a especificação. Nunca ponha credenciais nem dados de
clientes num `SKILL.md`: é lido em cada pedido que usa a skill.
