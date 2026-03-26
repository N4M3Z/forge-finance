---
name: TaxReturn
version: 0.1.0
description: "Interactive Czech personal income tax return (`DPFO`) preparation workflow. USE WHEN tax return, DPFO, danove priznani, file taxes, prepare tax filing, correct tax return."
---

Interactive workflow for preparing or correcting a Czech personal income tax return (`DPFO`).

## Instructions

1. **Identify scope.** Ask for the tax year. Locate the project note (`Projects/Taxes YYYY/`). Check PersonalTaxDeadlines rule to determine which deadline applies and whether this is `opravné` or `dodatečné přiznání`.

2. **Inventory documents.** List all files in the project's Assets directory. For each, invoke TaxAnalysis to extract and classify. Present the inventory to the user for confirmation.

3. **Validate income.** Cross-check extracted income against §6-§10 categories (PersonalTaxIncome rule). For employment income, verify `potvrzení o zdanitelných příjmech` from each employer. For foreign income, identify the applicable double taxation treaty and relief method ([§38f][1]).

4. **Compute deductions.** Apply PersonalTaxDeductions rule:
   - Retirement savings: check all products against the shared 48 000 CZK aggregate ([§15a][2]) per LongTermInvestment rule
   - Mortgage interest: verify contract date and limit ([§15(3)][3]) per MortgageInterest rule
   - Donations: verify minimum threshold ([§15(1)][4])
   - Present deduction summary with proof status (document found / missing)

5. **Compare with prior filing.** If a prior `DPFO` XML exists in the project, parse it and diff against computed values. Highlight discrepancies.

6. **Present summary.** Show a table matching `DPFO` form sections: total income by category, deductions, tax base, tax credits, computed tax, overpayment/underpayment.

7. **Pre-submission checklist:**
   - All proof documents present in Assets
   - Amounts within statutory limits
   - Filing deadline and form type confirmed (`opravné` vs `dodatečné` vs `řádné`)
   - Recommend `daňový poradce` for complex situations (foreign income, business income above threshold)

## Constraints

- Never auto-submit a filing
- Always present final values for user confirmation before generating output
- Use SourcePriority rule when citing statutory limits
- Use ForeignTerms rule for Czech term formatting

[1]: https://www.zakonyprolidi.cz/cs/1992-586#p38f
[2]: https://www.zakonyprolidi.cz/cs/1992-586#p15a
[3]: https://www.zakonyprolidi.cz/cs/1992-586#p15-3
[4]: https://www.zakonyprolidi.cz/cs/1992-586#p15-1
