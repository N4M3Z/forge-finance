Czech-source capital income subject to withholding at source under [§ 36 zákon
586/1992 Sb.][1]. These items are **fully taxed by the payer** at 15 %; the
recipient does **not** declare them on DPFO.

## In scope

| Income type                                         | Source                          |
|-----------------------------------------------------|---------------------------------|
| Úroky z bankovních / spořicích / termínovaných účtů | Czech bank                      |
| Úroky ze stavebního spoření                         | Stavební spořitelna             |
| Dividendy z českých akcií                           | E.g. ČEZ, Komerční banka, Moneta|
| Dividendy z českých podílových fondů                | Czech investiční společnost     |
| Kupóny z českých dluhopisů                          | Český emitent                   |

The bank/payer issues a `Potvrzení podle § 38g(2)` summarizing withheld tax —
keep for archive but do not enter on DPFO.

## NOT in scope (must declare)

| Income type                                    | Where on DPFO              |
|------------------------------------------------|----------------------------|
| Foreign-source dividends (e.g. Revolut, IBKR)  | §8 row 38; FX convert      |
| Foreign-source bank interest                   | §8 row 38; FX convert      |
| Sale / redemption of securities                | §10 (or §4(1)(w) exempt)   |
| Sale of crypto / digital assets                | §10 (or §4(1)(zh) exempt)  |
| Bond *maturity* — return of principal          | Not income                 |

The crucial distinction: withholding (§36) covers **interest and dividends**
only. Capital gains from disposals are §8/§10 income regardless of whether
the broker is a Czech bank.

## Validation prompts

- "Did you sell or redeem any units / shares this year?" — If yes, push to
  SecuritiesTax skill regardless of broker location.
- "What kind of investment ended in month X?" — Bond maturity is not income;
  fund redemption is.
- "Czech bank?" — If yes, dividends/interest are covered by §36; only
  disposals matter.

[1]: https://www.zakonyprolidi.cz/cs/1992-586#p36
