# Manual do AITOOL

Para quem usa o assistente dentro do Primavera v10 todos os dias: contabilidade, vendas,
compras, back office. A instalação está no [INSTALL.pt.md](../INSTALL.pt.md); o que o produto
é e como está construído, no [README](../README.pt.md).

Todos os exemplos foram feitos na DEMOV10, a empresa de demonstração da Cegid, na versão que
acompanha este manual. Códigos como `SOFRIO`, `F0003` ou `A0001` são dessa empresa.

**Os pedidos mais usados**

| Para | Escreva, por exemplo | Secção |
| --- | --- | --- |
| Uma fatura ou proposta | *Faz uma fatura à SOFRIO com 2 A0002* | [5](#5-criar-documentos-e-fichas-sem-abrir-o-editor) |
| Uma linha no editor aberto | *Põe uma linha de 3 A0002 a 250 €* | [4](#4-preencher-um-ecrã-por-escrito) |
| Um artigo com variantes | *Põe 2 do I0001 com DDR2-1024 e MT2200* | [4](#4-preencher-um-ecrã-por-escrito) |
| Um artigo com fórmula | *Põe 2 peças do A0005 com 1,5 de largura e 2 de comprimento* | [4](#4-preencher-um-ecrã-por-escrito) |
| Um recibo, pagamento ou encontro de contas | *Faz um recibo ao cliente SOFRIO de 100 euros* | [5](#recibos-pagamentos-e-encontros-de-contas) |
| Aprovar faturas para pagamento | *Aprova para pagamento as faturas do fornecedor F0003* | [5](#recibos-pagamentos-e-encontros-de-contas) |
| Distribuir um valor no editor de liquidações | *Põe 500 em valor a liquidar e distribui* | [5](#recibos-pagamentos-e-encontros-de-contas) |
| Saber o que se passa | *Quais os pendentes da SOFRIO?* | [2](#2-perguntar-pelos-seus-dados) |
| O PDF oficial de um documento | *Imprime a fatura FA C/4* | [2](#2-perguntar-pelos-seus-dados) |

O que grava espera sempre pelo seu clique no cartão ([secção 6](#6-o-cartão-de-confirmação)).

---

## 1. Abrir

O friso tem um separador **BOLA LABS** com o botão **Assistente AI**. O chat abre encostado à
direita do ERP; o botão no topo do painel solta-o numa janela própria. `Ctrl+N` começa uma
conversa nova, `Ctrl+B` abre a lista de conversas, `Ctrl+,` as definições.

Da primeira vez, as definições pedem uma chave de IA (OpenAI, Anthropic, OpenRouter, um
endpoint compatível ou um servidor local). Não há mais nada para configurar.

## 2. Perguntar pelos seus dados

Escreva a pergunta como a faria a um colega. A resposta vem dos dados do próprio ERP e,
quando o ERP tem uma consulta sua (os pendentes, por exemplo), dessa consulta.

| Escreve | Recebe |
| --- | --- |
| *Que pendentes tem o cliente SOFRIO?* | Os documentos pendentes, em cartões e numa tabela viva |
| *Quanto vendemos do artigo A0001 desde 2019 e a que clientes?* | As vendas líquidas desse artigo, por cliente |
| *Vendas por mês de 2016* | Um gráfico e a tabela por trás dele |
| *Qual o stock do A0002 por armazém?* | O stock por armazém |
| *Quais os 10 melhores clientes do ano passado?* | Um ranking com os totais |

Cada linha de uma tabela tem um menu: abrir a ficha no ERP, gerar o PDF, ver os pendentes.
**Copiar** copia a tabela para colar no Excel. *Imprime a fatura FA C/4* gera o PDF com o mapa
da série, ATCUD e QR, e o cartão tem Ver, Imprimir e Guardar como.

### Sabe o que tem aberto

Cada mensagem leva a ficha aberta no ERP (um cliente, um fornecedor, um artigo) e a janela
da frente. *"Quanto deve este cliente?"* com a ficha de um cliente aberta não precisa de
código. O cabeçalho do chat mostra o que está a ser partilhado e tem um interruptor para o
desligar. Escrever `@` e um nome traz qualquer outra ficha para a mensagem.

## 3. Abrir qualquer ecrã pelo nome

*"Abre o explorador de vendas"*, *"abre a ficha do fornecedor F0003"*, *"abre o editor de
liquidações"*. O assistente procura a função no catálogo do próprio friso do ERP, em todos os
módulos que a empresa tem, e abre-a. Quando o botão do friso está à vista, o cursor desliza
até ele, para se ver o que está a ser clicado.

Da primeira vez que uma expressão é usada, o cartão mostra para onde foi e pergunta **Era
isto** / **Não era isto**. A resposta fica guardada para todos os postos da empresa.

## 4. Preencher um ecrã por escrito

Reduz o esforço motor: quem não pode usar o rato, ou prefere não o
usar, conduz as janelas do ERP por texto.

- *"Que campos tem esta janela?"* lista os campos da janela da frente, separador a
  separador, com os valores atuais.
- *"Põe o cliente SOFRIO"* põe o cliente no campo de entidade do documento, confirma que o
  documento aceita esse tipo de entidade e lê o nome que o ERP mostra.
- *"Data de hoje, condição de pagamento a 45 dias, armazém 2"* preenche vários campos de uma
  vez. Expressões como "Fatura a 45 dias" ou "Armazém 2" passam aos códigos que as tabelas da
  empresa têm para elas; quando servem dois códigos, pergunta qual.
- *"Uma linha do artigo A0002, quantidade 3, preço 250"* acrescenta uma linha ao documento.
  Nos editores de vendas, compras e documentos internos, o artigo entra na grelha e a
  quantidade, o preço, o desconto, a descrição e o armazém entram na linha do documento
  pelos eventos do próprio editor, para o ERP calcular a linha como se a tivesse escrito.
- *"Põe 2 do I0001 com DDR2-1024 e MT2200 e 1 com DDR2-512 e MT2500"*: num artigo com
  dimensões, o assistente preenche a grelha de variantes do ERP e confirma-a; o documento fica
  com a linha agregadora do artigo e uma linha por variante, como se as escolhesse. Sem dizer
  quais, pergunta; *"abre a grelha que eu escolho"* deixa-a aberta para si. Se cancelar a
  grelha, o ERP deixa a linha do artigo sem variantes (quantidade 0): apaga-se com o botão
  direito nessa linha, em "Remove Linha".
- *"Põe 2 peças do A0005 com 1,5 de largura e 2 de comprimento"*: num artigo com fórmula, as
  medidas vão para a janela "Fórmula" do ERP e a linha fica com a quantidade que o ERP calcula.
- *"Lê o diálogo"* lê uma mensagem que o ERP abriu e diz o que faz cada resposta.

Quando o ERP abre uma janela que bloqueia o resto (a grelha de variantes, "Fórmula", "Números
de Série", um aviso), o assistente passa para uma janela própria no mesmo lugar e continua a
responder; volta ao painel quando essa janela fecha. Desliga-se em Definições → Avançado →
Comportamento.

Os campos de separadores que não estão à vista são alcançados sem mudar de separador à mão.

**O que nunca faz sozinho:** carregar num botão que grava, anula ou apaga. Gravar,
Confirmar, Anular, Apagar e afins passam pelo cartão de confirmação (secção 6), e o mesmo vale
para responder "Sim" a um diálogo do ERP como "gravar as alterações?". Com o assistente ancorado
no painel, essa resposta é sua, no ERP.

## 5. Criar documentos e fichas sem abrir o editor

Nas escritas mais comuns o assistente vai diretamente ao motor de negócio do ERP. Nada é
escrito numa janela; o ERP valida exatamente como quando grava à mão, e a numeração é a do
ERP.

| Escreve | Prepara |
| --- | --- |
| *Cria o cliente Exemplo Lda, NIF 999999990* | Uma ficha de cliente |
| *Cria o artigo AIT1018 "Cabo HDMI 2 m", unidade UN, IVA 23* | Uma ficha de artigo |
| *Faz uma proposta ao SOFRIO com 2 A0001* | Um documento de venda, com os preços e totais do ERP |
| *Lança a fatura do fornecedor F0003, documento FT 2026/123, 5 A0002 a 300 euros* | Um documento de compra |
| *Faz um recibo ao cliente SOFRIO de 100 euros* | Um recibo de cliente |
| *Paga 200 euros ao fornecedor F0001* | Um pagamento a fornecedor |
| *Faz um encontro de contas do cliente SOFRIO de 150 euros* | Uma compensação entre cliente e fornecedor |
| *Recebe tudo o que o cliente MICROSOFTPOR deve* | Um recibo do saldo todo |

### Recibos, pagamentos e encontros de contas

- Os documentos pendentes vêm da tabela de pendentes do ERP, limitados ao que o tipo de
  liquidação está configurado para liquidar.
- Com um valor, liquidam-se primeiro as dívidas mais antigas, a última em parte. As notas de
  crédito e adiantamentos em aberto ficam em aberto, a não ser que os indique ou peça para
  liquidar tudo; o cartão diz quanto ficou de fora.
- Sem valor, liquida-se o saldo todo, notas de crédito incluídas.
- Um encontro de contas usa o fornecedor associado ao cliente na ficha ou, se não houver, o
  fornecedor com o mesmo NIF. Também pode indicar o fornecedor.
- Um documento que está pendente mas num estado que o tipo de liquidação não aceita (uma
  fatura de fornecedor à espera de aprovação de pagamento, por exemplo) é explicado com o
  nome do estado no ERP e o documento que muda esse estado. Não aparece como "não pendente".
- "Aprova para pagamento as faturas do fornecedor X" grava a aprovação (o documento APR do
  ERP) a partir do cartão: as faturas passam de "Aguarda Aprovação" a "Aprovada" e nada é
  pago; o pagamento é o passo seguinte, com o seu próprio cartão.
- No editor de liquidações (Contas Correntes), "põe 500 em valor a liquidar e distribui"
  preenche o Valor Entregue do separador Distribuição Automática e carrega em Distribuir:
  o ERP reparte o valor pelos pendentes mais antigos sem gravar nada; só o Confirmar grava,
  e esse passa pelo cartão.
- Quando a ficha do cliente não tem modo de pagamento e o tipo de liquidação comunica ao
  SAF-T, usa-se o modo com que esse tipo costuma ser gravado, e o cartão di-lo.

## 6. O cartão de confirmação

Cada escrita é mostrada antes de acontecer, num cartão com:

- o tipo de documento e a série, a entidade e o nome;
- cada linha, ou cada documento liquidado, com o valor que vai ser liquidado;
- os totais do próprio ERP: mercadoria, descontos, IVA, retenção na fonte, total, ou o valor
  compensado num encontro de contas;
- os avisos, a âmbar: uma escolha por omissão da ferramenta, um crédito que ficou em aberto,
  um campo que o ERP preencheu.

A gravação corre quando carrega no botão do cartão e em mais nada. Escrever "sim" no chat
não grava. Depois de gravar, o cartão diz **Gravado** com o número que o ERP deu; se o ERP
parou num diálogo, o cartão diz o que falta responder lá.

Cada gravação, recusa e falha fica em `AI_AuditLog` na base de dados da empresa, com o
utilizador, a ferramenta e o resultado. `/auditoria` mostra as suas; os supervisores
(administradores e técnicos) veem as de todos com `/auditoria todos`.

## 7. O que faz sozinho

- **Vários passos de uma vez.** "Abre o editor de compras para o F0003 com uma linha do
  A0002" é um pedido só: abrir o editor, pôr o fornecedor, acrescentar a linha. Os passos
  correm num lote e param no primeiro que falhe ou que precise da sua confirmação.
- **Aprende os pedidos que se repetem.** Um pedido que correu limpo passa a receita. A partir
  da terceira vez corre diretamente, sem pedir o plano ao modelo de IA: o mesmo tipo de
  pedido com outros valores (outro cliente, outro artigo) demora segundos. `/receitas` lista
  o que aprendeu, e uma receita nunca grava sozinha: as escritas continuam a passar pelo
  cartão.
- **Aprende a maneira de falar da empresa.** "NIF" para Contribuinte, "plafond" para Limite
  de crédito, "editor de liquidações" para Pagamentos e Recebimentos → Operações. Aprende com
  os valores que o ERP guardou, com as correções e com as suas respostas nos cartões, e
  partilha isso com todos os postos pela base de dados da empresa. O que rejeita não volta a
  ser proposto.
- **Escolhe por omissão o que faz sentido e di-lo.** Um tipo de fatura de compra quando não
  se indica nenhum (o que a empresa mais usa), a série por omissão para hoje, uma condição ou
  modo de pagamento quando a ficha não os tem. Cada escolha é um aviso no cartão, nunca uma
  decisão calada.
- **Avisa quando está lento.** Um passo demorado mostra de que está à espera; um modelo que
  não responde em 30 segundos é repetido uma vez.
- **Mantém o modelo de IA honesto.** Quando um modelo diz que fez alguma coisa no ERP sem ter
  chamado uma ferramenta, o addon volta a pedir-lhe com a ferramenta obrigatória, e avisa se
  ele insistir.

## 8. Escolher o modelo de IA

Qualquer modelo com chamada de ferramentas funciona; a diferença está na rapidez, no custo e
em quantas vezes precisa da rede de segurança da secção 7. Na nossa bancada de 2026-10-18 (os
mesmos nove pedidos, ERP real):

| Resultado | Modelos |
| --- | --- |
| Excelente | gpt-oss-120b, MiniMax M3, Nemotron 3.5 Lightning, Claude Haiku 5.5, Mistral Small, GPT-6 Luna |
| Bom | GPT-5.6 Sol (mais lento e mais caro), GLM, DeepSeek, Gemini Flash, Qwen3 14B, Kimi K3 |
| Funciona com a rede de segurança | Llama 4 Maverick |
| Não recomendado | modelos muito pequenos sem chamada de ferramentas |

O chip do modelo no cabeçalho do chat muda de modelo; o chip do raciocínio troca rapidez por
profundidade. O painel de sessão (o contador no cabeçalho) mostra os tokens e o custo
estimado de cada pedido.

## 9. Comandos e atalhos

| Comando | O que faz |
| --- | --- |
| `/novo` | Conversa nova |
| `/limpar` | Limpa a conversa atual |
| `/exportar` | Exporta para Markdown, HTML ou texto |
| `/config` | Definições |
| `/auditoria [N]`, `/auditoria todos [N]` | A sua auditoria, ou a de todos (supervisores) |
| `/compactar` | Resume uma conversa longa para libertar contexto |
| `/skills` | As skills da empresa (processos escritos em Markdown) |
| `/receitas` | Os pedidos que aprendeu a fazer diretamente |
| `/ajuda` | Ajuda |

`Ctrl+N` conversa nova · `Ctrl+B` conversas · `Ctrl+E` exportar · `Ctrl+,` definições · `Enter` envia ·
`Shift+Enter` nova linha.

## 10. Quando alguma coisa corre mal

- Os cartões de erro trazem uma referência como **ref. T-1a2b**. Dê-a ao suporte: identifica
  a volta no registo.
- Definições → Diagnóstico gera um pacote de suporte (relatório e sete dias de registos,
  sem dados sensíveis).
- Uma janela que não responde ao assistente tem normalmente um diálogo do ERP aberto por
  trás: responda-lhe no ERP e volte a pedir.
- Uma expressão que foi parar ao sítio errado: responda **Não era isto** no cartão. Não volta
  a ser proposta.

## 11. Limites que convém saber

- Não aplica as permissões por utilizador do Primavera ao que lê; ver
  [Segurança e privacidade](SECURITY-AND-PRIVACY.pt.md).
- Nunca anula nem apaga documentos sozinho, e não tem ferramenta para isso.
- O Explorador de vendas não tem restrição por artigo: as vendas de um artigo são
  respondidas a partir dos dados, não nessa janela.
- Letras e remessas bancárias fazem-se no ERP; o assistente explica quando um documento
  está à espera de uma delas.
- Artigos com números de série (como o A0004): uma fatura, guia ou nota de crédito criada pelo
  assistente não os pode indicar e o ERP recusa gravá-la, por isso o assistente não a prepara e
  propõe fazer a linha no editor, onde o ERP pede os números. Orçamentos e encomendas, que não
  mexem no stock, fazem-se normalmente.
