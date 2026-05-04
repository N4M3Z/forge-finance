# DPPDP9 XML attribute reference

Schema reference for Czech `DPPO` filing XML. Verified against MOJE daně portal validation, May 2026 (DPPDP9 `verzePis="05.01"`, EPO software 48.x).

Always check the current schema generation on [adisspr.mfcr.cz DPPDP9][dppdp9] before generating — MF publishes new versions periodically.

`verzePis` uses **MAJOR.MINOR only** (e.g. `05.01`) — do not include patch version (`05.01.01` is non-standard and may produce upload warnings).

## VetaD — Header + filing meta

| Attribute               | Purpose                            | Typical value                              |
| ----------------------- | ---------------------------------- | ------------------------------------------ |
| `c_nace`                | NACE main activity code            | e.g., `620000`                             |
| `typ_dapdpp`            | Filing type                        | `A`                                        |
| `uv_rozsah`             | Účetní výkaz rozsah                | `P` (plný) or `M` (mikro)                  |
| `uc_zav`                | Závěrka attached                   | `A` (yes)                                  |
| `kat_uj`                | Účetní jednotka kategorie          | `M`/`S`/`T`/`V`                            |
| `dapdpp_forma`          | Filing form                        | `B`/`O`/`D`/`E` (see below)                |
| `dap_typ`               | Same as `dapdpp_forma` in some XSDs| `B`                                        |
| `dan_por`               | Filed via daňový poradce           | `N` or `A`                                 |
| `audit`                 | Audit obligation                   | `N` for sub-threshold                      |
| `c_ufo_cil`             | FÚ kraj kód                        | `452` Středočeský, `451` Praha             |
| `zdobd_od` / `zdobd_do` | Period start/end                   | `01.01.YYYY` / `31.12.YYYY`                |
| `d_uv`                  | Date of účetní závěrka             | `31.12.YYYY`                               |
| `dokument`              | Fixed                              | `DP9`                                      |
| `k_uladis`              | Fixed                              | `DPP`                                      |
| `uv_vyhl`               | Vyhláška                           | `500` (vyhláška 500/2002)                  |
| `spoj_zahr`             | Spojené osoby zahraničí            | `N` or `A`                                 |
| `uv_rozsah_rozv`        | Rozvaha rozsah                     | `M` (mikro) or `P`                         |
| `uv_rozsah_vzz`         | VZZ rozsah                         | `M` or `P` (see note)                      |
| `uz_rad`                | Účetní závěrka řádná               | `T` (true)                                 |
| `uv_mena`               | Currency                           | `CZK`                                      |
| `kc_v_4`                | V. oddíl ř.4 nedoplatek/přeplatek  | signed integer (negative = poplatník dluží)|

`dapdpp_forma` values: `B` řádné, `O` opravné (před lhůtou), `D` dodatečné (po lhůtě), `E` opravné dodatečné. For `O`/`D`/`E` set `d_zjist` (datum zjištění) on VetaD.

`uv_rozsah_vzz` — use `P` when VetaUB rows are druhové členění (rows 1–55). Even mikro UJ may voluntarily file VZZ in plný rozsah; the flag describes the OUTPUT format chosen, not the kategorizace of the unit.

`kc_v_4` is **required**. For typical filing where there is a tax liability, `kc_v_4 = -kc_ii_340` (e.g., `-18690` for daň 18 690 CZK). Negative = poplatník dluží, positive = přeplatek to refund.

## VetaP — Taxpayer

| Attribute                                       | Purpose                          |
| ----------------------------------------------- | -------------------------------- |
| `dic`                                           | Daňové ID (8 digits)             |
| `zkrobchjm`                                     | Obchodní jméno                   |
| `psc` / `naz_obce` / `ulice` / `c_pop`          | Sídlo address                    |
| `c_pracufo`                                     | Územní pracoviště kód            |
| `opr_jmeno` / `opr_prijmeni` / `opr_postaveni`  | Statutární zástupce              |

`c_pracufo` codes (Středočeský kraj examples):

| Kód    | ÚP                                                                |
| ------ | ----------------------------------------------------------------- |
| `2101` | Praha-východ (Thámova 27, Praha 8 — covers Úvaly etc.)            |
| `2104` | Brandýs nad Labem-Stará Boleslav                                  |
| `2121` | Rakovník                                                          |

