---
name: SocialFiling
version: 0.2.0
description: "ČSSZ social security filing — generate and correct Přehled OSVČ for social insurance. USE WHEN ČSSZ, social security, přehled OSVČ, social insurance, důchodové pojištění, OSSZ."
---

# SocialFiling

Generate or correct the ČSSZ `Přehled o příjmech a výdajích OSVČ` (social security overview) derived from DPFO data.

## Context

Every self-employed person (`OSVČ`) must file a `Přehled` with their local OSSZ (district social security administration) after filing DPFO. When the DPFO is corrected (`opravné`/`dodatečné`), the `Přehled` must be updated within **8 days** of the correction filing ([zákon 589/1992 Sb.][1]).

## Input

Requires from the DPFO (provided by TaxReturn or TaxFiling):
- §7 tax base (`základ daně z příjmů ze samostatné činnosti`)
- Number of months of self-employment activity
- Whether self-employment is the primary (`hlavní`) or secondary (`vedlejší`) activity
- Whether the taxpayer had concurrent §6 employment (triggers `souběh` — mixed year with `druc="S"`)

## Instructions

### 1. Parse existing filing

If a ČSSZ XML exists (e.g., `CSSZ-2025.xml`), parse it and extract:
- Declared §7 income (`pri` attribute in `pvv` element)
- Months of activity (`mesv` element)
- Advance payments (`zal` element)
- Activity type (`hlavc`/`vedc` elements)

### 2. Compute updated values

From the corrected DPFO §7 base:
- `vyměřovací základ` = 55% of §7 tax base (NOT 50% — health insurance uses 50%, social uses 55%) ([§5b][2])
- Annual social insurance = `vyměřovací základ` × 29.2% ([§7(1a)][3])
- Monthly advance = annual ÷ 12, rounded up to whole CZK
- Minimum `vyměřovací základ` for `hlavní` activity: check against the annual minimum ([§5b(3)][2])

### 3. Diff against prior filing

Present changes:

```markdown
| Field                    | Filed    | Corrected | Delta    |
| ------------------------ | -------- | --------- | -------- |
| §7 tax base              | X CZK    | Y CZK     | +Z CZK  |
| Vyměřovací základ (55%)  | A CZK    | B CZK     | +C CZK  |
| Annual insurance (29.2%) | D CZK    | E CZK     | +F CZK  |
| Monthly advance          | G CZK    | H CZK     | +I CZK  |
```

### 4. Submission

File via [ePortál ČSSZ][4] or deliver to the local OSSZ. Deadline: 8 days after corrected DPFO submission for corrections, or one month after the DPFO filing deadline for regular filings.

## ČSSZ XML Schema

