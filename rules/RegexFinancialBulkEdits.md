When bulk-editing tracked accounting or financial files (hledger journals, účetní deník, výkazy, smlouvy), avoid greedy digit-matching regex such as `[0-9]{3,}` or `\d{6}`. Bank account numbers, invoice numbers, mortgage references, and monetary amounts share digit patterns with account codes — over-matching corrupts data silently.

Specific failure mode: a regex meant to insert a separator into 6-digit account codes (`221001` → `221.001`) also matches `1234567890` (bank account → `123.4567890`), `N20240123` (invoice → `N202.40123`), and `100000,00` (loan amount → `100.000,00`). In European number format the corrupted amounts may still parse to the same value, so bilance still balances and the corruption is invisible until human review.

Use explicit per-pattern substitution: list the ~15 actual account codes used in the file and substitute each by name, not by digit-class regex. Verify with `git diff` before committing — look at every line touched, not just the diff summary.
