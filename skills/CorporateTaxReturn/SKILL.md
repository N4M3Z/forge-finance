---
name: CorporateTaxReturn
version: 0.1.0
description: "Czech corporate income tax (`DPPO`) annual close workflow for `s.r.o.` — verify rejstřík + ESM, prepare účetní závěrka, generate DPPDP9 XML, attach závěrka, request sbírka-listin forwarding. USE WHEN DPPO, dan z prijmu pravnickych osob, corporate tax, sro tax, danove priznani sro, accounting close, ucetni zaverka, no economic activity filing, dormant filing."
---

# CorporateTaxReturn

Annual close workflow for a Czech `s.r.o.` filing `DPPO`. Coordinates rejstřík/ESM verification, účetní závěrka preparation, DPPDP9 XML generation, and sbírka listin filing — all driven as one MOJE daně submission via the §72(2) daňového řádu příloha pattern.

## Background

Filing `DPPO` is mandatory for every `s.r.o.` regardless of activity ([§38m DPPO][zdp38m]). The §38mc opt-out is reserved for veřejně prospěšní poplatníci a SVJ — a standard `s.r.o.` cannot use it.

`Účetní závěrka` is a mandatory příloha to `DPPO` ([§72(2) daňového řádu][dr72], [pokyny DPPDP9][pok]). Ticking **Žádost o předání účetní závěrky do sbírky listin** inside the form discharges the §66 zákona 304/2013 publication duty in the same submission ([Finanční správa][fs]). Use this path — it eliminates a separate justice.cz upload.

See [CorporateTax][../../rules/en-CZ/CorporateTax.md] rule for thresholds, deadlines, and penalties.

## Inputs

1. **Tax year** — the zdaňovací období (e.g., 2025).
2. **Project folder** — `Projects/Taxes <Company> <Year>/Assets/` with prior-year DPPDP9 XML, závěrka PDFs, rejstřík výpis.
3. **DIČ + spisová značka** — for justice.cz lookups.
4. **Datová schránka access** — verify before submission.

## Workflow

### 1. Verify external state

Before producing any files:

| Check | Source | Why |
| ----- | ------ | --- |
| Rejstřík current state | [or.justice.cz][orj] subjektId lookup | Confirm shareholders, sídlo, jednatelé reflect reality |
| Sbírka listin coverage | [or.justice.cz][orj] vypis-sl-firma | Spot any missing prior-year závěrka — flag for backfill |
| `ESM` (evidence skutečných majitelů) | [esm.justice.cz][esm] (authenticated) | Verify [§9 zákona 37/2021][zesm] reflects current owners; deadline 15 days from rejstřík change |
| `DPH` plátcovství status | [ARES][ares] / MOJE daně | If plátce, separate nulové `DPH` + KH may also be due |
| **All bank statements** for the tax year + last few months of prior year | bank portal / Mojebanka / spořitelna | **Required upfront, not as you go.** Includes accounts opened or closed mid-year. Without complete bank picture, opening balance reconciliation will cycle through guesses. Specifically ask: "any accounts opened or closed during YEAR or YEAR-1?" |

Gaps in SL numbering (e.g., SL2 → SL4) usually mean a missed prior-year filing. Use [RegisterFiling][../RegisterFiling/SKILL.md] to backfill before this year's submission, so the §66 clock is current and §105a risk does not compound.

### 2. Prepare účetní závěrka

For a mikro účetní jednotka in zjednodušený rozsah ([§1b zákona 563/1991][zou1b]):

| Document | Required for mikro |
| -------- | ------------------ |
| `Rozvaha` (balance sheet) | yes |
| `Výkaz zisku a ztráty` | yes for závěrka; mikro may omit from publication |
| `Příloha v účetní závěrce` | yes |
| `Výroční zpráva` | only if audit obligation triggered ([§21a][zou21a]) |
| Auditor | only if 2 of 3 thresholds met (assets >40M, obrat >80M, ≥50 zaměstnanců) for two consecutive years ([§20][zou20]) |

Opening balances must equal the closing balances of the prior year — this is the most common preparation error.

For dormant or near-dormant operations, reuse the structure of the prior year's accountant-prepared závěrka as a template — values differ, structure does not.

### 3. Convene valná hromada

