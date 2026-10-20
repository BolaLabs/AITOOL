# AITOOL user guide

For the people who use the assistant inside Primavera v10 every day: accounts, sales,
purchasing, the back office. Installation is in [INSTALL.md](../INSTALL.md); what the product
is and how it is built is in the [README](../README.md).

Every example below was run on DEMOV10, the Cegid demo company, on the version this guide
ships with. Codes such as `SOFRIO`, `F0003` or `A0001` are that company's.

---

## 1. Open it

The ribbon has a **BOLA LABS** tab with an **Assistente AI** button. The chat opens docked at
the right of the ERP; the button at the top of the panel pops it out into its own window.
`Ctrl+N` starts a new conversation, `Ctrl+B` opens the list of conversations, `Ctrl+,` the
settings.

The first time, the settings ask for an AI key (OpenAI, Anthropic, OpenRouter, or a local
server). Nothing else needs configuring.

## 2. Ask about your data

Write the question as you would ask a colleague. The answer comes from the ERP's own data
and, where the ERP has a query of its own (pending items, for instance), from that query.

| You write | You get |
| --- | --- |
| *Que pendentes tem o cliente SOFRIO?* | The pending documents, as cards and a live table |
| *Quanto vendemos do artigo A0001 desde 2019 e a que clientes?* | Net sales of that article, per customer |
| *Vendas por mês de 2016* | A chart and the table behind it |
| *Qual o stock do A0002 por armazém?* | Stock per warehouse |
| *Quais os 10 melhores clientes do ano passado?* | A ranking with the totals |

Each row of a table has a menu: open the record in the ERP, generate the PDF, show the
pending items. **Copiar** copies the table so it pastes into Excel.

### It knows what you have open

Each message carries the record open in the ERP (a customer, a supplier, an article) and the
window in front. *"Quanto deve este cliente?"* with a customer record open needs no code.
The chat header shows what is being shared and has a switch to stop it. Writing `@` and a
name brings any other record into the message.

## 3. Open any screen by name

*"Abre o explorador de vendas"*, *"abre a ficha do fornecedor F0003"*, *"abre o editor de
liquidações"*. The assistant finds the function in the ERP's own ribbon catalogue, across
every module the company has, and opens it. When the ribbon button is in view the cursor
glides to it, so you see what is being clicked.

The first time a wording is used, the card shows where it went and asks **Era isto** /
**Não era isto**. Your answer is remembered for every workstation of the company.

## 4. Fill a screen by writing

This is the part built for accessibility: a person who cannot use the mouse, or prefers not
to, drives the ERP windows by text.

- *"Que campos tem esta janela?"* lists the fields of the window in front, tab by tab, with
  their current values.
- *"Põe o cliente SOFRIO"* puts the customer in the document's entity field, checks that the
  document accepts that kind of entity, and reads back the name the ERP shows.
- *"Data de hoje, condição de pagamento a 45 dias, armazém 2"* fills several fields at once.
  Words such as "Fatura a 45 dias" or "Armazém 2" are turned into the codes the company's
  tables have for them; when two codes fit, it asks which.
- *"Uma linha do artigo A0002, quantidade 3, preço 250"* adds a document line. In the sales,
  purchase and internal-document editors the article goes into the grid and quantity, price,
  discount, description and warehouse go into the document line through the editor's own
  events, so the ERP computes the line as if you had typed it.
- *"Põe 2 do I0001 com DDR2-1024 e MT2200 e 1 com DDR2-512 e MT2500"*: for an article with
  dimensions the assistant fills the ERP's variant grid and confirms it; the document gets the
  article's aggregator line and one line per variant, as if you had picked them. Without saying
  which, it asks; *"abre a grelha que eu escolho"* leaves the grid open for you.
- *"Põe 2 peças do A0005 com 1,5 de largura e 2 de comprimento"*: for a formula article the
  measures go into the ERP's "Fórmula" dialog and the line carries the quantity the ERP computes.
- *"Lê o diálogo"* reads a message box the ERP opened, and says what each answer does.

