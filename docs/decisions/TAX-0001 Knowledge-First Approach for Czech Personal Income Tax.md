---
title: "TAX-0001"
description: "Knowledge-first approach for Czech personal income tax (DPFO) coverage"
type: adr
category: architecture
tags:
    - tax
    - dpfo
    - czech
status: accepted
created: 2026-03-25
updated: 2026-03-25
author: N4M3Z
project: forge-finance
responsible:
    - N4M3Z
accountable:
    - N4M3Z
consulted: []
informed: []
upstream:
    - rules/en-CZ/PersonalTaxIncome.md
    - rules/en-CZ/PersonalTaxDeductions.md
    - rules/en-CZ/PersonalTaxDeadlines.md
    - rules/en-CZ/LongTermInvestment.md
    - rules/en-CZ/MortgageInterest.md
    - rules/en-CZ/SecuritiesTax.md
---

# Knowledge-First Approach for Czech Personal Income Tax

## Context and Problem Statement

Czech personal income tax (`DPFO` / `daňové přiznání fyzických osob`) requires annual filing with income from multiple sources, eligible deductions, and supporting documentation. The forge-finance module supports the full lifecycle: gathering documents, understanding tax law, validating data, and preparing the return. Tax projects use the vault's project note system, named by tax year (not filing year). The question is whether to start with workflow skills or domain knowledge rules.

## Decision Drivers

- Rules are reusable across tax years and filing cycles
- Tax law changes infrequently compared to implementation details
- Skills need domain knowledge to validate correctly
- Bilingual term mapping serves both filing and Q&A use cases

## Considered Options

1. Skills first, rules later (build workflows, add law knowledge as needed)
2. Rules first, skills on top (build comprehensive law rules, then layer workflow skills)
3. Parallel development (rules and skills together)

## Decision Outcome

Chosen option: **Option 2 (rules first, skills on top)**. Build Czech tax law rules comprehensively first, then layer workflow skills on top. The upfront investment in knowledge makes every skill and agent more capable from day one.

No Rust code. No hooks. Skills-only module.

## Consequences

- [+] Rules are reusable across tax years and entity types
- [+] Bilingual term mapping makes the module useful for Czech tax law Q&A beyond filing
- [-] More upfront work before the first filing run, but rules inform every step

## More Information

### Architecture

```text
forge-finance/
    rules/en-CZ/
        PersonalTaxIncome.md           # income categories (§6-§10, zákon 586/1992 Sb.)
        PersonalTaxDeductions.md       # nezdanitelné části základu daně (§15)
        PersonalTaxDeadlines.md        # filing deadlines, correction procedures, penalties
        LongTermInvestment.md          # DIP + penzijní spoření specifics
        MortgageInterest.md            # hypoteční úroky deduction
        SecuritiesTax.md               # stock sales, dividends, time-test exemption
    rules/
        CurrencyFormatting.md
        ForeignTerms.md
        SourcePriority.md
        Penalties.md
        FilingWorkflow.md
    skills/
        TaxReturn/SKILL.md             # DPFO preparation workflow
        TaxAnalysis/SKILL.md           # PDF/CSV document extraction
        TaxFiling/SKILL.md             # DPFDP7 XML generation
        Fakturoid/SKILL.md             # invoice API integration
        Revolut/SKILL.md               # brokerage export parsing
        SecuritiesTax/SKILL.md         # FIFO lot matching
        SocialFiling/SKILL.md          # ČSSZ přehled OSVČ
        HealthFiling/SKILL.md          # health insurance přehled
    agents/
        TaxAdvisor.md                  # Czech tax law Q&A agent
```

### Rules — Bilingual, Law-Referenced

Each rule opens with a Czech-English term mapping and `zákon` section reference. Body captures current law ([zákon 586/1992 Sb.][1] as amended). Behavioral guidance that tells the AI how to reason about Czech tax concepts.

| Rule                    | Covers                                                                                      |
| ----------------------- | ------------------------------------------------------------------------------------------- |
| `PersonalTaxIncome`     | §6 employment, §7 self-employment, §8 capital, §9 rental, §10 other. Foreign income, DTTs. |
| `PersonalTaxDeductions` | §15 deductions: DIP, pension, mortgage, life insurance, donations. Limits and proof docs.   |
| `PersonalTaxDeadlines`  | Filing deadlines. `Opravné` vs `dodatečné přiznání`. Penalties.                             |
| `LongTermInvestment`    | DIP + `penzijní spoření`: contribution limits, employer treatment, 120-month minimum.       |
| `MortgageInterest`      | `Hypoteční úroky`: contract requirements, annual limit, `bytové potřeby` qualification.     |
| `SecuritiesTax`         | Stock/ETF sales §10, dividends §8, time-test exemption, FX conversion.                     |

### TaxReturn Skill

Interactive `DPFO` preparation workflow: inventory source documents, extract data (via TaxAnalysis), validate income categories, compute deductions, cross-check amounts, flag issues, generate filing values, pre-submission checklist.

### TaxAnalysis Skill

Reads financial PDFs and CSVs. Extracts amounts, dates, payer/payee, document type. Classifies by income category or deduction type. Handles Czech-language documents.

### TaxAdvisor Agent

Czech tax law specialist. References `zákon` sections. Bilingual (Czech terms, English explanations). Conservative approach — recommends `daňový poradce` when uncertain. Used by TaxReturn for validation and available standalone for Q&A.

### Project Structure

Vault project: `Projects/Taxes YYYY/Taxes YYYY.md` following ProjectConventions. Source documents in `Assets/`. Inbox staging for incoming documents.

[1]: https://www.zakonyprolidi.cz/cs/1992-586
