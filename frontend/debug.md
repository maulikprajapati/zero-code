# Debug Frontend Logs in Grafana

## 1. Check All Recent Logs
In Grafana Explore → Loki, try these queries:

```
{job=~".*"} | json
```

```
{} |= "frontend"
```

```
{} |= "test"
```

## 2. Check Faro-specific Labels
```
{__name__=~".*"}
```

## 3. Check by Time Range
- Set time range to "Last 5 minutes"
- Click "Simulate Error" button
- Refresh the query

## 4. Alternative: Check Alloy Logs
```bash
kubectl logs -n monitoring -l app=alloy --follow | grep -i frontend
```

## 5. If Still No Logs
The issue might be that Faro logs need specific formatting. Try this query:
```
{} |= "Simulating error"
```