# Roadmap

**English** | [Português](ROADMAP.pt.md)

AITOOL already answers from PRIMAVERA, fills its windows and saves documents, receipts and
payments from a card you click. Next, it reads the paperwork that arrives: supplier invoices
from a photo or a PDF, checked against e-Fatura, and collections by MB WAY that come back as
receipts. Every item ships only after it works in a real PRIMAVERA ERP, and
nothing here is a promise of a date: the [README](README.md) describes what exists today, and
the [CHANGELOG](CHANGELOG.md) what each version added.

| Status | Meaning |
| --- | --- |
| **Next** | Designed and planned for the coming versions |
| **Exploring** | Being studied before it is planned; tell us which one you need in [Discussions](https://github.com/BolaLabs/AITOOL/discussions) |
| **Direction** | Where the product is heading after that |

## Recently shipped

| Version | What it brought |
| --- | --- |
| 2.22 | Requests from the user guide reach the right tool on the first message; articles found by name in editor lines and warehouses by the company's codes; keep typing while it answers; a clearer confirmation card; serial-number articles and unknown codes stopped before the ERP's own error dialogs |
| 2.21 | The chat keeps working while an ERP window blocks the rest; variant grids and the "Fórmula" dialog filled from one sentence |
| 2.19 | Approval of supplier invoices for payment (APR); the settlement editor filled and distributed |
| 2.18 | Purchase documents, receipts, payments and account offsetting, each saved only from its card |
| 2.16 | The assistant knows the record and the window you have open, with no selector |

## Next

### Supplier invoices from a photo or a PDF

Drop the PDF or the photo of a supplier invoice into the chat. The assistant reads the AT QR
code that Portuguese invoices carry as the source of truth for the issuer, the date and the
VAT totals, reads the lines the QR does not carry, checks that both add up, and prepares the
purchase document with the original file attached in the ERP's own archive. If something
does not reconcile it stops and says what is missing. You confirm every document; nothing is
posted on its own.

### Purchases checked against e-Fatura

*"Que compras estão no e-Fatura e não estão no ERP?"* The assistant compares the invoices
your suppliers reported to the AT with the purchase documents in the ERP, by tax id, number
and ATCUD, and lists what is missing, what differs in amount and what is in the ERP twice.
It starts from the file the e-Fatura portal exports; anything missing can then go through
the invoice reader above.

### Collections by MB WAY and Multibanco, settled as receipts

*"Cobra os vencidos da SOFRIO por MB WAY."* With your own payment provider account (EasyPay,
ifthenpay, SIBS or Stripe), the assistant creates the MB WAY request or the Multibanco
reference for the pending invoices, checks which were paid, and prepares the receipt for each
one on a confirmation card. Your provider key stays encrypted on your machine.

### Reports and presentations from live ERP data

*"Faz a apresentação do mês para a administração."* PowerPoint, Excel and Word files, or
OpenDocument for LibreOffice, built on your own machine from the figures the assistant read in
the ERP, with the query behind each chart. Nothing is uploaded to make them.

### SAF-T checked before it is sent

*"Verifica o SAF-T de setembro."* The file the ERP exported is checked against the AT schema and
against the ERP itself: gaps in numbering, ATCUD, exemption codes, tax ids, totals. Sending it
stays with the ERP or the AT portal.

### "How did it get this number?"

Behind every figure, on request: the query, the filters and the records that produced it, so
a total can be checked before it is used in a decision.

### A business memory you can see

Default series, a customer's usual terms, house rules: the assistant remembers what you teach
it, in your company's own SQL Server, with where each fact came from. A panel shows everything
it learned, and anything there can be corrected or deleted.

### Every table to Excel, every document by e-mail

A button on every result table that saves it as an Excel file, and e-mails that carry the
document's official PDF as an attachment, ready for you to review and send.

### Your own retention rules

Choose how long conversations and audit entries stay in your database; older ones are removed
from AITOOL's own tables, company by company. Today nothing expires.

### Every answer cheaper and quicker

The assistant's fixed instructions and tool descriptions sent once and reused (prompt caching)
instead of on every step, measured on the same requests in the real ERP. You pay your own AI
provider, so this is money you keep.

## Exploring

- **Morning briefing.** When the ERP opens: overdue items, yesterday's sales, articles below
  minimum stock and documents waiting for approval, in one card.
- **From opportunity to sale.** Move a CRM opportunity to its next stage, log the first contact
  and open it by its code, with the company's own sales cycle.
- **Saved views.** Keep an answer as a view that refreshes with the ERP's data.
- **A second approver above a limit.** Writes above an amount wait for a person with the
  authority to confirm them.
- **A public skills collection.** Skills reviewed publicly, by pull request, and installed from
  Settings.
- **Long conversations.** The conversation summarised automatically before the model's limit.
- **Bank reconciliation.** Bank statements (ISO 20022 camt.053 files first, open banking later,
  under your own contract) matched against pending items, with each receipt on a card.
- **Supplier payment files.** The approved payments as a SEPA file for you to upload to your
  homebanking, with a warning when a supplier's IBAN changed recently.
- **Microsoft 365 and Google Workspace.** Reports saved to OneDrive, SharePoint or Google Drive,
  Outlook drafts with the official PDF attached, a summary posted to a Teams channel.
- **Online shop orders.** Today's WooCommerce, PrestaShop or Shopify orders prepared as ERP
  documents, each one on its card.
- **CTT shipping labels.** The label for a delivery note, from your own CTT account.
- **A browser that works in your session.** Portals such as e-Fatura, Segurança Social Direta
  or a supplier's site opened in a window of the assistant where you sign in yourself; it
  reads and downloads, and any button that submits stays yours.
- **Invoices received by the AT.** A check that every invoice the ERP issued reached e-Fatura.

## Direction

- **Connectors to other systems.** An MCP client so the assistant can use tools other systems
  expose, with the same per-tool switches and audit.
- **Invoicing public entities.** The contract and commitment references an electronic invoice
  to the State needs, checked before the ERP issues it.
- **Signing proposals and contracts** with the Chave Móvel Digital.
- **WhatsApp.** A reminder or a document sent from the chat through WhatsApp, drafted by the
  assistant and sent by you.

## What does not change

- **Nothing is saved without your click.** Every document, record and payment is shown as a
  card first; only the card's button saves.
- **It runs where you decide.** On your ERP, with your AI provider or a model on your own
  network. No Bola Labs server in the path.
- **Every write is audited** in your company's own database.
- **No automatic posting** of accounting movements, and no fiscal document issued outside the
  certified ERP.
- **Nothing fiscal or financial is submitted for you.** SAF-T, declarations and communications
  to the AT stay with the ERP or your portal session, and payments with your bank. The
  assistant checks, reconciles and prepares.
- **Your passwords stay yours.** The assistant never stores AT, Segurança Social or bank
  passwords; you sign in to those portals yourself, and a payment provider key stays encrypted on your
  machine.
- **Skills never carry code.** They are reviewed text instructions that combine the assistant's
  own tools, with the same card and the same audit.
