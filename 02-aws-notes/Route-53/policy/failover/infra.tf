terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Credentials are resolved through the standard AWS provider credential chain:
# the default AWS CLI profile, environment variables, or an IAM role.
provider "aws" {
  alias   = "primary"
  region  = "us-east-1"
}

provider "aws" {
  alias   = "secondary"
  region  = "ap-south-1"
}

data "aws_availability_zones" "primary" {
  provider = aws.primary
  state    = "available"
}

data "aws_availability_zones" "secondary" {
  provider = aws.secondary
  state    = "available"
}

data "aws_ami" "amazon_linux_primary" {
  provider    = aws.primary
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

data "aws_ami" "amazon_linux_secondary" {
  provider    = aws.secondary
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

# -----------------------------------------------------------------------------
# Primary region: us-east-1
# -----------------------------------------------------------------------------
resource "aws_vpc" "primary" {
  provider             = aws.primary
  cidr_block           = "10.10.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name   = "failover-primary-vpc"
    Region = "us-east-1"
    Role   = "primary"
  }
}

resource "aws_internet_gateway" "primary" {
  provider = aws.primary
  vpc_id   = aws_vpc.primary.id

  tags = { Name = "failover-primary-igw" }
}

resource "aws_subnet" "primary_public" {
  provider                = aws.primary
  vpc_id                  = aws_vpc.primary.id
  cidr_block              = "10.10.1.0/24"
  availability_zone       = data.aws_availability_zones.primary.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "failover-primary-public-subnet"
    Tier = "public"
  }
}

resource "aws_route_table" "primary_public" {
  provider = aws.primary
  vpc_id   = aws_vpc.primary.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.primary.id
  }

  tags = { Name = "failover-primary-public-rt" }
}

resource "aws_route_table_association" "primary_public" {
  provider       = aws.primary
  subnet_id      = aws_subnet.primary_public.id
  route_table_id = aws_route_table.primary_public.id
}

resource "aws_security_group" "primary_web" {
  provider    = aws.primary
  name        = "failover-primary-web-sg"
  description = "Allow HTTP access to the primary failover demo server"
  vpc_id      = aws_vpc.primary.id

  ingress {
    description = "HTTP for browser tests and Route 53 health checks"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "failover-primary-web-sg" }
}

resource "aws_instance" "web_primary" {
  provider                    = aws.primary
  ami                         = data.aws_ami.amazon_linux_primary.id
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.primary_public.id
  vpc_security_group_ids      = [aws_security_group.primary_web.id]
  associate_public_ip_address = true

  user_data = <<-EOF
    #!/bin/bash
    dnf install -y httpd
    systemctl enable --now httpd

    echo OK > /var/www/html/health
    cat > /var/www/html/index.html <<'HTML'
    <!doctype html>
    <html lang="en"><head><meta charset="utf-8"><title>Failover Demo - Primary</title></head>
    <body style="font-family:Arial,sans-serif;margin:3rem;background:#11998e;color:white">
      <h1>Route 53 Failover Demo</h1>
      <h2>PRIMARY SERVER - ACTIVE</h2>
      <p>Region: US East (N. Virginia)</p>
      <p>Region code: us-east-1</p>
      <p>This is the primary endpoint used while its Route 53 health check is healthy.</p>
    </body></html>
    HTML
  EOF

  tags = {
    Name   = "failover-demo-primary"
    Region = "us-east-1"
    Role   = "Primary"
    Demo   = "Route53-Failover"
  }
}

resource "aws_eip" "primary" {
  provider = aws.primary
  instance = aws_instance.web_primary.id
  domain   = "vpc"

  tags = { Name = "failover-demo-primary-eip" }
}

# -----------------------------------------------------------------------------
# Secondary region: ap-south-1
# -----------------------------------------------------------------------------
resource "aws_vpc" "secondary" {
  provider             = aws.secondary
  cidr_block           = "10.20.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name   = "failover-secondary-vpc"
    Region = "ap-south-1"
    Role   = "secondary"
  }
}

