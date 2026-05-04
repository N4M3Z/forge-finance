# Chart of Accounts — full reference

Common-subset Czech `účtová osnova` for podnikatele per `vyhláška 500/2002 Sb.` Příloha č. 4 (směrná účtová osnova). Lists `účty` typically needed by a mikro `s.r.o.`; full reference at [zakonyprolidi.cz/cs/2002-500][VYHL500].

## Chart by účtová třída

### Třída 0 — Dlouhodobý majetek

| Účet | Název | Type | Poznámka |
| ---- | ----- | ---- | -------- |
| 013  | Software | A | DNHM |
| 022  | Samostatné hmotné movité věci a soubory | A | DHM, > 80 K CZK + > 1 rok |
| 042  | Pořizovaný DHM | A | clearing account during acquisition |
| 062  | Podíly — podstatný vliv | A | 20–50 % share, DFM |
| 063  | Ostatní cenné papíry a podíly | A | < 20 % share, DFM |
| 081  | Oprávky ke stavbám | A (kontrární) | accumulated depreciation |
| 082  | Oprávky k 022 | A (kontrární) | accumulated depreciation |

### Třída 1 — Zásoby

| Účet | Název | Type | Poznámka |
| ---- | ----- | ---- | -------- |
| 112  | Materiál na skladě | A | inventory |
| 132  | Zboží na skladě | A | merchandise |

### Třída 2 — Krátkodobý finanční majetek a peněžní prostředky

| Účet | Název | Type | Poznámka |
| ---- | ----- | ---- | -------- |
| 211  | Pokladna | A | cash |
| 221  | Bankovní účty | A | analytika per účet |
| 231  | Krátkodobé úvěry | L | bank loans < 1 year |
| 261  | Peníze na cestě | A | clearing |

### Třída 3 — Zúčtovací vztahy

| Účet | Název | Type | Poznámka |
| ---- | ----- | ---- | -------- |
| 311  | Pohledávky z obchodních vztahů | A | trade receivables |
| 314  | Poskytnuté provozní zálohy | A | advance payments out |
| 315  | Ostatní pohledávky | A | misc receivables |
| 321  | Závazky z obchodních vztahů | L | trade payables |
| 324  | Přijaté provozní zálohy | L | advance payments in |
| 325  | Ostatní závazky | L | misc payables |
| 331  | Závazky vůči zaměstnancům — mzdy | L | net wages owed |
| 336  | Zúčtování s SP a ZP | L | social + health insurance |
| 341  | Daň z příjmů splatná | L | corporate income tax payable |
| 342  | Ostatní přímé daně | L | personal income tax withheld |
| 343  | DPH | L (or A) | VAT |
| 351  | Pohledávky — ovládaná či ovládající osoba | A | related-party receivable |
| 355  | Ostatní pohledávky za společníky | A | shareholder receivables |
| 365  | Závazek vůči společníkovi obchodní korporace | L | shareholder loan to s.r.o. |
| 378  | Jiné pohledávky | A | ad hoc receivables |
| 379  | Jiné závazky | L | ad hoc payables |

### Třída 4 — Kapitálové účty a dlouhodobé závazky

| Účet | Název | Type | Poznámka |
| ---- | ----- | ---- | -------- |
| 411  | Základní kapitál | E | share capital (`ZK`) |
| 412  | Ážio (vkladové ážio) | E | share premium |
| 413  | Ostatní kapitálové fondy | E | other capital funds |
| 421  | Zákonný rezervní fond | E | reserve (legacy) |
| 427  | Ostatní fondy | E | other funds |
| 428  | Nerozdělený zisk minulých let | E | retained earnings |
| 429  | Neuhrazená ztráta minulých let | E (debit) | accumulated losses |
| 431  | Výsledek hospodaření ve schvalovacím řízení | E | current period P/L (closes to 428/429) |
| 451  | Rezervy zákonné | L | statutory reserves |
| 461  | Bankovní úvěry dlouhodobé | L | bank loans > 1 year |

### Třída 5 — Náklady

| Účet | Název | Type | Poznámka |
| ---- | ----- | ---- | -------- |
| 501  | Spotřeba materiálu | X | materials consumed |
| 504  | Prodané zboží | X | COGS — merchandise |
| 511  | Opravy a udržování | X | repairs |
| 512  | Cestovné | X | travel |
| 513  | Náklady na reprezentaci | X | representation (typically nedaňové!) |
| 518  | Ostatní služby | X | other services (notář, právník, IT) |
| 521  | Mzdové náklady | X | gross wages |
| 524  | Zákonné sociální + zdravotní pojištění | X | employer SP + ZP |
| 543  | Dary | X | typically nedaňové unless §15(8) ZDP |
| 545  | Ostatní pokuty a penále | X | typically nedaňové |
| 548  | Ostatní provozní náklady | X | misc operating |
| 551  | Odpisy DNHM a DHM | X | depreciation |
| 559  | Tvorba opravných položek | X | impairments |
| 561  | Prodané cenné papíry | X | sold securities |
| 563  | Kurzové ztráty | X | FX losses |
| 568  | Ostatní finanční náklady | X | bank fees, finance charges |
| 591  | Daň z příjmů splatná z běžné činnosti | X | corp income tax expense |