Schválení účetní závěrky valnou hromadou starts the §66 30-day clock for sbírka listin ([§66 zákona 304/2013][r304-66]). Produce the `zápis z valné hromady` schvalující závěrku and store in `Assets/`.

### 4. Generate DPPDP9 XML

Use the prior-year submission as a starting template. Per-year edits:

- `VetaD/@zdobd_od`, `@zdobd_do`, `@d_uv`, `@d_hospvysl` — period dates
- `VetaD/@dap_typ` = `B` (řádné), or `O`/`D`/`E` for corrections
- `VetaD/@uc_zav` = `A` (závěrka attached)
- `VetaD/@audit` = `N` for sub-threshold company
- `VetaD/@kat_uj` = `M` (mikro) | `S` (malá) | `T` (střední) | `V` (velká)
- `VetaP/@dic`, `@psc`, `@naz_obce`, `@ulice`, `@c_pop` from current rejstřík sídlo
- `VetaP/@opr_jmeno`, `@opr_prijmeni`, `@opr_postaveni` for jednatel
- All numeric `kc_*` rows reflect the current year's books

Validate before presenting:

```sh
xmllint --noout file.xml
xmllint --noout --schema docs/en-CZ/dppdp9_epo2.xsd file.xml
```

Cache the current XSD from [adisspr.mfcr.cz DPPDP9][dppdp9] before generating; verify the schema version on the day of filing — MF publishes new generations periodically.

DPPDP9 attribute mapping reference for `VetaO`, `VetaUA`, `VetaUB`, `VetaUD`, `VetaUZ` lives in companion file [`dppdp9-attributes.md`](./dppdp9-attributes.md). **Critical gotcha**: `kc_ii270_280` is the **sazba daně 21**, not the daňový základ — base goes to `kc_ii260_270`.

### 4a. Audit-safe strategy (default for small `s.r.o.` filings)

Per the audit-safe practitioner standard among Czech tax advisors for small-business `DPPO`: file using only positions that would clearly survive substantive review. See TAX-0003 for the underlying decision and the AuditSignalDisclosure + CzechTaxAuditMarkers rules for the disclosure protocol and marker catalogue.

- **Skip the deduction of old `daňová ztráta` minulých let** (`ř.230 = 0`) even if available. Per `§38r odst. 2` ZDP, applying an old loss extends the `prekluzivní lhůta` for the loss-origin period — adverse asymmetry on small returns.
- **Avoid `nedaňový` receivable writeoffs** (548/315) when current revenue produces book profit. The resulting "tax > book profit" pattern invites questions about the writeoff. Leave the receivable on books and revisit when an `§24(2)(y)` trigger fires.
- **Avoid large single-line `ř.40` non-deductible items** unless they are mandatory.
- **Year-over-year consistency**: keep the filing structure identical across years. Predictable filings simplify multi-year continuity.

When a tax loss arises in the current year: file an `oznámení o vzdání se práva uplatnit daňovou ztrátu` per [§38r odst. 4 ZDP][zdp38r] together with the return. The `prekluzivní lhůta` for the loss-origin year then stays at the standard 3 years rather than the extended 5 + 3 years.

### 4b. Inheriting from prior accountant (reconciliation pattern)

When taking over from a prior accountant whose 2024 closing differs from actual reality at 1.1.2025:

1. **DO NOT restate prior year** column on rozvaha — keep it exactly as filed by predecessor. No "upravené" framing.
2. **Open current year with actual position** — bank balance from statements, receivables/payables from documents.
3. **Reconcile the difference in příloha v ÚZ** (čl. 3.x). Most common difference sources:
    - Bank account opened mid-year, deposit not in prior závěrka
    - Bank fees not booked in prior year
    - Loan from společník (additional cash injection) not recognized
4. **Adjust opening equity + opening loan** by the missing 2024 movements. No 426 entry needed in 2025 if differences are absorbed in opening balances at 1.1.YYYY.

This avoids reopening filed prior year while making 2025 tie to actual cash position.

### 5. Attach závěrka + sbírka listin žádost

Two attachment paths — choose one:

**Path A — embed PDF as base64 in `<Prilohy>` (preferred)**: produces a self-contained XML that the EPO portal accepts directly with no separate file upload. See [`epo-attachments.md`](./epo-attachments.md) for the wrapper structure, the list of which documents need PDF embedding (only `Příloha v účetní závěrce` does — rozvaha and VZZ are rendered automatically from `VetaUA`/`VetaUB`/`VetaUD` numerical data), and the EPO upload URL.

