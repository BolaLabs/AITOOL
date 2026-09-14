# Changelog

All notable changes to this project are documented here.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and the project uses [Conventional Commits](https://www.conventionalcommits.org/).
Unreleased work is tracked under **Unreleased** until it is tagged.

## [Unreleased]

## [2.12.1] - 2026-09-14

### Added

- The assistant knows who is signed into the ERP. It reads the name, the login and the
  profile of the ERP user (`AdmEngine`/`clsUtilizador`: name, administrator, super
  administrator, technician, profile description) when the company opens, addresses the
  person by their first name, and the message bubble carries that name. The registered
  e-mail address is never put in the system prompt.
- Supervisor view. An administrator, super administrator or technician of the ERP gets a
  "Supervisor" badge in the header, the `/auditoria todos [N]` command and a "Todos os
  utilizadores" switch on the conversation list. Everyone else sees only their own
  conversations and their own audit entries — the audit trail was visible to every user
  before. This is an application control decided in C# from the ERP profile, not a database
  boundary: whoever holds the SQL connection still reads the `AI_*` tables.
- A confirmation card with a hard gate on every write. `create_entity`, `update_entity`,
  `create_sales_document`, `create_opportunity` and a commit button pressed through
  `interact_erp_window` render a card built in C# from the ERP's own preview — fields,
  warnings and, on documents, the totals the ERP computed. The commit runs only with a
  single-use token the application issues while drawing that card, valid for 15 minutes and
  bound to the exact arguments previewed. The model never sees the token, so a `confirm=true`
  call on its own is refused and lands in `AI_AuditLog` as
  `Recusou (sem confirmação no cartão)`, with the pending card highlighted again. Typing
  "sim" no longer saves anything.
- The assistant does not claim an ERP action it did not perform. When an answer says it
  opened, created or saved something in a turn where no tool ran, the reply gains a note —
  "Nenhuma ação foi executada no ERP neste turno." — and the log a warning. The answer
  itself is not rewritten.
- The change card puts the current value beside the new one for every field `update_entity`
  touches, read off the ficha before anything is applied.

### Fixed

- The user name in the Crystal formulas (`PRI_NomeUtilizador`) came out empty on the
  official document PDFs.
- Reloading skills (`/skills recarregar`, Settings → Skills) rebuilds the system prompt of the
  open conversation; a new skill no longer waited for a new chat.
- OpenAI-compatible providers keep a 10-minute ceiling on the HTTP client, so the configurable
  inactivity timeout is what decides when a stalled request is repeated.
- Remaining strings in pt-PT with accents; gold accent text meets contrast in the light theme.
- The reasoning block opens and closes from the keyboard; the slash-command palette announces
  its items and the selection to screen readers.
- The confirmation token is matched to the arguments by value and not by the raw JSON: an
  accent written literally or escaped, or the keys written in another order, no longer
  breaks the match between the card and the commit.
- A commit the ERP refused reissues the card's token, so Confirmar can be pressed again
  instead of reaching a gate that no longer holds an authorisation.
- Skill descriptions and trigger phrases are bounded in the system prompt, so a long
  `SKILL.md` header cannot crowd out the rules.
- The footer showed a four-part version; a cancelled turn raised two toasts; system messages
  carried emojis.
- The turn that follows a confirmed card no longer gains the "Nenhuma ação foi executada"
  note: that turn runs no tool by design.
- Answering an ERP dialog ("Sim", "OK") or a save button that only resolved inside the
  automation reaches the same confirmation card; the model was told to ask for
  `confirm=true`, which the gate then refused.
- A supervisor opening another user's conversation sees it read-only: nothing they write
  lands in that user's history, and delete and rename are refused on conversations that are
  not theirs. `/auditoria` without a known login shows nothing instead of everything.
- A commit whose outcome the ERP could not confirm closes the card instead of offering a
  second Confirmar; a failure inside the commit resolves the card instead of leaving it on
  "A gravar…".
- The theme button switches on the first click; starting from "sistema" it used to apply the
  theme already on screen.
- The PDF card's "Mais" menu opens anchored to its button and closes on scroll or resize,
  instead of drifting away from it.

### Changed

- The installer creates an empty `%ProgramData%\AITOOL\Skills` and resets its ACL on every
  run, so only SYSTEM and administrators can write there. The skills that ship with the addon
  (`prospecao-de-leads`, `_modelo`) stay in the addon's own `Skills` folder and are no longer
  copied there; the copies 2.12.0 left in the shared folder are removed on upgrade, and
  precedence user > shared > shipped is unchanged.
- A fresh install starts on OpenRouter with `openai/gpt-5.6-sol` (1M of context; the same
  model is `gpt-5.6-sol` on OpenAI direct), changeable in Settings as before. An unknown
  model, one the provider's catalogue does not describe, is assumed to hold 128k.
- Reasoning effort reads Desligado / Rápido / Equilibrado / Profundo / Máximo, and what each
  one sends is decided from the provider's catalogue for that model (`none`, `minimal`,
  `xhigh` or `max` where they are supported) instead of guessing from the model name. The
  choice is remembered per model, so switching models and back restores it.