### Třída 6 — Výnosy

| Účet | Název | Type | Poznámka |
| ---- | ----- | ---- | -------- |
| 601  | Tržby za vlastní výrobky | R | own products revenue |
| 602  | Tržby z prodeje služeb | R | services revenue |
| 604  | Tržby za zboží | R | merchandise revenue |
| 641  | Tržby z prodeje DHM | R | gain on sale of fixed assets |
| 648  | Ostatní provozní výnosy | R | misc operating |
| 661  | Tržby z prodeje cenných papírů | R | sold securities revenue |
| 662  | Úroky | R | interest income |
| 663  | Kurzové zisky | R | FX gains |
| 668  | Ostatní finanční výnosy | R | misc finance income |

### Třída 7 — Závěrkové účty

| Účet | Název | Type | Poznámka |
| ---- | ----- | ---- | -------- |
| 701  | Počáteční účet rozvažný | E (transient) | opening balance offset (year start) |
| 702  | Konečný účet rozvažný | E (transient) | closing balance offset (year end) |
| 710  | Účet zisků a ztrát | E (transient) | P/L closing target |

Třída 7 jsou závěrkové účty — používají se v `účetní uzávěrka` na konci roku (Konečný účet rozvažný) a začátku dalšího (Počáteční účet rozvažný). Pro mikro UJ ve zjednodušeném rozsahu lze nahradit přímými převody mezi 5xx/6xx → 431 a 411–429 stay continuous.

## Common operations → účet

For each typical Czech business operation, the recommended účetní zápis:

| Operace | Účet MD | Účet D | Pozn. |
| ------- | ------- | ------ | ----- |
| Vystavená faktura — služba | 311 | 602 | analytika 311.<odběratel> |
| Inkaso od odběratele | 221 | 311 | |
| Přijatá faktura — služby | 518 | 321 | analytika 321.<dodavatel>; 518.<typ> for substruktura |
| Přijatá faktura — materiál | 501 nebo 112 | 321 | 501 if straight-to-consumption; 112 if stocked |
| Úhrada faktury dodavateli | 321 | 221 | |
| Bankovní poplatek | 568 | 221 | |
| Úroky bankovní | 662 | 221 | |
| Vklad společníka — peníze | 221 | 411 nebo 365 | 411 if equity contribution; 365 if loan |
| Bezúročná zápůjčka od společníka | 221 | 365 | |
| Splátka zápůjčky společníkovi | 365 | 221 | |
| Krátkodobá zápůjčka třetí osobě | 378 | 221 | |
| Nabytí podílu < 20 % | 063 | 221 nebo 379 | 221 cash, 379 ne-uhrazené |
| Mzda hrubá | 521 | 331 | |
| SP + ZP zaměstnavatele | 524 | 336 | |
| Daň z příjmu fyz. — srážková (§ 6) | 521 | 342 | net wage to 331, daň to 342 |
| Předpis daně z příjmů PO | 591 | 341 | k 31.12. |
| Úhrada daně z příjmů PO | 341 | 221 | |
| Odpis DHM | 551 | 082 | účetní odpis (daňový jen na ř.50/52 DPPO) |
| Závěrka — převod nákladů na VH | 710 | 5xx | nebo přímo 431 / 5xx |
| Závěrka — převod výnosů na VH | 6xx | 710 | nebo 6xx / 431 |
| Otvírací stavy nového roku | 7xx | 1–4xx | balance opening |

## Rozvaha row mapping (mikro zkrácený rozsah)

Per `vyhláška 500/2002` Příloha č. 1, mikro UJ se zjednodušeným rozsahem publishes only top-level letter rows. The full mapping for any účet is below — for mikro, all sub-positions roll up to the parent letter row.

### AKTIVA (mikro zkrácený)

| Řádek mikro | Plný název | Patří sem účty |
| ----------- | ---------- | -------------- |
| **A.** | Pohledávky za upsaný základní kapitál | 353 |
| **B.** | Stálá aktiva | DHM, DNHM, DFM (013, 022, 042, 062, 063), minus oprávky 081, 082 |
| **C.** | Oběžná aktiva | zásoby (112, 132), pohledávky (311, 314, 315, 351, 355, 378), peněžní prostředky (211, 221, 261), krátkodobý finanční majetek |
| **D.** | Časové rozlišení aktiv | 381, 385 (mikro typicky neúčtuje) |

### PASIVA (mikro zkrácený)

