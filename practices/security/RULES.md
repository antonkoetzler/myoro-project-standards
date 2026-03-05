# Security Standards

## Never Do This

- No secrets, credentials, API keys, or tokens in source code or git history. Ever.
- No string concatenation in SQL. Use parameterized queries or an ORM.
- No plain-text password storage. Use bcrypt (cost ≥12) or Argon2id.
- No eternal tokens. All tokens must have an expiry.
- No sensitive data (passwords, tokens, PII) in logs.
- No stack traces or internal error details in API responses.
- No `unsafe-inline` or `unsafe-eval` in Content-Security-Policy.

## Secrets

- `.env` is gitignored. `.env.example` has placeholders only.
- Use a secrets manager (Vault, AWS Secrets Manager, etc.) in production.

## Input Validation

- Validate all external input at the system boundary. Allowlist, not blocklist.
- Never trust client-supplied IDs, roles, or permissions — verify server-side on every request.

## Auth & Session

- Token expiry required. Refresh token rotation on every use.
- Session invalidation on logout must be immediate.
- `HttpOnly`, `Secure`, `SameSite=Strict` on session cookies.

## OWASP Top 10 (brief)

1. Broken Access Control — deny by default; enforce server-side on every request.
2. Cryptographic Failures — TLS 1.2+; AES-256 at rest; no MD5/SHA-1.
3. Injection — parameterized queries; validate/escape all inputs.
4. Insecure Design — threat model new features; security is a design constraint.
5. Security Misconfiguration — no debug in prod; minimal permissions; no default creds.
6. Vulnerable Components — SCA in CI; no unaddressed high/critical CVEs.
7. Auth Failures — see Auth & Session above.
8. Data Integrity Failures — verify signatures; use subresource integrity.
9. Logging Failures — log all auth events and access control failures.
10. SSRF — allowlist URLs for server-side requests; block internal ranges.

## Dependencies & Transport

- SCA scan in CI. Pin versions in lock files.
- HTTPS only. HSTS. CSP. `X-Frame-Options`.
