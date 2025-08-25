#!/bin/bash

# Stop services
docker-compose down

# Remove only Grafana volume to clear cache
docker volume rm zero-code_grafana-data

# Restart services
docker-compose up -d

echo "Grafana cache cleared. Wait 30 seconds then access http://localhost:3000"