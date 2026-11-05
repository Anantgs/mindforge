# Route 53 Failover Routing - Practical Guide

## Step-by-Step: Creating Failover DNS Records

### 1. **Deploy the Infrastructure**
Deploy both primary and secondary EC2 instances with health checks:
```bash
cd /mnt/d/ALL-DEVOPS/NOTES/devops-notes-extended/devops-notes/AWS-NOTES/Route-53/policy/failover
terraform init
terraform apply
```

Note the outputs:
- Primary IP: `54.123.45.67` (example - us-east-1)
- Secondary IP: `52.89.123.45` (example - us-west-2)
- Primary Health Check ID: `abc123-def456-ghi789`
- Secondary Health Check ID: `xyz789-uvw456-rst123`

### 2. **Verify Infrastructure**
Test both instances and health check endpoints:
```bash
# Test primary instance
curl http://54.123.45.67
curl http://54.123.45.67/health

# Test secondary instance
curl http://52.89.123.45
curl http://52.89.123.45/health
```

You should see:
- Primary: Green page with "PRIMARY SERVER - ACTIVE"
- Secondary: Red/Orange page with "SECONDARY SERVER - FAILOVER ACTIVATED"
- Health endpoints: Both should return "OK"

### 3. **Create Route 53 Hosted Zone**
```
AWS Console → Route 53 → Hosted Zones → Create hosted zone
- Domain name: yourdomain.com
- Type: Public hosted zone
- Create
```

### 4. **Create PRIMARY Failover Record**
```
Click "Create record"
- Record name: failover (will become failover.yourdomain.com)
- Record type: A
- Value: 54.123.45.67 (Primary instance IP)
- TTL: 60 seconds
- Routing policy: Failover
- Failover record type: Primary
- Health check ID: abc123-def456-ghi789 (select from dropdown)
- Record ID: primary-server
- Create records
```

### 5. **Create SECONDARY Failover Record**
```
Click "Create record" again
- Record name: failover (SAME name as primary)
- Record type: A
- Value: 52.89.123.45 (Secondary instance IP)
- TTL: 60 seconds
- Routing policy: Failover
- Failover record type: Secondary
- Health check ID: xyz789-uvw456-rst123 (optional but recommended)
- Record ID: secondary-server
- Create records
```

**Critical**: Both records must have the **same name** but different failover types (Primary vs Secondary).

---

## How Failover Routing Works

### Normal Operation (Primary Healthy)

```
User Request: failover.yourdomain.com
        ↓
    Route 53 DNS
        ↓
Check Primary Health Check → ✅ HEALTHY
        ↓
Return Primary IP: 54.123.45.67
        ↓
User sees: GREEN page "PRIMARY SERVER - ACTIVE"
```

### Failover Scenario (Primary Unhealthy)

```
User Request: failover.yourdomain.com
        ↓
    Route 53 DNS
        ↓
Check Primary Health Check → ❌ UNHEALTHY
        ↓
Check Secondary Health Check → ✅ HEALTHY
        ↓
Return Secondary IP: 52.89.123.45
        ↓
User sees: RED/ORANGE page "SECONDARY SERVER - FAILOVER ACTIVATED"
```

### Recovery (Primary Becomes Healthy Again)

```
User Request: failover.yourdomain.com
        ↓
    Route 53 DNS
        ↓
Check Primary Health Check → ✅ HEALTHY (recovered)
        ↓
Return Primary IP: 54.123.45.67
        ↓
User sees: GREEN page "PRIMARY SERVER - ACTIVE" (back to normal)
```

---

## Health Check Mechanics

### How Route 53 Health Checks Work

1. **Route 53 Health Checkers** (distributed globally) make requests to your endpoint
2. **Default settings**:
   - Interval: 30 seconds
   - Failure threshold: 3 consecutive failures
   - This means: 3 × 30s = **90 seconds** to detect failure

3. **Health check evaluation**:
   ```
   Attempt 1 (0s):   Request → Timeout/Error → Mark as failed
   Attempt 2 (30s):  Request → Timeout/Error → Mark as failed
   Attempt 3 (60s):  Request → Timeout/Error → Mark as failed
   At 90s: Health check status changes to UNHEALTHY
   → Route 53 starts routing to secondary
   ```

4. **Recovery works the same way**:
   ```
   Attempt 1 (0s):   Request → 200 OK → Mark as success
   Attempt 2 (30s):  Request → 200 OK → Mark as success
   Attempt 3 (60s):  Request → 200 OK → Mark as success
   At 90s: Health check status changes to HEALTHY
   → Route 53 routes back to primary
   ```

### Fast Health Checks (Optional)
For faster failover, use 10-second intervals:
```
Interval: 10 seconds
Failure threshold: 3
Failover detection time: 3 × 10s = 30 seconds
```

**Note**: Fast health checks cost more but provide quicker failover.

---

## Complete Practical Exercise

