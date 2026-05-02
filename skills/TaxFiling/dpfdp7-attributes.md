# DPFDP7 Attribute Mapping

Companion to `SKILL.md`. The XSD is cached at `docs/en-CZ/dpfdp7_epo2.xsd`.
Before adding an attribute to generated XML, verify it exists:

```sh
grep -n 'name="<attr>"' docs/en-CZ/dpfdp7_epo2.xsd
```

Tax-year-2024+ mapping (DPFDP7 schema, 7th generation). Every attribute below
was verified against the cached XSD on 2026-04-29.

## VetaP — taxpayer identification

| Attribute      | Description                                                |
|----------------|------------------------------------------------------------|
| `prijmeni`     | Surname                                                    |
| `jmeno`        | First name                                                 |
| `titul`        | Title (Mgr., Ing., …) — optional                           |
| `rod_c`        | Rodné číslo, 10 digits, no slash                           |
| `dic`          | DIČ — **1-10 digits only, no "CZ" prefix** (XSD pattern)   |
| `naz_obce`     | City                                                       |
| `ulice`        | Street name (no number)                                    |
| `c_pop`        | House number (číslo popisné)                               |
| `c_orient`     | Orientation number (číslo orientační)                      |
| `psc`          | Postal code, 5 digits                                      |
| `stat`         | Country (e.g. "ČESKÁ REPUBLIKA")                           |
| `st_prislus`   | Citizenship — 2-letter code (ES, CZ, …)                    |
| `c_telef`      | Phone                                                      |
| `email`        | Email                                                      |
| `c_pracufo`    | Územní pracoviště code (3-digit, e.g. "001"–"022" for Praha pracoviště, see financnisprava.gov.cz) |

## VetaD — header, slevy, daňové zvýhodnění, payments

**Required (XSD `use="required"`):** `dokument="DP7"`, `k_uladis="DPF"`, `dap_typ`, `rok`, `pln_moc`, `audit`, `c_ufo_cil`.