## VetaO — II. oddíl daň z příjmů

**Critical gotcha**: attribute names like `kc_ii<from>_<to>` represent the calculation transition between rows; they don't always equal one specific row.

| Attribute      | Maps to form řádek                                 | Notes                                  |
| -------------- | -------------------------------------------------- | -------------------------------------- |
| `kc_ii10_10`   | ř.10 VH před zdaněním                              | účetní VH (zisk +, ztráta −)           |
| `kc_ii200_200` | ř.200 Základ daně před úpravou                     | ř.10 + ř.70 − ř.170                    |
| `kc_ii_220`    | ř.220 Daňový základ po úpravě                      | po vyňatých zahr. příjmech             |
| `kc_ii230_250` | ř.250 Základ daně po odečtech                      | po §34 ztrátě                          |
| `kc_ii260_270` | ř.270 Daňový základ zaokr. dolů na celé tisíce     | použito pro výpočet daně               |
| `kc_ii270_280` | ř.280 SAZBA DANĚ (v %)                             | **= 21**, NE základ! Max 2 číslice     |
| `kc_ii280_290` | ř.290 Daň                                          | = ř.270 × ř.280 / 100                  |
| `kc_ii_331`    | ř.331 Samostatný základ daně §20b                  | obvykle 0                              |
| `kc_ii_332`    | ř.332 Sazba pro samostatný základ                  | **= 15** (fixed)                       |
| `kc_ii_333`    | ř.333 Daň ze samostatného základu                  | obvykle 0                              |
| `kc_ii_335`    | ř.335 Daň ze samostatného základu po snížení       | obvykle 0                              |
| `kc_ii300_310` | ř.310 Daň po slevách                               |                                        |
| `kc_ii320_330` | ř.330 Daň po snížení a zápočtech                   |                                        |
| `kc_ii_340`    | ř.340 Celková daň                                  | = ř.330 + ř.335                        |
| `kc_ii_360`    | ř.360 Poslední známá daň                           | base pro zálohy příštího roku          |
| `d_hospvysl`   | Datum vyhotovení výkazu zisku/ztráty               | `31.12.YYYY`                           |

**Samostatný základ daně quadruplet** (`kc_ii_331` / `kc_ii_332` / `kc_ii_333` / `kc_ii_335`) stays together as a complete unit. Even when the row is unused (typical for small `s.r.o.` without §20b operations), keep all four attributes with `0` values — including `kc_ii_332="15"` for the rate. Omitting individual zero attributes from a complete row may cause portal validation issues; the rate persists as a structural attribute regardless of base/tax being zero.

## VetaS — Doplňkové údaje

| Attribute      | Purpose                                  | Typical value         |
| -------------- | ---------------------------------------- | --------------------- |
| `poc_zam`      | Počet zaměstnanců                        | obvykle `0`           |
| `kc_dpp_i1`    | Roční úhrn čistého obratu (v tis. CZK)   | round to nearest      |
| `cisobr_mena`  | Měna                                     | `CZK`                 |

## VetaUA — Vybrané údaje z rozvahy AKTIVA

`kc_brutto`, `kc_netto`, `kc_netto_min` — current period brutto/netto and minulé období netto. **All values in tisíc CZK, integer rounding per row.**

For mikro zkrácený rozsah, ALLOWED rows (per portal validation 2025):

| c_radku | Položka            |
| ------- | ------------------ |
| `1`     | AKTIVA CELKEM      |
| `3`     | B. Stálá aktiva    |
| `37`    | C. Oběžná aktiva   |

Higher detail rows (6, 46, 71, 73, etc.) are PLNÝ rozsah only and **fail mikro validation** with error 2743.

For plný rozsah, additional valid rows include:

- `6` B.III. Dlouhodobý finanční majetek
- `46` C.II. Pohledávky
- `71` C.IV. Peněžní prostředky
- `73` C.IV.2 Bank accounts

## VetaUB — Vybrané údaje z VZZ

`kc_sled` (current period) and `kc_min` (minulé období). Values in tisíc CZK.

For VZZ druhové členění (most common), valid rows include:

