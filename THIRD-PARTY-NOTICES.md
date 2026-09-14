# Third-Party Notices

AITOOL is licensed under the [AITOOL Community License](LICENSE). **That licence covers only
the software authored by Bruno Marques / BolaLabs.** It does **not** apply
to, and grants no rights in, the third-party components listed below (including the
Primavera/Cegid ERP SDK, DevExpress and other commercial libraries), each of which
remains governed by its own license. No Cegid or SAP binary is redistributed by this
project — those are provided by the Primavera host environment at runtime, or are
build-time prerequisites you must obtain under your own license. The one commercial
component the setup does carry is the DevExpress WinForms runtime, under DevExpress's
redistribution terms; see [DISTRIBUTION.md](DISTRIBUTION.md).

This is a good-faith inventory; each component is authoritative for its own terms.

## Host-provided / build prerequisites (commercial)

| Component | Owner | Role | How it is obtained |
| ----------- | ------- | ------ | -------------------- |
| Primavera / Cegid ERP SDK (`Primavera.Extensibility.*`, `*US100.dll`, `Std*100.dll`, …) | Cegid / PRIMAVERA | ERP integration (BSO/PSO, entities, navigation) | **At runtime:** provided by the licensed Primavera v10 (SG100) installation the addon is loaded into. **At build time:** 116 reference assemblies are vendored in `Lib/`, **as is and with no warranty**, so the solution compiles without an ERP present. Every reference is `<Private>False</Private>` — nothing is copied to the output, packaged, or loaded from those copies. They are not covered by this repository's license and it grants no rights to them; building from this repository requires your own valid Primavera/Cegid licensing. See [Lib/README.md](Lib/README.md). |
| DevExpress WinForms 21.2.3 | Developer Express Inc. | UI controls (grid, ribbon, editors) | **At runtime:** the setup installs 49 DevExpress assemblies alongside the addon, under DevExpress's redistribution terms — a Primavera installation supplies most but not all of the ones this addon uses. Same version as the host, so nothing in the ERP process is downgraded. **At build time:** not vendored; developing against this repository requires your own DevExpress WinForms licence. |
| Microsoft Edge WebView2 Runtime | Microsoft | Embedded chat web UI | Installed on the end-user machine (Evergreen WebView2 Runtime). Not redistributed by AITOOL. |

## ReportEngine module (commercial — only if that module is shipped)

The `ReportEngine` project references four SAP Crystal Reports assemblies
(`CrystalReports.Engine`, `ReportSource`, `Shared`, `Windows.Forms`) plus DevExpress
v21.2. These carry redistribution-restrictive licenses and are **not** relicensed by
AITOOL's Community License. If `ReportEngine` is not part of a given distribution, the Crystal
half of this section does not apply.

`ReportEngine/Lib/` holds 18 reference copies of the Crystal Reports closure, **as is and
with no warranty**, so the compile surface is legible without installing the runtime first.
Nothing resolves from that folder — the project has no `HintPath` and Crystal is resolved
from the GAC — and nothing from it is staged into the setup. Building or customising
reports requires SAP Crystal Reports for Visual Studio under your own licence. The README in
`ReportEngine/Lib/` (source repository only) lists those files.

## Open-source dependencies (NuGet)

Resolved via NuGet at build time (the OpenAI SDK is a vendored project; its upstream notice is in `OpenAI.SDK/LICENSE`) and bundled with the addon. Each is governed by its own
license; consult the package for authoritative terms.

| Package | Purpose | License (typical) |
| --------- | --------- | ------------------- |
| OpenAI .NET SDK (Betalgo-derived, vendored in `/OpenAI.SDK`, Copyright (c) 2022 Betalgo) | OpenAI / OpenAI-compatible client | MIT |
| Dapper | Lightweight SQL data access | Apache-2.0 |
| NLog | Logging | BSD-3-Clause |
| Sentry / Sentry.NLog | Error monitoring | MIT |
| PDFsharp | PDF rendering of ERP documents | MIT |
| Costura.Fody / Fody | Assembly embedding at build | MIT |
| FluentResults | Result pattern | MIT |
| FlaUI.Core / FlaUI.UIA3 | UI Automation used to drive the ERP's own windows | MIT |
| Interop.UIAutomationClient | COM interop assembly for the Windows UI Automation API, pulled in by FlaUI.UIA3 | MIT (FlaUI) |
| System.Management | WMI queries (process and window discovery) | MIT |
| System.Text.Json, System.Net.Http.Json, System.Text.Encodings.Web, System.Data.SqlClient, Microsoft.Extensions.* , Microsoft.Bcl.AsyncInterfaces, System.Resources.Extensions | Runtime/framework support | MIT |
| Microsoft.SourceLink.GitHub | Build-time only (source link metadata); not shipped | MIT |

## Installer

The setup is built with [Inno Setup 6](https://jrsoftware.org/isinfo.php) (Jordan Russell,
Martijn Laan). Its engine and uninstaller are part of every `AITOOL-Setup-*.exe`, under the
[Inno Setup License](https://jrsoftware.org/files/is/license.txt); Inno Setup itself is not
relicensed by AITOOL.

## Vendored web assets (chat UI)

Bundled as files under `UI/Resources/Chat/vendor/` (and copied next to the addon at
deploy time) so the chat renders fully offline. Versions are pinned and each file's
Subresource Integrity (SRI) hash is enforced by `index.html`.

| Component | Version | Purpose | License |
| ----------- | --------- | --------- | --------- |
| [marked](https://github.com/markedjs/marked) | 11.0.0 | Markdown rendering | MIT |
| [DOMPurify](https://github.com/cure53/DOMPurify) | 3.0.6 | HTML sanitization (XSS protection) | Apache-2.0 OR MPL-2.0 (dual) |
| [highlight.js](https://github.com/highlightjs/highlight.js) (+ Atom One Dark theme) | 11.9.0 | Code syntax highlighting | BSD-3-Clause |
| [Mermaid](https://github.com/mermaid-js/mermaid) | 10.9.0 | Diagram rendering (lazy-loaded) | MIT |

## Anthropic / OpenAI / OpenRouter APIs

AITOOL is a client of third-party AI APIs (OpenAI, OpenRouter, Anthropic, or any
OpenAI-compatible endpoint you configure). Use of those services is governed by the
respective provider's terms and data-usage policies. See [SECURITY.md](SECURITY.md)
for what data is sent.
