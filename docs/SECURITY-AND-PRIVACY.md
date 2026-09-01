**English** | [Português](SECURITY-AND-PRIVACY.pt.md)

# Security and privacy — what an IT approver needs to know

This is the document to read before approving AITOOL on a company machine. It describes the
addon as installed: not the AI provider's own security posture, not Primavera's, not your
SQL Server hardening.

Vulnerability reporting is in [SECURITY.md](../SECURITY.md).

---

## 1. Where the software runs

In-process inside `Erp100EV.exe` on the user's workstation (.NET Framework 4.8), deployed to
`<SG100>\Config\EV\Extensions\AITOOL\` and registered in the ERP's Extensibility table
(`PRIEMPRE..ExtensibilityConfiguration`).

There is no server component. **No Bola Labs service is contacted at runtime** — no licence
check, no telemetry endpoint, no update check. Uninstalling is deleting one folder and one
Extensibility row.

## 2. What leaves the machine, and to whom

| Destination | What | When | How to stop it |
| --- | --- | --- | --- |
| The AI provider **you** configure | The conversation, the system prompt (which carries the company code, the user and the currently open ERP window) and every tool result — customer names, tax numbers, balances, sales figures, SQL result rows | Every turn | Configure a local OpenAI-compatible endpoint; nothing leaves the machine |
| Web-search provider (Tavily / Brave / Serper / Exa / self-hosted SearXNG) | The search query text only | Only when `web_search` runs | Disable the tool, or leave the key unset |
| VIES and NIF.pt | A tax number | Only when `enrich_entity` runs | Disable the tool |
| Sentry | Error-level events, sanitized | **Only if an operator configures a DSN. No DSN ships.** | Leave `Sentry:Dsn` empty (the default) |
| Bola Labs | Nothing, ever | — | — |

What reaches the provider is what the assistant retrieved to answer that question — not a
bulk export. There is no data-residency control beyond the provider's own.

## 3. What the assistant can do

- **Read** ERP data: entities, documents, stock, current accounts, pending items, sales
  analysis, and read-only SQL.
- **Drive the ERP client**: open functions by navigating the ribbon, open records in their
  editors, list and fill fields and grid cells in open windows — including the classic VB6
  editors, via UI Automation.
- **Write**: create and update customer/supplier files, create sales documents, create CRM
  sales opportunities. E-mail drafts are handed to the default mail client for review and
  never sent by the addon.
- **Generate** the official Crystal report PDF of a document and open it.
- **Search the web**, with results marked as untrusted content.

The ceiling: no purchase documents, no article creation, no accounting postings, no
deletions, no direct writes to ERP tables.

## 4. What bounds it, and how strongly

Three tiers. The distinction matters, so it is stated plainly rather than blurred.

**Enforced in code.** `run_query` accepts only `SELECT`/`WITH`, after reducing the statement
to its executable skeleton (comments and string literals removed, brackets unwrapped, Unicode
homoglyphs normalized), rejects statement stacking, rejects cross-database and `db..object`
names. The blocklist behaviour is pinned by `scripts/checks/Test-SqlGuard.ps1`; the 500-row
cap is applied in `RunQueryTool` (as a `TOP` rewrite when the query can be wrapped, otherwise by
stopping the reader after 500 rows) and is not covered by a guard script. Commit and
destroy buttons in the window automation (gravar, guardar, anular, apagar, eliminar, remover,
confirmar) are refused unless the call carries the authorisation flag — judged on the button
the ERP resolved, not on the caption requested, because the resolver matches by substring.
Inside a modal dialog only refusals and single-button acknowledgements pass without it. One window interaction at a time;
commits are single-flight. Web-search endpoints are HTTPS with redirects disabled. The chat
page's CSP confines script, style, framing and form-action sources to the page's own origin,
and every library is vendored with SRI. Two limits are worth stating plainly: inline script
and style are allowed, because the surface is a single file, so the CSP restricts where code
comes from and not what injected inline markup could do — that is what DOMPurify is for; and
images and outbound connections are allowed over HTTPS, so markdown rendered in the chat can
still reference a remote image.

**Enforced by the prompt, not by code.** The two-step write contract, and the rule that tool
output is data and never instructions. A model can ignore a prompt rule. This is why the
audit trail and the off switches exist, and why the next section is worth reading.

**Enforced by configuration.** Individual tools can be disabled
(`Assistant:DisabledTools`), or the whole ERP tool layer (`ErpTools:Enabled=false`), leaving
a plain chat with no ERP access.

### The confirmation boundary, precisely

Write tools take a `confirm` flag. With it false the ERP validates the draft and returns a
preview without saving; with it true the record is committed. **The flag is set by the
assistant**, following a system-prompt instruction to set it only after the user agrees in
the chat. There is currently no code path that blocks a commit on a user gesture, so a model
that ignores the instruction can commit in one step.

Every commit — and every refused commit — lands in `AI_AuditLog`. A hard UI confirmation is
the first item on the roadmap. If that residual risk is unacceptable for a given company,
disable the write tools, or the tool layer entirely.

### It does not enforce Primavera's per-user permissions

Tools that go through the ERP object model act as the logged-in ERP user. **Tools that read
through SQL do not**: `search_entities`, `query_documents`, `query_account_balance`,
`analyze_sales`, `check_stock`, `render_document` and `run_query` use the ERP's own database
connection, and Primavera's permissions are enforced by the application, not by the database.
A user who cannot see supplier balances in the ERP can still ask the assistant for them.

Bound it by disabling those tools for the population that should not have them, or by
pointing the addon at a read-only SQL login scoped to what you accept.

## 5. Credentials

API keys are encrypted with Windows DPAPI (`CurrentUser` scope) and stored as base64 in
`%LocalAppData%\Cegid\Extensions\AITOOL\secrets.dat`. Per-user and per-machine: not readable
by another Windows account, not portable, and **not recoverable if the profile is lost or
reset** — the key simply appears to have never been set, and has to be entered again.

Keys are never written to `appsettings`, never logged, and never sent anywhere but the
provider. The settings UI shows a mask, never the value.

Environment-variable fallbacks exist for unattended setups: `OPENAI_API_KEY`,
`OPENROUTER_API_KEY`, `ANTHROPIC_API_KEY`, `LMSTUDIO_API_KEY`.

Note for terminal-server, VDI and roaming-profile deployments: DPAPI `CurrentUser` follows
the Windows profile. A non-persistent profile means the key is re-entered every session.

## 6. What is stored in your database

Three tables are created **automatically, in the ERP company database** (`PRI<CodEmp>`) on
first use. There is no separate database and no migration step.

| Table | Contents |
| --- | --- |
| `AI_ChatSessions` | Session metadata per user and company |
| `AI_ChatMessages` | Message content, plain text, including ERP data returned by tools |
| `AI_AuditLog` | Timestamp, user, company, tool, summary, success flag, and the serialized tool arguments with key/token/secret/password values redacted, truncated at 2000 characters |

**There is no retention policy and no purge job.** Sessions can be deleted individually from
the UI; nothing expires, and the data survives uninstalling the addon. For a deployment
subject to GDPR retention or erasure obligations, that is a policy you have to add — a
scheduled delete against these three tables is the whole of it.

Required permissions: whatever the ERP connection already has, plus `CREATE TABLE` on the
database and `ALTER` on the `dbo` schema the first time the addon runs.

If your login is not allowed to create tables — and many are not — run
[`sql/AI_Schema.sql`](../sql/AI_Schema.sql) once per company as `db_owner`. After that the
addon needs no DDL rights at all: `SELECT, INSERT, UPDATE, DELETE` on `AI_ChatSessions` and
`AI_ChatMessages`, and `SELECT, INSERT` on `AI_AuditLog`, which is never updated or deleted.

**A commit is refused when the audit trail cannot be reached.** Creating or changing a record
in the ERP with the confirmation flag set checks first that the log can be written, and stops
with an actionable message if it cannot. Previews and reads carry on, because they change
nothing in the ERP. Before this, a database that blocked the tables let the write through and
left two warnings in a local file as the only trace.

### What the audit trail covers

**Covered**: commits through the object model (create/update entity, create sales document,
create sales opportunity),
refused commits, failures, and the five mutating window actions (field write, grid write,
button click, window close, close-all-windows, and their refusals).

**Not covered**: previews and non-confirmed attempts, ribbon navigation
(`open_erp_function`), reads, `print_document`, and `enrich_entity` (read-only).

**Failure mode**: if the audit insert itself fails, the ERP write still stands and the
failure is logged locally only.

**Viewing**: `/auditoria` in the chat shows the recent entries; the table is yours to query.

## 7. Local logs

`%LocalAppData%\Cegid\Extensions\AITOOL\Logs\`, daily rotation, 7-day retention, never
uploaded. DEBUG builds log verbosely, including tool arguments; RELEASE logs warnings and
above; RELEASE builds log Info and above (operations and ERP-write context, never the key).
Web-search queries are never logged — they can embed names and tax ids.

## 8. Prompt injection

ERP fields, SQL results and web pages are text an attacker can influence, and all three reach
the model.

Mitigations: a spotlighting rule in the system prompt that treats tool output as data and
never as instructions; `untrusted_content` marking on web results with an inline warning; and
telemetry on known injection phrasings.

Residual risk, stated plainly: a successful injection could cause a tool call the user did not
intend. It is bounded by the tool set, the SQL guard, the commit-button gate and the audit
trail — **not** by a confirmation dialog. See section 4.

## 9. Network

Outbound, over TLS 443, to whichever of these you enable: your AI provider's API host, your
web-search provider, `ec.europa.eu` (VIES) and `nif.pt` if `enrich_entity` is used,
`www.google.com/s2/favicons` for the icons on web-search source cards (the hostnames of the
sources are sent to Google), and your Sentry host if you configure a DSN. Nothing else. There is no inbound listener.

The chat UI is served from a WebView2 virtual host (`https://aitool.local`) that never
touches the network.

## 10. Checklist before approving

- [ ] Choose the AI provider — or a local model — and review its data-usage policy
- [ ] Decide whether the write tools are enabled at all
- [ ] Decide whether `run_query` is enabled, and whether to point the addon at a read-only
      SQL login
- [ ] Accept that three tables are created in the company database, with no retention policy
      (or schedule your own purge)
- [ ] Decide the Sentry DSN (default: none)
- [ ] Know the removal path: delete the folder, remove the Extensibility row; the three
      tables survive by design
- [ ] Note that the installer is not code-signed today — SmartScreen will warn, and the
      SHA256 published with each release is how you verify the download
