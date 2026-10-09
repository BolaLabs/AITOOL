# Changelog

All notable changes to this project are documented here.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and the project uses [Conventional Commits](https://www.conventionalcommits.org/).
Unreleased work is tracked under **Unreleased** until it is tagged.

## [Unreleased]

## [2.16.0] - 2026-10-09

### Added

- The assistant knows what is open in the ERP. Each message carries the client, supplier and
  article records open at that moment (code and name) and the title of the active window,
  so "este cliente", "esta ficha" or "os pendentes daqui" need no code. The block is built
  when the message is sent and kept with it, so a replayed conversation sends the same text
  and the prompt cache holds; it is never stored or shown in the chat.
- The chat header shows what the assistant sees: the active record (`CLI 0031 · name`, `+N`
  for the others), the active window's title, or "Sem janelas abertas". Its popover lists
  everything that goes with the next message and has the switch "Partilhar as janelas
  abertas" (`Assistant:ShareOpenWindows`, on by default); with it off nothing about the ERP
  windows leaves the machine.

### Changed

- `@` and a name now puts the entity into the message as text (`cliente SOFRIO (Sofrio,
  Lda)`), so what the user sees is what the model gets.
- The "Assistente AI" button on client, supplier and article records opens or brings the
  chat forward without asking; the record is already in the context. On the F4 lists the
  button is "Assistente AI" with the AITOOL logo, at the end of the bar, instead of a
  "Selecionar" with a check mark that looked like the selection button other extensions
  add and only opened the chat.
- An empty code no longer falls back to an implicit entity: `get_pending_items` with no
  code returns every entity's pending items, `query_account_balance` and `open_record` ask
  for the code, and `get_entity_details` reads the records open in the ERP. With the context
  automatic, an empty code would otherwise have meant whichever record happened to be open.

### Removed

- The "Adicionar contexto" picker, its entity chips and the hidden context lookup of the
  chat window. A pick never reached the model when the chat was opened from the ribbon, a
  reset brought back the record's entity instead of the one picked, and removing one chip
  cleared them all.

### Fixed

- Opening a function by its full path (`Geral → Documentos Internos`) failed whenever other
  catalogue entries ended in the same name: every path segment scored the same on all of
  them and the tie was reported as ambiguous, even for the exact path the tool had just
  proposed. A vague request ("editor de internos") then took four to six round trips to the
  model. An exact path now wins, and `>` is accepted as a separator.
- The toolbar buttons were one shared item per kind, linked into every open list or
  record: with two lists open, closing one left the other's button dead, the item kept a
  forced `Id = 0` that collided with the host's own items, and a close handler was added on
  every window activation. Each window now gets its own item, created in its own bar
  manager, which goes away with the window.
- Pending items lost the entity's name column: the name lookup aliased its key `Código`
  (accented in the 2.12 wording pass) and read `Codigo`, so it failed on every call and the
  list showed codes only.

## [2.15.1] - 2026-10-07

### Fixed

- OpenAI's newer models on `/chat/completions` (gpt-5.6, gpt-6) refused every turn: they take
  `max_completion_tokens` instead of `max_tokens`, spell the lowest reasoning effort `none`
  instead of `minimal`, and accept function tools only with reasoning off. The request now
  follows those rules for that generation, and any other 400 that names a parameter
  ("Unsupported parameter", "Unsupported value", "set reasoning_effort to …") is learned
  for the model and the request is sent once more with the correction; the chat never shows
  the first refusal. The log carries `Request adapted for <model>: …` when that happens.
- The settings tabs wrap to a second row when the panel is narrow; with the assistant docked
  at 600 px, "Avançado" was behind a scrollbar that was not drawn.
- Saving Max tokens at 0 (or anything outside 256–128 000) closed the modal on "saved" and
  kept the old value. The modal now stays open on the field with the range; an empty field
  goes back to the default 4096. Same check for the tool steps (1–15).
- "Testar ligação" tests the model typed in the field, saved or not, and says so in its
  verdict; it used to test the saved one, so a wrong model looked fine until Guardar. The
  previous verdict no longer shows when the modal is reopened, and clears as soon as the
  model is edited; the model suggestion list closes when the pointer leaves the field, so
  it no longer sits over the test button.
- The log file could stop at company open and stay silent for the whole session. The
  addon only installed its NLog target when nothing else had configured NLog; when the
  ERP's Dashboards engine got there first (or the extension bound to the ERP's own NLog),
  our rules were never added. The target and rules are now added into the active
  configuration, scoped to the addon's logger, and restored whenever the host replaces it.

