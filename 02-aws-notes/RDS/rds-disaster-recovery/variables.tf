variable "project_name" {
  type        = string
  description = "Prefix applied to resource names."
  default     = "commerce-dr"
}

variable "domain_name" {
  type        = string
  description = "Existing public Route 53 hosted-zone name."
  default     = "devoops.biz"
}

variable "application_subdomain" {
  type        = string
  description = "Subdomain served by the regional ALBs."
  default     = "shop"
}

variable "primary_region" {
  type    = string
  default = "us-east-1"
}

variable "dr_region" {
  type    = string
  default = "us-west-2"
}

variable "application_repository" {
  type    = string
  default = "https://github.com/Anantgs/commerse-rds-project.git"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "db_instance_class" {
  type    = string
  default = "db.t4g.micro"
}

locals {
  application_fqdn = "${var.application_subdomain}.${var.domain_name}"
  common_tags = {
    Project     = var.project_name
    ManagedBy   = "Terraform"
    Environment = "disaster-recovery-lab"
  }
}
