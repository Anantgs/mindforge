# AWS Elastic Load Balancing (ELB) Architecture & Reference Guide

This reference guide summarizes the foundational concepts, routing mechanisms, advanced configuration features, and visual architecture flows of AWS Elastic Load Balancing (ELB) discussed during system design and architecture planning.

---

## 1. Overview of Elastic Load Balancing

AWS Elastic Load Balancing distributes incoming application or network traffic across multiple targets—such as Amazon EC2 instances, containers, IP addresses, and AWS Lambda functions—in one or more Availability Zones (AZs). It enhances application fault tolerance, scales seamlessly with incoming load, and provides automated health checks to route traffic exclusively to operational targets.

---

## 2. End-to-End System Architecture

Below is the visual architecture diagram representing the setup discussed: an internet-facing Application Load Balancer deployed across multiple public Availability Zones, routing traffic through path-based rules to private Auto Scaling target groups, with health checks, connection draining, and access logging enabled.

```text
                                  [ Internet Clients ]
                                           │
                                           ▼
                                [ Internet Gateway (IGW) ]
                                           │
                    ┌──────────────────────┴──────────────────────┐
                    ▼                                             ▼
        [ Public Subnet - AZ-a ]                      [ Public Subnet - AZ-b ]
     ┌─────────────────────────────┐               ┌─────────────────────────────┐
     │  ALB Node (AZ-a)            │               │  ALB Node (AZ-b)            │
     │  Listener: Port 443 / 80    │◄─────────────►│  Listener: Port 443 / 80    │
     └──────────────┬──────────────┘  Cross-Zone   └──────────────┬──────────────┘
                    │                 Load Balancing              │
         ┌──────────┴─────────────────────────────────────────────┴──────────┐
         │                    Listener Rules & Routing                       │
         │  Rule 1: Path = /api/*      ──► Forward to [ API Target Group ]   │
         │  Rule 2: Path = /images/*   ──► Forward to [ Media Target Group ] │
         │  Rule 3: Default (/*)       ──► Forward to [ Web Target Group ]   │
         └──────────┬─────────────────────────────────────────────┬──────────┘
                    │                                             │
      Access Logs   ▼                                             ▼  Access Logs
  [ S3 Bucket: elb-access-logs ]                     [ S3 Bucket: elb-access-logs ]
                    │                                             │
   ┌────────────────┴─────────────────────────────────────────────┴────────────────┐
   │                          VPC Private Subnets                                  │
   │                                                                               │
   │   Target Group 1 (API Service)       Target Group 2 (Web Frontend)            │
   │   ┌──────────────────────────────┐   ┌──────────────────────────────┐         │
   │   │ [EC2 / Container: api-1]     │   │ [EC2: web-1 (AZ-a)]          │         │
   │   │ [EC2 / Container: api-2]     │   │ [EC2: web-2 (AZ-b)]          │         │
   │   └──────────────┬───────────────┘   └──────────────┬───────────────┘         │
   │                  │                                  │                         │
   │                  ▼                                  ▼                         │
   │      [ Auto Scaling Group ]             [ Auto Scaling Group ]                │
   │      • Health Check Monitoring          • Dynamic / Scheduled Scaling         │
   │      • Connection Draining (300s)       • Termination Policies                │
   └───────────────────────────────────────────────────────────────────────────────┘
```

---

## 3. Load Balancer Types

AWS offers three primary managed load balancer families tailored to different layers of the Open Systems Interconnection (OSI) model:

| Attribute | Application Load Balancer (ALB) | Network Load Balancer (NLB) | Gateway Load Balancer (GWLB) |
| :--- | :--- | :--- | :--- |
| **OSI Layer** | Layer 7 (Application) | Layer 4 (Transport) | Layer 3 (Network / Gateway) |
| **Supported Protocols** | HTTP, HTTPS, gRPC, WebSocket | TCP, UDP, TLS | IP (GENEVE encapsulation on UDP 6081) |
| **Performance & Latency** | Content routing (~single-digit ms) | Ultra-low latency (~sub-millisecond), millions of req/sec | High-throughput transparent traffic steering to virtual appliances |
| **IP Addressing** | Dynamic DNS-managed IPs; elastic IPs not supported directly | Static IP per subnet / AZ; supports Elastic IP (EIP) attachment | Operates transparently via private VPC endpoints (GWLBE) |
| **Core Use Cases** | Microservices, REST APIs, containerized apps (ECS/EKS), modern web apps | High-performance TCP/UDP streams, gaming, IoT, financial trading | Third-party firewalls, Intrusion Detection/Prevention (IDS/IPS), packet inspection |

---

## 4. Listeners & Routing Rules

A **listener** is a process that checks for connection requests using the protocol and port configured by the administrator.

