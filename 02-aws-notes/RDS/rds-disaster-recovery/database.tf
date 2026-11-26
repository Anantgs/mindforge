# The password is supplied at apply time and stored in Terraform state.
variable "db_password" {
  description = "Password for the commerce PostgreSQL login; use a protected state backend."
  type        = string
  sensitive   = true
}

resource "aws_security_group" "primary_db" {
  provider    = aws.primary
  name_prefix = "${var.project_name}-primary-db-"
  description = "PostgreSQL access from primary application instances"
  vpc_id      = module.primary_vpc.vpc_id
}

resource "aws_security_group" "dr_db" {
  provider    = aws.dr
  name_prefix = "${var.project_name}-dr-db-"
  description = "PostgreSQL access from DR application instances"
  vpc_id      = module.dr_vpc.vpc_id
}

resource "aws_db_subnet_group" "primary" {
  provider   = aws.primary
  name       = "${var.project_name}-primary-db"
  subnet_ids = module.primary_vpc.database_subnets
}

resource "aws_db_subnet_group" "dr" {
  provider   = aws.dr
  name       = "${var.project_name}-dr-db"
  subnet_ids = module.dr_vpc.database_subnets
}

resource "aws_db_instance" "primary" {
  provider                  = aws.primary
  identifier                = "${var.project_name}-primary"
  engine                    = "postgres"
  instance_class            = var.db_instance_class
  allocated_storage         = 20
  storage_encrypted         = true
  db_name                   = "commerce"
  username                  = "commerce_admin"
  password                  = var.db_password
  db_subnet_group_name      = aws_db_subnet_group.primary.name
  vpc_security_group_ids    = [aws_security_group.primary_db.id]
  multi_az                  = true
  publicly_accessible       = false
  backup_retention_period   = 7
  skip_final_snapshot       = false
  final_snapshot_identifier = "${var.project_name}-primary-final"
  deletion_protection       = true
}

resource "aws_db_instance" "replica" {
  provider                  = aws.dr
  identifier                = "${var.project_name}-replica"
  replicate_source_db       = aws_db_instance.primary.arn
  instance_class            = var.db_instance_class
  db_subnet_group_name      = aws_db_subnet_group.dr.name
  vpc_security_group_ids    = [aws_security_group.dr_db.id]
  kms_key_id                = aws_kms_key.dr_rds.arn
  publicly_accessible       = false
  skip_final_snapshot       = false
  final_snapshot_identifier = "${var.project_name}-replica-final"
  deletion_protection       = true
}

resource "aws_kms_key" "dr_rds" {
  provider                = aws.dr
  description             = "Cross-region RDS replica encryption"
  deletion_window_in_days = 30
}

output "primary_database_endpoint" {
  value = aws_db_instance.primary.address
}

output "dr_replica_endpoint" {
  value = aws_db_instance.replica.address
}
