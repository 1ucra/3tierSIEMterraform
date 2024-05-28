resource "aws_ssm_parameter" "db_id" {
  name  = "/config/account/admin/ID"
  type  = "SecureString"
  value = var.db_user_id
  overwrite   = true
  description = "input db admin ID"
}

resource "aws_ssm_parameter" "db_pwd" {
  name  = "/config/account/admin/PWD"
  type  = "SecureString"
  value = var.db_user_pwd
  overwrite   = true
  description = "input db admin PWD"
}

# 8 Creating DB subnet group for RDS Instances
resource "aws_db_subnet_group" "db_subnet_group" {
  name       = var.db_securityGroup_name
  subnet_ids = [data.aws_subnet.db_subnet1.id, data.aws_subnet.db_subnet2.id]
}

# Creating Aurora RDS Cluster, username and password used only for practice, otherwise follow DevOps best practices to keep it secret

locals {
  snapshot_time = "aurora-cluster-final-${formatdate("YYYYMMDD-HHmm", timestamp())}"
}

resource "aws_rds_cluster" "aurora-cluster" {
  cluster_identifier      = "aurora-cluster"
  engine                  = "aurora-mysql"
  engine_version          = "8.0.mysql_aurora.3.04.2"
  engine_mode = "provisioned"
  master_username         = aws_ssm_parameter.db_id.value
  master_password         = aws_ssm_parameter.db_pwd.value
  storage_encrypted  = true
  allow_major_version_upgrade = false
  backup_retention_period = 3
  preferred_backup_window = "19:00-21:00" #4시~6시
  skip_final_snapshot     = false
  final_snapshot_identifier = local.snapshot_time
  database_name           = var.db_name
  port                    = 3306
  db_subnet_group_name    = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids  = [data.aws_security_group.db-sg.id]
  serverlessv2_scaling_configuration {
    max_capacity = 2.0
    min_capacity = 1.0
  }
  tags = {
    Name = var.rds_name
  }
}

# Creating RDS Cluster instance
resource "aws_rds_cluster_instance" "primary-instance" {
  cluster_identifier = aws_rds_cluster.aurora-cluster.id
  identifier         = "primary-instance"
  instance_class     = "db.serverless"
  engine             = aws_rds_cluster.aurora-cluster.engine
  engine_version     = aws_rds_cluster.aurora-cluster.engine_version
}

# Creating RDS Read Replica Instance
resource "aws_rds_cluster_instance" "read_replica_instance" {
  count              = 1
  cluster_identifier = aws_rds_cluster.aurora-cluster.id
  identifier         = "read-replica-instance-${count.index}"
  instance_class     = "db.serverless"
  engine             = aws_rds_cluster.aurora-cluster.engine

  depends_on = [aws_rds_cluster_instance.primary-instance]
}

resource "aws_ssm_parameter" "db-cluster-endpoint" {
  name  = "/config/system/db-cluster-endpoint"
  type  = "SecureString"
  value = aws_rds_cluster.aurora-cluster.endpoint
  overwrite   = true
  description = "db-cluster-endpoint"
}