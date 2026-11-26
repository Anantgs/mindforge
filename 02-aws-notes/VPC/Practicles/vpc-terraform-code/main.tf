data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_ssm_parameter" "amazon_linux_2023_ami" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

locals {
  public_subnets   = { for name, subnet in var.subnets : name => subnet if subnet.tier == "public" }
  private_subnets  = { for name, subnet in var.subnets : name => subnet if subnet.tier == "private" }
  database_subnets = { for name, subnet in var.subnets : name => subnet if subnet.tier == "database" }

  common_tags = {
    Project   = var.project_name
    ManagedBy = "Terraform"
  }
}

resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(local.common_tags, { Name = "${var.project_name}-vpc" })
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(local.common_tags, { Name = "${var.project_name}-igw" })
}

resource "aws_subnet" "public" {
  for_each = local.public_subnets

  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value.cidr
  availability_zone       = data.aws_availability_zones.available.names[each.value.az_index]
  map_public_ip_on_launch = true

  tags = merge(local.common_tags, { Name = "${var.project_name}-${each.key}" })
}

resource "aws_subnet" "private" {
  for_each = local.private_subnets

  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value.cidr
  availability_zone = data.aws_availability_zones.available.names[each.value.az_index]

  tags = merge(local.common_tags, { Name = "${var.project_name}-${each.key}" })
}

resource "aws_subnet" "database" {
  for_each = local.database_subnets

  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value.cidr
  availability_zone = data.aws_availability_zones.available.names[each.value.az_index]

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-${each.key}"
    Tier = "database"
  })
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = merge(local.common_tags, { Name = "${var.project_name}-public-rt" })
}

resource "aws_eip" "nat" {
  domain = "vpc"

  tags = merge(local.common_tags, { Name = "${var.project_name}-nat-eip" })
}

resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public["public_1"].id

  depends_on = [aws_internet_gateway.this]

  tags = merge(local.common_tags, { Name = "${var.project_name}-nat-gateway" })
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this.id
  }

  tags = merge(local.common_tags, { Name = "${var.project_name}-private-rt" })
}

resource "aws_route_table" "database" {
  vpc_id = aws_vpc.this.id

  # Deliberately no default route: database subnets remain isolated.
  tags = merge(local.common_tags, { Name = "${var.project_name}-database-rt" })
}

resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  for_each = aws_subnet.private

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "database" {
  for_each = aws_subnet.database

  subnet_id      = each.value.id
  route_table_id = aws_route_table.database.id
}

resource "aws_security_group" "web" {
  name_prefix = "${var.project_name}-web-"
  description = "Allow HTTP for the manual load-balancing demo"
  vpc_id      = aws_vpc.this.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH (demo access from anywhere)"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, { Name = "${var.project_name}-web-sg" })
}

resource "aws_instance" "web" {
  for_each = aws_subnet.public

  ami                    = data.aws_ssm_parameter.amazon_linux_2023_ami.value
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = each.value.id
  vpc_security_group_ids = [aws_security_group.web.id]
  user_data_replace_on_change = true

  user_data = <<-EOF
    #!/bin/bash
    dnf -y update
    dnf -y install httpd
    TOKEN=$(curl -sS -X PUT -H "X-aws-ec2-metadata-token-ttl-seconds: 21600" http://169.254.169.254/latest/api/token)
    METADATA_URL="http://169.254.169.254/latest/meta-data"
    PRIVATE_IP=$(curl -sS -H "X-aws-ec2-metadata-token: $TOKEN" "$METADATA_URL/local-ipv4")
    PUBLIC_IP=$(curl -sS -H "X-aws-ec2-metadata-token: $TOKEN" "$METADATA_URL/public-ipv4")

    cat > /var/www/html/index.html <<HTML
    <!doctype html>
    <html><head><title>${each.key == "public_1" ? "http1" : "http2"}</title></head>
    <body style="font-family:Arial;text-align:center;padding-top:80px">
      <h1>${each.key == "public_1" ? "http1" : "http2"}</h1>
      <p>Manual load-balancing demonstration</p>
      <p><strong>Public IP:</strong> $PUBLIC_IP</p>
      <p><strong>Private IP:</strong> $PRIVATE_IP</p>
    </body></html>
    HTML
    systemctl enable --now httpd
  EOF

  tags = merge(local.common_tags, {
    Name   = "${var.project_name}-${each.key == "public_1" ? "http1" : "http2"}"
    Server = each.key == "public_1" ? "http1" : "http2"
  })
}