| Attribute         | Row(s)  | Description                                                  |
|-------------------|---------|--------------------------------------------------------------|
| `dokument`        | —       | Fixed `DP7`                                                  |
| `k_uladis`        | —       | Fixed `DPF`                                                  |
| `dap_typ`         | 03      | `B` řádné / `O` opravné / `D` dodatečné / `E` opravné dodatečné |
| `rok`             | header  | Tax year                                                     |
| `zdobd_od`        | header  | Period start (DD.MM.YYYY)                                    |
| `zdobd_do`        | header  | Period end                                                   |
| `c_ufo_cil`       | header  | FÚ code (e.g. 451 = hl. m. Praha)                            |
| `pln_moc`         | 05      | `A`/`N` — daňový poradce based on plná moc                   |
| `audit`           | 05a     | `A`/`N` — povinnost auditu                                   |
| `d_zjist`         | header  | Discovery date — required for `dap_typ` `O`/`D`/`E`          |
| `kc_pausal`       | 86      | Zálohy zaplacené v paušálním režimu                          |
| `kc_zalzavc`      | 84      | §6 employer-withheld advances                                |
| `kc_zalpred`      | 85      | Taxpayer's own advance payments (zálohy 2024 → 2025)         |
| `kc_konkurs`      | 90      | Tax already paid (§38gb)                                     |
| `kc_zbyvpred`     | 91      | Remaining to pay (+) / overpayment (-)                       |
| `m_manz`          | 65a tab | Months for sleva na manželku                                 |
| `manz_jmeno`      | tab 1   | Spouse first name                                            |
| `manz_prijmeni`   | tab 1   | Spouse surname                                               |
| `manz_titul`      | tab 1   | Spouse title                                                 |
| `manz_r_cislo`    | tab 1   | Spouse rodné číslo                                           |
| `manz_d_nar`      | tab 1   | Spouse birth date                                            |
| `m_vyzmanzl`      | 65a     | Months claimed for spouse credit                             |
| `m_invduch`       | 66      | Invalidity months (1st/2nd grade)                            |
| `m_ztpp`          | 68      | Months for ZTP/P holder credit                               |
| `m_deti`          | 72 tab  | Months claimed for **1st child**                             |
| `m_deti2`         | 72 tab  | Months claimed for **2nd child**                             |
| `m_deti3`         | 72 tab  | Months claimed for **3rd+ child**                            |
| `m_detiztpp`      | 72 tab  | Months claimed for ZTP/P 1st child                           |
| `m_detiztpp2`     | 72 tab  | Months claimed for ZTP/P 2nd child                           |
| `m_detiztpp3`     | 72 tab  | Months claimed for ZTP/P 3rd+ child                          |
| `da_slevy`        | 62      | Slevy podle § 35 odst. 1 (R&D, ZTP/P zaměstnanec, …) — **NOT** sleva na poplatníka |
| `kc_sleva_exe`    | 62a     | Sleva za zastavenou exekuci                                  |
| `sleva_rp`        | 64      | **Základní sleva na poplatníka § 35ba(1)(a)** — 30 840 CZK   |
| `da_slevy35ba`    | 65a     | Sleva na manželku/manžela § 35ba(1)(b) (24 840 CZK)          |
| `kc_manztpp`      | 65b     | Sleva na ZTP/P manžela                                       |
| `uhrn_slevy35ba`  | 70      | Úhrn slev (62 + 62a + 63 + 64 + 65a + 65b + 66 + 67 + 68)    |
| `da_slezap`       | 71      | Daň po slevách § 35ba (decimal, 2 fraction digits)           |
| `kc_dazvyhod`     | 72      | Daňové zvýhodnění na děti § 35c                              |
| `kc_slevy35c`     | 73      | Sleva uplatněná z daňového zvýhodnění                        |
| `kc_dan_po_db`    | 74      | Daň po uplatnění § 35c                                       |
| `da_samzakl`      | 74a     | Daň ze samostatného základu daně § 16a                       |
| `kc_dan_celk`     | 75      | Daň celkem (74 + 74a)                                        |
| `kc_vyplbonus`    | 76 / 89 | Daňový bonus / vyplacený bonus                               |
| `kc_db_po_odpd`   | 77      | Daň celkem po úpravě o bonus                                 |
| `kc_danbonus`     | 77a     | Daňový bonus po odpočtu daně                                 |
| `kc_pzdp`         | 78      | Poslední známá daň (jen `D`/`E`)                             |
| `kc_zjidp`        | 79      | Zjištěná daň podle § 141                                     |
| `kc_rozdil_dp`    | 80      | Rozdíl 79 − 78                                               |
| `kc_pzzt`         | 81      | Poslední známá ztráta                                        |
| `kc_zjizt`        | 82      | Zjištěná ztráta                                              |
| `kc_rozdil_zt`    | 83      | Rozdíl 82 − 81                                               |
| `kc_dztrata`      | 61      | Daňová ztráta zaokrouhlená nahoru                            |
| `kc_sraz_rezehp`  | 87      | Sražená daň § 36 odst. 6                                     |
| `kc_sraz_6_4`     | 87a     | Sražená daň § 36 odst. 7                                     |
| `kc_sraz385`      | 88      | Zajištěná daň § 38e                                          |

## VetaO — partial tax bases by category

| Attribute      | Row | Description                                  |
|----------------|-----|----------------------------------------------|
| `kc_prij6`     | 31  | Total employment income from all employers   |
| `kc_prij6zahr` | 35  | §6 income from foreign sources               |
| `kc_dan_zah`   | 33  | Tax paid abroad on §6 income (§ 6 odst. 13)  |
| `kc_zd6p`      | 34  | §6 partial tax base (computed)               |
| `kc_zd6`       | 36  | §6 partial tax base (transfer from row 34)   |
| `kc_zd7`       | 37  | §7 partial tax base (from VetaT row 113)     |
| `kc_zakldan8`  | 38  | §8 capital income partial base               |
| `kc_zd9`       | 39  | §9 rental partial base (from VetaV row 206)  |
| `kc_zd10`      | 40  | §10 other income partial base                |
| `kc_uhrn`      | 41  | Sum of §7 + §8 + §9 + §10 (excludes §6)      |
| `kc_zakldan23` | 42  | §6 + positive(row 41)                        |
| `kc_ztrata2`   | 44  | Loss carryforward applied                    |
| `kc_zakldan`   | 45  | Row 42 minus row 44                          |
| `celk_sl4`     | tab | Aggregate Tab. 2 (children) sum col 4        |
| `celk_sl5`     | tab | Aggregate Tab. 2 (children) sum col 5        |

## VetaS — deductions, rounded base, tax

