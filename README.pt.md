[English](README.md) | **Português**

<div align="center">

<img src="docs/assets/banner.svg" alt="AITOOL — assistente de IA embutido no ERP Primavera v10" width="920">

**Um assistente dentro do PRIMAVERA v10 que corre inteiramente em máquinas que controla** —
sem conta no fabricante, sem licença por posto, sem créditos contados — com o modelo que
escolher, incluindo um local. Responde a partir dos dados do seu negócio, abre qualquer ecrã
do ERP que descreva por palavras suas, preenche janelas e cria clientes e documentos de venda
através dos objetos de negócio do próprio ERP: primeiro um preview validado pelo ERP, gravação
só depois de concordar, e cada escrita num registo de auditoria na sua própria base de dados.

[![.NET Framework](https://img.shields.io/badge/.NET%20Framework-4.8-512BD4?logo=dotnet)](https://dotnet.microsoft.com/download/dotnet-framework/net48)
[![DevExpress](https://img.shields.io/badge/DevExpress-21.2.3-FF7200)](https://www.devexpress.com/)
[![Platform](https://img.shields.io/badge/Platform-Windows-0078D6)](https://www.microsoft.com/windows)
[![Licença: Community](https://img.shields.io/badge/Licen%C3%A7a-Community%20(gratuita)-D9A441.svg)](LICENSE.pt)
[![Feedback bem-vindo](https://img.shields.io/badge/Feedback-bem--vindo-D9A441.svg)](CONTRIBUTING.md)
[![Website](https://img.shields.io/badge/Web-bolalabs.pt-1E3A5F)](https://bolalabs.pt)

</div>

---

**Navegue consoante quem é:**

| Quero... | Ir para |
| --- | --- |
| Perceber o que isto é, sem a engenharia | [Em termos simples](#em-termos-simples) |
| Ver o que o assistente consegue mesmo fazer | [O que faz](#o-que-faz) · [As 21 tools](#as-21-tools) |
| Chegar a um ecrã que não encontro nos menus | [Encontre qualquer ecrã por palavras suas](#encontre-qualquer-ecrã-por-palavras-suas) |
| Decidir se é seguro pô-lo perto do meu ERP | [Segurança e confiança](#segurança-e-confiança) · [docs/SECURITY-AND-PRIVACY.pt.md](docs/SECURITY-AND-PRIVACY.pt.md) |
| Instalá-lo, num PC ou numa rede inteira | [Instale uma vez, todos os postos o recebem](#instale-uma-vez-todos-os-postos-o-recebem) · [Instalação (utilizadores finais)](#instalação-utilizadores-finais) |
| Compará-lo com o Cegid Pulse | [Comparação com o Cegid Pulse](#comparação-com-o-cegid-pulse) |
| Compilá-lo a partir do código fonte | [Compilar (developers)](#compilar-developers) |
| Saber para onde isto vai | [Para lá do Primavera](#para-lá-do-primavera) · [ROADMAP.md](ROADMAP.md) |

---

## Em termos simples

Abra o ERP como sempre. Um botão novo no friso (ribbon) abre um chat. Pergunte, por palavras
suas: *"quanto é que este cliente me deve, e desde quando?"* — e o assistente responde a
partir dos seus dados reais, com os números que o próprio ERP lhe daria. Peça-lhe para
preparar uma proposta e ele preenche-a, mostra-lhe os totais para rever e só grava depois de
dizer que sim. Cada alteração que faz passa pelas mesmas validações que o ERP lhe aplica a
si, e fica num registo de auditoria na sua própria base de dados.

Quatro coisas o distinguem de colar os seus dados num chatbot:

- **Corre onde decidir.** Dentro do seu ERP, nas suas próprias máquinas. Não há nenhum
  servidor da Bola Labs no caminho, nenhuma conta a criar, e com um modelo de IA local nada
  sai sequer do edifício.
- **Escolhe (e paga) a IA diretamente.** OpenAI, Anthropic, OpenRouter, qualquer endpoint
  compatível com OpenAI, ou um modelo local através do LM Studio — a preços do fornecedor,
  sem subscrição, sem licença por posto e sem créditos contados por cima.
- **Qualquer ecrã, a pedir.** "Abre o extrato de conta do fornecedor", "abre o
  explorador de vendas": encontra a função no catálogo do ribbon e abre-a, seja qual for
  o módulo onde vive. Ninguém precisa de se lembrar onde está um ecrã.
- **Mostra a escrita antes de a fazer.** Criar ou alterar registos está desenhado em dois
  passos: um preview validado pelo próprio ERP, depois uma segunda chamada confirmada que o
  assistente está instruído a fazer só depois de dizer que sim — e cada gravação, recusa e
  falha fica num registo de auditoria que pode ler a partir do chat.

O produto é gratuito, para empresas e parceiros. Instale-o a partir do assistente de instalação
([como funciona](#instalação-utilizadores-finais)), configure uma chave de IA e está a
funcionar em minutos.

---

## Como é

<table>
<tr>
<td><img src="docs/assets/screenshot-pendentes-kpi.png" alt="Pendentes: cartões KPI, filtros e tabela viva, ancorados ao lado do ERP" width="300"></td>
<td><img src="docs/assets/screenshot-preview-confirmacao.png" alt="Alteração a uma ficha de cliente em pré-visualização, à espera da confirmação do utilizador" width="300"></td>
<td><img src="docs/assets/screenshot-auditoria.png" alt="A vista /auditoria sobre a AI_AuditLog no chat" width="300"></td>
</tr>
<tr>
<td><sub>"Dá-me a lista de pendentes desde 2015" — a consulta de pendentes do próprio ERP, em cartões e tabela viva.</sub></td>
<td><sub>Uma escrita é pré-visualizada pelo ERP e só gravada depois do "sim".</sub></td>
<td><sub>Cada gravação, recusa e falha fica na <code>AI_AuditLog</code>, na sua base de dados.</sub></td>
</tr>
</table>

<img src="docs/assets/screenshot-ficha-ao-lado.jpg" alt="O assistente ancorado à direita do cliente Primavera, com a ficha de cliente que abriu ao lado" width="920">

Capturas na DEMOV10, a empresa de demonstração da Cegid, com a build 2.8.0.

---

## O que faz

O AITOOL é uma extensão WinForms (.NET Framework 4.8) que embute um assistente de chat no
cliente Primavera v10 (SG100) via WebView2. O assistente fala com o modelo à sua escolha —
OpenAI, OpenRouter, Anthropic nativo ou qualquer endpoint compatível com OpenAI, LM Studio
incluído — e atua sobre o ERP através de 21 tools descobertas automaticamente:

- **Lê dados reais do ERP.** Pendentes com a consulta do próprio ERP, análise de vendas por
  período, cliente e artigo, contagens de vendas e compras por ano via SQL guardado, saldos de conta corrente com antiguidade, stock por armazém, pesquisa de
  documentos, pesquisa de entidades por nome, código, NIF ou localidade — mais uma tool de
  SQL só de leitura, guardada a `SELECT`/`WITH` e limitada a 500 linhas. As respostas
  tabulares aparecem como tabelas vivas com cartões KPI, e cada linha tem um menu de
  contexto: abrir no ERP, gerar o PDF, abrir o registo, mostrar os seus pendentes.
- **Conduz o cliente do ERP.** Abre qualquer função do ERP pelo nome a partir do catálogo
  do ribbon, em todos os contextos de navegação que a instalação tiver — Vendas,
  Contabilidade, Tesouraria, Recursos Humanos, o que estiver licenciado. Abre registos
  (fichas de cliente, fornecedor e artigo, documentos, extratos de conta) nos seus editores
  nativos. Numa janela aberta lista os campos, preenche campos e células de grelha, clica
  em botões e separadores, lê diálogos modais e fecha janelas — tanto em janelas .NET como
  nos editores VB6 clássicos, através de UI Automation. Quando o botão do ribbon está
  visível o cursor desliza até ele, para que veja o que está a ser clicado.
- **Escreve com preview.** Cria fichas de cliente e fornecedor e documentos de venda
  (propostas, encomendas, faturas) e atualiza fichas existentes, sempre através dos objetos
  de negócio do Primavera, para que todas as validações do ERP corram e a numeração
  continue a ser do ERP. A primeira chamada é validada pelo ERP (`ValidaActualizacao`) e
  devolve um preview com totais reais sem gravar; a gravação é uma segunda chamada,
  confirmada, que o assistente está instruído a fazer só depois de concordar no chat.
  Depois de uma gravação, um aviso diz-lhe que janelas abertas do ERP ficaram
  desatualizadas. Cada gravação, recusa e falha fica escrita na `AI_AuditLog` na sua
  própria base de dados; `/auditoria` no chat lê-a de volta.
- **Botões de commit exigem uma flag explícita.** A automação de janelas pode escrever em
  campos e premir botões, mas um botão que grava ou destrói dados (gravar, guardar, anular,
  apagar, eliminar, remover, confirmar) é recusado a menos que a chamada traga uma flag de
  autorização explícita, que o assistente está instruído a definir só depois de o
  utilizador pedir essa ação. A verificação corre sobre o botão que o ERP resolveu, não
  sobre a legenda pedida. Dentro de um diálogo modal a regra inverte-se: só passam recusas
  (Cancelar, Não) e diálogos de um só botão, pelo que responder "Sim" a "Gravar
  alterações?" exige a mesma autorização. Cada escrita de campo, escrita em grelha, clique
  de botão e fecho de janela através da automação fica registado na `AI_AuditLog` com o
  utilizador, a empresa, a tool, os argumentos e o resultado. A navegação no ribbon não é
  auditada, e se o próprio insert de auditoria falhar a escrita no ERP mantém-se (a falha
  é registada localmente). Veja [SECURITY.md](SECURITY.md) para o que essa fronteira é e
  não é.
- **Documentos.** O PDF oficial de um documento, produzido pelo relatório Crystal com que a
  série está configurada — ATCUD e código QR são do próprio ERP — abre-se sozinho num
  cartão com visualizador. Quando a série não tem relatório configurado recebe um aviso
  âmbar e uma folha de dados simples, nunca um documento oficial a fingir.
- **Enriquecimento de entidades.** Dê-lhe um NIF e o assistente preenche a ficha a partir
  de registos públicos (VIES, NIF.pt), valida o NIF por país e mostra um diff campo a campo
  antes de qualquer escrita.
- **Pesquisa web.** Cinco fornecedores — Brave, Exa, Serper, Tavily ou um SearXNG
  self-hosted — com a sua própria chave, para leads e dados de empresas; os resultados são
  explicitamente marcados como conteúdo não confiável.
- **Descobre em vez de adivinhar.** Tipos de documento, séries (com validade) e preços de
  artigo vêm da configuração do ERP através de tools de consulta dedicadas.
- **Um chat que se comporta como um produto.** Streaming com indicadores de fase e um
  cancelar que para o turno em menos de um segundo; blocos de raciocínio colapsáveis;
  Markdown, Mermaid e syntax highlighting renderizados totalmente offline (bibliotecas
  vendored, com versões fixas e verificação SRI); chips de sugestão de seguimento;
  histórico de conversas no seu SQL Server com pesquisa e mudança de nome; slash commands;
  temas claro/escuro/sistema; atalhos de teclado (`Ctrl+N` novo chat, `Ctrl+B` sessões,
  `Ctrl+,` definições); janela destacável; exportação para Markdown, HTML ou texto simples.
  O assistente declara que é um sistema de IA, como exige o artigo 50.º do AI Act.

### As 21 tools

| Tool | O que faz |
| --- | --- |
| `search_entities` | Pesquisa clientes, fornecedores e artigos por nome, código, NIF ou localidade |
| `get_entity_details` | Detalhes completos de uma entidade (cliente, fornecedor, artigo) |
| `get_pending_items` | Documentos pendentes por entidade, ou de todas as entidades, com filtros de datas |
| `query_account_balance` | Saldo de conta corrente de um cliente/fornecedor, com escalões de antiguidade |
| `query_documents` | Pesquisa documentos comerciais por tipo, entidade, data ou estado |
| `analyze_sales` | Análise de vendas por cliente, artigo ou período; top-N e comparação de períodos. O âmbito vem da classificação de documentos do próprio ERP, pelo que notas de crédito e devoluções são descontadas — os valores são líquidos |
| `check_stock` | Stock atual, mínimo e máximo de um artigo por armazém |
| `render_document` | Cabeçalho e linhas de um documento comercial, mostrados como cartão interativo |
| `run_query` | SQL só de leitura escrito pelo modelo — apenas `SELECT`/`WITH`, escrita/DDL bloqueadas por uma guarda |
| `open_record` | Abre um registo (ficha, documento, extrato de conta) no seu editor nativo do ERP |
| `open_erp_function` | Abre qualquer função do ERP pelo nome, navegando o ribbon; lista o inventário em caso de dúvida |
| `interact_erp_window` | Lista janelas e campos, preenche campos e células de grelha, clica botões — janelas .NET e nativas (VB6) |
| `print_document` | Gera o PDF do relatório oficial de um documento, aberto num cartão com visualizador |
| `get_sales_document_types` | Lista os tipos de documento de venda configurados nesta instalação do ERP, cada um com a natureza que o ERP lhe atribui (orçamento, encomenda, guia, fatura) |
| `get_sales_series` | Lista as séries de um tipo de documento, com a série por omissão e a validade à data de hoje |
| `get_article_price` | Preço/desconto sugerido pelas regras de preços do ERP (listas de preços, regras por cliente, escalões de quantidade) |
| `create_entity` | Cria uma ficha de cliente/fornecedor via BSO — preview primeiro, grava numa segunda chamada confirmada |
| `create_sales_document` | Cria um documento de venda via BSO — preview com totais reais, depois confirmar para gravar |
| `update_entity` | Atualiza campos de uma ficha de cliente/fornecedor existente — preview primeiro, grava numa segunda chamada confirmada |
| `enrich_entity` | Preenche uma ficha a partir de registos públicos pelo NIF (VIES, NIF.pt), mostrando um diff campo a campo antes de qualquer escrita |
| `web_search` | Pesquisa na web pública (Brave, Tavily, Exa, Serper ou um SearXNG self-hosted); só de leitura, resultados marcados como conteúdo não confiável |

Cada tool pode ser ligada ou desligada individualmente nas definições; a camada de tools
inteira tem um kill switch (`ErpTools:Enabled` / `AITOOL_ERP_TOOLS_ENABLED`).

Um fluxo típico de ponta a ponta — *"esta empresa enviou-nos um email, faz-lhes uma
proposta"*: `web_search` encontra a empresa → `search_entities` verifica se já existe →
`create_entity` (preview → confirmar → gravar) → `get_sales_document_types` + `get_sales_series`
escolhem o tipo de proposta real e uma série válida → `create_sales_document` (preview com
totais calculados pelo ERP → confirmar → gravar) → `print_document` para o PDF oficial.

---

## Encontre qualquer ecrã por palavras suas

O Primavera v10 tem centenas de funções espalhadas por módulos, contextos de navegação e
menus aninhados, e a maioria das pessoas usa uma dúzia delas. As outras são as que se
procuram uma vez por trimestre e nunca se fixam. O AITOOL lê o catálogo do ribbon do
próprio ERP no arranque — todas as funções, em todos os contextos de navegação que a
instalação tem licenciados — para que possa pedir um ecrã como pediria a um colega: *"abre
a ficha do cliente 0031 e os pendentes dele"*, *"abre o explorador de vendas"*, *"leva-me ao extrato
de conta deste fornecedor"*. O assistente encontra a função, muda de contexto se for preciso,
abre-a, e quando o botão do ribbon está visível o cursor desliza até ele para que aprenda
onde estava. Quando não tem a certeza, lista os candidatos em vez de adivinhar.

O mesmo mecanismo conduz o que vem a seguir: com a janela aberta, o assistente lista os
campos, preenche-os, passa pelos separadores, lê o diálogo que o ERP devolve e fecha a
janela — tanto nos ecrãs .NET modernos como nos editores VB6 clássicos.

Isto é também um ângulo de acessibilidade, dito com cuidado. Tudo o que o ERP expõe por
menus pode ser pedido por texto, o que ajuda quem não sabe onde vive um ecrã, quem tem
dificuldade em percorrer ribbons aninhados e quem trabalha melhor a escrever do que a
apontar. Não torna o Primavera uma aplicação totalmente acessível, e a entrada por voz está
no roadmap, não no produto.

---

## Instale uma vez, todos os postos o recebem

O Primavera v10 instala-se tipicamente em cliente-servidor: o ERP vive num servidor e cada
posto de trabalho chega à pasta partilhada `SG100` (mapas, configuração, extensões) através
de uma partilha Windows. O AITOOL é uma extensão nessa pasta, por isso o setup corre **uma
vez**, na máquina que tem o `SG100`, e cada posto apanha o assistente no arranque seguinte.
Não há nada a instalar por posto: um posto de trabalho precisa apenas do runtime Microsoft
Edge WebView2, que o Windows 10 e 11 já trazem.

O setup é um assistente Windows normal que faz o trabalho do lado do ERP sozinho: encontra
a instalação do Primavera, deteta ERPs multi-instância, regista o addon no ecrã de
Extensibilidade do ERP (comum, ou por empresa) e remove esse registo na desinstalação. Os
departamentos de IT têm um modo silencioso. Não conhecemos outro addon Primavera que venha
com um instalador que se regista a si próprio; os detalhes estão em
[Instalação (utilizadores finais)](#instalação-utilizadores-finais), e as notas de rede em
[INSTALL.pt.md](INSTALL.pt.md).

Cada utilizador abre depois o assistente a partir do ribbon e introduz a sua própria chave
de fornecedor, guardada cifrada por utilizador Windows (DPAPI) e enviada apenas a esse
fornecedor. Uma empresa que queira partilhar uma chave, ou correr um modelo local num
servidor, aponta o endpoint para lá.

---

## Arquitetura

<div align="center">
<img src="docs/assets/turn-flow.svg" alt="Anatomia de um turno: mensagem do utilizador, streaming do modelo, tool calls, confirmação humana nas escritas, ERP" width="920">
</div>

O addon é alojado in-process pelo ERP. A superfície de chat é uma página WebView2 servida a
partir de um host virtual (`https://aitool.local`) com uma CSP que não permite nenhum CDN —
marked, DOMPurify, highlight.js e Mermaid são vendored com versões fixas e hashes SRI, pelo
que a renderização funciona totalmente offline. JS e C# comunicam por `PostWebMessageAsJson`
/ `ExecuteScriptAsync`, abstraídos atrás de uma interface `IChatView`.

Um turno corre através do `ToolCallOrchestrator`: faz streaming do fornecedor ativo, executa
tool calls até ao limite de iterações configurado (1-15), reproduz o transcript de tools nas
continuações e é dono do cancelamento por turno. Os fornecedores estão atrás de uma
abstração `IAiProvider` — uma implementação para endpoints compatíveis com OpenAI e um
adaptador Anthropic nativo (`/v1/messages`, thinking com níveis de esforço, prompt caching).
As tools implementam `IErpTool`, são marcadas com `[Tool]` e são descobertas por reflexão no
arranque.

Cinco projetos compõem a solução: **AITOOL** (o addon), **OpenAI.SDK** (cliente vendored
baseado no Betalgo — streaming e tool calling, sem dependência do AITOOL), **Shared.Config**
(configuração unificada + telemetria), **ReportEngine** (wrapper de Crystal Reports usado
para os PDFs oficiais de documentos) e **Installer** (conduz a construção do Inno Setup).
Detalhes em [ARCHITECTURE.md](ARCHITECTURE.md).

---

## Segurança e confiança

Deixar um modelo de linguagem perto de um ERP é um problema de confiança antes de ser um
problema de funcionalidades. As salvaguardas, pela ordem em que importam:

| Salvaguarda | Como funciona |
| --- | --- |
| **Protocolo de escrita em dois passos** | `create_entity` e `create_sales_document` exigem `confirm=false` primeiro: o ERP valida o rascunho e devolve um preview (com totais reais nos documentos) sem gravar. Gravar exige uma segunda chamada com `confirm=true`, que o assistente está instruído a fazer só depois de o utilizador concordar explicitamente no chat. As gravações são single-flight — uma segunda gravação concorrente é recusada. **Isto é uma fronteira de instrução ao modelo, não um portão de UI**: hoje nenhum caminho de código bloqueia um commit num gesto do utilizador, pelo que um modelo que ignore a instrução pode fazer commit num só passo. Uma confirmação de UI obrigatória está no roadmap; entretanto, o registo de auditoria e os interruptores por tool são o que limita o risco. |
| **As escritas passam pelos objetos de negócio do ERP** | Os registos são criados via o modelo de objetos BSO do Primavera, pelo que todas as validações do ERP correm e os números de documento são atribuídos pelo ERP. Não há escritas diretas nas tabelas core do ERP. O `run_query` é só de leitura por guarda aplicacional, não por permissão de base de dados — corre na ligação do próprio ERP, pelo que empresas que queiram uma segunda barreira devem apontar o addon para um login SQL só de leitura. |
| **SQL com guarda** | O `run_query` aceita apenas `SELECT`/`WITH`: uma blocklist rejeita palavras-chave de escrita/DDL/sistema (`INSERT`, `DROP`, `EXEC`, `xp_*`, `OPENROWSET`, …) depois de remover comentários, parêntesis retos e homóglifos Unicode para impedir contornos; o empilhamento de statements (`;`) é recusado; o número de linhas é limitado do lado do servidor. |
| **Conteúdo não confiável é sinalizado** | O system prompt fixa uma regra: texto devolvido por tools (páginas web, resultados SQL, campos do ERP) é dado para analisar, nunca instruções para seguir. Os resultados do `web_search` levam adicionalmente `untrusted_content: true` mais um aviso inline, e formulações de injeção conhecidas são sinalizadas para a telemetria. |
| **Automação de janelas contida** | O contrato de automação proíbe clicar em botões de gravar/anular/eliminar a menos que o utilizador o tenha pedido na conversa — o assistente preenche campos, resume e para. Corre uma interação de janela de cada vez. |
| **Chaves cifradas em repouso** | As chaves de API (fornecedores e pesquisa web) vivem num cofre cifrado por utilizador com DPAPI (`secrets.dat`), nunca em configuração em texto simples. Os endpoints de pesquisa web têm de ser HTTPS e os redirects estão desativados, para que uma chave não possa fugir para um destino de redirect — a exceção é um SearXNG self-hosted em loopback ou numa gama privada, que não leva chave e só aceita HTTP simples quando explicitamente permitido. |
| **Higiene de telemetria** | Os logs são locais (NLog, rotação diária). Builds RELEASE enviam apenas eventos de nível erro para o Sentry, com chaves de API, passwords de connection strings e caminhos de utilizador redigidos antes do envio. As pesquisas web nunca são registadas — podem conter nomes e NIFs. |
| **Interruptores** | Cada tool liga e desliga individualmente nas definições; `ErpTools:Enabled` desliga a camada de tools inteira, deixando um chat simples. |

O que sai da máquina, o que fica guardado na sua base de dados e o que limita o assistente
está em [docs/SECURITY-AND-PRIVACY.pt.md](docs/SECURITY-AND-PRIVACY.pt.md) — escrito para a
pessoa que tem de aprovar a instalação.

### Não aplica as permissões por utilizador do Primavera

Vale a pena saber antes de o pôr em produção, porque decide a quem o dá.

As tools que passam pelo modelo de objetos do ERP (criar e atualizar registos, abrir
janelas, imprimir) atuam como o utilizador do ERP com sessão iniciada e batem nas regras do
próprio ERP. **As tools que leem por SQL não** — `search_entities`, `query_documents`,
`query_account_balance`, `analyze_sales`, `check_stock`, `render_document` e `run_query`
usam a ligação à base de dados do próprio ERP, e as permissões do Primavera são aplicadas
pela aplicação, não pela base de dados. Um utilizador que não pode abrir saldos de
fornecedores no ERP pode na mesma pedi-los ao assistente.

Duas formas de o limitar: desativar as tools que uma dada população não deve ter
(`Assistant:DisabledTools`), ou apontar o addon para um login SQL só de leitura restrito às
views que aceitar. O mapeamento de permissões por utilizador não está implementado e não
está planeado para a v1.

---

## O que custa

O addon é gratuito ao abrigo da [Licença Community](LICENSE.pt). Não há subscrição, licença por posto, conta a criar
nem contadores — nada no AITOOL conta as suas ações.

O que paga é o seu fornecedor de IA, diretamente, ao preço dele. Uma ordem de grandeza, não
uma promessa: uma pergunta típica que corre duas ou três tools carrega o system prompt mais
os schemas das tools, portanto conte com alguns milhares de tokens de entrada por turno e
algumas centenas de saída. Os modelos mais baratos resolvem as consultas do dia a dia;
guarde os fortes para os fluxos de documentos com vários passos. O contador de tokens por
sessão está no roadmap, por isso hoje o conselho honesto é vigiar a primeira semana no
dashboard do próprio fornecedor.

Custo marginal zero é possível: aponte-o para um endpoint local compatível com OpenAI
(LM Studio, ou o servidor de inferência da sua empresa) e nada é faturado e nada sai da
máquina. Abaixo de cerca de 8B parâmetros com quantização de 4 bits, o tool calling deixa de
ser fiável — esse é o limite prático, não uma lista de modelos suportados.

## O que não vai fazer

Limites deliberados, não lacunas à espera de serem preenchidas:

- **Sem workflows autónomos.** As cadeias de tools têm limite por turno; não corre sem
  supervisão.
- **Sem lançamentos contabilísticos, sem eliminações, sem documentos de compra, sem criação
  de artigos.** Documentos de venda e fichas de cliente/fornecedor são a superfície de
  escrita.
- **Sem entrada de faturas ou documentos.** Não lê uma fatura em PDF e lança-a. Está no
  roadmap, e condicionado pelas regras portuguesas: documentos fiscais são emitidos por
  software certificado pela AT, nunca por um assistente.
- **Sem carregamento de plugins.** Nada corre dentro do processo do ERP por ser largado numa
  pasta.
- **Sem exportação de tabelas de resultados para Excel ou CSV.** As conversas exportam para
  Markdown, HTML ou texto simples; as tabelas oferecem cópia.
- **Não substitui conhecer o seu ERP.** Responde a partir dos seus dados e conduz os seus
  ecrãs; não audita a sua configuração nem corrige os seus dados mestre.

A interface está em português (pt-PT). O assistente responde na língua em que lhe escrever.

---

## Começar

### Comparação com o Cegid Pulse

A Cegid tem o seu próprio assistente para o Primavera. A comparação que as pessoas pedem,
com base no material publicado pela própria Cegid:

| | Cegid Pulse | AITOOL |
| --- | --- | --- |
| Onde corre | Um serviço cloud da Cegid, acedido pela API deles — mesmo quando o seu ERP é on-premise | No processo do ERP, na sua máquina |
| Conta obrigatória | Uma Cegid Account por utilizador | Nenhuma |
| Edição | Apenas Evolution | Evolution (ver requisitos) |
| O modelo | O da Cegid | O seu — OpenAI, OpenRouter, Anthropic, qualquer endpoint compatível com OpenAI, ou um local |
| Custo de uma ação | Franquia de tokens por edição, com recargas pagas | O que o seu fornecedor lhe cobrar, diretamente |

Não são substitutos: o Pulse está embutido nos workflows do ERP pelo fabricante e é
suportado por ele. O AITOOL existe para o caso em que a resposta a "para onde vão os dados
do meu negócio" tem de ser "para lado nenhum", e em que a escolha do modelo é sua.

### Requisitos

- ERP Primavera v10 (SG100) licenciado, edição Evolution
- Microsoft Edge WebView2 Runtime
- SQL Server (a instância do próprio ERP; guarda também o histórico de chat)
- Uma chave de API de pelo menos um fornecedor (OpenAI, OpenRouter, Anthropic) — ou um
  endpoint local compatível com OpenAI, como o LM Studio, que não precisa de chave

### Instalação (utilizadores finais)

<img src="docs/assets/installer-wizard.png" alt="Assistente de instalação do AITOOL" width="200" align="right">

A instalação é um assistente de instalação Windows normal — descarregar, seguinte, seguinte,
concluído. O setup ainda não está assinado digitalmente, por isso o Windows SmartScreen
mostra um aviso na primeira execução; o SHA256 nas notas da release é a forma de verificar o
download. O que faz por si, por ordem:

1. **Encontra a sua instalação do Primavera** automaticamente
   (`PERCURSOSGE100`/`PERCURSOSGV100` → registry → instalação anterior → pergunta se tudo o
   resto falhar), e recusa-se a correr com o cliente do ERP aberto.
2. **Trata ERPs multi-instância**: deteta pastas `Config_<instance>`, deixa escolher uma ou
   várias, com uma consulta opcional de PRIINSTANCIAS no SQL Server.
3. **Regista o AITOOL no ecrã de Extensibilidade do ERP** por si — como extensão comum ou
   para empresas específicas, escrito na base de dados PRIEMPRE de cada instância. Sem
   configuração manual do ERP.
4. **Desinstala de forma limpa**: o mesmo estado é usado para remover o registo na
   desinstalação.

Para departamentos de IT, o deployment silencioso é suportado:
`/VERYSILENT /INSTANCES=ALL /SQLSERVER=SRV /REGISTER=COMMON`, ou
`/VERYSILENT /DIR="<SG100>\Config\EV\Extensions\AITOOL"`. Os passos de cópia manual estão em
[INSTALL.pt.md](INSTALL.pt.md).

Numa instalação cliente-servidor, corra-o uma vez na máquina que tem o `SG100`; os postos
não precisam de nada além do runtime WebView2 (veja
[Instale uma vez, todos os postos o recebem](#instale-uma-vez-todos-os-postos-o-recebem)).

Depois arranque o Primavera, abra o assistente a partir do ribbon e defina o fornecedor, o
modelo e a chave de API no modal de definições. A chave fica guardada cifrada (DPAPI) no
perfil desse utilizador. Primeira resposta útil: menos de cinco minutos desde o download.

### Compilar (developers)

Compilar precisa de um ambiente Primavera SG100 licenciado para um deploy completo, mas
compila em qualquer lado: todas as referências Primavera resolvem a partir da pasta vendored
`Lib\`.

```bat
:: two gitignored files unblock the build
type nul > Properties\licenses.licx
copy appsettings.Development.example.json appsettings.Development.json

msbuild AITOOL.sln -restore -p:Configuration=Debug
```

- Com o ERP instalado, o output faz deploy diretamente para
  `<SG100>\Config\EV\Extensions\AITOOL\` (raiz resolvida a partir das variáveis
  `PERCURSOSGE100`/`PERCURSOSGV100`; override com `-p:PrimaveraRoot=<path>`; é precisa
  elevação quando o ERP vive em `C:\Program Files`).
- Sem o ERP, o build avisa (`AITOOL001`) e recorre a `bin\<Config>\`; use
  `-p:OutDir=<dir>` para uma verificação explícita só de compilação.

A `Lib\` guarda 116 assemblies de referência de compilação — o fecho transitivo exato de que
o compilador precisa, nunca copy-local, nunca distribuídos. Em runtime o addon liga-se aos
assemblies do próprio ERP. Que o `FileVersion` vendored fique atrás de um service release
instalado é inofensivo: o binding vai pelo `AssemblyVersion`, que o Primavera fixa em toda a
v10.

```powershell
pwsh -File scripts\checks\Test-LibClosure.ps1        # prove the folder matches the closure
pwsh -File scripts\Update-PrimaveraLibs.ps1          # report version drift, change nothing
pwsh -File scripts\Update-PrimaveraLibs.ps1 -Apply   # refresh from this machine's install
```

Ambos resolvem a instalação a partir das mesmas variáveis de ambiente que o build usa, pelo
que não há nada a configurar. Veja [`Lib/README.md`](Lib/README.md) para os detalhes e a
nota de licenciamento.

### Compilar o instalador

A partir do Visual Studio: escolha a configuração de solução **Installer** e Build Solution,
ou clique com o botão direito no projeto `Installer` → **Build** a partir de qualquer
configuração (o projeto está excluído dos builds Debug/Release, pelo que um F6 normal nunca
empacota). Na linha de comandos:

```powershell
pwsh -File Installer\build-installer.ps1
```

Ambos correm o mesmo script: compila a solução em Release para uma pasta de staging local
(sem nunca tocar no ERP), lê a versão do `AITOOL.dll` compilado e compila o script Inno
Setup para `Installer\dist\AITOOL-Setup-<version>.exe`, imprimindo o seu SHA256.
Parâmetros: `-Configuration`, `-IncludePdb`, `-OutputDir`. Uma tag `v*` dispara o mesmo
build num runner self-hosted e prepara um rascunho de GitHub Release
(`.github/workflows/installer.yml`). Detalhes, seleção de instâncias, branding e notas de
assinatura de código: [Installer/README.md](Installer/README.md).

---

## Configuração

Tudo o que é do dia a dia configura-se no modal de definições e é persistido num ficheiro
por utilizador (`%LocalAppData%\Cegid\Extensions\AITOOL\appsettings.User.json`) — os deploys
nunca o sobrescrevem. Ordem de resolução: variável de ambiente → ficheiro do utilizador →
`appsettings.{Environment}.json` → `appsettings.json` → defaults incorporados. A camada de
ambiente cobre `Provider:*`, `ErpTools:*`, `Sql:*` e `Sentry:*`; as definições `Assistant:*`
abaixo são lidas apenas dos ficheiros, com as chaves de pesquisa web como única exceção.
Referência completa:
[docs/CONFIGURATION.md](docs/CONFIGURATION.md).

| Definição | O que controla | Default |
| --- | --- | --- |
| `Provider:Active` | Fornecedor ativo: `openai`, `openrouter`, `anthropic`, `lmstudio`, `custom` | detetado do base URL |
| `Provider:<id>:Model` | Id do modelo por fornecedor (seletor pesquisável com badges de capacidades) | preset |
| `Provider:<id>:BaseUrl` | Endpoint, editável para fornecedores compatíveis com OpenAI | preset |
| `Provider:<id>:ReasoningEffort` | `Off` / `Low` / `Medium` / `High` / `Max`, onde o modelo o suporta | `Off` |
| Chaves de API | Definidas na aplicação; cifradas com DPAPI por utilizador. Fallbacks de ambiente: `OPENAI_API_KEY`, `OPENROUTER_API_KEY`, `ANTHROPIC_API_KEY` | — |
| `Assistant:MaxTokens` | Máximo de tokens por resposta (256-128000) | `4096` |
| `Assistant:Temperature` | 0-2; desativada para modelos de raciocínio | `0.7` |
| `Assistant:MaxToolIterations` | Rondas de tool calls por turno (1-15) | `15` |
| `Assistant:StreamingEnabled` | Streaming server-sent | on |
| Toggles por tool | Ativa/desativa cada uma das 21 tools (`Assistant:DisabledTools`) | todas ativas |
| `ErpTools:Enabled` | Kill switch para a camada de tools inteira | on |
| Pesquisa web | Fornecedores (`tavily`, `brave`, `serper`, `exa`, `searxng` self-hosted) + chaves no cofre cifrado; modo fan-out ou fallback | `tavily` |
| System prompt personalizado | Instruções extra acrescentadas ao prompt incorporado | vazio |
| Tema | Claro / escuro / sistema, toggle no cabeçalho do chat | sistema |
| Exportação | Pasta, formato por omissão (`md`/`html`/`txt`), abertura automática | `md` |

---

## Trade-offs de design

Escolhas que parecem estranhas vistas de fora e são deliberadas:

- **.NET Framework 4.8.** O addon corre in-process dentro do cliente Primavera v10, que é um
  host .NET Framework. O runtime é imposto, não escolhido — nenhuma API .NET 5+ em lado
  nenhum.
- **WinForms + WebView2.** O host é WinForms/DevExpress; reconstruir a shell nunca esteve em
  cima da mesa. O chat precisava de uma superfície moderna, por isso é uma página WebView2
  com todas as bibliotecas de renderização vendored — sem CDN, funciona offline, e a CSP
  obriga a isso.
- **Fallback UIA para a automação de janelas.** O Primavera ainda traz editores clássicos da
  era VB6 que o modelo de objetos .NET não vê. A automação tenta primeiro o modelo de
  objetos in-process e recorre a UI Automation (FlaUI/UIA3) numa worker thread dedicada —
  mais lento, mas torna as janelas nativas automatizáveis também.
- **Sem projetos de teste.** A verificação é um build limpo mais uma execução dentro do ERP.
  Quase todos os comportamentos relevantes dependem de um host vivo licenciado — objetos
  BSO/PSO, editores DevExpress, WebView2 — pelo que testes unitários aqui exercitariam
  sobretudo mocks exatamente das partes que se partem. Um trade-off, não uma virtude.
- **OpenAI SDK vendored.** Um cliente baseado no Betalgo vive no repositório (`OpenAI.SDK`)
  em vez de uma dependência NuGet: precisava de compatibilidade com .NET Framework 4.8, de
  suporte Anthropic nativo e de comportamento de streaming/tool calling afinado para este
  addon, sem deriva do upstream. Mantém-se independente — sem referência de volta ao AITOOL.

---

## Para lá do Primavera

Hoje o AITOOL é um agente para o **ERP Primavera v10 da Cegid** — esse foco é a razão pela
qual as tools parecem nativas: falam objetos BSO, séries do ERP, regras fiscais portuguesas.
A arquitetura por baixo já está dividida em camadas que não conhecem o Primavera: a
abstração de fornecedores, a superfície de chat, o contrato de tools (`IErpTool`), o modelo
de auditoria. As especificidades do ERP vivem atrás dessas costuras.

Dito como intenção, não como capacidade entregue: a direção é servir **outros ERPs** a
seguir, e tornar-se **agnóstico de ERP** com o tempo — o mesmo assistente, o mesmo modelo de
confiança (on-premise, o seu fornecedor de IA, preview antes de gravar, escritas auditadas),
com a integração do ERP como camada plugável. Um passo relacionado no mesmo caminho é falar
[MCP](https://modelcontextprotocol.io) (Model Context Protocol): o transporte Streamable
HTTP da spec MCP atual suporta servidores stateless, o que encaixa no modelo in-process e
por turno deste addon — um cliente MCP no AITOOL deixaria o assistente consumir servidores
de tools de terceiros para lá das 21 tools incorporadas. Veja [ROADMAP.md](ROADMAP.md) para
onde isso se situa em relação ao resto.

---

## Roadmap

Para onde isto vai, e o que está deliberadamente fora do âmbito, vive em
[ROADMAP.md](ROADMAP.md). Itens mais próximos: um portão de confirmação de UI obrigatório
nas escritas, mostrar as tool calls e o SQL por trás de cada resposta, entrada de faturas e
exportação de tabelas.

---

## Estrutura do repositório

<div align="center">
<img src="docs/assets/repo-layout.svg" alt="Estrutura do repositório: as pastas do addon AITOOL (AI, Chat, ERP, Common, UI, Infrastructure), projetos irmãos (OpenAI.SDK, Shared.Config, ReportEngine) e pastas de suporte (Installer, docs, sql, Lib)" width="920">
</div>

---

## Privacidade e tratamento de dados

- As mensagens de chat **e os dados do ERP que o assistente obtém por si** (clientes,
  vendas, stock, saldos) são enviados para o **fornecedor de IA que configurar** (OpenAI /
  OpenRouter / Anthropic / o seu endpoint). Reveja a política de uso de dados desse
  fornecedor. Com um endpoint local (LM Studio), nada sai da máquina.
- As chaves de API ficam guardadas **cifradas na sua máquina** (Windows DPAPI, por
  utilizador) e são enviadas apenas para o fornecedor configurado — nunca para a Bola Labs.
- As escritas no ERP acontecem apenas através dos seus objetos de negócio, desenhadas como
  preview e depois gravação confirmada, com cada resultado na `AI_AuditLog`; não há escritas
  diretas nas tabelas core do ERP. Nenhum conteúdo de chat é alguma vez enviado à Bola Labs
  como telemetria.
- O histórico de chat fica no seu SQL Server. Os logs são locais; em RELEASE, eventos de
  nível erro podem ir para o Sentry com chaves, connection strings e caminhos de utilizador
  redigidos — veja [SECURITY.md](SECURITY.md).

---

## Feedback

Os Issues e as Discussions em [BolaLabs/AITOOL](https://github.com/BolaLabs/AITOOL) são onde o
produto melhora — veja [CONTRIBUTING.md](CONTRIBUTING.md) para o que incluir num relato.
Padrões da comunidade: [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md). Para o que não deva ser
público — uma instalação, uma parceria, um relato de segurança — escreva para <bruno@bolalabs.pt>.

---

## Licença

[Licença Community do AITOOL](LICENSE.pt) — gratuita para qualquer uso, incluindo comercial e
redistribuição do instalador inalterado; não é open source. A licença cobre apenas o software
da Bola Labs: os componentes de terceiros (SDK Primavera/Cegid, DevExpress, Crystal Reports e outros)
mantêm-se sob as suas próprias licenças. Nenhum binário da Cegid ou da SAP é redistribuído
aqui; o instalador leva o runtime DevExpress ao abrigo dos termos de redistribuição da
DevExpress — veja [THIRD-PARTY-NOTICES.md](THIRD-PARTY-NOTICES.md) e
[DISTRIBUTION.md](DISTRIBUTION.md).

O nome e o logótipo AITOOL são marcas — veja [TRADEMARKS.md](TRADEMARKS.md). Licenças de
código, builds white-label, deployment, uso em produção com suporte e futuras funcionalidades
premium estão em [COMMERCIAL.md](COMMERCIAL.md). Os ativos de marca e as regras de uso
vivem em [docs/brand](docs/brand/README.md).

Copyright 2025-2026 Bruno Marques — Bola Labs

---

## Documentação

| Recurso | Descrição |
| --- | --- |
| [INSTALL.pt.md](INSTALL.pt.md) | Instalação para utilizadores finais |
| [ARCHITECTURE.md](ARCHITECTURE.md) | Fluxo de dados, integração WebView2, empacotamento |
| [docs/CONFIGURATION.md](docs/CONFIGURATION.md) | Referência completa de configuração |
| [Installer/README.md](Installer/README.md) | Build do instalador, ordem de deteção, assinatura |
| [docs/SECURITY-AND-PRIVACY.pt.md](docs/SECURITY-AND-PRIVACY.pt.md) | O que um aprovador de IT valida: o que sai da máquina, o que fica guardado, o que limita o assistente |
| [SECURITY.md](SECURITY.md) | Armazenamento de credenciais, tratamento de dados, reporte de vulnerabilidades |
| [DISTRIBUTION.md](DISTRIBUTION.md) | Como o AITOOL pode ser distribuído (binário vs código fonte) |
| [THIRD-PARTY-NOTICES.md](THIRD-PARTY-NOTICES.md) | Componentes de terceiros e licenças |
| [CONTRIBUTING.md](CONTRIBUTING.md) | Como reportar problemas e sugerir alterações |
| [CHANGELOG.md](CHANGELOG.md) | Histórico de versões |

---

<div align="center">

<img src="docs/assets/bolalabs-logo.png" alt="Bola Labs" width="180">

Feito pela **Bola Labs** para o ERP Primavera v10 da Cegid.

[![Website](https://img.shields.io/badge/bolalabs.pt-visit-D9A441)](https://bolalabs.pt)
[![GitHub](https://img.shields.io/badge/GitHub-BolaLabs-181717?logo=github)](https://github.com/BolaLabs)

</div>
