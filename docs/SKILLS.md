# Skills

A skill is a workflow written for the assistant in plain Markdown: which tools to use, in
what order, what to confirm, what never to do. The assistant reads it when a request
matches the skill's description and follows it. No code runs from a skill — it can only
combine the tools the addon already has, with the same two-step confirmation and the same
audit trail.

Portuguese version: [SKILLS.pt.md](SKILLS.pt.md).

## Where skills live

| Folder | Who | Notes |
|---|---|---|
| `<ERP>\Config\EV\Extensions\AITOOL\Skills\<name>\SKILL.md` | The addon itself | The skills that ship with each version (`incluida` in `/skills`); replaced on every update, so do not edit here |
| `%ProgramData%\AITOOL\Skills\<name>\SKILL.md` | Everyone on this machine (and, in client-server setups, every workstation that shares it) | The installer places the shipped skills here and never overwrites your edits |
| `%LocalAppData%\Cegid\Extensions\AITOOL\Skills\<name>\SKILL.md` | You | Open it from Settings → Skills → "Abrir a minha pasta de skills" |

A shared skill with the same name as a shipped one replaces it, and a skill in your folder
replaces both. A folder or `name` starting with `_` is a template: listed, never offered to
the assistant. Skills you switch off are remembered in
`%LocalAppData%\Cegid\Extensions\AITOOL\skills-disabled.json`. Settings → Skills
lists every skill found, where it came from, and lets you switch each one off. `/skills` in
the chat lists them; `/skills recarregar` reads the folders again (a new conversation picks
them up).

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
4. Otherwise `enrich_entity`, then `create_entity` in two steps.
5. `create_opportunity` in two steps.
6. `draft_email` for the company contact, or for the user when an internal summary was asked.
```

Header keys:

- `name`: short, no spaces; it is how the assistant calls the skill. Missing, the folder name is used.
- `description` (required): one sentence; the assistant reads it to decide whether the skill applies.
- `triggers`: words that usually appear in the request, comma-separated.
- `tools`: the tools the skill may use, comma-separated; empty means every enabled tool. The
  list restricts, it never adds: a tool switched off in Settings stays off.
- `version`, `author`: free text, shown in Settings.

The body is free Markdown. Keep the instructions under 12 000 characters (the header does not
count); a longer body is listed with a problem and never used. Write it the way you would brief a new colleague: what to ask first,
which tool answers each step, what to do with the result, where to stop and ask.

## What a skill cannot do

- Skip the two-step confirmation of a save. `create_entity`, `update_entity`,
  `create_sales_document` and `create_opportunity` always preview first and save only after
  the user's explicit yes; the skill's text cannot change that.
- Override the system prompt. The skill's instructions are loaded after it, and the prompt
  tells the model that skills never dispense with its rules.
- Send anything. `draft_email` prepares a draft the user opens in their own mail client.
- Reach systems the addon has no tool for. Calling external APIs (payments, CRMs, ticketing)
  needs a dedicated tool with its own credentials and audit; see [ROADMAP.md](../ROADMAP.md).

## Shipped skills

| Skill | What it does |
|---|---|
| `prospecao-de-leads` | Web search for target companies → existing customer check → customer record (two steps) → CRM sales opportunity (two steps) → e-mail draft for review |
| `_modelo` | The template to copy; it stays disabled until renamed |

## Sharing skills

A skill is a folder: zip it, mail it, or publish it in a Git repository. A public collection
reviewed by pull request is planned as `BolaLabs/AITOOL-skills`; until it exists, the
`_modelo` folder and this page are the spec. Never put credentials or customer data in a
`SKILL.md`: it is read into every request that uses the skill.
