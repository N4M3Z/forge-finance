Czech corporate income tax (`DPPO`, `daň z příjmů právnických osob`) under [zákon 586/1992 Sb.][zdp]. Rate is 21 % from 2024 ([§21][zdp21]). Schema for tax years 2024+ is **DPPDP9** ([adisspr.mfcr.cz][dppdp9]) — verify the current generation on the day of filing.

Related rules: ReceivableWriteoffs (when writeoffs are tax-deductible vs not), ShareholderLoans (interest-free loans from members to s.r.o.), AuditSignalDisclosure + CzechTaxAuditMarkers (audit-safe filing default per TAX-0003).

## Filing mandatoriness

Every právnická osoba (including dormant `s.r.o.`) must file `DPPO` regardless of activity or tax base ([§38m][zdp38m]). The §38mc exemption is reserved for veřejně prospěšní poplatníci a `SVJ` — a standard `s.r.o.` cannot opt out, even with zero income.

## Deadlines

| Deadline | Path | Source |
| -------- | ---- | ------ |
| 1 April (year+1) | paper / non-DS electronic | [§136(1) DŘ][dr136] |
| 1 May (year+1) | electronic via datová schránka | [§136(2)(a) DŘ][dr136] |
| 1 July (year+1) | with `daňový poradce` / audit | [§136(2)(b) DŘ][dr136] |

`s.r.o.` typically holds a datová schránka — the 1 May path applies by default. Weekend/holiday shifts to next business day.

## Účetní závěrka attached as příloha

`Účetní závěrka` is a mandatory příloha to `DPPO` ([§72(2) daňového řádu][dr72], [pokyny DPPDP9][pok]). Ticking **Žádost o předání účetní závěrky do sbírky listin** inside the form discharges [§66 zákona 304/2013][r304-66] publication duty in the same submission ([Finanční správa][fs]). Use this path — single submission, no separate justice.cz upload.

## Účetní jednotka kategorizace

Per [§1b zákona 563/1991 Sb.][zou1b]. Limits expressed in CZK — 2 of 3 must be exceeded for two consecutive years to upgrade category.

| Kategorie | Aktiva celkem | Roční úhrn obratu | Průměrný počet zaměstnanců |
| --------- | ------------- | ----------------- | -------------------------- |
| Mikro     | ≤ 11 mil.     | ≤ 22 mil.         | ≤ 10                       |
| Malá      | ≤ 120 mil.    | ≤ 240 mil.        | ≤ 50                       |
| Střední   | ≤ 500 mil.    | ≤ 1 000 mil.      | ≤ 250                      |
| Velká     | > 500 mil.    | > 1 000 mil.      | > 250                      |

Audit obligation: 2 of 3 thresholds met for two consecutive years ([§20][zou20]). Mikro a malé without audit obligation may publish only `rozvaha` + `příloha` ([§21a][zou21a]).

## Zálohy na daň (`§38a` ZDP)

Per [§38a odst. 1 ZDP][zdp38a]: zálohy se neplatí, pokud `poslední známá daňová povinnost` ≤ 30 000 CZK.

| Poslední známá daň | Zálohy v dalším období | Splatnost |
| ------------------ | ---------------------- | --------- |
| ≤ 30 000 CZK | **žádné** | — |
| 30 000 – 150 000 CZK | 2× 40 % poslední daně | 15. 6. + 15. 12. |
| > 150 000 CZK | 4× 25 % poslední daně | čtvrtletně |

`Poslední známá daň` = ř.360 DPPDP9. Pro většinu mikro `s.r.o.` s obratem pod 100 K CZK ročně daň zůstává pod prahem 30K → žádné zálohy ani v dalších letech.

Pokud nastane mimořádný rok s daní > 30K (jako u CYBERTEC 2025), zálohy začínají od dalšího období. Při návratu k dormantní činnosti (daň zase pod 30K) lze požádat o snížení/zrušení záloh per [§174 daňového řádu][dr174] (`žádost o stanovení záloh jinak`).

## Strategie pro daňovou ztrátu (`§34` + `§38r` ZDP)

Daňovou ztrátu lze odečíst od základu daně v 5 následujících obdobích ([§34 odst. 1 ZDP][zdp34]).

**Past §38r odst. 2**: Existence daňové ztráty automaticky **prodlužuje prekluzivní lhůtu** pro stanovení daně za období vzniku ztráty na celé carryforward okno (5 let). Tj. ztráta z roku 2020 → prekluze pro 2020 trvá do 2029 (místo standardních 3 let).

