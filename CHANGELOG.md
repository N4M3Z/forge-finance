# Changelog

All notable changes to forge-finance are documented here. Format follows [Keep a Changelog](https://keepachangelog.com/).

## [Unreleased]

### Fixed

- **CLAUDE.md**: Corrected ČSSZ vyměřovací základ from 50 % to 55 % of §7 base
  (zákon 589/1992, post-2024 konsolidační balíček).
- **.githooks/pre-commit, Makefile**: Drop trailing dot from `forge validate`
  and `forge install` invocations — `forge` 0.3.1 rejects the positional
  argument and was blocking commits.

### Changed

- **TaxFiling skill**: Expanded DPFDP7 attribute mapping from ~12 to ~150
  attributes covering VetaP / VetaD / VetaO / VetaS / VetaA / VetaB / VetaT,
  extracted into a companion file (`dpfdp7-attributes.md`). Added
  `Schema Gotchas` section (element ordering, dic format, fixed required
  attributes, decimal vs integer fields, MOJE daně rendering quirks) and a
  companion `skeleton.xml` validated against the cached XSD.
- **PersonalTaxDeductions rule**: Added 2024 reform dual condition for spouse
  credit (child <3 AND spouse income <68 000 CZK).
- **SecuritiesTax rule**: Added 3-year time-test for digital assets effective
  2025 (no transitional step-up, shared 40 mil CZK cap).
- **SocialFiling skill**: Added portal submission guidance (per-year formID
  URL pattern), post-2024 DS routing, NP pre-fill quirk, bank account
  resolution via memory-first procedure.
- **HealthFiling skill**: Filled VZP portal URL, documented VZP as online-only
  HTML form (no XML import/export), bank account resolution via memory-first
  procedure.
- **TaxReturn skill**: Added structured intake questionnaire as a companion
  file referenced from Step 2.

### Added

- **rules/en-CZ/CzechBankWithholding.md**: §36 srážková daň at source
  treatment (interest, dividends, bond coupons not declared on DPFO).
- **rules/en-CZ/IncomeTaxAdvances.md**: §38a advance payment schedule and
  §174 reduction request.
- **rules/en-CZ/BankAccounts.md**: Memory-first lookup procedure for FÚ,
  ČSSZ, and health insurer accounts. No hard-coded numbers in tracked
  content; canonical sources documented (financnisprava Příloha č. 4 PDF,
  cssz.cz per-OSSZ pages, per-pojišťovna platby pages).

## [0.1.0] - 2026-04-07

### Added

- Tax law rules: PersonalTaxIncome, PersonalTaxDeductions, PersonalTaxDeadlines, LongTermInvestment, MortgageInterest, SecuritiesTax, TaxXmlSchema
- Convention rules: CurrencyFormatting, ForeignTerms, SourcePriority, Penalties, FilingWorkflow
- Skills: Fakturoid, Revolut, SecuritiesTax, TaxAnalysis, TaxFiling, TaxReturn, SocialFiling, HealthFiling
- Agent: TaxAdvisor
- DPFDP7 XSD schema cached in docs/
- ADRs: TAX-0001, TAX-0002
- CI workflow, SECURITY.md, forge-cli Makefile