- Settings → Skills redesigned: a count, an Incluída / Partilhada / Minha pill per skill,
  the description and the phrases that trigger it, and an "Abrir pasta partilhada" button
  that only a supervisor sees. Switching a shared skill off affects only the user who did it.
- A skill's `tools` list guides the assistant; it does not restrict the tools it may call.
- The RELEASE log records every tool that ran, with its duration and its outcome, and every
  request with the model and the reasoning effort. Names, timings and outcomes only — never
  arguments, prompts or keys. A tool that answers `success: false` is an error in that line
  and not an "ok": an ERP refusal used to be recorded as a completed call.
- `create_entity` proposes a code from the name when the user gives none — accents stripped,
  uppercased, cut at the 12 characters the ERP column holds — and shows it on the preview
  card. A code longer than the column is refused before the BSO, which used to truncate it in
  silence.
- Reasoning is asked of OpenRouter as a `reasoning: {effort}` object and read back from
  `delta.reasoning`; the OpenAI-style `reasoning_effort` had OpenRouter billing the thinking
  tokens without ever returning them. When a provider bills reasoning and returns no text,
  the block reads the effort and the time to the first token ("Profundo · 4 s") instead of
  staying empty.
- An installation that only ever had an OpenAI key stays on OpenAI: the active provider is
  deduced from the key that is configured, and the new OpenRouter default applies only where
  nothing is set.
- The PDF card leads with Ver, Imprimir and Guardar como…, with the rest of the actions under
  Mais.
- The Word, Excel and CSV exporters were removed with the packages behind them (Xceed DocX,
  under a non-commercial licence, and MiniExcel); none of the three was ever reachable from
  the UI. Conversations still export to Markdown, HTML and plain text.

### Security

- A tool switched off in Settings is refused at execution, not only left out of the list sent
  to the model.
- The "open file" action from the chat only opens files under the addon's own documents
  folder (`%TEMP%\AITOOL_Docs`); any other path is refused.
- Only the card's token authorises a commit; the card id, which the page carries, no longer
  counts as a credential. Assistant text is no longer attached to telemetry events.
- `run_query` refuses the `AI_*` tables; the assistant's own records are read through
  `/auditoria`.
- The chat page's CSP no longer allows images or connections to external hosts (the page's
  own origin only), and `data:` navigation is removed.
- The API key no longer appears in the Debug log (`updateApiKey` messages).

## [2.12.0] - 2026-09-02

### Added

- Reasoning effort one click from the message: a chip beside the token counter (visible when
  the model reasons) opens Desl./Baixo/Médio/Alto/Máx.; Ctrl+Shift+E opens it from the
  keyboard. It is the same setting the header popover and Settings carry.
- Billed costs: OpenRouter reports the amount it charged for each request and the session
  panel shows it without the "~" ("Custo faturado"); other providers keep the priced estimate.
  Cached input tokens are recorded per request.

### Fixed

