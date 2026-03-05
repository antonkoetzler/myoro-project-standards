# API Design

## REST Semantics

- GET: read-only, no side effects, no body.
- POST: create. PUT: full replace. PATCH: partial update. DELETE: remove.

## URI Conventions

- Lowercase kebab-case, plural nouns: `/user-profiles`, `/orders`
- Nested for ownership: `/users/{id}/orders`
- No trailing slashes, no file extensions, no verbs in URIs.

## Status Codes

- 200 OK, 201 Created (+ `Location`), 204 No Content
- 400 Bad Request, 401 Unauthorized, 403 Forbidden, 404 Not Found
- 409 Conflict, 422 Unprocessable Entity, 429 Rate Limited, 500 Server Error
- Never return 200 with an error in the body.

## Error Format (RFC 7807)

```json
{ "type": "...", "title": "...", "status": 422, "detail": "...", "instance": "...", "errors": [] }
```

## Versioning

- URI path versioning: `/v1/`, `/v2/`. Never break existing versions.
- Add `Deprecation` + `Sunset` headers on deprecated endpoints.

## Pagination

- Cursor-based preferred: `{ "data": [], "nextCursor": "...", "hasMore": true }`
- Always wrap collections in `{ "data": [] }` — never a bare array root.

## Conventions

- camelCase JSON fields. ISO 8601 dates. Absent over `null` for missing optional fields.
- OpenAPI 3.x spec committed to repo; validated in CI.

## Authentication

- Bearer tokens in `Authorization` header. API keys in `X-Api-Key` header.
- Never in query parameters or request body.
