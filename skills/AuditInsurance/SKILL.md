---
name: AuditInsurance
version: 0.1.0
description: "Audit a Czech insurance offer against the referenced VPP and any incumbent policy. Extract sublimits, cross-reference výluky, compute §2807 renewal timing, produce verified comparison with clause citations. USE WHEN compare pojištění, audit nabídka, pojišťovna návrh, evaluate insurance offer."
---

# AuditInsurance

Audit a Czech insurance offer end-to-end: pull the governing VPP, extract sublimits, find hidden exclusions the offer table omits, compute §2807 renewal timing against any incumbent, and output a verified comparison with article citations. Dispatch the broker message via GhostWrite in the user's relationship register.

## Inputs

1. **New nabídka / offer PDF** — the document to audit.
2. **Incumbent policy** — návrh + pojistka if the user is switching, else skip cross-reference steps.
3. **Referenced VPP document(s)** — cited in the offer's "Čím se pojištění řídí" section (e.g. VPP-BH-05/2024, M-100/23, M-500/23). Fetch from the insurer's site:
    - Generali: `generaliceska.cz/documents/20183/...`
    - Kooperativa: `koop.cz/file/edee/dokumenty/pojisteni-majetku/...`
    - Allianz: `allianz.cz/dokumenty/...`

## Workflow

### 1. Extract offer sublimits

Read the offer's section 6 (Pojištění majetku) or equivalent. Normalize every row into a table:

| Položka | Pojistná částka | Limit plnění | Sublimit | Spoluúčast | Varianta |

Flag items marked "nesjednáno" or "–" as untaken připojištění — they are actionable if the user wants them.

### 2. Scan VPP for hidden exclusions

Section 6 tables hide structural exclusions. Read čl. E (výluky z domácnosti), čl. B (peril definitions), čl. D (spoluúčast), čl. C (benefits and compliance provisions) of the VPP directly. Look for:

- **Article-level výluky** that contradict or shadow offer sublimits (e.g. `čl. E02 odst. 3 — pojištění se nevztahuje na věci zvláštní hodnoty uložené v nebytových prostorech`).
- **Variant-specific exclusions** (ATYP vs Exclusive vs All risk often differ in what's outright excluded).
- **Sublimit-of-sublimit stacking** — a 60 K sublimit inside a 3 M limit behaves very differently from a 60 K first-risk amount.
- **Additive vs within pojistná částka** — vedlejší stavby "nad rámec" stacks, "sublimit" doesn't.

### 3. Cross-reference incumbent

For each line item, classify:

| Verdict | Meaning |
| --- | --- |
| BETTER | New offer strictly exceeds incumbent |
| EQUAL | Same coverage and deductible |
| GAP | New offer is lower but still covered |
| HIDDEN EXCLUSION | New offer has a VPP carve-out the table doesn't show |
| MOOT | Neither has this coverage |
| CORRECTED | Claim that sounded like a gap but actually isn't after VPP read |

### 4. §2807 timing audit (only if switching)

If the user has an incumbent:

1. Find the anniversary date (počátek pojištění + 12 měsíců × N).
2. Cutoff for clean výpověď = anniversary − 6 týdnů (zákon 89/2012 §2807).
3. If today ≤ cutoff: clean switch possible.
4. If today > cutoff: flag the §2804 lapse-by-non-payment path, estimate the collectable premium and administrative penalties, warn about ČAP pojistný registr flag, and propose settling the upomínka in full to convert "unpaid" to "paid late".

Reference the memory insight [[Czech insurance renewal window is 6 weeks before anniversary]] if it exists in the user's vault.

### 5. Produce verified comparison

Output a table with at minimum these columns:

| # | Položka | Incumbent | Nová nabídka | Verdikt | Zdroj (čl., page) |

Cite every factual number to a specific article or page/section. Use markdown reference-style links for URLs per CitationHygiene. Never quote a number without a source.

### 6. Prioritized dodatek / připojištění asks

For each identified GAP or HIDDEN EXCLUSION, propose a specific broker ask:

- **Připojištění Aktiv (all risk)** — closes věci zvláštní hodnoty gaps
- **Připojištění Přenosná elektronika ve Světě** — laptop/camera outside home
- **Dodatek ke sjednání** — raise specific sublimit above default
- **Písemné potvrzení** (no premium impact, paper trail) — clarify scope of a specific článek or stacking structure

Estimate premium impact for each (historical ranges: připojištění typically +300–800 Kč/rok each).

### 7. Broker message

Dispatch via [[GhostWrite]] skill. Ask the user the relationship (friend / colleague / formal vendor) and disclose AI involvement in the first sentence — see GhostWrite's "AI-transparency ghostwriting" and "Relationship overrides platform register" sections. Default register for insurance brokers is formal unless user says otherwise.

## Output

Present in this order: comparison table → net assessment (genuine gaps only) → prioritized broker asks → drafted message. Never write or send; let the user review.

## Constraints

- Always fetch the VPP directly — do not reason from the offer's section 6 alone. The table is a map; the VPP is the territory (per [[VerifyClaims]]).
- Cite every number inline with článek or page reference. No uncited figures.
- Classify each line deterministically (BETTER / EQUAL / GAP / HIDDEN EXCLUSION / MOOT / CORRECTED) — "partial" is a code smell; decompose into multiple rows.
- §2807 math must account for today's date vs anniversary, not just the pojistné období length.
- When a sublimit looks off by more than 5× vs incumbent, treat it as an audit-priority item even if the headline number seems adequate.

## Scope

Czech property and liability insurance (majetek, odpovědnost, stavba, domácnost). Extend cautiously to motor (pojištění vozidla) and life (životní pojištění) — these have different peril structures and different governing articles. For health insurance (zdravotní pojištění), do not use this skill; the domain is regulated separately.
