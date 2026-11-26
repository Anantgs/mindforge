# Post-deployment tests

Run AWS CLI commands from the machine with access to the deployment account. Database commands must run from an EC2 instance in the appropriate VPC, for example using Systems Manager Session Manager. These tests do not promote the replica or change DNS.

## 1. Verify HTTPS and redirect

```bash
curl -I https://shop.devoops.biz/
curl -I http://shop.devoops.biz/
```

Expected: HTTPS returns `200`; HTTP returns a redirect to HTTPS. A `200` confirms the catalog can be served, but does not by itself verify checkout or replication.

## 2. Check both regional application targets

```bash
EAST_TG=$(aws elbv2 describe-target-groups --region us-east-1 \
  --names commerce-east-tg --query 'TargetGroups[0].TargetGroupArn' --output text)
WEST_TG=$(aws elbv2 describe-target-groups --region us-west-2 \
  --names commerce-west-tg --query 'TargetGroups[0].TargetGroupArn' --output text)

aws elbv2 describe-target-health --region us-east-1 --target-group-arn "$EAST_TG" \
  --query 'TargetHealthDescriptions[*].[Target.Id,TargetHealth.State,TargetHealth.Reason]' --output table
aws elbv2 describe-target-health --region us-west-2 --target-group-arn "$WEST_TG" \
  --query 'TargetHealthDescriptions[*].[Target.Id,TargetHealth.State,TargetHealth.Reason]' --output table
```

Expected: two `healthy` targets in each region. The DR health check is a read check, not proof that the replica can accept orders.

## 3. Check RDS status and replication

```bash
aws rds describe-db-instances --region us-east-1 --db-instance-identifier commerce-dr-primary \
  --query 'DBInstances[0].[DBInstanceStatus,MultiAZ,Endpoint.Address]' --output table
aws rds describe-db-instances --region us-west-2 --db-instance-identifier commerce-dr-replica \
  --query 'DBInstances[0].[DBInstanceStatus,ReadReplicaSourceDBInstanceIdentifier,StatusInfos]' --output json
```

Expected: both are `available`, primary is Multi-AZ, and replica status reports `replicating`. In CloudWatch, select the replica's `AWS/RDS` `ReplicaLag` metric. PostgreSQL's timestamp-based metric can rise on an idle source, so verify a known order rather than treating a lag value alone as proof of missing data.

## 4. Place a test order

Open `https://shop.devoops.biz`, add a product to the cart and place an order using a recognizable test email, for example `dr-test@example.com`. Note the order ID, product, quantity and confirmation total. This creates real persistent data and reduces inventory.

## 5. Verify primary data and stock

Open a Session Manager shell on a **primary** application EC2 instance. Its ID is available from `terraform output primary_instances`. Connect using a PostgreSQL client and the primary endpoint; supply the database password at the prompt, not in the command line. If `psql` is unavailable, install an appropriate PostgreSQL client package for your EC2 operating system.

```bash
psql "host=commerce-dr-primary.c4pc8qi0kkz9.us-east-1.rds.amazonaws.com port=5432 dbname=commerce user=commerce_admin sslmode=require"
```

In `psql`, run:

```sql
SELECT current_database(), current_user, pg_is_in_recovery();
SELECT id, customer_email, status, total
FROM orders WHERE customer_email = 'dr-test@example.com' ORDER BY id DESC;
SELECT oi.order_id, oi.product_name, oi.quantity, oi.unit_price
FROM order_items oi JOIN orders o ON o.id = oi.order_id
WHERE o.customer_email = 'dr-test@example.com' ORDER BY oi.order_id DESC;
SELECT p.name, i.quantity AS stock_remaining
FROM products p JOIN inventory i ON i.product_id = p.id ORDER BY p.id;
\q
```

Expected: `pg_is_in_recovery` is `false`; the order and its items match the browser confirmation. Compare stock to the value recorded **before** checkout to confirm the reduction.

## 6. Verify the same order on the replica

Open a Session Manager shell on a **DR** application EC2 instance (`terraform output dr_instances`). Connect to its local regional replica:

```bash
psql "host=commerce-dr-replica.c5oges8uwdgc.us-west-2.rds.amazonaws.com port=5432 dbname=commerce user=commerce_admin sslmode=require"
```

```sql
SELECT current_database(), pg_is_in_recovery();
SELECT id, customer_email, status, total
FROM orders WHERE customer_email = 'dr-test@example.com' ORDER BY id DESC;
SELECT oi.order_id, oi.product_name, oi.quantity, oi.unit_price
FROM order_items oi JOIN orders o ON o.id = oi.order_id
WHERE o.customer_email = 'dr-test@example.com' ORDER BY oi.order_id DESC;
\q
```

Expected: `pg_is_in_recovery` is `true` and the order and items match the primary. Replication is asynchronous; if the order is not present, wait and query again while checking `ReplicaLag` and RDS replication status. Do not attempt a write on the replica.

## Troubleshooting

On the affected EC2 instance:

```bash
systemctl status commerce nginx --no-pager
journalctl -u commerce -n 80 --no-pager
sudo tail -n 100 /var/log/cloud-init-output.log
```

Avoid sharing `.env`, Terraform state, database passwords, or Secrets Manager values in logs or chat. `sslmode=require` encrypts the database connection but does not validate the server hostname; configure the AWS RDS CA bundle and `sslmode=verify-full` for verified TLS.
