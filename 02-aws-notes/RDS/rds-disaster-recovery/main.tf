data "aws_route53_zone" "public" {
  provider     = aws.primary
  name         = var.domain_name
  private_zone = false
}

data "aws_availability_zones" "primary" {
  provider = aws.primary
  state    = "available"
}

data "aws_availability_zones" "dr" {
  provider = aws.dr
  state    = "available"
}

module "primary_vpc" {
  source               = "https://github.com/terraform-aws-modules/terraform-aws-vpc/archive/refs/tags/v5.21.0.zip//terraform-aws-vpc-5.21.0"
  providers            = { aws = aws.primary }
  name                 = "${var.project_name}-primary"
  cidr                 = "10.10.0.0/16"
  azs                  = slice(data.aws_availability_zones.primary.names, 0, 2)
  public_subnets       = ["10.10.0.0/24", "10.10.1.0/24"]
  private_subnets      = ["10.10.10.0/24", "10.10.11.0/24"]
  database_subnets     = ["10.10.20.0/24", "10.10.21.0/24"]
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
  enable_dns_support   = true
}

module "dr_vpc" {
  source               = "https://github.com/terraform-aws-modules/terraform-aws-vpc/archive/refs/tags/v5.21.0.zip//terraform-aws-vpc-5.21.0"
  providers            = { aws = aws.dr }
  name                 = "${var.project_name}-dr"
  cidr                 = "10.20.0.0/16"
  azs                  = slice(data.aws_availability_zones.dr.names, 0, 2)
  public_subnets       = ["10.20.0.0/24", "10.20.1.0/24"]
  private_subnets      = ["10.20.10.0/24", "10.20.11.0/24"]
  database_subnets     = ["10.20.20.0/24", "10.20.21.0/24"]
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
  enable_dns_support   = true
}
