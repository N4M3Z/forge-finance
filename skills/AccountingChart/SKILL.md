---
name: AccountingChart
version: 0.1.0
description: "Czech chart of accounts (`účtová osnova`) per `vyhláška 500/2002 Sb.` plus mapping `účet` numbers to rozvaha and výkaz zisku a ztráty rows for mikro/malou/střední účetní jednotku. USE WHEN choose right account number, classify a transaction, account 311 vs 378, account 365 vs 411, map account to rozvaha row, balance sheet row mapping, income statement row mapping, chart of accounts, `účtová osnova`, `vyhláška 500/2002`, `mikro účetní jednotka`, podvojné účetnictví pro `s.r.o.`."
---

# AccountingChart

Czech `účtová osnova` for `podnikatele` (entrepreneurs) per [vyhláška č. 500/2002 Sb.][VYHL500] and `České účetní standardy` (ČÚS), plus the mapping from `účet` numbers to `rozvaha` and `výkaz zisku a ztráty` rows for `mikro`, `malou`, and `střední` účetní jednotku.

The full common-subset chart and výkaz mapping tables live in [`chart-of-accounts.md`](./chart-of-accounts.md) — load that companion when classifying a specific operation or building a `výkaz`. This file routes intent to the right answer.

## Workflow Routing

| Intent | Action | Where to look |
| ------ | ------ | ------------- |
| Choose the right `účet` for a transaction | Classify operation by druh, determine type (A/L/E/X/R), pick from chart | [`chart-of-accounts.md`](./chart-of-accounts.md) — section "Common operations → účet" |
| Look up `účet` name and type from a number (e.g. "what is 568?") | Reference table | [`chart-of-accounts.md`](./chart-of-accounts.md) — section "Chart by účtová třída" |
| Map `účet` to `rozvaha` row | Look up rozvaha-mikro mapping | [`chart-of-accounts.md`](./chart-of-accounts.md) — section "Rozvaha row mapping" |
| Map `účet` to `VZZ` row | Look up VZZ druhové mapping | [`chart-of-accounts.md`](./chart-of-accounts.md) — section "VZZ row mapping" |
| Determine `účetní jednotka` category | Compare to thresholds | See "Categorization" below |

## Background — vyhláška 500/2002

Vyhláška 500/2002 implements [zákon č. 563/1991 Sb.][ZOU] (`zákon o účetnictví`, ZoÚ) for entrepreneurs. It defines:

- **Směrná účtová osnova** — the reference framework of `účtové třídy` (0–7) and recommended `účty` (Příloha č. 4)
- **Struktura výkazů** — required rows for `rozvaha` and `výkaz zisku a ztráty` per category of UJ (Příloha č. 1, č. 2)
- **Account types** — aktivní (A), pasivní (L), kapitálový (E), nákladový (X), výnosový (R)

Každá účetní jednotka sestaví vlastní účtový rozvrh based on the směrná osnova — choose only `účty` actually used. A mikro UJ typically needs 15–30 účtů.

## Account types (sign conventions)

| Type | Czech label | Increase on | Examples |
| ---- | ----------- | ----------- | -------- |
| **A** Aktivní | Majetek | MD (debit) | 022 stroje, 221 banka, 311 pohledávky |
| **L** Pasivní | Závazky / cizí zdroje | D (credit) | 321 dodavatelé, 341 daň splatná, 461 úvěry |
| **E** Kapitálový | Vlastní kapitál | D (credit) | 411 ZK, 421 zákonný RF, 428 nerozdělený zisk |
| **X** Nákladový | Spotřeba | MD (debit) | 518 ostatní služby, 568 finanční náklady |
| **R** Výnosový | Tržby | D (credit) | 602 tržby za služby, 662 úroky |

`Účet` 429 (`Neuhrazená ztráta minulých let`) is technically Equity but carries a debit balance — losses reduce equity. In hledger sign convention store it as positive MD; report it as negative when computing vlastní kapitál.

## Categorization (kategorie účetní jednotky)

