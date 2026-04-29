# Intake Questionnaire

Companion to `SKILL.md` Step 2. Run this **before** parsing documents to
disambiguate income types and deductions in scope. One AskUserQuestion batch
is fine.

## Questions

1. **§6 employment** — any salary, DPP/DPČ, or foreign employment in the year?
2. **§7 self-employment** — Fakturoid, other invoicing, multiple clients?
3. **§8 capital income** — Czech bank interest/dividends (already withheld
   §36, do **not** declare); foreign broker interest/dividends (must declare);
   ČEZ dividends (Czech, withheld); foreign company dividends (declare).
   See `CzechBankWithholding` rule for the §36 boundary.
4. **§9 rental** — any rental income from real estate or movables?
5. **§10 other** — securities sales (check 3-year time-test, 100K threshold,
   40M cap), crypto sales (3-year time-test from 2025), occasional sales,
   prizes.
6. **§15 deductions** — mortgage interest (and contract date for limit),
   donations (incl. blood / organs).
7. **§15a aggregate** — penzijní připojištění, LTIP/DIP, životní pojištění,
   long-term care insurance (shared 48 000 CZK cap).
8. **§35ba slevy** — spouse credit (verify both: child <3 AND spouse income
   <68 000 CZK — see PersonalTaxDeductions dual condition), invalidity,
   ZTP/P, student.
9. **§35c daňové zvýhodnění** — children, with second spouse's `Potvrzení
   druhého z poplatníků`.
10. **Filing channel** — datová schránka FO, NIA/BankID via MOJE daně, or
    daňový poradce (with plná moc filed by 1.4.).

## Output

Convert the answers into a working memory of "in scope" vs "out of scope"
income/deduction types **before** reading any documents. Skip reading
documents that map to out-of-scope categories.
