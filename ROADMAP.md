# Roadmap

Where AITOOL is going, in order. Effort windows, not dates — this is a working
document, revised as releases close. Anything listed here describes intent, not
a shipped capability; the README documents only what exists today.

## Before a public launch

Non-negotiable, in this order. (Status on 2026-08-21: the product launches as a free
binary under the Community License from a public documentation repository; the items
below that are still open are stated as limits in the README rather than hidden.)

- **A real confirmation gate on writes.** Today the `confirm` flag arrives in the
  model's own tool arguments and nothing in C# or JS blocks a commit on a user
  gesture — it is a prompt boundary, documented as such in SECURITY.md. The fix
  is a one-shot preview token: the `confirm=false` pass returns a GUID bound to a
  hash of the draft, and the `confirm=true` pass requires a matching, unexpired
  token. That closes stale previews and double-confirms with the same change.
- **"How it worked this out."** Expose the tool calls, the SQL and the source
  records behind every number, in the answer. IDC (Jul 2026) found 71% of finance
  leaders would veto a 99%-accurate system that cannot show its reasoning; Sage
  and NetSuite both ship this today.
- **Machine-readable marking of generated content.** The other half of AI Act
  Article 50: the disclosure to the reader now exists, but exported conversations
  and generated documents carry no marker saying a model produced them.
- **Settle the `Lib/` question in writing** with the Cegid partner agreement. The
  position is stated in DISTRIBUTION.md. With the source repository private, no Cegid
  binary leaves the building; the conversation is needed only before any source release.

Closed on this list: print from the PDF card (2026-08-24: Imprimir opens the viewer with
Chromium's print dialog; Ctrl+P in the viewer does the same), the README screenshots
(2026-08-21), the capabilities-and-limits statement ("What it will not do" in
the README), the minimum-model floor (~8B at q4, in the README's cost section), the
Cegid Pulse comparison, and the Article 50 disclosure to the user — stated on the
welcome screen and standing under the message box for the whole session, because a
returning conversation never shows a welcome screen.

## Next up — reach

The gap between what the engine does and what the user can reach.

- **Export any result table to Excel or CSV.** Today tables offer copy to
  clipboard; the export services already exist and will be wired to a button
  on every table card.
- **Charts and saved views from an answer.** Natural-language charting is table
  stakes across the category; promoting an answer to a persistent widget is not.

## Trust

What a customer hits in the first week of real use.

- Accessibility pass: keyboard access to tool cards and dialogs, focus
  return on modal close, semantic landmarks. The screen-reader streaming
  blocker is already fixed; claims wait until the full list closes.
- Friendly first-run and error surfaces with clear recovery steps, and honest
  error mapping: provider 5xx, context-length-exceeded and "this model has no
  tool support" currently all surface as "check your internet".
- Token and cost figures that are fully correct. The session panel (2026-08-29)
  prices every request with the model that answered it, reads OpenRouter's
  published prices from its models endpoint and falls back to a built-in table
  for OpenAI and Anthropic. Since 2.12.0 streams carry the provider's real usage
  and OpenRouter's billed amount replaces the estimate ("Custo faturado"), cached
  input tokens are kept per request, and the context size comes from the
  provider's catalogue. Still open: cached tokens are recorded but not shown; the
  table has no Claude 5 rows (OpenRouter covers them); totals cover the ERP
  process, not one chat window.
- `interact_erp_window` `list_fields` on a client record: the enrichment walk ran 12-15 s
  against a 4 s budget and the worker was replaced after a timeout (2026-08-30, no
  cancellation involved). The budget is not holding on that path; measure the
  enrichment step and cap it.
- "Tentar novamente" on an older failed turn regenerates the latest turn, not the one
  whose card was clicked (2026-08-30). Retry should carry the turn it belongs to.
- "Fecha as janelas todas" is answered with `list_windows` plus one `close_window` per
  window (three model round-trips, ~10 s) instead of the single `close_all_windows`
  action (2026-09-02). Steer the tool description, or accept the route and give the
  single-window close the same Info log line as the bulk one.
- Silent streams while a model thinks: two 100 s stalls on "Abre a ficha do cliente SOFRIO"
  (2026-09-01, gpt-5-mini via OpenRouter, reasoning "Desl.") came from the model reasoning
  at its default medium effort with nothing streamed. 2.11.1 sends `minimal` for "Desl."
  on gpt-5; the general fix is to ask OpenRouter to stream the reasoning (so the UI shows
  "A pensar" with a clock instead of silence) and to raise the no-token timeout only when
  reasoning is on.
- Skills, next: an `http_request` tool with an allow-list of domains and DPAPI-stored
  credentials, which is what opens external APIs to skills — the first one planned is
  `easypay-cobrancas` (MB references, MB WAY, payment lookups), sandbox first; a public
  `BolaLabs/AITOOL-skills` collection reviewed by pull request and "install from the
  collection" inside Settings → Skills; per-skill saved parameters (default seller,
  origin) and per-company skills.
- CRM opportunities beyond create: default sales cycle should be the company's (the
  window uses CV_SOFT on DEMOV10; the tool takes the first cycle by code), campaign and
  project as optional arguments, an `advance_opportunity` tool on
  `CriaActividadeFaseCicloVenda`, an `open_record` route for opportunities (the ribbon
  function opens a blank record; loading by code needs its own path), and the first
  contact/activity in the prospecting skill. `list_fields` on that window: 36 fields,
  enrichment 20 s, walks of 7-8 s against the 4 s budget (2026-08-30).
