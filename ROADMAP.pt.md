# Roadmap

[English](ROADMAP.md) | **Português**

O AITOOL já responde a partir do PRIMAVERA, preenche as janelas e grava documentos, recibos e
pagamentos a partir de um cartão em que carrega. A seguir, lê a papelada que chega: faturas de
fornecedor a partir de uma foto ou de um PDF. Cada ponto só sai depois de funcionar num ERP
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
- **Cobranças com referências Multibanco e MB WAY.** Uma skill revista que cria referências de
  pagamento para faturas pendentes e verifica quais foram pagas.
- **Da oportunidade à venda.** Avançar uma oportunidade do CRM para a fase seguinte, registar o
  primeiro contacto e abri-la pelo código, com o ciclo de vendas da empresa.
- **Vistas guardadas.** Guardar uma resposta como uma vista que se atualiza com os dados do ERP.
- **Um segundo aprovador acima de um limite.** Gravações acima de um valor esperam por quem tem
  autoridade para as confirmar.
- **Uma coleção pública de skills.** Skills revistas publicamente, por pull request, e
  instaladas a partir das Definições.
- **Conversas longas.** A conversa resumida automaticamente antes do limite do modelo.

## Direção

- **Ferramentas de outros sistemas.** Um cliente MCP para o assistente usar ferramentas que
  outros sistemas exponham, com os mesmos interruptores por ferramenta e a mesma auditoria.

## O que não muda

- **Nada é gravado sem o seu clique.** Cada documento, ficha e pagamento aparece primeiro num
  cartão; só o botão do cartão grava.
- **Corre onde decidir.** No seu ERP, com o seu fornecedor de IA ou um modelo na sua própria
  rede. Nenhum servidor da Bola Labs no caminho.
- **Cada gravação fica auditada** na base de dados da sua empresa.
- **Sem lançamentos automáticos** de movimentos contabilísticos, e nenhum documento fiscal
  emitido fora do ERP certificado.
- **As skills nunca trazem código.** São instruções em texto, revistas, que combinam as
  ferramentas do próprio assistente, com o mesmo cartão e a mesma auditoria.
