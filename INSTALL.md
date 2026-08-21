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

## Install

The installer is not code-signed; Windows SmartScreen warns on first run. Verify the SHA256
published with the release before continuing.

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
   the assistant — or use the installer, which detects the instances and installs into
   all selected ones at once.
3. Start the Primavera client. AITOOL appears in the ribbon.

## First run — configure a provider

1. Open AITOOL and click the settings (gear) icon.
2. Choose a provider (OpenAI, OpenRouter, Anthropic, or a compatible endpoint).
3. Paste your API key and pick a model (the list loads from the provider). The key is
   stored encrypted on your machine (Windows DPAPI) and is never written in plain text or
   sent anywhere except the provider you chose. See [SECURITY.md](SECURITY.md).
4. Start chatting. Settings (provider, model, key) persist across restarts.

## Where to get a key

- OpenAI: <https://platform.openai.com/api-keys>
- OpenRouter: <https://openrouter.ai/keys>
- Anthropic: <https://console.anthropic.com/>

## Updating

Close the client, replace the files in the AITOOL extensions folder with the new build,
and restart. Your provider settings and encrypted key are preserved.

## Uninstall

Close the client and delete the `…\Extensions\AITOOL\` folder. To also remove your saved
key, delete `%LocalAppData%\Cegid\Extensions\AITOOL\secrets.dat`.