- Automatic compaction: `/compactar` exists and the chat nudges at 80% of the
  context; running it unattended before the limit is hit is the next step.
- A retention policy for `AI_ChatMessages` and `AI_AuditLog`. Today nothing
  expires and there is no purge — a GDPR question for a Portuguese market.
- Approvals routing: a second-approver gate for writes above a threshold.

## Efficiency and reliability

Measured gaps, not preferences.

- **Pending-items date window.** `get_pending_items` passes a 24-month `DataInicial` to the
  ERP's own query, and the tool description says so, yet a run without dates returned the
  same 138 documents as a run from 2015 on the demo company. Establish what `TipoDataRef=0`
  does with the dates, then either make the window real or drop the claim. The same query
  pays dozens of catalog round trips through the DSO; on a server with slow compiles it
  took 60-125 s where the SQL itself took under a second.
- **Prompt caching that works.** Every request carries a fixed ~11k-token prefix
  (16 KB system prompt + ~20 KB of schemas for 24 tools) re-sent on every tool
  continuation. Only 1 of Anthropic's 4 cache breakpoints is used, and because
  the order is tools → system → messages, changing the open ERP window
  invalidates the cached tool schemas. Published measurements: 41-80% cost,
  13-31% TTFT.
- **Fewer tools in the prefix.** 21 is at OpenAI's recommended ceiling and above
  Anthropic's tool-search threshold. Either consolidate related tools behind an
  `action` parameter, or defer the rare ones. Do it once, not incrementally —
  it changes the observable tool names the golden set asserts on.
- **Model capability discovery instead of name-prefix guessing.** Anthropic's
  models endpoint returns effort levels and thinking types; OpenRouter returns
  `supported_parameters`. Both are already parsed and both results are thrown
  away before the request is built.
- **Keep the partial answer when the idle watchdog fires.** The budget is now
  inactivity rather than total call time, and the two keys with different units
  are one. What is still lost on a cut is persistence: the text stays on screen
  but never reaches the message chain, so it disappears on reload and is absent
  from the next request's context. Fixing that means the providers returning
  what they accumulated instead of throwing.
- **Row caps on the three tools that have none** (`check_stock`,
  `query_account_balance`, `analyze_sales` by-period) and an `EXISTS` check so a
  non-existent code returns "not found" instead of a confident zero.
- **Timing where the seconds go.** Tool durations are logged at Debug, which is
  DEBUG-build only — the shipped build records no tool duration at all. Nothing
  in the SQL layer is timed, and time-to-first-token is never measured.

## Evaluation

