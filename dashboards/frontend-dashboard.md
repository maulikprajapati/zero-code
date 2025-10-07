# Frontend Observability Dashboard Setup

## Create Dashboard in Grafana

1. **Go to Grafana** → http://localhost:3000
2. **Click "+" → Dashboard**
3. **Add panels with these queries:**

### Panel 1: Error Rate
- **Type**: Stat
- **Query**: `sum(rate({source="faro"} |= "error" [5m]))`
- **Title**: "Frontend Error Rate"

### Panel 2: All Frontend Logs
- **Type**: Logs
- **Query**: `{source="faro"}`
- **Title**: "Frontend Activity"

### Panel 3: Error Logs Only
- **Type**: Logs  
- **Query**: `{source="faro"} |= "error"`
- **Title**: "Frontend Errors"

### Panel 4: Web Vitals
- **Type**: Logs
- **Query**: `{source="faro"} |= "vitals"`
- **Title**: "Web Performance"

### Panel 5: User Actions
- **Type**: Logs
- **Query**: `{source="faro"} |= "Fetching"`
- **Title**: "User Interactions"

## Advanced Queries

### Error Count by Type
```
sum by (level) (count_over_time({source="faro"} |= "error" [1h]))
```

### Log Volume Over Time
```
sum(count_over_time({source="faro"}[5m]))
```

### Filter by App
```
{source="faro", app="frontend-app"}
```

## Dashboard Features
- Set refresh to 5s for real-time monitoring
- Use time range: Last 1 hour
- Add alerts for error rate > 1/min