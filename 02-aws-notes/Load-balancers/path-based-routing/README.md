# Path-based routing prerequisites

This Terraform lab creates only the infrastructure required before you manually configure path-based routing:

- all resources in `us-east-1` by default
- one VPC (`10.10.0.0/16`)
- two public subnets in separate Availability Zones
- an internet gateway and public route table
- `http1` and `http2` Amazon Linux 2023 web servers

It intentionally does **not** create an ALB, listener, target group, or listener rule.

## Deploy

```powershell
terraform init
terraform apply
```

Terraform outputs two direct HTTP URLs. Open each to verify the page name and its private IP address.

## Configure the ALB manually afterward

The following resources are deliberately created manually so you can practise configuring ALB path-based routing.

### 1. Create an ALB security group

Create an ALB security group in the lab VPC with these rules:

| Direction | Type | Port | Source / destination |
| --- | --- | --- | --- |
| Inbound | HTTP | 80 | `0.0.0.0/0` |
| Outbound | All traffic | All | `0.0.0.0/0` |

For a production system, use HTTPS on port 443 and normally redirect HTTP to HTTPS.

### 2. Create the Application Load Balancer

In **EC2 → Load Balancers → Create load balancer**:

1. Select **Application Load Balancer**.
2. Set the scheme to **Internet-facing** and IP address type to **IPv4**.
3. Select the lab VPC.
4. Select both public subnets created by Terraform. They must be in different Availability Zones.
5. Attach the ALB security group from the previous step.
6. Create the ALB. Do not use the default security group unless it has the required HTTP rules.

### 3. Create target groups

Create two target groups. For each target group, use **Instances** as the target type, **HTTP** as the protocol, port **80**, and the lab VPC.

| Target group | Register target | Health-check path |
| --- | --- | --- |
| `http1-tg` | `http1` instance on port 80 | `/` |
| `http2-tg` | `http2` instance on port 80 | `/` |

Wait until both registered targets show **Healthy**. A healthy target confirms that the ALB can connect to Apache on the instance.

### 4. Create the listener and path rules

Create an **HTTP:80** listener on the ALB. Set its default action to a fixed `404` response, such as `wrong path buddy`.

Add these listener rules. Listener rules are evaluated from the lowest priority number upwards.

| Priority | Condition: path | Action |
| ---: | --- | --- |
| 10 | `/http1/*` | Forward to `http1-tg` |
| 20 | `/http2/*` | Forward to `http2-tg` |
| Default | Any unmatched path | Return fixed `404` |

### 5. Add URL rewrite transforms

An ALB selects a target using the path but forwards the original path unless you rewrite it. Without a rewrite, `/http1/` reaches the `http1` server as `/http1/`. This lab's Apache page exists at `/`, so Apache would return `404 Not Found`.

Edit each listener rule and add a **URL rewrite** transform:

| Rule | Match regular expression | Replace with |
| --- | --- | --- |
| `/http1/*` | `^/http1/(.*)$` | `/$1` |
| `/http2/*` | `^/http2/(.*)$` | `/$1` |

The request flow is then:

```text
/http1/         -> http1-tg -> rewrite to / -> http1 index.html
/http2/         -> http2-tg -> rewrite to / -> http2 index.html
```

### 6. Test

Copy the ALB DNS name from the ALB details page and test with a trailing slash:

```text
http://<alb-dns-name>/http1/
http://<alb-dns-name>/http2/
```

The first URL should show the `http1` page and its private IP; the second should show `http2`.

### 7. Restrict the web-server security group

The Terraform-created EC2 security group temporarily permits HTTP from the internet so you can test server pages directly. After the ALB works, replace that rule with:

| Direction | Type | Port | Source |
| --- | --- | --- | --- |
| Inbound | HTTP | 80 | ALB security group |

This is the production pattern: the ALB is public, while web servers accept traffic only from the ALB.

## Remove the lab

```powershell
terraform destroy
```
