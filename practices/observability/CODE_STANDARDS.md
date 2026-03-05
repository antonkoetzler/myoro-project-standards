# Observability Standards

## Three Pillars

All three are required in production systems. They are complementary, not interchangeable:

- **Structured Logs** — discrete events: what happened, when, and in what context.
- **Metrics** — aggregated numbers over time: how often, how fast, how many.
- **Distributed Traces** — the path a request took through the system: latency breakdown per service and operation.

## Structured Logging

- JSON format in all production environments. Never free-form strings.
- Mandatory fields on every log line:

| Field | Type | Example |
|-------|------|---------|
| `timestamp` | ISO 8601 | `"2024-03-15T10:30:00.123Z"` |
| `level` | string | `"info"` |
| `message` | string | `"User login successful"` |
| `service` | string | `"auth-service"` |
| `trace_id` | string | `"4bf92f3577b34da6"` |
| `span_id` | string | `"00f067aa0ba902b7"` |

Additional context fields as needed: `user_id`, `request_id`, `environment`, `version`.

## Log Levels

| Level | When to use | Production default |
|-------|-------------|-------------------|
| `error` | An operation failed and needs immediate attention or investigation. Include stack trace. | Enabled |
| `warn` | Something unexpected happened but the system handled it. Worth reviewing. | Enabled |
| `info` | Normal, significant events: service start/stop, request completion, state changes. | Enabled |
| `debug` | Detailed diagnostic information for development only. | Disabled |

Never enable `debug` level in production by default. Make log level configurable via environment variable.

## What to Log

**Always log:**
- All inbound requests (method, path, status code, duration in ms).
- All outbound requests to external services (URL, status, duration).
- All errors with stack traces and relevant context.
- Significant state changes (user created, payment processed, job started/completed).
- Authentication events (login success, login failure, token issued, token revoked).

**Never log:**
- Passwords, tokens, API keys, or any credentials.
- PII (personal identifiable information) unless explicitly required by law and encrypted.
- Full request/response bodies by default (they may contain secrets or PII).
- Health check endpoint hits (too noisy, no value).

## Metrics

The **Four Golden Signals** — monitor these for every service:

| Signal | What it measures | Prometheus convention |
|--------|-----------------|----------------------|
| Rate | Requests per second | `http_requests_total` counter |
| Errors | Error rate (%) | `http_request_errors_total` counter |
| Latency | Request duration distribution | `http_request_duration_seconds` histogram |
| Saturation | Resource utilisation (CPU, memory, queue depth) | `process_cpu_seconds_total`, custom gauges |

**Prometheus naming conventions:**
- snake_case names.
- `_total` suffix for counters: `http_requests_total`.
- `_seconds` for durations: `http_request_duration_seconds`.
- `_bytes` for sizes: `response_body_bytes`.
- Include `service` and `environment` labels on all metrics.

## Distributed Tracing

- Propagate trace context across all service boundaries using **W3C TraceContext** standard (`traceparent` / `tracestate` headers).
- Use **OpenTelemetry SDK** as the standard instrumentation library — it is vendor-neutral and supports all major backends (Jaeger, Zipkin, Tempo, OTLP).
- Create spans for: HTTP handler invocations, outbound HTTP calls, database queries, message queue operations, background job execution.
- Span names: `<verb> <resource>` — e.g. `GET /users/{id}`, `SELECT users`, `publish order.created`.
- Record errors on spans: set `status = Error` and add error details as span attributes.

## Correlation

- Every log line produced during a request must include the same `trace_id`.
- Pass `trace_id` in response headers (`X-Trace-Id`) so clients can reference it when reporting issues.
- Logs, metrics, and traces must all use the same `service` name for cross-signal correlation in observability tools.
- Alert on error rate and p99 latency, not just on server errors — high latency is often a leading indicator of failure.
