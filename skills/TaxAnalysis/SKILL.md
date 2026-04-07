---
name: TaxAnalysis
version: 0.1.0
description: "Extract and classify financial data from Czech tax documents (PDF, CSV). USE WHEN tax document, extract tax data, classify income, analyze potvrzeni, read tax PDF."
---

# TaxAnalysis

The user has a financial document they need analyzed for tax purposes. Read the document, extract structured data, and classify it.

## Instructions

1. Accept the document path (PDF or CSV). Read it using the Read tool (PDFs render visually).

2. Extract structured data:
   - Amounts (with currency)
   - Dates (tax year, issue date, period covered)
   - Payer / payee identifiers
   - Document type (what kind of confirmation or statement this is)

3. Classify using PersonalTaxIncome and PersonalTaxDeductions rules:
   - Income documents: assign §6-§10 category
   - Deduction documents: assign §15 or §15a deduction type
   - Flag if classification is ambiguous — present options to the user

4. Handle Czech-language documents. Common document types:
   - `Potvrzení o zdanitelných příjmech` — employment income (§6)
   - `Daňové potvrzení k DIP` — LTIP deduction (§15a)
   - `Výpis z doplňkového penzijního spoření` — pension deduction (§15a)
   - `Potvrzení o zaplacených úrocích` — mortgage interest (§15)
   - `Potvrzení zaplacené pojistné` — life insurance (§15a)

5. Output a structured summary per document.

## Output Format

```markdown
**Document:** [filename]
**Type:** [Czech document type] — [English equivalent]
**Tax year:** [year]
**Classification:** [§ section] — [category name]
**Extracted values:**
- [field]: [value]
- [field]: [value]
**Notes:** [any flags, ambiguities, or missing information]
```

## Constraints

- Never modify source documents
- Use CurrencyFormatting rule for all amounts
- Flag documents that span multiple tax years
- If a document is illegible or ambiguous, say so — do not guess
