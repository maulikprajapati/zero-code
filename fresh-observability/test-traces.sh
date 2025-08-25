#!/bin/bash

echo "Testing trace pipeline..."

# Test if Alloy is receiving traces by sending a test trace
kubectl run trace-test --image=curlimages/curl --rm -it --restart=Never -- \
  curl -X POST http://alloy.grafana.svc.cluster.local:4318/v1/traces \
  -H "Content-Type: application/json" \
  -d '{
    "resourceSpans": [{
      "resource": {
        "attributes": [{
          "key": "service.name",
          "value": {"stringValue": "test-service"}
        }]
      },
      "scopeSpans": [{
        "spans": [{
          "traceId": "12345678901234567890123456789012",
          "spanId": "1234567890123456",
          "name": "test-span",
          "startTimeUnixNano": "1609459200000000000",
          "endTimeUnixNano": "1609459201000000000"
        }]
      }]
    }]
  }'

echo ""
echo "Check Alloy logs:"
kubectl logs deployment/alloy -n grafana --tail=10

echo ""
echo "Check Tempo logs:"
kubectl logs deployment/tempo -n grafana --tail=10