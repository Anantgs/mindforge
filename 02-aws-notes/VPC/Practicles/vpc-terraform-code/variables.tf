variable "aws_region" {
  description = "AWS Region in which to create the demonstration environment."
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Prefix used for resource names and tags."
  type        = string
  default     = "manual-lb-demo"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC. A /20 contains 4,096 IP addresses."
  type        = string
  default     = "10.10.0.0/20"
}

variable "subnets" {
  description = "Subnets to create. az_index selects a distinct Availability Zone from the region's available AZ list."
  type = map(object({
    cidr     = string
    az_index = number
    tier     = string
  }))

  default = {
    public_1 = {
      cidr     = "10.10.0.0/24"
      az_index = 0
      tier     = "public"
    }
    public_2 = {
      cidr     = "10.10.1.0/24"
      az_index = 1
      tier     = "public"
    }
    private_1 = {
      cidr     = "10.10.2.0/24"
      az_index = 0
      tier     = "private"
    }
    private_2 = {
      cidr     = "10.10.3.0/24"
      az_index = 1
      tier     = "private"
    }
    database_1 = {
      cidr     = "10.10.4.0/24"
      az_index = 0
      tier     = "database"
    }
    database_2 = {
      cidr     = "10.10.5.0/24"
      az_index = 1
      tier     = "database"
    }
  }

  validation {
    condition     = alltrue([for subnet in values(var.subnets) : contains(["public", "private", "database"], subnet.tier)])
    error_message = "Each subnet tier must be public, private, or database."
  }
}

variable "instance_type" {
  description = "EC2 instance type for the two web servers."
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Name of an existing EC2 Key Pair for SSH access. Leave null to launch instances without an SSH key pair."
  type        = string
  default     = null
  nullable    = true
}

