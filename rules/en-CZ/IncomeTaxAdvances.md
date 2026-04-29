DPFO advance payments under [§ 38a zákon 586/1992 Sb.][1] are derived from
the **last known tax liability** — i.e. row 77 (`Daň celkem po úpravě o daňový
bonus`) of the most recent DPFO.

## Schedule

| Last-known tax (ř. 77) | Advances per year | Each advance | Due dates                     |
|------------------------|-------------------|--------------|-------------------------------|
| ≤ 30 000 CZK           | 0                 | —            | —                             |
| 30 001 – 150 000 CZK   | 2                 | 40 % rounded up to whole 100 CZK | 15. 6. and 15. 12. |
| > 150 000 CZK          | 4                 | 25 % rounded up to whole 100 CZK | 15. 3., 15. 6., 15. 9., 15. 12. |

The "advance period" runs from the day after the DPFO deadline to the same
date one year later (§ 38a odst. 1). Advances paid during the advance period
go on row 85 (`kc_zalpred`) of the next DPFO.

## Adjustment under § 174 daň. řádu

If the taxpayer's circumstances change materially (e.g. ceased main client,
extended illness), they may file `Žádost o stanovení záloh jinak` to reduce
or zero out advances. Decision is at the FÚ's discretion; allow 30 days lead
time before the next due date.

## Penalties for late payment

Same as for any tax — `úrok z prodlení` per [§ 252 daňového řádu][2] starts
from the day after the due date, with a 4-day administrative tolerance.
Forgiven below 1 000 CZK aggregate. See `Penalties` rule.

## Practical advice

- After every DPFO submission with row 77 > 30 000, set up the trvalý příkaz
  with the FÚ account (per `BankAccounts` rule) and VS = rodné číslo.
- For seasonal OSVČ whose income drops, file the § 174 žádost **before** the
  March advance due date (deadline-driven, not income-driven).

[1]: https://www.zakonyprolidi.cz/cs/1992-586#p38a
[2]: https://www.zakonyprolidi.cz/cs/2009-280#p252
