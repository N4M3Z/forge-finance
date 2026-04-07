# forge-finance

Tax law rules, document analysis, and filing workflows for Czech personal income tax (DPFO).

## What it provides

**Rules** — Czech tax law knowledge base with per-number statutory citations:

| Rule                    | Coverage                                                |
| ----------------------- | ------------------------------------------------------- |
| PersonalTaxIncome     | §6-§10 income categories, foreign income, §38f override |
| PersonalTaxDeductions | §15/§15a deductions, tax credits                        |
| PersonalTaxDeadlines  | Filing deadlines, opravné/dodatečné, penalties           |
| LongTermInvestment    | LTIP + pension savings, 48K aggregate cap               |
| MortgageInterest      | Mortgage interest deduction, contract date limits        |
| SecuritiesTax         | Stock sales §10, dividends §8, time test, FX conversion |
| TaxXmlSchema          | DPFDP7 XML attribute-to-row mappings                    |

**Skills** — end-to-end tax preparation workflow:

| Skill          | Role                                                    |
| -------------- | ------------------------------------------------------- |
| Fakturoid      | API client — §7 invoices/expenses via OAuth2             |
| Revolut        | Thin parser — normalizes brokerage exports               |
| SecuritiesTax  | Broker-agnostic — FIFO, time test, FX, §8/§10           |
| TaxAnalysis    | PDF/CSV document extraction and classification           |
| TaxFiling      | DPFDP7 XML parse/diff/generate for EPO                  |
| TaxReturn      | Orchestrator — full DPFO preparation workflow            |
| SocialFiling   | ČSSZ přehled OSVČ — social security                     |
| HealthFiling   | Health insurance přehled — routes to CPZP/VZP/OZP       |

**Agent** — TaxAdvisor (Czech tax law Q&A specialist)

## Installation

```sh
forge install path/to/forge-finance
```

Or via the legacy Makefile:

```sh
make install
```

See [INSTALL.md](INSTALL.md) for prerequisites and configuration.

## Configuration

Copy `.env.example` to `.env` and set your credentials:

```sh
FAKTUROID_CLIENT_ID=<your-oauth-client-id>
FAKTUROID_CLIENT_SECRET=<your-oauth-client-secret>
```

Override defaults in `config.yaml` (gitignored).

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for conventions, structure, and workflow.

## License

[EUPL-1.2](LICENSE)