- The header and the session panel disagreed on the context size (the header read the
  provider's catalogue, the panel the built-in table: "1.1M" against "400K"). Both now use the
  catalogue, and the panel refreshes when the list arrives or the model changes.
- Tool rounds showed "0 received" in the last requests: streams now ask OpenAI and OpenRouter
  for the final usage chunk, and the local estimate counts the tool-call arguments when a
  provider sends no usage.

## [2.11.1] - 2026-09-01

### Fixed

- A confirmed `create_opportunity` is never retried automatically: it now sits with the other
  ERP writes in the retry policy, so an ERP timeout on save cannot produce two opportunities.
- Web-search source cards and the VIES enrichment card survive the streaming re-render;
  they were dropped by the first text that followed the tool.
- Query results: years, document numbers, codes and any integer under 10 000 print without a
  thousands separator ("2024", not "2.024").
- Opening Settings no longer places the caret in the API key with the value selected; a stray
  keystroke could replace a working key.
- Escape closed Settings twice, re-sending the provider selection.
- Automation step cards stayed where they were streamed instead of jumping above the text.
- The thinking block kept "A pensar…" when reasoning interleaved with tool calls.
- Links pasted in a user message are readable on the navy bubble.
- Memory cards no longer offer "Regenerar".
- Skills tab: a timeout message instead of an endless "A carregar…".
- Web-search cards only follow http(s) links and no longer fetch favicons from a third party.
- Session pill and panel write costs the same way; HTML escaping covers quotes in attributes.
- Reasoning "Desl." on a gpt-5 model now sends `reasoning_effort: minimal`. Sending nothing
  left the model at its default medium effort, and OpenRouter streams nothing while it
  thinks, which over the full 24-tool request showed up as a 100 s silent stall.
- The memory card ends with a line telling the model to answer from the recalled facts
  before querying the ERP again.
- A model call that has produced nothing after 30 s is sent again once, with a toast; the
  same request answered in two seconds on retry every time the stall was seen.
- Escape closes Settings whatever has focus inside it.
- Text on the user bubble is white in the dark theme too.

### Changed

- Amber is a fill colour; where the accent carries text (estimated cost, "Rascunho" badge)
  it uses a darker ink shade that meets contrast.
- Keyboard focus reveals message actions and draws a ring on chips, toggles and sessions.
- Slash-command palette: one icon per command.
- Accents in the remaining Settings and session labels (Raciocínio, Visão, Compatível, Este
  mês, Sem título, Módulo, Série, N.º Doc); "A ligar" instead of "A conectar".
- `/ajuda` lists what the assistant can do today, writes and skills included.
- Docs: 24 tools everywhere, the write surface names CRM opportunities and the e-mail draft,
  SKILLS.md documents the three folders, the template rule and the disabled list, README
  anchors fixed.

## [2.11.0] - 2026-08-30

### Added

- Skills: a folder with a `SKILL.md` teaches the assistant a workflow — a description it
  reads to know when the skill applies, and the steps to follow with the tools it already
  has. Shared folder (`%ProgramData%\AITOOL\Skills`) and per-user
  folder; Settings → Skills lists and switches them; `/skills` in the chat; `use_skill` tool.
  A skill never dispenses with the two-step confirmation of a save. See docs/SKILLS.md.
- `prospecao-de-leads`, the first shipped skill: web search for target companies, existing-
  customer check, customer record and CRM sales opportunity in two steps each, and an e-mail
  draft for review.
- `create_opportunity`: creates a CRM sales opportunity for an existing customer through the
  BSO, preview first, audited on save.
- `draft_email`: prepares an e-mail (to, subject, body) as a card with "Abrir no e-mail" and
  "Copiar"; nothing is sent.

## [2.10.0] - 2026-08-30

### Changed

- Query results read like a report: column names become words ("TOTALPENDENTE" is "Total
  pendente", the SQL alias stays in the tooltip), ISO dates print as dd/mm/yyyy, negatives are
  red, headers stay put while scrolling, the footer states rows and columns and whether the
  result was capped, and a one-number answer is shown as a figure with its label instead of
  a one-cell grid. The filter box appears from six rows.
- Each tool step shows how long it took and how many rows came back.
- The compaction summary is a "Memória da conversa" card: how many messages it replaced,
  when, one line on why it exists, and the summary itself, collapsible.
- The model chip in the header shows the live context use ("2% · 400K").

### Fixed

- A question whose turn timed out, was cancelled or failed stayed in the request, so the next
  message was answered together with the old one (the model would open the record the
  earlier, abandoned question asked for). It now leaves the context; "Tentar novamente" brings
  it back. Nothing is removed from the screen or the history.

## [2.9.0] - 2026-08-29

### Added

- Session panel behind the token counter: context window in use, messages in and out of
  context, and since the ERP opened the number of requests, tokens sent and received, the
  estimated cost, a per-model breakdown when more than one model answered, and the last
  requests one by one. Costs are priced per request with the model that answered it, so
  switching models keeps the total honest. A toast suggests compacting at 80% of the context.
- Prices: OpenRouter's published per-model prices are read from its models endpoint (fetched
  once in the background when the chat opens, and whenever the model list loads), the static
  table gains the Anthropic models and matches ids with a provider prefix such as
  `openai/gpt-5-mini`, which until now showed "no price".
- `/compactar` (and the panel's button): the model summarises the older messages into one
  note and they leave the request; nothing is deleted from the screen or the history. The
  last two exchanges always stay verbatim.

### Fixed

- The context window kept the "first message must be the user's" rule even when nothing was
  being truncated, which silently dropped a message that opened the conversation with the
  assistant (the compaction summary). The rule now only moves a window that is already
  cutting; for Anthropic, a neutral user turn is placed in front instead.

### Changed

- The message box is one card: the text on top, a rail underneath with the options button,
  the AI notice or the shortcut hint, the token counter and a round send button that turns
  into the stop button while a reply streams.
- Every user-facing string is written in accented Portuguese: toasts, the `/ajuda` and
  `/auditoria` output, table headers, settings labels and the tool descriptions and results
  the model relays. Error toasts no longer carry the raw exception text; the detail stays
  in the log.
- Icon-only buttons (conversations, settings, show/hide key, toast close) carry accessible
  names, and the key toggle reports its state.
- Front-end diagnostics go through the debug gate instead of the browser console, so a
  customer opening DevTools sees nothing but their own page.

## [2.8.3] - 2026-08-28

### Fixed

- The print dialog opened from the PDF card (and Ctrl+P in the viewer) previewed a blank
  page: it printed the page hosting the PDF plugin. The viewer now asks Chromium's PDF
  viewer to print the document, and the preview shows the invoice.

## [2.8.2] - 2026-08-27

### Added

- Imprimir on the PDF card: the viewer opens with Chromium's print dialog over the official
  document; Ctrl+P inside the viewer does the same. The one-sentence-to-paper flow closes.
- The AI_* schema upgrades itself: a table created by an older AI_Schema.sql, or trimmed by
  an administrator, gains the columns the current build writes (idempotent, both in the
  runtime bootstrap and in the script).

### Fixed

- The PDF viewer failed to open ("Erro ao abrir o visualizador de PDF", 0x8007139F) after the
  device-scale fix below: it created a second WebView2 environment on the chat's user data
  folder with different browser arguments. Every WebView2 in the addon now shares one
  environment.
- On a monitor scaled above 100% the chat clipped text at its right edge and could not
  scroll to the last line: the ERP client is DPI-unaware and works in virtual 96-DPI
  coordinates while Chromium sized the page for the physical DPI. The browser now uses one
  device scale factor when the host process is DPI-unaware.
- A UIA walk cancelled by the user stops at its next node instead of running out the rest
  of its four-second budget on the retired worker; the log says "replaced after
  cancellation" at Info, keeping the Warning for the timeout case it was written for.

## [2.8.1] - 2026-08-21

### Fixed

- A conversation started from the sidebar's "Nova conversa" button, or left behind after
  deleting the current one, ran without the system prompt — no ERP rules, no tool guidance,
  no date — until the ERP was restarted. Both paths now reset the way `/novo` does.
- The chat resources (markdown, sanitiser, syntax highlighting, diagrams) are found in the
  installed folder when the ERP's shadow copy carries only the DLLs; until now that start fell
  back to the embedded page and rendered plain text.
- `open_record` waits up to 90 s for the ERP window (was 45 s) and logs at 30 s that the ERP
  is slow; on a slow SQL server a plain client record took 51 s and was reported as a failure
  one poll before it appeared.
- The session cost in the footer is priced at the active provider's model, and hidden when
  that model has no pricing row.

### Changed

- The dock panel is named after the product; provider, model and context stay in the chat
  header. Its default width follows the screen (600-860 px) so the KPI cards fit in one row.
- Refusals of irreversible actions name what the action touches (balances, account, fiscal
  maps, stock) instead of asking a bare "are you sure?".

- `close_all_windows` now also closes the PDF viewer the assistant opened and the legacy
  VB6 editors, which are native top-level windows rather than forms; it still stops at the
  first window that raises a save prompt.

## [2.8.0] - 2026-08-21

### Fixed

- The first request after a long tool call or a pause stalled about 20 seconds before the
  single retry rescued it: a pooled keep-alive socket was reused after the provider had
  closed it. Every provider request now closes its connection.

### Changed

- Licence: the product ships under the AITOOL Community License (free of charge, binary
  only, unmodified redistribution allowed) instead of MIT. The source repository is private;
  the public repository carries documentation, releases and the issue tracker.
- The installer shows the licence; the setup is not code-signed and the docs now say so
  next to the download.
- Documentation corrected where it overstated the code: no print button on the PDF card,
  RELEASE logs at Info level, Sentry sessions and traces, the favicon host on web-search
  cards, `Shared.Config.dll` in the loose-file list, the Betalgo notice for the vendored SDK.

### Added

- The assistant states that it is one. The welcome screen says so in full, and the line
  under the message box says so for the rest of the session — a returning conversation
  never shows a welcome screen, so a first-interaction-only notice would leave most
  sessions unmarked. AI Act Article 50 has applied since 2 August 2026.
- `.github/FUNDING.yml`, so the repository carries the same sponsorship links as the rest of
  the BolaLabs products.

- The assistant is told today's date. It is stamped onto the system message when each request
  is built, not when the prompt is stored, so a window left open past midnight does not carry
  yesterday's date; the block also resolves the common windows (this month, last year, last 30
  days) so relative questions never depend on the model's own arithmetic. Without it, "what did
  we sell this year" was answered against whatever year the model's training data suggested.
- Rules for reading documents by their business name. `TipoDoc` codes are per-installation, so
  "orçamentos"/"propostas" now get resolved before any query runs, and the answer names the
  codes it used. An empty result is treated as a suspect filter to verify, not as proof that no
  such documents exist.
- `get_sales_document_types` now returns each type's **nature** — the ERP's own classification
  in `DocumentosVenda.TipoDocumento` (request for quote, quote/proposal, order, delivery note,
  invoice) — instead of leaving the model to infer meaning from a free-text description. It was
  already being read and then dropped. On the demo company, matching by nature finds three quote
  types where matching the word "orçamento" finds one: "Fatura Pró-Forma" and "Cotação base de
  Avenças" are both quotes, and neither contains the word.
- Golden set section 8, covering exactly those three failures — relative dates, business
  vocabulary, and empty results reported as absence.
- Portuguese mirrors of the three documents non-developers read: `README.pt.md`,
  `INSTALL.pt.md` and `docs/SECURITY-AND-PRIVACY.pt.md`, with a language switcher at the
  top of each pair. English stays canonical; everything else remains English-only.
- `scripts/checks/Test-DocsSync.ps1` fails the release build when a Portuguese mirror lags
  its English original, so translations can drift during development but never in a tagged
  release. `Installer/build-installer.ps1` runs it automatically (`-SkipDocsSync` opts out).
- `docs/brand/index.html` — visual brand specification (symbol at every size, ribbon
  preview in both themes, palette, wordmark, variants, misuse examples). It loads the real
  SVGs from the repository, so it doubles as a smoke test for the brand assets.
- Portuguese OpenGraph card (`png/og-1200x630.pt.png`) alongside the English one.

### Fixed

- `analyze_sales` overstated every total, ranking and margin it produced. It scoped sales with
  a hardcoded list of document codes (`FA`, `FT`, `FR`, `FS`, `VD`) — codes are configured per
  installation, so it both missed an installation's own invoice types and, more seriously,
  never subtracted credit notes and returns. It now scopes by the ERP's own classification
  (`DocumentosVenda.TipoDocumento = 4`), which includes them; the ERP stores them with negative
  amounts, so they deduct themselves. On the demo company the difference is 701.896,25 gross
  against 683.480,99 net, and two customers whose credit notes exceed their invoices move from
  positive to negative — one of them did not appear in the ranking at all. The result now
  carries the scope it used so the answer can say the figures are net.
- SQL results dropped a column whenever two columns shared a name. SQL Server returns an empty
  name for every unaliased expression, so `SELECT COUNT(*), SUM(Total)` and a join selecting
  `c.Nome` alongside `cl.Nome` both collapsed onto one dictionary key and the earlier column
  vanished from the answer without any error. Column names are now resolved once per result
  set and disambiguated, and `run_query`'s interactive table binds to the same resolution.
- `run_query` turned an unaliased calculated column into SQL error 8155 naming `_q`, the
  internal row-bounding wrapper — a name the model has never seen and cannot act on. It now
  gets told to alias the expression instead.
- The wordmark SVGs clipped their own tagline: the text extended past the 420-unit viewBox,
  so "ERP PRIMAVERA" rendered as "ERP PRIMA". Widened to 500 units, which also leaves room
  for the Arial fallback where Segoe UI is absent.
- The English OpenGraph card is now the default `og-1200x630.png` (it fronts an
  English-canonical repository) and no longer addresses the reader informally.

### Changed

- Dependency refresh since 2.6.0, previously unrecorded: MiniExcel 1.45.0, NLog 6.1.4,
  Sentry / Sentry.NLog 6.7.0, Microsoft.Extensions.* and System.Text.Json 10.0.10.
- `ReportEngine/Lib/` dropped the nine design-time, ASP.NET and WPF assemblies that no
  reference resolved, and gained a README stating what the remaining eighteen are for.
  Nothing resolved from that folder before or after: Crystal comes from the GAC.

## [2.7.0] - 2026-08-09

### Added

- New visual identity: the A·i monogram (navy `#1E3A5F` + gold `#D9A441`, the palette the
  chat UI already uses) replaces the stock "GROW" logo across the product — window icon,
  ribbon, splash, installer wizard, multi-resolution `.ico` files and docs banner.
- Brand guide and media kit in `docs/brand/` (SVG masters, PNG exports, usage rules,
  OpenGraph image). Product and installer assets are regenerated from these masters;
  `make-branding.ps1` now builds the installer branding from them.
- README restructured for both technical and non-technical readers: plain-terms intro,
  navigation table, installer walkthrough with wizard preview, and a "Beyond Primavera"
  section stating the multi-ERP / ERP-agnostic direction.
- Roadmap: "Further out" section — pluggable ERP integrations and an MCP client
  (Streamable HTTP, stateless) as future direction.

### Changed

- Official website is now `https://bolalabs.pt` — updated in the ribbon link, installer
  metadata (`MyAppURL`/`MyAppContact`) and docs.
- Docs diagrams and README badges realigned from the old green accent to the brand gold.

## [2.6.2] - 2026-08-05

### Fixed

- Toasts now fade out (the exit transition was missing) and render as neutral cards with a
  colored status edge, readable in dark mode.
- Tool errors written for the model ("NÃO repitas", timeout wording) no longer reach user
  toasts: tools return a separate `user_message` and the action handler shows only that.
- Sticky table headers actually pin while scrolling result tables: tables switched from
  `border-collapse: collapse` (Chromium does not stick `th` in collapsed tables) to
  `separate`, and result tables scroll inside their own container.
- "Dá-me a lista de pendentes" now routes to `get_pending_items` (KPI cards, ERP-parity
  filters) instead of a raw `run_query`.

### Changed

- Dark theme: entity/doc-type/status badges and context chips use translucent tints instead
  of light pastel fills.
- Context menus, mention dropdown, model picker and command palette share one 90 ms open
  animation with reduced-motion support; hover states unified on theme tokens.
- Rows acknowledge a context-menu action immediately (dimmed while the ERP works).
- pt-PT copy pass: settings pane and toasts fully accented, "provedor" replaced by
  "fornecedor", technical jargon removed from user-facing errors.

## [2.6.1] - 2026-08-03

### Fixed

- Opening a CCT exploration (pendentes, extrato de conta corrente) no longer hangs for 45 s
  when the assistant is docked and the chat has keyboard focus: the drill-down now moves
  focus from the WebView2 to the ERP's MDI client before firing, because the MDI activation
  handshake waits on the focused Chromium window and never completes
  (docs/ERP-AUTOMATION-FACTS.md).

## [2.6.0] - 2026-07-29

First tagged release. Everything below was previously tracked under Unreleased.

### Added

- Country-aware tax-number validation: the entity's country decides which rules apply, the
  Portuguese check digit no longer rejects correct foreign VAT numbers, VIES is queried
  against the entity's own member state, and the country code itself is validated against the
  company's `Paises` table with an actionable message.
- `enrich_entity` accepts a `country` argument; `create_entity`/`update_entity` guidance
  covers foreign entities and the undifferentiated taxpayer (`999999990`).
- Golden-set coverage for enrichment (tools 20-21) and foreign entities
  (`scripts/e2e/golden-set.md` sections 6 and 7), plus a project `ROADMAP.md`.
- Multi-provider AI (OpenAI, OpenRouter, native Anthropic, any OpenAI-compatible endpoint) with
  streaming, reasoning models, per-provider persisted settings and DPAPI-protected API keys.
- Official ERP document PDFs: sales, purchases, settlements and current-account documents print
  the real Primavera report (Crystal formula context, company header, certification signature,
  QR code) with automatic viewer opening; data-PDF fallback for series without a configured map.
- Structured chat renderers: pending items with KPI split by entity kind and clickable filters,
  entity lists, paginated query results, document cards — plus friendly empty states.
- Chat UX: command palette (`/`), `@` entity mentions, live context picker of open ERP windows,
  token pill with draft estimate, inline session rename, session previews, dark/light/system theme.
- Fully offline chat UI: the page is served from a local WebView2 virtual host and marked,
  DOMPurify, highlight.js and Mermaid are vendored with pinned versions and SRI hashes.
- Dependabot configuration for NuGet updates and repository governance
  (`CODEOWNERS`, pull request template, issue forms).
- This changelog.

### Changed

- Default `Assistant:MaxToolIterations` raised from 5 to 15: real chains observed in live
  validation (open, inspect, preview, confirm; search, enrich, create, print) regularly need
  six to ten rounds, and the old cap surfaced as a hard mid-flow error.
- `update_entity` now runs the ERP's own `ValidaActualizacao` during preview, so a save the
  ERP would refuse is refused before the user is asked to confirm it (parity with
  `create_entity`).
- Assistant guidance: once the user confirms a preview the write commits immediately (no
  repeated previews), and series report-map questions resolve via one query over
  `SeriesVendas` instead of window navigation.
- The AI turn loop (streaming, tool execution, transcript replay, cancellation) moved from
  `ChatAIViewModel` into a dedicated `ToolCallOrchestrator` service, unchanged in behavior.
- Dependency refresh: DocX 5.2.0, MiniExcel 1.44.1, PDFsharp 6.2.4, NLog 6.1.3, Sentry 6.6.0,
  Microsoft.Extensions 10.0.9, Dapper 2.1.79, Costura.Fody 6.2.0 (which now removes loose
  copies of embedded assemblies from the output — deploys must mirror the full build folder).

### Security

- Purged a committed strong-name key and legacy branding assets (`ReportEngine/*.snk`,
  `ReportEngine/*.ico`) from the entire git history (2026-07-18 rewrite; clones made before
  that date must be re-cloned). Assembly signing remains disabled; treat the old key as
  compromised. `.gitignore` excludes `*.snk`, `*.pem`, `*.p12`, `*.key`, `*.crt`, `*.cer`.
- Chat CSP no longer allows any CDN host; all scripts are local with enforced SRI.

### Fixed

- Opening a record that does not exist no longer reports success: the ERP's warning box was
  being counted as the record window. The warning text is now read, surfaced as the tool's
  error, and the box is closed automatically — including the successive warnings each failed
  drill-down route raises while the SDK call winds down, which previously stacked up and
  swallowed every later click.
- Synced the latest security and stability fixes that post-dated the Azure DevOps -> GitHub
  migration (telemetry sanitization, ERP backup/rollback hardening, path-traversal protection,
  WebView2 message hardening, thread safety, disposal/leak fixes, SQL safety, PDF export).
- Pending-items parity with the ERP "Consulta de Pendentes" (dynamic account/state filter),
  stratified truncation so entity-kind filters never show an empty table, and PdfSharp font
  resolution under the Primavera host.