resource "aws_internet_gateway" "secondary" {
  provider = aws.secondary
  vpc_id   = aws_vpc.secondary.id

  tags = { Name = "failover-secondary-igw" }
}

resource "aws_subnet" "secondary_public" {
  provider                = aws.secondary
  vpc_id                  = aws_vpc.secondary.id
  cidr_block              = "10.20.1.0/24"
  availability_zone       = data.aws_availability_zones.secondary.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "failover-secondary-public-subnet"
    Tier = "public"
  }
}

resource "aws_route_table" "secondary_public" {
  provider = aws.secondary
  vpc_id   = aws_vpc.secondary.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.secondary.id
  }

  tags = { Name = "failover-secondary-public-rt" }
}

resource "aws_route_table_association" "secondary_public" {
  provider       = aws.secondary
  subnet_id      = aws_subnet.secondary_public.id
  route_table_id = aws_route_table.secondary_public.id
}

resource "aws_security_group" "secondary_web" {
  provider    = aws.secondary
  name        = "failover-secondary-web-sg"
  description = "Allow HTTP access to the secondary failover demo server"
  vpc_id      = aws_vpc.secondary.id

  ingress {
    description = "HTTP for browser tests and Route 53 health checks"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "failover-secondary-web-sg" }
}

resource "aws_instance" "web_secondary" {
  provider                    = aws.secondary
  ami                         = data.aws_ami.amazon_linux_secondary.id
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.secondary_public.id
  vpc_security_group_ids      = [aws_security_group.secondary_web.id]
  associate_public_ip_address = true

  user_data = <<-EOF
    #!/bin/bash
    dnf install -y httpd
    systemctl enable --now httpd

    echo OK > /var/www/html/health
    cat > /var/www/html/index.html <<'HTML'
    <!doctype html>
    <html lang="en"><head><meta charset="utf-8"><title>Failover Demo - Secondary</title></head>
    <body style="font-family:Arial,sans-serif;margin:3rem;background:#c0392b;color:white">
      <h1>Route 53 Failover Demo</h1>
      <h2>SECONDARY SERVER - FAILOVER ACTIVE</h2>
      <p>Region: Asia Pacific (Mumbai)</p>
      <p>Region code: ap-south-1</p>
      <p>This endpoint is returned when the primary Route 53 health check is unhealthy.</p>
    </body></html>
    HTML
  EOF

  tags = {
    Name   = "failover-demo-secondary"
    Region = "ap-south-1"
    Role   = "Secondary"
    Demo   = "Route53-Failover"
  }
}

resource "aws_eip" "secondary" {
  provider = aws.secondary
  instance = aws_instance.web_secondary.id
  domain   = "vpc"

  tags = { Name = "failover-demo-secondary-eip" }
}

# Route 53 hosted zones, health checks, and failover records are intentionally
# excluded. Create them manually using the IPs and /health endpoints below.
output "primary_public_ip" {
  value       = aws_eip.primary.public_ip
  description = "Primary endpoint IP for the Route 53 PRIMARY record"
}

output "secondary_public_ip" {
  value       = aws_eip.secondary.public_ip
  description = "Secondary endpoint IP for the Route 53 SECONDARY record"
}

output "primary_health_check_url" {
  value       = "http://${aws_eip.primary.public_ip}/health"
  description = "Use this URL when creating the primary Route 53 HTTP health check"
}

output "secondary_health_check_url" {
  value       = "http://${aws_eip.secondary.public_ip}/health"
  description = "Optional secondary Route 53 HTTP health check URL"
}

output "demo_instructions" {
  value = <<-EOT
    1. Confirm both servers directly:
       Primary:   http://${aws_eip.primary.public_ip}
       Secondary: http://${aws_eip.secondary.public_ip}

    2. Create a Route 53 HTTP health check manually:
       Endpoint: ${aws_eip.primary.public_ip}
       Path: /health
       Port: 80

    3. Create two Route 53 A records with the same name:
       PRIMARY record value:   ${aws_eip.primary.public_ip}
       SECONDARY record value: ${aws_eip.secondary.public_ip}
       Routing policy: Failover
  EOT
}
