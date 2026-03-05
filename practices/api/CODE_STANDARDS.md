# API Design

## REST Semantics

| Method | Semantics | Idempotent | Body |
|--------|-----------|------------|------|
| GET | Retrieve resource(s) | Yes | No |
| POST | Create a new resource | No | Yes |
| PUT | Full replace of a resource | Yes | Yes |
| PATCH | Partial update | No | Yes |
| DELETE | Remove a resource | Yes | No |

GET requests must never have side effects. POST creates; do not use POST for retrieval.

## URI Conventions

- Lowercase kebab-case: `/user-profiles`, `/order-items`
- Nouns not verbs: `/users` not `/getUsers`
- Plural collections: `/users`, `/orders`
- Nested resources for ownership: `/users/{id}/orders`, `/orders/{id}/items`
- No trailing slashes: `/users` not `/users/`
- No file extensions: `/users` not `/users.json`

## Status Codes

| Code | Meaning | When to use |
|------|---------|-------------|
| 200 | OK | Successful GET, PUT, PATCH, DELETE with response body |
| 201 | Created | POST that creates a resource (include `Location` header) |
| 204 | No Content | Successful DELETE or POST with no response body |
| 400 | Bad Request | Malformed request syntax, invalid parameters |
| 401 | Unauthorized | Missing or invalid authentication |
| 403 | Forbidden | Authenticated but not authorized |
| 404 | Not Found | Resource does not exist |
| 409 | Conflict | State conflict (duplicate, optimistic lock failure) |
| 422 | Unprocessable Entity | Validation failure on a well-formed request |
| 429 | Too Many Requests | Rate limit exceeded |
| 500 | Internal Server Error | Unexpected server-side error |

Never return 200 with an error in the body. Status codes are the contract.

## Error Format

Use RFC 7807 Problem Details:

```json
{
  "type": "https://example.com/errors/validation-failed",
  "title": "Validation Failed",
  "status": 422,
  "detail": "One or more fields failed validation.",
  "instance": "/users/create",
  "errors": [
    { "field": "email", "message": "Must be a valid email address" }
  ]
}
```

`errors[]` is optional and used for field-level validation details.

## Versioning

- URI path versioning: `/v1/users`, `/v2/users`
- Version when you make breaking changes only; non-breaking additions do not require a new version.
- Never modify or remove a published version without a deprecation period and advance notice.
- Deprecation: return `Deprecation` and `Sunset` headers on deprecated endpoints.

## Pagination

Cursor-based pagination preferred for large or frequently-changing datasets:

```json
{
  "data": [...],
  "nextCursor": "eyJpZCI6MTIzfQ==",
  "hasMore": true
}
```

Offset-based is acceptable for small, stable datasets:

```json
{
  "data": [...],
  "total": 847,
  "page": 3,
  "pageSize": 25
}
```

## Request / Response Conventions

- camelCase field names in JSON.
- Always wrap collections in an envelope: `{ "data": [...] }` — never a bare array as the root.
- ISO 8601 dates: `2024-03-15T10:30:00Z`.
- Null vs. absent: prefer absent over `null` for optional fields not present in this response.

## OpenAPI

- Every API has an OpenAPI 3.x specification committed to the repository.
- Generate the spec from code (decorators, annotations) or generate code from the spec — do not hand-write both.
- The spec is the contract; it must be kept in sync with the implementation via CI validation.

## Authentication

- Bearer tokens in `Authorization: Bearer <token>` header.
- API keys in `X-Api-Key: <key>` header.
- Never in query parameters (they appear in server logs and browser history).
- Never in the request body for standard auth flows.
