Interest-free loans from a shareholder (`společník`) to their `s.r.o.` are common funding for small Czech companies. Three statutes govern the form and tax treatment.

## Interest-free is allowed (no transfer-pricing exposure)

Per [§23 odst. 7 ZDP][zdp23-7], the arm's-length adjustment for related-party transactions has an explicit safe harbour for an interest-free loan (`bezúročná zápůjčka`) from a shareholder to their `s.r.o.` — no fictitious interest is imputed for tax purposes when the lender is a member of the borrower entity. Document the interest-free nature explicitly in the contract; do not rely on silence.

The same safe harbour does **not** apply in the opposite direction: a loan from the `s.r.o.` to its shareholder must bear interest at the customary market rate (`obvyklá úroková sazba`), otherwise the company is taxed on imputed interest income.

## Written form is mandatory for single-member companies

Per [§13 ZOK][zok13], any contract between a `společnost` and its sole `společník` who is also `jednatel` requires written form with officially certified signatures (`úředně ověřené podpisy`) when not made in the ordinary course of business. A shareholder loan is not ordinary-course business. Verbal agreements are unenforceable and cannot be relied on by either party.

For multi-member companies the §13 requirement does not apply, but written form is still strongly recommended for evidence and audit defence.

## Loan creation patterns

Three common ways a shareholder funds the company. All three are interest-free loans (`zápůjčka`) per [§2390 NOZ][noz2390] and use account `365 Závazky vůči společníkovi` on the company's books:

| Pattern                                       | Mechanics                                                                                                                                                | Booking on company's books                            |
| --------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------- |
| Cash transfer                                 | Shareholder wires CZK to the company bank account                                                                                                        | `221 / 365`                                           |
| Payment of company's debt to a third party    | Shareholder pays a supplier, accountant, or notář invoice from a personal account, satisfying the company's payable per [§1936 NOZ][noz1936]            | `321 / 365` (closes payable, opens shareholder loan)  |
| Non-equity in-kind contribution               | Shareholder transfers an asset to the company outside `vklad do základního kapitálu`                                                                     | `01x or 02x / 365` at fair value                      |

For each pattern, draft a written `smlouva o zápůjčce` (or include all tranches in one umbrella contract) at the time of the funding event.

## Documenting historical loans without backdating

When historical loans were not contemporaneously documented, **do not backdate** a contract — backdating private documents to deceive a third party (auditor, FÚ, soud) carries criminal exposure under [§348 trestního zákoníku][tz348].

Two safe approaches instead:

1. **Current-dated `smlouva o zápůjčce`** that recites the historical funding events as factual statements — "The parties confirm that during 2020–2024 the lender provided the borrower with the loans listed below in the dates and amounts shown." The contract is signed today and acknowledges past performance.
2. **`Uznání závazku`** per [§2053 NOZ][noz2053] — a one-page declaration by the company (signed by `jednatel`) acknowledging the current debt amount. Stops the limitation period (`promlčecí lhůta`) from running and creates a legal presumption that the debt exists.

Both rely on bank statements and source documents (supplier invoice paid from personal account, etc.) as the underlying evidence. The contract or acknowledgment is a wrapper, not the substantive proof.

## Repayment and conversion

The shareholder may demand repayment at any time per the contract. When the company lacks liquidity, options are:

- **Partial repayment** — pay what cash is available; the residual stays on account 365 as a payable.
- **Conversion to non-equity contribution** — `příplatek mimo základní kapitál` per [§162 ZOK][zok162] shifts the 365 payable to equity without a cash transaction. Requires a `valná hromada` resolution.
- **Debt forgiveness (`prominutí dluhu`)** per [§1995 NOZ][noz1995] — last resort. The forgiven amount is taxable revenue for the company (booked to `648`), creating a DPPO base. Avoid unless exit-driven.

[zdp23-7]: https://www.zakonyprolidi.cz/cs/1992-586#p23
[zok13]: https://www.zakonyprolidi.cz/cs/2012-90#p13
[zok162]: https://www.zakonyprolidi.cz/cs/2012-90#p162
[noz2390]: https://www.zakonyprolidi.cz/cs/2012-89#p2390
[noz2053]: https://www.zakonyprolidi.cz/cs/2012-89#p2053
[noz1936]: https://www.zakonyprolidi.cz/cs/2012-89#p1936
[noz1995]: https://www.zakonyprolidi.cz/cs/2012-89#p1995
[tz348]: https://www.zakonyprolidi.cz/cs/2009-40#p348
