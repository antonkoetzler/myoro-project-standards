# Observability Standards

## Three Pillars (all required in production)

- **Structured Logs** — discrete events in JSON format.
- **Metrics** — aggregated numbers (rate, errors, latency, saturation).
- **Distributed Traces** — request flow across service boundaries.

## Structured Logging

- JSON format always in production. Never free-form strings.
- Mandatory fields: `timestamp` (ISO 8601), `level`, `message`, `service`, `trace_id`, `span_id`.

## Log Levels

- `error`: operation failed, needs attention. Include stack trace.
- `warn`: unexpected but handled. Worth reviewing.
- `info`: normal significant events (request complete, state changes, auth events).
- `debug`: development only. Never enabled in production by default.

## What to Log / Never Log

**Log:** request in/out (method, path, status, duration), errors with stack traces, state changes, auth events.

**Never log:** passwords, tokens, credentials, PII, full request/response bodies by default.

## Metrics — Four Golden Signals

- Rate: `http_requests_total` (counter)
- Errors: `http_request_errors_total` (counter)
- Latency: `http_request_duration_seconds` (histogram, report p50/p95/p99)
- Saturation: CPU, memory, queue depth (gauges)

Prometheus conventions: snake_case, `_total` for counters, `_seconds` for durations.

## Distributed Tracing

- Propagate W3C TraceContext (`traceparent`) across all service boundaries.
- Use OpenTelemetry SDK. Instrument HTTP handlers, outbound calls, DB queries, queue ops.
- Set `status = Error` on spans when an error occurs.

## Correlation

- Every log line during a request shares the same `trace_id`.
- Return `X-Trace-Id` in response headers. Same `service` name across logs, metrics, traces.
- Alert on error rate and p99 latency — not just 5xx responses.