| c_radku | Položka                                                       |
| ------- | ------------------------------------------------------------- |
| `1`     | I. Tržby z prodeje výrobků a služeb                           |
| `3`     | A. Výkonová spotřeba                                          |
| `6`     | A.3 Služby                                                    |
| `30`    | * Provozní výsledek hospodaření                               |
| `47`    | K. Ostatní finanční náklady                                   |
| `48`    | * Finanční výsledek hospodaření                               |
| `49`    | ** Výsledek hospodaření před zdaněním                         |
| `50`    | L. Daň z příjmů                                               |
| `51`    | L.1 Daň z příjmů splatná                                      |
| `53`    | ** Výsledek hospodaření po zdanění                            |
| `55`    | *** Výsledek hospodaření za účetní období                     |

Row `61` (Čistý obrat za účetní období) **fails validation** for VZZ druhové členění with error 2631 — DO NOT include.

## VetaUD — Vybrané údaje z rozvahy PASIVA

`kc_sled` and `kc_min`. Mikro zkrácený číselník uses **renumbered rows** (NOT plný rozvaha pasiva ř.78–120 — those fail with error 2743).

Working mikro pasiva rows (tested through May 2026):

| c_radku | Položka                                       |
| ------- | --------------------------------------------- |
| `1`     | PASIVA CELKEM                                 |
| `2`     | A. Vlastní kapitál                            |
| `24`    | B.+C. Cizí zdroje                             |
| `30`    | C. Závazky (= row 24 if Rezervy = 0)          |

**Validation rule (error 2414)**: `kc_sled` of B.+C. row (24) must equal sum of B. (Rezervy) + C. (Závazky). For typical s.r.o. with no Rezervy, set both row 24 and row 30 to the same total.

## VetaUZ — Žádost o předání závěrky do sbírky listin

Single-occurrence element with `pr11_*` boolean attributes:

| Attribute     | Purpose                                            | Typical value            |
| ------------- | -------------------------------------------------- | ------------------------ |
| `pr11_rozv`   | Rozvaha attached                                   | `A`                      |
| `pr11_vzz`    | Výkaz zisku a ztráty                               | `N` for mikro            |
| `pr11_puz`    | Příloha v účetní závěrce                           | `A`                      |
| `pr11_pzvk`   | Přehled o změnách vlastního kapitálu               | `N` for mikro            |
| `pr11_ppt`    | Přehled o peněžních tocích                         | `N` for mikro            |
| `pr11_uzmus`  | Závěrka dle MUS                                    | `N`                      |
| `pr11_email`  | Notification email                                 | `<your email>`           |

`pr11_vzz="N"` for mikro per `§ 21a odst. 9 ZoÚ` — VZZ may be omitted from sbírka listin publication.

After submission FÚ forwards závěrka PDF to sbírka listin automatically.

## Common XML errors and fixes

| Error code | Symptom                                                    | Fix                                                                              |
| ---------- | ---------------------------------------------------------- | -------------------------------------------------------------------------------- |
| `2602`     | "Není vložena příloha účetní závěrky"                      | Embed příloha PDF in `<Prilohy>` block (preferred) or attach in MOJE daně UI     |
| `2631`     | Row "X" not valid for VZZ                                  | Drop the row (e.g., 61 for druhové členění)                                      |
| `2743`     | Row "X" nespadá do zkráceného rozsahu pro mikro            | Move to mikro číselník row, drop excess detail rows                              |
| `2799`     | Žádost požaduje přílohu která není přiložena               | Embed příloha PDF in `<Prilohy>` block; rozvaha doesn't need PDF (auto-rendered) |
| `2414`     | B.+C. row != sum of B. + C.                                | Match VetaUD row 24 with row 30 (when Rezervy = 0)                               |
| —          | "Překročen max počet číslic" on `kc_ii270_280`             | Set to `21` (sazba), put base in `kc_ii260_270`                                  |
| —          | Form V. oddíl ř.4 empty after import                       | Add `kc_v_4` to VetaD with signed nedoplatek/přeplatek value                     |

For `<Prilohy>` block syntax, see companion file [`epo-attachments.md`](./epo-attachments.md).

[dppdp9]: https://adisspr.mfcr.cz/dpr/adis/idpr_pub/epo2_info/popis_struktury_detail.faces?zkratka=DPPDP9
