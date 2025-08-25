#!/bin/bash

echo "Deploying fresh observability stack..."

# Apply namespace
kubectl apply -f namespace.yaml

# Apply Tempo
kubectl apply -f tempo.yaml

# Apply Alloy
kubectl apply -f alloy.yaml

# Apply Grafana
kubectl apply -f grafana.yaml

echo "Waiting for pods to be ready..."
kubectl wait --for=condition=ready pod -l app=tempo -n grafana --timeout=60s
kubectl wait --for=condition=ready pod -l app=alloy -n grafana --timeout=60s
kubectl wait --for=condition=ready pod -l app=grafana -n grafana --timeout=60s

echo "Getting service information..."
kubectl get svc -n grafana

echo ""
echo "Setup complete!"
echo "Configure your .NET microservices to send traces to:"
echo "  OTEL_EXPORTER_OTLP_ENDPOINT=http://alloy:4317"
echo ""
echo "Access Grafana at: http://localhost:3000 (admin/admin)"
echo "Port forward with: kubectl port-forward svc/grafana 3000:3000 -n grafana"