# Distribution

AITOOL is distributed free of charge as a binary addon under the [Community License](LICENSE).
Model A is the only public channel; Model B describes the source repository, which is private
and licensed separately.

## Model A — Binary addon (recommended)

Ship the assemblies AITOOL builds, to users who already run a licensed
Primavera v10 (SG100) environment. The host provides the Primavera SDK at runtime, so
**no Cegid binary is redistributed**.

What you ship (the build output for `AITOOL`):

- `AITOOL.dll` (your code + embedded chat UI + embedded OSS deps).
- `ReportEngine.dll`, which is excluded from the Costura bundle and always ships loose.
- The loose, Costura-excluded dependencies that sit next to it: `Shared.Config.dll`, `OpenAI.dll`,
  `FluentResults.dll`, `NLog.dll`, `Dapper.dll`, `System.Data.SqlClient.dll`,
  `System.Text.Json.dll`, `System.Text.Encodings.Web.dll`,
  `Microsoft.Bcl.AsyncInterfaces.dll`, `System.Threading.Tasks.Extensions.dll`,
  `FlaUI.Core.dll`, `FlaUI.UIA3.dll`, `Interop.UIAutomationClient.dll`, and the loose
  DevExpress/first-party set produced by the build (see the Costura configuration in
  `FodyWeavers.xml`).

**DevExpress is shipped, and deliberately so.** The setup carries 49 DevExpress 21.2.3
assemblies, about 171 MB of the roughly 250 MB staged (the setup itself compresses to
around 118 MB). A Primavera installation supplies most of them,
but not all of the ones this addon uses, and an addon that fails to load because one
assembly is missing from the host is worse than a larger download. They are redistributable
runtime components, and they are the same version the host runs, so nothing is
downgraded in the ERP process.

That redistribution covers running the product, not building it. **Developing against this
repository requires your own DevExpress WinForms licence** for anything beyond the
assemblies a licensed Primavera installation already provides — a DevExpress subscription is
a separate commercial product and this repository grants no rights to it.

What you do **not** ship: the Primavera/Cegid SDK or the WebView2 runtime — these come from
the host machine. The `Lib/` folder is compile-time only and is not part of any output; see
[Lib/README.md](Lib/README.md) and [THIRD-PARTY-NOTICES.md](THIRD-PARTY-NOTICES.md).

This model is suitable for the Cegid/PRIMAVERA extension portal and can be published now.
End-user steps are in [INSTALL.md](INSTALL.md).

## Model B — Source repository (private)

The source lives in a private repository and is licensed under written agreement
(see [COMMERCIAL.md](COMMERCIAL.md)); the public `BolaLabs/AITOOL` repository carries the
documentation, the releases and the issue tracker. The source is this repository's own work. The one thing that is not is
`Lib/`, and the position on it is deliberate and stated here so nobody has to guess.

**`Lib/` holds 116 Cegid reference assemblies, provided as is.** They exist so the solution
compiles and can be developed without a Primavera installation on the machine, and they do
nothing else: every reference is `<Private>False</Private>`, nothing is copied to any
output, nothing is packaged, nothing is executed, and nothing reaches an end user. At
runtime the addon binds to the assemblies of the licensed ERP it is loaded into. Full
rationale in [Lib/README.md](Lib/README.md).

They are not covered by this repository's license, and it grants no rights to them. Anyone
building from this repository is responsible for holding their own valid Primavera/Cegid
licensing and for their own use of those files. That disclaimer states the position and
limits our liability; it is not itself a licence from Cegid, and it is not presented as one.

If Cegid asks for them to be removed, they come out: the fallback is to delete `Lib/` from
the working tree and from git history and document the SDK as a build prerequisite resolved
from a licensed installation. The cost is that the build then depends on where Primavera is
installed, which breaks CI and every new contributor's first clone — the exact problem
`Lib/` exists to avoid.

Nothing else blocks publication of the binary. The repository contains no secrets (`appsettings.*.json`
are gitignored; only `.example` variants are tracked) and the ReportEngine module carries no
commercial binaries of its own.

## Building

No ERP installation is required to build: references resolve from the vendored `Lib/`
folder. A licensed Primavera v10 (SG100) environment is required only to *deploy* and run —
`Directory.Build.props` derives the deploy path from the `PERCURSOSGE100`/`PERCURSOSGV100`
variables, and falls back to a local `bin\` folder with warning AITOOL001 when no ERP is
present. See [README.md](README.md#build-developers) and [CONTRIBUTING.md](CONTRIBUTING.md).
