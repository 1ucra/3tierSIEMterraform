
resource "aws_elasticache_serverless_cache" "redis-cluster" {
  engine = "redis"
  name   = "redis"
  cache_usage_limits {
    data_storage {
      minimum = 1
      maximum = 2
      unit    = "GB"
    }
    ecpu_per_second {
      minimum = 1000
      maximum = 2000
    }
  }
  description              = "aurora db caching"
  major_engine_version     = "7"
  security_group_ids       = [var.redis_securityGroup_id]
  subnet_ids               = [data.aws_subnet.db-subnet1.id, data.aws_subnet.db-subnet2.id]
  
  tags = {
    createDate = "${formatdate("YYYYMMDD", timestamp())}"
    Name = "aws_elasticache_serverless_cache/redis-cluster"
    owner = "ktd-admin"
  }

}



resource "aws_ssm_parameter" "redis-endpoint" {
  name  = "/config/system/redis-cluster-endpoint"
  type  = "String"
  value = aws_elasticache_serverless_cache.redis-cluster.endpoint[0].address
  depends_on = [ aws_elasticache_serverless_cache.redis-cluster ]

  tags = {
    createDate = "${formatdate("YYYYMMDD", timestamp())}"
    Name = "aws_ssm_parameter/redis-endpoint"
    owner = "ktd-admin"
  }
}