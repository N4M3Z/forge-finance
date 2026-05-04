Czech corporate-tax treatment of receivable writeoffs (`odpis pohledávky`) under [zákon 586/1992 Sb.][zdp] and [zákon 593/1992 Sb. o rezervách][zor]. The default for written-off non-trade receivables is non-deductible — `daňový` deductibility requires meeting strict statutory pre-conditions.

## Default rule for security deposits and prepayments

Writeoffs of paid `kauce` and `záloha` (booked on accounts 314/315) are **almost always tax non-deductible**. Two compounding blockers:

1. [§24 odst. 2 písm. y) ZDP][zdp24y] requires that the receivable was originally recognized as revenue. A `kauce` paid out goes 314/221 — never through revenue — so the gateway is closed at the threshold.
2. [§2 odst. 2 zákona 593/1992 Sb.][zor2] explicitly excludes receivables arising from `zálohy` from `zákonné opravné položky`. Without an allowance, the alternative §24(2)(y) path through opravné položky also fails.

Standard treatment: book the writeoff as `548 Jiné provozní náklady / 311 (or 314/315) Pohledávky` with an analytical split flagging it non-deductible. Add the amount to `ř.40` of the DPPDP9 return as a `připočitatelná položka`.

## Trade-receivable writeoffs (account 311)

Trade receivables (recognized as revenue when invoiced) can qualify for tax-deductible writeoff under [§24(2)(y) ZDP][zdp24y] when one of these triggers fires:

| Trigger                                                                       | Source                    | Notes                                            |
| ----------------------------------------------------------------------------- | ------------------------- | ------------------------------------------------ |
| Debtor in `insolvenční řízení` and the claim was duly filed                   | §24(2)(y)(1)              | Verify in [insolvenční rejstřík][insolv]         |
| Debtor died (individual) or ceased without legal successor (legal entity)     | §24(2)(y)(2)–(3)          | Verify in [or.justice.cz][orj]                   |
| `dražba` or `exekuce` ended without satisfaction                              | §24(2)(y)(4)              | Documented decision required                     |
| Receivable covered by `zákonné opravné položky` per zákon 593/1992            | §24(2)(y) closing clause  | Allowance creation has its own age + amount tests |

Pre-condition (always): the receivable must have been recognized as revenue at the moment it arose AND not yet written off for tax purposes in a prior period.

## Escape paths when default fails

When direct deductible writeoff is blocked but the receivable is genuinely uncollectible, two structural alternatives exist:

- **`Postoupení pohledávky`** per [§24(2)(s) ZDP][zdp24s] — sell the receivable to a third party. The cost basis (face value) becomes a deductible expense up to the amount received from the buyer. Requires a written `smlouva o postoupení pohledávky` plus debtor notification per [§1882 NOZ][noz1882]. Restructuring after the fact does not work — the consideration must be characterized as `úplata za postoupení` in the original agreement.
- **Wait for §24(2)(y) trigger** — track the debtor's status and write off when an insolvency, death/dissolution, or completed enforcement event occurs.

Under no circumstance treat a `záloha` writeoff as deductible without one of the explicit triggers — a doměrek + 20 % `penále` per [§251 daňového řádu][dr251] on audit is the predictable outcome.

[zdp]: https://www.zakonyprolidi.cz/cs/1992-586
[zdp24y]: https://www.zakonyprolidi.cz/cs/1992-586#p24
[zdp24s]: https://www.zakonyprolidi.cz/cs/1992-586#p24
[zor]: https://www.zakonyprolidi.cz/cs/1992-593
[zor2]: https://www.zakonyprolidi.cz/cs/1992-593#p2
[noz1882]: https://www.zakonyprolidi.cz/cs/2012-89#p1882
[dr251]: https://www.zakonyprolidi.cz/cs/2009-280#p251
[insolv]: https://isir.justice.cz
[orj]: https://or.justice.cz
