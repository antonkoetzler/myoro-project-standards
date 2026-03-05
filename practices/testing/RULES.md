# Testing Strategy

## Test Pyramid

Many unit → fewer integration → very few E2E. Inverting this pyramid = slow, expensive, brittle suite.

## Unit Tests

- One unit of behavior in isolation. Under 50ms each.
- No I/O, no network, no DB. Mock all external dependencies.
- Run on every commit.

## Integration Tests

- Components working together with real infrastructure (real DB, real HTTP stack).
- Run on every PR in CI.

## E2E Tests

- Critical user journeys only through the full UI or API.
- Minimise count — if an integration test can cover it, use that instead.
- Run before release or on schedule, not on every commit.

## Test Naming

Name must explain the failure without reading the body:
- `test_<what>_<condition>_<expected>` — e.g. `test_login_with_expired_token_returns_401`
- BDD: `describe('AuthService') { it('returns null when token is expired') }`

## Test Data

- Factories or fixtures, not production data.
- Clean, known state before each test. Never share mutable state between tests.

## Coverage

- 80%+ on business/domain logic is a reasonable target.
- Coverage % is not a quality signal. Test behavior, not implementation.
- Do not test private methods, getters/setters with no logic, or framework code.
