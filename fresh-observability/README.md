# Fresh Observability Stack

## Components
- **Grafana Tempo**: Trace storage and query engine
- **Grafana Alloy**: Trace collection and filtering (filters out `/health` endpoints)
- **Grafana**: UI for viewing traces

## Quick Deploy
```bash
chmod +x deploy.sh
./deploy.sh
```

## Manual Deploy
```bash
kubectl apply -f namespace.yaml
kubectl apply -f tempo.yaml
kubectl apply -f alloy.yaml
kubectl apply -f grafana.yaml
```

## Configure Your .NET Microservices
Update your microservice deployments to send traces to Alloy:

```yaml
env:
- name: OTEL_EXPORTER_OTLP_ENDPOINT
  value: "http://alloy:4317"
- name: OTEL_SERVICE_NAME
  value: "your-service-name"
```

## Access Grafana
```bash
kubectl port-forward svc/grafana 3000:3000 -n grafana
```
Then open http://localhost:3000 (admin/admin)

## Health Endpoint Filtering
Alloy automatically filters out traces from:
- `/health`
- `/api/health`
- `/v1/health`
- Any URL containing `/health`

## Verify Setup
```bash
kubectl get pods -n grafana
kubectl logs -f deployment/alloy -n grafana
kubectl logs -f deployment/tempo -n grafana
```