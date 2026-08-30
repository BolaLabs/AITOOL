# Security Policy

## Supported Versions

| Version | Supported |
| ------- | --------- |
| 2.11.x  | Yes       |
| 2.10.x  | Yes       |
| < 2.10  | No        |

This table is verified by `scripts/checks/Test-VersionCoherence.ps1`, which fails when the
version stamped in `Properties/AssemblyInfo.cs` is not listed here.

## Reporting a Vulnerability

We take security vulnerabilities seriously. If you discover a security issue, please follow responsible disclosure practices:

### How to Report

1. **DO NOT** create a public GitHub issue for security vulnerabilities
2. Open a private advisory at
   `https://github.com/BolaLabs/AITOOL/security/advisories/new`, or email
   <bruno@bolalabs.pt>
3. Include:
   - Description of the vulnerability
   - Steps to reproduce
   - Potential impact
   - Suggested fix (if any)

### What to Expect

- **Acknowledgment**: We will acknowledge receipt within 48 hours
- **Assessment**: We will assess the vulnerability within 7 days
- **Resolution**: Critical vulnerabilities will be prioritized and patched as soon as possible
- **Credit**: You will be credited for responsible disclosure (unless you prefer anonymity)

## Security Best Practices

This project follows these security practices:

### Credential storage

- API keys entered in the app are encrypted at rest with **Windows DPAPI**
  (`ProtectedData`, `CurrentUser` scope) and written to
  `%LocalAppData%\Cegid\Extensions\AITOOL\secrets.dat`. They are **never** written to
  `appsettings` in plain text, never logged, and never sent to BolaLabs — only to the AI
  provider you configured.
- DPAPI ciphertext is per-user and per-machine: it cannot be decrypted by another user or
  on another machine. A corrupt/foreign secrets file degrades gracefully to "no saved key".
- Optional fallbacks for unattended/dev setups: environment variables
  (`OPENAI_API_KEY`, `OPENROUTER_API_KEY`, `ANTHROPIC_API_KEY`, `LMSTUDIO_API_KEY`, `AI_*` for a custom endpoint) or `appsettings`. Prefer the
  encrypted in-app store; never commit a key.
- The settings UI offers a show/hide toggle and masks the stored key.

### Data sent to AI providers

- Chat messages, the system prompt (which carries the company code, the user and the
  currently open ERP window) and every tool result — including customer names, tax numbers,
  balances and SQL result rows — are sent to the provider **you** configure, over TLS. It is
  what the assistant retrieved to answer that question, not a bulk export. Review the
  provider's data-usage policy.
- Nothing is sent to BolaLabs at any point. There is no licence check, no update check and
  no telemetry endpoint of ours.
- Pointing the addon at a local OpenAI-compatible endpoint keeps all of it on the machine.

### ERP access

- **Writes exist and are deliberate.** The assistant can create customer and supplier
  records and sales documents, update records, and drive ERP windows. It cannot create
  purchase documents or articles, post accounting entries, delete anything, or write
  directly to ERP tables — writes go through the Primavera BSO object model
  (`ErpCreationService`), so the ERP's own validation runs and document numbers are
  ERP-assigned. Commits are single-flight.
- **How confirmation actually works.** Write tools take a `confirm` flag. With it false the
  ERP validates the draft and returns a preview without saving; with it true the record is
  committed. The flag is set by the assistant, following a system-prompt instruction to set
  it only after the user agrees in the chat. Today there is no code path that blocks a
  commit on a user gesture: this is a model-instruction boundary, not a UI gate, and a model
  that ignores the instruction can commit in one step. A hard UI confirmation is on the
  roadmap. Every commit — and every refused commit — is recorded in `AI_AuditLog`.
- **Kill switches.** Individual tools can be disabled (`Assistant:DisabledTools`), or the
  whole ERP tool layer (`ErpTools:Enabled=false`) for plain chat with no ERP access.
- **SQL is read-only by application guard, not by database permission.** `run_query` accepts
  only `SELECT`/`WITH`, strips comments and brackets before matching, rejects statement
  stacking, and caps rows at 500 — but it runs on the ERP's own connection, which is a
  privileged login. Companies wanting a second barrier should point the addon at a read-only
  SQL login.
- All other database access uses parameterized queries.

### What is stored in your database

Three tables are created automatically in the ERP company database on first use:
`AI_ChatSessions`, `AI_ChatMessages` and `AI_AuditLog`. Message content is stored in plain
text and contains whatever the conversation contained, including ERP data returned by tools.
The audit detail holds the serialized tool arguments with key/token/secret/password values
redacted, truncated at 2000 characters. **There is no retention policy and no purge job** —
sessions can be deleted individually from the UI, nothing expires, and the data survives
uninstalling the addon.

### Prompt injection

ERP fields, SQL results and web pages are text an attacker can influence, and all three
reach the model. Mitigations: a spotlighting rule in the system prompt that treats tool
output as data and never as instructions, `untrusted_content` marking on web results, and
telemetry on injection markers. Residual risk: a successful injection could cause a tool
call the user did not intend, bounded by the tool set, the SQL guard, the commit-button gate
and the audit trail — not by a confirmation dialog. See the confirmation note above.

### Telemetry & Logging

- **No Sentry DSN ships.** In a default install nothing is sent anywhere. When an operator
  configures a DSN, RELEASE builds send Error-level events (sanitized), release-health
  sessions and a 10% sample of performance traces; no chat content.
- Sensitive data (API keys, passwords, connection strings) is redacted before logging or
  sending
- Local logs live in `%LocalAppData%\Cegid\Extensions\AITOOL\Logs\` with 7-day retention and
  are never uploaded. Web-search queries are not logged.

### Configuration Security

```
# Files that should NEVER be committed:
appsettings.json
appsettings.Development.json
appsettings.Production.json

# Safe to commit (templates with empty values):
appsettings.example.json
appsettings.Development.example.json
appsettings.Production.example.json
```

## Third-Party Dependencies

This project uses the following third-party components:

| Component | Security Considerations |
|-----------|------------------------|
| OpenAI SDK (Betalgo) | API keys stored securely |
| WebView2 | Runs in Edge sandbox; navigation is default-deny |
| DevExpress | Licensed commercial component, redistributed with the setup |
| FlaUI (UIA3) | Drives the ERP's own windows; every mutating action is audited |
| System.Data.SqlClient | Runs on the ERP's connection; `run_query` is read-only by application guard |
| Costura.Fody | Embeds dependencies into the assembly at build time |
| marked, DOMPurify, highlight.js, Mermaid | Vendored with pinned versions and SRI hashes; no CDN |
| NLog | Local file logging only |
| Sentry | Error tracking with sanitization |

## Security Updates

- We monitor security advisories for all dependencies
- NuGet packages are kept up-to-date with security patches
- Critical security updates are prioritized over feature development

## Contact

For security-related inquiries:

- **Email**: `bruno@bolalabs.pt`
- **Maintainer**: Bruno Marques - BolaLabs
- **Non-sensitive matters**: Open a GitHub issue
