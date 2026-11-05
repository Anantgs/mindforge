The key differences between CNAME and Alias records in Amazon Route 53 are crucial for effective DNS configurations.

Here's a breakdown:

*   **CNAME Records**
    *   **Purpose**: CNAME (Canonical Name) records are used to **map one hostname to another hostname**. For instance, you can map `app.example.com` to an Elastic Load Balancer (ELB) hostname like `lb1-5432.us-east-1.elb.amazonaws.com`. This simplifies access for users by allowing them to use a custom, user-friendly domain to reach an AWS resource.
    *   **Limitations**: An important detail about CNAME records is that they **cannot be used for root domains**. This means you cannot create a CNAME record to map `example.com` directly to `api.example.com`. They are generally restricted to subdomains.

*   **Alias Records**
    *   **Purpose**: Alias records are used to **point a hostname (like `api.example.com`) directly to an AWS resource** (such as `api-1.example.com`). They integrate seamlessly with various AWS services, including S3 static websites, Elastic Load Balancers, CloudFront distributions, API Gateway, Elastic Beanstalk, VPC interface endpoints, Global Accelerator, and even other Route 53 records within the same hosted zone.
    *   **Key Benefits**:
        *   **Cost**: Alias records are **free of charge** when used with AWS resources.
        *   **Health Checks**: They come with **built-in health checks** to ensure availability.
        *   **Root Domain Support**: Unlike CNAME records, Alias records **can be used for both root domains (e.g., `example.com`) and non-root domains (e.g., `www.example.com`)**. This flexibility makes them a powerful tool.
        *   **Type**: Alias records are always of **type A for IPv4 or quad A for IPv6**.
        *   **TTL**: You **cannot set a TTL (Time To Live)** for Alias records because they dynamically inherit the TTL from the underlying AWS resource they point to.

In summary, while both record types can simplify access to AWS resources, **CNAME records point one hostname to another and cannot be used for root domains**, whereas **Alias records point directly to AWS resources, are free, include health checks, and crucially, can be used for both root and non-root domains**.


* what do you mean by root domain?

In the context of DNS configurations within Amazon Route 53, a **root domain** refers to the primary domain name without any subdomains.

For example:
*   **`example.com`** is considered a root domain.
*   In contrast, **`app.example.com`** or **`www.example.com`** are considered non-root domains or subdomains because they have an additional label (`app` or `www`) before the main domain name.

The distinction between root and non-root domains is particularly important when choosing between CNAME and Alias records:
*   **CNAME records cannot be used for root domains**. This means you cannot map `example.com` directly to another hostname using a CNAME record.
*   **Alias records, however, can be used for both root domains** (e.g., `example.com`) and non-root domains (e.g., `www.example.com`). This flexibility allows Alias records to point root domains to AWS resources like an S3 bucket or a load balancer.


NOT ALLOWED
```
example.com → CNAME → d123.cloudfront.net

```


ALLOWED
```
example.com → ALIAS → d123.cloudfront.net

```