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

**CI** — tag `v*` ou `workflow_dispatch` (ver [CI/CD](#cicd)).

O script compila a solução em Release para `Installer\staging\` (compile-only,
não toca no ERP), lê a versão da `AITOOL.dll` e produz
`Installer\dist\AITOOL-Setup-<versão>.exe` com o SHA256 impresso no fim.

Parâmetros: `-Configuration` (default Release), `-IncludePdb` (inclui .pdb),
`-OutputDir` (default `Installer\dist`), `-SkipDocsSync` (salta a verificação de
sincronização dos espelhos PT, que por omissão corre antes de empacotar).

## Deteção do Primavera e destino

Ordem de deteção da raiz SG100 (igual ao `Directory.Build.props`):

1. `/DIR="..."` na linha de comandos (deploy empresarial; ignora instâncias)
2. Variáveis `PERCURSOSGE100` / `PERCURSOSGV100` (apontam para `<SG100>\Apl`;
   a raiz é a pasta-mãe)
3. Registo: `HKLM32\SOFTWARE\PRIMAVERA\WindowsService200\Services\PRIMAVERA
   AutoUpdate\Applications\ERP100\EV\*` → `PRODUCTINSTALLDIR`
4. Instalação anterior do AITOOL (`HKLM\SOFTWARE\Bola Labs\AITOOL` → `Sg100Root`)
5. Pedido ao utilizador (valida que existe `Config` ou `Config_<instância>`;
   aceita a raiz ou a pasta `Apl`)

Destino por instância: `<SG100>\Config[_Instância]\EV\Extensions\AITOOL\`.

## Instâncias do Primavera

O ERP v10 pode ter várias instâncias (BD `PRIINSTANCIAS`, tabela
`dbo.Instancias`). Cada instância além da `DEFAULT` sufixa as pastas da raiz
SG100: `Config_ALEX`, `Dados_ALEX`, `Mapas_ALEX`, ... A `DEFAULT` usa as pastas
sem sufixo — e é o único cenário quando a BD `PRIINSTANCIAS` não existe.

O instalador deteta as instâncias pelas pastas `Config[_X]` na raiz SG100 (o
que está de facto implantado na máquina é o que conta para copiar ficheiros):

- Uma única instância válida → nenhuma pergunta; instala como sempre.
- Várias instâncias → página de seleção com checkboxes (multi-instância):
  o AITOOL é instalado em todas as selecionadas. Instâncias já com AITOOL
  aparecem pré-selecionadas ("será atualizada"); sem `EV` aparecem desativadas.
- Botão "Consultar PRIINSTANCIAS no SQL Server...": opcional, liga ao SQL
  (autenticação Windows ou SQL) e cruza a lista local com `dbo.Instancias` —
  mostra descrições/estado bloqueada e instâncias registadas no servidor mas
  sem pasta local (não instaláveis a partir dessa máquina).

A primeira instância selecionada é a pasta `{app}` do Inno; as restantes são
espelhadas no fim da instalação com as mesmas regras (`appsettings*.json`
nunca esmagam um existente; `.pdb` e `appsettings.Development*` ficam fora).
Todas as pastas instaladas ficam registadas em `HKLM\SOFTWARE\Bola Labs\AITOOL`
(`InstallDirs`) e o uninstall remove-as todas.

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
`<SG100>\Config[_X]\EV\PRISECLE.BIN`, decifrado com o baralhamento reversível
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

No fim, o instalador verifica o **WebView2 Runtime** (necessário ao chat) e,
se faltar, instala-o automaticamente com o bootstrapper oficial da Microsoft
(download ~2 MB); sem rede fica um aviso com o link.

## Instalação silenciosa

```bat
AITOOL-Setup-x.y.z.w.exe /SILENT
AITOOL-Setup-x.y.z.w.exe /VERYSILENT /INSTANCES=DEFAULT,ALEX
AITOOL-Setup-x.y.z.w.exe /VERYSILENT /INSTANCES=ALL /SQLSERVER=SRV\PRIMAVERA /REGISTER=COMMON
AITOOL-Setup-x.y.z.w.exe /VERYSILENT /REGISTER=ERGO;ITM /SQLSERVER=SRV /SQLAUTH=sql /SQLUSER=sa /SQLPASSWORD=...
AITOOL-Setup-x.y.z.w.exe /VERYSILENT /DIR="C:\Program Files\PRIMAVERA\SG100\Config\EV\Extensions\AITOOL"
```

- Sem `/INSTANCES`: reinstala nas instâncias onde o AITOOL já existe; senão na
  `DEFAULT`; senão na primeira válida.
- `/INSTANCES=ALL` instala em todas as instâncias com edição Evolution.
- Nome inválido em `/INSTANCES` aborta com a lista de instâncias disponíveis.
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
| ERP aberto (`Erp100EV.exe`/`Erp100LE.exe`) | Repetir/Cancelar no install e uninstall; em silencioso aborta |
| Primavera não instalado | Deteção falha → pede a pasta (valida `Config[_*]`); silencioso aborta |
| Só a instância DEFAULT (ou sem BD PRIINSTANCIAS) | Sem página de instâncias; comportamento clássico |
| Várias instâncias (`Config_ALEX`, ...) | Página de seleção multi-instância; pré-seleciona as já instaladas |
| Instância sem `EV` | Aparece desativada; se nenhuma tiver EV, pede confirmação global |
| Instância na BD sem pasta local | Listada (via consulta SQL) mas desativada |
| Instância bloqueada (`Bloqueada=1`) | Marcada como bloqueada na lista |
| `/INSTANCES` com nome inválido | Aborta com a lista de instâncias disponíveis |
| SQL inacessível / sem PRIINSTANCIAS | Consulta é opcional; erro mostrado, lista local mantém-se |
| PRISECLE.BIN ausente/ilegível ou servidor em baixo | Auto-ligação falha em silêncio; diálogo SQL manual e códigos manuais cobrem o resto |
| Registo sem ligação SQL | Passa a "Não registar" com aviso; instalação continua |
| Lista de empresas indisponível | Página aceita códigos manuais; validados por instância na escrita |
| Filtro de empresas ativo | Seleção acumulada sobrevive a filtros; "Limpar" apaga também as escondidas |
| WebView2 Runtime em falta | Instalação automática via bootstrapper oficial; sem rede fica aviso com link |
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
| Uninstall | Não apaga `%LocalAppData%\Cegid\Extensions\AITOOL` (config, secrets.dat, logs) e informa onde fica |
| `.pdb` | Fora por omissão; `-IncludePdb` para builds de diagnóstico |
| Idioma | Wizard em português ou inglês (seleção no arranque) |
| Fim da instalação | Opção de abrir o ERP (não elevado, `runasoriginaluser`) |
| Build do projeto Installer dentro do próprio script | `-p:AitoolPackaging=true` + exclusão no .sln impedem recursão |
| `pwsh` ausente (build via VS) | Erro claro com o comando de instalação, antes de compilar |
