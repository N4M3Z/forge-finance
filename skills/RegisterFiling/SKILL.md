---
name: RegisterFiling
version: 0.1.0
description: "File documents to the Czech veřejný rejstřík sbírka listin — annual účetní závěrka, notářské zápisy on ownership/sídlo changes, founder docs. Two paths: forwarded by FÚ as DPPO příloha or direct upload via datová schránka. USE WHEN sbírka listin, sbirka listin, sbírka, rejstřík filing, závěrka publication, justice.cz upload, accounting publication, public records filing, založit do sbirky listin."
---

# RegisterFiling

File documents to the **sbírka listin** at the Czech veřejný rejstřík (Ministry of Justice). Two paths exist — choose by document type and deadline.

## Background

[§66 zákona 304/2013][r304-66] obliges every právnická osoba registered in a veřejný rejstřík to deposit specified documents — including the schválená účetní závěrka — to the sbírka listin. Deadline: bez zbytečného odkladu po vzniku skutečnosti, outermost 12 měsíců od rozvahového dne.

Penalties under [§104 zákona 304/2013][r304-104] reach 100 000 CZK per missed filing. **Two consecutive missed závěrky filings** open [§105a][r304-105a] dissolution-without-liquidation — a corporate death penalty, not a fine. Treat backlog with urgency.

See [CorporateTax][../../rules/en-CZ/CorporateTax.md] rule for the full penalty table.

## What goes into sbírka listin (most common)

| Document | Source | Frequency |
| -------- | ------ | --------- |
| `Účetní závěrka` (rozvaha, VZZ, příloha) | účetní | yearly |
| `Výroční zpráva` | větší a střední účetní jednotky | yearly if audit-required |
| `Notářský zápis` (změna společníků, sídla, kapitálu) | notář | per event |
| `Smlouva o převodu obchodního podílu` | notář | per event |
| `Zakladatelské dokumenty` | notář | once at vznik |
| `Návrh na zápis změny + přílohy` | jednatel / notář | per event |

Mikro a malé účetní jednotky may omit `výkaz zisku a ztráty` from publication ([§21a zákona 563/1991][zou21a]).

## Workflow

### Path A — FÚ forwarding (preferred for závěrka)

When filing `DPPO` via MOJE daně, attach závěrka as `Příloha k položce 11 I. oddílu` and **tick "Žádost o předání účetní závěrky do sbírky listin"**. The FÚ forwards to the rejstříkový soud bez zbytečného odkladu — single submission discharges both [§72(2) daňového řádu][dr72] and §66 zákona 304/2013 ([Finanční správa][fs], [Portál gov.cz S14028][gov]).

Driven by [CorporateTaxReturn][../CorporateTaxReturn/SKILL.md] for the end-to-end DPPO flow.

### Path B — Direct upload via datová schránka

When the document is not a tax-period závěrka (notářský zápis, smlouva o převodu podílu), or when filing outside the `DPPO` cycle (backfill, mid-year změna):

1. **Identify the rejstříkový soud.** Spisová značka prefix maps to the soud:

    | Prefix | Soud |
    | ------ | ---- |
    | `C` followed by Praha number | Městský soud v Praze |
    | `C` jiné | příslušný krajský soud |
    | `B` | akciové společnosti — same soud, different oddíl |

2. **Convert to PDF/A-2u** if required by the soud's intake. Both PDF and PDF/A are widely accepted; verify against the soud's current instructions.
3. **Submit via datová schránka** to the soud's `DS` (Městský soud v Praze: `snkabbm`) or via the [Inteligentní formuláře][if] interface at justice.cz. Plain email is not accepted.
4. **Confirm receipt** by checking [or.justice.cz vypis-sl-firma][orj] a few business days later — the document should appear with a new SL ID.

### Verifying current state

Before assuming a document is filed:

```
https://or.justice.cz/ias/ui/vypis-sl-firma?subjektId=<id>
```

Returns a chronological list of SL IDs. Gaps in the SL numbering (e.g., SL2 → SL4) usually indicate either filtered/withdrawn entries or a missed filing — investigate.

For owner / director / sídlo state:

```
https://or.justice.cz/ias/ui/rejstrik-firma.vysledky?subjektId=<id>&typ=UPLNY
```

Returns full history including vymazané entries — useful for confirming an ownership change is reflected.

### Backfilling missed prior years

If a prior-year závěrka was prepared but never reached sbírka listin:

1. Locate the original závěrka (accountant's archive, prior-year `Assets/` folder, or BDO archive).
2. Verify it was schválená valnou hromadou — required for §66 clock alignment. If never schválená, schválit nyní (zápis z valné hromady).
3. File via Path B as a standalone deposit, citing the period in the document name (e.g., `Účetní závěrka za rok 2020`).
4. Document the backfill in the project notes — penalty exposure under §104 remains assessable, but voluntary deposit reduces audit risk and clears the §105a counter.

## Workflow Routing

| Situation | Path |
| --------- | ---- |
| Závěrka attached to current-year `DPPO` | A (FÚ forwards) |
| Notářský zápis (ownership, sídlo, kapitál) | B (direct via DS) |
| Backfill of prior-year závěrka | B (direct via DS) |
| Founder documents at vznik | done by notář through přímý zápis |
| Late current-year závěrka after `DPPO` already filed without žádost | B (direct via DS) |

## Red Flags

| Signal | What it means |
| ------ | ------------- |
| Missing SL ID in vypis (e.g., SL3 absent between SL2 and SL4) | Likely a filed-and-withdrawn document, OR a missed filing — investigate before relying on the "looks fine" assumption |
| Prior závěrka never schválená valnou hromadou | §66 clock never started — `dodatečné schválení + dodatečné založení` needed |
| Two consecutive years with no závěrka in sbírka listin | §105a dissolution risk — escalate, file immediately |
| Notářský zápis without corresponding `ESM` update | 15-day clock under [zákon 37/2021][zesm] may be breached — check ESM |

## Constraints

- Verify schválení valnou hromadou before depositing závěrka — unschválená závěrka cannot start the §66 clock
- Never assume a document is filed without checking vypis-sl-firma — gaps are common
- For Path A, verify in vypis-sl-firma a few weeks after `DPPO` submission that the SL entry appeared; the FÚ usually forwards within days but is not instantaneous
- For Path B, datová schránka of the soud is the canonical channel — keep doručenka

[r304-66]: https://www.zakonyprolidi.cz/cs/2013-304#p66
[r304-104]: https://www.zakonyprolidi.cz/cs/2013-304#p104
[r304-105a]: https://www.zakonyprolidi.cz/cs/2013-304#p105a
[zou21a]: https://www.zakonyprolidi.cz/cs/1991-563#p21a
[dr72]: https://www.zakonyprolidi.cz/cs/2009-280#p72
[zesm]: https://www.zakonyprolidi.cz/cs/2021-37
[fs]: https://financnisprava.gov.cz/cs/dane/dane/dan-z-prijmu/dotazy-a-odpovedi/dan-z-prijmu-pravnickych-osob/vybrane-dotazy-k-predavani-ucetni
[gov]: https://portal.gov.cz/sluzby-vs/zverejneni-ucetni-zaverky-prostrednictvim-sveho-spravce-dane-z-prijmu-S14028
[orj]: https://or.justice.cz
[if]: https://or.justice.cz/ias/ui/podani
