#!/bin/bash

echo "Testing trace-to-logs correlation..."

# Port forward Grafana
kubectl port-forward -n tracing svc/grafana 3000:3000 &
GRAFANA_PID=$!

# Port forward UserService  
kubectl port-forward -n tracing svc/userservice 8080:8080 &
USER_PID=$!

sleep 3

echo "Generating traces and logs..."
curl -s http://localhost:8080/users/123 > /dev/null
curl -s http://localhost:8080/users/456 > /dev/null
curl -s http://localhost:8080/users/789 > /dev/null

echo ""
echo "✅ Traces and logs generated!"
echo ""
echo "🔗 Open Grafana: http://localhost:3000 (admin/admin)"
echo ""
echo "📋 Steps to see trace-to-logs button:"
echo "1. Go to Explore → Select Tempo"
echo "2. Search for traces (last 5 minutes)"
echo "3. Click on a trace to expand it"
echo "4. Click on any span"
echo "5. Look for 'Logs for this span' button"
echo ""
echo "Press Ctrl+C to stop port forwarding..."

# Wait for user to stop
trap "kill $GRAFANA_PID $USER_PID 2>/dev/null; exit" INT
wait