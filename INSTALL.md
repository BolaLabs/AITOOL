**English** | [Português](INSTALL.pt.md)

# Installing AITOOL

AITOOL is an extension for the Primavera v10 (SG100) desktop client.

## Requirements

- A licensed **Primavera v10 (SG100)** installation, **version 10.20 or later**, in the
  **Evolution, Executive or Professional** edition (Evolution and Executive are validated;
  Professional installs on the same rules and awaits a customer confirmation). The ERP
  provides the SDK AITOOL uses at runtime, the DevExpress 21.2 controls and the WebView2
  component the chat runs on (`Apl\Cegid.Platform.WebBrowserControl.dll`). Older v10 builds
  that still embed the Chromium (CefSharp) browser do not have that component; the setup
  detects it and stops before copying anything.
- **Microsoft .NET Framework 4.8.** The ERP itself runs from 4.7.2; the setup installs 4.8
  automatically when it is missing (an in-place update, no impact on the ERP).
- **Microsoft Edge WebView2 Runtime** (Evergreen), 125 or later recommended. Most Windows 11
  machines already have it; the setup installs it when it is missing.
- An API key for at least one AI provider: OpenAI, OpenRouter, Anthropic, or any
  OpenAI-compatible endpoint (e.g. a local LM Studio server, which needs no key).

## Client-server installations

Primavera v10 is typically installed client-server: the ERP lives on a server and every
workstation reaches the shared `SG100` folder (maps, configuration, extensions) through a
Windows share. AITOOL is an extension inside that folder, so:

