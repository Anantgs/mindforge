# VPC manual web-server demo

This Terraform configuration creates in `us-east-1` by default:

- One VPC (`10.10.0.0/20`, 4,096 addresses)
- Two public subnets in separate Availability Zones
- Two private subnets in separate Availability Zones
- Two isolated database subnets in separate Availability Zones
- An Internet Gateway, dedicated public/private/database route tables, and no subnet associations with the default route table
- One NAT Gateway in `public_1`; both private subnets route internet-bound traffic through it
- Two Amazon Linux 2023 EC2 web servers: `http1` and `http2`

All six subnet definitions are in `variables.tf` under `variable "subnets"`. Add or change a subnet there (or override the map in a `.tfvars` file). The `az_index` values `0` and `1` place each matching pair in two separate AZs. The database route table intentionally has no default route, keeping its subnets isolated. The instances are deliberately in public subnets so you can demonstrate *manual* load balancing: open the two output URLs alternately in a browser and each page identifies its server. This configuration does not create an ALB.

## Deploy

Ensure your AWS credentials are configured, then run:

```powershell
terraform init
terraform plan
terraform apply
```

When apply completes, Terraform prints `http1_url` and `http2_url`. Wait one or two minutes for Apache to finish installing, then visit both URLs. Each browser page shows the server name plus its public and private IP addresses.

To enable SSH, create/select an EC2 Key Pair in `us-east-1`, download and protect its `.pem` file, then set its name in `terraform.tfvars`:

```hcl
key_name = "my-existing-key-pair"
```

Connect as `ec2-user`. Port 22 is open to all IPv4 addresses for this demo, but authentication still requires the configured key pair. Do not use this security-group rule for production.

## Remove resources

```powershell
terraform destroy
```

AWS charges may apply while the EC2 instances exist.
