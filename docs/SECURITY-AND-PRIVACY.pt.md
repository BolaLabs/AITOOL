[English](SECURITY-AND-PRIVACY.md) | **Português**

# Segurança e privacidade — o que um responsável de TI precisa de saber

Este é o documento a ler antes de aprovar o AITOOL numa máquina da empresa. Descreve o
addon tal como é instalado: não a postura de segurança do próprio fornecedor de IA, não a
do Primavera, não o hardening do seu SQL Server.

A comunicação de vulnerabilidades está em [SECURITY.md](../SECURITY.md).

---

## 1. Onde o software corre

In-process dentro do cliente Primavera (`Erp100EV.exe`, `Erp100LE.exe` ou `Erp100LP.exe`,
consoante a edição), na estação de trabalho do utilizador (.NET Framework 4.8), instalado
em `<SG100>\Config\<EV|LE|LP>\Extensions\AITOOL\` e registado na tabela de
Extensibilidade do ERP (`PRIEMPRE..ExtensibilityConfiguration`).

Não existe componente de servidor. **Nenhum serviço da Bola Labs é contactado em
runtime** — sem verificação de licença, sem endpoint de telemetria, sem verificação de
atualizações. Desinstalar é apagar uma pasta e uma linha de Extensibilidade.

## 2. O que sai da máquina, e para quem

| Destino | O quê | Quando | Como impedir |
| --- | --- | --- | --- |
| O fornecedor de IA configurado por **si** | A conversa, o system prompt (que inclui o código da empresa, o utilizador e a janela do ERP atualmente aberta) e todos os resultados de tools — nomes de clientes, números de contribuinte, saldos, valores de vendas, linhas de resultados SQL | Em cada turno | Configurar um endpoint local compatível com OpenAI; nada sai da máquina |
| Fornecedor de pesquisa web (Tavily / Brave / Serper / Exa / SearXNG self-hosted) | Apenas o texto da consulta de pesquisa | Apenas quando o `web_search` corre | Desativar a tool, ou deixar a chave por definir |
| VIES e NIF.pt | Um número de contribuinte | Apenas quando o `enrich_entity` corre | Desativar a tool |
| Jev (TypeSafe AI, alojado nos Estados Unidos), diretamente ou através da OpenRouter | Títulos de janelas, nomes de menus, etiquetas de campos e colunas, legendas de botões e texto dos diálogos da janela do ERP que está a ser automatizada, mais o nome que o utilizador deu ao que pediu. Nunca os valores escritos nos campos, nunca dados das tabelas | **Apenas se um utilizador ligar "Decisões rápidas (Jev)" nas definições. Desligado por omissão**; o painel mostra um aviso de proteção de dados junto do interruptor | Deixar o interruptor desligado |
| Sentry | Eventos de nível erro, sessões de release health e uma amostra de 10% de traces de desempenho, sanitizados; sem conteúdo do chat | **Apenas se um operador configurar um DSN. Nenhum DSN é distribuído.** | Deixar `Sentry:Dsn` vazio (a predefinição) |
| Quem receber o pacote de apoio enviado pelo utilizador | Um .zip com o relatório da instalação, os registos locais dos últimos 7 dias, as preferências do utilizador sem credenciais e os últimos relatórios do instalador; chaves, palavras-passe, connection strings e caminhos `C:\Users\<nome>` são redigidos. Os registos podem ainda mostrar clientes, artigos ou tabelas consultados pelas tools | Apenas quando um utilizador carrega em **Exportar pacote de apoio** (definições → Diagnóstico) e envia o ficheiro | Não o exportar, ou revê-lo antes de enviar |
| Bola Labs | Nada, nunca | — | — |

O que chega ao fornecedor é o que o assistente obteve para responder àquela pergunta —
não uma exportação em massa. Não há controlo de residência de dados para além do que o
próprio fornecedor oferecer.

## 3. O que o assistente consegue fazer

- **Ler** dados do ERP: entidades, documentos, stocks, contas correntes, pendentes,
  análise de vendas e SQL só de leitura.
- **Conduzir o cliente ERP**: abrir funções navegando o friso (ribbon), abrir registos
  nos respetivos editores, listar e preencher campos e células de grelha em janelas
  abertas — incluindo os editores clássicos VB6, via UI Automation.
- **Escrever**: criar e atualizar fichas de cliente/fornecedor, criar artigos, criar
  documentos de venda, criar oportunidades de venda no CRM e, só para administradores e
  técnicos, prolongar ou reativar uma série de vendas — cada uma delas dependente do cartão de
  confirmação descrito na secção 4. Os rascunhos de e-mail são entregues ao cliente de
  correio predefinido para revisão e nunca enviados pelo addon.
- **Gerar** o PDF do mapa oficial Crystal de um documento e abri-lo.
- **Pesquisar na web**, com os resultados marcados como conteúdo não confiável.

O teto: sem documentos de compra, sem criação de artigos, sem lançamentos
contabilísticos, sem eliminações, sem escritas diretas nas tabelas do ERP.

## 4. O que o limita, e com que força

Três níveis. A distinção importa, por isso é dita com clareza em vez de esbatida.

**Imposto no código.** O `run_query` aceita apenas `SELECT`/`WITH`, depois de reduzir a
instrução ao seu esqueleto executável (comentários e literais de string removidos,
parêntesis retos removidos dos identificadores, homóglifos Unicode normalizados), rejeita
empilhamento de instruções e rejeita nomes cross-database e `db..object`. O comportamento da
blocklist é fixado por `scripts/checks/Test-SqlGuard.ps1`; o limite de 500 linhas é aplicado no
`RunQueryTool` (como reescrita `TOP` quando a query pode ser envolvida, senão parando o leitor
ao fim de 500 linhas) e não é coberto por nenhum script. Toda a escrita no ERP depende de uma
autorização que a aplicação emite ao desenhar o cartão de confirmação, detalhada mais abaixo.
Os botões de commit e de destruição na automação de janelas (gravar, guardar, anular, apagar,
eliminar, remover, confirmar) passam pelo mesmo portão — avaliado sobre o
botão que o ERP resolveu, e não sobre a legenda pedida, porque a resolução é por substring.
Dentro de um diálogo modal só passam recusas e diálogos de um só botão; qualquer outra
resposta fica para o utilizador, no próprio ERP. Uma interação de janela de
cada vez; os commits são single-flight. Os endpoints de pesquisa web são HTTPS com
redirects desativados. A CSP da página de chat confina as origens de script, estilo, framing
e ações de formulário à origem da própria página, e todas as bibliotecas são vendorizadas com
SRI. Dois limites que vale a pena dizer com todas as letras: script e estilo inline são
permitidos, porque a superfície é um único ficheiro, pelo que a CSP restringe de onde vem o
código e não o que markup inline injetado poderia fazer — é para isso que existe o DOMPurify;
e imagens e ligações de saída ficam confinadas à origem da própria página, pelo que markdown
renderizado no chat não consegue carregar uma imagem remota nem chegar a um host externo.

**Imposto pelo prompt, não pelo código.** A regra de que o output das tools é dados e nunca
instruções, e a instrução para perguntar antes de uma ação irreversível. Um modelo pode
ignorar uma regra do prompt. É por isso que o trilho de auditoria e os interruptores de corte
(kill switch) existem.

**Imposto pela configuração.** Tools individuais podem ser desativadas
(`Assistant:DisabledTools`), ou toda a camada de tools do ERP (`ErpTools:Enabled=false`),
deixando um chat simples sem acesso ao ERP. Uma tool desligada é recusada na execução, e não
apenas omitida da lista enviada ao modelo.

### O portão de escrita, com precisão

As tools de escrita recebem uma flag `confirm`. Com ela a false, o ERP valida o rascunho e
devolve um preview sem gravar. **É a aplicação, e não o modelo, que transforma esse preview
num cartão de confirmação** — os campos, os avisos e, nos documentos, os totais que o próprio
ERP calculou, lidos do JSON do ERP e não do que o modelo escreveu. Ao construir o cartão, a
aplicação emite uma autorização: de uso único, válida 15 minutos, e ligada a um hash da
ferramenta e dos argumentos exatos que foram pré-visualizados.

A gravação exige essa autorização. Ela chega à ferramenta apenas pelo clique do utilizador no
cartão, e nunca faz parte do que o modelo vê ou consegue escrever. Por isso `confirm=true`
sozinho já não grava nada: a chamada é recusada, o cartão pendente volta a ser destacado, e a
recusa fica em `AI_AuditLog` como `Recusou (sem confirmação no cartão)`. Escrever "sim" no
chat também não grava — o botão do cartão é o único caminho. Alterar o rascunho invalida o
cartão, porque os argumentos deixam de coincidir com o hash a que a autorização estava ligada.

O mesmo portão cobre os botões de gravação e de destruição premidos por `interact_erp_window`.

**O que este portão não é.** É um controlo de aplicação dentro do addon, não uma fronteira de
base de dados. Limita o que um modelo — ou uma injeção de prompt bem-sucedida — consegue fazer
o ERP gravar. Não faz nada quanto a quem chega à base de dados do ERP com a mesma ligação que
o addon usa. Se mesmo a superfície de escrita com portão for inaceitável para uma dada
empresa, desative as tools de escrita, ou a camada de tools por inteiro.

### Não impõe as permissões por utilizador do Primavera

As tools que passam pelo modelo de objetos do ERP atuam como o utilizador ERP com sessão
iniciada. **As tools que leem por SQL não**: `search_entities`, `query_documents`,
`query_account_balance`, `analyze_sales`, `check_stock`, `render_document` e `run_query`
usam a ligação à base de dados do próprio ERP, e as permissões do Primavera são impostas
pela aplicação, não pela base de dados. Um utilizador que não consegue ver saldos de
fornecedores no ERP pode, ainda assim, pedi-los ao assistente.

Limite-o desativando essas tools para a população que não as deve ter, ou apontando o
addon para um login SQL só de leitura com o âmbito que aceitar.

## 5. Credenciais

As chaves de API são encriptadas com Windows DPAPI (âmbito `CurrentUser`) e guardadas em
base64 em `%LocalAppData%\Cegid\Extensions\AITOOL\secrets.dat`. Por utilizador e por
máquina: não legíveis por outra conta Windows, não portáveis, e **não recuperáveis se o
perfil se perder ou for reposto** — a chave simplesmente aparece como nunca tendo sido
definida, e tem de ser introduzida de novo.

As chaves nunca são escritas em `appsettings`, nunca são registadas em log, e nunca são
enviadas para lado nenhum exceto o fornecedor. A UI de definições mostra uma máscara,
nunca o valor.

Existem fallbacks por variável de ambiente para instalações não assistidas:
`OPENAI_API_KEY`, `OPENROUTER_API_KEY`, `ANTHROPIC_API_KEY`, `LMSTUDIO_API_KEY`.

Nota para implementações em terminal server, VDI e perfis roaming: o DPAPI `CurrentUser`
segue o perfil Windows. Um perfil não persistente significa reintroduzir a chave em cada
sessão.

## 6. O que fica guardado na sua base de dados

Quatro tabelas são criadas **automaticamente, na base de dados de empresa do ERP**
(`PRI<CodEmp>`) na primeira utilização. Não há base de dados separada nem passo de
migração.

| Tabela | Conteúdo |
| --- | --- |
| `AI_ChatSessions` | Metadados de sessão por utilizador e empresa |
| `AI_ChatMessages` | Conteúdo das mensagens, em texto simples, incluindo dados do ERP devolvidos pelas tools |
| `AI_AuditLog` | Timestamp, utilizador, empresa, tool, resumo, flag de sucesso, e os argumentos serializados da tool com os valores de key/token/secret/password ocultados, truncados a 2000 caracteres |
| `AI_AutomationKnowledge` | O que a automação das janelas aprendeu, partilhado pelos postos: o texto do pedido, a janela, a etiqueta e o nome do controlo do campo, coluna ou funcionalidade do ERP que ele quis dizer, as etiquetas que um utilizador rejeitou, um contador de utilizações, a data e o utilizador que alterou por último. Só nomes e etiquetas, nunca os valores escritos |

**Não há política de retenção nem job de purga.** As sessões podem ser apagadas
individualmente na UI; nada expira, e os dados sobrevivem à desinstalação do addon. Para
uma implementação sujeita a obrigações de retenção ou apagamento do RGPD, essa é uma
política que tem de ser acrescentada por si — um delete agendado contra as três primeiras
tabelas é tudo o que é preciso. A `AI_AutomationKnowledge` não guarda dados pessoais além
do código do utilizador que alterou a linha por último.

Permissões necessárias: as que a ligação do ERP já tem, mais `CREATE TABLE` na base de dados
e `ALTER` no esquema `dbo` na primeira execução do addon.

Se o seu login não puder criar tabelas — e muitos não podem — execute o
[`sql/AI_Schema.sql`](../sql/AI_Schema.sql) uma vez por empresa, como `db_owner`. A partir
daí o addon não precisa de nenhum direito de DDL: `SELECT, INSERT, UPDATE, DELETE` em
`AI_ChatSessions` e `AI_ChatMessages`, `SELECT, INSERT` em `AI_AuditLog`, que nunca é
atualizado nem apagado, e `SELECT, INSERT, UPDATE` em `AI_AutomationKnowledge`. Sem esta
última tabela nada falha: cada posto fica com o que aprendeu só para si.

**Uma gravação é recusada quando o registo de auditoria está inacessível.** Criar ou alterar
um registo no ERP a partir do cartão de confirmação verifica primeiro que consegue escrever no
registo, e pára com uma mensagem acionável se não conseguir. As pré-visualizações e as
leituras continuam, porque não alteram nada no ERP. Antes disto, uma base de dados que
bloqueasse as tabelas deixava a escrita passar e ficavam dois avisos num ficheiro local como
único rasto.

### O que o trilho de auditoria cobre

**Coberto**: commits através do modelo de objetos (criar/atualizar entidade, criar artigo,
criar documento de venda, criar oportunidade de venda, alterar série de vendas), commits recusados, falhas, e as
ações de janela que alteram estado (escrita em campo, um ou vários; escrita em grelha, uma
célula ou uma linha; clique em botão, fecho de janela, fecho de todas as janelas, e as
respetivas recusas).

**Não coberto**: previews e tentativas não confirmadas, navegação no friso
(`open_erp_function`), leituras, `print_document` e `enrich_entity` (só de leitura).

**Modo de falha**: se o próprio insert de auditoria falhar, a escrita no ERP mantém-se e
a falha é registada apenas localmente.

**Consulta**: `/auditoria [N]` no chat mostra as entradas recentes do próprio utilizador; a
tabela é sua para consultar. As tabelas `AI_*` são recusadas pelo `run_query`, pelo que o
assistente não consegue ler os seus próprios registos através do SQL escrito pelo modelo — só
por `/auditoria`.

### Quem vê os registos de quem

As sessões de chat e as entradas de auditoria são do utilizador ERP que as criou: um
utilizador comum vê as suas conversas e as suas ações, e mais nada. Um administrador, super
administrador ou técnico do ERP é tratado como supervisor — um badge no cabeçalho,
`/auditoria todos [N]`, e um interruptor "Todos os utilizadores" na lista de conversas. Uma
conversa de outra pessoa abre só de leitura: nada do que o supervisor escreve entra nela, e
renomear e apagar são recusados.

O perfil é lido do ERP (`AdmEngine`, `clsUtilizador`) na abertura da empresa, e o âmbito é
aplicado em C# antes de a consulta correr. **É um controlo de aplicação, não uma permissão de
base de dados**: as linhas vivem na base de dados de empresa e quem lá chegar com um cliente
SQL lê-as todas, seja qual for o perfil que tenha no ERP. O e-mail registado do utilizador é
lido mas nunca colocado no system prompt.

## 7. Logs locais

`%LocalAppData%\Cegid\Extensions\AITOOL\Logs\`, rotação diária, retenção de 7 dias, nunca
enviados para fora. As builds DEBUG registam com verbosidade, incluindo argumentos das
tools; as RELEASE registam Info e acima (operações e contexto das escritas no ERP, nunca a chave). As consultas de pesquisa web nunca são
registadas — podem conter nomes e números de contribuinte.

A mesma pasta guarda o `automation-memory.json`: o que a automação das janelas aprendeu,
em JSON legível, com uma cópia de segurança da versão anterior ao lado. Regista que campo,
coluna de grelha ou funcionalidade do ERP um pedido acabou por querer dizer ("plafond" é
"Limite" na ficha de cliente) e quais o utilizador rejeitou. Só nomes e etiquetas; os
valores escritos nunca lá ficam. Pode ser lido, editado ou apagado. Definições → Avançado
esvazia-o nesse posto e, pela tabela partilhada, nos outros; isso é recusado a quem não for
administrador, superadministrador ou técnico no ERP.

O conhecimento que o addon traz de origem está dentro do próprio addon e, em texto, em
`Knowledge\automation-knowledge.json` na pasta da extensão. É esse o ficheiro que um
administrador edita. O ERP verifica a integridade da DLL do addon, não deste ficheiro.

## 8. Prompt injection

Campos do ERP, resultados SQL e páginas web são texto que um atacante pode influenciar, e
os três chegam ao modelo.

Mitigações: uma regra de spotlighting no system prompt que trata o output das tools como
dados e nunca como instruções; marcação `untrusted_content` nos resultados web com um
aviso inline; e telemetria sobre formulações de injeção conhecidas.

Risco residual, dito com clareza: uma injeção bem-sucedida podia causar uma chamada de
tool que o utilizador não pretendia. O que a limita é o conjunto de tools, o guard de SQL, o
portão de escrita — uma instrução injetada não consegue obter a autorização do cartão, logo
não consegue fazer o ERP gravar seja o que for — e o trilho de auditoria. Ver a secção 4.

## 9. Rede

Saída, por TLS 443, para os destinos que ativar de entre estes: o host da API do seu
fornecedor de IA, o seu fornecedor de pesquisa web, `ec.europa.eu` (VIES) e `nif.pt` se o
`enrich_entity` for usado, `api.typesafe.ai` ou `openrouter.ai` se as decisões rápidas (Jev)
estiverem ligadas, e o seu host Sentry se configurar um DSN. Nada mais. Não há
listener de entrada.

A UI de chat é servida a partir de um host virtual do WebView2 (`https://aitool.local`)
que nunca toca na rede.

## 10. Checklist antes de aprovar

- [ ] Escolher o fornecedor de IA — ou um modelo local — e rever a respetiva política de
      uso de dados
- [ ] Decidir se as tools de escrita ficam sequer ativas (toda a escrita depende de um
      cartão de confirmação que alguém tem de carregar)
- [ ] Decidir se o `run_query` fica ativo, e se o addon deve apontar para um login SQL só
      de leitura
- [ ] Aceitar que quatro tabelas são criadas na base de dados de empresa, sem política de
      retenção (ou agendar a sua própria purga)
- [ ] Decidir o DSN do Sentry (predefinição: nenhum)
- [ ] Conhecer o caminho de remoção: apagar a pasta, remover a linha de Extensibilidade;
      as quatro tabelas sobrevivem por design
- [ ] Notar que o instalador ainda não é assinado (code signing) — o SmartScreen vai
      avisar, e o SHA256 publicado com cada release é a forma de verificar o download