- **Run the setup once**, on the machine that holds `SG100` (the server, or the PC that
  shares the folder), with the Primavera client closed everywhere. The setup finds the
  installation, writes the files into `<SG100>\Config\<EV|LE|LP>\Extensions\AITOOL\` for
  every edition it finds and registers the addon in the ERP's Extensibility screen.
- **Workstations need nothing else.** They pick the assistant up at their next start. The
  only local requirement is the Microsoft Edge WebView2 runtime, which Windows 10 and 11
  already carry.
- **Keys are per user.** Each person enters their provider key in the assistant's
  settings; it is encrypted with that Windows user's DPAPI profile, on that workstation.
  A company that wants a shared key, or a local model on a server, points the endpoint
  there instead.

Topologies vary (Terminal Server, several instances, a copy of `SG100` per machine); if
yours is unusual, the manual copy below works the same way, folder by folder.

## Install

Download `AITOOL-Setup-<version>.exe` from the release page and run it on the machine that
holds `SG100`, with the Primavera client closed. The setup is not code-signed yet, so
Windows SmartScreen warns on first run: click **More info → Run anyway**. The SHA256
published with the release is how you check the download first.

The wizard does the ERP-side work by itself:

1. **Finds the Primavera installation** — `PERCURSOSGE100`/`PERCURSOSGV100`/
   `PERCURSOSGP100`, then the registry, then a previous AITOOL install, and it asks only if
   all of that fails. It refuses to continue while the ERP client is open.
2. **Pre-flight check**, before any file is copied: the ERP version of each edition, the
   WebView2 component of the ERP, DevExpress 21.2, the extensibility engine, .NET
   Framework 4.8, the WebView2 Runtime (installed on the spot when missing) and write access
   to each destination. Red items block and say what to fix ("Repetir" re-checks); yellow
   ones warn and let you continue.
3. **Detects every edition and instance** — each `Config[_INSTANCE]\EV`, `\LE` or `\LP`
   folder whose executable exists in `Apl` is a target, all pre-selected, with an optional
   PRIINSTANCIAS lookup on SQL Server. A previous install left in `Config\EV` on a
   workstation without Evolution is removed.
4. **Writes the same files** into every selected target and **registers AITOOL in the
   ERP's Extensibility screen**, once per instance, as a common extension or for specific
   companies.
5. **Verifies the result** target by target (file present, MD5 equal to the registered
   row, executable found), shows it, and saves a report under
   `%ProgramData%\AITOOL\Install\` that you can send to support.

For IT departments: `/VERYSILENT /INSTANCES=ALL /EDITIONS=ALL /SQLSERVER=SRV
/REGISTER=COMMON` (`/EDITIONS=EV,LE,LP` narrows the editions; `ALL` is the default), or
`/VERYSILENT /DIR="<SG100>\Config\LE\Extensions\AITOOL"` for one exact folder. In silent
mode the pre-flight check runs too and aborts with the list of blocking items.

Then start the Primavera client. AITOOL appears in the ribbon.

### Manual copy, as an alternative

Useful when the setup cannot run — an unusual topology, or a policy against installers.

1. Close the Primavera client.
2. Copy the AITOOL files into the extensions folder of the edition you run:
   `<SG100>\Config\<EDITION>\Extensions\AITOOL\`, where `<EDITION>` is `EV` for Evolution
   (`Erp100EV.exe`), `LE` for Executive (`Erp100LE.exe`) or `LP` for Professional
   (`Erp100LP.exe`) — typically `C:\Program Files\PRIMAVERA\SG100\Config\LE\Extensions\AITOOL\`
   on an Executive workstation. If Primavera was installed elsewhere, the
   `PERCURSOSGE100`/`PERCURSOSGV100`/`PERCURSOSGP100` environment variable points at its
   `Apl` folder; `<SG100>` is that folder's parent. When more than one edition is
   installed, copy the same files into each edition folder: they share one registration.
   (Copy the whole folder delivered to you; do not leave older copies behind.)

   **Multiple ERP instances:** each Primavera instance beyond `DEFAULT` has its own
   suffixed folder tree (`Config_<INSTANCE>`, e.g. `Config_ALEX`). Repeat the copy into
   `<SG100>\Config_<INSTANCE>\<EDITION>\Extensions\AITOOL\` for every instance that should
   get the assistant.
3. Register the extension by hand in the ERP's Extensibility screen — the step the setup
   otherwise does for you.
4. Start the Primavera client. AITOOL appears in the ribbon.

## First run — configure a provider

1. Open AITOOL and click the settings (gear) icon.
2. Choose a provider (OpenAI, OpenRouter, Anthropic, or a compatible endpoint).
3. Paste your API key and pick a model (the list loads from the provider). The key is
   stored encrypted on your machine (Windows DPAPI) and is never written in plain text or
   sent anywhere except the provider you chose. See [SECURITY.md](SECURITY.md).
4. Start chatting. Settings (provider, model, key) persist across restarts.

On the first run the addon creates three `AI_*` tables in the ERP database for chat history
and the audit trail. What they hold, and the pre-built script for sites where the addon may
not `CREATE TABLE`, are in
[docs/SECURITY-AND-PRIVACY.md, section 6](docs/SECURITY-AND-PRIVACY.md#6-what-is-stored-in-your-database).

## Where to get a key

- OpenAI: <https://platform.openai.com/api-keys>
- OpenRouter: <https://openrouter.ai/keys>
- Anthropic: <https://console.anthropic.com/>

## Updating

Close the client, replace the files in the AITOOL extensions folder with the new build,
and restart. Your provider settings and encrypted key are preserved.

## Uninstall

Close the Primavera client and uninstall AITOOL from Windows **Apps** (Settings → Apps →
Installed apps). It removes the files from every folder it recorded at install time, takes
the AITOOL line out of the ERP's Extensibility configuration, and deletes its
`HKLM\SOFTWARE\Bola Labs\AITOOL` key with the `InstallDirs` list.

Two folders are left in place on purpose:
`%LocalAppData%\Cegid\Extensions\AITOOL` (your settings, the encrypted `secrets.dat` and the
logs) and `%ProgramData%\AITOOL` (the shared skills). Delete them by hand if you want
nothing left. The `AI_*` tables stay in the ERP database as well; they are yours to drop.

After a manual copy, remove the `…\Extensions\AITOOL\` folder and the Extensibility line by
hand instead.
