# Instalador AITOOL (Inno Setup)

Instalador Windows do AITOOL para o ERP Primavera v10, com branding Bola Labs,
seleção de instâncias do ERP e suporte a instalação silenciosa.

## Pré-requisitos

- [Inno Setup 6.3+](https://jrsoftware.org/isdl.php) (ISCC.exe; 6.3 introduziu
  `x64compatible`)
- Visual Studio 2022 ou [Build Tools](https://aka.ms/vs/17/release/vs_BuildTools.exe)
  com o workload ".NET desktop build tools"
- PowerShell 7 (`pwsh`)
- Os dois ficheiros gitignored que o build exige: `Properties\licenses.licx`
  (vazio chega) e `appsettings.Development.json` (o instalador exclui-o sempre)

## Gerar

Três caminhos, todos sobre o mesmo `build-installer.ps1`:

**Visual Studio** — dois gestos equivalentes; o progresso e o SHA256 aparecem
na janela Output (requer `pwsh` no PATH; o build falha com a instrução de
instalação se faltar):

- Configuração **Installer** no dropdown da toolbar → Build Solution (F6/
  Ctrl+Shift+B). Nessa configuração só o projeto `Installer` compila (os
  restantes são compilados pelo script para staging).
- Em Debug/Release: botão direito no projeto `Installer` → **Build**. O
  projeto está desativado nessas configurações, por isso Build Solution/F6
  nunca gera instaladores por engano — só o build explícito.

**Linha de comandos:**

```powershell
pwsh -File Installer\build-installer.ps1
```

O script compila a solução em Release para `Installer\staging\` (compile-only,
não toca no ERP), lê a versão da `AITOOL.dll` e produz
`Installer\dist\AITOOL-Setup-<versão>.exe` com o SHA256 impresso no fim.

Parâmetros: `-Configuration` (default Release), `-IncludePdb` (inclui .pdb),
`-OutputDir` (default `Installer\dist`), `-SkipDocsSync` (salta a verificação de
sincronização dos espelhos PT, que por omissão corre antes de empacotar).

## Deteção do Primavera e destino

Ordem de deteção da raiz SG100 (igual ao `Directory.Build.props`):

1. `/DIR="..."` na linha de comandos (deploy empresarial; ignora instâncias e edições)
2. Variáveis `PERCURSOSGE100` / `PERCURSOSGV100` / `PERCURSOSGP100` (apontam para
   `<SG100>\Apl`; a raiz é a pasta-mãe)
3. Registo: `HKLM32\SOFTWARE\PRIMAVERA\WindowsService200\Services\PRIMAVERA
   AutoUpdate\Applications\ERP100\<EV|LE|LP>\*` → `PRODUCTINSTALLDIR`
4. Instalação anterior do AITOOL (`HKLM\SOFTWARE\Bola Labs\AITOOL` → `Sg100Root`)
5. Pedido ao utilizador (valida que existe `Config` ou `Config_<instância>`;
   aceita a raiz ou a pasta `Apl`)

Destino por alvo: `<SG100>\Config[_Instância]\<EV|LE|LP>\Extensions\AITOOL\`.

## Edições do Primavera

As edições partilham a raiz SG100 e o `Apl`; só a subpasta de configuração muda:
`EV` = Evolution (`Erp100EV.exe`), `LE` = Executive (`Erp100LE.exe`), `LP` = Professional
(`Erp100LP.exe`). Uma pasta `Config[_X]\<ED>` só conta como alvo quando o executável da
edição existe em `Apl`. O registo na Extensibilidade é por instância (a BD `PRIEMPRE` é
partilhada pelas edições), por isso o instalador copia os mesmos bytes para todos os alvos:
a linha registada tem um único `HashCode`.

Uma pasta `Config[_X]\EV\Extensions\AITOOL` sem `Erp100EV.exe`, cujo único conteúdo é o
AITOOL, foi deixada por um instalador antigo num posto sem Evolution (o caso reportado a
2026-09-17 num posto Executive): é removida antes da cópia e o resultado regista-o.

## Pré-verificação

Página própria a seguir ao Bem-vindo (e em silencioso corre em `PrepareToInstall`), antes de
qualquer cópia. Cada linha é OK, Aviso ou Bloqueante; "Repetir" reavalia:

| Verificação | Como | Se falhar |
| --- | --- | --- |
| Versão do ERP por alvo | FileVersion de `Apl\Erp100<ED>.exe` (>= 10.0020 = validada) | Aviso ("não validada") |
| Componente WebView2 da Cegid | `Apl\Cegid.Platform.WebBrowserControl.dll` existe e contém `Microsoft.Web.WebView2.Core` | Bloqueante |
| DevExpress 21.2 | `Apl\DevExpress.XtraBars.v21.2.dll` | Bloqueante |
| Motor de extensibilidade | `Apl\Primavera.Extensibility.Engine.dll` | Aviso |
| .NET Framework 4.8 | `NDP\v4\Full\Release` >= 528040; senão instala o web installer oficial (`/q /norestart`; 3010 = reinício pedido no fim) | Aviso se a instalação falhar |
| WebView2 Runtime | `EdgeUpdate\Clients\{F3017226…}\pv`; senão instala o bootstrapper Evergreen | Bloqueante se a instalação falhar; Aviso se < 125 |
| ERP fechado | WMI `Win32_Process` para `Erp100EV/LE/LP.exe` | Bloqueante (Repetir) |
| Escrita em cada destino | ficheiro temporário em `Config[_X]\<ED>` | Bloqueante |
| Pasta EV órfã | ver acima | Aviso (será removida) |

## Resultado

Página depois da cópia (`wpInstalling`): por alvo, ficheiro presente, MD5 do ficheiro igual
ao `HashCode` registado (lido da BD com a mesma ligação do registo), executável da edição
encontrado; mais as pastas órfãs removidas e o estado do WebView2 Runtime. "Copiar
relatório" (via PowerShell `Set-Clipboard`, para não perder acentos) e "Abrir relatório". O
relatório em texto, com a pré-verificação e o resultado, fica em
`%ProgramData%\AITOOL\Install\AITOOL-Setup-<versão>-<data>.txt`; o AITOOL inclui-o no
pacote de apoio.

## Instâncias do Primavera

O ERP v10 pode ter várias instâncias (BD `PRIINSTANCIAS`, tabela
`dbo.Instancias`). Cada instância além da `DEFAULT` sufixa as pastas da raiz
SG100: `Config_ALEX`, `Dados_ALEX`, `Mapas_ALEX`, ... A `DEFAULT` usa as pastas
sem sufixo — e é o único cenário quando a BD `PRIINSTANCIAS` não existe.

O instalador deteta as instâncias pelas pastas `Config[_X]` na raiz SG100 (o
que está de facto implantado na máquina é o que conta para copiar ficheiros):

- Um único alvo (instância × edição) → nenhuma pergunta; instala como sempre.
- Vários alvos → página de seleção com checkboxes ("DEFAULT · Executive 10.0020.3514"):
  todos pré-selecionados, porque as edições da mesma instância partilham o registo.
  Alvos já com AITOOL mostram "instalada X — será atualizada" ou "será reparada" (mesma
  versão). Instâncias só no servidor aparecem desativadas.
- Botão "Consultar PRIINSTANCIAS no SQL Server...": opcional, liga ao SQL
  (autenticação Windows ou SQL) e cruza a lista local com `dbo.Instancias` —
  mostra descrições/estado bloqueada e instâncias registadas no servidor mas
  sem pasta local (não instaláveis a partir dessa máquina).

A primeira instância selecionada é a pasta `{app}` do Inno; as restantes são
espelhadas no fim da instalação com as mesmas regras (`appsettings*.json`
nunca esmagam um existente; `.pdb` e `appsettings.Development*` ficam fora).
Todas as pastas instaladas ficam registadas em `HKLM\SOFTWARE\Bola Labs\AITOOL`
(`InstallDirs`) e o uninstall remove-as todas.

## Skills partilhadas

As skills incluídas na versão ficam em `{app}\Skills` e são substituídas em cada
upgrade, como o resto do addon. O instalador cria vazia a pasta partilhada
`%ProgramData%\AITOOL\Skills` (secção `[Dirs]`) e, em `[Run]`, corre um `icacls` com
`/inheritance:r` que a deixa com SYSTEM e Administradores em controlo total e
`BUILTIN\Users` apenas em leitura e execução. O `Permissions:` do Inno não chegava: é
aditivo e mantinha a ACE herdada de `C:\ProgramData`, que dá escrita a qualquer
utilizador. A ACL é reposta em cada instalação; a pasta e o seu conteúdo sobrevivem ao
uninstall (`uninsneveruninstall`). As duas skills que a 2.12.0 copiou para lá
(`prospecao-de-leads`, `_modelo`) são removidas por `[InstallDelete]`, para que a versão
que vem no addon volte a ganhar.

## Registo na Extensibilidade

Depois da seleção de instâncias, o instalador pergunta como registar o AITOOL
na Extensibilidade do ERP — o equivalente ao ecrã Administrador/ERP >
Extensibilidade, escrito diretamente na base `PRIEMPRE` de cada instância
(tabela `ExtensibilityConfiguration`), com a mesma semântica do ERP
(`InsertExtensionFromFile` do StdPlatBS100):

- **Extensão comum** (recomendado): uma linha com `Company=''` e
  `CommonExtension=1` — disponível em todas as empresas.
- **Empresas específicas**: página própria com a lista de `Empresas`
  (excluindo inativas) da instância principal — filtro de pesquisa, botões
  "Selecionar visíveis"/"Limpar", contador de seleção e um campo de códigos
  manuais para quando a BD não está acessível. Grava uma linha com os códigos
  separados por `"; "` (formato do ERP, ex.: `DEMOV10; SHTS`) e
  `CommonExtension=0`. Noutras instâncias só entram os códigos que existirem
  lá.
- **Não registar**: instala só os ficheiros; o registo faz-se depois no ERP.

### Ligação SQL automática (PRISECLE.BIN)

O instalador lê o servidor e as credenciais SQL do próprio ERP —
`<SG100>\Config[_X]\<EV|LE|LP>\PRISECLE.BIN`, o primeiro legível entre as edições da
instância, decifrado com o baralhamento reversível
do Primavera — e liga-se sem perguntar nada: a lista de instâncias é
enriquecida com `PRIINSTANCIAS` (descrições, bloqueadas, `NomePriempre`) e as
empresas carregam automaticamente ao entrar na página. O diálogo SQL manual
(Windows ou SQL auth) fica como fallback/override. Credenciais nunca são
persistidas; só o servidor e o tipo de autenticação, para pré-preencher
upgrades.

Detalhes escritos por linha: `ID` (GUID), `FileVersion` (ProductVersion da
DLL), `HashCode` (MD5 do ficheiro — compatível com "Verificar integridade das
extensões"), `IsActive=1`, `IsSystem=0`. O registo é um upsert: um registo
existente mantém o `ID` e a posição na fila (`ExecutionQueue`); duplicados de
instalações antigas são consolidados; um registo novo entra com
`ExecutionQueue = MAX+1`. A base por instância vem de
`PRIINSTANCIAS..Instancias.NomePriempre` (fallback `PRIEMPRE[_Instância]`).
Falhas de registo nunca revertem a instalação dos ficheiros: fica o aviso e a
indicação de registo manual.

O **WebView2 Runtime** (necessário ao chat) é verificado na pré-verificação e,
se faltar, instalado automaticamente com o bootstrapper oficial da Microsoft
(download ~2 MB); no modo `/DIR` a mesma verificação corre no fim.

## Instalação silenciosa

```bat
AITOOL-Setup-x.y.z.w.exe /SILENT
AITOOL-Setup-x.y.z.w.exe /VERYSILENT /INSTANCES=DEFAULT,ALEX
AITOOL-Setup-x.y.z.w.exe /VERYSILENT /INSTANCES=ALL /EDITIONS=ALL /SQLSERVER=SRV\PRIMAVERA /REGISTER=COMMON
AITOOL-Setup-x.y.z.w.exe /VERYSILENT /EDITIONS=LE /REGISTER=ERGO;ITM /SQLSERVER=SRV /SQLAUTH=sql /SQLUSER=sa /SQLPASSWORD=...
AITOOL-Setup-x.y.z.w.exe /VERYSILENT /DIR="C:\Program Files\PRIMAVERA\SG100\Config\LE\Extensions\AITOOL"
```

- Sem `/INSTANCES` e sem `/EDITIONS`: todos os alvos (instância × edição) da máquina.
- `/EDITIONS=EV,LE,LP` (ou `ALL`, a omissão) filtra as edições antes da seleção; código
  desconhecido aborta.
- Nome inválido em `/INSTANCES` aborta com a lista de instâncias disponíveis.
- A pré-verificação corre também em silencioso; um ponto bloqueante aborta com a lista
  (`PreSilentBlocked`) e o registo do Inno (`/LOG`) leva o detalhe.
- `/REGISTER=COMMON|NONE|COD1;COD2` controla o registo na Extensibilidade
  (default em silencioso: `NONE`). Sem `/SQLSERVER`, as credenciais vêm
  automaticamente do `PRISECLE.BIN` do ERP; `/SQLSERVER` (com
  `/SQLAUTH=windows` por omissão, ou `sql` + `/SQLUSER` + `/SQLPASSWORD`)
  sobrepõe-se.
- Em modo silencioso não há prompts: se o Primavera não for detetado nem houver
  `/DIR`, ou se o ERP estiver aberto, o setup aborta com exit code diferente de 0.
  Falhas só de registo não alteram o exit code (ficheiros instalados; aviso no log).

## Branding

`branding\` tem os derivados que o wizard usa, gerados por
`branding\make-branding.ps1` (só System.Drawing, sem ImageMagick) a partir dos
masters da marca em `docs\brand\png` (monograma A·i + orbital) e commitados:

| Ficheiro | Uso |
| --- | --- |
| `wizard-large-164.bmp` / `-328.bmp` | painel lateral do wizard (100% / 200% DPI) |
| `wizard-small-55.bmp` / `-110.bmp` | cabeçalho do wizard (100% / 200% DPI) |
| `AITOOL.ico` | ícone do setup/uninstall (16–256 px; entradas BMP+máscara até 48 px, PNG a partir de 64) |

Os PNGs `bolalabs-*.png` na pasta são a marca da empresa (não do produto) e já
não alimentam o gerador. Para regenerar depois de mudar os masters:

```powershell
pwsh -File Installer\branding\make-branding.ps1
```

Regras da marca e masters: `docs/brand/README.md`.

Site: `https://bolalabs.pt` (contacto `bruno@bolalabs.pt`). É este o URL
usado no instalador (`MyAppURL`/`MyAppContact` no `.iss`).

## Publicação

A release é local: `pwsh -File scripts\Publish-Release.ps1` (a partir da raiz, com a
`AssemblyInfo.cs` e o CHANGELOG já na versão nova) cria a tag, compila o setup com
`build-installer.ps1`, escreve o `.sha256`, recusa um setup com `appsettings` dentro,
corre o espelho público e publica a GitHub Release nos dois repositórios. Não há job de
CI para o instalador: as referências DevExpress 21.2.3 e o Inno Setup não existem em
runners hosted; migrar implicaria a feed NuGet licenciada da DevExpress (chave em secret).

## Assinatura de código (distribuição pública)

O setup não está assinado; o SmartScreen vai avisar até haver reputação. Para
distribuir publicamente:

1. Certificado de code signing (OV ou EV; EV ganha reputação SmartScreen imediata).
2. `signtool sign /fd SHA256 /tr http://timestamp.digicert.com /td SHA256 dist\AITOOL-Setup-<versão>.exe`
3. Opcional: `SignTool=` no Inno para assinar também o uninstaller embebido.

## Edge cases cobertos

| Caso | Comportamento |
| --- | --- |
| ERP aberto (`Erp100EV.exe`/`Erp100LE.exe`/`Erp100LP.exe`) | Bloqueante na pré-verificação e Repetir/Cancelar no install e uninstall; em silencioso aborta |
| Primavera não instalado | Deteção falha → pede a pasta (valida `Config[_*]`); silencioso aborta |
| Raiz sem nenhuma edição reconhecida | Mensagem com as pastas encontradas; interativo deixa escolher outra raiz, silencioso aborta |
| Só um alvo (uma instância, uma edição) | Sem página de seleção; comportamento clássico |
| Evolution + Executive na mesma raiz | Dois alvos, ambos pré-selecionados; mesmos bytes, uma linha na BD |
| Só Executive (ou só Professional) | Instala em `LE` (ou `LP`) sem perguntas; nada é criado em `EV` |
| Pasta `Config\EV\Extensions\AITOOL` órfã (posto sem Evolution) | Removida antes da cópia; listada na pré-verificação e no resultado |
| ERP anterior à 10.20 mas com os componentes | Aviso "não validada"; instala |
| ERP da era CefSharp (sem `Cegid.Platform.WebBrowserControl.dll`) | Bloqueante; nada é copiado |
| DevExpress diferente de 21.2 em `Apl` | Bloqueante; nada é copiado |
| .NET 4.7.x | Instalação automática do 4.8; se falhar, aviso e instala na mesma |
| Várias instâncias (`Config_ALEX`, ...) | Página de seleção multi-alvo; pré-seleciona todos |
| Instância na BD sem pasta local | Listada (via consulta SQL) mas desativada |
| Instância bloqueada (`Bloqueada=1`) | Marcada como bloqueada na lista |
| `/INSTANCES` com nome inválido | Aborta com a lista de instâncias disponíveis |
| SQL inacessível / sem PRIINSTANCIAS | Consulta é opcional; erro mostrado, lista local mantém-se |
| PRISECLE.BIN ausente/ilegível ou servidor em baixo | Auto-ligação falha em silêncio; diálogo SQL manual e códigos manuais cobrem o resto |
| Servidor SQL guardado por uma instalação anterior | Só é fallback: sem `/SQLSERVER`, o PRISECLE.BIN vem primeiro (o servidor guardado usava autenticação Windows e falhava com SSPI num SQL noutra máquina) |
| Registo sem ligação SQL | Passa a "Não registar" com aviso; instalação continua |
| Lista de empresas indisponível | Página aceita códigos manuais; validados por instância na escrita |
| Filtro de empresas ativo | Seleção acumulada sobrevive a filtros; "Limpar" apaga também as escondidas |
| WebView2 Runtime em falta | Instalação automática na pré-verificação; se falhar (sem rede) é bloqueante com o link do instalador autónomo |
| WebView2 Runtime anterior à 125 | Aviso; instala |
| Fim da instalação | Página de resultado por alvo + relatório em `%ProgramData%\AITOOL\Install`; "Abrir o ERP" abre a edição do primeiro alvo |
| Upgrade do registo | Upsert mantém `ID` e `ExecutionQueue`; duplicados antigos consolidados |
| Empresa selecionada não existe noutra instância | Código filtrado por instância; instância sem nenhum código válido fica por registar, com aviso |
| Base PRIEMPRE/tabela em falta | Aviso por instância; ficheiros ficam instalados |
| Linha AITOOL.dll com `IsSystem=1` | Nunca é tocada (registo e uninstall filtram `IsSystem=0`) |
| Registo em falha parcial (várias instâncias) | Aviso lista instância + base + erro; restantes seguem |
| Upgrade | Modo e empresas do registo anterior pré-selecionados; `FileVersion`/`HashCode` atualizados |
| Uninstall do registo | Removido automaticamente via PRISECLE (ou Windows auth); senão nota de remoção manual |
| Upgrade | Pré-seleciona as instâncias instaladas; `appsettings*.json` do build só entram com `onlyifdoesntexist` |
| Uninstall multi-instância | Remove todas as pastas registadas em `InstallDirs` (só padrões `...\Extensions\AITOOL`) |
| Segredos de dev | `appsettings.Development*.json` nunca é empacotado e é apagado de deploys manuais antigos |
| Cache de extensões do host | Limpa `%LocalAppData%\Cegid\Extensions\<área>\*` que contenha `AITOOL.dll` (só do utilizador que corre o setup) |
| Uninstall | Não apaga `%LocalAppData%\Cegid\Extensions\AITOOL` (config, secrets.dat, logs) nem `%ProgramData%\AITOOL` (skills partilhadas) e informa onde ficam |
| `.pdb` | Fora por omissão; `-IncludePdb` para builds de diagnóstico |
| Idioma | Wizard em português ou inglês (seleção no arranque) |
| Fim da instalação | Opção de abrir o ERP (não elevado, `runasoriginaluser`) |
| Build do projeto Installer dentro do próprio script | `-p:AitoolPackaging=true` + exclusão no .sln impedem recursão |
| `pwsh` ausente (build via VS) | Erro claro com o comando de instalação, antes de compilar |