## [2.15.0] - 2026-10-07

### Changed

- Settings reorganised into seven tabs: Modelo, Ferramentas, Pesquisa web, Jev, Skills,
  Exportação and Avançado. Each tab is one column of titled sections; the two-column grid
  that packed unrelated fields side by side is gone, and "Diagnóstico" appears once. The
  tools list is grouped (consulta, documentos, escrita, automação, pesquisa, skills), shows
  the first sentence of each description with the full text one click away, and no longer
  scrolls inside a 264 px box. "Testar ligação" sits next to the model it tests.
- Skills: "Nova skill" asks for a name, creates the folder from the template with the header
  filled in and opens SKILL.md in the editor; every skill card has "Editar SKILL.md" (or
  "Ver SKILL.md" for shipped and shared ones). The template itself is no longer listed.

### Fixed

- A provider answer such as HTTP 400 or 401 to a non-streaming request (the model check and
  the tools check of "Testar ligação", and any turn with streaming off) was reported as
  "Não foi possível ligar ao fornecedor de IA. Verifique a ligação à internet". The body
  was read and discarded; it now reaches the user as "O fornecedor recusou o pedido
  (HTTP 400): …" with the provider's own reason, so a rejected tool schema or an unknown
  parameter can be acted on. OpenRouter's numeric `"code"` in error bodies no longer breaks
  parsing either.
- "Testar ligação" with a refused key on a provider that lists models showed "✓ Chave
  aceite pelo fornecedor — 0 modelos disponíveis" and then failed on the model step. A 401
  on the listing is now reported as such, and the steps say what they prove: the listing is
  "Fornecedor contactado" (OpenRouter lists models without any key), and the 1-token
  completion is "Chave aceite e modelo disponível nesta conta".
- Enabling two web-search providers one after the other kept only the second: each save
  started from the configuration loaded at start-up. Saved sections are reloaded into
  memory as soon as they are written, so toggles, order and mode persist together and the
  modal shows the real state when reopened.

## [2.14.1] - 2026-10-02

### Fixed

- The chat header and composer at narrow widths. Docked at the default 600 px, the
  context pill ran under the supervisor badge and the AI disclosure ended in an ellipsis.
  The left section now shrinks inside its own box, the badge keeps only its shield below
  640 px (the tooltip keeps the role), the empty-context label collapses to the plus at
  820 px, the model name gets more room, and the composer hint has a short form chosen by
  width, so nothing truncates mid-word.

## [2.14.0] - 2026-09-30

### Added

- `interact_erp_window` fills a whole screen in one call: `set_fields` writes every field of
  a record in the order given and `set_grid_row` a whole document line (article first). The
  result says, field by field, which ERP field each value went to and whether the ERP kept
  it; a dialog that opens midway stops the batch instead of typing into a blocked window.
  One tool call replaces one model round trip per field, and the chat shows the outcome as
  a card ("3 de 3 campos", one row per field).
- Fields on other tabs. A record is read with every tab it has (119 fields on the client
  record, 104 of them outside the tab in view) and the tab is selected before the value is
  written: "NIF" reaches Dados Fiscais and "plafond" reaches Crédito without the user
  switching tabs. A field the ERP keeps closed comes back with the options beside it that
  open it ("Limite" with "Limite em valor").