### Step 1: Deploy and Verify
```bash
terraform init
terraform apply -auto-approve

# Save outputs
terraform output

# Test both instances
curl http://PRIMARY_IP
curl http://SECONDARY_IP
```

### Step 2: Create Route 53 Records
Follow steps 3-5 above to create:
- Hosted zone
- Primary failover record
- Secondary failover record

### Step 3: Wait for DNS Propagation
```bash
# Check DNS (should return primary IP initially)
nslookup failover.yourdomain.com

# Or use dig
dig failover.yourdomain.com
```

### Step 4: Test Normal Operation
```bash
# Browse to your domain
curl http://failover.yourdomain.com

# Should see GREEN page (PRIMARY SERVER)
```

### Step 5: Simulate Primary Failure
```bash
# Method 1: Stop the primary instance
aws ec2 stop-instances --instance-ids i-1234567890abcdef0 --region us-east-1

# Method 2: Stop Apache on primary (if you have SSH access)
ssh ec2-user@PRIMARY_IP
sudo systemctl stop httpd
```

### Step 6: Monitor Health Check Status
```bash
# Check health check status
aws route53 get-health-check-status --health-check-id abc123-def456-ghi789

# Or use AWS Console
AWS Console → Route 53 → Health checks → Select your health check
```

### Step 7: Verify Failover (Wait 2-3 Minutes)
```bash
# After ~90 seconds (or 30s with fast health checks), test again
curl http://failover.yourdomain.com

# Should now see RED/ORANGE page (SECONDARY SERVER)
# This means failover worked!
```

### Step 8: Test Recovery
```bash
# Start the primary instance again
aws ec2 start-instances --instance-ids i-1234567890abcdef0 --region us-east-1

# Wait for instance to start and health check to recover (2-3 minutes)

# Test again
curl http://failover.yourdomain.com

# Should see GREEN page again (back to PRIMARY)
```

### Step 9: Monitor with CloudWatch
```bash
# Create CloudWatch dashboard to monitor
AWS Console → CloudWatch → Dashboards → Create dashboard

Add widgets for:
- Primary Health Check Status
- Secondary Health Check Status
- ConnectionTime metrics
```

### Step 10: Cleanup
```bash
# When done testing, destroy resources
terraform destroy -auto-approve
```

---

## Testing Scenarios

### Scenario 1: Complete Primary Failure
```bash
# Simulate complete failure
aws ec2 stop-instances --instance-ids PRIMARY_INSTANCE_ID

# Expected behavior:
# Time 0s:     Primary stops responding
# Time 90s:    Health check marks as unhealthy
# Time 90s+:   All traffic routes to secondary
# Time 90s+:   Users see SECONDARY page
```

### Scenario 2: Service Failure (Instance Running)
```bash
# SSH to primary and stop web service
ssh ec2-user@PRIMARY_IP
sudo systemctl stop httpd

# Expected behavior:
# Time 0s:     Apache stops
# Time 0s:     /health endpoint stops responding
# Time 90s:    Health check fails
# Time 90s+:   Traffic routes to secondary
```

### Scenario 3: Network Latency (Slow Response)
```bash
# If health check timeout is 10 seconds
# And response takes > 10 seconds
# Health check will fail even though service is "up"

# Test by adding artificial delay
sudo tc qdisc add dev eth0 root netem delay 15000ms
```

### Scenario 4: Both Servers Fail
```bash
# Stop both primary and secondary
aws ec2 stop-instances --instance-ids PRIMARY_ID SECONDARY_ID

# Expected behavior:
# Both health checks fail
# DNS still returns IPs, but connections fail
# Users see connection errors
```

---

## Real-World Use Cases

### Use Case 1: Disaster Recovery
```
Production: us-east-1 (primary)
DR Site: us-west-2 (secondary, warm standby)

Normal: All traffic → us-east-1
Disaster: Automatic failover → us-west-2
Recovery: Automatic failback → us-east-1
```

### Use Case 2: Maintenance Windows
```
Step 1: Verify secondary is healthy
Step 2: Stop primary for maintenance
Step 3: Traffic automatically routes to secondary
Step 4: Perform maintenance on primary
Step 5: Start primary
Step 6: Traffic automatically returns to primary
```

### Use Case 3: Multi-Tier Application
```
Web Tier:    Primary (us-east-1) → Secondary (us-west-2)
App Tier:    Primary (us-east-1) → Secondary (us-west-2)
DB Tier:     Primary (us-east-1) → Read Replica (us-west-2)

All tiers failover together for complete DR
```

---

## Advanced Configuration

### Multiple Secondary Records
You can't have multiple secondaries directly, but you can nest policies:

```
Primary: Single record (us-east-1)
Secondary: Weighted policy with multiple records
  └─ us-west-2 (weight: 70)
  └─ eu-west-1 (weight: 30)
```

### Combining Failover with Latency
```
Layer 1: Failover
  ├─ Primary: Latency policy (us-east-1, eu-west-1)
  └─ Secondary: Latency policy (us-west-2, ap-southeast-1)

This gives you:
- Active-active in each tier (latency-based)
- Failover between tiers
```

