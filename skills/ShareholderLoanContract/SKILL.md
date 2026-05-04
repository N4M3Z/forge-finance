---
name: ShareholderLoanContract
version: 0.1.0
description: "Document loans from shareholder to Czech `s.r.o.` — generate `smlouva o zápůjčce` for current loans or `uznání závazku` for historical loans, instead of backdating. Covers cash transfers, third-party debt payments, and partial repayments. USE WHEN shareholder loan, member loan, smlouva o zapujcce, uznani zavazku, půjčka od společníka, bezúročná zápůjčka, document historical loan, sro funding."
---

# ShareholderLoanContract

Workflow for documenting loans from a shareholder (`společník`) to their Czech `s.r.o.` either prospectively (current loan being made) or retrospectively (historical loans without contract). Always uses current dates — backdating private documents to deceive a third party (auditor, `FÚ`, court) carries criminal exposure under [§348 trestního zákoníku][tz348].

See the [ShareholderLoans][shrules] rule for the statutory framework, and [AuditSignalDisclosure][auditrule] before recommending any treatment that affects the company's tax return.

## When to use which document

| Situation                                                                                           | Document                                                       | Authority                              |
| --------------------------------------------------------------------------------------------------- | -------------------------------------------------------------- | -------------------------------------- |
| Current loan being made today                                                                       | `Smlouva o zápůjčce` (loan contract)                           | [§2390 NOZ][noz2390]                   |
| Multi-tranche current loan with planned future tranches                                             | `Smlouva o zápůjčce` framework with tranche schedule           | [§2390 NOZ][noz2390]                   |
| Historical loans without contract — multiple past funding events                                    | Current-dated `Smlouva o zápůjčce` reciting historical events  | [§2390 NOZ][noz2390]                   |
| Single historical balance (don't care about per-tranche detail)                                     | `Uznání závazku` (one-page acknowledgment of debt)             | [§2053 NOZ][noz2053]                   |
| Repayment in full                                                                                   | `Potvrzení o splacení zápůjčky` + bank-transfer record         | derived from contract                  |
| Conversion of loan to non-equity contribution (`příplatek mimo základní kapitál`)                   | `Rozhodnutí valné hromady` per [§162 ZOK][zok162]              | requires shareholder resolution        |

## Inputs needed

1. **Lender** — full name, date of birth, address. For multiple shareholders, identify which one is the lender.
2. **Borrower** — `s.r.o.` name, `IČO`, `DIČ`, `sídlo`, `spisová značka` from `obchodní rejstřík`.
3. **Funding events** — date, amount in CZK, mechanism (cash transfer, paid third-party invoice, in-kind), bank account or invoice reference. Source from bank statements and supplier invoices.
4. **Repayments to date** — date, amount, mechanism. Subtract from gross loaned to get current outstanding.
5. **Single-member status** — is the lender the sole `společník` AND `jednatel`? If yes, [§13 ZOK][zok13] requires written form with `úředně ověřené podpisy` (officially certified signatures). If no (multiple members), written form recommended but signatures may be unwitnessed.

## Workflow

### 1. Reconstruct the loan history

Build a chronological table of every funding event and repayment:

| Date        | Direction                  | Amount CZK     | Mechanism                                    | Evidence                  |
| ----------- | -------------------------- | -------------: | -------------------------------------------- | ------------------------- |
| YYYY-MM-DD  | Lender → Borrower          | +X             | Cash transfer to bank account NNNNN          | Bank statement YYYY-MM    |
| YYYY-MM-DD  | Lender → Borrower          | +X             | Paid supplier invoice from personal account  | Invoice + personal stmt   |
| YYYY-MM-DD  | Borrower → Lender          | −X             | Cash withdrawal at account closure           | Bank statement            |
| **Total**   |                            | **net X**      |                                              |                           |

The net total is the current outstanding loan principal. This must match account `365 Závazky vůči společníkovi` on the company's books.

### 2. Choose the document type

Use the table at the top of this skill. For most "I forgot to write a contract for years of loans" scenarios, the right output is a **current-dated `Smlouva o zápůjčce`** that recites historical events. The `Uznání závazku` template is shorter but loses per-tranche detail.

### 3. Fill the template

Use the templates in this skill:

- [`templates/loan-contract.md`](./templates/loan-contract.md) — `Smlouva o zápůjčce`
- [`templates/debt-acknowledgment.md`](./templates/debt-acknowledgment.md) — `Uznání závazku`

Both templates declare the loan as interest-free per [§23 odst. 7 ZDP][zdp23-7] safe harbour for shareholder-to-company loans. Repayment is on demand by the lender.

### 4. Confirm signing requirements

- **Single-member `s.r.o.` where lender = `jednatel`**: print, sign by lender (in their personal capacity), then sign by lender (in their `jednatel` capacity for the borrower). Take to a `Czech Point` or notary for `úředně ověřené podpisy` (~30 CZK per signature).
- **Multi-member `s.r.o.`**: print, sign by lender (personal), sign by an authorized `jednatel` of the borrower (different person from lender). Officially certified signatures recommended but not required.

### 5. Store and reference

Place the signed PDF in the company's document archive. Reference the contract date and amount in:

- Annual `příloha v účetní závěrce` (notes to financial statements), section "Závazky vůči společníkovi"
- Future `Uznání závazku` if loan amount changes materially

## Workflow Routing

| Scenario                                                                  | Path                                                                  |
| ------------------------------------------------------------------------- | --------------------------------------------------------------------- |
| Documenting one current cash loan                                         | `Smlouva o zápůjčce` template, single tranche                         |
| Documenting historical multi-event loan                                   | `Smlouva o zápůjčce` template with historical recital + tranche table |
| Just need to acknowledge current outstanding balance                      | `Uznání závazku` template                                             |
| Loan being converted to equity contribution                               | Hand off to `valná hromada` resolution per [§162 ZOK][zok162] (out of scope here) |
| Loan being forgiven                                                       | `Prominutí dluhu` per [§1995 NOZ][noz1995] — taxable revenue for company; flag tax cost first |

## Constraints

- Never backdate the contract date. Use today's date and recite historical facts in the body.
- Never assert facts that bank statements or source documents do not support.
- For single-member `s.r.o.`, do not skip the `úředně ověřené podpisy` requirement of [§13 ZOK][zok13] — unsigned/uncertified contracts are unenforceable in disputes.
- Do not generate interest provisions for shareholder-to-company loans unless the parties specifically negotiated interest. Default is `bezúročná` per [§23(7) ZDP][zdp23-7] safe harbour.
- For loans in the opposite direction (company → shareholder), interest at customary market rate (`obvyklá úroková sazba`) is required to avoid imputed-interest tax exposure — that scenario is out of scope for this skill; route to a `daňový poradce`.

[shrules]: ../../rules/en-CZ/ShareholderLoans.md
[auditrule]: ../../rules/AuditSignalDisclosure.md
[noz2390]: https://www.zakonyprolidi.cz/cs/2012-89#p2390
[noz2053]: https://www.zakonyprolidi.cz/cs/2012-89#p2053
[noz1995]: https://www.zakonyprolidi.cz/cs/2012-89#p1995
[zdp23-7]: https://www.zakonyprolidi.cz/cs/1992-586#p23
[zok13]: https://www.zakonyprolidi.cz/cs/2012-90#p13
[zok162]: https://www.zakonyprolidi.cz/cs/2012-90#p162
[tz348]: https://www.zakonyprolidi.cz/cs/2009-40#p348