**Vzdání se práva** ([§38r odst. 4 ZDP][zdp38r]): Při podání řádného nebo dodatečného přiznání lze podat `oznámení o vzdání se práva uplatnit daňovou ztrátu` v následujících obdobích. Pokud takto poplatník učiní, prekluze §38r se NEPRODLOUŽÍ — vrátí se ke standardní 3leté lhůtě.

**Praktická logika** (audit-safe practitioner standard mezi českými daňovými poradci):

> Při nevýznamných ztrátách je běžným postupem ztrátu nepoužít a tím chránit prekluzivní lhůtu. Doporučuje se podat XML datovou schránkou — vzdání se práva na uplatnění daňové ztráty v 5 následujících obdobích.

Pro malé `s.r.o.` se sporadickou činností:

- **Ztráta vznikla, je marginální** → podat `oznámení o vzdání se práva` při podání DPPO. Prekluze pro období vzniku zůstává standardní 3 roky.
- **Pozitivní VH s dostupnou starou ztrátou** → zvážit, zda uplatnit. Uplatnění starší ztráty na ř.230 je marker pro FÚ → potenciální review originálního stanovení ztráty. **Neuplatnění** = nudné přiznání bez markerů, vyšší daň, ale klid od FÚ.
- **2020 ztráta** propadá po 2025 (5-letý limit). Pokud nebyla využita, je ztracena.

Trade-off: zaplatit ~21 % z `daňový základ` výměnou za "smooth sailing" filing bez audit triggers.

## Penalties

| Penalty | Calculation | Source |
| ------- | ----------- | ------ |
| Late `DPPO` filing (`pokuta`) | 0.05 %/day after 5-day grace, min 500, max 5 % / 300 000 CZK | [§250 DŘ][dr250] |
| Late payment (`úrok z prodlení`) | repo rate + 8pp daily, forgiven under 1 000 CZK | [§252 DŘ][dr252] |
| Audit penalty (`penále`) | 20 % of additionally assessed tax (authority-initiated only) | [§251 DŘ][dr251] |
| Late sbírka listin filing | up to 100 000 CZK | [§104 zákona 304/2013][r304-104] |
| 2× consecutive missed závěrky | dissolution-without-liquidation risk | [§105a zákona 304/2013][r304-105a] |

Two missed závěrky filings is a corporate death penalty, not a fine. Keep yearly cadence and prefer self-correction via `dodatečné podání` to avoid the §251 audit penalty.

[zdp]: https://www.zakonyprolidi.cz/cs/1992-586
[zdp21]: https://www.zakonyprolidi.cz/cs/1992-586#p21
[zdp38m]: https://www.zakonyprolidi.cz/cs/1992-586#p38m
[dr136]: https://www.zakonyprolidi.cz/cs/2009-280#p136
[dr72]: https://www.zakonyprolidi.cz/cs/2009-280#p72
[dr250]: https://www.zakonyprolidi.cz/cs/2009-280#p250
[dr252]: https://www.zakonyprolidi.cz/cs/2009-280#p252
[dr251]: https://www.zakonyprolidi.cz/cs/2009-280#p251
[zou1b]: https://www.zakonyprolidi.cz/cs/1991-563#p1b
[zou20]: https://www.zakonyprolidi.cz/cs/1991-563#p20
[zou21a]: https://www.zakonyprolidi.cz/cs/1991-563#p21a
[r304-66]: https://www.zakonyprolidi.cz/cs/2013-304#p66
[r304-104]: https://www.zakonyprolidi.cz/cs/2013-304#p104
[r304-105a]: https://www.zakonyprolidi.cz/cs/2013-304#p105a
[fs]: https://financnisprava.gov.cz/cs/dane/dane/dan-z-prijmu/dotazy-a-odpovedi/dan-z-prijmu-pravnickych-osob/vybrane-dotazy-k-predavani-ucetni
[pok]: https://adisspr.mfcr.cz/dpr/adis/idpr_pub/dpp/dp9/doc/pokyny_dap_2024.pdf
[dppdp9]: https://adisspr.mfcr.cz/dpr/adis/idpr_pub/epo2_info/popis_struktury_detail.faces?zkratka=DPPDP9
[zdp34]: https://www.zakonyprolidi.cz/cs/1992-586#p34
[zdp38a]: https://www.zakonyprolidi.cz/cs/1992-586#p38a
[zdp38r]: https://www.zakonyprolidi.cz/cs/1992-586#p38r
[dr174]: https://www.zakonyprolidi.cz/cs/2009-280#p174