| Řádek mikro | Plný název | Patří sem účty |
| ----------- | ---------- | -------------- |
| **A.** | Vlastní kapitál | 411, 412, 413, 421, 427, 428, 429, 431 (po závěrce: 428/429) |
| **B.+C.** | Cizí zdroje | rezervy 451, závazky 321, 324, 325, 331, 336, 341, 342, 343, 365, 379, úvěry 231, 461 |
| **D.** | Časové rozlišení pasiv | 383, 384, 389 (mikro typicky neúčtuje) |

Mikro může B (Rezervy) zobrazovat samostatně nebo agregovat s C (Závazky) — convention: `B.+C. Cizí zdroje`. Pokud rezervy = 0, zobrazte jen `C. Závazky` se stejnou hodnotou nebo `B.+C. Cizí zdroje`.

### Vlastní kapitál breakdown (volitelný detail v mikro)

Mikro UJ může uvést vlastní kapitál buď jen jako `A. Vlastní kapitál` (jeden řádek), nebo s rozpisem:

| Řádek | Patří sem |
| ----- | --------- |
| A.I.  | Základní kapitál — 411, ažio 412, fondy 413, 421, 427 |
| A.II. | Fondy ze zisku — 421, 427 |
| A.IV. | Výsledek hospodaření minulých let — 428 (zisk), 429 (ztráta) |
| A.V.  | Výsledek hospodaření běžného účetního období — 431 |

## VZZ row mapping (druhové členění)

Per `vyhláška 500/2002` Příloha č. 2 (`Výkaz zisku a ztráty — druhové členění`). Mikro UJ má dvě možnosti: `zkrácený rozsah` (jen letter + arabic level rows) nebo `plný rozsah`. Most mikro UJ stick with druhové členění (vs účelové) and use the layout below.

### Výnosy a náklady provozní

| Označení | Řádek | Patří sem účty |
| -------- | ----- | -------------- |
| **I.**   | Tržby z prodeje výrobků a služeb | 601, 602 |
| **II.**  | Tržby za prodej zboží | 604 |
| **A.**   | Výkonová spotřeba | 501 (materiál), 502, 503, 504, 511, 512, 513, 518 |
| **B.**   | Změna stavu zásob vlastní činnosti | 581, 582, 583 |
| **C.**   | Aktivace | 584, 585, 586 |
| **D.**   | Osobní náklady | 521, 522, 523, 524, 525, 526, 527, 528 |
| **E.**   | Úpravy hodnot v provozní oblasti | 551 (odpisy), 552, 553, 554, 557, 558, 559 |
| **III.** | Ostatní provozní výnosy | 641, 642, 644, 646, 648 |
| **F.**   | Ostatní provozní náklady | 541, 542, 543, 544, 545, 546, 548, 549 |
| **\***   | **Provozní výsledek hospodaření** | I + II − A − B − C − D − E + III − F |

### Výnosy a náklady finanční

| Označení | Řádek | Patří sem účty |
| -------- | ----- | -------------- |
| **IV.**  | Výnosy z dlouhodobého finančního majetku — podíly | 661, 665 (dividendy z 062/063) |
| **V.**   | Výnosy z ostatního dlouhodobého finančního majetku | 666, 667 |
| **VI.**  | Výnosové úroky a podobné výnosy | 662 |
| **G.**   | Úpravy hodnot a rezervy ve finanční oblasti | 574, 579 |
| **H.**   | Nákladové úroky a podobné náklady | 562 |
| **VII.** | Ostatní finanční výnosy | 663, 664, 668 |
| **K.**   | Ostatní finanční náklady | 561 (prodané CP), 563 (kurzové ztráty), 564, 565, 566, 568, 569 |
| **\***   | **Finanční výsledek hospodaření** | IV + V + VI − G − H + VII − K |

### VH před zdaněním a daň

| Označení | Řádek | Patří sem účty |
| -------- | ----- | -------------- |
| **\*\***  | **VH před zdaněním** | Provozní VH + Finanční VH |
| **L.**    | Daň z příjmů | 591 + 592 + 593 + 594 |
| **L.1.**  | Daň z příjmů splatná | 591 |
| **L.2.**  | Daň z příjmů odložená | 592, 593 |
| **\*\*\***| **Výsledek hospodaření za účetní období** | VH před zdaněním − L |
| **\*\***  | **Čistý obrat za účetní období** | I + II + III + IV + V + VI + VII |

## Reference

- [Vyhláška č. 500/2002 Sb.][VYHL500] — full text
- [Zákon č. 563/1991 Sb. (ZoÚ)][ZOU] — accounting law
- [Příloha č. 4 k vyhlášce 500/2002 Sb. — směrná účtová osnova][VYHL500-P4]

[VYHL500]: https://www.zakonyprolidi.cz/cs/2002-500
[ZOU]: https://www.zakonyprolidi.cz/cs/1991-563
[VYHL500-P4]: https://www.zakonyprolidi.cz/cs/2002-500/zneni-20240101#p1
