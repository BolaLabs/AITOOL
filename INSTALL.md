**English** | [Português](INSTALL.pt.md)

# Installing AITOOL

AITOOL is an extension for the Primavera v10 (SG100) desktop client.

## Requirements

- A licensed **Primavera v10 (SG100)** installation (provides the ERP SDK AITOOL uses at
  runtime, and most of the DevExpress controls; the setup carries the rest).
- **Microsoft Edge WebView2 Runtime** (Evergreen). Most Windows 11 machines already have it;
  otherwise install it from Microsoft (free).
- An API key for at least one AI provider: OpenAI, OpenRouter, Anthropic, or any
  OpenAI-compatible endpoint (e.g. a local LM Studio server, which needs no key).

## Client-server installations

Primavera v10 is typically installed client-server: the ERP lives on a server and every
workstation reaches the shared `SG100` folder (maps, configuration, extensions) through a
Windows share. AITOOL is an extension inside that folder, so:

- **Run the setup once**, on the machine that holds `SG100` (the server, or the PC that
  shares the folder), with the Primavera client closed everywhere. The setup finds the
  installation, writes the files into `<SG100>\Config\EV\Extensions\AITOOL\` and registers
  the addon in the ERP's Extensibility screen.
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

1. **Finds the Primavera installation** — `PERCURSOSGE100`/`PERCURSOSGV100`, then the
   registry, then a previous AITOOL install, and it asks only if all of that fails. It
   refuses to continue while the ERP client is open.
2. **Detects multi-instance ERPs** (`Config_<INSTANCE>` folder trees, e.g. `Config_ALEX`)
   and lets you install into one or several at once, with an optional PRIINSTANCIAS lookup
   on SQL Server.
3. **Writes the files** into `<SG100>\Config\EV\Extensions\AITOOL\` for each selected
   instance and **registers AITOOL in the ERP's Extensibility screen**, as a common
   extension or for specific companies.
4. **Checks the Microsoft Edge WebView2 Runtime** and installs it if it is missing.

For IT departments: `/VERYSILENT /INSTANCES=ALL /SQLSERVER=SRV /REGISTER=COMMON`, or
`/VERYSILENT /DIR="<SG100>\Config\EV\Extensions\AITOOL"`.

Then start the Primavera client. AITOOL appears in the ribbon.

### Manual copy, as an alternative

Useful when the setup cannot run — an unusual topology, or a policy against installers.

1. Close the Primavera client.
2. Copy the AITOOL files into the extensions folder of your Primavera installation:
   `<SG100>\Config\EV\Extensions\AITOOL\` — typically
   `C:\Program Files\PRIMAVERA\SG100\Config\EV\Extensions\AITOOL\`. If Primavera was
   installed elsewhere, the `PERCURSOSGE100` environment variable points at its `Apl`
   folder; `<SG100>` is that folder's parent.
   (Copy the whole folder delivered to you; do not leave older copies behind.)

   **Multiple ERP instances:** each Primavera instance beyond `DEFAULT` has its own
   suffixed folder tree (`Config_<INSTANCE>`, e.g. `Config_ALEX`). Repeat the copy into
   `<SG100>\Config_<INSTANCE>\EV\Extensions\AITOOL\` for every instance that should get
   the assistant.
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
