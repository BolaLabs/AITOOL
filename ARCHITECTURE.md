# Architecture (EN)

This repository hosts a WinForms extension for ERP Primavera v10 targeting .NET Framework 4.8 with DevExpress WinForms 21.2.3. The UI is classic WinForms with a modern chat surface powered by WebView2. Telemetry is centralized via NLog with Sentry integration for RELEASE builds.

## Solution layout

- **AITOOL** (WinForms app): Modular structure organized by domain/functionality:
  - `/AI` - Provider abstraction (`Providers/`), ViewModels, Services, Tools
  - `/Chat` - Chat functionality (Models, Repository, Services, ViewModels, Export)
  - `/ERP` - Primavera integration (Editores, Services, automation)
  - `/Common` - Shared utilities (Extensions, Helpers, Utils, Models, Results, Data)
  - `/UI` - User interface (Forms, Dialogs, Resources, Views, Messaging, Services)
  - `/Infrastructure` - DI (ServiceProviderFactory, ServiceConfigurator)
- **Shared.Config** (class library): TelemetryService (NLog backend), TelemetryInitializer (Sentry), UnifiedConfig, ConfigurationService, ProviderPresets, ModelCapabilities
- **OpenAI.SDK** (class library): Standalone Betalgo OpenAI client (no dependency on AITOOL)
- **ReportEngine** (class library): Crystal Reports wrapper behind the official document PDFs
- **Installer** (build-only project): drives the Inno Setup build; only built under the `Installer` solution configuration

## Core data flow

1) User interacts with chat in WebView2 (HTML/JS)
2) JS posts messages to C# via WebView2 WebMessageReceived
3) ChatAIViewModel builds a message chain and serializes ERP context (JSON)
4) ToolCallOrchestrator (Chat/Services) runs the turn: streams via the provider abstraction, executes ERP tool calls (up to the iteration cap), replays the tool transcript on continuations, and owns per-turn cancellation
5) Streaming deltas are marshaled back to JS for progressive rendering
6) TelemetryService logs request/response, timings, and token usage

## WebView2 integration

- The chat surface (`UI/Resources/Chat/index.html`) is served from a WebView2 virtual host (`https://aitool.local` mapped onto the loose `UI\Resources\Chat` folder next to AITOOL.dll), giving the page a real origin
- marked, DOMPurify, highlight.js and Mermaid are vendored under `UI/Resources/Chat/vendor/` with pinned versions and SRI hashes — the chat renders fully offline; the CSP allows no CDN hosts
- Fallback: when the loose folder is missing, the embedded copy of index.html loads via NavigateToString and rendering degrades gracefully (plain text, no vendor libs)
- JavaScript communicates with C# using PostWebMessageAsJson; C# replies via ExecuteScriptAsync
- UTF-8 safety: when rendering HTML inside iframes, we inject <meta charset="UTF-8"> and common CSS using an injectStyle() helper to prevent garbled characters

## OpenAI usage

- Provider abstraction (OpenAI / OpenRouter / native Anthropic / OpenAI-compatible) with streaming
- Temperature defaults to 0.7 (configurable in-app; gated off for reasoning models)
- Context window optimization with a sliding window and a token safety margin
- ERP context is consolidated into a single System message with explicit validation rules and JSON fences

## Telemetry and logging

- Centralized via Shared.Config.TelemetryService (NLog 6.x)
- DEBUG: Trace..Fatal to local rolling file; RELEASE: Info..Fatal to file, Error..Fatal to Sentry (Sentry.NLog)
- BeforeSend/BeforeBreadcrumb hooks sanitize secrets and reduce noise
- Use TelemetryService.LogDebug/Info/Warning/Error/Fatal and AddBreadcrumb

## ERP integration safety

- Never write directly to ERP core tables. Writes go through the Primavera BSO object model,
  in `ERP/Services/ErpCreationService.cs`:
  - `commit=false` runs the ERP's own `ValidaActualizacao` and returns a preview, saving nothing
  - `commit=true` calls `Actualiza` on the BSO, so the ERP assigns numbers and enforces its rules
  - Commits are single-flight; a second concurrent commit is refused
  - Every commit, refusal and failure is written to `AI_AuditLog` by `ErpToolsService`
