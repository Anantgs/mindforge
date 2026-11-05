variable "instance_profile_name" {
  type    = string
  default = "ssm-instance-profile"
}

variable "iam_policy_name" {
  type    = string
  default = "ssm-policy"
}

variable "role_name" {
  type    = string
  default = "ssm-role"
}
