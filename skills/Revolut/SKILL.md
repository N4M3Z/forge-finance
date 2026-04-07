---
name: Revolut
version: 0.2.0
description: "Parse Revolut investment exports into normalized transactions for SecuritiesTax. USE WHEN revolut, revolut CSV, revolut P&L, revolut statement, revolut export."
---

# Revolut

Thin brokerage parser. Reads Revolut investment exports and normalizes them into the standard transaction format consumed by SecuritiesTax.

## Prerequisites

Revolut has no personal API. Export manually: Invest > Documents > Account Statement (Excel, "All time") or P&L Statement (PDF).

## Instructions

### 1. Read the export

Accept a file path (PDF, CSV, or Excel). For PDFs, the Read tool renders tables visually. For CSVs, parse directly. If PDF vision misreads values, ask the user to re-export as CSV or confirm values manually.

### 2. Extract transactions

For each row, produce a normalized record:

| Field            | Revolut P&L column          |
| ---------------- | --------------------------- |
| `symbol`         | Symbol                      |
| `isin`           | ISIN                        |
| `name`           | Security name               |
| `type`           | `sell` (Sells section), `dividend` (Other income section) |
| `date`           | Date sold / Date acquired   |
| `quantity`       | Quantity                    |
| `price`          | from Cost basis / Gross proceeds |
| `amount`         | Gross proceeds / Dividend   |
| `currency`       | USD (or as stated)          |
| `fees`           | Fees column                 |
| `withholding_tax`| Withholding Tax (dividends) |

For sell transactions, also extract the **acquisition date** and **cost basis** from the corresponding columns.

### 3. Hand off to SecuritiesTax

Pass the normalized transaction list to the SecuritiesTax skill for lot matching, time-test analysis, FX conversion, and tax computation.

## Constraints

- Never modify source export files
- If PDF parsing produces suspicious values (e.g., numbers that don't sum correctly), flag and ask user to confirm
- This skill only parses — all tax logic lives in SecuritiesTax
