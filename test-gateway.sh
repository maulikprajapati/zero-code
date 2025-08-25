#!/bin/bash

GATEWAY_URL="http://localhost:9009"

echo "=== Testing API Gateway Authentication ==="

echo "1. Testing login endpoint..."
TOKEN_RESPONSE=$(curl -s -X POST "$GATEWAY_URL/api/auth/login" \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"password"}')

echo "Login response: $TOKEN_RESPONSE"

TOKEN=$(echo $TOKEN_RESPONSE | jq -r '.token // empty')

if [ -z "$TOKEN" ]; then
    echo "❌ Failed to get token"
    exit 1
fi

echo "✅ Token obtained: ${TOKEN:0:50}..."

echo ""
echo "2. Testing authenticated endpoint (users)..."
curl -s -H "Authorization: Bearer $TOKEN" "$GATEWAY_URL/api/users/123" | jq .
