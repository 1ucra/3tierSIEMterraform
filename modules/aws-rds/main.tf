# 8 Creating DB subnet group for RDS Instances


resource "aws_db_subnet_group" "db_subnet_group" {
  name       = var.sg-name
  subnet_ids = [data.aws_subnet.db-subnet1.id, data.aws_subnet.db-subnet2.id]
}

# Creating Aurora RDS Cluster, username and password used only for practice, otherwise follow DevOps best practices to keep it secret
resource "aws_rds_cluster" "aurora_cluster" {
  cluster_identifier      = "aurora-cluster"
  engine                  = "aurora-mysql"
  engine_version          = "8.0.mysql_aurora.3.04.2"
  engine_mode = "provisioned"
  master_username         = data.aws_ssm_parameter.db_id.value
  master_password         = data.aws_ssm_parameter.db_pw.value
  storage_encrypted  = true
  allow_major_version_upgrade = false
  backup_retention_period = 3
  preferred_backup_window = "19:00-21:00" #4시~6시
  skip_final_snapshot     = true
  database_name           = var.db-name
  port                    = 3306
  db_subnet_group_name    = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids  = [data.aws_security_group.db-sg.id]
  serverlessv2_scaling_configuration {
    max_capacity = 4.0
    min_capacity = 1.0
  }
  tags = {
    Name = var.rds-name
  }
}

# Creating RDS Cluster instance
resource "aws_rds_cluster_instance" "primary_instance" {
  cluster_identifier = aws_rds_cluster.aurora_cluster.id
  identifier         = "primary-instance"
  instance_class     = "db.serverless"
  engine             = aws_rds_cluster.aurora_cluster.engine
  engine_version     = aws_rds_cluster.aurora_cluster.engine_version
}

# Creating RDS Read Replica Instance
resource "aws_rds_cluster_instance" "read_replica_instance" {
  count              = 1
  cluster_identifier = aws_rds_cluster.aurora_cluster.id
  identifier         = "read-replica-instance-${count.index}"
  instance_class     = "db.serverless"
  engine             = aws_rds_cluster.aurora_cluster.engine

  depends_on = [aws_rds_cluster_instance.primary_instance]
}
