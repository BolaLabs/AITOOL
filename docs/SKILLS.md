# Skills

A skill is a workflow written for the assistant in plain Markdown: which tools to use, in
what order, what to confirm, what never to do. The assistant reads it when a request
matches the skill's description and follows it. No code runs from a skill — it can only
combine the tools the addon already has, with the same confirmation card on every write and
the same audit trail.

Portuguese version: [SKILLS.pt.md](SKILLS.pt.md).

## Where skills live

| Folder | Who | Notes |
|---|---|---|
| `<ERP>\Config\EV\Extensions\AITOOL\Skills\<name>\SKILL.md` | The addon itself | The skills that ship with each version (`incluída` in `/skills`); replaced on every update, so do not edit here |
| `%ProgramData%\AITOOL\Skills\<name>\SKILL.md` | Everyone on this machine (and, in client-server setups, every workstation that shares it) | Created empty by the installer, which resets its ACL on every run so that only SYSTEM and administrators can write; an update never touches what is in it |
| `%LocalAppData%\Cegid\Extensions\AITOOL\Skills\<name>\SKILL.md` | You | Open it from Settings → Skills → "Abrir a minha pasta de skills" |

A shared skill with the same name as a shipped one replaces it, and a skill in your folder
replaces both. A folder or `name` starting with `_` is a template: listed, never offered to
the assistant. Skills you switch off are remembered in
`%LocalAppData%\Cegid\Extensions\AITOOL\skills-disabled.json` — a per-user file, so
switching off a shared skill affects only you. Settings → Skills lists how many skills were
found and, for each one, an Incluída / Partilhada / Minha pill, the description, the phrases
that trigger it, and the switch. "Abrir pasta partilhada" is shown only to a supervisor (an
ERP administrator, super administrator or technician), because what lands there runs for
everyone on the machine. `/skills` in the chat lists them; `/skills recarregar` reads the
folders again and rebuilds the system prompt of the open conversation, so the next message
already sees the change.

## The file

```markdown
---
name: prospecao-de-leads
description: Finds target companies, creates the customer record if missing,
  opens a CRM sales opportunity and prepares a contact e-mail for review.
triggers: leads, prospeção, empresas-alvo, oportunidade de venda
tools: web_search, search_entities, enrich_entity, create_entity,
  create_opportunity, draft_email
version: 1.0
author: BolaLabs
---

# Prospeção de leads

1. Understand the target (sector, area, size). Ask one thing at a time if something is missing.
2. `web_search` for candidates; collect name, tax id, site, e-mail.
3. `search_entities` by tax id and name: reuse an existing customer.
4. Otherwise `enrich_entity`, then `create_entity` (preview, then the card).
5. `create_opportunity` (preview, then the card).
6. `draft_email` for the company contact, or for the user when an internal summary was asked.
```

Header keys:

- `name`: short, no spaces; it is how the assistant calls the skill. Missing, the folder name is used.
- `description` (required): one sentence; the assistant reads it to decide whether the skill applies.
- `triggers`: words that usually appear in the request, comma-separated.
- `tools`: the tools the skill expects to use, comma-separated. The list guides the
  assistant; it does not restrict it. What the assistant may call is decided in Settings, and
  a tool switched off there stays off whatever the skill says.
- `version`, `author`: free text, shown in Settings.

The body is free Markdown. Keep the instructions under 12 000 characters (the header does not
count); a longer body is listed with a problem and never used. Write it the way you would brief a new colleague: what to ask first,
which tool answers each step, what to do with the result, where to stop and ask.

## What a skill cannot do

- Skip the confirmation of a save. `create_entity`, `update_entity`,
  `create_sales_document` and `create_opportunity` always preview first, and the confirmation
  is always the card: the commit needs a single-use token the application issues when it draws
  that card and the user's click returns. A skill that tells the assistant to save directly,
  or to accept a typed "sim", changes nothing — the call is refused and audited.
- Override the system prompt. The skill's instructions are loaded after it, and the prompt
  tells the model that skills never dispense with its rules.
- Send anything. `draft_email` prepares a draft the user opens in their own mail client.
- Reach systems the addon has no tool for. Calling external APIs (payments, CRMs, ticketing)
  needs a dedicated tool with its own credentials and audit; see [ROADMAP.md](../ROADMAP.md).

## Shipped skills

| Skill | What it does |
|---|---|
| `prospecao-de-leads` | Web search for target companies → existing customer check → customer record (preview, card) → CRM sales opportunity (preview, card) → e-mail draft for review |
| `_modelo` | The template to copy; it stays disabled until renamed |

## Sharing skills

A skill is a folder: zip it, mail it, or publish it in a Git repository. A public collection
reviewed by pull request is planned as `BolaLabs/AITOOL-skills`; until it exists, the
`_modelo` folder and this page are the spec. Never put credentials or customer data in a
`SKILL.md`: it is read into every request that uses the skill.