### Listener Configuration
- **Front-end Port & Protocol:** Defines what the client connects to (e.g., HTTPS on port 443, HTTP on port 80, TCP on port 8443).
- **Default Actions:** A catch-all rule executed when no condition-specific routing rules match incoming requests (e.g., forward to a default target group, return a fixed 404 response, or redirect HTTP to HTTPS).

### Advanced Routing Rules (ALB Layer 7)
ALB evaluates rules in numerical priority order. When a condition evaluates to true, the configured action executes:

- **Path-Based Routing:** Routes traffic based on the URL path in the request (e.g., `/api/*` forwards to the Backend Target Group, `/static/*` forwards to static asset servers).
- **Host-Based Routing:** Routes traffic based on the domain name in the `Host` header (e.g., `api.example.com` vs. `billing.example.com`).
- **HTTP Header-Based Routing:** Inspects custom or standard HTTP headers (e.g., `User-Agent`, `X-Custom-Header`).
- **HTTP Request Method Routing:** Directs requests according to standard HTTP verbs (`GET`, `POST`, `PUT`, `DELETE`).
- **Query Parameter Routing:** Directs requests matching query string key-value pairs (e.g., `?version=v2`).
- **Source IP CIDR Routing:** Matches the client's IPv4 or IPv6 CIDR block to route or restrict traffic.

### Visual Flow: Path-Based Routing

```text
Incoming Request: GET /api/v1/users
        │
        ▼
   [ Listener: Port 443 ]
        │
        ├─► [ Rule 1: Host == 'admin.domain.com' ? ] ──(No)──┐
        │                                                    ▼
        ├─► [ Rule 2: Path == '/api/*' ? ] ──────────(Yes)──► [ Target Group: API ]
        │                                                           │
        │                                                           ├─► EC2 Instance 1A
        │                                                           └─► EC2 Instance 1B
        ▼
   [ Rule 3 (Default): Path == '/*' ] ──► [ Target Group: Web Frontend ]
```

---

## 5. Target Groups & Routing Algorithms

A **Target Group** routes requests to one or more registered compute targets. When creating a listener rule, one or more target groups are designated as the forward destination.

### Target Types
1. **Instances:** Targets specified by EC2 Instance ID.
2. **IP Addresses:** Targets specified by private IPv4/IPv6 addresses (enables hybrid routing to on-premises servers or custom container topologies).
3. **Lambda Functions:** Invokes serverless functions directly from HTTP/HTTPS requests.
4. **Application Load Balancers:** Allows chaining an ALB behind an NLB to provide static IP endpoints for Layer 7 applications.

### Routing Algorithms
- **Round Robin:** Distributes requests evenly and sequentially across all healthy targets in the target group. This is the default algorithm.
- **Least Outstanding Requests (LOR):** Routes the next request to the target that currently has the fewest open, active, or in-flight requests. Ideal for workloads where request processing times vary widely.
- **Weighted Random:** ALB selects targets randomly based on assigned percentage weights, frequently applied for canary releases and blue/green deployments.

---

## 6. Health Checks

Elastic Load Balancing regularly monitors the health of all registered targets using active probing.

### Configuration Parameters
- **Health Check Protocol & Port:** The protocol (`HTTP`, `HTTPS`, `TCP`) and port used to test target responsiveness.
- **Health Check Path:** The URI endpoint queried on the target (e.g., `/healthz` or `/status`).
- **Success Codes (HTTP/HTTPS):** The HTTP response codes expected from the application (e.g., `200` or `200-299`).
- **Interval:** The frequency of health check probes (e.g., every 30 seconds).
- **Timeout:** The duration during which no response from a target means a failed probe (e.g., 5 seconds).
- **Healthy Threshold:** The number of consecutive successful checks required before a target is marked healthy and receives live traffic.
- **Unhealthy Threshold:** The number of consecutive failed checks required before a target is removed from active routing.

### Visual Flow: Health Checking & Traffic Gating

```text
      [ ALB Health Checker ]
                 │
      Every 30s: GET /healthz
                 │
                 ├─── Response: HTTP 200 (x2 consecutive) ──► Mark HEALTHY ──► Route Live Traffic
                 │
                 └─── Response: 500 / Timeout (x2 consec) ──► Mark UNHEALTHY ──► Halt Traffic Routing
                                                                                        │
                                                                                        ▼
                                                                             Auto Scaling Replaces Target
```

---

## 7. Session Stickiness (Sticky Sessions)

Session stickiness binds a client’s session to a specific target within a target group, ensuring subsequent requests from that user reach the same instance to maintain stateful local application memory.

### Cookie Types
- **Duration-Based (Load Balancer-Generated):** The load balancer issues an encrypted cookie (`AWSALB` for ALB) with a configurable expiration duration (from 1 second to 7 days).
- **Application-Based:** Uses an application-generated cookie or custom name (`AWSALBAPP`). The load balancer still sets a corresponding tracking cookie to follow the application's session state.

