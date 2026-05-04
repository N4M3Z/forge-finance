---
title: "TAX-0003"
description: "Audit-safe filing as a default tax-advisory posture for small businesses"
type: adr
category: process
tags:
    - tax
    - dppo
    - dpfo
    - czech
    - strategy
    - small-business
status: accepted
created: 2026-05-03
updated: 2026-05-03
author: N4M3Z
project: forge-finance
responsible:
    - N4M3Z
accountable:
    - N4M3Z
consulted: []
informed: []
related:
    - "docs/decisions/TAX-0001 Knowledge-First Approach for Czech Personal Income Tax.md"
    - "docs/decisions/TAX-0002 Statutory Law in Rules Filing Procedures in Skills.md"
upstream:
    - rules/AuditSignalDisclosure.md
    - rules/en-CZ/CzechTaxAuditMarkers.md
    - rules/en-CZ/CorporateTax.md
    - rules/en-CZ/ReceivableWriteoffs.md
---

# Audit-Safe Filing as a Default

## Context and Problem Statement

Tax law in most jurisdictions offers small-business taxpayers multiple legitimate ways to reduce a current-year liability: applying prior-year loss carryforwards against current income, writing off uncollectable receivables, classifying expenses to maximize deductibility, taking allowances and credits. None of these moves are aggressive in themselves — each sits within the four corners of the statute. But many of them rest on interpretive choices the taxpayer makes about how the statute applies to their facts, and those choices can be questioned on review.

For a small business — annual revenue measured in hundreds of thousands of CZK rather than millions, no internal tax department, light or no engagement with a paid advisor — the cost of defending an interpretive position is concentrated and high: preparation time the owner cannot bill, advisor fees they did not budget for, possible recharacterization plus penalties, multi-week disruption. The tax savings on a small return are diffuse and small in absolute terms. The trade-off is structurally asymmetric.

The question this decision addresses: when advising small-business taxpayers, what posture should the default be — maximum legal tax minimization (take every position the statute permits), or an audit-safe posture that takes only positions which would clearly survive a substantive review and accepts a slightly higher current-year tax in exchange for a structurally cleaner compliance profile?

The trigger was a Czech `DPPO` filing session for a `s.r.o.` with marginal annual revenue, where four iterations on receivable-writeoff strategy occurred because the interpretive cost of each option was not surfaced upfront. The audit-safe practitioner standard among Czech tax advisors for filings of this size is to skip `ř.230` deductions of old `daňová ztráta` and avoid interpretive entries on `ř.40`, even at the cost of higher current-year tax, specifically to keep the `prekluzivní lhůta` short and the return composed of unambiguous positions.

## Decision Drivers

- Small-business taxpayers cannot easily absorb the cost of defending interpretive positions; cost-per-event is far higher than for medium or large enterprises with internal tax functions
- The Czech `§38r` `prekluzivní lhůta` mechanic specifically penalizes use of old `daňová ztráta` by extending the assessment window for the loss-origin period — an asymmetry users typically miss
- Practitioner consensus exists for the audit-safe posture in this segment (Czech tax-advisor standard for `nevýznamné ztráty`)
- AI advisory that recommends adjustments without disclosing the interpretive cost forces re-work cycles when the user later discovers the trade-off
- Larger taxpayers (with internal tax functions, professional advisors, materially larger savings on the table) follow the opposite default, and that is correct for their context — the rule must distinguish

## Considered Options

- **Option A — Maximum legal tax minimization for everyone.** Apply every available deduction, allowance, loss carryforward, and reclassification the statute permits. Treat the cost of defending positions as a separate concern the user can opt out of.
- **Option B — Audit-safe by default for small businesses, opt-in for aggressive treatment.** Take only positions that are clearly defensible without elaborate argumentation. Skip interpretive moves (large non-deductible adjustments, old loss carryforwards applied against current income, "tax exceeds book profit" patterns) unless the user specifically opts into aggressive treatment with full disclosure of the trade-off. Default applies to small businesses (rough threshold: annual revenue under 1 mil CZK for `s.r.o.` and routine returns for individuals).
- **Option C — Always present both, no default.** Show the comparison for every adjustment without a recommended path, leaving every choice fully open.

## Decision Outcome

**Option B** — audit-safe filing as the default for small-business filings, with explicit disclosure of the alternative on every adjustment whose treatment rests on an interpretive choice.

The decision rests on three operational mechanisms:

1. A universal rule (AuditSignalDisclosure) requires every recommendation that creates an interpretive entry on the return to be presented in a two-column comparison alongside the audit-safe alternative. The rule applies across jurisdictions, not only Czech.
2. A jurisdiction-specific marker catalogue (initially CzechTaxAuditMarkers for `DPPO` and `DPFO`) lists the entries whose treatment varies and provides an audit-safe alternative for each. New jurisdictions add their own catalogue when in scope.
3. The audit-safe default activates based on observable filing parameters (revenue band, accounting-unit category, prior loss-streak pattern). Users who want maximum tax minimization opt in explicitly after seeing the disclosure.

Larger filings — where tax savings exceed the expected cost of defending positions, or where the taxpayer has dedicated tax-function capacity — fall outside this default and are advised to engage a licensed `daňový poradce` who can weigh the trade-off with full client knowledge.

## Consequences

- Small-business users will pay marginally more tax in years where deductions or loss carryforwards would otherwise apply (typically a few thousand CZK per year)
- Small-business users will not later face follow-up questions about positions added without their conscious choice
- Old `daňová ztráta` may expire unused (e.g. a 2020 loss expires after 2025 if not applied) — accepted cost of the strategy
- Outputs become uniform year over year, which itself simplifies multi-year continuity
- Cross-references between the universal disclosure rule, the jurisdiction-specific marker catalogue, and the workflow skills create a coherent strategy story when the user reads any one of them
- Engagements with larger taxpayers (revenue meaningfully above the small-business threshold, or where tax savings clearly exceed the cost of defending the position) require explicit opt-out of this default and a routing recommendation to a licensed advisor
- Taxpayers with active disputes or known prior review history may benefit even more from the audit-safe posture — flag those cases explicitly during intake

## More Information

The catalyst for this decision was a `s.r.o.` `DPPO` filing in May 2026 where four iterations on writeoff strategy occurred because the interpretive cost of each option was not surfaced upfront. Audit-safe practitioner standard among Czech tax advisors for marginal-revenue filings — skip `ř.230` deductions of `nevýznamné ztráty` to protect the `prekluzivní lhůta` — confirmed the posture this ADR encodes.

For implementation details and the operational rules:

- AuditSignalDisclosure rule — universal disclosure protocol
- CzechTaxAuditMarkers rule — Czech-specific marker catalogue
- CorporateTax rule — `§38a` zálohy threshold plus `§38r` ztráta strategy
- ReceivableWriteoffs rule — writeoff blockers and escape paths
- CorporateTaxReturn skill — workflow steps that operationalize the strategy
