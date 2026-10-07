**English** | [Português](README.pt.md)

<div align="center">

<img src="docs/assets/banner.svg" alt="AITOOL — AI assistant embedded in ERP Primavera v10" width="920">

**An assistant inside PRIMAVERA v10 that runs entirely on machines you control** — no vendor
account, no per-seat licence, no metered credits — with the model you choose, including a
local one. It answers from your business data, opens any ERP screen you describe in plain
language, fills windows, and creates customers and sales documents through the ERP's own
business objects: a preview validated by the ERP first, a save only from the confirmation
card you click, and every write in an audit trail in your own database.

[![.NET Framework](https://img.shields.io/badge/.NET%20Framework-4.8-512BD4?logo=dotnet)](https://dotnet.microsoft.com/download/dotnet-framework/net48)
[![DevExpress](https://img.shields.io/badge/DevExpress-21.2.3-FF7200)](https://www.devexpress.com/)
[![Platform](https://img.shields.io/badge/Platform-Windows-0078D6)](https://www.microsoft.com/windows)
[![License: Community](https://img.shields.io/badge/License-Community%20(free)-D9A441.svg)](LICENSE)
[![Feedback welcome](https://img.shields.io/badge/Feedback-welcome-D9A441.svg)](CONTRIBUTING.md)
[![Website](https://img.shields.io/badge/Web-bolalabs.pt-1E3A5F)](https://bolalabs.pt)

</div>

---

**Navigate by who you are:**

| I want to... | Go to |
| --- | --- |
| Understand what this is, without the engineering | [In plain terms](#in-plain-terms) |
| See what the assistant can actually do | [What it does](#what-it-does) · [The 26 tools](#the-26-tools) |
| Reach a screen I cannot find in the menus | [Find any screen in plain language](#find-any-screen-in-plain-language) |
| Decide whether it is safe to put near my ERP | [Security and trust](#security-and-trust) · [docs/SECURITY-AND-PRIVACY.md](docs/SECURITY-AND-PRIVACY.md) |
| Install it, on one PC or on a whole network | [Install once, every workstation gets it](#install-once-every-workstation-gets-it) · [Install (end users)](#install-end-users) |
| Compare it with Cegid Pulse | [How this compares to Cegid Pulse](#how-this-compares-to-cegid-pulse) |
| Build it from source | [Build (source licensees)](#build-source-licensees) |
| Know where this is going | [Beyond Primavera](#beyond-primavera) · [ROADMAP.md](ROADMAP.md) |

---

## In plain terms

You open your ERP as always. A new button on the ribbon opens a chat. You ask, in your own
words: *"how much does this customer owe me, and since when?"* — and the assistant answers
from your real data, with the numbers the ERP itself would give you. Ask it to prepare a
proposal and it fills one in, shows you the totals for review, and saves only when you press
the button on the confirmation card. Every change it makes goes through the same validations
the ERP applies to you, and is recorded in an audit trail in your own database.

Five things make it different from pasting your data into a chatbot:

- **It runs where you decide.** Inside your ERP, on your own machines. There is no Bola
  Labs server in the path, no account to create, and with a local AI model nothing leaves
  the building at all.
- **You choose (and pay) the AI directly.** OpenAI, Anthropic, OpenRouter, any
  OpenAI-compatible endpoint, or a local model on a compatible server such as LM Studio — at provider prices, with
  no subscription, no per-seat licence and no metered credits on top.
- **Any screen, by asking.** "Open the supplier account statement", "open the sales
  explorer": it finds the function in the ribbon catalogue and opens it, whichever
  module it lives in. Nobody needs to remember where a screen is.
- **It shows the write before it happens.** Creating or changing records runs in two steps:
  a preview validated by the ERP itself, then a confirmation card with the fields and the
  ERP's own totals. The save runs on your click on that card and on nothing else — and every
  save, refusal and failure lands in an audit log you can read from the chat.
- **It knows who is asking.** The assistant reads the name, login and profile of the ERP
  user with the open session and addresses you by name; administrators, super administrators
  and technicians additionally get a supervisor view over the audit trail and everyone's
  conversations. Your registered e-mail address is never sent to the model.

The product is free to use, for companies and partners alike. Install it from the setup wizard
([how it works](#install-end-users)), configure an AI key, and it is working in minutes.

---

## What it looks like

<table>
<tr>
<td><img src="docs/assets/screenshot-pendentes-kpi.png" alt="Pending items: KPI cards, filters and the live table, docked beside the ERP" width="300"></td>
<td><img src="docs/assets/screenshot-preview-confirmacao.png" alt="A change to a client record previewed and waiting for the user's confirmation" width="300"></td>
<td><img src="docs/assets/screenshot-auditoria.png" alt="The /auditoria view over AI_AuditLog in the chat" width="300"></td>
<td><img src="docs/assets/screenshot-sessao-custos.png" alt="The session panel: context, requests, tokens, estimated cost and the Compactar button" width="300"></td>
</tr>
<tr>
<td><sub>"Dá-me a lista de pendentes desde 2015" — the ERP's own pending-items query, as cards and a live table.</sub></td>
<td><sub>A write is previewed by the ERP first and saved only from the confirmation card.</sub></td>
<td><sub>Every save, refusal and failure lands in <code>AI_AuditLog</code>, in your database.</sub></td>
<td><sub>Context, tokens and cost per request; one click compacts a long conversation.</sub></td>
</tr>
</table>

<img src="docs/assets/screenshot-ficha-ao-lado.jpg" alt="The assistant docked at the right of the Primavera client, with the client record it opened beside it" width="920">

Captured on DEMOV10, the Cegid demo company (screen 2.8.0, session panel 2.9.0).

**Watch it work.** A two-and-a-half-minute film of the published version on DEMOV10 — the installer,
a screen opened by name, real data, the official PDF, a write with a brake, the audit table, a skill
running a whole process — plays on the product page: [bolalabs.pt/en/aitool](https://bolalabs.pt/en/aitool/).
Nothing in it is a mock-up.

---

## What it does

AITOOL is a WinForms extension (.NET Framework 4.8) that embeds a chat assistant into the
Primavera v10 (SG100) client via WebView2. The assistant talks to the model of your choice —
OpenAI, OpenRouter, native Anthropic, or any OpenAI-compatible endpoint (LM Studio is one) —
and acts on the ERP through 26 auto-discovered tools:

- **Reads real ERP data.** Pending items with the ERP's own query, sales analysis by
  period, client and article, sales and purchase counts per year via `run_query`, current-account balances with aging, stock per warehouse, document search,
  entity search by name, code, tax id or city — plus a read-only SQL tool guarded to
  `SELECT`/`WITH` and capped at 500 rows. Tabular answers render as live tables with KPI
  cards, and each row carries a context menu: open in the ERP, generate the PDF, open the
  record, show its pending items.
- **Drives the ERP client.** Opens any ERP function by name from the ribbon catalogue,
  across every navigation context the installation has — Sales, Accounting, Treasury, HR,
  whatever is licensed. Opens records (client, supplier and article cards, documents,
  account statements) in their native editors. In an open window it lists the fields,
  fills fields and grid cells, clicks buttons and tabs, reads modal dialogs and closes
  windows — on .NET windows and on the legacy VB6 editors alike, through UI Automation.
  When the ribbon button is visible the cursor glides to it, so you see what is being
  clicked.
- **Writes with a preview.** Creates customer and supplier records and sales documents
  (proposals, orders, invoices) and updates existing records, always through the
  Primavera business objects so every ERP validation runs and numbering stays the ERP's.
  The first call is validated by the ERP (`ValidaActualizacao`) and returns a preview with
  real totals without saving; that preview is drawn as a confirmation card — the fields, the
  warnings and the totals the ERP computed — and the save runs only when you press its
  button. After a save, a notice tells you which open ERP windows are now stale. Every save,
  refusal and failure is written to `AI_AuditLog` in your own database; `/auditoria` in the
  chat reads it back.
- **Commit buttons go through the same card.** The window automation may type into fields
  and press buttons, but a button that commits or destroys data (gravar, guardar, anular,
  apagar, eliminar, remover, confirmar) is refused unless the call carries the authorisation
  the card issues. The check runs on the button the ERP actually resolved, not on the caption
  that was asked for. Inside a modal dialog the rule inverts: only a refusal (Cancelar, Não)
  and single-button acknowledgements pass; any other answer, "Sim" to "Save changes?"
  included, is given by the user in the ERP itself, because a dialog the ERP is waiting on
  blocks the window the chat lives in. A click is reported as a click: the card says
  "Gravado" only for what the ERP confirmed. Every field write, grid write, button click and window close through
  the automation is recorded in `AI_AuditLog` with the user, company, tool, arguments and
  outcome. Ribbon navigation is not audited, and if the audit insert itself fails the ERP
  write still stands (the failure is logged locally). See [SECURITY.md](SECURITY.md) for
  what that boundary is and is not.
- **Documents.** The official PDF of a document, produced by the Crystal report the series
  is configured with — ATCUD and QR code are the ERP's own — opens by itself in a viewer
  card, and Imprimir on the card opens the print dialog. When the series has no report configured you get an amber warning and a plain
  data sheet instead, never a fake official document.
- **Entity enrichment.** Give it a tax id and the assistant fills the record from public
  registries (VIES, NIF.pt), validates the tax id by country, and shows a field-by-field
  diff before anything is written.
- **Web search.** Five providers — Brave, Exa, Serper, Tavily or a self-hosted SearXNG —
  with your own key, for leads and company data; results are explicitly marked as
  untrusted content.
- **Fills whole screens in one step.** `set_fields` writes every field of a record,
  including the ones on other tabs, and `set_grid_row` a whole document line in the ERP's own
  grid, reporting field by field where each value landed. A window is read in under half a
  second. With the optional fast decision model (Jev, off by default) the names that do not
  match — "NIF" for "Contribuinte", "plafond" for "Limite", "editor de documentos de venda"
  for a ribbon path — are resolved in about 0.3 s, ERP dialogs are classified, and buttons
  get a second opinion that can only ask for more confirmation.
- **Learns your wording, for every workstation.** The addon ships knowing what common
  requests mean in the ERP windows, in a text file an administrator can edit once for
  everyone. Each workstation adds what it learns — from the values the ERP kept, from the
  correction that followed a request it could not place, and from your answer on the card
  ("Era isto" / "Não era isto") — and shares it with the others through the company
  database. What you reject is not proposed again. Names of fields, columns and functions
  only, never the values; and no file is indispensable: a missing or damaged one is
  rebuilt.
- **Discovers instead of guessing.** Document types, series (with validity) and article
  prices come from the ERP configuration through dedicated lookup tools.
- **Chat that behaves like a product.** Streaming with phase indicators and a cancel that
  stops the turn in under a second; collapsible thinking blocks; Markdown, Mermaid and
  syntax highlighting rendered fully offline (vendored, pinned, SRI-checked libraries);
  follow-up suggestion chips; conversation history in your SQL Server with search and
  rename; eight slash commands (`/novo`, `/limpar`, `/exportar`, `/config`,
  `/auditoria [N] | todos [N]`, `/compactar`, `/skills`, `/ajuda`); light/dark/system themes;
  keyboard shortcuts (`Ctrl+N` new chat,
  `Ctrl+B` sessions, `Ctrl+,` settings); pop-out window; export to Markdown, HTML or plain
  text. The assistant states that it is an AI system, as AI Act Article 50 requires.

### The 26 tools

| Tool | What it does |
| --- | --- |
| `search_entities` | Searches customers, suppliers and articles by name, code, tax id (NIF) or city |
| `get_entity_details` | Full details of one entity (customer, supplier, article) |
| `get_pending_items` | Pending documents per entity, or across all entities; accepts date arguments |
| `query_account_balance` | Current-account balance for a customer/supplier, with aging buckets |
| `query_documents` | Searches commercial documents by type, entity, date or status |
| `analyze_sales` | Sales analysis by customer, article or period; top-N and period comparison. Scoped by the ERP's own document classification, so credit notes and returns are deducted — the figures are net |
| `check_stock` | Current, minimum and maximum stock of an article per warehouse |
| `render_document` | Header and lines of a commercial document, shown as an interactive card |
| `run_query` | Model-written read-only SQL — `SELECT`/`WITH` only, write/DDL blocked by a guard |
| `open_record` | Opens a record (file, document, account statement) in its native ERP editor |
| `open_erp_function` | Opens any ERP function by name, navigating the ribbon; lists the inventory when unsure |
| `interact_erp_window` | Lists windows and fields, fills fields and grid cells, clicks buttons — .NET and native (VB6) windows |
| `print_document` | Generates the official report PDF of a document; the card offers Ver, Imprimir, Guardar como… and the rest under Mais |
| `get_sales_document_types` | Lists the sales document types configured in this ERP installation, each with the nature the ERP assigns it (quote, order, delivery note, invoice) |
| `get_sales_series` | Lists the series of a document type, with default and today's validity |
| `get_article_price` | Suggested price/discount from ERP price rules (price lists, customer rules, quantity tiers) |
| `create_entity` | Creates a customer/supplier file via BSO — preview first, saved from the confirmation card |
| `create_sales_document` | Creates a sales document via BSO — preview with real totals, saved from the confirmation card |
| `update_entity` | Updates fields of an existing customer/supplier file — preview first, saved from the confirmation card |
| `create_article` | Creates an article (goods or service) via BSO, with unit, VAT code and price — preview first, saved from the confirmation card; the VAT code is never guessed |
| `update_sales_series` | Extends or reactivates a sales series when the ERP refuses a document for a series that ran out; administrators and technicians only — preview first, applied from the confirmation card |
| `create_opportunity` | Creates a CRM sales opportunity for an existing customer — preview first, saved from the confirmation card |
| `draft_email` | Prepares an e-mail draft (to, subject, body) shown as a card; the user opens it in their own mail client, nothing is sent |
| `use_skill` | Loads the instructions of a skill — a workflow written in Markdown by whoever uses the ERP; see [docs/SKILLS.md](docs/SKILLS.md) |
| `enrich_entity` | Fills a file from public registries by tax id (VIES, NIF.pt), showing a field-by-field diff before anything is written |
| `web_search` | Public web search (Brave, Tavily, Exa, Serper or a self-hosted SearXNG); read-only, results flagged as untrusted content |

Settings → Ferramentas lists them grouped by what they do (queries, documents, writes with
confirmation, window automation, web and e-mail, skills) and toggles each one individually;
the whole tool layer has a kill switch (`ErpTools:Enabled` / `AITOOL_ERP_TOOLS_ENABLED`).

A typical end-to-end flow — *"this company emailed us, make them a proposal"*:
`web_search` finds the company → `search_entities` checks if it already exists →
`create_entity` (preview → card → your click) → `get_sales_document_types` + `get_sales_series`
pick the real proposal type and a valid series → `create_sales_document` (preview with ERP-computed
totals → card → your click) → `print_document` for the official PDF.

---

## Teach it your own workflows

A skill is a folder with one `SKILL.md`: a description the assistant reads to know when the
skill applies, and the steps to follow — which tools, in what order, what to confirm. No
code, no plugin to install: anyone who can write a procedure for a colleague can write one.
The skills that ship with a version live in the addon's own folder. Next to them, a shared
`%ProgramData%\AITOOL\Skills` folder that only administrators write to holds the ones your
organisation adds, and each user has a personal folder that overrides both.
Settings → Skills lists them with the count, an Incluída / Partilhada / Minha pill, the
description and the phrases that trigger each one, and switches them off — switching a shared
skill off affects only you, and only a supervisor gets the button that opens the shared
folder. "Nova skill" asks for a name, creates the folder from the template and opens its
`SKILL.md` in your editor; every card has an "Editar SKILL.md" button, and a file with a
problem (a missing description, a header left open) says so on the card and stays off until
fixed. `/skills` shows them in the chat. A skill's `tools` list guides the assistant; it does
not restrict which tools it may call.

The shipped `prospecao-de-leads` skill runs the whole prospecting flow: a web search for
target companies, a check whether the company already exists, the customer record and a CRM
sales opportunity (each previewed, each saved from its confirmation card) and an e-mail draft
that opens in your mail client for review. Nothing is saved or sent without you. The format
and the rules are in [docs/SKILLS.md](docs/SKILLS.md).

## Find any screen in plain language

Primavera v10 has hundreds of functions spread over modules, navigation contexts and
nested menus, and most people use a dozen of them. The others are the ones you look for
once a quarter and never remember. AITOOL reads the ERP's own ribbon catalogue at startup —
every function, in every navigation context the installation is licensed for — so you can
ask for a screen the way you would ask a colleague: *"open client 0031 and his pending items"*,
*"open the sales explorer"*, *"take me to this supplier's account statement"*. The
assistant finds the function, switches context if it has to, opens it, and when the
ribbon button is visible the cursor glides to it so you learn where it was. When it is
not sure, it lists the candidates instead of guessing.

The same mechanism drives what comes next: once the window is open, the assistant can
list its fields, fill them, move through tabs, read the dialog the ERP throws back and
close the window — on the modern .NET screens and on the legacy VB6 editors alike.

This is also an accessibility angle, stated carefully. Everything the ERP exposes through
menus can be requested in text, which helps people who do not know where a screen lives,
people who find nested ribbons hard to scan, and people who work better by typing than by
pointing. It does not make Primavera a fully accessible application, and voice input is on
the roadmap rather than in the product.

---

## Install once, every workstation gets it

Primavera v10 is typically installed client-server: the ERP lives on a server, and every
workstation reaches the shared `SG100` folder (maps, configuration, extensions) through a
Windows share. AITOOL is an extension in that folder, so the setup runs **once**, on the
machine that holds `SG100`, and every workstation picks the assistant up at its next
start. There is nothing to deploy per seat: a workstation needs only the Microsoft Edge
WebView2 runtime, which Windows 10 and 11 already carry and which the setup checks for and
installs when it is missing.

The setup is a normal Windows wizard that does the ERP-side work by itself: it finds the
Primavera installation, detects multi-instance ERPs, registers the addon in the ERP's
Extensibility screen (common, or per company) and removes that registration on uninstall.
IT departments get a silent mode. We are not aware of another Primavera addon that ships
with a self-registering installer; the details are under
[Install (end users)](#install-end-users), and network notes are in
[INSTALL.md](INSTALL.md).

Each user then opens the assistant from the ribbon and enters their own provider key,
which is stored encrypted per Windows user (DPAPI) and sent only to that provider. A
company that wants to share one key, or run a local model on a server, points the
endpoint there instead.

---

## Architecture

<div align="center">
<img src="docs/assets/turn-flow.svg" alt="Anatomy of a turn: user message, model streaming, tool calls, human confirmation for writes, ERP" width="920">
</div>

The addon is hosted in-process by the ERP. The chat surface is a WebView2 page served from a
virtual host (`https://aitool.local`) with a CSP that allows no CDN — marked, DOMPurify,
highlight.js and Mermaid are vendored with pinned versions and SRI hashes, so rendering works
fully offline. JS and C# talk over `PostWebMessageAsJson` / `ExecuteScriptAsync`, abstracted
behind an `IChatView` interface.

A turn runs through the `ToolCallOrchestrator`: it streams from the active provider, executes
tool calls up to the configured iteration cap (1-15), replays the tool transcript on
continuations, and owns per-turn cancellation. Providers sit behind an `IAiProvider`
abstraction — one implementation for OpenAI-compatible endpoints and a native Anthropic
adapter (`/v1/messages`, thinking with effort levels, prompt caching). Tools implement
`IErpTool`, are marked with `[Tool]`, and are discovered by reflection at startup.

Five projects make up the solution: **AITOOL** (the addon), **OpenAI.SDK** (vendored
Betalgo-based client — streaming and tool calling, no dependency on AITOOL),
**Shared.Config** (unified configuration + telemetry), **ReportEngine** (Crystal Reports
wrapper used for the official document PDFs) and **Installer** (drives the Inno Setup
build). Details in [ARCHITECTURE.md](ARCHITECTURE.md).

---

## Security and trust

Letting a language model near an ERP is a trust problem before it is a features problem.
The guardrails, in the order they matter:

| Guardrail | How it works |
| --- | --- |
| **Writes are gated on a confirmation card** | `create_entity`, `create_article`, `update_entity`, `update_sales_series`, `create_sales_document`, `create_opportunity` and any commit button pressed through `interact_erp_window` are previewed first: the ERP validates the draft and returns the fields and, for documents, the totals it computed. The application renders that preview as a card and, while doing so, issues a single-use authorisation token — valid for 15 minutes and bound to the exact arguments previewed. The commit runs only with that token, which is produced by the user's click on the card and is never shown to the model. A `confirm=true` call without it is refused and recorded in `AI_AuditLog` as a refusal; typing "sim" saves nothing. Saves are single-flight — a second concurrent save is refused. What this is not: a database boundary. It bounds what the model can trigger, not what someone with the SQL connection can do. |
| **Per-user visibility** | Conversations and audit entries are scoped to the ERP user who created them. ERP administrators, super administrators and technicians see a Supervisor badge, `/auditoria todos` and a "Todos os utilizadores" switch on the conversation list; another user's conversation opens read-only, and only its owner can rename or delete it. It is an application control decided in C# from the ERP profile, not a database permission. |
| **Writes go through the ERP's business objects** | Records are created via the Primavera BSO object model, so every ERP validation runs and document numbers are assigned by the ERP. There are no direct writes to ERP core tables. `run_query` is read-only by application guard, not by database permission — it runs on the ERP's own connection, so companies wanting a second barrier should point the addon at a read-only SQL login. |
| **Guarded SQL** | `run_query` accepts only `SELECT`/`WITH`: a blocklist rejects write/DDL/system keywords (`INSERT`, `DROP`, `EXEC`, `xp_*`, `OPENROWSET`, …) after stripping comments, brackets and Unicode homoglyphs to prevent bypasses; statement stacking (`;`) is refused; row counts are bounded server-side. |
| **Untrusted content is spotlighted** | The system prompt pins a rule: text returned by tools (web pages, SQL results, ERP fields) is data to analyze, never instructions to follow. `web_search` results additionally carry `untrusted_content: true` plus an inline warning, and known injection phrasings are flagged to telemetry. |
| **Restrained window automation** | A save, void or delete button pressed through the automation is refused unless the call carries the confirmation card's authorisation; the prompt additionally tells the assistant to fill fields, summarize and stop. One window interaction runs at a time. |
| **Keys encrypted at rest** | API keys (providers and web search) live in a per-user DPAPI-encrypted store (`secrets.dat`), never in plaintext config. Web-search endpoints must be HTTPS and redirects are disabled, so a key cannot leak to a redirect target — the exception is a self-hosted SearXNG on loopback or a private range, which carries no key and accepts plain HTTP only when explicitly allowed. |
| **Telemetry hygiene** | Logs are local (NLog, daily rotation). No Sentry DSN ships; if an operator configures one, RELEASE builds send error-level events, release-health sessions and a 10% trace sample, with API keys, connection-string passwords and user paths redacted before sending and no chat content. Web-search queries are never logged — they can embed names and tax ids. |
| **Off switches** | Each tool toggles individually in settings; `ErpTools:Enabled` turns the whole tool layer off, leaving a plain chat. |

What leaves the machine, what is stored in your database, and what bounds the assistant is
in [docs/SECURITY-AND-PRIVACY.md](docs/SECURITY-AND-PRIVACY.md) — written for the person who
has to approve the install.

### It does not enforce Primavera's per-user permissions

Worth knowing before you deploy it, because it decides who you give it to.

Tools that go through the ERP object model (creating and updating records, opening windows,
printing) act as the logged-in ERP user and hit the ERP's own rules. **Tools that read
through SQL do not** — `search_entities`, `query_documents`, `query_account_balance`,
`analyze_sales`, `check_stock`, `render_document` and `run_query` use the ERP's own database
connection, and Primavera's permissions are enforced by the application, not by the database.
A user who cannot open supplier balances in the ERP can still ask the assistant for them.

Two ways to bound it: disable the tools a given population should not have
(`Assistant:DisabledTools`), or point the addon at a read-only SQL login scoped to the views
you accept. Per-user permission mapping is not implemented and is not planned for v1.

---

## What it costs

The addon is free under the [Community License](LICENSE). There is no subscription, no per-seat licence, no
account to create, and no metering — nothing in AITOOL counts your actions.

What you do pay is your AI provider, directly, at their price. A rough shape rather than a
promise: a typical question that runs two or three tools carries the system prompt plus the
tool schemas, so expect a few thousand input tokens per turn and a few hundred output.
Cheaper models handle the day-to-day lookups; keep the strong ones for the multi-step
document flows. The counter at the bottom of the chat opens the session panel: context
window in use, messages in and out of context, requests, tokens sent and received since the
ERP opened, the cost (OpenRouter reports the billed amount of each request and the panel
shows it as such; otherwise the addon prices the tokens with the provider's published list
or a built-in table for OpenAI and Anthropic), the last requests one by one, and what the
next request will weigh. The context size is the one the provider publishes for the model.
When the model reasons, a chip beside the message box switches the effort (Ctrl+Shift+E):
"Desligado" answers fastest, "Profundo" thinks longer on multi-step requests.
`/compactar` (or the panel's button) has the model summarise the older messages and drops
them from the request; they stay on screen and in the history. Still, watch the first week
on your provider's own dashboard.

Zero marginal cost is available: point it at a local OpenAI-compatible endpoint (LM Studio,
or your company's own inference server) and nothing is billed and nothing leaves the machine.
Below roughly 8B parameters at 4-bit quantization, tool calling stops being reliable — that
is the practical floor, not a supported-model list.

## What it will not do

Deliberate limits, not gaps waiting to be filled:

- **No autonomous workflows.** Tool chains are capped per turn; it does not run unattended.
- **No accounting postings, no deletions, no purchase documents, no article creation.**
  Sales documents, customer/supplier files and CRM sales opportunities are the write
  surface. `draft_email` prepares a message for review and never sends it.
- **No invoice or document intake.** It does not read a PDF invoice and post it. On the
  roadmap, and constrained by Portuguese rules: fiscal documents are issued by AT-certified
  software, never by an assistant.
- **No plugin loading.** Nothing runs inside the ERP process by being dropped in a folder.
- **No Excel or CSV export of result tables.** Conversations export to Markdown, HTML or
  plain text; tables offer copy.
- **Not a replacement for knowing your ERP.** It answers from your data and drives your
  screens; it does not audit your configuration or fix your master data.

The interface is Portuguese (pt-PT). The assistant answers in the language you write in.

---

## Getting started

### How this compares to Cegid Pulse

Cegid ships its own assistant for Primavera. The comparison people ask for, stated from
Cegid's own published material:

| | Cegid Pulse | AITOOL |
| --- | --- | --- |
| Where it runs | A Cegid cloud service, reached over their API — including when your ERP is on-premise | In the ERP process, on your machine |
| Account required | A Cegid Account per user | None |
| Edition | Evolution only | Evolution, Executive and Professional (see requirements) |
| The model | Cegid's | Yours — OpenAI, OpenRouter, Anthropic, any OpenAI-compatible endpoint, or a local one |
| Cost of an action | Token allowance per edition, with paid top-ups | Whatever your provider charges you, directly |

They are not substitutes: Pulse is embedded in ERP workflows by the vendor and supported by
them. AITOOL exists for the case where the answer to "where does my business data go" has to
be "nowhere", and where the choice of model is yours.

### Requirements

- Licensed ERP Primavera v10 (SG100), version 10.20 or later. Evolution and Executive are
  validated; Professional installs on the same rules and is awaiting a customer
  confirmation. Older v10 builds that still embed the Chromium (CefSharp) browser lack the
  WebView2 component the chat runs on, and the setup says so before copying anything
- Microsoft .NET Framework 4.8 (the ERP runs from 4.7.2; the setup installs 4.8 if missing)
- Microsoft Edge WebView2 Runtime, 125 or later recommended (installed by the setup when
  missing)
- SQL Server (the ERP's own instance; also stores chat history)
- An API key for at least one provider (OpenAI, OpenRouter, Anthropic) — or a local
  OpenAI-compatible endpoint such as LM Studio, which needs no key

### Install (end users)

<img src="docs/assets/installer-wizard.png" alt="AITOOL setup wizard" width="200" align="right">

Installation is a normal Windows setup wizard — download, next, next, done. The setup is
not code-signed yet, so Windows SmartScreen shows a warning on first run; the SHA256 in the
release notes is how you check the download. What it does for you, in order:

1. **Finds your Primavera installation** automatically
   (`PERCURSOSGE100`/`PERCURSOSGV100`/`PERCURSOSGP100` → registry → previous install →
   prompt if all else fails), and refuses to run while the ERP client is open.
2. **Checks the workstation before copying anything**: ERP version per edition, the
   WebView2 component of the ERP, DevExpress 21.2, .NET Framework 4.8, the WebView2 Runtime
   (installed automatically when missing) and write access to each destination. Red items
   explain what to fix; the rest warns and continues.
3. **Handles every edition and instance**: each `Config[_instance]\EV`, `\LE` or `\LP`
   folder with its executable is a target, all pre-selected, with an optional
   PRIINSTANCIAS lookup on SQL Server.
4. **Registers AITOOL in the ERP Extensibility screen** for you — as a common extension or
   for specific companies, written to each instance's PRIEMPRE database. No manual ERP
   configuration.
5. **Verifies the result** target by target (file present, MD5 equal to the registered row,
   executable found) and saves a report you can send to support.
6. **Uninstalls cleanly**: the same state is used to remove the registration on uninstall.

For IT departments, silent deployment is supported:
`/VERYSILENT /INSTANCES=ALL /EDITIONS=ALL /SQLSERVER=SRV /REGISTER=COMMON`, or
`/VERYSILENT /DIR="<SG100>\Config\LE\Extensions\AITOOL"`. Manual copy steps are in
[INSTALL.md](INSTALL.md).

On a client-server installation, run it once on the machine that holds `SG100`; workstations
need nothing beyond the WebView2 runtime, which the setup checks for and installs when it is
missing (see
[Install once, every workstation gets it](#install-once-every-workstation-gets-it)).

Then start Primavera, open the assistant from the ribbon, and set the provider, model and
API key in the settings modal. The key is stored encrypted (DPAPI) on that user's profile.
Between the download and the first answer there is nothing else to arrange: no account to
create, no server to stand up, no ERP configuration to edit by hand.

### Build (source licensees)

The source is not public; building it is covered by a separate written agreement — see
[COMMERCIAL.md](COMMERCIAL.md). The legal note that matters to a reader here: compiling
needs no ERP installation, because every Primavera reference resolves from a vendored
`Lib\` folder of compile-time reference assemblies that are never copy-local and never
shipped. At runtime the addon binds to the ERP's own assemblies, so no Primavera binary is
redistributed. A licensed Primavera v10 (SG100) environment is needed only to deploy and
run.

### Build the installer

```powershell
pwsh -File Installer\build-installer.ps1
```

The script stages a Release build locally (never touching the ERP) and writes
`Installer\dist\AITOOL-Setup-<version>.exe` with its SHA256. Parameters, the Visual Studio
route, instance selection, branding and code-signing: [Installer/README.md](Installer/README.md).

---

## Configuration

Everything day-to-day is configured in the settings modal and persisted to a per-user file
(`%LocalAppData%\Cegid\Extensions\AITOOL\appsettings.User.json`) — deploys never overwrite it.
Resolution order: environment variable → user file → `appsettings.{Environment}.json` →
`appsettings.json` → built-in defaults. The environment layer covers `Provider:*`,
`ErpTools:*`, `Sql:*` and `Sentry:*`; the `Assistant:*` settings below are read from the
files only, except the web-search and entity-enrichment keys, which do accept environment
overrides. The variables the code reads are listed family by family in
[docs/CONFIGURATION.md](docs/CONFIGURATION.md).

| Setting | What it controls | Default |
| --- | --- | --- |
| `Provider:Active` | Active provider: `openai`, `openrouter`, `anthropic`, `lmstudio`, `custom` | `openrouter` |
| `Provider:<id>:Model` | Model id per provider (searchable picker with capability badges) | `openai/gpt-5.6-sol` on OpenRouter, `gpt-5.6-sol` on OpenAI direct |
| `Provider:<id>:BaseUrl` | Endpoint, editable for OpenAI-compatible providers | preset |
| `Provider:<id>:ReasoningEffort` | `Off` / `Low` / `Medium` / `High` / `Max` — Desligado, Rápido, Equilibrado, Profundo, Máximo in the interface — where the model supports it. What each level sends is read from the provider's catalogue for that model (`none`, `minimal`, `xhigh`, `max` where they exist), and the choice is remembered per model. Also changed from the chip beside the message box | `Off` |
| API keys | Set in-app; DPAPI-encrypted per user. Env fallbacks: `OPENAI_API_KEY`, `OPENROUTER_API_KEY`, `ANTHROPIC_API_KEY` | — |
| `Assistant:MaxTokens` | Max tokens per response (256-128000) | `4096` |
| `Assistant:Temperature` | 0-2; gated off for reasoning models | `0.7` |
| `Assistant:MaxToolIterations` | Tool-call rounds per turn (1-15) | `15` |
| `Assistant:StreamingEnabled` | Server-sent streaming | on |
| Per-tool toggles | Enable/disable each of the 26 tools (`Assistant:DisabledTools`) | all on |
| `ErpTools:Enabled` | Kill switch for the entire tool layer | on |
| Web search | Providers (`tavily`, `brave`, `serper`, `exa`, self-hosted `searxng`) + keys in the encrypted store; fan-out or fallback mode | `tavily` |
| Fast decisions (Jev) | `Jev:Enabled`, `Jev:Route` (`openrouter` uses the OpenRouter key, `typesafe` its own key in the encrypted store), `Jev:MinConfidence` (0.50-0.95) | off, `openrouter`, `0.60` |
| Custom system prompt | Extra instructions appended to the built-in prompt | empty |
| Theme | Light / dark / system, toggle in the chat header | system |
| Export | Folder, default format (`md`/`html`/`txt`), auto-open | `md` |

---

## Design trade-offs

Choices that look odd from the outside and are deliberate:

- **.NET Framework 4.8.** The addon runs in-process inside the Primavera v10 client, which is
  a .NET Framework host. The runtime is imposed, not chosen — no .NET 5+ APIs anywhere.
- **WinForms + WebView2.** The host is WinForms/DevExpress; rebuilding the shell was never on
  the table. The chat needed a modern surface, so it is a WebView2 page with all rendering
  libraries vendored — no CDN, works offline, and the CSP enforces it.
- **UIA fallback for window automation.** Primavera still ships classic VB6-era editors that
  the .NET object model cannot see. Automation tries the in-process object model first and
  falls back to UI Automation (FlaUI/UIA3) on a dedicated worker thread — slower, but it makes
  native windows scriptable too.
- **No test projects.** Verification is a clean build plus a run inside the ERP. Nearly every
  meaningful behavior depends on a licensed live host — BSO/PSO objects, DevExpress editors,
  WebView2 — so unit tests here would mostly exercise mocks of exactly the parts that break.
  A trade-off, not a virtue.
- **Vendored OpenAI SDK.** A Betalgo-based client lives in-repo (`OpenAI.SDK`) instead of a
  NuGet dependency: it needed .NET Framework 4.8 compatibility, native Anthropic support and
  streaming/tool-calling behavior tuned for this addon, without upstream drift. It stays
  standalone — no reference back to AITOOL.

---

## Beyond Primavera

Today AITOOL is an agent for **ERP Primavera v10 by Cegid** — that focus is why the tools
feel native: they speak BSO objects, ERP series, Portuguese fiscal rules. The architecture
underneath is already split in layers that do not know about Primavera: the provider
abstraction, the chat surface, the tool contract (`IErpTool`), the audit model. The ERP
specifics live behind those seams.

Stated as intent, not as a shipped capability: the direction is to serve **other ERPs**
next, and to become **ERP-agnostic** over time — the same assistant, the same trust model
(on-premise, your AI provider, preview-then-save, audited writes), with the ERP integration
as a pluggable layer. A related step on the same road is speaking
[MCP](https://modelcontextprotocol.io) (Model Context Protocol): the current MCP spec's
Streamable HTTP transport supports stateless servers, which fits this addon's in-process,
per-turn model — an MCP client in AITOOL would let the assistant consume third-party tool
servers beyond the built-in 26 tools. See [ROADMAP.md](ROADMAP.md) for where that sits
relative to everything else.

---

## Roadmap

Where this is going, and what is deliberately out of scope, lives in
[ROADMAP.md](ROADMAP.md). Nearest items: showing the tool calls and SQL behind every answer,
table export to Excel, e-mail attachments, and invoice intake.

---

## Repository layout

<div align="center">
<img src="docs/assets/repo-layout.svg" alt="Repository layout: the AITOOL addon folders (AI, Chat, ERP, Common, UI, Infrastructure), sibling projects (OpenAI.SDK, Shared.Config, ReportEngine) and support folders (Installer, docs, sql, Lib)" width="920">
</div>

---

## Privacy and data handling

- Chat messages **and the ERP data the assistant retrieves for you** (customers, sales,
  stock, balances) are sent to the **AI provider you configure** (OpenAI / OpenRouter /
  Anthropic / your endpoint). Review that provider's data-usage policy. With a local endpoint
  (compatible servers such as LM Studio), nothing leaves the machine.
- API keys are stored **encrypted on your machine** (Windows DPAPI, per user) and sent only
  to the configured provider — never to Bola Labs.
- Writes to the ERP happen only through its business objects: a preview, then a save the
  confirmation card authorises, with every outcome in `AI_AuditLog`; there are no direct
  writes to ERP core tables. No chat content is ever sent to Bola Labs as telemetry.
- Chat history stays in your SQL Server. Logs are local. No Sentry DSN ships; if an operator
  configures one, RELEASE builds send errors, release-health sessions and a 10% trace sample,
  with keys, connection strings and user paths redacted — see [SECURITY.md](SECURITY.md).

---

## Feedback

Issues and Discussions in [BolaLabs/AITOOL](https://github.com/BolaLabs/AITOOL) are where the
product gets better — see [CONTRIBUTING.md](CONTRIBUTING.md) for what to include in a report.
Community standards: [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md). For anything that should not be
public — a deployment, a partnership, a security report — write to <bruno@bolalabs.pt>.

---

## License

[AITOOL Community License](LICENSE) — free of charge for any use, including commercial and
redistribution of the unmodified installer; not open source. The licence covers the Bola Labs
software only: third-party components (Primavera/Cegid SDK, DevExpress, Crystal Reports and others) remain
under their own licenses. No Cegid or SAP binary is redistributed here; the setup does carry
the DevExpress runtime under DevExpress's redistribution terms — see
[THIRD-PARTY-NOTICES.md](THIRD-PARTY-NOTICES.md) and [DISTRIBUTION.md](DISTRIBUTION.md).

PRIMAVERA and Cegid are trademarks of Cegid; AITOOL is not affiliated with, sponsored by or
endorsed by Cegid. The AITOOL name and logo are trademarks — see
[TRADEMARKS.md](TRADEMARKS.md). Source
licences, white-label builds, deployment, supported production use and future premium
features are in [COMMERCIAL.md](COMMERCIAL.md). Brand assets and usage rules live in
[docs/brand](docs/brand/README.md).

Copyright 2025-2026 Bruno Marques — Bola Labs

---

## Documentation

| Resource | Description |
| --- | --- |
| [INSTALL.md](INSTALL.md) | End-user installation |
| [ARCHITECTURE.md](ARCHITECTURE.md) | Data flow, WebView2 integration, packaging |
| [docs/CONFIGURATION.md](docs/CONFIGURATION.md) | Full configuration reference |
| [Installer/README.md](Installer/README.md) | Installer build, detection order, signing |
| [docs/SECURITY-AND-PRIVACY.md](docs/SECURITY-AND-PRIVACY.md) | What an IT approver signs off: what leaves the machine, what is stored, what bounds the assistant |
| [SECURITY.md](SECURITY.md) | Credential storage, data handling, reporting vulnerabilities |
| [DISTRIBUTION.md](DISTRIBUTION.md) | How AITOOL may be distributed (binary vs source) |
| [THIRD-PARTY-NOTICES.md](THIRD-PARTY-NOTICES.md) | Third-party components and licenses |
| [CONTRIBUTING.md](CONTRIBUTING.md) | How to report problems and suggest changes |
| [CHANGELOG.md](CHANGELOG.md) | Release history |

---

<div align="center">

<img src="docs/assets/bolalabs-logo.png" alt="Bola Labs" width="180">

Built by **Bola Labs** for ERP Primavera v10 by Cegid.

[![Website](https://img.shields.io/badge/bolalabs.pt-visit-D9A441)](https://bolalabs.pt)
[![GitHub](https://img.shields.io/badge/GitHub-BolaLabs-181717?logo=github)](https://github.com/BolaLabs)

</div>
