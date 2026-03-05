# Testing Strategy

## Test Pyramid

```
        /\
       /E2E\         — Few: critical user journeys only
      /------\
     /  Integ  \     — Some: components working together
    /------------\
   /  Unit Tests  \  — Many: isolated business logic
  /________________\
```

Inverting this pyramid (more E2E than unit) produces a slow, expensive, brittle test suite that developers stop running. Do not invert it.

## Unit Tests

- Test one unit of behavior in isolation.
- Must be fast: under 50ms per test. Slow unit tests are a sign of hidden I/O or missing mocks.
- No I/O: no network calls, no database, no filesystem reads (except fixtures loaded at test start).
- Mock all external dependencies (databases, HTTP clients, message queues, clocks, random number generators).
- Run on every commit, locally and in CI.

## Integration Tests

- Test that components work together: service + real database, API + real HTTP stack, queue consumer + real broker.
- Slower than unit tests — this is acceptable. They catch contract mismatches that unit tests cannot.
- Use real infrastructure where practical (Docker-based test databases, local message brokers).
- Run on every PR in CI, not necessarily on every local commit.

## E2E Tests

- Test critical user journeys only through the full UI or public API.
- Examples: "user can register and log in", "user can place an order and receive a confirmation email".
- Expensive, slow, and inherently flaky — minimise their count. If a journey can be verified with an integration test, use the integration test.
- Run before release or on a nightly schedule. Not on every commit.

## Test Naming

Tests must be readable as specifications. The test name must explain a failure without requiring anyone to read the test body.

**Patterns:**
- `test_<what>_<condition>_<expected>` — e.g. `test_login_with_expired_token_returns_401`
- BDD-style: `describe('AuthService') { it('returns null when token is expired') }`
- The name must include: **what** is being tested, **under what condition**, and **what the expected outcome is**.

## Test Data

- Use factories or fixtures, not production data.
- Start each test from a clean, known state. Do not rely on state left by a previous test.
- Never share mutable state between tests — test order must not matter.
- Use meaningful, readable test values. `"john@example.com"` is better than `"aaa@bbb.com"`.

## Coverage

- Aim for meaningful coverage of business logic — 80%+ line coverage on domain and service layers is a reasonable target.
- Coverage percentage alone is not a quality signal. 100% coverage of getters and setters is worthless. 60% coverage of complex business rules with meaningful assertions is valuable.
- Test behavior, not implementation. Do not test private methods or internal state directly.
- A test that would still pass after breaking the code it tests is not a test — it is noise.

## What Not to Test

- Private methods and internal implementation details. Test the public contract.
- Simple getters and setters with no logic.
- Framework code and third-party libraries (they have their own tests).
- Configuration values (test that the application behaves correctly given configuration, not that config files contain specific strings).
