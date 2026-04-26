---
name: PaymentQr
description: "Generate Czech SPAYD payment QR codes with valid IBAN and account checksums. USE WHEN qr platba, czech qr, spayd, generate payment qr, fundraising qr, donation qr."
version: 0.1.0
---
Generate scannable Czech SPAYD payment QR codes that bank apps actually accept. The format is deceptively layered — a QR can scan correctly while the payload is rejected as invalid by ČSOB, KB, Air Bank, or any other Czech bank app.

## SPAYD Payload Format

The SPAYD (Short Payment Descriptor) string is what gets encoded in the QR. Pattern:

```
SPD*1.0*ACC:<IBAN>[+<BIC>]*AM:<amount>*CC:<currency>*MSG:<message>*X-VS:<varsymbol>*RN:<recipient>
```

Mandatory: `SPD` header, `1.0` version, `ACC` (IBAN, optionally `+BIC`). Everything else is optional.

Field rules:
- `*` separates fields
- `:` separates key from value
- ASCII only in values (no Czech diacritics — strip or transliterate before encoding)
- Periods inside MSG can confuse some parsers — prefer space or dash separators

Minimal SPAYD that scans cleanly:

```
SPD*1.0*ACC:CZ7308000000002026051200+GIBACZPX*AM:500.00*CC:CZK*MSG:Tereza Plzen
```

## Validation Layers

A bank app validates the payload through several gates. Failing any one of them produces "invalid QR" with no specific reason. Pre-validate all of them locally before generating the QR.

| Gate | Check | Failure mode |
| ---- | ----- | ------------ |
| QR scan | Camera resolves modules | "Cannot read code" |
| Payload parse | SPAYD structure parses | "Unsupported QR" |
| IBAN format | Length 24, country `CZ`, mod-97 = 1 | "Invalid IBAN" |
| Account checksum | Czech mod-11 on prefix and 10-digit account | "Invalid account number" |
| Bank registry | Account exists at the named bank | "Account does not exist" |
| Currency | 3-letter ISO match | "Unsupported currency" |

The last gate (registry check) is what blocks vymyšlené účty — even with mathematically valid IBAN and mod-11 account, ČSOB and several others reject accounts that aren't in their interbank registry. For demo/role-play purposes, use a real account you control rather than a fake one.

## Czech Account mod-11 Check

Czech bank accounts have two parts that each must satisfy mod-11:

**Prefix** (up to 6 digits, padded left with zeros), weighted left to right:

```
weights = [10, 5, 8, 4, 2, 1]
sum(digit * weight for digit, weight in zip(prefix, weights)) % 11 == 0
```

**Account** (10 digits, padded left with zeros), weighted left to right:

```
weights = [6, 3, 7, 9, 10, 5, 8, 4, 2, 1]
sum(digit * weight for digit, weight in zip(account, weights)) % 11 == 0
```

Prefix `000000` always passes. Finding a valid 10-digit account by brute force takes microseconds.

## IBAN mod-97 Check

Czech IBAN: `CZ` + 2 check digits + 4-digit bank code + 6-digit prefix + 10-digit account = 24 chars.

```python
def iban_check(country, bban):
    rearranged = bban + country + "00"
    numeric = "".join(
        str(ord(c) - 55) if c.isalpha() else c
        for c in rearranged
    )
    return 98 - (int(numeric) % 97)
```

Verify with: build full IBAN → move first 4 chars to end → letters→digits → mod 97 must equal 1.

## Bank Code → BIC Table

Including BIC (`+<BIC>` after IBAN) materially improves bank app compatibility, especially for older Air Bank and Raiffeisenbank versions.

| Bank code | Bank | BIC |
| --------- | ---- | --- |
| 0100 | Komerční banka | `KOMBCZPP` |
| 0300 | ČSOB | `CEKOCZPP` |
| 0600 | MONETA Money Bank | `AGBACZPP` |
| 0710 | Česká národní banka | `CNBACZPP` |
| 0800 | Česká spořitelna | `GIBACZPX` |
| 2010 | Fio banka | `FIOBCZPP` |
| 2700 | UniCredit Bank | `BACXCZPP` |
| 3030 | Air Bank | `AIRACZPP` |
| 5500 | Raiffeisenbank | `RZBCCZPP` |
| 6100 | Equa bank | `EQBKCZPP` |
| 6210 | mBank | `BREXCZPP` |
| 8040 | Oberbank | `OBKLCZ2X` |

## Generation Recipe (Python)

Install once into a uv venv (system pip is wrapped — see `KnownIssues.md`):

```bash
uv venv /tmp/qrenv
uv pip install --python /tmp/qrenv/bin/python qrcode pillow
```

Generate a black PNG (maximum scanner compatibility — color QRs work but reduce camera margin):

```python
import qrcode

iban = "CZ7308000000002026051200"
bic = "GIBACZPX"
spayd = f"SPD*1.0*ACC:{iban}+{bic}*AM:500.00*CC:CZK*MSG:Tereza Plzen"

qr = qrcode.QRCode(
    version=None,
    error_correction=qrcode.constants.ERROR_CORRECT_M,
    box_size=12,
    border=4,
)
qr.add_data(spayd)
qr.make(fit=True)
img = qr.make_image(fill_color="black", back_color="white")
img.save("payment.png")
```

For inline embedding in a single HTML file:

```python
import base64, io
buf = io.BytesIO()
img.save(buf, format="PNG", optimize=True)
b64 = base64.b64encode(buf.getvalue()).decode()
html = f'<img src="data:image/png;base64,{b64}" alt="QR platba">'
```

## Color QR Variant

Red modules on white scan reliably in good light. Use SVG output for crisp resolution:

```python
import qrcode.image.svg, re

factory = qrcode.image.svg.SvgPathFillImage
img = qr.make_image(image_factory=factory)
img.save("/tmp/qr.svg")

with open("/tmp/qr.svg") as f:
    svg = f.read()
svg = svg.replace('fill="#000000"', '')
svg = svg.replace('<path d=', '<path fill="#E83E1F" d=')
```

Don't multi-color the QR. Position markers (the three big squares) need uniform color with the data modules; mixing colors breaks finder pattern detection on roughly half of phone scanners.

## Red Flags

| Thought | Reality |
| ------- | ------- |
| "I'll just use any 10-digit account number" | Bank apps reject accounts that fail mod-11. Compute or validate first. |
| "The QR scans, it must be valid" | Scanning is one gate of six. The payload is parsed and registry-checked separately. |
| "Diacritics in MSG should work" | SPAYD spec allows them, but real-world parsers vary. Strip to ASCII. |
| "I can skip the BIC" | Optional but several Czech bank apps need it for non-domestic-route IBANs. Always include. |
| "Color makes it more striking" | Reduces scanner margin. Black-on-white first; color only after black-on-white is proven. |

## Constraints

- Validate IBAN mod-97 and account mod-11 before generating, not after the bank rejects
- Strip diacritics from MSG and RN; SPAYD spec is permissive but parsers are not
- Always include BIC for cross-app compatibility
- Default to black PNG; only switch to color SVG when compatibility is proven on the target audience's banking apps
- For demo/role-play QRs that won't actually be paid, use a real account you control rather than a vymyšlený one — bank registry checks reject fakes regardless of math
