#!/bin/bash

# Build Docker images in Minikube
eval $(minikube docker-env)

# Build services
docker build -t userservice:latest ./UserService
docker build -t orderservice:latest ./OrderService
docker build -t apigateway:latest ./ApiGateway
# docker build -t devicemanager:latest /Users/cygnet/Documents/Projects/gsm/repos/server-backend/Microservices/DeviceManagerService

# Deploy to Kubernetes
kubectl apply -f k8s/

# Wait for Alloy to be ready before other services
kubectl wait --for=condition=available --timeout=120s deployment/alloy -n monitoring

# Wait for deployments
kubectl wait --for=condition=available --timeout=300s deployment --all -n applications
kubectl wait --for=condition=available --timeout=300s deployment --all -n monitoring

# Get service URLs
echo "UserService URL: $(minikube service userservice -n applications --url)"
echo "Grafana URL: $(minikube service grafana -n applications --url)"