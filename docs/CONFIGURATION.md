# AITOOL Configuration

All projects read configuration through `Shared.Config` (`AITOOL.SharedConfig.UnifiedConfig`), which merges JSON files and resolves each value with a strict precedence order:

1. Environment variables (e.g. `OPENROUTER_API_KEY`, `AITOOL_AI_PROVIDER`)
2. `appsettings.User.json` — per-user settings, written by the settings modal
3. `appsettings.{Environment}.json` — placed in the addon folder (overrides the base file)
4. `appsettings.json` — placed in the addon folder (base)
5. Built-in defaults (provider presets and code defaults)

## Where the files live

| File | Location | Written by |
| --- | --- | --- |
| `appsettings.json`, `appsettings.{Environment}.json` | the addon folder, next to `AITOOL.dll` (`<SG100>\Config\EV\Extensions\AITOOL\`) | you, from the `*.example.json` templates. Neither is produced by the build or carried by the setup, and both are gitignored; read-only at runtime |
| `appsettings.User.json` | `%LocalAppData%\Cegid\Extensions\AITOOL\` | the settings modal |
| `secrets.dat` | `%LocalAppData%\Cegid\Extensions\AITOOL\` | the settings modal (DPAPI-encrypted) |

The addon folder is resolved from `Shared.Config.dll`'s own location, not from the process directory: the ERP hosts the addon, so `AppDomain.BaseDirectory` and the working directory both point at Primavera's `Apl` folder rather than at the addon.

The app never writes to the shipped files. That folder can sit under `C:\Program Files` (admin-only), and every build overwrites its copies, so user settings would be lost on the next deploy. Everything the app writes goes to the per-user folder — see [SECURITY.md](../SECURITY.md).

The environment is `Development` in DEBUG builds and `Production` in RELEASE builds, overridable via `AITOOL_ENVIRONMENT` (falls back to `DOTNET_ENVIRONMENT`, then `ASPNETCORE_ENVIRONMENT`).

Real appsettings files must be plain JSON without comments: a malformed file is skipped (the reason is traced) and every setting in it reverts to a default. Comments are allowed only in the committed `*.example.json` templates and must be removed when copying.

## Provider section (current schema)

```json
{
  "Provider": {
    "Active": "openrouter",
    "openrouter": {
      "ApiKey": "",
      "BaseUrl": "https://openrouter.ai",
      "Model": "openai/gpt-5.6-sol",
      "ReasoningEffort": "Off"
    }
  }
}
```

- `Provider:Active` (string): active provider id. Four presets exist — `openai`, `openrouter`, `anthropic`, `lmstudio`. Any other id is accepted and treated as an OpenAI-compatible endpoint, reading its key from the `AI_` environment prefix. When absent, the provider is detected from the configured base URL. Env override: `AITOOL_AI_PROVIDER`.
- `Provider:{id}:ApiKey` (string): key for that provider. Prefer the in-app encrypted store or the env variable (`OPENAI_API_KEY`, `OPENROUTER_API_KEY`, `ANTHROPIC_API_KEY`, `LMSTUDIO_API_KEY`). For the `openai` id, the key is read from the legacy `OpenAI:ApiKey` instead.
- `Provider:{id}:BaseUrl` (string): optional; defaults to the provider preset.
- `Provider:{id}:Model` (string): model id, free text. OpenRouter uses the `vendor/model` format; falls back to `OpenAI:Model` when empty. A fresh install starts on `openai/gpt-5.6-sol` (OpenRouter) or `gpt-5.6-sol` (OpenAI direct) — 1M of context. A model the provider's catalogue does not describe is assumed to hold 128k.
- `Provider:{id}:ReasoningEffort` (string): `Off` | `Low` | `Medium` | `High` | `Max`, shown as Desligado / Rápido / Equilibrado / Profundo / Máximo (where the provider supports it). What each level sends on the wire is read from the provider's catalogue for the selected model: `Off` becomes `none` or `minimal` where the model accepts one of them, because a reasoning model left at its default thinks before it streams anything; `Max` becomes `max`, or `xhigh` on the generation that took that, or `high`. The choice is stored per provider *and model* (`{id}|{model}` at runtime), so changing model and back restores it. The chip beside the message box, the header popover and Settings change the same value.

### Provider presets (built-in defaults)

| Provider | BaseUrl | PathPrefix | AuthMode |
| --- | --- | --- | --- |
| OpenAI | `https://api.openai.com` | *(none)* | `Bearer` |
| OpenRouter | `https://openrouter.ai` | `api` | `Bearer` |
| Anthropic | `https://api.anthropic.com` | *(native adapter)* | `Header` (x-api-key) |
| LM Studio | `http://localhost:1234` | `v1` | `None` |

`PathPrefix` and `AuthMode` are resolved from the preset of the active provider; the `OpenAI:PathPrefix` / `OpenAI:AuthMode` keys exist only to override them for custom endpoints. Do not set them for the known providers.

## Legacy OpenAI section

`OpenAI:ApiKey`, `OpenAI:BaseUrl` and `OpenAI:Model` configure the `openai` provider only (kept for backward compatibility). The remaining keys are global for all OpenAI-compatible providers:

- `OpenAI:TimeoutSeconds` (int, default 100): how long the model may go **without sending
  anything** before the turn is cut. It is an inactivity budget, not a cap on the call: every
  chunk of answer or reasoning pushes the deadline out again, so a model that thinks for
  minutes and then replies is not interrupted, while one that goes silent is. The HTTP clients
  keep a 10-minute ceiling behind it. Env: `OPENAI_TIMEOUT`.
- `OpenAI:StreamingEnabled` (bool): enable server-sent streaming when supported. Env: `OPENAI_STREAMING`.
- `OpenAI:AdditionalHeaders` (object): extra headers sent on every request (e.g. OpenRouter attribution headers `HTTP-Referer` and `X-Title`).

## Sentry section

- `Sentry:Dsn` (string): empty disables Sentry. Env: `SENTRY_DSN`.
- `Sentry:Environment` (string): `Development` | `Staging` | `Production`. Env: `SENTRY_ENVIRONMENT`.
- `Sentry:Debug` (bool): verbose SDK diagnostics (not gated by build configuration). Env: `SENTRY_DEBUG_MODE`.

RELEASE builds send Error/Critical events plus release-health sessions and a 10% trace sample;
event payloads are sanitized by `TelemetryInitializer`.

## Sql section

- `Sql:Encrypt` (bool): `true` in Production. Env: `AITOOL_SQL_ENCRYPT`.
- `Sql:TrustServerCertificate` (bool): `false` in Production (use proper certificates); `true` is typical for local dev. Env: `AITOOL_SQL_TRUST_SERVER_CERT`.
- `Sql:TimeoutSeconds` (int, default 30): command timeout. Env: `AITOOL_SQL_TIMEOUT`.

## Sections managed by the app

- `Assistant:*` — chat/runtime settings (max tokens, temperature, streaming, theme, export options, disabled tools). Written by the settings UI; do not pre-create it in templates. Most of it is read from the files only; the web-search and enrichment keys below are the exceptions and accept environment overrides.
- `ErpTools:Enabled` (bool, default `true`): kill switch for ERP tool calling. Set it to `false` to run the assistant as a plain chat with no ERP access. Env: `AITOOL_ERP_TOOLS_ENABLED`.

## Environment variables the code reads

| Family | Variables | Setting overridden | Default |
| --- | --- | --- | --- |
| Provider | `{OPENAI,OPENROUTER,ANTHROPIC,LMSTUDIO}_API_KEY` (`AI_API_KEY` for a custom id), `{PREFIX}_BASE_URL`, `{PREFIX}_MODEL`, `{PREFIX}_REASONING_EFFORT`, `AITOOL_AI_PROVIDER` | `Provider:{id}:ApiKey` / `BaseUrl` / `Model` / `ReasoningEffort`, `Provider:Active` | preset |
| HTTP | `OPENAI_TIMEOUT`, `OPENAI_STREAMING` | `OpenAI:TimeoutSeconds`, `OpenAI:StreamingEnabled` | `100`, `true` |
| Web search | `AITOOL_WEBSEARCH_MODE`, `AITOOL_WEBSEARCH_PROVIDERS` (legacy singular `AITOOL_WEBSEARCH_PROVIDER`), `AITOOL_WEBSEARCH_TIMEOUT` (ms), `AITOOL_WEBSEARCH_NATIVE_MAXUSES` | `Assistant:WebSearch:Mode` / `Providers` / `TimeoutMs` / `Native:MaxUses` | `fanout`, `tavily`, `15000`, `5` |
| Web search endpoints | `AITOOL_WEBSEARCH_{BRAVE,EXA,SERPER,TAVILY}_ENDPOINT` | `Assistant:WebSearch:{Brave,Exa,Serper,Tavily}Endpoint` | the provider's public API URL |
| SearXNG | `AITOOL_WEBSEARCH_SEARXNG_BASEURL`, `AITOOL_WEBSEARCH_SEARXNG_ALLOWINSECURE` | `Assistant:WebSearch:Searxng:BaseUrl` / `AllowInsecure` | unset, `false` |
| Enrichment (`enrich_entity`) | `AITOOL_ENRICHMENT_VIES_ENABLED`, `AITOOL_ENRICHMENT_NIFPT_ENABLED`, `AITOOL_ENRICHMENT_TIMEOUT` (ms), `AITOOL_ENRICHMENT_CACHE_TTL_MINUTES`, `AITOOL_ENRICHMENT_CODE_RULE`, `AITOOL_ENRICHMENT_STRICT_ERP_CHECK` | `Assistant:Enrichment:Vies:Enabled` / `NifPt:Enabled` / `TimeoutMs` / `CacheTtlMinutes` / `CodeRule` / `StrictErpCheck` | `true`, `true`, `4000`, `1440`, `hybrid`, `false` |
| SQL | `AITOOL_SQL_ENCRYPT`, `AITOOL_SQL_TRUST_SERVER_CERT`, `AITOOL_SQL_TIMEOUT` | `Sql:*` (see above) | as above |
| Sentry | `SENTRY_DSN`, `SENTRY_ENVIRONMENT`, `SENTRY_DEBUG_MODE` | `Sentry:*` (see above) | unset |
| Tools, environment | `AITOOL_ERP_TOOLS_ENABLED`, `AITOOL_ENVIRONMENT` | `ErpTools:Enabled`, the environment name | `true`, by build |

Web-search API keys themselves are read from the encrypted store or `Assistant:WebSearch:*` in the files, not from the environment.

## Developer setup

1. Copy `appsettings.Development.example.json` to `appsettings.Development.json` and remove all comments.
2. Set the provider key in-app (preferred), via env variable, or in `Provider:{id}:ApiKey` for convenience. Never commit real appsettings files — they are git-ignored.
3. Build and run. In DEBUG, `appsettings.Development.json` is copied to the output on every build, overwriting UI-persisted changes in the extension folder; keep the repo-root file as the source of truth for dev. Encrypted keys are unaffected.

## Production deployment

Ship `appsettings.Production.json` alongside the executable only if you need non-default settings (it is not copied by the build). API keys are entered in-app by each user and stored encrypted; leave `ApiKey` empty in deployed files.
