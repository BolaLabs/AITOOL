**English** | [Português](README.pt.md)

<div align="center">

<img src="docs/assets/banner.svg" alt="AITOOL — AI assistant embedded in ERP Primavera v10" width="920">

**An assistant inside PRIMAVERA v10 that runs entirely on machines you control** — no vendor
account, no per-seat licence, no metered credits — with the model you choose, including a
local one. It answers from your business data, opens any ERP screen you describe in plain
language, fills windows, and creates customers and sales documents through the ERP's own
business objects: a preview validated by the ERP first, a save only after you agree, and
every write in an audit trail in your own database.

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
| See what the assistant can actually do | [What it does](#what-it-does) · [The 21 tools](#the-21-tools) |
| Reach a screen I cannot find in the menus | [Find any screen in plain language](#find-any-screen-in-plain-language) |
| Decide whether it is safe to put near my ERP | [Security and trust](#security-and-trust) · [docs/SECURITY-AND-PRIVACY.md](docs/SECURITY-AND-PRIVACY.md) |
| Install it, on one PC or on a whole network | [Install once, every workstation gets it](#install-once-every-workstation-gets-it) · [Install (end users)](#install-end-users) |
| Compare it with Cegid Pulse | [How this compares to Cegid Pulse](#how-this-compares-to-cegid-pulse) |
| Build it from source | [Build (developers)](#build-developers) |
| Know where this is going | [Beyond Primavera](#beyond-primavera) · [ROADMAP.md](ROADMAP.md) |

---

## In plain terms

You open your ERP as always. A new button on the ribbon opens a chat. You ask, in your own
words: *"how much does this customer owe me, and since when?"* — and the assistant answers
from your real data, with the numbers the ERP itself would give you. Ask it to prepare a
proposal and it fills one in, shows you the totals for review, and only saves after you say
so. Every change it makes goes through the same validations the ERP applies to you, and is
recorded in an audit trail in your own database.

Four things make it different from pasting your data into a chatbot:

- **It runs where you decide.** Inside your ERP, on your own machines. There is no Bola
  Labs server in the path, no account to create, and with a local AI model nothing leaves
  the building at all.
- **You choose (and pay) the AI directly.** OpenAI, Anthropic, OpenRouter, any
  OpenAI-compatible endpoint, or a local model through LM Studio — at provider prices, with
  no subscription, no per-seat licence and no metered credits on top.
- **Any screen, by asking.** "Open the supplier account statement", "open the sales
  explorer": it finds the function in the ribbon catalogue and opens it, whichever
  module it lives in. Nobody needs to remember where a screen is.
- **It shows the write before it happens.** Creating or changing records is designed in two
  steps: a preview validated by the ERP itself, then a second confirmed call the assistant
  is instructed to make only after you say so — and every save, refusal and failure lands
  in an audit log you can read from the chat.

The product is free to use, for companies and partners alike. Install it from the setup wizard
([how it works](#install-end-users)), configure an AI key, and it is working in minutes.

---

## What it looks like

<table>
<tr>
<td><img src="docs/assets/screenshot-pendentes-kpi.png" alt="Pending items: KPI cards, filters and the live table, docked beside the ERP" width="300"></td>
<td><img src="docs/assets/screenshot-preview-confirmacao.png" alt="A change to a client record previewed and waiting for the user's confirmation" width="300"></td>
<td><img src="docs/assets/screenshot-auditoria.png" alt="The /auditoria view over AI_AuditLog in the chat" width="300"></td>
</tr>
<tr>
<td><sub>"Dá-me a lista de pendentes desde 2015" — the ERP's own pending-items query, as cards and a live table.</sub></td>
<td><sub>A write is previewed by the ERP first and saved only after "sim".</sub></td>
<td><sub>Every save, refusal and failure lands in <code>AI_AuditLog</code>, in your database.</sub></td>
</tr>
</table>

<img src="docs/assets/screenshot-ficha-ao-lado.jpg" alt="The assistant docked at the right of the Primavera client, with the client record it opened beside it" width="920">

Captured on DEMOV10, the Cegid demo company, with the 2.8.0 build.

---

## What it does

AITOOL is a WinForms extension (.NET Framework 4.8) that embeds a chat assistant into the
Primavera v10 (SG100) client via WebView2. The assistant talks to the model of your choice —
OpenAI, OpenRouter, native Anthropic, or any OpenAI-compatible endpoint, LM Studio included —
and acts on the ERP through 21 auto-discovered tools:

- **Reads real ERP data.** Pending items with the ERP's own query, sales analysis by
  period, client and article, sales and purchase counts per year through guarded SQL, current-account balances with aging, stock per warehouse, document search,
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
  real totals without saving; the save is a second, confirmed call the assistant is
  instructed to make only after you agree in the chat. After a save, a notice tells you
  which open ERP windows are now stale. Every save, refusal and failure is written to
  `AI_AuditLog` in your own database; `/auditoria` in the chat reads it back.
- **Commit buttons need an explicit flag.** The window automation may type into fields
  and press buttons, but a button that commits or destroys data (gravar, guardar, anular,
  apagar, eliminar, remover, confirmar) is refused unless the call carries an explicit
  authorisation flag, which the assistant is instructed to set only after you ask for that
  action. The check runs on the button the ERP actually resolved, not on the caption that
  was asked for. Inside a modal dialog the rule inverts: only a refusal (Cancelar, Não)
  and single-button acknowledgements pass, so answering "Sim" to "Save changes?" needs the
  same authorisation. Every field write, grid write, button click and window close through
  the automation is recorded in `AI_AuditLog` with the user, company, tool, arguments and
  outcome. Ribbon navigation is not audited, and if the audit insert itself fails the ERP
  write still stands (the failure is logged locally). See [SECURITY.md](SECURITY.md) for
  what that boundary is and is not.
- **Documents.** The official PDF of a document, produced by the Crystal report the series
  is configured with — ATCUD and QR code are the ERP's own — opens by itself in a viewer
  card. When the series has no report configured you get an amber warning and a plain
  data sheet instead, never a fake official document.
- **Entity enrichment.** Give it a tax id and the assistant fills the record from public
  registries (VIES, NIF.pt), validates the tax id by country, and shows a field-by-field
  diff before anything is written.
- **Web search.** Five providers — Brave, Exa, Serper, Tavily or a self-hosted SearXNG —
  with your own key, for leads and company data; results are explicitly marked as
  untrusted content.
- **Discovers instead of guessing.** Document types, series (with validity) and article
  prices come from the ERP configuration through dedicated lookup tools.
- **Chat that behaves like a product.** Streaming with phase indicators and a cancel that
  stops the turn in under a second; collapsible thinking blocks; Markdown, Mermaid and
  syntax highlighting rendered fully offline (vendored, pinned, SRI-checked libraries);
  follow-up suggestion chips; conversation history in your SQL Server with search and
  rename; slash commands; light/dark/system themes; keyboard shortcuts (`Ctrl+N` new chat,
  `Ctrl+B` sessions, `Ctrl+,` settings); pop-out window; export to Markdown, HTML or plain
  text. The assistant states that it is an AI system, as AI Act Article 50 requires.

### The 21 tools

| Tool | What it does |
| --- | --- |
| `search_entities` | Searches customers, suppliers and articles by name, code, tax id (NIF) or city |
| `get_entity_details` | Full details of one entity (customer, supplier, article) |
| `get_pending_items` | Pending documents per entity, or across all entities, with date filters |
| `query_account_balance` | Current-account balance for a customer/supplier, with aging buckets |
| `query_documents` | Searches commercial documents by type, entity, date or status |
| `analyze_sales` | Sales analysis by customer, article or period; top-N and period comparison. Scoped by the ERP's own document classification, so credit notes and returns are deducted — the figures are net |
| `check_stock` | Current, minimum and maximum stock of an article per warehouse |
| `render_document` | Header and lines of a commercial document, shown as an interactive card |
| `run_query` | Model-written read-only SQL — `SELECT`/`WITH` only, write/DDL blocked by a guard |
| `open_record` | Opens a record (file, document, account statement) in its native ERP editor |
| `open_erp_function` | Opens any ERP function by name, navigating the ribbon; lists the inventory when unsure |
| `interact_erp_window` | Lists windows and fields, fills fields and grid cells, clicks buttons — .NET and native (VB6) windows |
| `print_document` | Generates the official report PDF of a document, opened in a viewer card |
| `get_sales_document_types` | Lists the sales document types configured in this ERP installation, each with the nature the ERP assigns it (quote, order, delivery note, invoice) |
| `get_sales_series` | Lists the series of a document type, with default and today's validity |
| `get_article_price` | Suggested price/discount from ERP price rules (price lists, customer rules, quantity tiers) |
| `create_entity` | Creates a customer/supplier file via BSO — preview first, then a second confirmed call saves |
| `create_sales_document` | Creates a sales document via BSO — preview with real totals, then confirm to save |
| `update_entity` | Updates fields of an existing customer/supplier file — preview first, then a second confirmed call saves |
| `enrich_entity` | Fills a file from public registries by tax id (VIES, NIF.pt), showing a field-by-field diff before anything is written |
| `web_search` | Public web search (Brave, Tavily, Exa, Serper or a self-hosted SearXNG); read-only, results flagged as untrusted content |

Every tool can be toggled individually in settings; the whole tool layer has a kill switch
(`ErpTools:Enabled` / `AITOOL_ERP_TOOLS_ENABLED`).

A typical end-to-end flow — *"this company emailed us, make them a proposal"*:
`web_search` finds the company → `search_entities` checks if it already exists →
`create_entity` (preview → confirm → save) → `get_sales_document_types` + `get_sales_series`
pick the real proposal type and a valid series → `create_sales_document` (preview with ERP-computed
totals → confirm → save) → `print_document` for the official PDF.

---

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
WebView2 runtime, which Windows 10 and 11 already carry.

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
| **Two-step write protocol** | `create_entity` and `create_sales_document` require `confirm=false` first: the ERP validates the draft and returns a preview (with real totals for documents) without saving. Saving requires a second call with `confirm=true`, which the assistant is instructed to make only after the user explicitly agrees in the chat. Saves are single-flight — a second concurrent save is refused. **This is a model-instruction boundary, not a UI gate**: no code path blocks a commit on a user gesture today, so a model that ignores the instruction can commit in one step. A hard UI confirmation is on the roadmap; the audit trail and the per-tool off switches are what bound the risk meanwhile. |
| **Writes go through the ERP's business objects** | Records are created via the Primavera BSO object model, so every ERP validation runs and document numbers are assigned by the ERP. There are no direct writes to ERP core tables. `run_query` is read-only by application guard, not by database permission — it runs on the ERP's own connection, so companies wanting a second barrier should point the addon at a read-only SQL login. |
| **Guarded SQL** | `run_query` accepts only `SELECT`/`WITH`: a blocklist rejects write/DDL/system keywords (`INSERT`, `DROP`, `EXEC`, `xp_*`, `OPENROWSET`, …) after stripping comments, brackets and Unicode homoglyphs to prevent bypasses; statement stacking (`;`) is refused; row counts are bounded server-side. |
| **Untrusted content is spotlighted** | The system prompt pins a rule: text returned by tools (web pages, SQL results, ERP fields) is data to analyze, never instructions to follow. `web_search` results additionally carry `untrusted_content: true` plus an inline warning, and known injection phrasings are flagged to telemetry. |
| **Restrained window automation** | The automation contract forbids clicking save/void/delete buttons unless the user asked for it in the conversation — the assistant fills fields, summarizes, and stops. One window interaction runs at a time. |
| **Keys encrypted at rest** | API keys (providers and web search) live in a per-user DPAPI-encrypted store (`secrets.dat`), never in plaintext config. Web-search endpoints must be HTTPS and redirects are disabled, so a key cannot leak to a redirect target — the exception is a self-hosted SearXNG on loopback or a private range, which carries no key and accepts plain HTTP only when explicitly allowed. |
| **Telemetry hygiene** | Logs are local (NLog, daily rotation). RELEASE builds send only error-level events to Sentry, with API keys, connection-string passwords and user paths redacted before sending. Web-search queries are never logged — they can embed names and tax ids. |
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
document flows. The per-session token counter is on the roadmap, so today the honest advice
is to watch the first week on your provider's own dashboard.

Zero marginal cost is available: point it at a local OpenAI-compatible endpoint (LM Studio,
or your company's own inference server) and nothing is billed and nothing leaves the machine.
Below roughly 8B parameters at 4-bit quantization, tool calling stops being reliable — that
is the practical floor, not a supported-model list.

## What it will not do

Deliberate limits, not gaps waiting to be filled:

- **No autonomous workflows.** Tool chains are capped per turn; it does not run unattended.
- **No accounting postings, no deletions, no purchase documents, no article creation.**
  Sales documents and customer/supplier files are the write surface.
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
| Edition | Evolution only | Evolution (see requirements) |
| The model | Cegid's | Yours — OpenAI, OpenRouter, Anthropic, any OpenAI-compatible endpoint, or a local one |
| Cost of an action | Token allowance per edition, with paid top-ups | Whatever your provider charges you, directly |

They are not substitutes: Pulse is embedded in ERP workflows by the vendor and supported by
them. AITOOL exists for the case where the answer to "where does my business data go" has to
be "nowhere", and where the choice of model is yours.

### Requirements

- Licensed ERP Primavera v10 (SG100), Evolution edition
- Microsoft Edge WebView2 Runtime
- SQL Server (the ERP's own instance; also stores chat history)
- An API key for at least one provider (OpenAI, OpenRouter, Anthropic) — or a local
  OpenAI-compatible endpoint such as LM Studio, which needs no key

### Install (end users)

<img src="docs/assets/installer-wizard.png" alt="AITOOL setup wizard" width="200" align="right">

Installation is a normal Windows setup wizard — download, next, next, done. The setup is
not code-signed yet, so Windows SmartScreen shows a warning on first run; the SHA256 in the
release notes is how you check the download. What it does for you, in order:

1. **Finds your Primavera installation** automatically
   (`PERCURSOSGE100`/`PERCURSOSGV100` → registry → previous install → prompt if all else
   fails), and refuses to run while the ERP client is open.
2. **Handles multi-instance ERPs**: detects `Config_<instance>` folders, lets you pick one
   or several, with an optional PRIINSTANCIAS lookup on SQL Server.
3. **Registers AITOOL in the ERP Extensibility screen** for you — as a common extension or
   for specific companies, written to each instance's PRIEMPRE database. No manual ERP
   configuration.
4. **Uninstalls cleanly**: the same state is used to remove the registration on uninstall.

For IT departments, silent deployment is supported:
`/VERYSILENT /INSTANCES=ALL /SQLSERVER=SRV /REGISTER=COMMON`, or
`/VERYSILENT /DIR="<SG100>\Config\EV\Extensions\AITOOL"`. Manual copy steps are in
[INSTALL.md](INSTALL.md).

On a client-server installation, run it once on the machine that holds `SG100`; workstations
need nothing beyond the WebView2 runtime (see
[Install once, every workstation gets it](#install-once-every-workstation-gets-it)).

Then start Primavera, open the assistant from the ribbon, and set the provider, model and
API key in the settings modal. The key is stored encrypted (DPAPI) on that user's profile.
First useful answer: under five minutes from download.

### Build (source licensees)

Building needs a licensed Primavera SG100 environment for a full deploy, but compiles anywhere:
all Primavera references resolve from the vendored `Lib\` folder.

```bat
:: two gitignored files unblock the build
type nul > Properties\licenses.licx
copy appsettings.Development.example.json appsettings.Development.json

msbuild AITOOL.sln -restore -p:Configuration=Debug
```

- With the ERP installed, the output deploys straight into
  `<SG100>\Config\EV\Extensions\AITOOL\` (root resolved from the `PERCURSOSGE100`/
  `PERCURSOSGV100` variables; override with `-p:PrimaveraRoot=<path>`; elevation is needed
  when the ERP lives under `C:\Program Files`).
- Without the ERP, the build warns (`AITOOL001`) and falls back to `bin\<Config>\`; use
  `-p:OutDir=<dir>` for an explicit compile-only check.

`Lib\` holds 116 compile-time reference assemblies — the exact transitive closure the
compiler needs, never copy-local, never shipped. At runtime the addon binds to the ERP's
own assemblies. That the vendored `FileVersion` trails an installed service release is
harmless: binding goes by `AssemblyVersion`, which Primavera pins across v10.

```powershell
pwsh -File scripts\checks\Test-LibClosure.ps1        # prove the folder matches the closure
pwsh -File scripts\Update-PrimaveraLibs.ps1          # report version drift, change nothing
pwsh -File scripts\Update-PrimaveraLibs.ps1 -Apply   # refresh from this machine's install
```

Both resolve the installation from the same environment variables the build uses, so
there is nothing to configure. See [`Lib/README.md`](Lib/README.md) for the details and
the licensing note.

### Build the installer

From Visual Studio: pick the **Installer** solution configuration and Build Solution, or
right-click the `Installer` project → **Build** from any configuration (the project is
excluded from Debug/Release builds, so a normal F6 never packages). From the command line:

```powershell
pwsh -File Installer\build-installer.ps1
```

Both run the same script: it compiles the solution in Release to a local staging folder
(never touching the ERP), reads the version from the built `AITOOL.dll`, and compiles the
Inno Setup script into `Installer\dist\AITOOL-Setup-<version>.exe`, printing its SHA256.
Parameters: `-Configuration`, `-IncludePdb`, `-OutputDir`. A `v*` tag triggers the same
build on a self-hosted runner and drafts a GitHub Release
(`.github/workflows/installer.yml`). Details, instance selection, branding and
code-signing notes: [Installer/README.md](Installer/README.md).

---

## Configuration

Everything day-to-day is configured in the settings modal and persisted to a per-user file
(`%LocalAppData%\Cegid\Extensions\AITOOL\appsettings.User.json`) — deploys never overwrite it.
Resolution order: environment variable → user file → `appsettings.{Environment}.json` →
`appsettings.json` → built-in defaults. The environment layer covers `Provider:*`,
`ErpTools:*`, `Sql:*` and `Sentry:*`; the `Assistant:*` settings below are read from the
files only, with the web-search keys as the one exception. Full reference:
[docs/CONFIGURATION.md](docs/CONFIGURATION.md).

| Setting | What it controls | Default |
| --- | --- | --- |
| `Provider:Active` | Active provider: `openai`, `openrouter`, `anthropic`, `lmstudio`, `custom` | detected from base URL |
| `Provider:<id>:Model` | Model id per provider (searchable picker with capability badges) | preset |
| `Provider:<id>:BaseUrl` | Endpoint, editable for OpenAI-compatible providers | preset |
| `Provider:<id>:ReasoningEffort` | `Off` / `Low` / `Medium` / `High` / `Max`, where the model supports it | `Off` |
| API keys | Set in-app; DPAPI-encrypted per user. Env fallbacks: `OPENAI_API_KEY`, `OPENROUTER_API_KEY`, `ANTHROPIC_API_KEY` | — |
| `Assistant:MaxTokens` | Max tokens per response (256-128000) | `4096` |
| `Assistant:Temperature` | 0-2; gated off for reasoning models | `0.7` |
| `Assistant:MaxToolIterations` | Tool-call rounds per turn (1-15) | `15` |
| `Assistant:StreamingEnabled` | Server-sent streaming | on |
| Per-tool toggles | Enable/disable each of the 21 tools (`Assistant:DisabledTools`) | all on |
| `ErpTools:Enabled` | Kill switch for the entire tool layer | on |
| Web search | Providers (`tavily`, `brave`, `serper`, `exa`, self-hosted `searxng`) + keys in the encrypted store; fan-out or fallback mode | `tavily` |
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
servers beyond the built-in 21 tools. See [ROADMAP.md](ROADMAP.md) for where that sits
relative to everything else.

---

## Roadmap

Where this is going, and what is deliberately out of scope, lives in
[ROADMAP.md](ROADMAP.md). Nearest items: a hard UI confirmation gate on writes, showing the
tool calls and SQL behind every answer, invoice intake, and table export.

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
  (LM Studio), nothing leaves the machine.
- API keys are stored **encrypted on your machine** (Windows DPAPI, per user) and sent only
  to the configured provider — never to Bola Labs.
- Writes to the ERP happen only through its business objects, designed as preview then
  confirmed save, with every outcome in `AI_AuditLog`; there are no direct writes to ERP
  core tables. No chat content is ever sent to Bola Labs as telemetry.
- Chat history stays in your SQL Server. Logs are local; in RELEASE, error-level events may
  go to Sentry with keys, connection strings and user paths redacted — see [SECURITY.md](SECURITY.md).

---

## Feedback

Issues and Discussions in [BolaLabs/AITOOL](https://github.com/BolaLabs/AITOOL) are where the
product gets better — see [CONTRIBUTING.md](CONTRIBUTING.md) for what to include in a report.
Community standards: [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md).

---

## License

[AITOOL Community License](LICENSE) — free of charge for any use, including commercial and
redistribution of the unmodified installer; not open source. The licence covers the Bola Labs
software only: third-party components (Primavera/Cegid SDK, DevExpress, Crystal Reports and others) remain
under their own licenses. No Cegid or SAP binary is redistributed here; the setup does carry
the DevExpress runtime under DevExpress's redistribution terms — see
[THIRD-PARTY-NOTICES.md](THIRD-PARTY-NOTICES.md) and [DISTRIBUTION.md](DISTRIBUTION.md).

The AITOOL name and logo are trademarks — see [TRADEMARKS.md](TRADEMARKS.md). Source
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