Namespace: `http://schemas.cssz.cz/OSVC2025`. XSD cached at `docs/en-CZ/OSVC25.xsd`. Official docs at [cssz.cz/definice-e-podani-osvc](https://www.cssz.cz/definice-e-podani-osvc).

### Activity Type (`druc`)

| Value | Meaning                                         |
| ----- | ----------------------------------------------- |
| `H`   | Hlavní only (primary self-employment all year)  |
| `V`   | Vedlejší only (secondary all year)              |
| `S`   | Souběh — both hlavní and vedlejší in same year  |

### Per-Month Flags (`hlavc`, `vedc`)

Each contains `m1`-`m12` plus `m13` (full-year shorthand). Values: `A` (active), `N` (inactive), or empty.

`vedc` qualifying reasons: `zam` (employment), `duchod` (pension), `pdite` (childcare), `ppm` (maternity), `pece` (care allowance), `ndite` (dependent child).

### Computation Elements (`pvv`)

| Element  | Description                                               |
| -------- | --------------------------------------------------------- |
| `pri`    | §7 tax base (from DPFO row 37)                            |
| `mesc`   | Total months: `h` (hlavní count), `v` (vedlejší count)   |
| `mesv`   | Months after deducting sick/military leave                 |
| `vvz`    | Vyměřovací základ: `h` / `v` (55% of rdza, or minimum)   |
| `poj`    | Annual insurance = uvz × 29.2%                            |
| `zal`    | Advances paid during the year                             |
| `ned`    | Amount due = poj - zal                                    |

### Correction Elements

Set `typ="O"` on `prehledosvc`. Add `opr` element with `datopr` (correction date) and `duvod` (reason text).

### Submission

Upload to [ePortál ČSSZ](https://eportal.cssz.cz/web/portal/-/tiskopisy/osvc-2025).

## Submission via ePortál ČSSZ

The interactive `Přehled OSVČ` form **does not accept XML import** for individuals
— XML import is reserved for batch submission via PVS (accounting firms). For
OSVČ, two paths:

1. **Fill the interactive form**, save WIP XML to disk ("Uložit pro pozdější
   dokončení") to refine, then submit "Datovou schránkou" from inside the
   form (requires ISDS auth).
2. **Pre-fill XML** from this skill's output, attach it to a manual datová
   zpráva, and send to the territorial ÚSSZ DS.

### Form access

The durable entry point is the ePortál ČSSZ home page: <https://eportal.cssz.cz>.
The per-year form has a year-specific URL with a `formID=ZPZS66_<YYYY>.fo`
pattern (for tax year 2025: `https://eportal.cssz.cz/web/portal/fasBridge?formID=ZPZS66_2025.fo`).
The form ID changes each year — derive it, do not cache.

### Datová schránka routing (post-2024 reorganization)

ČSSZ merged district OSSZ into territorial ÚSSZ in 2024. Old per-okres DS IDs
**no longer route**. Search "Územní správa sociálního zabezpečení" + region in
DS rather than relying on cached IDs.

### Common form pre-fill quirks

- **`<zal np="908">` even for non-NP participants.** The form pre-fills the
  minimum monthly NP záloha for the year even if the user never enrolled in
  voluntary nemocenské pojištění. If the user is **not** an NP participant,
  set `np="0"` before saving — leaving the value risks ČSSZ registering them.
- **`<hlavc><m13>A</m13></hlavc>` shorthand.** The form may use `m13="A"` for
  "celoročně hlavní" without filling `m1`-`m12`. Valid; do not expand to
  per-month flags unless the activity actually changed mid-year.
- **`<prihldp/>` empty** is the right state for an OSVČ already registered
  for důchodové pojištění. Only fill it for new registrations.

### New záloha calculation

```
nová roční pojistné = vyměřovací základ × 0.292
nová měsíční záloha = ceil(nová roční pojistné / 12)
```

The new záloha applies from the calendar month following submission of the
přehled (per [§14 odst. 9 zákona 589/1992][1]). Practical advice: ask the
user to check their current trvalý příkaz and prepare the change for the
next month's payment.

### Bank account for payment

**No specific account number is hard-coded in this skill** — ČSSZ assigns the
account when the user registers as OSVČ. Resolution order, per the
`BankAccounts` rule:

1. Recall from user memory (last year's verified account).
2. Otherwise fetch from
   `https://www.cssz.cz/web/cz/kontakty/region/ossz/<okres>#bankovni-spojeni`
   for the user's territorial OSSZ. Prefix encoding:
   - `01011-` důchodové pojištění OSVČ
   - `11017-` nemocenské pojištění OSVČ
   - `21012-` zaměstnavatelé / dobrovolné důchodové
3. If still uncertain, ask the user to copy the account from their předpis
   záloh PDF or ePortál ČSSZ.

VS = `vsdp` (variabilní symbol důchodového pojištění) from the přehled, **not**
the rodné číslo.

## Constraints

- Always present the diff for user confirmation before generating output
- Flag if the correction changes activity type (hlavní ↔ vedlejší)
- Flag if the corrected advance payment differs from what's currently being paid
- When taxpayer had concurrent §6 employment, set `druc="S"` with per-month flags in both `hlavc` and `vedc` (see SocialInsuranceSchema rule)

[1]: https://www.zakonyprolidi.cz/cs/1992-589
[2]: https://www.zakonyprolidi.cz/cs/1992-589#p5b
[3]: https://www.zakonyprolidi.cz/cs/1992-589#p7
[4]: https://eportal.cssz.cz/