### Visual Flow: Sticky Session Lifecycle

```text
Initial Request (No Cookie)
Client ──────────────► [ ALB ] ──(Round Robin)──► Target A (EC2)
                          │                          │
                          ▼                          │
                     Generates Cookie 'AWSALB'       │
                          │                          │
Client ◄─── Set-Cookie ───┴──────────────────────────┘

Subsequent Requests (Cookie: AWSALB=Target_A)
Client ──────────────► [ ALB ] ──(Bypasses RR)──► Target A (EC2)
```

### Design Considerations
While stickiness maintains session locality for non-distributed applications, it can lead to uneven load distribution if a small number of users generate disproportionate traffic. Modern architectures typically offload session state to distributed caches (e.g., Amazon ElastiCache / Redis) to keep backend instances stateless.

---

## 8. Advanced Load Balancer Features

### Connection Draining (Deregistration Delay)
- **Mechanism:** When a target is deregistered (manually or by Auto Scaling during scale-in) or becomes unhealthy, connection draining halts new incoming requests to that target while allowing active, in-flight requests to finish processing cleanly.
- **Configuration:** Configured via the `deregistration_delay.timeout_seconds` attribute (range: 0 to 3600 seconds; default is 300 seconds / 5 minutes).
- **Benefit:** Prevents abrupt TCP resets (`RST`) or broken 502/504 HTTP responses for clients currently completing transactions or file uploads.

```text
Auto Scaling triggers Scale-In or Deregistration
                          │
                          ▼
              [ Target Marked DEREGISTERING ]
                          │
             ┌────────────┴────────────┐
             ▼                         ▼
   New Incoming Requests     Existing In-Flight Requests
   Routed to OTHER targets   Allowed up to 300s to finish
             │                         │
             │                         ▼
             │               All active requests complete
             │                         │
             ▼                         ▼
   [ Instance safely stopped / terminated by ASG ]
```

### Access Logs
- **Mechanism:** Captures detailed metadata about every request received by the load balancer and delivers compressed log files to an Amazon S3 bucket at 5-minute or 60-minute intervals.
- **Captured Fields:** Timestamp, client IP and source port, target IP and processing port, request processing time, target response time, ELB status code, target status code, received/sent bytes, user agent, SSL cipher, and TLS protocol version.
- **Analysis:** Typically queried using Amazon Athena (SQL queries on S3 data) or ingested into CloudWatch Logs / OpenSearch for security audits, latency bottleneck identification, and traffic pattern visualization.

```text
[ Client Requests ] ──► [ Application Load Balancer ] ──► [ Targets ]
                                   │
                           Captures Metadata:
                           • Client IP & Port
                           • Latency & Timestamps
                           • HTTP Status (ELB & Target)
                           • TLS Ciphers & User-Agent
                                   │
                                   ▼ (Every 5 or 60 mins)
                    [ Amazon S3: elb-access-logs/ ]
                                   │
                                   ▼
                      [ Amazon Athena (SQL Analytics) ]
```

### Idle Timeout
- **Mechanism:** The maximum time that a connection can remain completely idle (without any data transferred in either direction) before the load balancer terminates the connection.
- **Configuration:** Default is 60 seconds on an ALB (configurable from 1 to 4000 seconds).
- **Tuning Guidance:**
  - For standard REST APIs and microservices: Keep close to 60 seconds to release socket resources promptly.
  - For long-running operations (large file uploads/downloads, synchronous batch reporting, Server-Sent Events, WebSockets): Increase the timeout on both the load balancer and the backend web servers (e.g., NGINX, Apache, Node.js) to avoid premature `504 Gateway Timeout` errors.
  - Backend timeout rule: Ensure backend server keep-alive timeouts are configured higher than the load balancer's idle timeout.

---

## 9. Summary Architectural Matrix

| Feature | Primary Purpose | Default Setting | Key Configuration Levers |
| :--- | :--- | :--- | :--- |
| **Listener Rules** | Traffic steering based on Layer 7 inspection | Default action | Path, host, method, headers, query params |
| **Target Groups** | Logical grouping of backend workers | Instance / Round Robin | Target type, algorithm (Round Robin vs. LOR) |
| **Health Checks** | Automatic target fault detection | Protocol-dependent | Interval, timeout, healthy/unhealthy threshold |
| **Session Stickiness** | Client session affinity | Disabled | Duration-based cookie vs. Application cookie |
| **Connection Draining** | Graceful instance shutdown and scaling | 300 seconds | `deregistration_delay.timeout_seconds` (0–3600s) |
| **Access Logs** | Audit, compliance, troubleshooting | Disabled | S3 destination bucket, prefix, interval |
| **Idle Timeout** | Socket lifecycle management | 60 seconds | `idle_timeout.timeout_seconds` (1–4000s) |
