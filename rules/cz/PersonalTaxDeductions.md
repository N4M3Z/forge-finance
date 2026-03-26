`Nezdanitelné části základu daně` reduce the tax base before computing DPFO. Each deduction requires specific proof.

## Retirement Savings Products (§15a aggregate cap)

From 2024, all retirement savings deductions share a single 48 000 CZK/year aggregate ceiling ([§15a][1], introduced by [zákon 462/2023 Sb.][2]):

| Product                        | Czech                             | Proof                                          |
| ------------------------------ | --------------------------------- | ---------------------------------------------- |
| Supplementary pension savings  | `doplňkové penzijní spoření`      | `výpis z doplňkového penzijního spoření`       |
| LTIP                           | `dlouhodobý investiční produkt`   | `daňové potvrzení k DIP`                       |
| Life insurance                 | `životní pojištění`               | `potvrzení zaplacené pojistné`                 |
| Long-term care insurance       | `pojištění dlouhodobé péče`       | `potvrzení zaplacené pojistné`                 |

The 48 000 CZK cap is shared — not per product. See LongTermInvestment rule for product-specific conditions.

## Other Deductions (§15)

| Deduction        | Czech                             | Limit                       | Proof                                         | Source      |
| ---------------- | --------------------------------- | --------------------------- | --------------------------------------------- | ----------- |
| Mortgage interest| `úroky z úvěru na bytové potřeby` | 150 000 / 300 000 CZK       | `potvrzení o zaplacených úrocích` + `smlouva` | [§15(3)][3] |
| Donations        | `bezúplatná plnění` (`dary`)      | max 15% of tax base         | `potvrzení od příjemce`                       | [§15(1)][4] |
| Blood donation   | `odběr krve`                      | 3 000 CZK per donation      | `potvrzení od odběrového centra`              | [§15(1)][4] |
| Organ donation   | `darování orgánu`                 | 20 000 CZK                  | medical confirmation                          | [§15(1)][4] |

Mortgage interest limit depends on contract date: 300 000 CZK before 2021, 150 000 CZK from 2021 ([zákon 39/2021 Sb.][5]). See MortgageInterest rule.

Donations minimum: 1 000 CZK or 2% of tax base (whichever is lower threshold).

## Tax Credits (`slevy na dani`)

Credits reduce tax directly, not the base:

| Credit                               | Amount (2024) | Source         |
| ------------------------------------ | ------------- | -------------- |
| `Základní sleva na poplatníka`       | 30 840 CZK    | [§35ba(1a)][6] |
| `Sleva na manžela/manželku`          | 24 840 CZK    | [§35ba(1b)][6] |
| `Daňové zvýhodnění` na 1. dítě      | 15 204 CZK    | [§35c(1)][7]   |
| `Daňové zvýhodnění` na 2. dítě      | 22 320 CZK    | [§35c(1)][7]   |
| `Daňové zvýhodnění` na 3.+ dítě     | 27 840 CZK    | [§35c(1)][7]   |
| `Sleva na invaliditu` (1./2.)        | 2 520 CZK     | [§35ba(1c)][6] |
| `Sleva na invaliditu` (3.)           | 5 040 CZK     | [§35ba(1d)][6] |
| `Sleva na studenta`                  | 4 020 CZK     | [§35ba(1f)][6] |

When validating: verify each deduction has proof in project Assets, check retirement products against the shared 48 000 CZK aggregate, cross-reference employer contributions against [§6(9)][8] exemption (50 000 CZK combined).

[1]: https://mf.gov.cz/cs/financni-trh/ochrana-spotrebitele/aktuality/2024/dlouhodoby-investicni-produkt-a-danova-podpora-pro-54732
[2]: https://www.zakonyprolidi.cz/cs/2023-462
[3]: https://www.zakonyprolidi.cz/cs/1992-586#p15-3
[4]: https://www.zakonyprolidi.cz/cs/1992-586#p15-1
[5]: https://www.zakonyprolidi.cz/cs/2021-39
[6]: https://www.zakonyprolidi.cz/cs/1992-586#p35ba
[7]: https://www.zakonyprolidi.cz/cs/1992-586#p35c
[8]: https://www.zakonyprolidi.cz/cs/1992-586#p6-9
