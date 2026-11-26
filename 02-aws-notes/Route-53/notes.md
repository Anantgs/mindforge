# Practical DNS Learning & Troubleshooting Using Linux

## 1. Project Overview

This project documents practical DNS (Domain Name System) learning and troubleshooting using Ubuntu Linux running on WSL (Windows Subsystem for Linux).

The goal is to understand how DNS works, how domain names resolve into IP addresses, how DNS servers communicate, and how to troubleshoot DNS-related problems using Linux commands.

## 2. Environment

- Operating System: Ubuntu Linux
- Environment: Windows Subsystem for Linux (WSL)
- User: root
- DNS Utility: BIND9 DNS utilities
- DNS Tools: dig, nslookup

## 3. What is DNS?

DNS stands for Domain Name System.

DNS translates human-readable domain names into IP addresses.

Example:

```bash
www.google.com
```

DNS resolves the domain into IP addresses such as:

```text
142.251.156.119
142.251.152.119
```

DNS allows users to access websites without remembering their IP addresses.

## 4. DNS Commands Practiced

### 4.1 Check DNS using dig

```bash
dig www.google.com
```

Purpose:
- Queries DNS records.
- Displays the DNS response.
- Shows returned IP addresses.
- Displays DNS server and query time.

Important output:

```text
status: NOERROR
ANSWER: 8
SERVER: 172.24.144.1#53
```

Explanation:

- NOERROR: DNS query completed successfully.
- ANSWER: 8: Eight DNS answers were returned.
- SERVER: DNS server used for the query.
- Query time: Time taken to receive the DNS response.

### 4.2 Check DNS using nslookup

```bash
nslookup www.google.com
```

Purpose:
- Resolves domain names.
- Displays IPv4 and IPv6 addresses.
- Identifies the DNS server used.

### 4.3 Trace the complete DNS resolution process

```bash
dig +trace www.google.com
```

Purpose:

Displays the DNS resolution hierarchy.

DNS resolution process:

1. Root DNS servers
2. TLD DNS servers (.com)
3. Authoritative DNS servers
4. Final IP address response

Example DNS hierarchy:

```text
Your Ubuntu System
       |
       v
Root DNS Servers (.)
       |
       v
TLD DNS Servers (.com)
       |
       v
Google Authoritative DNS
       |
       v
www.google.com IP Address
```

### 4.4 Find IPv4 records

```bash
dig www.google.com A
```

A records contain IPv4 addresses.

### 4.5 Find IPv6 records

```bash
dig www.google.com AAAA
```

AAAA records contain IPv6 addresses.

### 4.6 Find mail servers

```bash
dig google.com MX
```

MX records identify mail servers responsible for receiving email for a domain.

### 4.7 Find name servers

```bash
dig google.com NS
```

NS records identify authoritative name servers.

### 4.8 Query Google's public DNS

```bash
dig @8.8.8.8 www.google.com
```

Purpose:
- Queries Google's public DNS resolver.
- Helps compare DNS responses from different resolvers.

### 4.9 Display only IP addresses

```bash
dig www.google.com +short
```

Purpose:
- Displays a simplified DNS response.
- Useful for scripts and troubleshooting.

### 4.10 Check DNS configuration

```bash
cat /etc/resolv.conf
```

Purpose:
- Displays DNS resolver configuration.
- Identifies configured nameservers.

## 5. Understanding DNS Response Flags

Example:

```text
flags: qr rd ad
```

| Flag | Meaning |
|---|---|
| QR | DNS response |
| RD | Recursion desired |
| RA | Recursion available |
| AA | Authoritative answer |
| AD | Authenticated data |

## 6. Understanding DNS Record Types

| Record | Description |
|---|---|
| A | IPv4 address |
| AAAA | IPv6 address |
| MX | Mail exchange |
| NS | Name server |
| CNAME | Canonical name / alias |
| TXT | Text information |
| PTR | Reverse DNS lookup |
| SOA | Start of Authority |
| SRV | Service location |
| DNSKEY | DNSSEC public key |
| DS | Delegation Signer |
| RRSIG | DNSSEC signature |
| NSEC3 | DNSSEC authenticated denial of existence |

## 7. Understanding DNSSEC

DNSSEC stands for Domain Name System Security Extensions.

It helps protect DNS responses using cryptographic signatures.

Important DNSSEC records:

- DNSKEY: Public key used in DNSSEC.
- DS: Delegation Signer.
- RRSIG: Digital signature.
- NSEC3: Helps authenticate nonexistence of DNS records.

Useful command:

```bash
dig google.com DNSKEY
```

## 8. Troubleshooting Observed During Practice

### Issue 1: Recursion not available

Observed message:

```text
WARNING: recursion requested but not available
```

Explanation:

The DNS server at 172.24.144.1 reported that recursive DNS service was unavailable for the request.

However, DNS answers were still returned.

### Issue 2: IPv6 network unreachable

Observed message:

```text
UDP setup with 2001:4860:4802:34::a#53 failed:
network unreachable
```

Explanation:

The WSL environment appears unable to reach IPv6 DNS servers.

The DNS trace continued over IPv4 and successfully obtained Google's DNS records.

This does not indicate a failure of the entire DNS resolution process.

## 9. Practical Learning Exercises

Execute these commands one by one.

```bash
# 1. Find IPv4 address
dig google.com A

# 2. Find IPv6 address
dig google.com AAAA

# 3. Find mail servers
dig google.com MX

# 4. Find authoritative name servers
dig google.com NS

# 5. Find TXT records
dig google.com TXT

# 6. Find Start of Authority
dig google.com SOA

# 7. Query DNS using Google DNS
dig @8.8.8.8 google.com

# 8. Trace DNS resolution
dig +trace google.com

# 9. Display short DNS response
dig google.com +short

# 10. Check DNS configuration
cat /etc/resolv.conf
```

## 10. Learning Roadmap

### Beginner
- What is DNS?
- DNS resolution
- IPv4 and IPv6
- dig
- nslookup

### Intermediate
- DNS record types
- DNS hierarchy
- Root DNS servers
- TLD DNS servers
- Authoritative DNS
- DNS caching and TTL

### Advanced
- DNSSEC
- Recursive DNS resolvers
- DNS forwarders
- Reverse DNS
- DNS troubleshooting
- DNS zone management

### Linux DNS Administration
- BIND9 installation
- DNS server configuration
- Forward and reverse zones
- DNS client configuration
- DNS query troubleshooting

## 11. Useful Linux Networking Commands

```bash
# Check network interfaces
ip addr

# Check routing table
ip route

# Test network connectivity
ping google.com

# Trace network route
traceroute google.com

# Check listening ports
ss -tulnp

# Test HTTP connectivity
curl -I https://www.google.com

# Inspect DNS traffic (install tcpdump if needed)
tcpdump -i any port 53
```

## 12. Project Conclusion

Through this practical exercise, I learned how DNS translates domain names into IP addresses and how DNS resolution works across the root, TLD, and authoritative DNS servers.

I also practiced Linux DNS utilities such as dig and nslookup, explored DNS record types, learned about DNSSEC, and investigated IPv6 connectivity warnings in WSL.

This project provides a foundation for further learning in Linux system administration, networking, DNS server administration, and network troubleshooting.

---

**Technologies Used:** Ubuntu Linux, WSL, BIND9 DNS utilities, DNS, IPv4, IPv6, DNSSEC.

**Project Type:** Linux Networking / DNS Practical Lab.