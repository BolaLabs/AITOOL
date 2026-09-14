# Lib — vendored Primavera assemblies

116 assemblies from a Cegid Primavera v10 installation, committed so the solution
builds on any machine without an ERP installed.

## Why they are here

Building against the ERP means referencing its object model — `ErpBS100`, `IBasBS100`,
`StdPlatBS100` and their dependencies. Resolving those from a local installation would
make the build depend on where (and whether) Primavera is installed, which breaks CI
and every new developer's first clone. Vendoring them makes `msbuild AITOOL.sln`
work anywhere.

## Curated, not a copy of the installation

This folder is the **transitive compile-time closure** and nothing else — the exact set
MSBuild hands to the compiler. It is not a dump of `<SG100>\Apl\`: an installation has
thousands of assemblies, the addon needs 116.

The set is derived, never hand-maintained. `Test-LibClosure.ps1` asks MSBuild to resolve
references for the four compiled projects in both configurations — `Installer` is a build
driver with no references of its own and stays out — and compares the answer with what is
on disk:

```powershell
pwsh -File scripts\checks\Test-LibClosure.ps1        # verify
pwsh -File scripts\checks\Test-LibClosure.ps1 -Fix   # drop what nothing references
```

It fails when the folder has assemblies nothing references, and when a reference has no
file. Run it after touching references in any `.csproj`.

Note what is kept: the interface assemblies (`IBasBS100`, `ICmpBS100`, `IVndBS100`, …)
and the business entities (`BasBE100`, `VndBE100`, …), because the code binds to
`bso.Base.Clientes` and friends through interfaces. Most implementation assemblies
(`BasBS100`, `VndBS100`) are absent on purpose: they are never referenced at compile
time and the ERP supplies them at runtime.

## Compile-time only — never shipped, never copy-local

Every reference in `AITOOL.csproj` is `<Private>False</Private>`, and that is
deliberate:

```xml
<Reference Include="BasBE100, Version=10.0.0.0, Culture=neutral, PublicKeyToken=11cd844aca152173">
  <SpecificVersion>False</SpecificVersion>
  <HintPath>Lib\BasBE100.dll</HintPath>
  <Private>False</Private>
</Reference>
```

These files are **reference assemblies**. They are not copied to the output, are not
in the installer, and never reach a customer machine. At runtime the addon is loaded
*inside* the ERP process and binds to the ERP's own assemblies — the ones the customer
actually has.

Turning copy-local on would be actively harmful: a second, older copy of the business
objects loaded into the ERP process is a category of bug that is very hard to diagnose.
**If a reference here ever shows `Private=True`, that is a defect.**

## Version drift is expected — and harmless

Primavera ships service releases often, so these files fall behind any given
installation. That is fine, because .NET binds on `AssemblyVersion`, not on
`FileVersion`, and Primavera keeps `AssemblyVersion` pinned at `10.0.0.0` across the
whole v10 line:

| | vendored here | a live installation |
| --- | --- | --- |
| `AssemblyVersion` (drives binding) | `10.0.0.0` | `10.0.0.0` |
| `FileVersion` (build stamp) | spread across `…3503` to `…3529`, because assemblies are only refreshed when a compile needs them | whatever service release the customer has, usually newer |
| strong name | `11cd844aca152173` | `11cd844aca152173` |

The `10.0.0.0` line holds for 113 of the 116. The exceptions are the two FarPoint assemblies
(`11.40.20177.0`, strong name `327c3516b1b18457`) and `Primavera.Core.Interop.dll`
(`2.1.0.0`), which are third-party or interop rather than v10 business objects.

**When a refresh is actually needed:** when a service release adds a member the code
wants to call. The vendored metadata has no knowledge of it, so the compile fails on
something that exists perfectly well at runtime. That is the signal.

```powershell
pwsh -File scripts\Update-PrimaveraLibs.ps1          # report drift, change nothing
pwsh -File scripts\Update-PrimaveraLibs.ps1 -Apply   # refresh from this machine's install
```

The script resolves the installation from the `PERCURSOSGE100` / `PERCURSOSGV100`
environment variables the Primavera installer sets — the same source
`Directory.Build.props` uses — so there is nothing to configure. Override with
`-PrimaveraRoot <path to SG100>` for a second install, and add `-IncludeOutsideApl` to
also match assemblies that live outside `Apl\`.

It refuses to replace a file whose `AssemblyVersion` differs from the vendored one:
that is not a refresh, it is a breaking change to the reference contract, and it needs
the `Reference` entries in `AITOOL.csproj` updated deliberately rather than silently.

## What is not here

Two assemblies in the closure have no counterpart in the reference installation and
keep their vendored copies. DevExpress 21.2.3 must be installed on the build machine.
So must the Crystal Reports runtime — `ReportEngine/Lib/` (with its own README) holds
reference copies of that closure, but nothing resolves from there.

## Licensing and disclaimer

These are Cegid Primavera binaries. They are **not** covered by this repository's
licence, and no license to them is granted or implied by it — see
[TRADEMARKS.md](../TRADEMARKS.md) and [COMMERCIAL.md](../COMMERCIAL.md).

They are present for one reason: so the solution compiles and can be developed without a
Primavera installation on the machine. They are compile-time metadata, never copied to any
output, never packaged, never executed, and never delivered to an end user — at runtime the
addon binds to the assemblies of the licensed ERP it is loaded into.

**Provided as is, with no warranty of any kind.** Anyone building from this repository is
responsible for holding their own valid Primavera/Cegid licensing, and for their own use of
these files. If Cegid asks for their removal, they come out and the build reverts to
resolving references from a licensed installation — which is the arrangement this folder
exists to avoid, not one it makes impossible.