- The commit is gated in `ErpToolsService`: the preview pass makes `WriteConfirmationStore`
  issue a single-use token (15 minutes, bound to a hash of tool + arguments), the card built
  by `WriteConfirmationCard` carries it, and the user's click returns it as
  `_confirm_token`. `TryConsume` must match before `commit=true` runs; a `confirm=true` call
  without it is refused and audited as `Recusou (sem confirmação no cartão)`. The model never
  sees the token. See SECURITY.md.

## Performance rules

- DevExpress: server-side filtering/sorting; virtual mode for large grids; repository item reuse
- SQL Server: parameterized queries; NOLOCK where existing behavior relies on it; avoid ballooning LOH allocations
- Token management: enforce headroom for response generation; compact context where possible

## Build/compatibility

- .NET Framework 4.8 only; DevExpress WinForms 21.2.3; ERP Primavera v10 SDK
- Do not introduce .NET 5+ APIs or WPF
- Keep OpenAI.SDK independent from AITOOL (no cross-references)

## Packaging/deploy

- Costura.Fody (6.2) embeds most NuGet dependencies into AITOOL.dll (~17 MB) and removes their loose copies from the output; DevExpress*, Shared.Config, ReportEngine and a few runtime libraries are excluded and ship loose
- Deploys must mirror the FULL build output folder into `…\SG100\Config\<EV|LE|LP>\Extensions\AITOOL` (one folder per installed edition, including `UI\Resources\Chat`), removing files that are no longer produced — a stale loose DLL shadows its embedded replacement because the CLR probes the app-base folder first

---

# Arquitetura (PT)

Este repositório contém uma extensão WinForms para o ERP Primavera v10 direcionada ao .NET Framework 4.8 com DevExpress WinForms 21.2.3. A UI é WinForms clássico com uma superfície moderna de chat suportada por WebView2. A telemetria é centralizada via NLog com integração Sentry para builds RELEASE.

## Estrutura da solução

- **AITOOL** (WinForms app): Estrutura modular organizada por domínio/funcionalidade:
  - `/AI` - Abstração de fornecedores (`Providers/`), ViewModels, Services, Tools
  - `/Chat` - Funcionalidade de chat (Models, Repository, Services, ViewModels, Export)
  - `/ERP` - Integração Primavera (Editores, Services, automação)
  - `/Common` - Utilitários partilhados (Extensions, Helpers, Utils, Models, Results, Data)
  - `/UI` - Interface de utilizador (Forms, Dialogs, Resources, Views, Messaging, Services)
  - `/Infrastructure` - DI (ServiceProviderFactory, ServiceConfigurator)
- **Shared.Config** (biblioteca): TelemetryService (NLog), TelemetryInitializer (Sentry), UnifiedConfig, ConfigurationService, ProviderPresets, ModelCapabilities
- **OpenAI.SDK** (biblioteca): Cliente Betalgo OpenAI standalone (sem dependência do AITOOL)
- **ReportEngine** (biblioteca): Wrapper de Crystal Reports por trás dos PDFs oficiais
- **Installer** (projeto só de build): conduz a construção do Inno Setup; só é compilado na configuração `Installer` da solução

## Fluxo de dados principal

1) Utilizador interage com o chat no WebView2 (HTML/JS)
2) JS comunica com C# via WebMessageReceived
3) ChatAIViewModel constrói a cadeia de mensagens e serializa o contexto ERP (JSON)
4) ToolCallOrchestrator (Chat/Services) executa o turno: streaming via a abstração de fornecedores, execução das ferramentas ERP (até ao limite de iterações), replay do transcript nas continuações, e cancelamento por turno
5) Deltas de streaming são enviados de volta para JS para rendering progressivo
6) TelemetryService regista pedido/resposta, tempos e uso de tokens

## Integração WebView2

