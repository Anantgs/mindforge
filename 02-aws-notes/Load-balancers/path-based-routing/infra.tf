terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  description = "AWS Region in which to create the lab"
  type        = string
  default     = "us-east-1"
}

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_ami" "amazon_linux" {
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

resource "aws_vpc" "path_routing" {
  cidr_block           = "10.10.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "path-routing-lab-vpc"
  }
}

resource "aws_internet_gateway" "path_routing" {
  vpc_id = aws_vpc.path_routing.id

  tags = {
    Name = "path-routing-lab-igw"
  }
}

resource "aws_subnet" "public" {
  count = 2

  vpc_id                  = aws_vpc.path_routing.id
  cidr_block              = "10.10.${count.index + 1}.0/24"
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "path-routing-public-${count.index + 1}"
    Tier = "public"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.path_routing.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.path_routing.id
  }

  tags = {
    Name = "path-routing-public-rt"
  }
}

resource "aws_route_table_association" "public" {
  count = length(aws_subnet.public)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "web" {
  name        = "path-routing-web-sg"
  description = "Allow HTTP access to the path-routing lab servers"
  vpc_id      = aws_vpc.path_routing.id

  ingress {
    description = "HTTP for direct browser testing; replace with ALB security group after creating the ALB"
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

  tags = {
    Name = "path-routing-web-sg"
  }
}

resource "aws_instance" "web" {
  count = 2

  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.public[count.index].id
  vpc_security_group_ids      = [aws_security_group.web.id]
  associate_public_ip_address = true

  user_data = <<-EOF
    #!/bin/bash
    dnf install -y httpd
    systemctl enable --now httpd

    TOKEN=$(curl -sS -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
    PRIVATE_IP=$(curl -sS -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/local-ipv4)

    cat > /var/www/html/index.html <<HTML
    <!doctype html>
    <html lang="en">
      <head><meta charset="utf-8"><title>http${count.index + 1}</title></head>
      <body style="font-family:Arial,sans-serif;margin:3rem">
        <h1>http${count.index + 1}</h1>
        <p>Private IP: <strong>$PRIVATE_IP</strong></p>
        <p>Subnet: ${aws_subnet.public[count.index].cidr_block}</p>
      </body>
    </html>
    HTML
  EOF

  tags = {
    Name    = "http${count.index + 1}"
    Service = "path-routing-lab"
  }
}

output "http_server_urls" {
  description = "Direct URLs for checking the two web pages before you add an ALB manually"
  value = {
    http1 = "http://${aws_instance.web[0].public_ip}"
    http2 = "http://${aws_instance.web[1].public_ip}"
  }
}

output "subnet_availability_zones" {
  description = "Availability Zones used by the two public subnets"
  value       = aws_subnet.public[*].availability_zone
}

