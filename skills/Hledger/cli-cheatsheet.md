# hledger CLI cheat-sheet

Reference for everyday hledger commands against a Czech mikro UJ journal. Assumes `hledger.conf` is set up at the repo root so `-f` is implicit; otherwise add `-f <company>.journal` to each command.

## Daily commands

| Command                                  | What it shows                                                          |
| ---------------------------------------- | ---------------------------------------------------------------------- |
| `hledger stats`                          | Period span, txn count, account count, included files                  |
| `hledger check`                          | Strict parse + balance + account-declared assertions                   |
| `hledger accounts`                       | Every account that has at least one posting                            |
| `hledger bal`                            | Flat balance, every account                                            |
| `hledger bal --tree`                     | Hierarchical balance (default if set in hledger.conf)                  |
| `hledger bal -e 2026-01-01`              | Snapshot at a specific date                                            |
| `hledger bse -e 2026-01-01`              | Balance Sheet with Equity at a date                                    |
| `hledger is --yearly`                    | P/L per year, side by side (the canonical reconstruction check)        |
| `hledger is -p 'quarterly 2025'`         | Quarterly P/L for a year                                               |
| `hledger is -p 'monthly 2025'`           | Monthly P/L                                                            |
| `hledger register 365.000`               | Every txn touching account 365, with running balance                   |
| `hledger register 221.001 -p 2025`       | Bank ČS movements in 2025                                              |
| `hledger areg 221.001`                   | Account register (single-account focused, like a bank statement view)  |
| `hledger print`                          | Round-trip — what hledger sees, full transactions                      |
| `hledger print -2`                       | First N transactions                                                   |
| `hledger activity`                       | Histogram of postings per period                                       |
| `hledger -f <company>.en.journal …`      | Same data through the English alias overlay (see Bilingual section)    |

## Query filter primitives

Append to any command. hledger queries are space-separated, ANDed together.

| Filter                | Meaning                                                |
| --------------------- | ------------------------------------------------------ |
| `5.Náklady`           | Account name regex (matches anywhere in path)          |
| `acct:365`            | Same, explicit form                                    |
| `not:acct:365`        | Negation                                               |
| `date:202407..202412` | Date range (inclusive start, exclusive end)            |
| `date:2025`           | Single year                                            |
| `desc:Zápůjčka`       | Description regex                                      |
| `payee:Acme`          | Payee regex                                            |
| `amt:'>10000'`        | Amount comparison (use quotes; `<`, `>`, `=`, `>=`)    |
| `cur:CZK`             | Filter by commodity                                    |
| `tag:audit`           | Has the tag                                            |
| `tag:audit=high`      | Tag with specific value                                |
| `code:F01`            | Transaction code filter                                |

Examples:

```sh
hledger bal 5.Náklady                          # only expense accounts
hledger reg date:2024..2025 amt:'>10000'       # 2024 entries above 10K
hledger print desc:Zápůjčka                    # all loan-related transactions
hledger bal not:tag:reconstructed              # exclude tagged reconstruction entries
```

## Period syntax

Used with `-p` flag or in queries:

| Period              | Meaning                                            |
| ------------------- | -------------------------------------------------- |
| `-p 2025`           | Calendar year 2025                                 |
| `-p 'q1 2025'`      | Q1 2025 (also `q2`, `q3`, `q4`)                    |
| `-p 'jan 2025'`     | Single month                                       |
| `-p '2024-06..2025-03'` | Custom range                                   |
| `-p yearly`         | Group by year (with `is`, `bal`)                   |
| `-p quarterly`      | Group by quarter                                   |
| `-p monthly`        | Group by month                                     |

`-e <date>` (end-of-period) and `-b <date>` (begin-of-period) work alongside `-p`.

## Walk-through suggestions for getting acquainted

```sh
# Walk one full year through the lens of each report:
hledger is -p 2021                             # 2021 P/L
hledger bse -e 2022-01-01                      # state immediately after 2021 close
hledger reg -p 2021                            # every 2021 entry chronologically
hledger print -p 2021                          # double-entry form

# Compare years side by side:
hledger bal 5 6 --yearly                       # expenses + revenues per year
hledger bse -p 'every year' --depth 2          # year-end snapshots, depth-2

# Reconcile to filed závěrka:
hledger is --yearly                            # match against filed VH per year
hledger bal 365 -e 2025-01-01                  # match Příloha čl. 3.3 disclosure
hledger bal 311 -e 2025-01-01                  # match receivables disclosure

# Drill into a specific account's history:
hledger reg 365.000                            # full shareholder loan history
hledger areg 221.001                           # bank statement view
```

## Output formatting flags

| Flag                  | Effect                                            |
| --------------------- | ------------------------------------------------- |
| `--pretty`            | Unicode box-drawing in tables (set in hledger.conf for global default) |
| `--tree`              | Hierarchical view (default for `bal`/`bse` if set in hledger.conf) |
| `--flat`              | Flat view, override `--tree`                      |
| `--depth N`           | Truncate account hierarchy to N levels            |
| `-O csv` / `-O json`  | Machine-readable output                           |
| `--no-total`          | Hide totals row                                   |
| `-N`                  | Same as `--no-total`                              |
| `--width=200`         | Wider register output (env vars don't expand — use literals) |