No ERP vendor publishes accuracy numbers, and evaluation gaps are the most-cited
reason agent pilots die. The golden set exists and has real pass criteria; what is
missing is turning prose criteria into log assertions so a run produces a failure
count, the way the `scripts/checks/` guards already do. Ground truth here is
deterministic — SQL and `AI_AuditLog` rows — which is a stronger oracle than a
judge model. This is the clearest open field in the category.

## The other half of the ERP

- Purchase documents: creation with the same two-step preview/commit flow and
  ERP-side validation used for sales.
- Article creation.
- Purchase document types and series discovery tools.
- Per-line VAT override, pending live validation of how the ERP recalculates
  totals.

## Memory

Structured, scoped, visible. Facts the assistant learns (default series,
customer terms, house rules) stored in the company's own SQL Server database
alongside the existing chat history and audit tables — with provenance, and a
panel where the user reviews, edits and deletes what was learned. No external
services, no new dependencies.

## Vision (read)

Point the assistant at a document image or PDF and let it identify what it is,
extract the identifiers, and resolve the current state from the ERP — the
database is the source of truth for state, never the pixels. Provider-gated
and off by default: images leave the machine only when the user's configured
provider does.

## Skills by convention

Extensibility through reviewed instruction files (markdown), never through
dropped binaries. A skill is approved before it becomes available; the
assistant never writes its own.

## Purchase invoice intake

The largest competitive gap: document intake is table stakes at five ERP vendors,
it is the case that pays first in Portugal (accounts payable), and a competitor
already sells it on Primavera v10.

Assisted, end to end: the Portuguese invoice QR code is the signed source of
truth for header and VAT totals; vision reads only line items; a deterministic
reconciliation in code must match the QR before anything is proposed; the
human confirms every posting. If the numbers do not reconcile, it stops.

Portuguese constraint that shapes the design: AI must never *issue* fiscal
documents — invoicing goes through AT-certified software with ATCUD and SAF-T.
The input side (read, extract, classify, propose) is safe territory, and
proposing inside the certified ERP for a human to commit is already the shape
this product has.

## Further out — beyond one ERP

Stated as direction, not commitment; nothing here ships before the launch list closes.

- **Other ERPs, then ERP-agnostic.** The provider abstraction, chat surface, tool
  contract (`IErpTool`) and audit model already do not know about Primavera; the ERP
  specifics live behind those seams. The direction is to extract the Primavera layer
  into a pluggable integration so the same assistant — same trust model: on-premise,
  your AI provider, preview-then-save, audited writes — can serve other ERPs.
- **MCP client.** The current MCP spec (Streamable HTTP transport, which supports
  stateless servers) fits this addon's in-process, per-turn model. An MCP client in
  AITOOL would let the assistant consume third-party tool servers beyond the built-in
  tools, with the same per-tool toggles and audit treatment. On .NET Framework 4.8 this
  means either the official C# SDK's netstandard2.0 surface or a thin JSON-RPC client in
  the vendored SDK project — decided when the work starts, not before.

## Design lines that do not change

These are decisions, not gaps:

- **No autonomous long-running workflows.** Tool chains are capped per turn
  and every destructive step requires explicit confirmation.
- **No automatic posting.** Accounting movements are proposed, never posted
  without a human.
- **No binary plugin loading.** Nothing gets to run inside the ERP process by
  being dropped into a folder.
- **Writes are audited.** Every mutating action lands in `AI_AuditLog` in the
  company's own database.
- **No multi-agent orchestration.** One user, one ERP session, UI-thread-bound
  window automation. Sub-agents solve context exhaustion in long autonomous runs;
  this product caps tool chains per turn by design.
- **No embedding store for memory.** Memory is structured, visible and editable in
  the company's own SQL Server. For a relational ERP, semantic recall over chat
  history is worse than a query and adds a heavy dependency to an in-process addon.
- **No LLM-as-judge gating a build.** What this assistant asserts is checkable
  against the ERP's own numbers and the audit table; a judge model would be weaker
  evidence than the check that already exists.
