variable "flask_secret_key" {
  type        = string
  sensitive   = true
  description = "Shared Flask session signing key; stored in Terraform state."
}

resource "aws_acm_certificate" "primary" {
  provider          = aws.primary
  domain_name       = local.application_fqdn
  validation_method = "DNS"
  lifecycle { create_before_destroy = true }
}
resource "aws_acm_certificate" "dr" {
  provider          = aws.dr
  domain_name       = local.application_fqdn
  validation_method = "DNS"
  lifecycle { create_before_destroy = true }
}
resource "aws_route53_record" "validation" {
  provider        = aws.primary
  for_each        = { for option in aws_acm_certificate.primary.domain_validation_options : option.domain_name => option }
  zone_id         = data.aws_route53_zone.public.zone_id
  name            = each.value.resource_record_name
  type            = each.value.resource_record_type
  records         = [each.value.resource_record_value]
  ttl             = 60
  allow_overwrite = true
}
resource "aws_acm_certificate_validation" "primary" {
  provider                = aws.primary
  certificate_arn         = aws_acm_certificate.primary.arn
  validation_record_fqdns = [for record in aws_route53_record.validation : record.fqdn]
}
resource "aws_acm_certificate_validation" "dr" {
  provider                = aws.dr
  certificate_arn         = aws_acm_certificate.dr.arn
  validation_record_fqdns = [for record in aws_route53_record.validation : record.fqdn]
}
module "primary_app" {
  source          = "./modules/region"
  providers       = { aws = aws.primary }
  name            = "commerce-east"
  vpc_id          = module.primary_vpc.vpc_id
  public_subnets  = module.primary_vpc.public_subnets
  private_subnets = module.primary_vpc.private_subnets
  db_sg_id        = aws_security_group.primary_db.id
  certificate_arn = aws_acm_certificate_validation.primary.certificate_arn
  instance_type   = var.instance_type
  repository      = var.application_repository
  database_url    = "postgresql+psycopg://commerce_admin:${urlencode(var.db_password)}@${aws_db_instance.primary.address}:5432/commerce?sslmode=require"
  secret_key      = var.flask_secret_key
  primary         = true
}
module "dr_app" {
  source          = "./modules/region"
  providers       = { aws = aws.dr }
  name            = "commerce-west"
  vpc_id          = module.dr_vpc.vpc_id
  public_subnets  = module.dr_vpc.public_subnets
  private_subnets = module.dr_vpc.private_subnets
  db_sg_id        = aws_security_group.dr_db.id
  certificate_arn = aws_acm_certificate_validation.dr.certificate_arn
  instance_type   = var.instance_type
  repository      = var.application_repository
  database_url    = "postgresql+psycopg://commerce_admin:${urlencode(var.db_password)}@${aws_db_instance.replica.address}:5432/commerce?sslmode=require"
  secret_key      = var.flask_secret_key
  primary         = false
}
# Manual cutover: this is intentionally a single record so a primary outage
# cannot route users to an unpromoted read replica automatically.
variable "route_to_dr" {
  type    = bool
  default = false
}
resource "aws_route53_record" "app" {
  provider = aws.primary
  zone_id  = data.aws_route53_zone.public.zone_id
  name     = local.application_fqdn
  type     = "A"
  alias {
    name                   = var.route_to_dr ? module.dr_app.alb_dns : module.primary_app.alb_dns
    zone_id                = var.route_to_dr ? module.dr_app.alb_zone : module.primary_app.alb_zone
    evaluate_target_health = true
  }
}
output "application_url" { value = "https://${local.application_fqdn}" }
output "primary_instances" { value = module.primary_app.instance_ids }
output "dr_instances" { value = module.dr_app.instance_ids }
