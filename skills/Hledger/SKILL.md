---
name: Hledger
version: 0.1.0
description: "Plain-text double-entry accounting via hledger CLI for small Czech `s.r.o.` — write chart of accounts, record transactions, run rozvaha + VZZ reports, validate bilance, open new tax year, export totals for filing-grade markdown. USE WHEN hledger, record transaction, add to journal, balance my books, validate journal, generate balance sheet, generate income statement, open new fiscal year, year-end close, plain-text accounting, podvojné účetnictví v hledgeru, kontrola bilance, `účetní deník` v hledgeru."
---

# Hledger

Plain-text double-entry bookkeeping for a Czech mikro `s.r.o.` using [hledger][HLED] (Haskell, GPLv3, brew-installable). The journal file (`*.journal`) is the source of truth — markdown deník/rozvaha/VZZ are derived outputs at year-end.

The chart of accounts (Czech `účtová osnova` per `vyhláška 500/2002`) is delivered by the AccountingChart skill — read that first if uncertain about which `účet` to use for a given operation.

## Workflow Routing

| Mode | Trigger | Section |
| ---- | ------- | ------- |
| Setup | "set up hledger", "create accounts.journal", first time using hledger for a company | [1. Setup](#1-setup-one-time) |
| Record | "add transaction to deník", "zaúčtuj fakturu/výpis", new účetní case | [2. Record](#2-record-a-transaction) |
| Report | "spočítej rozvahu", "VZZ za rok", "verify bilance", year-end transcription | [3. Report](#3-report) |
| New year | "open new tax year", "carry over balances" | [4. Open new tax year](#4-open-new-tax-year) |

## Prerequisites

```sh
brew install hledger
```

Verify: `hledger --version` should print `1.50` or higher (this skill was written against `1.52`).

## 1. Setup (one-time)

For a new company, create two files in the project directory:

**`accounts.journal`** — chart of accounts (one-time, reused every year). Each `account` directive declares an account, its hierarchy, type tag, and Czech `účet` code. Use the AccountingChart skill to populate this with the right `účty` for the company's activity.

**Recommended naming for Czech mikro UJ** (4 levels):

```
<třída>.<jméno>:<synt>.<analytika>:<jméno>:[label]
```

Examples:

```
0.Majetek:063.001:Podíl:PartnerCo
2.FinMajetek:221.001:Banka:ČS
3.Vztahy:311.001:Pohledávky:Acme
3.Vztahy:341.000:Daň
4.Kapitál:411.000:ZK
5.Náklady:568.000:Poplatky
6.Výnosy:602.000:Služby
```

- Třída + název as one node (`3.Vztahy`) — dot glues, colon would split into an extra hierarchy layer
- Synt + analytika displayed as `221.001` — standard Czech accounting format
- `.000` analytika when no sub-account; `.001`/`.002` when there is (e.g. multiple banks, multiple customers)
- Třída 3 contains both pohledávky and závazky — `bs` splits them by `type:` tag, not by path

```hledger
; accounts.journal
D 1.000,00 CZK                                    ; default commodity + decimal style
commodity 1.000,00 CZK

account 2.FinMajetek                              ; type:A
account 2.FinMajetek:221.001                      ; type:A, code:221001
account 2.FinMajetek:221.001:Banka:ČS             ; type:A, code:221001  ; Česká spořitelna 1234567890/0800
account 3.Vztahy                                                         ; obsahuje aktiva i pasiva
account 3.Vztahy:311.001:Pohledávky:Acme          ; type:A, code:311001
account 3.Vztahy:341.000:Daň                      ; type:L, code:341000
account 4.Kapitál                                 ; type:E
account 4.Kapitál:411.000:ZK                      ; type:E, code:411000
account 5.Náklady:568.000:Poplatky                ; type:X, code:568000
account 6.Výnosy:602.000:Služby                   ; type:R, code:602000
```

Account types per hledger convention: `A` Asset, `L` Liability, `E` Equity, `X` Expense, `R` Revenue. The `code:` tag is the Czech `účet` number — used by `bs` and `is` to sort output in `účtová osnova` order.

**`<year>.journal`** — yearly transactions. Starts with `include accounts.journal` then opening balances + transactions chronologically.

**Per-year files vs single canonical journal.** For high-volume operations, split per year (`2024.journal`, `2025.journal`) and copy closing balances forward as opening entries. For low-volume mikro UJ (~20–50 transactions/year), keep a single `<company>.journal` spanning all years with `; === <year> ===` banner comments — `is --yearly`, `bse -e <date>`, and cross-year `register` queries work without `-f` plumbing, no closing-balance duplication. Switch to per-year only when one file exceeds ~5 000 lines.

## 2. Record a transaction

Each transaction has a date, narrative, and ≥ 2 postings. Postings sum to zero (double-entry). Sign convention: debit positive, credit negative.

| Operation type | First posting (MD) | Second posting (D) |
| -------------- | ------------------ | ------------------ |
| Issue invoice (`fakturace`) | Aktiva:311 (positive) | Vynosy:602 (negative) |
| Receive payment (`inkaso`) | Aktiva:221 (positive) | Aktiva:311 (negative) |
| Pay expense (`nákup`) | Naklady:5xx (positive) | Pasiva:321 or Aktiva:221 (negative) |
| Tax accrual (`předpis daně`) | Naklady:591 (positive) | Pasiva:341 (negative) |

Example — Acme s.r.o. invoice 15.3.2024 + payment 29.3.2024:

```hledger
2024-03-15 * F01 Faktura Acme s.r.o.
    Aktiva:311:Acme             50000,00 CZK
    Vynosy:602                 -50000,00 CZK

2024-03-29 * B03 Inkaso od Acme s.r.o.
    Aktiva:221:Banka_CS         50000,00 CZK
    Aktiva:311:Acme            -50000,00 CZK
```

Shortcut: hledger auto-balances if you omit the amount on the last posting:

```hledger
2024-12-31 * I01 Predpis dane PO
    Naklady:591                 15000,00 CZK
    Pasiva:341:DanZPrijmu                       ; auto-filled to -15000,00 CZK
```

After each addition, validate parsing: `hledger -f <year>.journal stats`. If it errors, hledger refuses to commit and tells you which transaction doesn't balance.

## 3. Report

| Intent | Command | Output |
| ------ | ------- | ------ |
| Bilance / rozvaha | `hledger -f <year>.journal bse --depth 3 --tree -e <year+1>-01-01` | Aktiva/Pasiva/Kapital totals |
| Výkaz zisku a ztráty | `hledger -f <year>.journal is --tree -p <year>` | Tržby + náklady + VH |
| Bilance všech účtů | `hledger -f <year>.journal balance --tree` | Every account current balance |
| Pohyby na účtu | `hledger -f <year>.journal register Aktiva:221` | Chronological movements on the account |
| Validace bilance | `hledger -f <year>.journal stats` | Transaction count + 0 if balanced |
| Strict correctness check | `hledger check` | Parse + balance + account-declared assertions in one go |

For day-to-day querying — filter primitives (`acct:`, `date:`, `desc:`, `amt:'>10000'`, `cur:CZK`), period syntax (`-p quarterly 2025`), output flags, and reconciliation walk-throughs — see [cli-cheatsheet.md](cli-cheatsheet.md).

**Reconstruction verification.** When backfilling historical years from filed závěrka PDFs, run `hledger is --yearly` and verify every column matches the filed `Výsledek hospodaření` for that year. The `Net:` row from `bse -e <year+1>-01-01 --depth 2` should match the filed bilance summary at year-end, and key reconciliation accounts (e.g. shareholder loan 365, customer deposits 311) should match Příloha v ÚZ disclosures. Mismatches mean the journal needs adjustment, not the filed PDFs.

**hledger sign quirks for Czech-trained eyes**: in `bse` output, equity (Kapital) shows the **net of capital and retained losses** — to get filing-grade vlastní kapitál, add the "Net" line (current period VH) to the Kapital total. Example: Kapital `−19 352,94` + Net `71 141,00` = vlastní kapitál `51 788,06`.

For year-end transcription into markdown rozvaha + VZZ, take the totals from `bse`/`is` output and place them in the Czech-format templates. The CorporateTaxReturn skill drives that workflow end-to-end.

## 4. Open new tax year

At `<year+1>` start:

1. Get closing balances of `<year>`:

    ```sh
    hledger -f <year>.journal balance --depth 3 --tree -e <year+1>-01-01
    ```

2. Create `<year+1>.journal` with `include accounts.journal` and a single opening transaction matching those closing balances.

3. Carry forward:
    - Aktiva (021, 022, 063, 221, 311, 378…) at MD positive
    - Pasiva (321, 341, 365, 379, 461…) at credit negative
    - Kapital (411, 421, 428…) at credit negative
    - **429** absorbs the prior-year `výsledek hospodaření` per `valná hromada` rozhodnutí (zisk → 428 nerozdělený; ztráta → 429 neuhrazená). The 431 account closes to zero.

4. Add transactions during the year as they happen.

## 5. Repo-level config (`hledger.conf`)

For a project with one canonical journal, drop a `hledger.conf` at the repo root so every `hledger` invocation finds it via auto-discovery (hledger 1.40+, walks upward from cwd). After this, no more `-f` flag on every command.

```
# hledger.conf
-f /absolute/path/to/<company>.journal
--pretty

[balance]
--tree
```

Gotchas:

- **Relative paths in `-f` resolve against cwd, not the config file location.** `-f company.journal` only works when run from repo root; from a subdirectory like `Filings/2025/` hledger looks for `Filings/2025/company.journal` and fails. Use an absolute path if subcommand invocations from any subdirectory need to work.
- **Environment variables don't expand.** `--width=$COLUMNS` errors at runtime (`unexpected '$'`). hledger.conf is not a shell — use literal values like `--width=200`.
- **General options at top, command-specific options under `[command]` headings** — `[balance]`, `[register]`, `[print]` etc.

## 6. Bilingual reports (alias overlay)

Keep the journal Czech-canonical; render English reports via an alias-overlay file. hledger aliases declared in a journal apply to subsequent postings only — they do **not** propagate across separate `-f` flags. Wrap the year journal with `include`:

```hledger
; 2025.en.journal
alias /^0\.Majetek$/                         = Assets:Investments
alias /^2\.FinMajetek:221\.001:Banka:ČS$/    = Assets:Bank:CS
alias /^3\.Vztahy:311\.001:Pohledávky:Acme$/ = Assets:Receivables:Acme
; ...one alias per declared account

include 2025.journal
```

```sh
hledger -f 2025.journal bse        # CZ canonical
hledger -f 2025.en.journal bse     # EN view of same data
```

Same numbers, two languages. The overlay file is parsed before the include, so all postings get rewritten as they're loaded. Bilance balances under either lens.

## Constraints

- Sign convention is debit-positive, credit-negative — follow consistently or hledger refuses
- Decimal separator is comma (`100000,00 CZK`) per Czech convention; declare via `D 1.000,00 CZK`
- Account names in journals MUST match `accounts.journal` declarations exactly (hledger is strict)
- Czech account codes (`code:` tag) are required for `bs`/`is` to sort in `účtová osnova` order
- The hledger journal is the source of truth for the year — markdown documents are derived; if they diverge, fix the journal first then regenerate
- For mikro UJ the chart of accounts can stay small (~14–30 accounts); resist adding accounts you won't use
- `hledger-ui` (TUI) is not on Homebrew on macOS — install via `cabal install hledger-ui` if the terminal interface is wanted; the CLI reports cover most needs

[HLED]: https://hledger.org