| Attribute        | Row     | Description                                                 |
|------------------|---------|-------------------------------------------------------------|
| `kc_op15_1a`     | 46      | Donations § 15(1) general                                   |
| `kc_op15_1c`     | 46      | Blood donation                                              |
| `kc_op15_1d`     | 46      | Organ donation                                              |
| `kc_op15_1e1`    | 46      | Other § 15(1) line item                                     |
| `kc_op15_1e2`    | 46      | Other § 15(1) line item                                     |
| `kc_op15_8`      | 47      | Mortgage interest § 15(3-4)                                 |
| `m_uroky`        | 47      | Months claimed for mortgage interest                        |
| `kc_op15_12`     | 48      | Penzijní připojištění § 15a(1)(a-c)                         |
| `kc_op15_13`     | 49      | Soukromé životní pojištění § 15a(1)(d)                      |
| `kc_op15_inpr`   | 50      | LTIP (`DIP`) § 15a(1)(e)                                    |
| `kc_op15_pece`   | 51      | Pojištění dlouhodobé péče § 15c                             |
| `kc_op34_4`      | 52      | Výzkum a vývoj § 34(4)                                      |
| `kc_podvzdel`    | 53      | Odpočet na podporu odborného vzdělávání                     |
| `kc_op28_5`      | tab     | Aggregate row § 28(5)                                       |
| `kc_odcelk`      | 54      | Total deductions (sum of 46–53)                             |
| `kc_zdsniz`      | 55      | Tax base after deductions (45 − 54, ≥ 0)                    |
| `kc_zdzaokr`     | 56      | Base rounded to whole hundreds CZK down                     |
| `da_dan16`       | 57      | Tax under § 16 — 15 % to 36× průměrná mzda, 23 % above (decimal, 2 fraction digits) |

## VetaA — dependent children (one element per child)

Each `<VetaA …/>` describes one child. Use `vyzdite_pocmes` for **1st** child placement, `vyzdite_pocmes2` for 2nd, `vyzdite_pocmes3` for 3rd+.

| Attribute            | Description                                              |
|----------------------|----------------------------------------------------------|
| `vyzdite_prijmeni`   | Surname                                                  |
| `vyzdite_jmeno`      | First name                                               |
| `vyzdite_r_cislo`    | Rodné číslo, 10 digits                                   |
| `vyzdite_d_nar`      | Birth date (DD.MM.YYYY)                                  |
| `vyzdite_pocmes`     | Months as **1st child** (no ZTP/P)                       |
| `vyzdite_pocmes2`    | Months as **2nd child**                                  |
| `vyzdite_pocmes3`    | Months as **3rd+ child**                                 |
| `vyzdite_ztpp`       | Months as 1st child (ZTP/P)                              |
| `vyzdite_ztpp2`      | Months as 2nd child (ZTP/P)                              |
| `vyzdite_ztpp3`      | Months as 3rd+ child (ZTP/P)                             |

## VetaB — attachment declarations (booleans/counts)

Set the count for each attached document. Element must come **before** VetaT in document order.

| Attribute        | Description                                              |
|------------------|----------------------------------------------------------|
| `priloha1`       | Pages of Příloha 1 attached (e.g. `2`)                   |
| `priloha2`       | Pages of Příloha 2 attached                              |
| `pril3_samlist`  | Pages of Příloha 3 + Samostatné listy                    |
| `priloha4`       | Pages of Příloha 4                                       |
| `potv_zam`       | Pages of `Potvrzení o zdanitelných příjmech` (§6)        |
| `potv_uver`      | Pages of mortgage interest potvrzení                     |
| `potv_penpri`    | Pages of pension contributions potvrzení                 |
| `potv_zivpoj`    | Pages of life insurance potvrzení                        |
| `potv_inpr`      | Pages of LTIP daňové potvrzení                           |
| `potv_pece`      | Pages of long-term care insurance potvrzení              |
| `potv_dazvyh`    | Pages of `Potvrzení druhého z poplatníků`                |
| `doklad_dar`     | Pages of donation receipts                               |
| `potv_36`        | Pages of § 36 income/withholding statements              |
| `potv_zahrsd`    | Pages of foreign authority income/tax statement          |
| `usn_exe`        | Pages of usnesení o zastavení exekuce                    |
| `vklad_ku`       | Pages of vyrozumění o vkladu do KN (§10)                 |
| `seznam`         | Pages of § 38f(10) seznam                                |
| `pril_poduv`     | Pages of § 34(1) loss-deduction příloha                  |
| `pril_loto`      | Pages of § 10(1)(h) bod 1 příloha                        |
| `pril_ztraty`    | Pages of ztráty příloha                                  |
| `duvody_dodap`   | Pages explaining reasons for `D`/`E` filing              |
| `dal_prilohy`    | Pages of "další přílohy"                                 |
| `priloh_celk`    | **Total pages across all přílohy** — must equal sum      |

