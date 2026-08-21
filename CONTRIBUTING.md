# Contributing

[English](#english) • [Português](#português)

---

## English

AITOOL is free to use under the [Community License](LICENSE) and its source is not public.
The way to contribute is feedback, and it matters: every tool, prompt rule and guard in the
product came from someone saying what did not work.

### Report a problem

Open an issue in [BolaLabs/AITOOL](https://github.com/BolaLabs/AITOOL/issues) with:

- the AITOOL version (settings modal, bottom line) and the Primavera v10 build
- the prompt you typed and what the assistant answered or did
- the relevant lines from `%LocalAppData%\Cegid\Extensions\AITOOL\Logs\` — keys are never
  written there, but check for customer names before pasting

Security issues go through [SECURITY.md](SECURITY.md), not the public tracker.

### Suggest something

GitHub Discussions is the place for ideas, questions and "would it be possible to".
[ROADMAP.md](ROADMAP.md) lists what is already planned, so you can see whether your idea is
on it.

### Development (source access)

The rest of this document is for people who build from the source under a source licence —
see [COMMERCIAL.md](COMMERCIAL.md). It targets .NET Framework 4.8, WinForms, DevExpress 21.2.3
and ERP Primavera v10.

#### Development Setup

- Visual Studio 2022 or newer (MSBuild 17.x or later; the solution file is currently saved by VS 18)
- .NET Framework 4.8 Developer Pack
- DevExpress WinForms 21.2.3 installed
- Edge WebView2 Runtime

#### Branching and Commits

- Branch from `main`; use feature branches: `feat/<short-name>`, `fix/<short-name>`
- **Conventional Commits**: `feat(scope):`, `fix(scope):`, `docs(scope):`, `refactor(scope):`, `perf(scope):`, `test(scope):`, `build(scope):`
- Scopes: openai, chat, erp, sql, grid, di, config, ui, tools, export, webview2, telemetry
- Keep commits small and descriptive; reference issues where applicable

#### Coding Standards

- .NET Framework 4.8 only (no .NET 5+ APIs)
- Use `async/await` with `ConfigureAwait(false)` in libraries
- Parameterize all SQL; keep NOLOCK where existing logic relies on it
- Implement proper Dispose pattern and event handler cleanup
- DevExpress: virtual mode for >1000 rows; reuse repository items

#### Telemetry & Logging

- Use `TelemetryService` (NLog backend) for all logs
- DEBUG: verbose local file; RELEASE: Info+ to the local file, Error+ to Sentry (via Sentry.NLog)
- No direct `SentrySdk` or `Debug.WriteLine` calls

#### Verification

There are no test projects, and that is deliberate: almost every code path either drives the
ERP object model or the WinForms/WebView2 UI, neither of which is meaningfully testable
outside a running Primavera. Verification is three steps instead:

- A clean build with 0 errors.
- The static guards in `scripts/checks/`. Four reflect over a compiled assembly to assert the
  SQL guard shape and the audit matrix — two of them take a mandatory `-BuildOutput`. Three
  run on the source tree instead, covering the `Lib/` closure, the EN/PT mirrors and version
  coherence. Invocations are in [scripts/checks/README.md](scripts/checks/README.md).
- The scenarios in `scripts/e2e/golden-set.md` against a live ERP, for anything touching
  tools, ERP automation, streaming or cancellation.

#### Pull Request Process

1. Ensure solution builds with 0 errors
2. Run the relevant `scripts/checks/` guards, and the golden-set scenarios your change touches
3. Update documentation if needed
4. Describe WHY, WHAT, HOW in the PR description
5. Link related issues; include screenshots for UI changes

#### Documentation languages

English is canonical. Three documents ship with a Portuguese mirror — `README.pt.md`,
`INSTALL.pt.md` and `docs/SECURITY-AND-PRIVACY.pt.md`; everything else is English-only.
Day-to-day PRs only need to touch the English file; the mirrors are brought back in sync
at release time, and `scripts/checks/Test-DocsSync.ps1` (run automatically by
`Installer/build-installer.ps1`) fails the release build while a mirror lags its
original. If your PR edits one of the three mirrored files and you can update the
translation in the same PR, do — otherwise the release step catches it.

---

## Português

O AITOOL é gratuito ao abrigo da [Licença Community](LICENSE.pt) e o código não é público. A
forma de contribuir é o feedback, e conta: cada ferramenta, regra de prompt e guarda do
produto veio de alguém a dizer o que não funcionou.

### Reportar um problema

Abra um issue em [BolaLabs/AITOOL](https://github.com/BolaLabs/AITOOL/issues) com:

- a versão do AITOOL (janela de definições, última linha) e a build do Primavera v10
- o que escreveu e o que o assistente respondeu ou fez
- as linhas relevantes de `%LocalAppData%\Cegid\Extensions\AITOOL\Logs\` — as chaves nunca
  são escritas lá, mas verifique nomes de clientes antes de colar

Problemas de segurança seguem por [SECURITY.md](SECURITY.md), não pelo tracker público.

### Sugerir algo

As GitHub Discussions são o sítio para ideias, dúvidas e "seria possível". O
[ROADMAP.md](ROADMAP.md) lista o que já está planeado.

### Desenvolvimento (acesso ao código)

O resto deste documento é para quem compila a partir do código com uma licença de código —
ver [COMMERCIAL.md](COMMERCIAL.md). Usa .NET Framework 4.8, WinForms, DevExpress 21.2.3 e ERP
Primavera v10.

#### Ambiente de Desenvolvimento

- Visual Studio 2022 ou mais recente (MSBuild 17.x ou superior; o ficheiro de solução está gravado pelo VS 18)
- .NET Framework 4.8 Developer Pack
- DevExpress WinForms 21.2.3 instalado
- WebView2 Runtime

#### Branches e Commits

- Criar branches a partir de `main`: `feat/<nome-curto>`, `fix/<nome-curto>`
- **Conventional Commits**: `feat(scope):`, `fix(scope):`, `docs(scope):`, `refactor(scope):`, `perf(scope):`, `test(scope):`, `build(scope):`
- Scopes: openai, chat, erp, sql, grid, di, config, ui, tools, export, webview2, telemetry
- Commits pequenos e descritivos; referenciar issues quando aplicável

#### Padrões de Código

- Apenas .NET Framework 4.8 (sem APIs .NET 5+)
- Usar `async/await` com `ConfigureAwait(false)` nas bibliotecas
- Queries SQL sempre parametrizadas; manter NOLOCK quando necessário
- Padrão de Dispose e limpeza de event handlers
- DevExpress: modo virtual para >1000 linhas; reutilização de repository items

#### Telemetria & Logging

- Usar `TelemetryService` (backend NLog) para todos os logs
- DEBUG: ficheiro local verboso; RELEASE: Info+ no ficheiro local, Error+ para o Sentry (via Sentry.NLog)
- Não usar diretamente `SentrySdk` ou `Debug.WriteLine`

#### Verificação

Não há projetos de teste, e é deliberado: quase tudo o que interessa depende de um ERP a
correr. A verificação tem três passos:

- Build limpo com 0 erros.
- Os guards estáticos em `scripts/checks/`. Quatro refletem sobre uma assembly compilada (dois
  exigem `-BuildOutput`); três correm sobre a árvore de código (closure de `Lib/`, espelhos
  EN/PT, coerência de versões). Invocações em [scripts/checks/README.md](scripts/checks/README.md).
- Os cenários de `scripts/e2e/golden-set.md` contra um ERP real, para tudo o que toque em
  tools, automação do ERP, streaming ou cancelamento.

#### Processo de Pull Request

1. Garantir build da solução com 0 erros
2. Correr os guards de `scripts/checks/` e os cenários do golden set
3. Atualizar documentação se necessário
4. Descrever PORQUÊ, O QUÊ e COMO na descrição do PR
5. Incluir screenshots para mudanças de UI quando aplicável

#### Idiomas da documentação

O inglês é canónico. Três documentos têm espelho em português — `README.pt.md`,
`INSTALL.pt.md` e `docs/SECURITY-AND-PRIVACY.pt.md`; o resto é só em inglês. No
dia a dia basta tocar no ficheiro inglês; os espelhos sincronizam-se na release,
e o `scripts/checks/Test-DocsSync.ps1` (corrido automaticamente pelo
`Installer/build-installer.ps1`) chumba o build da release enquanto um espelho
estiver atrasado. Se o PR mexe num dos três ficheiros espelhados e der para
atualizar a tradução no mesmo PR, melhor — senão, a release apanha.

---

## Code of Conduct

Please read our [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md) before contributing.

## Questions?

If you have questions, feel free to open a GitHub Discussion or Issue.