- Document lines in the ERP's own grids. The line grids of the editors are FarPoint
  spreads; `set_grid_row`, `set_grid_cell` and `list_grid` now read and write them the way
  a user does (the cell enters edit mode, takes the text and is left), so the article
  lookup, the price and the totals run as if typed.
- The assistant learns the windows, and what it learns reaches every workstation.
  - **Shipped knowledge.** The addon comes with what a request means in the windows it was
    measured on ("plafond" is "Limite" on the client record, "editor de documentos de venda"
    is `Vendas → Documentos`). It is inside the addon, and the setup also puts it as text in
    `Knowledge\automation-knowledge.json` in the extension folder, where an administrator
    edits it once for every workstation: add an entry, switch a shipped one off, or delete
    the file to get it back as shipped. Edits are picked up without restarting the ERP, an
    upgrade never overwrites an edited file, and an unedited one follows the new version.
  - **Learned knowledge.** Each workstation keeps what it learned in
    `%LocalAppData%\Cegid\Extensions\AITOOL\automation-memory.json` and shares it with the
    others through the company database (`AI_AutomationKnowledge`), the one place every
    workstation of a client-server installation reaches. The exchange runs behind the turn;
    a database that is slow, unreachable or without the table leaves the workstation
    working with what it has.
  - **It learns from three things:** what the ERP kept (a name resolved by Jev whose value
    stayed in the field); corrections (a request that found no field, followed by the same
    value written under the field's real name); and the user, on the cards, with "Era isto"
    and "Não era isto"; a match that came with the addon is labelled "de origem", one
    the installation learned "aprendido". What the user rejects is never proposed again for that wording and
    never comes back by itself; only "Era isto" takes a rejection back. A value the ERP
    refuses says nothing about the field, so nothing is unlearned there.
  - **No file is indispensable.** A knowledge file that is missing, locked, cut short or
    full of garbage is read as far as it can be, copied beside itself as `.corrupt` and
    rebuilt; the workstation memory keeps a backup of the last good version and is written
    through a temporary file, so a crash or a full disk leaves the previous one whole; two
    ERP processes writing at once keep what both learned.
  Names and captions only, never what was typed. Settings → Avançado shows the counts,
  where the files are and whether the knowledge is being shared. Forgetting what was
  learned reaches every workstation of the company, so it is reserved to the ERP
  administrator, super administrator or technician, asks twice (the second click within
  ten seconds), and is refused by the
  addon itself for anyone else; a single wrong match is corrected by any user with
  "Não era isto".
- `open_erp_function` finds the function by the user's wording: memory first; then, when
  the same function sits in two places of the ribbon (`Compras → Fornecedores` and
  `Geral → Recursos → Tabelas → Terceiros → Fornecedores`), the shortest way; then Jev
  against the whole ERP catalogue (865 entries here, asked in slices at the same time, the
  best of each slice settled in a last question with one option per function). When nothing
  is sure enough the model gets the dozen best candidates instead of the whole catalogue.
  What Jev or the model chose is a proposal: the card asks, and it becomes memory when the
  user says it was right or when the ERP keeps a value in the window it opened.
- The dialogs the ERP raises around a save are known by name: "Movimentos para a
  Contabilidade e Bancos", "O documento da contabilidade não está correto" and "Deseja
  efetuar a sua correção?" come back with what each answer does, so the assistant can tell
  the user that "Não" saves the document and leaves the entry as a draft.
- Two more cards on the welcome screen: filling a window and creating with confirmation.
- `interact_erp_window` `open_list` opens the ERP list of a code field, the F4 of that
  field. "A lista de artigos" is a list, not the Artigos window: `search_entities` now
  lists without a search term, and the record window opens only when asked for.
- `create_article`: creates an article, goods or service, through the ERP object model,
  in the same two steps as the other writers (preview, then the confirmation card). Every
  unit of the article is the base one, so a document line is not refused for a missing
  conversion. The VAT code is never guessed: without one the tool returns the company's
  codes and rates. An optional sale price goes to PVP 1. It replaces filling the Artigos
  window field by field, where the ERP refused the save for a VAT code and a unit the
  assistant had not written.
- `update_sales_series`: extends or reactivates a sales series, for administrators and
  technicians, with the same preview and card as the other writers. Series carry an end
  date and most installations let them run out at the turn of the year; until now every
  document of that type was refused until somebody found the configuration screen. The
  assistant names the series that ran out and offers to extend it. When the old year series
  are still marked as default and would overlap, the extended series is kept and drops the
  default mark, and the card says so.
- Fast decisions with Jev (TypeSafe AI), off by default, in settings → Avançado. Through
  OpenRouter it uses the OpenRouter key already configured; the direct TypeSafe route takes
  its own key, stored encrypted. When on:
  - labels that do not match by name ("NIF" → Contribuinte, "plafond" → Limite de Crédito)
    are resolved against the visible fields or grid columns, all of them in one parallel
    call of about 0.3 s, above an adjustable minimum confidence (0.50-0.95, default 0.60);
    below it the result lists the most likely candidates instead of guessing;
  - an ERP dialog the automation runs into comes back classified (information, save prompt,
    destructive confirmation, error, open session, licence) with the safe next step;
  - every button click without confirmation gets a second opinion that can only send it to
    the confirmation card, never let it through.
  Only window titles, menu names, labels, captions and dialog texts are sent, never field
  values or table data; the settings panel shows the data-protection notice next to the switch, and
  "Testar Jev" checks the key and the route. `scripts/checks/Test-JevDecisions.ps1` covers
  the service offline and, with `-Live`, against both routes.

### Changed

- Reading the fields of an ERP window no longer goes through UI Automation. The editors are
  WinForms trees where the editable control sits inside composites and its caption is a
  label beside the composite; walking the tree takes 0.4 s where the UIA enrichment took
  5 to 17 s and came back without captions. UIA stays for windows with fewer than four
  managed fields.
- A customer or supplier created through the object model had no place of operation, and
  the accounting integration of its first purchase invoice fell on the aggregate account
  ("Conta 221 não é de movimento"). The file now carries the same value the editor gives.
- A customer or supplier created without a payment condition gets the one most files of
  that kind already have, named in the preview; `create_sales_document` takes
  `payment_terms` and, for a customer whose file has none, does the same instead of
  stopping at "A condição de pagamento não está preenchida".
- A sales document the ERP refuses for its type or series (a series of manual copies, one
  with documents left unsigned, one out of date) comes back with the alternatives: the
  other valid series and the types of the same nature, each already put to the ERP as a
  preview, so the assistant proposes what the ERP does accept instead of stopping. What
  reverses a sale (returns, credit and debit notes) is never offered in place of one.
- What Jev was barely sure of is written but not remembered: under 0.80 the match stays a
  proposal on the card ("Era este" / "Não era este") instead of becoming knowledge for
  every workstation.
- `open_list` looks for the field among the code fields and uses what is known about the
  wording first: "cliente" in the sales editor opens the list of Entidade, not the discount
  box whose control happens to be named DescCliente.
- The totals row of the pending items card added up document numbers ("TOTAL 2,00" under
  N.º Doc.); only amounts are totalled.
- A list asked for without a search term starts with the records that have a name, not
  with the blank ones.
- A field name that matches the same caption on several tabs takes the one on the tab in
  view ("Entidade" in the sales editor) instead of asking.
- A compile-only build (`-p:OutDir=...`) with the ERP open no longer empties the shadow copy
  the running ERP is using.
- After a turn that opened or drove an ERP window, the keyboard returns to the chat
  composer (docked chat only), so the next thing typed goes to the assistant and not to the
  field the ERP focused.

### Fixed

- Dates written to masked boxes (the filters of Consulta de Pendentes) came out as
  `20-15-1900`; they now go in as digits in the order of the mask, and `yyyy-MM-dd` sent to
  a plain text box is shown the way the workstation shows dates.
- The click gate let through buttons that post or convert without saying "gravar":
  Estornar, Lançar, Emitir, Processar, Liquidar, Converter, Integrar, Aprovar, Transformar,
  Registar, Contabilizar, Finalizar, Encerrar, and "Fechar" followed by Período, Caixa,
  Exercício, Mês, Ano, Dia or Turno. They now go through the confirmation card; "Fechar" on
  its own still closes windows.
- The confirmation card of a button click said "Gravado" as soon as the click went out,
  even when the ERP had answered with a dialog and nothing was saved. A click now ends as
  "Clique feito" or, when the ERP opened a dialog or is still working, "Falta responder no
  ERP", with the name of the dialog; "Gravado" is kept for writes the ERP confirmed. A
  click that commits is watched for the dialog the ERP may raise after validating, and the
  assistant says "cliquei em Gravar", not "ficou gravado", until it has seen the record.
- Answers to an ERP dialog other than a refusal are no longer offered on a card: a dialog
  the ERP is waiting on blocks the window the chat lives in, so the card could not be
  clicked. The assistant says what the dialog asks and the user answers it in the ERP.
- A document line with an article that does not exist made the ERP raise its own "Ocorreu
  um erro inesperado" dialog, which blocked the chat until it was closed by hand. Articles
  are checked before any line is added.
- `get_sales_document_types` listed 17 of the 22 types of the demo company: the ERP list
  it read leaves out quotes and orders. It now reads the table of types.
- Reading the dialog the ERP opens after a click took 17 s through UI Automation and lost
  a worker. Managed dialogs are read from their control tree and system message boxes from
  their child windows, in milliseconds.
- `create_sales_document` was refused with "a data do documento é posterior à data de
  início do transporte" on series that carry a loading date: the loading date is now never
  before the document date.
- `get_sales_document_types` with the filter "orcamento" found nothing, because the
  description is "Orçamento": the filter ignores accents and also matches the nature.
- The list of articles in the chat showed the description blank: the card read a column
  name with an accent that the query does not have.
- An answer that says "o ERP recusou" in a turn where nothing was put to the ERP now
  carries a note saying the ERP was not consulted, the same way an unbacked "gravei" does.
- `set_field` on its own returned an empty `message` to the model; it now returns the
  outcome and the value the ERP kept.
- In a window with several grids (the sales editor shows the totals grid first) the grid
  tools took the first one and never found "Artigo". The column now decides the grid, and
  `list_grid` reports the editable, widest one.

## [2.13.1] - 2026-09-24

### Fixed

- The log file now carries the key/value details of each entry (model, token counts,
  billed cost, error code), which until now reached only Sentry: "Cost estimate for
  request" is readable in a customer log again.
- Two failures less than 2 s apart: the second one lost its `FLIGHT:` context, because the
  throttle emptied the flight recorder instead of keeping it for the next write.
- The support bundle redacts the logs and the installer reports too (keys, passwords,
  connection strings, `C:\Users\<name>` paths), not only the report. The settings text now
  says what the logs can still contain.
- Professional was shown as "validada" on version alone. The installer pre-flight and the
  session header now say "versão suportada; edição por confirmar" until a customer runs it.
- Error text that reaches the user without a mapped code (connection test, key and web
  search checks) is redacted the same way.
- Diagnostics in settings: "Exportar pacote de apoio" shows progress and cannot start twice;
  "Testar ligação" and "Registos detalhados" no longer stay stuck or show a state that was
  not applied when the C# side fails; the error codes in "Últimos avisos e erros" are
  readable in the dark theme; screen readers get the switch name and each step of the
  connection test.
- A chat opened without its formatting scripts logs `UI_003` (the toast mentioned a code
  nothing recorded) and points to the support bundle.
- Release script: a new release is created empty and its assets are uploaded with retries,
  so a dropped 118 MB upload no longer deletes the release.

### Changed

- README and the security and privacy guide describe what Sentry receives when an operator
  configures a DSN (errors, release-health sessions, a 10% trace sample) and list the
  support bundle as a way data can leave the machine. The installer guide warns that
  `/SQLPASSWORD` is visible on the command line.

## [2.13.0] - 2026-09-22

### Added

- Evolution, Executive and Professional. The installer treats every instance × edition pair
  as a target (`Config[_X]\EV`, `\LE`, `\LP`, each backed by its `Erp100<ED>.exe`), installs
  the same files into all of them and keeps one Extensibility row per instance. A previous
  install left in `Config\EV` on a workstation without Evolution is removed and the addon
  lands in the folder the ERP actually reads. `/EDITIONS=EV,LE,LP|ALL` for silent
  deployments; `-p:PrimaveraEdition` and `-p:PrimaveraInstance` for the build and F5.
- Pre-flight check in the installer, before any file is copied: Primavera version per
  edition, the Cegid WebView2 component (`Cegid.Platform.WebBrowserControl.dll`, absent on
  CefSharp-era builds), DevExpress 21.2, the extensibility engine, .NET Framework 4.8, the
  WebView2 Runtime (installed automatically when missing), the ERP closed, write access to
  each destination. Only the two missing ERP components and an uninstallable WebView2
  Runtime block; everything else warns. A result page after the copy proves each target
  (file present, MD5 equal to the registered row, executable found) and saves a report to
  `%ProgramData%\AITOOL\Install`.
- The addon checks the host before touching DevExpress or WebView2. On an ERP that lacks
  the components it needs, the ribbon gets a single AITOOL button that explains what is
  missing (ERP_004..006) instead of a silent empty tab. A missing WebView2 Runtime shows
  "Instalar WebView2" and "Tentar novamente" in the chat panel (UI_001); any other browser
  start-up failure shows the cause (UI_002). One browser profile per edition.
- Diagnostics for everyone: the settings modal shows one status line and "Exportar pacote
  de apoio", which writes a zip with a redacted report and the last seven days of logs;
  supervisors also get the log folder, a "Registos detalhados (24 h)" switch that really
  raises the log level and expires by itself, and the last warnings and errors.
- "Testar ligação" now verifies the provider the way the chat uses it, in four steps: key
  accepted, configured model reachable, streaming answer received, request with the ERP
  tools accepted. It used to stop at the model list, which passed with a model the account
  could not use.
- Every user turn carries a correlation id (`T-xxxx`) through the log and on the error card
  ("ref. T-xxxx"); the log layout carries the turn and the source class; a session header
  records versions, edition, instance, user and folders; and in RELEASE the last Debug
  lines are dumped into the file just before a warning or error (flight recorder).

### Fixed

- Installed on an Executive-only workstation, the setup used to write into `Config\EV` and
  the ERP reported "Não existe: AITOOL.dll". Reported by an Executive user on 2026-09-17.
- Chat resources and built-in skills were looked up under `Config*\EV` only; on any other
  edition the chat fell back to the embedded page (no markdown, no diagrams) with a toast
  that blamed the network.
- Timeouts (AI_002), a company not yet open (ERP_001) and empty model answers (AI_004) now
  reach the error card with their codes instead of a generic message or a blank bubble.
- The DevExpress version probing on start-up was decorative (references are bound to
  21.2.3.0) and is gone.

### Changed

- Requirements: Primavera v10.20 (build 10.0020) validated on Evolution and Executive;
  Professional installable on the same rules, awaiting a customer confirmation; .NET
  Framework 4.8; WebView2 Runtime 125 or later recommended.
- The installer script compiles on Inno Setup 6.5 and 6.6+ (the `CreateCustomForm`
  prototype changed in 6.6); `build-installer.ps1` picks the newest compiler installed.

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
  only, unmodified redistribution allowed) instead of the previous permissive licence. The source repository is private;
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
