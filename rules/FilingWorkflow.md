End-to-end filing order and cascade dependencies for Czech personal tax year.

## Filing Order

File in this order — each downstream filing depends on the previous:

```
1. DPFO (income tax)
2. ČSSZ přehled OSVČ (social security)
3. Health insurance přehled OSVČ (CPZP/VZP/OZP)
```

ČSSZ and health přehledy derive from the §7 tax base on the DPFO. Never file the přehledy before the DPFO is final.

## Correction Cascade

Correcting the DPFO (`opravné` or `dodatečné přiznání`) triggers mandatory correction of both přehledy if the §7 base or activity classification changed. Even if only §6 was added and §7 stayed the same, check whether the activity type (hlavní/vedlejší/souběh) needs updating.

## Deadlines After Correction

| Filing              | Notification deadline        | Payment deadline                |
| ------------------- | ---------------------------- | ------------------------------- |
| ČSSZ přehled        | 8 days from correction       | 8 days from přehled deadline    |
| Health přehled      | 8 days from correction       | 30 days from correction         |

Health insurance gives 30 days to pay, ČSSZ gives only 8. Prioritize ČSSZ payment.

## Souběh (§6 + §7 in Same Year)

When a taxpayer had both employment and self-employment in the same year:

- **DPFO**: declare both §6 and §7 income. Employer-withheld advances go on row 84 (`kc_zalzavc`), not row 85.
- **ČSSZ**: set `druc="S"` (souběh), per-month flags in `hlavc` and `vedc`, reason `zam="A"`.
- **CPZP**: set `neplatila-povinnost-hradit-zalohy-N: true` and `nebyl-zaklad-N: true` for employment months.

The minimum VZ does not apply for months where the employer paid health insurance above the employee minimum (`vyměřovací základ` 18 900 CZK/month in 2025).

## Common Mistakes

**Wrong activity type.** Filing as `hlavní` for all 12 months when you were employed part of the year. Employment months are `vedlejší` with reason `zaměstnání`. This affects minimum VZ and pension record.

**Pension deduction threshold.** Only pension contributions above 1 700 CZK/month are deductible. Filing the full contribution amount instead of the excess is the most common §15a error.

**Mortgage cap by contract date.** Contracts signed on or after 1 January 2021 have a 150 000 CZK limit, not 300 000. The date is the contract signing date, not the property purchase date.

**LTIP vs aggregate cap.** Contributing more than 48 000 CZK to LTIP is fine — but only 48 000 is deductible (shared across all §15a products). Check the `daňové potvrzení k DIP` for actual contribution, then cap at 48 000 minus any other §15a deductions.

**Social insurance rate.** ČSSZ uses 55% of §7 base, health insurance uses 50%. Mixing these up produces wrong přehled amounts.
