# Roadmap

[English](ROADMAP.md) | **Português**

O AITOOL já responde a partir do PRIMAVERA, preenche as janelas e grava documentos, recibos e
pagamentos a partir de um cartão em que carrega. A seguir, lê a papelada que chega: faturas de
fornecedor a partir de uma foto ou de um PDF, conferidas com o e-Fatura, e cobranças por MB WAY
que voltam como recibos. Cada ponto só sai depois de funcionar num ERP
PRIMAVERA real, e nada aqui é uma data prometida: o [README](README.pt.md) descreve o que já
existe, e o [CHANGELOG](CHANGELOG.md) o que cada versão acrescentou.

| Estado | Significado |
| --- | --- |
| **A seguir** | Desenhado e previsto para as próximas versões |
| **Em estudo** | Em análise antes de entrar no plano; diga qual lhe faz falta nas [Discussions](https://github.com/BolaLabs/AITOOL/discussions) |
| **Direção** | Para onde o produto segue depois disso |

## Saiu há pouco

| Versão | O que trouxe |
| --- | --- |
| 2.22 | Os pedidos do guia chegam à ferramenta certa à primeira; artigos encontrados pelo nome nas linhas do editor e armazéns pelo código da empresa; continuar a escrever enquanto responde; um cartão de confirmação mais claro; artigos com números de série e códigos inexistentes parados antes das janelas de erro do ERP |
| 2.21 | O chat continua a funcionar quando uma janela do ERP bloqueia o resto; grelhas de variantes e a janela "Fórmula" preenchidas a partir de uma frase |
| 2.19 | Aprovação de faturas de fornecedor para pagamento (APR); o editor de liquidações preenchido e distribuído |
| 2.18 | Documentos de compra, recibos, pagamentos e encontros de contas, cada um gravado só a partir do seu cartão |
| 2.16 | O assistente sabe a ficha e a janela que tem abertas, sem seletor |

## A seguir

### Faturas de fornecedor a partir de uma foto ou de um PDF

Largue no chat o PDF ou a foto de uma fatura de fornecedor. O assistente lê o código QR da AT
que as faturas portuguesas trazem como fonte de verdade do emitente, da data e dos totais de
IVA, lê as linhas que o QR não traz, confirma que tudo bate certo e prepara o documento de
compra com o ficheiro original anexado no arquivo do próprio ERP. Se alguma coisa não bater
certo, para e diz o que falta. Cada documento é confirmado por si; nada é lançado sozinho.

### Compras e vendas conferidas com o e-Fatura

*"Que compras estão no e-Fatura e não estão no ERP?"* O assistente lê o e-Fatura pelo serviço de
consulta da própria AT e compara as faturas que os seus fornecedores comunicaram com os
documentos de compra do ERP, por NIF, número e ATCUD: o que falta, o que difere no valor, o que
está duas vezes no ERP. A mesma conferência corre no outro sentido, *"A AT recebeu todas as
faturas de outubro?"*, para as faturas que o ERP emitiu. O que faltar pode depois passar pelo
leitor de faturas acima. Entra com um subutilizador da sua empresa, criado no Portal das
Finanças só para consulta.

### Cobranças por MB WAY e Multibanco, liquidadas em recibos

*"Cobra os vencidos da SOFRIO por MB WAY."* Com a sua própria conta de um fornecedor de
pagamentos (EasyPay, ifthenpay, SIBS ou Stripe), o assistente cria o pedido MB WAY ou a
referência Multibanco das faturas pendentes, verifica quais foram pagas e prepara o recibo de
cada uma num cartão de confirmação. A chave dessa conta fica cifrada na sua máquina.

### Relatórios e apresentações com os dados vivos do ERP

*"Faz a apresentação do mês para a administração."* Ficheiros PowerPoint, Excel e Word, ou
OpenDocument para o LibreOffice, feitos na sua máquina a partir dos valores que o assistente
leu no ERP, com a consulta por trás de cada gráfico. Nada é enviado para os fazer.

### SAF-T conferido antes de ser enviado

*"Verifica o SAF-T de setembro."* O ficheiro que o ERP exportou é conferido com o esquema da AT
e com o próprio ERP: falhas na numeração, ATCUD, códigos de isenção, NIF, totais. O envio
continua a ser feito pelo ERP ou no Portal das Finanças.

### "Como chegou a este número?"

Por trás de cada valor, quando pedir: a consulta, os filtros e os registos que o produziram,
para um total poder ser verificado antes de servir uma decisão.

### Uma memória do negócio que se vê

Séries por omissão, as condições habituais de um cliente, regras da casa: o assistente lembra o
que lhe ensinar, no SQL Server da sua empresa, com a origem de cada facto. Um painel mostra tudo
o que aprendeu, e qualquer coisa ali pode ser corrigida ou apagada.

### Qualquer tabela em Excel, qualquer documento por e-mail

Um botão em cada tabela de resultados que a guarda como ficheiro Excel, e e-mails que levam o
PDF oficial do documento em anexo, prontos para rever e enviar.

### Os seus prazos de retenção

Escolha quanto tempo as conversas e os registos de auditoria ficam na sua base de dados; os mais
antigos saem das tabelas do próprio AITOOL, empresa a empresa. Hoje nada expira.

### Cada resposta mais barata e mais rápida

As instruções fixas e as descrições das ferramentas enviadas uma vez e reaproveitadas (cache do
prompt) em vez de em cada passo, medido nos mesmos pedidos no ERP real. Paga diretamente ao seu
fornecedor de IA, por isso é dinheiro que fica consigo.

## Em estudo

- **Resumo da manhã.** Quando o ERP abre: pendentes vencidos, vendas de ontem, artigos abaixo do
  stock mínimo e documentos à espera de aprovação, num só cartão.
- **Da oportunidade à venda.** Avançar uma oportunidade do CRM para a fase seguinte, registar o
  primeiro contacto e abri-la pelo código, com o ciclo de vendas da empresa.
- **Vistas guardadas.** Guardar uma resposta como uma vista que se atualiza com os dados do ERP.
- **Um segundo aprovador acima de um limite.** Gravações acima de um valor esperam por quem tem
  autoridade para as confirmar.
- **Uma coleção pública de skills.** Skills revistas publicamente, por pull request, e
  instaladas a partir das Definições.
- **Conversas longas.** A conversa resumida automaticamente antes do limite do modelo.
- **Reconciliação bancária.** Extratos bancários (primeiro ficheiros ISO 20022 camt.053, depois
  open banking, com o seu próprio contrato) cruzados com os pendentes, com cada recibo num cartão.
- **Ficheiros de pagamento a fornecedores.** Os pagamentos aprovados num ficheiro SEPA para
  carregar no seu homebanking, com um aviso quando o IBAN de um fornecedor mudou há pouco.
- **Microsoft 365 e Google Workspace.** Relatórios guardados no OneDrive, SharePoint ou Google
  Drive, rascunhos do Outlook com o PDF oficial em anexo, um resumo publicado num canal do Teams.
- **Encomendas da loja online.** As encomendas do dia da WooCommerce, PrestaShop ou Shopify
  preparadas como documentos do ERP, cada uma no seu cartão.
- **Etiquetas de envio CTT.** A etiqueta de uma guia de remessa, com a sua própria conta CTT.
- **Um browser que trabalha na sua sessão.** Portais como o e-Fatura, a Segurança Social Direta
  ou o site de um fornecedor abertos numa janela do assistente onde entra você; ele lê e
  descarrega, e qualquer botão que submete fica consigo.

## Direção

- **Conectores a outros sistemas.** Um cliente MCP para o assistente usar ferramentas que
  outros sistemas exponham, com os mesmos interruptores por ferramenta e a mesma auditoria.
- **Faturação a entidades públicas.** As referências de contrato e de compromisso que uma
  fatura eletrónica ao Estado exige, conferidas antes de o ERP a emitir.
- **Assinar propostas e contratos** com a Chave Móvel Digital.
- **WhatsApp.** Um lembrete ou um documento enviado do chat pelo WhatsApp, redigido pelo
  assistente e enviado por si.

## O que não muda

- **Nada é gravado sem o seu clique.** Cada documento, ficha e pagamento aparece primeiro num
  cartão; só o botão do cartão grava.
- **Corre onde decidir.** No seu ERP, com o seu fornecedor de IA ou um modelo na sua própria
  rede. Nenhum servidor da Bola Labs no caminho.
- **Cada gravação fica auditada** na base de dados da sua empresa.
- **Sem lançamentos automáticos** de movimentos contabilísticos, e nenhum documento fiscal
  emitido fora do ERP certificado.
- **Nada fiscal ou financeiro é submetido em seu nome.** O SAF-T, as declarações e as comunicações à
  AT continuam no ERP ou na sua sessão do portal, e os pagamentos no seu banco. O assistente
  confere, reconcilia e prepara.
- **As suas palavras-passe ficam consigo.** O assistente nunca guarda as suas palavras-passe do
  Portal das Finanças, da Segurança Social ou do banco; entra você nesses portais. O que guarda,
  o subutilizador de consulta do e-Fatura e a chave do fornecedor de pagamentos, fica cifrado
  na sua máquina e nunca chega à Bola Labs.
- **As skills nunca trazem código.** São instruções em texto, revistas, que combinam as
  ferramentas do próprio assistente, com o mesmo cartão e a mesma auditoria.