### Health Check on Health Checks
Create a calculated health check that monitors multiple health checks:

```
Master Health Check
  └─ Requires 1 of 2 to be healthy:
      ├─ Primary Instance Health Check
      └─ Secondary Instance Health Check
```

---

## Troubleshooting

### Problem: Failover not happening
**Solutions**:
1. Check health check configuration:
   ```bash
   aws route53 get-health-check --health-check-id YOUR_HC_ID
   ```
2. Verify health check status:
   ```bash
   aws route53 get-health-check-status --health-check-id YOUR_HC_ID
   ```
3. Check security groups allow health check traffic
4. Verify `/health` endpoint returns 200 OK
5. Check if failure threshold is met (need 3 consecutive failures by default)

### Problem: Not failing back to primary
**Solutions**:
1. Verify primary instance is running
2. Check primary health check status
3. Clear DNS cache: `ipconfig /flushdns` (Windows) or `sudo dscacheutil -flushcache` (Mac)
4. Wait full recovery period (90 seconds default)
5. Check TTL - old DNS records might be cached

### Problem: Flapping (switching back and forth)
**Solutions**:
1. Increase failure threshold (e.g., from 3 to 5)
2. Increase health check interval
3. Check if service is genuinely unstable
4. Review health check path - is it too sensitive?
5. Check for network issues causing intermittent failures

### Problem: Both health checks failing
**Solutions**:
1. Check security groups
2. Verify NACL rules
3. Check if health check IPs are blocked
4. Verify health check endpoint exists and responds
5. Check Route 53 health checker IP ranges are allowed

### Problem: Slow failover detection
**Solutions**:
1. Use fast health checks (10-second interval)
2. Reduce failure threshold (but not below 2)
3. Lower TTL value (60 seconds or less)
4. Consider using Route 53 Application Recovery Controller for faster failover

---

## Monitoring and Alerts

### CloudWatch Alarms to Create

1. **Primary Unhealthy Alarm**
```bash
aws cloudwatch put-metric-alarm \
  --alarm-name "Primary-Health-Check-Failed" \
  --alarm-description "Primary server is unhealthy" \
  --metric-name HealthCheckStatus \
  --namespace AWS/Route53 \
  --statistic Minimum \
  --period 60 \
  --evaluation-periods 2 \
  --threshold 1 \
  --comparison-operator LessThanThreshold \
  --dimensions Name=HealthCheckId,Value=YOUR_PRIMARY_HC_ID
```

2. **Both Servers Unhealthy (Critical)**
```bash
# Create composite alarm that triggers when both health checks fail
```

3. **Failover Event Occurred**
```bash
# Monitor when secondary health check receives traffic
# Check CloudWatch Logs for Route 53 query logs
```

### What to Monitor
- Health check status (both primary and secondary)
- Health check response time
- DNS query count (increase might indicate issues)
- HTTP 5xx errors on both servers
- Instance status checks

---

## Cost Optimization

### Costs Involved
1. **Health Checks**: $0.50/month per health check
2. **EC2 Instances**: Both primary and secondary must run
3. **Data Transfer**: Charges for traffic
4. **DNS Queries**: $0.40 per million queries

### Cost Saving Tips
1. Use t2.micro instances for testing (free tier eligible)
2. Stop secondary during off-hours if acceptable
3. Use fewer health checks (only primary if acceptable risk)
4. Use standard health checks instead of fast (if 90s failover is acceptable)

---

## Best Practices Summary

✅ **DO:**
- Always configure health check on primary (required)
- Add health check to secondary too (recommended)
- Set appropriate TTL (60 seconds)
- Test failover regularly (monthly)
- Monitor health check status with CloudWatch
- Document your failover procedures
- Keep secondary instance warm and ready
- Use meaningful record IDs

❌ **DON'T:**
- Rely on failover without testing
- Set TTL too high (delays failover visibility)
- Forget to monitor health check status
- Stop secondary to save costs (defeats purpose)
- Use same availability zone for primary and secondary
- Skip health checks on secondary

---

## Quick Reference Commands

```bash
# Check health status
aws route53 get-health-check-status --health-check-id HC_ID

# List all health checks
aws route53 list-health-checks

# Stop primary instance (trigger failover)
aws ec2 stop-instances --instance-ids INSTANCE_ID --region us-east-1

# Start primary instance (trigger recovery)
aws ec2 start-instances --instance-ids INSTANCE_ID --region us-east-1

# Check DNS resolution
dig failover.yourdomain.com
nslookup failover.yourdomain.com

# Clear DNS cache
ipconfig /flushdns  # Windows
sudo dscacheutil -flushcache  # Mac
sudo systemd-resolve --flush-caches  # Linux

# Test health endpoint
curl http://YOUR_IP/health

# Monitor logs
tail -f /var/log/httpd/access_log  # On EC2 instance
```

---

This failover configuration provides **automatic disaster recovery** with minimal manual intervention!
