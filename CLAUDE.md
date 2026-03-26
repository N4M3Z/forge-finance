# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

Tax law rules, document analysis, and filing workflows for Czech personal income tax (`DPFO`) under [zakon 586/1992 Sb.](https://www.zakonyprolidi.cz/cs/1992-586). Skills-only forge module (no Rust code, no hooks).

## Build and Development

```sh
make install          # install skills + agents + activate git hooks
make validate         # validate module structure via pre-commit hooks
make test             # validate (alias for validate)
make clean            # remove build artifacts
```

Requires [forge-cli](https://github.com/N4M3Z/forge-cli) (`forge` binary in PATH). No submodules needed.

## Skill Pipeline

Skills form a directed pipeline where upstream skills feed data into downstream ones:

```
Fakturoid ──> TaxReturn ──> TaxFiling ──> MOJE dane (EPO portal)
Revolut ──> SecuritiesTax ──/               |
TaxAnalysis ────────────────/          SocialFiling
                                       HealthFiling
```

- **Fakturoid** — OAuth2 API client pulling issued invoices and expenses for §7 income. Cash-basis: only invoices with `paid_on` in the tax year count. Requires `FAKTUROID_CLIENT_ID` and `FAKTUROID_CLIENT_SECRET` in `.env`.
- **Revolut** — thin parser normalizing brokerage exports (PDF/CSV/Excel) into a standard transaction format. No tax logic; hands off to SecuritiesTax.
- **SecuritiesTax** — broker-agnostic FIFO lot matching, 3-year time-test exemption, FX conversion (`jednotny kurz` or daily CNB rate), §8/§10 classification.
- **TaxAnalysis** — reads financial PDFs and CSVs, extracts amounts and dates, classifies by income category or deduction type.
- **TaxReturn** — orchestrator. Document inventory, income validation (§6-§10), deduction computation (§15/§15a aggregate), cross-checks, pre-submission checklist.
- **TaxFiling** — parses existing DPFDP7 XML, diffs against computed values, generates corrected XML. Three modes: parse, diff, generate.
- **SocialFiling** — generates CSSZ `Prehled OSVC` from corrected DPFO §7 data. 29.2% rate on 50% of §7 base.
- **HealthFiling** — generates health insurance `Prehled OSVC`, routing to the correct company portal (VZP, CPZP, OZP). 13.5% rate on 50% of §7 base.

**Agent**: TaxAdvisor — Czech tax law Q&A specialist. References zakon sections, bilingual (Czech terms in backticks, English explanations). Recommends `danovy poradce` when uncertain.

## Rules as Knowledge Base

Rules in `rules/` encode Czech tax law with per-number statutory citations. They are behavioral guidance consumed by skills and the TaxAdvisor agent, not code:

| Rule                    | Scope                                                   |
| ----------------------- | ------------------------------------------------------- |
| PersonalTaxIncome     | §6-§10 income categories, foreign income, DTTs          |
| PersonalTaxDeductions | §15/§15a deductions, credits, 48K CZK aggregate cap     |
| PersonalTaxDeadlines  | Filing deadlines, `opravne`/`dodatecne`, penalty rates   |
| LongTermInvestment    | LTIP + pension savings, employer contributions           |
| MortgageInterest      | Mortgage interest, contract date limits                  |
| SecuritiesTax         | Stock sales §10, dividends §8, time test, FX conversion  |

## DPFDP7 XML Schema

The DPFO filing uses DPFDP7 (7th generation, tax years 2024+). All `Veta` elements are flat (attributes only, no child elements). Key elements: VetaD (header + tax computation), VetaP (taxpayer), VetaO (income totals), VetaS (deductions + final tax), VetaT (§7 detail), VetaV (§8-§10 detail), VetaW (foreign income credit), VetaN (refund bank account).

The XSD lives at `docs/cz/dpfdp7_epo2.xsd`. Always validate generated XML:

```sh
xmllint --noout file.xml
xmllint --noout --schema docs/cz/dpfdp7_epo2.xsd file.xml
```

Filing type is controlled by `dap_typ` on VetaD: `B` (radne), `O` (opravne radne — before deadline), `D` (dodatecne — after deadline), `E` (opravne dodatecne). For `O`/`D`/`E`, the `d_zjist` attribute (discovery date) is mandatory.

## Multi-Provider Build

`defaults.yaml` declares skills for Claude, Gemini, Codex, and OpenCode providers. The `build/` directory contains provider-specific output (kebab-case for Gemini/OpenCode, TOML agents for Codex). Source of truth is `skills/` and `agents/`, not `build/`.

## Conventions

- Czech legal terms in backticks (`bytove potreby`, `danove potvrzeni k DIP`), English equivalents in prose
- CZK after the number with a space: 1 500 CZK
- Every numeric value cites its statutory origin (zakon section reference)
- Government sources first, statutory text second, commentary third
- Validate XML with `xmllint --noout` and `xmllint --schema` after every edit
- Never auto-submit filings; always present values for user confirmation
- Never mix FX conversion methods (`jednotny kurz` vs daily CNB) within a filing
- Sanitize financial amounts when writing to tracked files (use rounded approximations)
- Omit optional XML attributes with no value — EPO rejects `"0"` where empty is expected