## VetaT — Příloha 1 (§7 self-employment)

**Required if §7 income exists.** Must come **after** VetaB in document order.

| Attribute         | Row | Description                                              |
|-------------------|-----|----------------------------------------------------------|
| `kc_prij7`        | 101 | Příjmy podle § 7                                         |
| `kc_vyd7`         | 102 | Výdaje                                                   |
| `kc_hosp_rozd`    | 104 | Rozdíl 101 − 102                                         |
| `kc_uhzvys`       | 105 | Úpravy podle § 5, § 23 — zvyšující                       |
| `kc_uhsniz`       | 106 | Úpravy podle § 5, § 23 — snižující                       |
| `kc_pod_so`       | 107 | Část rozdělená na spolupracující osobu (zisk)            |
| `kc_pod_vaso`     | 108 | Část rozdělená na spolupracující osobu (ztráta)          |
| `kc_vyd_so`       | 109 | Část připadající na poplatníka jako spolupracující (zisk)|
| `kc_vyd_vaso`     | 110 | Část připadající na poplatníka jako spolupracující (ztráta)|
| `kc_pod_komp`     | 112 | Podíl jako společník v.o.s. / komplementář k.s.          |
| `kc_zd7p`         | 113 | Dílčí základ daně z § 7                                  |
| `vyd7proc`        | A   | `A`/`N` — uplatňuji výdaje procentem z příjmů            |
| `uc_soust`        | A   | `D`/`U`/`P` — daňová evidence / účetnictví / paušál      |
| `kc_cisobr`       | A   | Roční úhrn čistého obratu (jen účetnictví)               |
| `kc_odpcelk`      | A   | Uplatněné odpisy celkem                                  |
| `kc_odpnem`       | A   | Z toho odpisy nemovitých věcí                            |
| `pr_prij7`        | B   | Příjmy hlavní činnost                                    |
| `pr_vyd7`         | B   | Výdaje hlavní činnost                                    |
| `pr_sazba`        | B   | Sazba % (paušál)                                         |
| `c_nace`          | B   | CZ-NACE main (e.g. 620900 = ostatní IT)                  |
| `prijmy7`         | B   | Příjmy další činnost                                     |
| `vydaje7`         | B   | Výdaje další činnost                                     |
| `sazba_dal`       | B   | Sazba % další činnost                                    |
| `c_nace_dal`      | B   | CZ-NACE další                                            |
| `celk_pr_prij7`   | B   | Celkem příjmy                                            |
| `celk_pr_vyd7`    | B   | Celkem výdaje                                            |
| `d_zahcin`        | C   | Datum zahájení činnosti                                  |
| `d_precin`        | C   | Datum přerušení                                          |
| `d_ukoncin`       | C   | Datum ukončení                                           |
| `d_obnocin`       | C   | Datum obnovení                                           |
| `m_podnik`        | C   | Počet měsíců činnosti                                    |

VetaC, VetaE — § 5/§23 úpravy detailed lines (one element per line).
VetaF — společníci společnosti.
VetaG — spolupracující osoba (rozděluji).
VetaH — osoba, která rozděluje na poplatníka.
VetaI — v.o.s./k.s. údaje.

## Other Veta elements (cross-reference XSD before use)

| Element | Purpose                                                      |
|---------|--------------------------------------------------------------|
| VetaU   | § 16a separate-base computation detail                       |
| VetaV   | Příloha 2 — § 9 (rental) and § 10 (other) detail            |
| VetaJ   | § 10 individual income items (one per item)                  |
| VetaW   | Příloha 3 — foreign income / tax credit                      |
| VetaR   | Samostatné listy headers                                     |
| VetaL   | Samostatné listy data rows                                   |
| VetaM   | Loss-carryforward worksheet                                  |
| VetaN   | Bank account for refund (`zp_vrac`, `c_nest_uctu`, `id_banky`, …) |
| VetaX/Y | Mortgage interest detail                                     |
| VetaZ   | Příloha 4 — § 16a samostatný základ                          |
| VetaT1/T2/T3 | File attachments (base64)                              |

**Important:** omit optional attributes that have no value rather than setting them
to `"0"`. EPO rejects zero where empty is expected (notably `kc_dazvyhod` row 72,
`kc_vyplbonus` row 76, and most bonus/credit rows).