- A superfície de chat (`UI/Resources/Chat/index.html`) é servida por um virtual host do WebView2 (`https://aitool.local` mapeado para a pasta solta `UI\Resources\Chat` ao lado do AITOOL.dll), dando um origin real à página
- marked, DOMPurify, highlight.js e Mermaid estão vendorizados em `UI/Resources/Chat/vendor/` com versões fixas e hashes SRI — o chat renderiza totalmente offline; a CSP não permite hosts CDN
- Fallback: se a pasta solta faltar, a cópia embebida do index.html carrega via NavigateToString e o rendering degrada graciosamente (texto simples, sem bibliotecas vendorizadas)
- JavaScript comunica com C# usando PostWebMessageAsJson; C# responde via ExecuteScriptAsync
- Segurança UTF-8: ao renderizar HTML em iframes, injetamos <meta charset="UTF-8"> e CSS comum com a função injectStyle() para evitar caracteres corrompidos

## Uso do OpenAI

- Abstração de fornecedores (OpenAI / OpenRouter / Anthropic nativo / compatível) com streaming
- Temperature por defeito 0.7 (configurável na app; desativada em modelos de raciocínio)
- Otimização da janela de contexto com sliding window e margem de segurança de tokens
- Contexto ERP consolidado numa única System message com regras explícitas de validação e fences JSON

## Telemetria e logging

- Centralizado via Shared.Config.TelemetryService (NLog 6.x)
- DEBUG: Trace..Fatal para ficheiro local rotativo; RELEASE: Info..Fatal para ficheiro, Error..Fatal para Sentry (Sentry.NLog)
- Hooks BeforeSend/BeforeBreadcrumb sanitizam segredos e reduzem ruído
- Usar TelemetryService.LogDebug/Info/Warning/Error/Fatal e AddBreadcrumb

## Segurança na integração ERP

- Nunca escrever diretamente nas tabelas core do ERP. As escritas passam pelo modelo de
  objetos BSO da Primavera, em `ERP/Services/ErpCreationService.cs`:
  - `commit=false` corre o `ValidaActualizacao` do próprio ERP e devolve uma pré-visualização, sem gravar
  - `commit=true` chama `Actualiza` no BSO, para o ERP atribuir números e aplicar as suas regras
  - As gravações são single-flight; uma segunda gravação concorrente é recusada
  - Cada gravação, recusa e falha é registada em `AI_AuditLog` pelo `ErpToolsService`
- O commit tem portão no `ErpToolsService`: a passagem de pré-visualização faz o
  `WriteConfirmationStore` emitir uma autorização de uso único (15 minutos, ligada a um hash
  de tool + argumentos), o cartão construído pelo `WriteConfirmationCard` transporta-a, e o
  clique do utilizador devolve-a como `_confirm_token`. O `TryConsume` tem de coincidir antes
  de o `commit=true` correr; uma chamada com `confirm=true` sem ela é recusada e auditada como
  `Recusou (sem confirmação no cartão)`. O modelo nunca vê a autorização. Ver SECURITY.md.

## Regras de performance

- DevExpress: filtragem/ordenação no servidor; modo virtual para grelhas grandes; reutilização de RepositoryItems
- SQL Server: queries parametrizadas; manter NOLOCK onde o comportamento existente depende disso; evitar alocações LOH
- Gestão de tokens: reservar espaço para a resposta; compactar contexto quando possível

## Build/compatibilidade

- Apenas .NET Framework 4.8; DevExpress WinForms 21.2.3; SDK do ERP Primavera v10
- Não introduzir APIs .NET 5+ ou WPF
- Manter OpenAI.SDK independente do AITOOL (sem referências cruzadas)

## Empacotamento/deploy

- O Costura.Fody (6.2) embebe a maioria das dependências NuGet no AITOOL.dll (~17 MB) e remove as cópias soltas do output; DevExpress*, Shared.Config, ReportEngine e algumas bibliotecas de runtime estão excluídos e seguem soltos
- O deploy tem de espelhar a pasta de output COMPLETA para `…\SG100\Config\<EV|LE|LP>\Extensions\AITOOL` (uma pasta por edição instalada, incluindo `UI\Resources\Chat`), removendo ficheiros que já não são produzidos — um DLL solto obsoleto faz shadowing da cópia embebida porque o CLR sonda primeiro a pasta base