When the ERP opens a window that blocks the rest (the variant grid, "Fórmula", "Números de
Série", a warning), the assistant moves to a window of its own in the same place and keeps
answering; it goes back to the panel when that window closes. Turn it off in Settings →
Avançado → Comportamento.

Fields on tabs that are not in view are reached without changing tab by hand.

**What it never does on its own:** press a button that saves, cancels or deletes. Gravar,
Confirmar, Anular, Apagar and the like go through the confirmation card (section 6), and so
does answering "Sim" to an ERP dialog such as "save changes?". With the assistant docked in the
panel, that answer is yours, in the ERP.

## 5. Create documents and records without opening the editor

For the common writes the assistant goes straight to the ERP's business engine. Nothing is
typed into a window; the ERP validates exactly as it does when you save by hand, and the
numbering is the ERP's.

| You write | It prepares |
| --- | --- |
| *Cria o cliente Exemplo Lda, NIF 999999990* | A customer record |
| *Cria o artigo AIT1018 "Cabo HDMI 2 m", unidade UN, IVA 23* | An article record |
| *Faz uma proposta ao SOFRIO com 2 A0001* | A sales document, with the ERP's prices and totals |
| *Lança a fatura do fornecedor F0003, documento FT 2026/123, 5 A0002 a 300 euros* | A purchase document |
| *Faz um recibo ao cliente SOFRIO de 100 euros* | A customer receipt |
| *Paga 200 euros ao fornecedor F0001* | A supplier payment |
| *Faz um encontro de contas do cliente SOFRIO de 150 euros* | A customer and supplier compensation |
| *Recebe tudo o que o cliente MICROSOFTPOR deve* | A receipt for the whole balance |

### Receipts, payments and encontros de contas

- The pending documents come from the ERP's pending table, limited to what the settlement
  type is configured to settle.
- With an amount, the oldest debts are settled first, the last one in part. Open credit
  notes and advances stay open unless you name them or ask to settle everything; the card
  says how much was left out.
- Without an amount, the whole balance is settled, credit notes included.
- An encontro de contas uses the supplier associated to the customer in its record or, if
  there is none, the supplier with the same tax id. You can also name the supplier.
- A document that is pending but in a state the settlement type does not take (a supplier
  invoice still waiting for payment approval, for example) is explained with the ERP's own
  state name and the document that changes that state. It is not called "not pending".
- "Approve supplier X's invoices for payment" saves the approval (the ERP's APR document)
  from the card: the invoices move from "Aguarda Aprovação" to "Aprovada" and nothing is
  paid; the payment is the next step, with its own card.
- In the settlement editor (Contas Correntes), "put 500 in the amount to settle and
  distribute" fills Valor Entregue on the Distribuição Automática tab and presses
  Distribuir: the ERP spreads the amount over the oldest pending items without saving;
  only Confirmar saves, and that goes through the card.
- When the customer's record has no payment method and the settlement type reports to
  SAF-T, the method that type is usually saved with is used, and the card says so.

## 6. The confirmation card

Every write is shown before it happens, as a card with:

- the document type and series, the entity and its name;
- every line, or every settled document, with the amount that will be settled;
- the ERP's own totals: goods, discounts, VAT, withholding tax, total, or the amount
  compensated in an encontro de contas;
- warnings, in amber: a default the tool chose, a credit left open, a field the ERP filled.

The save runs when you press the card's button and on nothing else. Writing "sim" in the
chat does not save. After the save the card says **Gravado** with the number the ERP gave;
if the ERP stopped with a dialog, the card says what is missing there.

Every save, refusal and failure goes to `AI_AuditLog` in the company database, with the user,
the tool and the outcome. `/auditoria` shows yours; supervisors (administrators and
technicians) see everyone's with `/auditoria todos`.

## 7. What it does by itself

- **Several steps in one go.** "Abre o editor de compras para o F0003 com uma linha do A0002"
  is one request: open the editor, set the supplier, add the line. The steps run in one batch
  and stop at the first one that fails or needs your confirmation.
- **Learns requests that repeat.** A request that ran cleanly becomes a recipe. From the
  third time it runs directly, without asking the AI model for the plan: the same kind of
  request with other values (another customer, another article) takes seconds. `/receitas`
  lists what was learned, and a recipe never saves on its own: writes still go through the
  card.
- **Learns the company's wording.** "NIF" for Contribuinte, "plafond" for Limite de
  crédito, "editor de liquidações" for Pagamentos e Recebimentos → Operações. It learns from
  the values the ERP kept, from corrections, and from your answers on the cards, and shares
  that with every workstation through the company database. What you reject is not proposed
  again.
- **Picks sensible defaults and says so.** A purchase invoice type when none is given (the
  one the company uses most), the default series for today, a payment term or method when
  the record has none. Each default is a warning on the card, never a silent choice.
- **Notices when it is slow.** A long step shows what it is waiting for; a model that does
  not answer in 30 seconds is retried once.
- **Keeps the AI model honest.** When a model claims it did something in the ERP without
  calling a tool, the addon asks it again with a tool required, and tells you if it insists.

## 8. Choosing the AI model

Any model with tool calling works; the difference is speed, cost and how often it needs the
safety net of section 7. In our bench on 2026-10-18 (the same nine requests, real ERP):

| Result | Models |
| --- | --- |
| Excellent | gpt-oss-120b, MiniMax M3, Nemotron 3.5 Lightning, Claude Haiku 5.5, Mistral Small, GPT-6 Luna |
| Good | GPT-5.6 Sol (slower and dearer), GLM, DeepSeek, Gemini Flash, Qwen3 14B, Kimi K3 |
| Works with the safety net | Llama 4 Maverick |
| Not recommended | very small models without tool calling |

The model chip in the chat header changes model; the reasoning chip trades speed for
depth. The session panel (the counter in the header) shows tokens and the estimated cost of
each request.

## 9. Commands and shortcuts

| Command | What it does |
| --- | --- |
| `/novo` | New conversation |
| `/limpar` | Clear the current conversation |
| `/exportar` | Export to Markdown, HTML or text |
| `/config` | Settings |
| `/auditoria [N]`, `/auditoria todos [N]` | Your audit trail, or everyone's (supervisors) |
| `/compactar` | Summarise a long conversation to free context |
| `/skills` | The company's skills (processes written in Markdown) |
| `/receitas` | The requests it learned to run directly |
| `/ajuda` | Help |

`Ctrl+N` new chat · `Ctrl+B` conversations · `Ctrl+,` settings · `Enter` sends ·
`Shift+Enter` new line.

## 10. When something goes wrong

- Error cards carry a reference such as **ref. T-1a2b**. Give it to support: it identifies
  the turn in the log.
- Settings → Diagnóstico builds a support bundle (report and seven days of logs, redacted).
- A window that does not respond to the assistant usually has an ERP dialog open behind it:
  answer it in the ERP and ask again.
- A wording that went to the wrong place: answer **Não era isto** on the card. It will not
  be proposed again.

## 11. Limits worth knowing

- It does not enforce Primavera's per-user permissions on what it reads; see
  [SECURITY.md](../SECURITY.md).
- It never cancels or deletes documents by itself, and has no tool for that.
- The sales explorer has no article restriction: sales of an article are answered from the
  data, not in that window.
- Bills of exchange and bank remittances are done in the ERP; the assistant explains when
  a document is waiting for one of them.
