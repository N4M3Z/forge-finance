Procedure for resolving Czech tax / insurance bank account numbers.

**No specific account numbers are stored in this rule.** Account values
belong in user-scoped memory (per-user, untracked), not in tracked content.
The rule's job is to instruct agents to look there first, then verify
against canonical sources, and finally — only if needed — to ask the user.

## Resolution order (apply for every payment)

1. **Recall before lookup.** Check user-scoped memory (`~/.claude/memory/`)
   and any local untracked rules/CLAUDE.md for previously-used accounts. A
   returning OSVČ will usually have last year's verified accounts there.

2. **Verify the recalled value once per filing season** against the
   canonical source for the authority (table below). Authorities update
   accounts infrequently but not never. If the recalled value matches the
   canonical source, use it.

3. **If no memory exists**, fetch from the canonical source (FÚ, ČSSZ —
   both are headlessly resolvable) or ask the user to copy from their
   official předpis / authority portal (VZP and other pojišťovny — JS-rendered
   pages, not headlessly resolvable). **Never invent.** Never infer a number
   from the `prefix-VS/0710` pattern.

4. **After verification, prompt the user to save the value to their
   personal memory** so next year's filing can recall it.

## Canonical sources

### Income tax — Finanční úřad

[Příloha č. 4 — Bankovní účty FÚ nejčastěji placených daní][1] on
financnisprava.gov.cz is a flat PDF, organized by **kraj**, not by
pracoviště. All Praha pracoviště share the same FÚ pro hl. m. Prahu account.

Account format: `<prefix>-<base>/0710`. The prefix encodes the tax type:

| Prefix | Tax type                                          |
|--------|---------------------------------------------------|
| `721`  | DPFO podávajících přiznání (the OSVČ filing case) |
| `7704` | DPPO                                              |
| `705`  | DPH                                               |
| `2866` | Paušální daň                                      |
| `713`  | DPFO ze závislé činnosti                          |
| `7720` | DPFO vybíraná srážkou                             |

Full mapping in the PDF.

VS = rodné číslo (10 digits, no slash).

Region matters at the **kraj** level. Ask the user for their territorial
workplace (kraj), then resolve.

### Social — ČSSZ / OSSZ

URL pattern: `https://www.cssz.cz/web/cz/kontakty/region/ossz/<okres>#bankovni-spojeni`.
Per-OSSZ HTML page, headlessly fetchable (no auth, stable URL pattern).
PSSZ Praha publishes per-Praha-district accounts (110-119, 121-123, …) at
the same URL.

Prefix encoding (universal across OSSZ):

| Prefix   | Insurance type                          |
|----------|-----------------------------------------|
| `01011-` | důchodové pojištění OSVČ                |
| `11017-` | nemocenské pojištění OSVČ               |
| `21012-` | zaměstnavatelé / dobrovolné důchodové   |

VS = `vsdp` (variabilní symbol důchodového pojištění) from the přehled —
**not** the rodné číslo.

### Health — VZP / CPZP / OZP / ZPMV / RBP

Per-region pages, but JS-rendered (not headlessly resolvable).

| Pojišťovna | Lookup page                        |
|------------|------------------------------------|
| VZP        | <https://www.vzp.cz/platci/cisla-uctu> |
| CPZP       | Each pojišťovna's "platby" / "číslá účtů" page |
| OZP        | "                                  |
| ZPMV       | "                                  |
| RBP        | "                                  |

Resolution: prefer user memory; otherwise direct the user to the lookup
page or moje.&lt;pojišťovna&gt;.cz account page (which shows the assigned
account directly). Verify against the QR code on the předpis PDF the
pojišťovna sends.

VS = rodné číslo (10 digits, no slash).

## Anti-patterns

- **Never invent or hard-code account numbers in tracked content.** This
  rule, every SKILL.md, and every ADR must point to the canonical source
  rather than baking in a value.
- **Never infer from a `prefix-VS/0710` pattern.** Some older guides showed
  this; most authorities have moved to fixed accounts where the VS
  identifies the taxpayer, not the account.
- **Never reuse old DS or account values without re-verifying** at the start
  of each filing season — even from memory.
- **If unsure, refuse and ask.** Wrong account = misrouted payment =
  penalties for late payment even though the money left the user's account
  on time.

[1]: https://financnisprava.gov.cz/assets/cs/prilohy/d-placeni-dani/priloha_4_bu_fu_nejcastejsi_dane.pdf
