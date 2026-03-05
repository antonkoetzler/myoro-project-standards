# Security Standards

## Never in Code

No secrets, credentials, API keys, tokens, passwords, or private keys in source code or git history — ever.

If a secret is committed, treat it as compromised immediately: rotate it, then purge it from history.

## Secrets Management

- Environment variables via `.env` files (always gitignored).
- `.env.example` committed with placeholder values only — never real values.
- Use a secrets manager (HashiCorp Vault, AWS Secrets Manager, GCP Secret Manager, Azure Key Vault) in staging and production.
- Never log secrets, even in debug mode.

## Input Validation

- Validate and sanitize all external input at the system boundary — every HTTP request, CLI argument, file upload, message queue event.
- Allowlist (whitelist) not blocklist: define what is valid and reject everything else.
- Never trust client-supplied data, IDs, or roles — re-verify on the server for every request.
- Validate content type, size, and structure before processing files.

## Parameterized Queries

No string concatenation in SQL — ever. Use parameterized statements or an ORM that handles escaping:

```
// NEVER:
db.query("SELECT * FROM users WHERE id = " + userId)

// ALWAYS:
db.query("SELECT * FROM users WHERE id = $1", [userId])
```

This applies to all database drivers, all languages, all query builders.

## Authentication & Session

- Tokens must have an expiry. No eternal tokens.
- Refresh token rotation: issue a new refresh token on every use; invalidate the old one.
- Never store passwords in plain text. Use bcrypt (cost ≥12) or Argon2id.
- Session invalidation must be immediate on logout — do not rely on expiry alone.
- Use `HttpOnly`, `Secure`, and `SameSite=Strict` (or `Lax`) on session cookies.

## OWASP Top 10 — Concise Rules

| # | Risk | Rule |
|---|------|------|
| 1 | Broken Access Control | Enforce authorization server-side on every request; deny by default. |
| 2 | Cryptographic Failures | TLS 1.2+ everywhere; AES-256 for data at rest; no MD5/SHA-1 for security. |
| 3 | Injection | Parameterized queries for SQL; escape for HTML/JS; validate all inputs. |
| 4 | Insecure Design | Threat model new features; security is a design constraint, not an afterthought. |
| 5 | Security Misconfiguration | Disable debug endpoints in production; remove default credentials; minimal permissions. |
| 6 | Vulnerable Components | SCA scan in CI; no unaddressed high/critical CVEs; pin versions in lock files. |
| 7 | Auth Failures | Token expiry, refresh rotation, bcrypt/Argon2, session invalidation on logout. |
| 8 | Data Integrity Failures | Verify signatures on software updates and serialized data; use subresource integrity. |
| 9 | Logging Failures | Log all auth events, errors, and access control failures; alert on anomalies. |
| 10 | SSRF | Validate and allowlist URLs for server-side requests; block internal network ranges. |

## Dependencies

- Run Software Composition Analysis (SCA) in CI on every PR.
- No unaddressed high or critical CVEs in production.
- Pin exact versions in lock files (`package-lock.json`, `Cargo.lock`, `go.sum`, etc.).
- Review dependency licenses for compatibility before adding.

## Security Headers & Transport

- HTTPS only in production. Redirect HTTP to HTTPS.
- `Strict-Transport-Security: max-age=31536000; includeSubDomains`
- `Content-Security-Policy` — define explicitly, do not use `unsafe-inline` or `unsafe-eval`.
- `X-Frame-Options: DENY` or `SAMEORIGIN`.
- No sensitive data (PII, tokens, session IDs) in server logs.
- No stack traces or internal error details in API responses to clients.
