---
name: HealthFiling
version: 0.2.0
description: "Health insurance filing — generate and correct Přehled OSVČ for health insurance companies (CPZP, VZP, OZP). USE WHEN health insurance, přehled OSVČ, zdravotní pojištění, CPZP, VZP, OZP, pojišťovna."
---

# HealthFiling

Generate or correct the health insurance `Přehled o příjmech a výdajích OSVČ` derived from DPFO data. Routes to the correct health insurance company portal.

## Health Insurance Companies

| Code | Company                                       | Přehled portal                                            | DS         |
| ---- | --------------------------------------------- | --------------------------------------------------------- | ---------- |
| 111  | VZP (Všeobecná zdravotní pojišťovna)          | [moje.vzp.cz][12]                                         |            |
| 205  | CPZP (Česká průmyslová zdravotní pojišťovna)  | [portal.cpzp.cz/app/prehled-osvc/2025/][10]               | `mk5ab8i`  |
| 207  | OZP (Oborová zdravotní pojišťovna)            | [ozp.cz][7]                                               |            |
| 211  | ZPMV (Zdravotní pojišťovna MV ČR)             | [zpmvcr.cz][8]                                            |            |
| 213  | RBP (Revírní bratrská pokladna)               | [rbp213.cz][9]                                            |            |

The user's company code appears on the `zápočtový list` or can be specified directly.

## Input

Requires from the DPFO (provided by TaxReturn or TaxFiling):
- §7 tax base
- Number of months of self-employment activity
- Months where employment (§6) was concurrent (reduces OSVČ health obligation)

## Instructions

### 1. Identify health insurance company

Ask the user or detect from available documents (zápočtový list field `Zdravotní pojišťovna`).

### 2. Compute updated values

From the corrected DPFO §7 base:
- `vyměřovací základ` = 50% of §7 tax base ([§3a][1])
- Annual health insurance = `vyměřovací základ` × 13.5% ([§2(1)][2])
- Monthly advance = annual ÷ months of activity, rounded up
- Minimum `vyměřovací základ`: check against the annual minimum ([§3a(2)][1])
- Months with concurrent employment where employer satisfied the minimum employee `vyměřovací základ` (18 900 CZK/month in 2025): OSVČ minimum floor does not apply for those months — pay only on actual 50% of §7 base

### 3. Diff against prior filing

```markdown
| Field                     | Filed    | Corrected | Delta    |
| ------------------------- | -------- | --------- | -------- |
| §7 tax base               | X CZK    | Y CZK     | +Z CZK  |
| Vyměřovací základ (50%)   | A CZK    | B CZK     | +C CZK  |
| Annual insurance (13.5%)  | D CZK    | E CZK     | +F CZK  |
| Monthly advance           | G CZK    | H CZK     | +I CZK  |
```

### 4. Submission

File via the company-specific portal. No XML upload — health insurers use web forms only (unlike ČSSZ). CPZP also accepts unauthenticated filing at [portal.cpzp.cz/app/prehled-osvc-pro-neprihlasene/2025/][11].

Correction notification deadline: **8 days** after discovering the change ([§24(2)][3]). Correction payment deadline: **30 days** from discovery (longer than ČSSZ's 8 days). Regular přehled due one month after the DPFO filing deadline.

## CPZP JSON Schema

Template cached at `templates/en-CZ/CPZP-prehled-template.json`. Upload via "Načíst ze souboru" on the portal.

### Key Fields

| Field                                    | Type    | Description                                           |
| ---------------------------------------- | ------- | ----------------------------------------------------- |
| `typ-prehledu`                           | string  | `RADNY`, `OPRAVNY`, or `ZMENOVY`                     |
| `danovy-zaklad`                          | string  | §7 tax base                                           |
| `mesicu-osvc`                            | string  | Total months registered as OSVČ                       |
| `mesicu-platil`                          | string  | Months where minimum VZ applied                       |
| `neplatila-povinnost-hradit-zalohy-N`    | boolean | No zálohy obligation in month N (souběh exempt)       |
| `nebyl-zaklad-N`                         | boolean | No minimum VZ in month N (souběh exempt)              |

Health insurance uses **50%** of §7 base (unlike ČSSZ which uses 55%).

## VZP portal specifics

The VZP web form (Moje VZP → Daňové formuláře → Přehled OSVČ) is an **online
HTML form only** — no XML import, no XML export, no JSON template. The skill
must compute every value, then walk the user through entering them into the
form by hand.

The form pre-fills a snapshot of the user's VZP ledger as of a recent date
("Stav k DD.MM.YYYY"). Late-December záloha payments may not be reflected
yet — ignore the snapshot's "celkový nedoplatek" if the user has paid since
that date. The přehled's own doplatek calculation (based on declared 2024
zálohy, not the snapshot) is what matters.

### Bank account for payment

**No specific account number is hard-coded in this skill** — VZP/CPZP/OZP
accounts are per-region, JS-rendered (not headlessly scrapeable), and tied to
the user's pojišťovna. Resolution order, per the `BankAccounts` rule:

1. Recall from user memory (last year's verified account).
2. Otherwise direct the user to copy the account from:
   - VZP: <https://www.vzp.cz/platci/cisla-uctu> or moje.vzp.cz account page
   - CPZP / OZP / ZPMV / RBP: each pojišťovna's "platby" page
3. Verify against the QR code on the předpis PDF the pojišťovna sends.

VS = rodné číslo (10 digits, no slash).

## Constraints

- Always confirm the health insurance company before computing
- Present diff for user confirmation before generating output
- Flag months where §6 employment overlapped with §7 self-employment (affects obligation calculation)
- Flag if the user changed health insurance companies mid-year

[1]: https://www.zakonyprolidi.cz/cs/1992-592#p3a
[2]: https://www.zakonyprolidi.cz/cs/1992-592#p2
[3]: https://www.zakonyprolidi.cz/cs/1992-592#p24
[4]: https://www.zakonyprolidi.cz/cs/1992-592
[5]: https://www.vzp.cz/
[6]: https://www.cpzp.cz/
[7]: https://www.ozp.cz/
[8]: https://www.zpmvcr.cz/
[9]: https://www.rbp213.cz/
[10]: https://portal.cpzp.cz/app/prehled-osvc/2025/
[11]: https://portal.cpzp.cz/app/prehled-osvc-pro-neprihlasene/2025/
[12]: https://moje.vzp.cz
