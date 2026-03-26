---
name: SecuritiesTax
version: 0.1.0
description: "Broker-agnostic securities tax computation — FIFO lot matching, time-test exemption, FX conversion, §8/§10 classification. USE WHEN securities tax, capital gains, time test, FX conversion, dividend tax, cost basis, lot matching."
---

Compute Czech tax obligations on securities transactions. Accepts normalized transaction data from any brokerage parser (Revolut, Interactive Brokers, Trading 212, Erste) and applies SecuritiesTax rules.

## Input Format

Expects a list of transactions, each with:
- `symbol`, `isin`, `name`
- `type`: `buy`, `sell`, or `dividend`
- `date` (ISO 8601)
- `quantity`, `price`, `amount` (in original currency)
- `currency` (ISO 4217)
- `fees` (in original currency)
- `withholding_tax` (for dividends)

Brokerage parsers (Revolut, etc.) normalize their exports into this shape before invoking SecuritiesTax.

## Instructions

### 1. FIFO Lot Matching

Match each sell to the oldest available buy lots (FIFO). For each matched lot, record:
- Acquisition date and cost basis
- Sale date and proceeds
- Holding period

### 2. Time-Test Exemption

Per SecuritiesTax rule: lots held over 3 years are exempt ([§4(1)(w)][1]). Flag borderline cases (exactly 3 years) for user confirmation.

### 3. 100K Threshold Check

If total gross proceeds across all sales do not exceed 100,000 CZK, all §10 income is exempt ([§4(1)(v)][1]).

### 4. FX Conversion

Ask the user which method to use, then apply consistently:

**Jednotný kurz (annual rate)**:
```sh
curl -s "https://www.kurzy.cz/kurzy-men/jednotny-kurz/" | # parse for the year's rate
```

**Denní kurz ČNB (daily rate)**:
```sh
curl -s "https://www.cnb.cz/cs/financni-trhy/devizovy-trh/kurzy-devizoveho-trhu/kurzy-devizoveho-trhu/denni_kurz.txt?date=DD.MM.YYYY"
```

The ČNB daily rate endpoint returns a pipe-delimited text file. Parse the line matching the currency code. Apply the same method to both buy and sell legs.

### 5. Compute Tax

**Stock sales (§10 — Příloha 2)**:
- Taxable gain per lot = proceeds (CZK) - cost basis (CZK) - fees (CZK)
- Exempt lots excluded
- §10 losses offset §10 gains in the same year, no carryforward

**Dividends (§8 — Řádek 38)**:
- Gross amount (pre-withholding) in CZK
- Foreign withholding tax creditable via Příloha č. 3
- At 15% Czech rate with 15% US treaty withholding: net CZ tax is zero (only when marginal rate is 15%; at 23% bracket, 8% differential applies)

### 6. Present Results

```markdown
**Lot Analysis**
| Symbol | Acquired   | Sold       | Holding | Cost (CZK) | Proceeds (CZK) | Gain (CZK) | Exempt? |
| ------ | ---------- | ---------- | ------- | ---------- | --------------- | ----------- | ------- |

**Summary**
| Category        | Amount (CZK) | DPFO location |
| --------------- | ------------ | ------------- |
| §10 taxable     | X            | Příloha 2     |
| §10 exempt      | Y            | not declared  |
| §8 dividends    | Z            | Řádek 38      |
| Foreign credit  | W            | Příloha 3     |
```

## Constraints

- Never mix FX methods within a filing
- Flag the 2025 transitional step-up option for pre-2025 holdings per SecuritiesTax rule
- Flag when marginal rate is 23% (affects dividend credit offset)

[1]: https://www.zakonyprolidi.cz/cs/1992-586#p4-1
