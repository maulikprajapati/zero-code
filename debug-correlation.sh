#!/bin/bash

echo "🔍 Debugging trace-to-logs correlation..."

# Check what labels exist in Loki
echo "📋 Loki labels:"
kubectl exec -n tracing deployment/loki -- wget -qO- "http://localhost:3100/loki/api/v1/labels" | jq .

# Check job values in Loki
echo "📋 Loki job values:"
kubectl exec -n tracing deployment/loki -- wget -qO- "http://localhost:3100/loki/api/v1/label/job/values" | jq .

# Generate a trace and check Tempo
echo "🚀 Generating trace..."
kubectl port-forward -n tracing svc/userservice 8080:8080 &
PID=$!
sleep 2
curl -s http://localhost:8080/users/123 > /dev/null
kill $PID

echo "📋 Recent traces in Tempo:"
kubectl exec -n tracing deployment/tempo -- wget -qO- "http://localhost:3200/api/search?tags=service.name" | head -200

echo ""
echo "✅ Check if service names in traces match job labels in logs"