**Path B — bare XML, attach PDF in EPO UI**: upload XML at [adisspr.mfcr.cz/pmd/epo/formulare?nacteni=1](https://adisspr.mfcr.cz/pmd/epo/formulare?nacteni=1), then attach závěrka PDF as `Příloha k položce 11 I. oddílu` in the portal. Two-step but simpler if the wrapper isn't generated.

Both paths require:

- **Tick "Žádost o předání účetní závěrky do sbírky listin"** (`VetaUZ/@pr11_rozv="A"` etc.) — the FÚ forwards to the rejstříkový soud, discharging the §66 zákona 304/2013 publication duty.

This is the same flow CYBERTEC and similar small `s.r.o.` use historically — verify it was used in the prior-year filing before relying on it (check that prior závěrky appear on the company's vypis-sl-firma).

### 6. Pre-submission checklist

- Závěrka schválená valnou hromadou (§66 clock started)
- Závěrka attached to `DPPO` as PDF příloha
- "Žádost o předání do sbírky listin" ticked
- DPPDP9 XML validates against current XSD
- Rejstřík and `ESM` reflect current state
- `DPH` nulové podání submitted separately if plátce
- Datová schránka access verified

## Workflow Routing

| Situation | Path |
| --------- | ---- |
| Standard řádné DPPO with attached závěrka | full workflow above |
| Late filing after deadline | switch `dap_typ` to `D`, set `d_zjist`, compute §250 pokuta + §252 úrok |
| Correction before deadline | switch `dap_typ` to `O`, set `d_zjist` |
| Backfill of prior-year závěrka only (no DPPO needed) | hand off to [RegisterFiling][../RegisterFiling/SKILL.md] Path B |

## Constraints

- Never auto-submit to MOJE daně — present XML and příloha set for user confirmation
- Validate XML against the cached XSD before presenting
- Cite every numeric threshold or deadline to its statutory source per SourcePriority
- Use ForeignTerms formatting for Czech legal terms (backticks)
- For non-trivial situations (audit threshold proximity, foreign income, M&A, restructuring), recommend `daňový poradce`
- Apply the AuditSignalDisclosure rule and the CzechTaxAuditMarkers catalogue when any adjustment that rests on an interpretive choice (large `ř.40` non-deductible item, `ř.230` deduction of old `daňová ztráta`, "tax > book profit" pattern) is being considered. Default to the audit-safe alternative for small `s.r.o.` filings — see TAX-0003.
- For shareholder loan documentation surfacing during the close, hand off to the ShareholderLoanContract skill; never backdate contracts.
- For DPPO-specific advisory questions arising mid-workflow, route to the CorporateTaxAdvisor agent.

[zdp38m]: https://www.zakonyprolidi.cz/cs/1992-586#p38m
[dr72]: https://www.zakonyprolidi.cz/cs/2009-280#p72
[zou1b]: https://www.zakonyprolidi.cz/cs/1991-563#p1b
[zou20]: https://www.zakonyprolidi.cz/cs/1991-563#p20
[zou21a]: https://www.zakonyprolidi.cz/cs/1991-563#p21a
[r304-66]: https://www.zakonyprolidi.cz/cs/2013-304#p66
[zesm]: https://www.zakonyprolidi.cz/cs/2021-37#p9
[fs]: https://financnisprava.gov.cz/cs/dane/dane/dan-z-prijmu/dotazy-a-odpovedi/dan-z-prijmu-pravnickych-osob/vybrane-dotazy-k-predavani-ucetni
[pok]: https://adisspr.mfcr.cz/dpr/adis/idpr_pub/dpp/dp9/doc/pokyny_dap_2024.pdf
[dppdp9]: https://adisspr.mfcr.cz/dpr/adis/idpr_pub/epo2_info/popis_struktury_detail.faces?zkratka=DPPDP9
[orj]: https://or.justice.cz
[esm]: https://esm.justice.cz/ias/issm/rejstrik
[ares]: https://ares.gov.cz
[zdp38r]: https://www.zakonyprolidi.cz/cs/1992-586#p38r
