resource "aws_ssm_parameter" "db-id" {
  name  = "/config/account/admin/ID"
  type  = "SecureString"
  value = var.db_user_id
  overwrite   = true
  description = "input db admin ID"

  tags = {
    createDate = "${formatdate("YYYYMMDD", timestamp())}"
    Name = "aws_ssm_parameter/db-id"
    owner = "ktd-admin"
  }
}

resource "aws_ssm_parameter" "db-pwd" {
  name  = "/config/account/admin/PWD"
  type  = "SecureString"
  value = var.db_user_pwd
  overwrite   = true
  description = "input db admin PWD"

  tags = {
    createDate = "${formatdate("YYYYMMDD", timestamp())}"
    Name = "aws_ssm_parameter/db-pwd"
    owner = "ktd-admin"
  }
}

# 8 Creating DB subnet group for RDS Instances
resource "aws_db_subnet_group" "db-subnet-group" {
  name       = var.db_securityGroup_name
  subnet_ids = [data.aws_subnet.db-subnet1.id, data.aws_subnet.db-subnet2.id]

  tags = {
    createDate = "${formatdate("YYYYMMDD", timestamp())}"
    Name = "aws_db_subnet_group/db-subnet-group"
    owner = "ktd-admin"
  }
}

# Creating Aurora RDS Cluster, username and password used only for practice, otherwise follow DevOps best practices to keep it secret

resource "aws_rds_cluster" "aurora-cluster" {
  cluster_identifier      = "aurora-cluster"
  engine                  = "aurora-mysql"
  engine_version          = "8.0.mysql_aurora.3.04.2"
  engine_mode = "provisioned"
  master_username         = aws_ssm_parameter.db-id.value
  master_password         = aws_ssm_parameter.db-pwd.value
  storage_encrypted  = true
  allow_major_version_upgrade = false
  backup_retention_period = 3
  preferred_backup_window = "18:00-20:00" #중국 4시~6시
  skip_final_snapshot     = true
  final_snapshot_identifier = "aurora-cluster-final-${formatdate("YYYYMMDD-HHmm", timestamp())}"
  database_name           = var.db_name
  port                    = 3306
  db_subnet_group_name    = aws_db_subnet_group.db-subnet-group.name
  vpc_security_group_ids  = [data.aws_security_group.db-sg.id]
  serverlessv2_scaling_configuration {
    max_capacity = 2.0
    min_capacity = 1.0
  }
  
  tags = {
    createDate = "${formatdate("YYYYMMDD", timestamp())}"
    Name = "aws_rds_cluster/aurora-cluster"
    owner = "ktd-admin"
  }
}

# Creating RDS Cluster instance
resource "aws_rds_cluster_instance" "primary-instance" {
  cluster_identifier = aws_rds_cluster.aurora-cluster.id
  identifier         = "primary-instance"
  instance_class     = "db.serverless"
  engine             = aws_rds_cluster.aurora-cluster.engine
  engine_version     = aws_rds_cluster.aurora-cluster.engine_version

  tags = {
    createDate = "${formatdate("YYYYMMDD", timestamp())}"
    Name = "aws_rds_cluster_instance/primary-instance"
    owner = "ktd-admin"
  }
}

# Creating RDS Read Replica Instance
resource "aws_rds_cluster_instance" "read-replica-instance" {
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

  tags = {
    createDate = "${formatdate("YYYYMMDD", timestamp())}"
    Name = "aws_ssm_parameter/db-cluster-endpoint"
    owner = "ktd-admin"
  }
}
