# Distributed Tracing with .NET 8 Microservices and Grafana Tempo

## Quick Start

Run the entire stack:

```bash
docker-compose up --build
```

## Test the Services

1. Call UserService which will call OrderService:
```bash
curl http://localhost:8080/users/123
```

2. View traces and logs in Grafana:
   - Open http://localhost:3000
   - Login: admin/admin
   - **Traces**: Go to Explore → Select Tempo datasource → Search for traces
   - **Logs**: Go to Explore → Select Loki datasource → Query logs by service
   
## Architecture

- **UserService** (Port 8080): Main service that calls OrderService
- **OrderService** (Port 8081): Secondary service called by UserService
- **Tempo** (Port 3200): Trace storage and query engine
- **Loki** (Port 3100): Log aggregation system
- **Promtail**: Log collector that forwards container logs to Loki
- **Grafana** (Port 3000): UI for viewing traces and logs

## Observability Features

- **Tracing**: OpenTelemetry auto-instrumentation for distributed tracing
- **Logging**: Structured JSON logs collected by Promtail and stored in Loki
- **Correlation**: Logs include structured data for filtering by user ID, service, etc.

### Sample Log Queries in Grafana

```
{job="userservice"} |= "Fetching user"
{job="orderservice"} |= "Found"
{container_name=~".*userservice.*"}
```

## Cleanup

```bash
docker-compose down -v
```