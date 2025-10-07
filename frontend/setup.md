# Frontend Observability Setup

## 1. Deploy Alloy Service
```bash
kubectl apply -f k8s/alloy-service.yaml
```

## 2. Get Minikube IP and Port
```bash
# Get minikube IP
minikube ip

# Port forward Alloy Faro endpoint
kubectl port-forward -n monitoring svc/alloy 12347:12347
```

## 3. Serve Frontend
```bash
cd frontend
python3 -m http.server 8000
```

## 4. Access Frontend
Open http://localhost:8000 in your browser

## 5. Test Observability
- Click "Fetch Users" to generate traces and logs
- Click "Simulate Error" to test error tracking
- Check Grafana at http://localhost:3000 for traces and logs

## Frontend Sends:
- **Traces**: User interactions, API calls, page loads
- **Logs**: Application events, errors, debug info  
- **Metrics**: Web vitals, performance metrics