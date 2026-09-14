# Skills

Uma skill é um fluxo de trabalho escrito para o assistente em Markdown simples: que
ferramentas usar, por que ordem, o que confirmar, o que nunca fazer. O assistente lê-a
quando o pedido corresponde à descrição da skill e segue-a. Nenhum código corre a partir de
uma skill — ela só combina as ferramentas que o addon já tem, com o mesmo cartão de
confirmação em cada escrita e a mesma auditoria.

Versão inglesa: [SKILLS.md](SKILLS.md).

## Onde vivem as skills

| Pasta | Quem | Notas |
|---|---|---|
| `<ERP>\Config\EV\Extensions\AITOOL\Skills\<nome>\SKILL.md` | O próprio addon | As skills que vêm com cada versão (`incluída` no `/skills`); substituídas em cada atualização, por isso não edite aqui |
| `%ProgramData%\AITOOL\Skills\<nome>\SKILL.md` | Toda a gente nesta máquina (e, em cliente-servidor, cada posto que a partilhe) | Criada vazia pelo instalador, que repõe a ACL em cada instalação para que só o SYSTEM e os administradores escrevam; uma atualização nunca toca no que lá estiver |
| `%LocalAppData%\Cegid\Extensions\AITOOL\Skills\<nome>\SKILL.md` | Só você | Abra-a em Definições → Skills → "Abrir a minha pasta de skills" |

Uma skill partilhada com o mesmo nome de uma incluída substitui-a, e uma skill na sua pasta
substitui ambas. Uma pasta ou `name` a começar por `_` é um modelo: aparece na lista, nunca
é oferecida ao assistente. As skills que desligar ficam registadas em
`%LocalAppData%\Cegid\Extensions\AITOOL\skills-disabled.json` — um ficheiro por
utilizador, pelo que desligar uma skill partilhada só o afeta a si. Definições → Skills mostra
quantas skills foram encontradas e, para cada uma, uma pill Incluída / Partilhada / Minha, a
descrição, as frases que a ativam e o interruptor. O botão "Abrir pasta partilhada" só aparece
a um supervisor (administrador, super administrador ou técnico do ERP), porque o que lá for
posto corre para toda a gente na máquina. `/skills` no chat lista-as; `/skills recarregar`
relê as pastas e reconstrói o system prompt da conversa aberta, pelo que a mensagem seguinte
já vê a alteração.

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
4. Senão `enrich_entity` e depois `create_entity` (pré-visualização e cartão).
5. `create_opportunity` (pré-visualização e cartão).
6. `draft_email` para o contacto da empresa, ou para o utilizador se pediu um resumo interno.
```

Chaves do cabeçalho:

- `name`: curto, sem espaços; é assim que o assistente chama a skill. Se faltar, usa-se o nome da pasta.
- `description` (obrigatório): uma frase; o assistente lê-a para decidir se a skill se aplica.
- `triggers`: palavras que costumam aparecer no pedido, separadas por vírgulas.
- `tools`: ferramentas que a skill conta usar, separadas por vírgulas. A lista orienta o
  assistente; não o restringe. O que o assistente pode chamar decide-se nas Definições, e
  uma ferramenta desligada lá continua desligada diga a skill o que disser.
- `version`, `author`: texto livre, mostrado nas Definições.

O corpo é Markdown livre. Mantenha as instruções abaixo de 12 000 caracteres (o cabeçalho
não conta); um corpo maior é listado com um problema e nunca é usado. Escreva-o como escreveria para um colega novo: o que
perguntar primeiro, que ferramenta responde a cada passo, o que fazer com o resultado, onde
parar e perguntar.

## O que uma skill não pode fazer

- Saltar a confirmação de uma gravação. `create_entity`, `update_entity`,
  `create_sales_document` e `create_opportunity` pré-visualizam sempre, e a confirmação é
  sempre o cartão: a gravação precisa de uma autorização de uso único que a aplicação emite ao
  desenhar esse cartão e que o clique do utilizador devolve. Uma skill que mande o assistente
  gravar diretamente, ou aceitar um "sim" escrito, não muda nada — a chamada é recusada e
  auditada.
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
| `prospecao-de-leads` | Pesquisa web de empresas-alvo → verificação de cliente existente → ficha de cliente (preview, cartão) → oportunidade de venda no CRM (preview, cartão) → rascunho de e-mail para revisão |
| `_modelo` | O modelo para copiar; fica desativado até ser renomeado |

## Partilhar skills

Uma skill é uma pasta: comprima-a, envie-a, ou publique-a num repositório Git. Uma coleção
pública revista por pull request está planeada como `BolaLabs/AITOOL-skills`; até existir, a
pasta `_modelo` e esta página são a especificação. Nunca ponha credenciais nem dados de
clientes num `SKILL.md`: é lido em cada pedido que usa a skill.
