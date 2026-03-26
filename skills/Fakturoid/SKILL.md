---
name: Fakturoid
version: 0.2.0
description: "Czech invoicing via Fakturoid API v3 — pull invoices, expenses, and income summaries for tax filing. USE WHEN fakturoid, invoices, issued invoices, expenses, income summary, §7 income, OSVČ income."
---

Pull invoicing data from [Fakturoid API v3][1] for tax and accounting workflows. Covers issued invoices (§7 income), expenses, and annual summaries.

## Prerequisites

Environment variables in `.env`:

```sh
FAKTUROID_CLIENT_ID=<oauth-client-id>
FAKTUROID_CLIENT_SECRET=<oauth-client-secret>
```

Register an OAuth app at Fakturoid Settings > API. Use the **Client Credentials** flow (server-to-server, no redirect).

## Authentication

Obtain a Bearer token via Client Credentials grant. Tokens expire after 7,200 seconds (2 hours). Credentials go via **HTTP Basic Auth**, not in the request body. Request and response must use JSON.

```sh
curl -s -X POST "https://app.fakturoid.cz/api/v3/oauth/token" \
    -u "$FAKTUROID_CLIENT_ID:$FAKTUROID_CLIENT_SECRET" \
    -H "Content-Type: application/json" \
    -H "Accept: application/json" \
    -H "User-Agent: ForgeFinance (tax@example.com)" \
    -d '{"grant_type":"client_credentials"}'
```

All subsequent requests require:
- `Authorization: Bearer <access_token>`
- `Accept: application/json` — Fakturoid returns 415 without it
- `User-Agent: ForgeFinance (contact@example.com)` — Fakturoid returns 400 without a User-Agent containing app name and contact email

## Instructions

### 1. Resolve account slug

```sh
curl -s "https://app.fakturoid.cz/api/v3/user.json" \
    -H "Authorization: Bearer $TOKEN" \
    -H "Accept: application/json" \
    -H "User-Agent: ForgeFinance (tax@example.com)"
```

The `user.json` endpoint returns an `accounts` array. Each account has a `slug`, `name`, and `registration_no` (IČ). Select the slug matching the IČ on the `DPFO` filing. All subsequent paths use `/accounts/{slug}/`.

### 2. Pull invoices for a tax year

```sh
curl -s "https://app.fakturoid.cz/api/v3/accounts/{slug}/invoices.json?since=2025-01-01&until=2025-12-31" \
    -H "Authorization: Bearer $TOKEN" \
    -H "Accept: application/json" \
    -H "User-Agent: ForgeFinance (tax@example.com)"
```

Filter parameters: `since`, `until`, `document_type` (exclude proformas/credit notes), `page` for pagination.

Each invoice has `total`, `issued_on`, `paid_on`, `status`, and `client_name`.

### 3. Cash-basis vs accrual

For §7 with `paušální výdaje` (flat-rate expenses), income is cash-basis: only invoices with `paid_on` within the tax year count. An invoice issued in December but paid in January of the next year belongs to the next tax year.

Sum `total` across invoices where `paid_on` falls within the tax year for §7 gross income (`celk_pr_prij7` on the `DPFO`).

### 4. Pull expenses

```sh
curl -s "https://app.fakturoid.cz/api/v3/accounts/{slug}/expenses.json?since=2025-01-01&until=2025-12-31" \
    -H "Authorization: Bearer $TOKEN" \
    -H "Accept: application/json" \
    -H "User-Agent: ForgeFinance (tax@example.com)"
```

Only needed when using actual expenses instead of flat-rate (`paušální výdaje`).

### 5. Account info

```sh
curl -s "https://app.fakturoid.cz/api/v3/accounts/{slug}/account.json" \
    -H "Authorization: Bearer $TOKEN" \
    -H "Accept: application/json" \
    -H "User-Agent: ForgeFinance (tax@example.com)"
```

Returns: `name`, `registration_no` (IČ), `vat_no` (DIČ), `street`, `city`, `zip`, `bank_account`, `plan`, `created_at`.

### 6. Client breakdown

Group invoices by `client_name` for per-client revenue analysis. Each invoice includes `client_name` and `subject_id` (links to subjects endpoint).

### 7. Subjects (client directory)

```sh
curl -s "https://app.fakturoid.cz/api/v3/accounts/{slug}/subjects.json" \
    -H "Authorization: Bearer $TOKEN" \
    -H "Accept: application/json" \
    -H "User-Agent: ForgeFinance (tax@example.com)"
```

Returns client/supplier records with `name`, `registration_no`, `street`, `city`, `country`, `email`.

### 8. Present summary

```markdown
| Metric                | Value          |
| --------------------- | -------------- |
| Issued invoices       | N              |
| Paid in tax year      | M              |
| Gross income (§7)     | X CZK          |
| Flat-rate (60%)       | Y CZK          |
| Tax base (§7)         | X - Y CZK     |
| Top client            | Name (Z CZK)  |
```

## Multi-Account

The `user.json` endpoint returns all accounts the user has access to. Each has a `slug` and `registration_no` (IČ). Select the correct account by matching IČ to the DPFO filing. The user may have separate accounts for personal `OSVČ` and company invoicing.

## Rate Limits

Monthly quotas depend on plan ([API docs][1]):

| Plan           | Requests/month |
| -------------- | -------------- |
| Na lehko       | 1,500          |
| Na každý den   | 3,000          |
| Na maximum     | 20,000         |

Check `X-RateLimit` response header for remaining quota. Use list endpoints (which include financial totals) to minimize detail calls.

## Constraints

- Read-only — never modify invoices or expenses
- Store tokens in memory, never write to tracked files
- Sanitize financial amounts per SanitizeFinancials rule when writing to tracked files

## MCP Alternative

[cookielab/fakturoid-mcp][2] provides Fakturoid tools as an MCP server. If installed, prefer MCP tools over raw curl calls.

[1]: https://www.fakturoid.cz/api/v3
[2]: https://github.com/cookielab/fakturoid-mcp
