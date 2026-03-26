---
title: "TAX-0002"
description: "Czech tax law encoded as statutory rules with zákon citations, filing procedures as workflow skills"
type: adr
category: architecture
tags:
    - architecture
    - rules
    - skills
    - czech-tax
status: accepted
created: 2026-03-29
updated: 2026-03-29
author: N4M3Z
project: forge-finance
responsible:
    - N4M3Z
accountable:
    - N4M3Z
consulted:
    - DeveloperCouncil
informed: []
upstream:
    - rules/cz/PersonalTaxIncome.md
    - rules/cz/PersonalTaxDeductions.md
    - rules/cz/PersonalTaxDeadlines.md
    - skills/TaxReturn/SKILL.md
    - skills/TaxFiling/SKILL.md
---

# Statutory Law in Rules, Filing Procedures in Skills

## Context and Problem Statement

Czech tax modules handle two distinct knowledge types: statutory law (`zákon 586/1992 Sb.` sections, rates, limits, deadlines) and procedural workflows (XML generation, API calls, document parsing, portal submission). Mixing both in the same artifact type creates ambiguous change boundaries. A `zákon` amendment should not require editing a filing skill, and a new brokerage integration should not touch tax law rules.

## Decision Drivers

- Tax law rules reference specific `zákon` sections and change on legislative cycles (annual amendments)
- Filing procedures change on implementation cycles (API versions, portal updates, format changes)
- Boundary test: `zákon` amendment -> rule update; portal format change -> skill update
- Rules are consumed by the TaxAdvisor agent for Q&A independent of any filing workflow

## Considered Options

1. Mixed (statutory rates and XML schema knowledge in the same rules)
2. Rules encode statutory law with `zákon` citations, skills handle filing procedures
3. Rules as API reference only, skills contain both law and implementation

## Decision Outcome

Chosen option: **Option 2 (statutory law in rules, filing procedures in skills)**, because it produces the cleanest change boundary aligned with the real-world update cadence. Law changes update rules. Implementation changes update skills.

The TaxAdvisor agent loads rules for standalone Q&A without needing any skill. Skills reference rules for validation but own their technical implementation (DPFDP7 XML schema, Fakturoid OAuth, ČSSZ ePortál format).

## Consequences

- [+] Rules are pure statutory reference with per-number `zákon` citations
- [+] TaxAdvisor agent works for law Q&A without filing skill dependencies
- [+] Skills own their technical implementation (schemas, formats, APIs, validation)
- [-] Skills are larger (contain both workflow logic and technical reference material)
