# RDS PostgreSQL application: deployment prerequisites and validation

This directory is intentionally documentation-only. The commerce application was deployed from the separate public repository; this guide records the AWS prerequisites, EC2/RDS connection setup, and checks used to prove that the application is working.

## Architecture

```text
Browser --> EC2 public IPv4 :80 --> Nginx --> Gunicorn / Flask --> RDS PostgreSQL :5432
```

Keep the RDS instance private. The browser connects only to EC2; EC2 connects privately to RDS.

## Prerequisites

### AWS networking

1. Create an EC2 instance and an RDS for PostgreSQL DB instance in the same VPC.
2. Place RDS in private subnets and set **Publicly accessible** to **No**.
3. Ensure EC2 has a public IPv4 address (or an Elastic IP), an Internet Gateway route, and a public subnet route table for browser access.
4. Configure security groups:

| Resource | Inbound rule | Source |
| --- | --- | --- |
| EC2 | HTTP TCP 80 | `0.0.0.0/0` for a lab; restrict it in production |
| EC2 | SSH TCP 22 | Your public IP only |
| RDS | PostgreSQL TCP 5432 | EC2 application's security group |

Never expose RDS port 5432 to `0.0.0.0/0`.

### Database setup

Connect to the default `postgres` database as the RDS master user, using TLS:

```bash
psql "host=<RDS-ENDPOINT> port=5432 dbname=postgres user=<MASTER-USER> sslmode=verify-full sslrootcert=./global-bundle.pem"
```

Create the application database and user:

```sql
CREATE DATABASE commerce;
CREATE USER commerce_user WITH LOGIN PASSWORD '<strong-unique-password>';
GRANT CONNECT ON DATABASE commerce TO commerce_user;
\c commerce
GRANT USAGE, CREATE ON SCHEMA public TO commerce_user;
```

The deployed application needs a TLS connection string in its environment file:

```text
DATABASE_URL=postgresql+psycopg://commerce_user:<URL-ENCODED-PASSWORD>@<RDS-ENDPOINT>:5432/commerce?sslmode=require
```

URL-encode passwords containing characters such as `@`, `:`, `/`, `#`, `?`, or spaces. A password containing only letters and digits does not change when URL-encoded.

### What was created in PostgreSQL

The database setup creates:

| Object | Purpose |
| --- | --- |
| `commerce` database | Application data store |
| `commerce_user` role | Least-privilege login used by the application |
| `products` | Product SKU, name, description, and price |
| `inventory` | Available stock for each product |
| `orders` | Customer email, order status, and total |
| `order_items` | Product and quantity stored for every order |

The application initialization creates the four tables and seed catalog products. Additional products can be inserted directly into `products` and `inventory` when needed.

Verify the database, role, and tables as the RDS master user:

```sql
\l commerce
\du commerce_user
\c commerce
\dt
```

## 2. Deploy the application on EC2

The application code is stored in the public repository `https://github.com/Anantgs/commerse-rds-project.git`. Run these commands as `root` on Amazon Linux 2023:

Sample DB host url : "DATABASE_URL=postgresql+psycopg://commerce_user:qwert12345@commerse.c4pc8qi0kkz9.us-east-1.rds.amazonaws.com:5432/commerce?sslmode=require"

```bash
dnf update -y
dnf install -y git
git clone https://github.com/Anantgs/commerse-rds-project.git
cd /root/commerse-rds-project
bash deploy/setup.sh
```

The installer asks for the RDS endpoint, database name, user, and password. It installs Python, Nginx, Gunicorn, and the PostgreSQL driver; creates a Python virtual environment; and creates the `commerce` and `nginx` systemd services.

### Configure the RDS connection and initialize RDS tables

Open the environment file after the installer completes:

```bash
vim /root/commerse-rds-project/.env
```

Set `DATABASE_URL` to the TLS URL shown in the database setup section, then initialize the schema with those environment variables loaded:

```bash
cd /root/commerse-rds-project
set -a
source .env
set +a
.venv/bin/flask --app app init-db
systemctl restart commerce
```

### EC2 deployment checks

The deployment host needs Python, Nginx, the PostgreSQL Python driver, and a systemd service that loads `DATABASE_URL` from its `.env` file. The service should be active before testing:

```bash
systemctl status commerce nginx --no-pager
curl -I http://127.0.0.1/
```

The local HTTP check must return `HTTP/1.1 200 OK` before testing from a browser.

## 3. Validate the deployed application

### 1. Confirm browser access

Open this URL using the EC2 **public** IPv4 address, not the private `172.31.x.x` address:

```text
http://<EC2-PUBLIC-IP>/
```