Per [§ 1b odst. 1 ZoÚ][ZOU1B]. Účetní jednotka spadá do nejnižší kategorie, jejíž žádné dva ze tří limitů nepřekročila po dvě po sobě jdoucí účetní období.

| Kategorie | Aktiva celkem | Roční úhrn obratu | Průměrný počet zaměstnanců |
| --------- | ------------: | ----------------: | -------------------------: |
| **Mikro** |    ≤ 11 mil. |          ≤ 22 mil. |                     ≤ 10 |
| Malá      |   ≤ 120 mil. |         ≤ 240 mil. |                     ≤ 50 |
| Střední   |   ≤ 500 mil. |        ≤ 1 000 mil. |                    ≤ 250 |
| Velká     |   > 500 mil. |        > 1 000 mil. |                    > 250 |

Mikro UJ may use the **zkrácený rozsah** of rozvaha + VZZ — only top-level letter rows (A, B, C, D), no roman-numeral subdivisions. Malá UJ uses letters + roman numerals. Střední/Velká uses full plný rozsah including arabic numerals.

## Common operations cheat-sheet

For full classification logic + edge cases see [`chart-of-accounts.md`](./chart-of-accounts.md). Quick lookup for the most common operations:

| Operace | Účet (MD) | Účet (D) |
| ------- | --------- | -------- |
| Vystavená faktura za služby | 311 (Pohledávka) | 602 (Tržby za služby) |
| Inkaso faktury | 221 (Banka) | 311 (Pohledávka) |
| Přijatá faktura — služby | 518 (Ostatní služby) | 321 (Závazek) |
| Úhrada faktury | 321 (Závazek) | 221 (Banka) |
| Bankovní poplatek | 568 (Finanční náklady) | 221 (Banka) |
| Mzda zaměstnance — hrubá | 521 (Mzdové náklady) | 331 (Závazek) |
| Sociální + zdravotní zaměstnance | 524 (SP/ZP) | 336 (Závazek) |
| Předpis daně z příjmů PO | 591 (Daň) | 341 (Závazek) |
| Bezúročná zápůjčka od společníka | 221 (Banka) | 365 (Závazek) |
| Krátkodobá zápůjčka jiné osobě | 378 (Pohledávka) | 221 (Banka) |
| Nabytí podílu (vklad do ZK jiné společnosti) | 063 (DFM) | 221 (Banka) |
| Závěrkový převod nákladů na 431 | 431 (VH) | 5xx (Náklad) |
| Závěrkový převod výnosů na 431 | 6xx (Výnos) | 431 (VH) |

## Constraints

- A skill in `forge-finance` is implicitly Czech — do not transliterate `účet` numbers to non-Czech systems
- Use the official `vyhláška 500/2002` row codes when generating `rozvaha`/`VZZ` for mikro UJ — do not invent intermediate sub-rows
- A mikro UJ may publish only `rozvaha` + `příloha v ÚZ` ([§ 21a odst. 9 ZoÚ][ZOU21A]); VZZ is optional for sbírka listin but still required as příloha k DPPO
- `Účtová osnova` is per company — define only the účty actually used; resist adding ones you don't need
- Mapping `účet` → `rozvaha` row depends on `splatnost` (krátkodobé vs dlouhodobé) — same účet can appear in different rows depending on whether the závazek/pohledávka splatí do 12 měsíců or později
- Distinguish `účet 311` (pohledávky z obchodních vztahů) from `účet 378` (jiné pohledávky, ad hoc) and from `účet 314/315` (poskytnuté zálohy) — IWG kauce technically belongs on 314, but inheritance from prior period may keep it on 311

[VYHL500]: https://www.zakonyprolidi.cz/cs/2002-500
[ZOU]: https://www.zakonyprolidi.cz/cs/1991-563
[ZOU1B]: https://www.zakonyprolidi.cz/cs/1991-563#p1b
[ZOU21A]: https://www.zakonyprolidi.cz/cs/1991-563#p21a
