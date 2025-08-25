# ArgoCD Setup

## Apply Applications
```bash
kubectl apply -f argocd/application.yaml
```

## Access ArgoCD UI
```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

## Get Admin Password
```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

## Update Git Repository
Replace `https://github.com/your-username/zero-code.git` in `application.yaml` with your actual repository URL.