If the browser cannot connect but the local `curl` command returns `200`, check the EC2 public IPv4 address, subnet route to the Internet Gateway, network ACLs, and the EC2 security-group HTTP rule.

### 2. Perform an application transaction

1. Open the catalog in the browser.
2. Add a product to the cart.
3. Place an order using a test email address.
4. Note the product name and quantity before and after checkout.

The catalog read verifies RDS reads. Checkout verifies that RDS creates an order and reduces inventory in one database transaction.

### 3. Verify data in RDS

Connect as `commerce_user` with TLS:

```bash
psql "host=<RDS-ENDPOINT> port=5432 dbname=commerce user=commerce_user sslmode=verify-full sslrootcert=./global-bundle.pem"
```

List the application tables:

```sql
\dt
```

Expected tables:

```text
inventory
order_items
orders
products
```

Inspect catalog data and current stock:

```sql
SELECT p.id, p.sku, p.name, p.price, i.quantity
FROM products AS p
JOIN inventory AS i ON i.product_id = p.id
ORDER BY p.id;
```

Confirm that the browser checkout wrote the order:

```sql
SELECT id, customer_email, status, total
FROM orders
ORDER BY id DESC;

SELECT oi.order_id, oi.product_name, oi.quantity, oi.unit_price
FROM order_items AS oi
ORDER BY oi.order_id DESC, oi.id;
```

The newest order must appear in `orders`, its products must appear in `order_items`, and the associated `inventory.quantity` must be lower by the ordered amount.

### 4. Quick check after creating an order

After placing an order in the browser, first confirm that the local web stack is healthy:

```bash
curl -I http://127.0.0.1/
systemctl status commerce nginx --no-pager
```

`curl` must return `HTTP/1.1 200 OK` and both services must be active. Then connect to RDS and run:

```sql
-- Latest orders created by the application
SELECT id, customer_email, status, total
FROM orders
ORDER BY id DESC;

-- Products stored in those orders
SELECT oi.order_id, oi.product_name, oi.quantity, oi.unit_price
FROM order_items AS oi
ORDER BY oi.order_id DESC, oi.id;

-- Remaining stock after checkout
SELECT p.name, p.sku, i.quantity AS stock_remaining
FROM products AS p
JOIN inventory AS i ON i.product_id = p.id
ORDER BY p.id;
```

The application is working correctly when the newest browser order appears in `orders` and `order_items`, while `stock_remaining` is lower by the ordered quantity.

### 5. Add products to the website catalog

Run this as `commerce_user` in the `commerce` database, then refresh the browser catalog:

```sql
WITH new_product AS (
  INSERT INTO products (sku, name, description, price)
  VALUES ('HUB-001', 'USB-C Hub', 'Seven-port USB-C hub with HDMI', 49.99)
  RETURNING id
)
INSERT INTO inventory (product_id, quantity)
SELECT id, 25 FROM new_product;
```

Verify the product and its stock:

```sql
SELECT p.sku, p.name, p.price, i.quantity
FROM products AS p
JOIN inventory AS i ON i.product_id = p.id
ORDER BY p.id;
```

## Operational checks

```bash
# Application and reverse-proxy status
systemctl status commerce nginx --no-pager

# Recent application errors
journalctl -u commerce -n 80 --no-pager

# Follow application logs while submitting a test order
journalctl -u commerce -f

# Confirm the application is listening behind Nginx
ss -ltnp | grep -E ':80|:8000'
```

## Troubleshooting

| Symptom | Cause and resolution |
| --- | --- |
| Browser times out | Use the EC2 public IPv4 address; allow HTTP 80 in the EC2 security group; verify the public subnet's Internet Gateway route. |
| `password authentication failed` | Reset the PostgreSQL role password with the RDS master user, then update the application's `DATABASE_URL`. |
| `no pg_hba.conf entry ... no encryption` | RDS requires TLS. Add `?sslmode=require` to `DATABASE_URL`. |
| `relation "products" does not exist` | The RDS schema was not initialized. Run the application's initialization command with `DATABASE_URL` exported from `.env`. |
| Browser gets HTTP 500 | Check `journalctl -u commerce -n 80 --no-pager`; the application log contains the underlying Python or database error. |

## Security follow-up

- Rotate any database password or `SECRET_KEY` that was shared in a terminal transcript or chat.
- Store production credentials in AWS Secrets Manager or SSM Parameter Store rather than a long-lived `.env` file.
- Use HTTPS with an ACM certificate and an Application Load Balancer or Nginx TLS configuration before exposing a real application.
- Do not run the application process as `root` in production; use a dedicated non-login service account.
