#!/bin/bash

echo "Building UserService..."
cd UserService
docker build -t userservice .
cd ..

echo "Building OrderService..."
cd OrderService
docker build -t orderservice .
cd ..

echo "Building ApiGateway..."
cd src/ApiGateway
docker build -t apigateway .
cd ../..

echo "All services built successfully!"