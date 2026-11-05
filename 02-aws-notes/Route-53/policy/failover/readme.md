# Route 53 Failover Routing Policy

## Overview
Failover routing policy allows you to route traffic to a primary resource when it's healthy, and automatically failover to a secondary resource when the primary becomes unhealthy. This is ideal for active-passive disaster recovery scenarios.

## How It Works
- Configure a primary record and a secondary (backup) record
- Health checks monitor the primary resource
- If primary is healthy → traffic goes to primary
- If primary is unhealthy → traffic automatically routes to secondary
- When primary recovers → traffic automatically returns to primary

## Use Cases
1. **Disaster Recovery**: Active-passive failover setup
2. **High Availability**: Ensure service continuity during outages
3. **Maintenance Windows**: Route traffic to backup during planned maintenance
4. **Multi-Region Backup**: Primary in one region, backup in another

## Configuration Requirements
- Two records with the same name and type
- One record marked as "Primary"
- One record marked as "Secondary"
- Health check **required** on primary record
- Health check optional on secondary record (recommended)

## Failover Types

### Active-Passive Failover
```
Primary (Active) ──────► Secondary (Passive)
     │                        │
   Healthy              Standby waiting
     │                        │
   Serves all traffic    No traffic
```

When primary fails:
```
Primary (Failed) ────X   Secondary (Active)
     │                        │
   Unhealthy              Takes over
     │                        │
   No traffic           Serves all traffic
```

## Example Scenario
```
Primary: EC2 in us-east-1 (54.123.45.67)
Secondary: EC2 in us-west-2 (52.89.123.45)

Normal operation:
User → Route 53 → Primary (us-east-1) → 54.123.45.67

Primary fails:
User → Route 53 → Check health → Failed
                → Route to Secondary (us-west-2) → 52.89.123.45

Primary recovers:
User → Route 53 → Check health → Healthy
                → Route back to Primary (us-east-1) → 54.123.45.67
```

## Key Features
- **Automatic Failover**: No manual intervention required
- **Health Check Based**: Decisions based on resource health
- **Fast Recovery**: Typically within 1-2 minutes (depends on health check interval)
- **Cost Effective**: Only pay for resources you use

## Health Check Configuration
### Recommended Settings
- Protocol: HTTP or HTTPS
- Path: `/health` or `/status`
- Port: 80 (HTTP) or 443 (HTTPS)
- Interval: 30 seconds (Fast: 10 seconds for quicker failover)
- Failure threshold: 3 consecutive failures
- Success threshold: 3 consecutive successes

## Best Practices
1. **Always use health checks** on primary (mandatory)
2. **Add health checks to secondary** for complete monitoring
3. **Test failover regularly** to ensure it works when needed
4. **Set appropriate TTL** (60 seconds recommended for faster failover)
5. **Monitor CloudWatch alarms** for health check status
6. **Keep secondary warm** (running and ready)
7. **Test recovery** to ensure traffic returns to primary

## Failover Decision Logic
```
User Request → Route 53
              ↓
    Check Primary Health Check
              ↓
         Is Healthy?
         /        \
       Yes         No
        ↓           ↓
    Return      Check Secondary
    Primary     Health Check
    IP              ↓
              Is Healthy?
              /        \
            Yes         No
             ↓           ↓
         Return      Return Error
         Secondary   (No healthy
         IP          resources)
```

## When to Use Failover Policy
✅ Use when:
- You need active-passive disaster recovery
- Service availability is critical
- You have a backup resource ready
- Automatic failover is required

❌ Don't use when:
- You need active-active load balancing (use Weighted or Latency)
- You want traffic split between resources
- Cost of maintaining backup is prohibitive
- Manual failover is acceptable

## Comparison with Other Policies

| Feature | Failover | Latency | Weighted |
|---------|----------|---------|----------|
| Active-Passive | ✅ Yes | ❌ No | ❌ No |
| Active-Active | ❌ No | ✅ Yes | ✅ Yes |
| Health Checks | Required | Optional | Optional |
| Cost | Lower (backup idle) | Higher (all active) | Higher (all active) |
| Use Case | DR/HA | Performance | Load distribution |

## Limitations
- Only supports two resources (primary and secondary)
- Primary health check is mandatory
- Not suitable for load distribution
- Secondary resource must be kept running (incurs cost)

## CloudWatch Monitoring
Monitor these metrics:
- `HealthCheckStatus` - Health check status (0 = unhealthy, 1 = healthy)
- `HealthCheckPercentageHealthy` - Percentage of healthy endpoints
- `ConnectionTime` - Time to establish connection
- `TimeToFirstByte` - Time to receive first byte

Set alarms for:
- Primary unhealthy → Alert operations team
- Secondary activated → Critical alert
- Both unhealthy → Emergency alert
